#include <string.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/pgmspace.h>

#include "tvtext.h"

#ifdef TVTEXT_FONT
#include TVTEXT_FONT
#elif TVTEXT_CHARACTER_WIDTH == 6
#include "font_6.h"
#elif TVTEXT_CHARACTER_WIDTH == 8
#include "font_8.h"
#endif

extern void tvtext_driver_init(void);

void tvtext_init(void) {
	// Initialise the assembly driver.
	tvtext_driver_init();

	// Set up I/O pins.
	TVTEXT_PICTURE_DDR |= _BV(TVTEXT_PICTURE_BIT);
	TVTEXT_SYNC_DDR |= _BV(TVTEXT_SYNC_BIT);

	// Set up timer.
	TCCR1B |= (0b001 << CS10); // Run at native clock speed, no prescaling.
	TIMSK1 |= _BV(OCIE1A);     // Interrupt on match A.
	TCCR1B |= _BV(WGM12);      // Mode 4 (TOP=OCR1A, CTC).

	// Set up default flags.
	tvtext_flags = _BV(TVTEXT_VISIBLE) | _BV(TVTEXT_AUTO_SCROLL) | _BV(TVTEXT_CURSOR_ENABLED);

	// Set the default cleared and cursor characters.
	tvtext_cleared = ' ';
	tvtext_cursor = '_';

	// Invert the cursor every 16 frames.
	tvtext_cursor_flash_period = 16;

	// Reset the viewport.
	tvtext_reset_viewport_cursor_home();

	// Reset the offset.
	tvtext_offset_x = TVTEXT_OFFSET_X_DEFAULT;
	tvtext_offset_y = 0;

	// Enable interrupts.
	sei();
}

uint8_t command_queue[9];
uint8_t command_queue_length;
uint8_t command_queue_command;

void tvtext_putc(char c) {
	// Are we handling a command that relies on queued data?
	if (command_queue_length > 0) {
		--command_queue_length;
		command_queue[command_queue_length] = c;
		if (command_queue_length == 0) {
			// We've received all the data for the queued command.
			switch (command_queue_command) {
				case 23:
					switch (command_queue[8]) {
						case 1:
							if (command_queue[7]) {
								tvtext_flags |= _BV(TVTEXT_CURSOR_ENABLED);
								tvtext_cursor_reset_flash();
							} else {
								tvtext_flags &= ~_BV(TVTEXT_CURSOR_ENABLED);
							}
							break;
						case 7:
							{
								// Preserve the old viewport coordinates.
								int8_t
									l = tvtext_viewport_left,
									b = tvtext_viewport_bottom,
									t = tvtext_viewport_top,
									r = tvtext_viewport_right;

								if (command_queue[7]) {
									// We're scrolling the entire screen, so expand the current viewport to fill it.
									tvtext_viewport_left = tvtext_viewport_top = 0;
									tvtext_viewport_right = TVTEXT_BUFFER_WIDTH - 1;
									tvtext_viewport_bottom = TVTEXT_BUFFER_HEIGHT - 1;
									
								}
								switch (command_queue[6]) {
									case 0:
										tvtext_scroll_right();
										break;
									case 1:
										tvtext_scroll_left();
										break;
									case 2:
										tvtext_scroll_down();
										break;
									case 3:
										tvtext_scroll_up();
										break;
								}
								if (command_queue[7]) {
									// We've just scrolled the entire screen, so restore the old viewport values.
									tvtext_viewport_left = l;
									tvtext_viewport_bottom = b;
									tvtext_viewport_top = t;
									tvtext_viewport_right = r;
								}
							}
							break;
					}
					break;
				case 27:
					tvtext_buffer[tvtext_cursor_row * TVTEXT_BUFFER_WIDTH + tvtext_cursor_column] = command_queue[0];
					tvtext_cursor_right();
					break;
				case 28:
					tvtext_set_viewport(command_queue[3], command_queue[2], command_queue[1], command_queue[0]);
					break;
				case 31:
					tvtext_cursor_move(command_queue[1], command_queue[0]);
					break;
			}
		}
	} else if (c < 32) {
		switch (c) {
			case 0:
				break;
			case 4:
				tvtext_flags |= _BV(TVTEXT_AUTO_SCROLL);
				break;
			case 5:
				tvtext_flags &= ~_BV(TVTEXT_AUTO_SCROLL);
				break;
			case 8:
				tvtext_cursor_left();
				break;
			case 9:
				tvtext_cursor_right();
				break;
			case 10:
				tvtext_cursor_down();
				break;
			case 11:
				tvtext_cursor_up();
				break;
			case 12:
				tvtext_clear();
				break;
			case 13:
				tvtext_cursor_column = tvtext_viewport_left;
				break;
			case 23:
				command_queue_command = c;
				command_queue_length = 9;
				break;
			case 26:
				tvtext_reset_viewport_cursor_home();
				break;
			case 27:
				command_queue_command = c;
				command_queue_length = 1;
				break;
			case 28:
				command_queue_command = c;
				command_queue_length = 4;
				break;
			case 30:
				tvtext_cursor_home();
				break;
			case 31:
				command_queue_command = c;
				command_queue_length = 2;
				break;
		}
	} else if (c == 127) {
		tvtext_cursor_left();
		tvtext_buffer[tvtext_cursor_row * TVTEXT_BUFFER_WIDTH + tvtext_cursor_column] = tvtext_cleared;
	} else {
		tvtext_buffer[tvtext_cursor_row * TVTEXT_BUFFER_WIDTH + tvtext_cursor_column] = c;
		tvtext_cursor_right();
	}
}

