#ifndef _TVTEXT_H_
#define _TVTEXT_H_

#include "config.h"

//
// Width of the text buffer in characters (set automatically).
//
#define TVTEXT_BUFFER_WIDTH (192 / TVTEXT_CHARACTER_WIDTH)

//
// Height of the text buffer in lines.
//
#define TVTEXT_BUFFER_HEIGHT 16

//
// X offset default value.
//
#define TVTEXT_OFFSET_X_DEFAULT (15-TVTEXT_SKIP_ALTERNATE_ROWS*2)

//
// X offset maximum value.
//
#define TVTEXT_OFFSET_X_MAX (19-TVTEXT_SKIP_ALTERNATE_ROWS*2)

//
// Set to make the display visible, cleared to blank the display.
//
#define TVTEXT_VISIBLE        0

//
// Automatically scroll the screen up or down when the cursor above or below the viewport.
//
#define TVTEXT_AUTO_SCROLL    1

//
// Display a flashing cursor on the screen.
//
#define TVTEXT_CURSOR_ENABLED 2

//
// Whether the flashing cursor is visible or not. If TVTEXT_CURSOR_ENABLED is not set, the cursor is permanently invisible.
//
#define TVTEXT_CURSOR_VISIBLE 3

//
// Enable this to invert the display (black text on a white background).
//
#define TVTEXT_INVERTED       4

#ifdef __ASSEMBLER__

#define r_sreg_save r14

#else  /* !ASSEMBLER */

#include <stdint.h>

register uint8_t r_sreg_save asm("r14");

//
// Stores the flags controlling the text output and display.
//
uint8_t tvtext_flags;

//
// A character buffer used to store the text.
//
char tvtext_buffer[TVTEXT_BUFFER_WIDTH * 16];

//
// The column that the cursor is in.
//
int8_t tvtext_cursor_column;

//
// The row that the cursor is in.
//
int8_t tvtext_cursor_row;

//
// The character used as the flashing cursor (defaults to '_').
//
char tvtext_cursor;

//
// The character used to clear the screen to (defaults to ' ').
//
char tvtext_cleared;

//
// The position of the left edge of the text viewport.
//
uint8_t tvtext_viewport_left;

//
// The position of the bottom edge of the text viewport.
//
uint8_t tvtext_viewport_bottom;

//
// The position of the right edge of the text viewport.
//
uint8_t tvtext_viewport_right;

//
// The position of the top edge of the text viewport.
//
uint8_t tvtext_viewport_top;

//
// The period (in frames) that it takes the cursor to toggle between being shown and being hidden.
//
uint8_t tvtext_cursor_flash_period;

//
// Timer used to blink the cursor. Starts at tvtext_cursor_blink_period, counts down to zero, then toggles the cursor visibility and resets.
//
uint8_t tvtext_cursor_flash_timer;

//
// The total number of frames that have been rasterised.
//
volatile int16_t tvtext_frame_counter;

//
// The horizontal offset of the active display. Larger numbers shift the display right. Values that are too large (above TVTEXT_OFFSET_X_MAX) will cause the the display to be scanned incorrectly.
//
uint8_t tvtext_offset_x;

//
// The vertical offset of the active display. Positive numbers move the display down, negative numbers move it up.
//
int16_t tvtext_offset_y;

//
// Initialises the tvText library and starts outputting video signals.
//
void tvtext_init(void);

//
// Puts a character onto the display.
//
void tvtext_putc(char c);

//
// Puts a NUL-terminated string onto the display.
//
void tvtext_puts(const char* s);

//
// Puts a NUL-terminated string stored in program memory onto the display.
//
void tvtext_puts_P(const char* s);

//
// Moves the cursor left one character (VDU 8).
//
void tvtext_cursor_left(void);

//
// Moves the cursor right one character (VDU 9).
//
void tvtext_cursor_right(void);

//
// Moves the cursor down one line (VDU 10).
//
void tvtext_cursor_down(void);

//
// Moves the cursor up one line (VDU 11).
//
void tvtext_cursor_up(void);

//
// Clears the text buffer to the defined clear character (VDU 12).
//
void tvtext_clear(void);

//
// Scrolls the viewport contents right one character (VDU 23,7,0,0,0;0;0;).
//
void tvtext_scroll_right(void);

//
// Scrolls the viewport contents left one character (VDU 23,7,0,1,0;0;0;).
//
void tvtext_scroll_left(void);

//
// Scrolls the viewport contents down one line (VDU 23,7,0,2,0;0;0;).
//
void tvtext_scroll_down(void);

//
// Scrolls the viewport contents up one line (VDU 23,7,0,3,0;0;0;).
//
void tvtext_scroll_up(void);

//
// Resets the viewport to its full size and homes the cursor (VDU 26).
//
void tvtext_reset_viewport_cursor_home(void);

//
// Sets the boundaries of the text viewport (VDU 28).
//
void tvtext_set_viewport(int8_t left, int8_t bottom, int8_t right, int8_t top);

//
// Moves the cursor to the top-left of the text viewport (VDU 30).
//
void tvtext_cursor_home(void);

//
// Moves the cursor to a particular location on the screen (VDU 31).
//
void tvtext_cursor_move(uint8_t column, uint8_t row);

//
// Waits for the rasteriser to enter the vsync period.
//
void tvtext_wait_vsync(void);

//
// Resets the cursor flash (makes cursor visible and resets the flash timer to the flash period).
//
void tvtext_cursor_reset_flash(void);

//
// Retrieve the bits for a row of pixels in a particular character of the text font.
//
uint8_t tvtext_get_font_row(char c, uint8_t row);

#endif /* ASSEMBLER */

#endif
