#include <stdlib.h>
#include <string.h>

#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/pgmspace.h>

#include "tvtext/tvtext.h"
#include "fontchars.h"
#include "joypad.h"
#include "delay.h"
#include "level.h"
#include "rectangle.h"
#include "scroll.h"
#include "number.h"

#include "tetrads.h"

// Position of the well on the screen.
#define WELL_LOCATION_TOP  3
#define WELL_LOCATION_LEFT 9

// Bit in the well array that represents the left and right walls.
#define WELL_LEFT  14
#define WELL_RIGHT 3
// A bitfield that represents a completely empty line on the well.
#define WELL_EMPTY 0b0000000000000000
// A bitfield that represents a section of the well that only has walls.
#define WELL_WALLS 0b0100000000001000
// A bitfield that represents a section of the well that has walls and is full of data.
#define WELL_FULL  0b0111111111111000

// The position of the "next" tetrad graphic.
#define NEXT_LOCATION_TOP   11
#define NEXT_LOCATION_LEFT  18

// The position of the score text.
#define SCORE_LOCATION_TOP   6
#define SCORE_LOCATION_RIGHT 7

// The position of the level text.
#define LEVEL_LOCATION_TOP   9
#define LEVEL_LOCATION_RIGHT 7

// The position of the lines text.
#define LINES_LOCATION_TOP   12
#define LINES_LOCATION_RIGHT 7

// Position of the level selection form.
#define LEVEL_SELECT_TOP     5
#define LEVEL_SELECT_LEFT    6

// Position of the logo text.
#define LOGO_TOP             4
#define LOGO_LEFT            1

// Position of the author text.
#define AUTHOR_TOP           11
#define AUTHOR_LEFT          4

// Number of game loops to execute before a held key repeats.
#define USER_REPEAT_PERIOD   5

// Array of bits that stores the well.
uint16_t well[23];

// Stores the user's current tetrad.
uint8_t tetrad[4];

// Stores the index for the next tetrad.
uint8_t next_tetrad;

uint8_t tetrad_x; // \_ Stores the position of the user's tetrad.
uint8_t tetrad_y; // /

uint32_t score;
uint32_t lines_cleared;
int8_t gravity_move_period;

uint8_t level; // Stores the current level.

// Loads a tetrad from its index (0-6) into the tetrad array.
void load_tetrad(uint8_t tetrad_number) {
	memcpy_P(tetrad, tetrads + tetrad_number * 4, 4);
}

// Empties the well.
void clear_well(void) {
	for (uint8_t row = 0; row < 21; ++row) {
		well[row] = WELL_WALLS;
	}
	well[21] = WELL_FULL;
	well[22] = WELL_EMPTY;
}

// Copies the entire well buffer to the screen.
void draw_well(void) {
	for (uint8_t row = 1; row < 21; row += 2) {
		uint16_t well_bits_above = well[row + 0], well_bits_below = well[row + 1];
		for (uint8_t col = 0; col < 5 + (WELL_LEFT & 1); ++col) {
			tvtext_buffer[(row / 2 + WELL_LOCATION_TOP) * TVTEXT_BUFFER_WIDTH + col + WELL_LOCATION_LEFT + 1] = FONT_QUARTER_BLOCK_SPACED + ((well_bits_above >> (WELL_LEFT - 1 - (WELL_RIGHT & 1))) & 0b0011) + ((well_bits_below >> (WELL_LEFT - 3 - (WELL_RIGHT & 1))) & 0b1100);
			well_bits_above <<= 2;
			well_bits_below <<= 2;
		}
	}
}

// Exclusively-ORs the tetrad to the well at a particular point. Returns 1 on collision, 0 otherwise.
uint8_t eor_tetrad(uint8_t x, uint8_t y) {
	uint8_t result = 0;
	for (uint8_t tetrad_row = 0, well_row = y; tetrad_row < 4; ++tetrad_row, ++well_row) {
		uint16_t tetrad_bits = (uint16_t)tetrad[tetrad_row] << (10 - x);
		if (tetrad_bits & well[well_row]) result = 1;
		well[well_row] ^= tetrad_bits;
	}
	return result;
}