void tvtext_puts(const char* s) {
	char c;
	while ((c = *(s++))) {
		tvtext_putc(c);
	}
}

void tvtext_puts_P(const char* s) {
	char c;
	while ((c = pgm_read_byte(s++))) {
		tvtext_putc(c);
	}
}

void tvtext_cursor_right(void) { // VDU 8
	if (++tvtext_cursor_column > tvtext_viewport_right) {
		tvtext_cursor_column = tvtext_viewport_left;
		tvtext_cursor_down();
	}
	tvtext_cursor_reset_flash();
}

void tvtext_cursor_down(void) { // VDU 9
	if (++tvtext_cursor_row > tvtext_viewport_bottom) {
		if (bit_is_set(tvtext_flags, TVTEXT_AUTO_SCROLL)) {
			tvtext_scroll_up();
			tvtext_cursor_row = tvtext_viewport_bottom;
		} else {
			// Just put cursor back on the top line.
			tvtext_cursor_row = tvtext_viewport_top;
		}
	}
	tvtext_cursor_reset_flash();
}

void tvtext_cursor_left(void) { // VDU 10
	if (--tvtext_cursor_column < tvtext_viewport_left) {
		tvtext_cursor_column = tvtext_viewport_right;
		tvtext_cursor_up();
	}
	tvtext_cursor_reset_flash();
}

void tvtext_cursor_up(void) { // VDU 11
	if (--tvtext_cursor_row < tvtext_viewport_top) {
		if (bit_is_set(tvtext_flags, TVTEXT_AUTO_SCROLL)) {
			tvtext_scroll_down();
			tvtext_cursor_row = tvtext_viewport_top;
		} else {
			// Just put the cursor back on the bottom line.
			tvtext_cursor_row = tvtext_viewport_bottom;
		}
	}
	tvtext_cursor_reset_flash();
}

void tvtext_clear(void) { // VDU 12
	char* p = tvtext_buffer + tvtext_viewport_top * TVTEXT_BUFFER_WIDTH + tvtext_viewport_left;
	for (uint8_t r = tvtext_viewport_top; r <= tvtext_viewport_bottom; ++r, p += TVTEXT_BUFFER_WIDTH) {
		memset(p, tvtext_cleared, tvtext_viewport_right - tvtext_viewport_left + 1);
	}
	tvtext_cursor_home();	
}

void tvtext_scroll_right(void) { // VDU 23,7,0,0,0;0;0;
	char* p = tvtext_buffer + tvtext_viewport_top * TVTEXT_BUFFER_WIDTH + tvtext_viewport_left;
	for (uint8_t r = tvtext_viewport_top; r <= tvtext_viewport_bottom; ++r, p += TVTEXT_BUFFER_WIDTH) {
		memmove(p + 1, p, tvtext_viewport_right - tvtext_viewport_left);
		p[0] = tvtext_cleared;
	}
}

void tvtext_scroll_left(void) { // VDU 23,7,0,1,0;0;0;
	char* p = tvtext_buffer + tvtext_viewport_top * TVTEXT_BUFFER_WIDTH + tvtext_viewport_left;
	for (uint8_t r = tvtext_viewport_top; r <= tvtext_viewport_bottom; ++r, p += TVTEXT_BUFFER_WIDTH) {
		memmove(p, p + 1, tvtext_viewport_right - tvtext_viewport_left);
		p[tvtext_viewport_right - tvtext_viewport_left] = tvtext_cleared;
	}
}

