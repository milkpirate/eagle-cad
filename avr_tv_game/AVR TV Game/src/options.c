#include <stdlib.h>
#include <avr/io.h>
#include <avr/pgmspace.h>

#include "tvtext/tvtext.h"
#include "joypad.h"
#include "rectangle.h"
#include "scroll.h"

#define INSTRUCTIONS_WIDTH  18
#define INSTRUCTIONS_HEIGHT 4
#define INSTRUCTIONS_LEFT   ((TVTEXT_BUFFER_WIDTH-(INSTRUCTIONS_WIDTH+2))/2)
#define INSTRUCTIONS_TOP    ((TVTEXT_BUFFER_HEIGHT-(INSTRUCTIONS_HEIGHT+2))/2)
#define INSTRUCTIONS_RIGHT  (INSTRUCTIONS_LEFT+INSTRUCTIONS_WIDTH+1)
#define INSTRUCTIONS_BOTTOM (INSTRUCTIONS_TOP+INSTRUCTIONS_HEIGHT+1)

void options(void) {
	
	// Draw the instructions.
	scroll_out_instant();
	tvtext_clear();
	draw_rounded_rectangle(0, 0, TVTEXT_BUFFER_WIDTH - 1, TVTEXT_BUFFER_HEIGHT - 1);
	draw_animated_rectangle(1, 1, TVTEXT_BUFFER_WIDTH - 2, TVTEXT_BUFFER_HEIGHT - 2);

	tvtext_set_viewport(INSTRUCTIONS_LEFT + 1, INSTRUCTIONS_TOP + 1, INSTRUCTIONS_RIGHT - 1, INSTRUCTIONS_BOTTOM - 1);
	tvtext_puts_P(PSTR(
		"Use the  joypad to"
		"fit as much of the"
		"rectangle  on  the"
		"screen as possible"
	));
	tvtext_reset_viewport_cursor_home();
	scroll_in();

	uint8_t old_joypad = ~PINC & JOY_ALL;
	uint8_t joypad;
	do {
		tvtext_wait_vsync();
		draw_animated_rectangle(1, 1, TVTEXT_BUFFER_WIDTH - 2, TVTEXT_BUFFER_HEIGHT - 2);

		joypad = ~PINC & JOY_ALL;
		if (joypad != old_joypad) {
			old_joypad = joypad;

			if ((joypad & JOY_LEFT) && (tvtext_offset_x > 0)) {
				--tvtext_offset_x;
			}
			if ((joypad & JOY_RIGHT) && (tvtext_offset_x < TVTEXT_OFFSET_X_MAX)) {
				++tvtext_offset_x;
			}
			if (joypad & JOY_UP) {
				--tvtext_offset_y;
			}
			if (joypad & JOY_DOWN) {
				++tvtext_offset_y;
			}
			if (joypad & JOY_FIRE2) {
				tvtext_flags ^= _BV(TVTEXT_INVERTED);
			}
		}

	} while (!(joypad & JOY_FIRE1));
	scroll_out();
	tvtext_clear();
	scroll_in_instant();

}