// Inclusively-ORs the tetrad to the well at a particular point. Returns 1 on collision, 0 otherwise.
inline uint8_t or_tetrad(uint8_t x, uint8_t y) {
	uint8_t result = 0;
	for (uint8_t tetrad_row = 0, well_row = y; tetrad_row < 4; ++tetrad_row, ++well_row) {
		uint16_t tetrad_bits = (uint16_t)tetrad[tetrad_row] << (10 - x);
		if (tetrad_bits & well[well_row]) result = 1;
		well[well_row] |= tetrad_bits;
	}
	return result;
}

//  Checks the tetrad against the well at a particular point. Returns 1 on collision, 0 otherwise.
uint8_t test_tetrad(uint8_t x, uint8_t y) {
	uint8_t result = 0;
	for (uint8_t tetrad_row = 0, well_row = y; tetrad_row < 4; ++tetrad_row, ++well_row) {
		uint16_t tetrad_bits = (uint16_t)tetrad[tetrad_row] << (10 - x);
		if (tetrad_bits & well[well_row]) result = 1;
	}
	return result;
}


// Adds a random tetrad to the top of the grid.
// Returns 1 on collision.
uint8_t add_next_tetrad(void) {
	// Fetch the next random tetrad.
	uint8_t preview_next_tetrad = rand() % 7;
	load_tetrad(preview_next_tetrad);
	// Draw it onto the screen.
	for (uint8_t preview_y = 0; preview_y < 2; ++preview_y) {
		for (uint8_t preview_x = 0; preview_x < 2; ++preview_x) {
			tvtext_buffer[(NEXT_LOCATION_TOP + preview_y) * TVTEXT_BUFFER_WIDTH + preview_x + NEXT_LOCATION_LEFT] =
				FONT_QUARTER_BLOCK_SPACED + ((tetrad[preview_y * 2 + 0] >> (2 * (1 - preview_x))) & 0b0011) + 
					((tetrad[preview_y * 2 + 1] << (2 * preview_x)) & 0b1100);
		}
	}
	// Load the *actual* next tetrad.
	load_tetrad(next_tetrad);
	// Draw the new tetrad onto the screen.
	tetrad_x = 1 + (16 - WELL_LEFT);
	tetrad_y = 1;
	// Set the next tetrad to be the one we previewed earlier.
	next_tetrad = preview_next_tetrad;
	return or_tetrad(tetrad_x, tetrad_y);
}

// Redraws the score.
void draw_score(void) {
	draw_right_number(score, SCORE_LOCATION_RIGHT, SCORE_LOCATION_TOP);
}

// Redraws the level number.
void draw_level(void) {
	draw_right_number(level, LEVEL_LOCATION_RIGHT, LEVEL_LOCATION_TOP);
}

// Updates the period of gravity.
void update_gravity_period(void) {
	gravity_move_period = 25 - level * 2;
	if (gravity_move_period < 1) gravity_move_period = 1;
}

// Redraws the number of cleared lines.
void draw_lines_cleared(void) {
	draw_right_number(lines_cleared, LINES_LOCATION_RIGHT, LINES_LOCATION_TOP);
}