void tvtext_scroll_down(void) { // VDU 23,7,0,2,0;0;0;
	char* p = tvtext_buffer + tvtext_viewport_bottom * TVTEXT_BUFFER_WIDTH + tvtext_viewport_left;
	for (uint8_t r = tvtext_viewport_top; r < tvtext_viewport_bottom; ++r, p -= TVTEXT_BUFFER_WIDTH) {
		memmove(p, p - TVTEXT_BUFFER_WIDTH, tvtext_viewport_right - tvtext_viewport_left + 1);
	}
	// Clear top line.
	memset(p, tvtext_cleared, tvtext_viewport_right - tvtext_viewport_left + 1);
}

void tvtext_scroll_up(void) { // VDU 23,7,0,3,0;0;0;
	char* p = tvtext_buffer + tvtext_viewport_top * TVTEXT_BUFFER_WIDTH + tvtext_viewport_left;
	for (uint8_t r = tvtext_viewport_top; r < tvtext_viewport_bottom; ++r, p += TVTEXT_BUFFER_WIDTH) {
		memmove(p, p + TVTEXT_BUFFER_WIDTH, tvtext_viewport_right - tvtext_viewport_left + 1);
	}
	// Clear bottom line.
	memset(p, tvtext_cleared, tvtext_viewport_right - tvtext_viewport_left + 1);
}

void tvtext_reset_viewport_cursor_home(void) { // VDU 26
	tvtext_cursor_row = tvtext_cursor_column = tvtext_viewport_top = tvtext_viewport_left = 0;
	tvtext_viewport_right = TVTEXT_BUFFER_WIDTH - 1;
	tvtext_viewport_bottom = TVTEXT_BUFFER_HEIGHT - 1;
	tvtext_cursor_reset_flash();
}

void tvtext_set_viewport(int8_t left, int8_t bottom, int8_t right, int8_t top) { // VDU 28
	// Clip viewport coordinates to fixed limitations.
	if (left < 0) { left = 0; } else if (left > TVTEXT_BUFFER_WIDTH - 1) { left = TVTEXT_BUFFER_WIDTH - 1; }
	if (bottom < 0) { bottom = 0; } else if (bottom > TVTEXT_BUFFER_HEIGHT - 1) { bottom = TVTEXT_BUFFER_HEIGHT - 1; }
	if (right < 0) { right = 0; } else if (right > TVTEXT_BUFFER_WIDTH - 1) { right = TVTEXT_BUFFER_WIDTH - 1; }
	if (top < 0) { top = 0; } else if (top > TVTEXT_BUFFER_HEIGHT - 1) { top = TVTEXT_BUFFER_HEIGHT - 1; }
	// Sort coordinates.
	if (left > right) {
		int8_t s = left;
		left = right;
		right = s;
	}
	if (top > bottom) {
		int8_t s = top;
		top = bottom;
		bottom = s;
	}
	// Store new viewport coordinates.
	tvtext_viewport_left = left;
	tvtext_viewport_bottom = bottom;
	tvtext_viewport_right = right;
	tvtext_viewport_top = top;
	// Clip the cursor to the new viewport.
	if (tvtext_cursor_column < left || tvtext_cursor_column > right || tvtext_cursor_row < top || tvtext_cursor_row > bottom) {
		tvtext_cursor_home();
	}
	tvtext_cursor_reset_flash();
}



void tvtext_cursor_home(void) { // VDU 30
	tvtext_cursor_column = tvtext_viewport_left;
	tvtext_cursor_row = tvtext_viewport_top;
	tvtext_cursor_reset_flash();
}

void tvtext_cursor_move(uint8_t column, uint8_t row) { // VDU 31
	if (column >= tvtext_viewport_left && column <= tvtext_viewport_right) {
		tvtext_cursor_column = column;
	}
	if (row >= tvtext_viewport_top && row <= tvtext_viewport_bottom) {
		tvtext_cursor_row = row;
	}
	tvtext_cursor_reset_flash();
}

void tvtext_cursor_reset_flash(void) {
	tvtext_cursor_flash_timer = tvtext_cursor_flash_period;
	tvtext_flags |= _BV(TVTEXT_CURSOR_VISIBLE);
}

void tvtext_wait_vsync(void) {
	int16_t frame_counter = tvtext_frame_counter;
	while (tvtext_frame_counter == frame_counter);
}

uint8_t tvtext_get_font_row(char c, uint8_t row) {
	return pgm_read_byte(tvtext_font_data + c * 8 + row);
}
