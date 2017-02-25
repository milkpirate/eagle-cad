#include <stdlib.h>
#include <string.h>

#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/pgmspace.h>

#include "tvtext/tvtext.h"
#include "joypad.h"
#include "rectangle.h"
#include "scroll.h"

#include "tetris.h"
#include "snake.h"
#include "options.h"

#include "gamepreviews.h"

// Position of the game selection rectangle.
#define GAME_SELECTION_LEFT   11
#define GAME_SELECTION_TOP    3
#define GAME_SELECTION_BOTTOM (GAME_SELECTION_TOP + 8)
#define GAME_SELECTION_RIGHT  (GAME_SELECTION_LEFT + 10)

// Position of the game preview graphic.
#define GAME_PREVIEW_LEFT     4
#define GAME_PREVIEW_TOP      4

// Number of games.
#define GAME_COUNT            3

// Draws a preview box for a particular game.
void draw_game_preview(uint8_t game, int8_t y_offset) {
	uint16_t i = game * 5 * 7;
	int8_t y = y_offset + GAME_PREVIEW_TOP - 1;
	for (int8_t r = -1; r < 8; ++r) {
		for (uint8_t c = 0; c < 5; ++c) {
			char preview_c = (r >= 0 && r < 7) ? pgm_read_byte(game_previews + i++) : ' ';
			if (y >= 0 && y < 16) {
				tvtext_buffer[y * TVTEXT_BUFFER_WIDTH + c + GAME_PREVIEW_LEFT] = preview_c;
			}
		}
		++y;
	}
}

int main(void) {
	// Initialise the joypad.
	JOY_PORT |= JOY_ALL;

	// Initialise the tvText library.
	tvtext_init();
	tvtext_flags &= ~_BV(TVTEXT_CURSOR_ENABLED);
	tvtext_flags |= _BV(TVTEXT_INVERTED);

	// Selected game index.
	uint8_t selected_game = 0;

	for (;;) {
		// Wait for all keys to be released.
		while (~JOY_PIN & JOY_ALL);

		// Draw the selection menu.
		tvtext_clear();
		draw_rounded_rectangle(GAME_SELECTION_LEFT, GAME_SELECTION_TOP, GAME_SELECTION_RIGHT, GAME_SELECTION_BOTTOM);
		tvtext_cursor_move(GAME_SELECTION_LEFT + 2, GAME_SELECTION_TOP + 2);
		tvtext_puts_P(PSTR("Tetris"));
		tvtext_cursor_move(GAME_SELECTION_LEFT + 2, GAME_SELECTION_TOP + 4);
		tvtext_puts_P(PSTR("Snake"));
		tvtext_cursor_move(GAME_SELECTION_LEFT + 2, GAME_SELECTION_TOP + 6);
		tvtext_puts_P(PSTR("Options"));

		// Preload the joypad input value.
		uint8_t joypad = ~JOY_PIN & JOY_ALL;
		uint8_t old_joypad = joypad;

		// Used to animate the swapping of game graphics.
		int8_t swap_game_scroll = 0;

		// We're still choosing a game...
		uint8_t choosing_game = 1;
		while (choosing_game) {
		
			// Wait for sync.
			tvtext_wait_vsync();

			// Clear the current game rectangle.
			clear_rectangle(GAME_SELECTION_LEFT + 1, GAME_SELECTION_TOP + 1 + 2 * selected_game, GAME_SELECTION_RIGHT - 1, GAME_SELECTION_TOP + 3 + 2 * selected_game);

			// Poll the joypad.
			joypad = ~JOY_PIN & JOY_ALL;
			if ((joypad == old_joypad) || (swap_game_scroll != 0)) {
				joypad = JOY_NONE;
			} else {
				old_joypad = joypad;
			}
			// Handle the joypad.
			switch (joypad & (JOY_UP | JOY_DOWN)) {
				case JOY_UP:
					selected_game += (GAME_COUNT - 1);
					swap_game_scroll = -16;
					break;
				case JOY_DOWN:
					++selected_game;
					swap_game_scroll = +16;
					break;
			}
			selected_game %= GAME_COUNT;

			// Have we selected a game?
			choosing_game = !(joypad & JOY_FIRE1);
		
			// Draw the new selected game rectangle.
			draw_animated_rectangle(GAME_SELECTION_LEFT + 1, GAME_SELECTION_TOP + 1 + 2 * selected_game, GAME_SELECTION_RIGHT - 1, GAME_SELECTION_TOP + 3 + 2 * selected_game, tvtext_frame_counter / 4);

			// Draw the game preview graphic.
			draw_game_preview(selected_game, swap_game_scroll);
			if (swap_game_scroll > 0) {
				draw_game_preview((selected_game + (GAME_COUNT - 1)) % GAME_COUNT, swap_game_scroll - 16);
				--swap_game_scroll;
			} else if (swap_game_scroll < 0) {
				draw_game_preview((selected_game + 1) % GAME_COUNT, swap_game_scroll + 16);
				++swap_game_scroll;
			}

		}

		// Scroll out the menu.
		scroll_out();
		tvtext_clear();
		tvtext_offset_y -= (128 + 8) * 2;

		// Run the selected game.
		switch (selected_game) {
			case 0:
				tetris();
				break;
			case 1:
				snake();
				break;
			case 2:
				options();
				break;
		}
	}
}