// Clears any complete lines from the well.
inline void clear_lines(void) {
	// Scan for rows to clear, starting from the bottom.
	uint8_t cleared_rows = 0;
	for (uint8_t row = 20; row >= 1; --row) {
		if (well[row] == WELL_FULL) {
			++cleared_rows;
		}
	}
	if (cleared_rows == 0) return;
	for (uint8_t row = 20; row >= 1; --row) {
		if (well[row] == WELL_FULL) {
			// We have a complete row.
			uint16_t score_per_block = level + 1;
			switch (cleared_rows) {
				case 1:
					score_per_block *= 4;
					break;
				case 2:
					score_per_block *= 10;
					break;
				case 3:
					score_per_block *= 30;
					break;
				case 4:
					score_per_block *= 120;
					break;
			}
			for (uint8_t col = WELL_LEFT - 1; col >= WELL_RIGHT + 1; --col) {
				well[row] &= ~(1 << col);
				score += score_per_block;
				tvtext_wait_vsync();
				draw_well();
				draw_score();
			}
			// Update the "lines cleared" state.
			if ((++lines_cleared % 10) == 0) {
				// Every 10 lines, go up a level.
				++level;
				update_gravity_period();
				draw_level();
			}
			draw_lines_cleared();
			// Move all rows above it down.
			for (uint8_t move_row = row; move_row >= 1; --move_row) {
				well[move_row] = well[move_row - 1];
			}
			// Blank out the top row.
			well[0] = WELL_WALLS;
			// Move the row back down again.
			++row;
		}
	}
}


// Design of the "S" in the logo.
const uint8_t logo_s[] PROGMEM = {
	FONT_DIAGONAL_BLOCK_BOTTOM_RIGHT, FONT_DIAGONAL_BLOCK_TOP_LEFT, FONT_BLOCK_100,
	FONT_DIAGONAL_BLOCK_TOP_RIGHT, FONT_DIAGONAL_BLOCK_BOTTOM_LEFT, FONT_DIAGONAL_BLOCK_TOP_RIGHT,
	FONT_DIAGONAL_BLOCK_BOTTOM_LEFT, FONT_DIAGONAL_BLOCK_TOP_RIGHT, FONT_DIAGONAL_BLOCK_BOTTOM_LEFT,
	FONT_BLOCK_100, FONT_DIAGONAL_BLOCK_BOTTOM_RIGHT, FONT_DIAGONAL_BLOCK_TOP_LEFT,
};

