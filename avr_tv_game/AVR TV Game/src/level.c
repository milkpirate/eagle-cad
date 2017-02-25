#include <stdint.h>
#include <avr/io.h>
#include <avr/pgmspace.h>

#include "tvtext/tvtext.h"
#include "delay.h"
#include "rectangle.h"
#include "joypad.h"

void draw_level_select_form(uint8_t left, uint8_t top) {
	tvtext_set_viewport(left, 15, left + 12, top);
	tvtext_clear();
	
	tvtext_set_viewport(left + 2, 15, left + 12 - 2, top + 2);
	tvtext_puts_P(PSTR(
		"0 1 2 3 4"
		"\n"
		"5 6 7 8 9"
	));

	tvtext_reset_viewport_cursor_home();
	draw_rounded_rectangle(left, top, left + 12, top + 6);
}

uint8_t process_level_select_form(uint8_t* level, uint8_t left, uint8_t top) {
	// Preload the old_joypad value.
	uint8_t old_joypad = ~JOY_PIN & (JOY_LEFT | JOY_RIGHT | JOY_UP | JOY_DOWN | JOY_FIRE1);
	uint8_t joypad;
	while (~JOY_PIN & JOY_ALL) {
	}

	do {

		joypad = ~JOY_PIN & JOY_ALL;
		if (joypad != old_joypad) {
			old_joypad = joypad;

			if (joypad & JOY_LEFT) {
				(*level) += 9;
			}
			if (joypad & JOY_RIGHT) {
				(*level) += 1;
			}
			if (joypad & (JOY_UP | JOY_DOWN)) {
				(*level) += 5;
			}
			*level %= 10;
		}

		uint8_t highlight_rectangle_x = (*level % 5) * 2 + left + 1;
		uint8_t highlight_rectangle_y = (*level / 5) * 2 + top + 1;
		draw_animated_rectangle(highlight_rectangle_x, highlight_rectangle_y, highlight_rectangle_x + 2, highlight_rectangle_y + 2);
		delay_ms(40);
		clear_rectangle(highlight_rectangle_x, highlight_rectangle_y, highlight_rectangle_x + 2, highlight_rectangle_y + 2);

	} while (!(joypad & (JOY_FIRE1 | JOY_FIRE2)));
	return joypad;
}
