#include <stdint.h>
#include <avr/io.h>

#include "tvtext/tvtext.h"
#include "delay.h"
#include "rectangle.h"
#include "joypad.h"

void draw_level_select_form(uint8_t left, uint8_t top) {
	tvtext_set_viewport(left, top + 6, left + 12, top);
	tvtext_clear();
	tvtext_set_viewport(0, 15, TVTEXT_BUFFER_WIDTH - 1, 0);
	draw_rounded_rectangle(left, top, left + 12, top + 6);
	
	for (uint8_t r = 0; r < 2; ++r) {
		for (uint8_t c = 0; c < 5; ++c) {
			tvtext_buffer[(r * 2 + top + 2) * TVTEXT_BUFFER_WIDTH  + (c * 2 + left + 2)] = r * 5 + c + '0';
		}
	}
}

uint8_t process_level_select_form(uint8_t* level, uint8_t left, uint8_t top) {
	// Preload the old_joypad value.
	uint8_t old_joypad = ~JOY_PIN & (JOY_LEFT | JOY_RIGHT | JOY_UP | JOY_DOWN | JOY_FIRE1);
	uint8_t joypad;
	do {

		joypad = ~JOY_PIN & JOY_ALL;
		if (joypad != old_joypad) {
			old_joypad= joypad;
		} else {
			joypad = 0;
		}

		uint8_t highlight_rectangle_x = (*level % 5) * 2 + left + 1;
		uint8_t highlight_rectangle_y = (*level / 5) * 2 + top + 1;
		delay_ms(40);
		draw_animated_rectangle(highlight_rectangle_x, highlight_rectangle_y, highlight_rectangle_x + 2, highlight_rectangle_y + 2, tvtext_frame_counter / 4);

		uint8_t old_level = *level;

		switch (joypad & (JOY_LEFT | JOY_RIGHT)) {
			case JOY_LEFT:
				*level += 9;
				break;
			case JOY_RIGHT:
				*level += 1;
				break;
		}

		switch (joypad & (JOY_UP | JOY_DOWN)) {
			case JOY_UP:
				*level += 5;
				break;
			case JOY_DOWN:
				*level += 15;
				break;
		}
		*level %= 10;
		if (*level != old_level) {
			clear_rectangle(highlight_rectangle_x, highlight_rectangle_y, highlight_rectangle_x + 2, highlight_rectangle_y + 2);
		}
	} while (!(joypad & (JOY_FIRE1 | JOY_FIRE2)));
	return joypad;
}