void tetris(void) {


	// Stores the current and old joypad states.	
	uint8_t joypad = 0;
	uint8_t old_joypad = 0;

	// Shunt the display up so it's above the screen.
	tvtext_offset_y -= 128 * 2;

	// Start from a blank slate.
	tvtext_clear();

	// Start with the vertical strokes in the T, E, T, R and I.
	for (uint8_t r = LOGO_TOP; r < LOGO_TOP + 4; ++r) {
		uint16_t row_offset = r * TVTEXT_BUFFER_WIDTH + LOGO_LEFT;
		tvtext_buffer[row_offset + 1] = FONT_BLOCK_100; // T
		tvtext_buffer[row_offset + 4] = FONT_BLOCK_100; // E
		tvtext_buffer[row_offset + 9] = FONT_BLOCK_100; // T
		tvtext_buffer[row_offset + 12] = FONT_BLOCK_100; // R
		tvtext_buffer[row_offset + 14] = FONT_BLOCK_100; // R
		tvtext_buffer[row_offset + 16] = FONT_BLOCK_100; // I
	}

	// Draw the rest of the logo letters manually.

	// T
	tvtext_buffer[(LOGO_TOP + 0) * TVTEXT_BUFFER_WIDTH + (LOGO_LEFT + 0)] = FONT_DIAGONAL_BLOCK_TOP_LEFT;
	tvtext_buffer[(LOGO_TOP + 0) * TVTEXT_BUFFER_WIDTH + (LOGO_LEFT + 2)] = FONT_DIAGONAL_BLOCK_TOP_RIGHT;
	
	// E
	tvtext_buffer[(LOGO_TOP + 0) * TVTEXT_BUFFER_WIDTH + (LOGO_LEFT + 5)] = FONT_DIAGONAL_BLOCK_TOP_LEFT;
	tvtext_buffer[(LOGO_TOP + 0) * TVTEXT_BUFFER_WIDTH + (LOGO_LEFT + 6)] = FONT_DIAGONAL_BLOCK_TOP_RIGHT;
	tvtext_buffer[(LOGO_TOP + 1) * TVTEXT_BUFFER_WIDTH + (LOGO_LEFT + 5)] = FONT_DIAGONAL_BLOCK_BOTTOM_RIGHT;
	tvtext_buffer[(LOGO_TOP + 2) * TVTEXT_BUFFER_WIDTH + (LOGO_LEFT + 5)] = FONT_DIAGONAL_BLOCK_TOP_RIGHT;
	tvtext_buffer[(LOGO_TOP + 3) * TVTEXT_BUFFER_WIDTH + (LOGO_LEFT + 5)] = FONT_DIAGONAL_BLOCK_BOTTOM_LEFT;
	tvtext_buffer[(LOGO_TOP + 3) * TVTEXT_BUFFER_WIDTH + (LOGO_LEFT + 6)] = FONT_DIAGONAL_BLOCK_BOTTOM_RIGHT;

	// T
	tvtext_buffer[(LOGO_TOP + 0) * TVTEXT_BUFFER_WIDTH + (LOGO_LEFT + 8)] = FONT_DIAGONAL_BLOCK_TOP_LEFT;
	tvtext_buffer[(LOGO_TOP + 0) * TVTEXT_BUFFER_WIDTH + (LOGO_LEFT + 10)] = FONT_DIAGONAL_BLOCK_TOP_RIGHT;

	// R
	tvtext_buffer[(LOGO_TOP + 0) * TVTEXT_BUFFER_WIDTH + (LOGO_LEFT + 12)] = FONT_DIAGONAL_BLOCK_BOTTOM_RIGHT;
	tvtext_buffer[(LOGO_TOP + 0) * TVTEXT_BUFFER_WIDTH + (LOGO_LEFT + 13)] = FONT_DIAGONAL_BLOCK_TOP_LEFT;
	tvtext_buffer[(LOGO_TOP + 1) * TVTEXT_BUFFER_WIDTH + (LOGO_LEFT + 13)] = FONT_DIAGONAL_BLOCK_BOTTOM_RIGHT;
	tvtext_buffer[(LOGO_TOP + 1) * TVTEXT_BUFFER_WIDTH + (LOGO_LEFT + 14)] = FONT_DIAGONAL_BLOCK_TOP_LEFT;
	tvtext_buffer[(LOGO_TOP + 2) * TVTEXT_BUFFER_WIDTH + (LOGO_LEFT + 13)] = FONT_DIAGONAL_BLOCK_TOP_LEFT;
	tvtext_buffer[(LOGO_TOP + 2) * TVTEXT_BUFFER_WIDTH + (LOGO_LEFT + 14)] = FONT_DIAGONAL_BLOCK_BOTTOM_LEFT;

	// S
	for (uint8_t r = 0; r < 4; ++r) {
		for (uint8_t c = 0; c < 3; ++c) {
			tvtext_buffer[(LOGO_TOP + r) * TVTEXT_BUFFER_WIDTH + (LOGO_LEFT + 18 + c)] = pgm_read_byte(logo_s + r * 3 + c);
		}
	}

	// Scroll the display down to bring the logo on-screen.
	// Scroll it down 16 pixels too many so it starts in the middle of the display.
	for (uint8_t s = 0; s < 128 + 16; ++s) {
		tvtext_wait_vsync();
		tvtext_offset_y += 2;
	}

	// Delay for a second, then scroll up.
	delay_ms(1000);
	for (uint8_t s = 0; s < 16 * 2; ++s) {
		tvtext_wait_vsync();
		--tvtext_offset_y;
	}

	// Author information.
	tvtext_cursor_move(AUTHOR_LEFT + 1, AUTHOR_TOP);
	tvtext_puts_P(PSTR("Ben Ryves 2009"));
	tvtext_cursor_move(AUTHOR_LEFT, AUTHOR_TOP + 1);
	tvtext_puts_P(PSTR("www.benryves.com"));

	// Wait for all keys to be released.
	while (~PINC & JOY_ALL);
	// Wait for the fire key to be pressed.
	while (!(~PINC & JOY_FIRE1));

	// Reset the level counter.
	uint8_t selected_level = 0;

	for (;;) {

		// Scroll the previous screen out.
		scroll_out();

		// Prompt for a menu number.
		level = selected_level;
		tvtext_clear();
		tvtext_cursor_move(LEVEL_SELECT_LEFT + 4, LEVEL_SELECT_TOP - 1);
		tvtext_puts_P(PSTR("Level"));
		draw_level_select_form(LEVEL_SELECT_LEFT, LEVEL_SELECT_TOP);

		// Scroll the menu in.
		scroll_in();

		// Handle the level selection.
		if (process_level_select_form(&level, LEVEL_SELECT_LEFT, LEVEL_SELECT_TOP) & JOY_FIRE2) {
			// We've hit the FIRE2 button; quit.
			scroll_out();
			tvtext_clear();
			tvtext_offset_y -= (128 + 8) * 2;
			return;
		}
		selected_level = level;

		// Scroll the menu out.
		scroll_out();

		tvtext_clear();

		// Draw the outside of the well.
		for (uint8_t row = 0; row < 10; ++row) {
			tvtext_buffer[(row + WELL_LOCATION_TOP) * TVTEXT_BUFFER_WIDTH + WELL_LOCATION_LEFT] = 127;
			tvtext_buffer[(row + WELL_LOCATION_TOP) * TVTEXT_BUFFER_WIDTH + WELL_LOCATION_LEFT + 6] = 127;
		}
		// Draw the bottom of the well.
		for (uint8_t col = 0; col < 6; ++col) {
			tvtext_buffer[(WELL_LOCATION_TOP + 10) * TVTEXT_BUFFER_WIDTH + WELL_LOCATION_LEFT + col] = 191;
		}
		// Bottom right corner of the well.
		tvtext_buffer[(WELL_LOCATION_TOP + 10) * TVTEXT_BUFFER_WIDTH + WELL_LOCATION_LEFT + 6] = 127;

		// Draw the "Next" piece box.
		draw_rounded_rectangle(NEXT_LOCATION_LEFT - 1, NEXT_LOCATION_TOP - 1, NEXT_LOCATION_LEFT + 2, NEXT_LOCATION_TOP + 2);

		// Clear the well array.
		clear_well();
		// Start with a single tetrad.
		srand(tvtext_frame_counter);
		add_next_tetrad();
		clear_well();
		add_next_tetrad();
		// Draw the well to the screen.
		draw_well();

		// Reset and redraw the score.
		score = 0;
		draw_score();
		tvtext_cursor_move(SCORE_LOCATION_RIGHT - 4, SCORE_LOCATION_TOP - 1);
		tvtext_puts_P(PSTR("Score"));

		// Redraw the level.
		draw_level();
		tvtext_cursor_move(LEVEL_LOCATION_RIGHT - 4, LEVEL_LOCATION_TOP - 1);
		tvtext_puts_P(PSTR("Level"));
		update_gravity_period();
	
		// Reset and redraw the number of lines cleared.
		lines_cleared = 0;
		draw_lines_cleared();
		tvtext_cursor_move(LINES_LOCATION_RIGHT - 4, LINES_LOCATION_TOP - 1);
		tvtext_puts_P(PSTR("Lines"));	

		// Reset the movement timers.
		uint8_t user_move_timer = USER_REPEAT_PERIOD;
		uint8_t gravity_move_timer = gravity_move_period;
	
		// Flag set when the game is over.
		uint8_t game_over = 0;

		// Flag set when the Down key is held.
		uint8_t down_held = 0;
		// Stores the tetrad's Y position at the instance the down key is held.
		uint8_t down_held_tetrad_y = 0;

		// Scroll the game in
		scroll_in();

		// Preload the old_joypad value.
		old_joypad = ~JOY_PIN & JOY_ALL;
		while (!game_over) {
			// Scrub the old tetrad.
			eor_tetrad(tetrad_x, tetrad_y);

			// Handle user input.
			joypad = ~PINC & JOY_ALL;

			// Has the joypad changed state?
			uint8_t old_old_joypad = old_joypad;
			if (joypad != old_joypad) {
				// Yes, so remember the state for next time and reset the timer.
				user_move_timer = USER_REPEAT_PERIOD;
				old_joypad = joypad;
			} else {
				// No, same buttons held. Check the repeat timer to see if we should repeat the move.
				if (--user_move_timer == 0) {
					user_move_timer = USER_REPEAT_PERIOD;
				} else {
					// Block all repeating keys.
					joypad &= ~(JOY_LEFT | JOY_RIGHT | JOY_UP | JOY_FIRE1);
				}
			}

			// Are we moving left or right?
			switch (joypad & (JOY_LEFT | JOY_RIGHT)) {
				case JOY_LEFT:
					if (!test_tetrad(tetrad_x - 1, tetrad_y)) {
						--tetrad_x;
					}
					break;
				case JOY_RIGHT:
					if (!test_tetrad(tetrad_x + 1, tetrad_y)) {
						++tetrad_x;
					}
					break;
			}
			// Are we rotating?
			if (joypad & (JOY_UP | JOY_FIRE1)) {
				uint8_t old_tetrad[4];
				memcpy(old_tetrad, tetrad, 4);
				// Rotate the tetrad into the spare most-significant nybble of each byte.
				for (uint8_t x = 0; x < 4; ++x) {
					for (uint8_t y = 0; y < 4; ++y) {
						if (tetrad[y] & (0x08 >> x)) {
							tetrad[x] |= (0x10 << y);
						}
					}
				}
				// Shift the most-significant nybble into the least-significant nybble.
				for (uint8_t r = 0; r < 4; ++r) {
					tetrad[r] >>= 4;
				}
				// Can we rotate here?
				if (test_tetrad(tetrad_x, tetrad_y)) {
					// Nope, can't move, restore the old tetrad.
					memcpy(tetrad, old_tetrad, 4);
				}
			}

			// Has the down key been pressed?
			if (joypad & JOY_DOWN) {
				// Was it previously released?
			 	if (!(old_old_joypad & JOY_DOWN)) {
					down_held_tetrad_y = tetrad_y;
					down_held = 1;
				}
			} else {
				down_held = 0;
			}

			// Can we move down?
			uint8_t hit_bottom = 0;
			if ((--gravity_move_timer == 0) || down_held) {
				if (!(hit_bottom = test_tetrad(tetrad_x, tetrad_y + 1))) {
					++tetrad_y;
				}
				gravity_move_timer = gravity_move_period;
			}

			// Draw the new tetrad.
			eor_tetrad(tetrad_x, tetrad_y);

			// Do we need to start from the top again?
			if (hit_bottom) {
				// Add a point for every line that down was held.
				if (down_held) {
					for (uint8_t i = down_held_tetrad_y; i < tetrad_y; ++i) {
						++score;
						tvtext_wait_vsync();
						draw_score();
					}
				}
				// Clear the lines.
				clear_lines();
				// Clear the "down_held" flag so the next piece drops slowly.
				down_held = 0;
				// Try to add a new tetrad. If it fails, set the game_over flag.
				game_over = add_next_tetrad();
			}
		
			// Wait for a game loop delay, then display the new position.
			delay_ms(40);
			draw_well();
		}
		// Game over!
		for (uint8_t row = 20; row >= 1; --row) {
			well[row] = WELL_FULL;
			delay_ms(60);
			draw_well();
		}
		for (uint8_t row = 1; row < 21; ++row) {
			well[row] = WELL_WALLS;
			delay_ms(60);
			draw_well();
		}
		tvtext_cursor_move(WELL_LOCATION_LEFT + 1, WELL_LOCATION_TOP + 4);
		tvtext_puts_P(PSTR("Game"));
		tvtext_cursor_move(WELL_LOCATION_LEFT + 2, WELL_LOCATION_TOP + 5);
		tvtext_puts_P(PSTR("over"));

		// Wait for all keys to be released.
		while (~PINC & JOY_ALL);
		// Wait for the fire key to be pressed.
		while (!(~PINC & JOY_FIRE1));

	}
}
