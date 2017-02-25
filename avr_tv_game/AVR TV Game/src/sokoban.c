#include <stdlib.h>
#include <avr/io.h>
#include <avr/pgmspace.h>

#include "tvtext/tvtext.h"
#include "joypad.h"
#include "rectangle.h"
#include "scroll.h"
#include "fontchars.h"
#include "sokoban_levels.h"
#include "delay.h"
#include "number.h"
#include "level.h"

#define SOKOBAN_FIELD_WIDTH  16
#define SOKOBAN_FIELD_HEIGHT 8
#define SOKOBAN_FIELD_LEFT   4
#define SOKOBAN_FIELD_TOP    2
#define SOKOBAN_FIELD_RIGHT  (SOKOBAN_FIELD_LEFT + SOKOBAN_FIELD_WIDTH - 1)
#define SOKOBAN_FIELD_BOTTOM (SOKOBAN_FIELD_TOP + SOKOBAN_FIELD_HEIGHT - 1)

#define SOKOBAN_INFO_WIDTH   16
#define SOKOBAN_INFO_HEIGHT  3
#define SOKOBAN_INFO_LEFT    4
#define SOKOBAN_INFO_TOP     (SOKOBAN_FIELD_BOTTOM + 3)
#define SOKOBAN_INFO_RIGHT   (SOKOBAN_INFO_LEFT + SOKOBAN_INFO_WIDTH - 1)
#define SOKOBAN_INFO_BOTTOM  (SOKOBAN_INFO_TOP + SOKOBAN_INFO_HEIGHT - 1)

#define SOKOBAN_OFFSET_UP    (0 - TVTEXT_BUFFER_WIDTH)
#define SOKOBAN_OFFSET_DOWN  TVTEXT_BUFFER_WIDTH
#define SOKOBAN_OFFSET_LEFT  -1
#define SOKOBAN_OFFSET_RIGHT 1

#define SOKOBAN_LEVEL_SELECT_TOP     5
#define SOKOBAN_LEVEL_SELECT_LEFT    6

// Current level - it is shown separated into level and room, but saved in one int
uint8_t sokoban_level;

// Pointer to start of this level in program memory
char* sokoban_level_data_pointer;
// Pointer to start of next level in program memory
char* sokoban_level_data_pointer_next;

// Number of moves that sokoban did
uint16_t sokoban_moves;
// Number of pushes that sokoban did
uint16_t sokoban_pushes;
// Number of moves that sokoban did since start of level
uint16_t sokoban_moves_level;
// Number of pushes that sokoban did since start of level
uint16_t sokoban_pushes_level;

/**
 * Draws info about game (level number, count of moves and pushes)
 */
void sokoban_draw_info() {
	draw_rounded_rectangle(SOKOBAN_INFO_LEFT - 1, SOKOBAN_INFO_TOP - 1, SOKOBAN_INFO_RIGHT + 1, SOKOBAN_INFO_BOTTOM + 1);
	tvtext_set_viewport(SOKOBAN_INFO_LEFT, SOKOBAN_INFO_TOP, SOKOBAN_INFO_RIGHT, SOKOBAN_INFO_BOTTOM);
	tvtext_puts_P(PSTR(
		"Level Moves Push"
		"   /            "
		"Total"
	));
	tvtext_reset_viewport_cursor_home();

	// level is shown separated to level and room (modulo SOKOBAN_ROOMS_PER_LEVEL)
	draw_right_number(sokoban_level / SOKOBAN_ROOMS_PER_LEVEL, SOKOBAN_INFO_LEFT + 2, SOKOBAN_INFO_TOP + 1);
	draw_right_number(sokoban_level % SOKOBAN_ROOMS_PER_LEVEL + 1, SOKOBAN_INFO_LEFT + 4, SOKOBAN_INFO_TOP + 1);
	draw_right_number(sokoban_moves_level, SOKOBAN_INFO_LEFT + 10, SOKOBAN_INFO_TOP + 1);
	draw_right_number(sokoban_pushes_level, SOKOBAN_INFO_LEFT + 15, SOKOBAN_INFO_TOP + 1);
	draw_right_number(sokoban_moves, SOKOBAN_INFO_LEFT + 10, SOKOBAN_INFO_TOP + 2);
	draw_right_number(sokoban_pushes, SOKOBAN_INFO_LEFT + 15, SOKOBAN_INFO_TOP + 2);
}

/**
 * Loads and draws level data (field and info) on screen
 */
void sokoban_load_level() {
	// position of "reading head" in level data (program memory)
	char* reading_pos;
	// read token, and his first and second nibble
	char token, token1, token2;
	// dimensions of level
	uint8_t level_width, level_height;

	// clear level statistics
	sokoban_moves_level = 0;
	sokoban_pushes_level = 0;

	// set position of head to start of level data
	reading_pos = sokoban_level_data_pointer;

	// clear display
	tvtext_wait_vsync();
	tvtext_cleared = 0;
	tvtext_clear();

	// draw field
	draw_rounded_rectangle(SOKOBAN_FIELD_LEFT - 1, SOKOBAN_FIELD_TOP - 1, SOKOBAN_FIELD_RIGHT + 1, SOKOBAN_FIELD_BOTTOM + 1);
	tvtext_set_viewport(SOKOBAN_FIELD_LEFT, SOKOBAN_FIELD_TOP, SOKOBAN_FIELD_RIGHT, SOKOBAN_FIELD_BOTTOM);
	tvtext_cleared = FONT_SOKOBAN_SKY;
	tvtext_clear();
	tvtext_cleared = 0;

	// read dimensions and set viewport
	token = pgm_read_byte(reading_pos);
	reading_pos++;
	level_width = ((token & 0b11110000) >> 4) + 1;
	level_height = (token & 0b00000111) + 1;
	tvtext_set_viewport((SOKOBAN_FIELD_LEFT + SOKOBAN_FIELD_RIGHT - level_width) / 2 + 1, (SOKOBAN_FIELD_TOP + SOKOBAN_FIELD_BOTTOM - level_height) / 2 + 1, (SOKOBAN_FIELD_LEFT + SOKOBAN_FIELD_RIGHT - level_width) / 2 + level_width, (SOKOBAN_FIELD_TOP + SOKOBAN_FIELD_BOTTOM - level_height) / 2 + level_height);

	// read level data and write to screen (compression algorithm is described in sokoban_levels.h)
	do {
		token = pgm_read_byte(reading_pos);
		token1 = ((token & 0b11110000) >> 4);
		token2 = (token & 0b00001111);

		if (token1 < 0xe) {
			tvtext_putc(FONT_SOKOBAN_FLOOR + (token1 & 0b00000111));
			if (token1 > 0x7) {
				tvtext_putc(FONT_SOKOBAN_FLOOR + (token1 & 0b00000111));
			}
		} else {
			tvtext_putc(13);
			tvtext_putc(10);
		}
		if (token2 < 0xe) {
			tvtext_putc(FONT_SOKOBAN_FLOOR + (token2 & 0b00000111));
			if (token2 > 0x7) {
				tvtext_putc(FONT_SOKOBAN_FLOOR + (token2 & 0b00000111));
			}
		} else {
			tvtext_putc(13);
			tvtext_putc(10);
		}

		reading_pos++;
	} while ((token1 != 0b00001111) && (token2 != 0b00001111));

	// set pointer to next level
	sokoban_level_data_pointer_next = reading_pos;

	// restore viewport
	tvtext_reset_viewport_cursor_home();

	// display info
	sokoban_draw_info();
}

/**
 * Restarts whole game (clears counters and starts at first level)
 */
void sokoban_restart_game() {
	sokoban_level = 0;
	sokoban_level_data_pointer = (char*)sokoban_levels;
	sokoban_moves = 0;
	sokoban_pushes = 0;
}

/**
 * Advances to the next level
 */
void sokoban_advance_level() {
	sokoban_level++;
	sokoban_level_data_pointer = sokoban_level_data_pointer_next;

	if (sokoban_level >= SOKOBAN_LEVELS_COUNT) {
		sokoban_restart_game();
	}
}

/**
 * Draws "congratulations" window
 */
inline void sokoban_congratulations() {
	// joystick status
	uint8_t joypad;
	// coordinates of animated rectangle
	uint8_t x1, x2, y1, y2;

	delay_ms(1000);

	// big window after last level
	if (sokoban_level == SOKOBAN_LEVELS_COUNT - 1) {
		tvtext_set_viewport(3, 3, 20, 8);
		tvtext_cursor_home();
		tvtext_puts_P(PSTR(
			" Congratulations! "
			"                  "
			" You've completed "
			" all levels.      "
			" Try again to do  "
			" your best!       "
		));
		tvtext_reset_viewport_cursor_home();
		x1 = 2;
		y1 = 2;
		x2 = 21;
		y2 = 9;

	// little window after each level
	} else {
		tvtext_cursor_move(3, 6);
		tvtext_puts_P(PSTR("  Level cleared!  "));
		x1 = 2;
		y1 = 5;
		x2 = 21;
		y2 = 7;
	}

	// wait until keypress
	do {
		draw_animated_rectangle(x1, y1, x2, y2);
		tvtext_wait_vsync();
		joypad = ~JOY_PIN & JOY_ALL;
	} while (!(joypad));
	do {
		joypad = ~JOY_PIN & JOY_ALL;
	} while ((joypad));
}

/**
 * Level selection (selects level to start - room is always 0)
 * @return uint8_t number of selected level
 */
inline uint8_t sokoban_select_level() {
	uint8_t level = 0;

	tvtext_clear();
	tvtext_cursor_move(SOKOBAN_LEVEL_SELECT_LEFT + 4, SOKOBAN_LEVEL_SELECT_TOP - 1);
	tvtext_puts_P(PSTR("Level"));
	draw_level_select_form(SOKOBAN_LEVEL_SELECT_LEFT, SOKOBAN_LEVEL_SELECT_TOP);
	scroll_in();
	process_level_select_form(&level, SOKOBAN_LEVEL_SELECT_LEFT, SOKOBAN_LEVEL_SELECT_TOP);
	scroll_out();

	return level;
}

/**
 * Shows intro
 */
inline void sokoban_intro() {
	scroll_out_instant();
	tvtext_clear();

	// draw last 24 chars (sokobal logo)
	tvtext_set_viewport(9, 1, 14, 4);
	for (char c = 256 - 24; c; c++) {
		tvtext_putc(c);
	}
	// draw title
	tvtext_set_viewport(6, 6, 18, 16);
	tvtext_puts_P(PSTR("SOKOBAN 2011"));

	// scroll in
	scroll_in();

	// draw credits
	tvtext_set_viewport(2, 8, 24, 16);
	tvtext_puts_P(PSTR(
		"Idea:\r\n"
		"  Hiroyuki Imabayashi\r\n"
		"Levels:\r\n"
		"  David W. Skinner\r\n"
		"Program & Graphics:\r\n"
		"  Martin Sustek\r\n"
		"  Ben Ryves\r\n"
	));

	tvtext_reset_viewport_cursor_home();

	// wait until keypress
	while (~JOY_PIN & JOY_ALL);
	while (!(~JOY_PIN & JOY_FIRE1));

	scroll_out();
}

/**
 * Returns pointer to char with player
 * @return char* pointer on tile in tvtext_buffer, where sokoban is
 */
inline char* sokoban_find_player() {
	char* a;

	// iterate through tvtext_buffer and search for sokoban or sokoban on target
	for (a = tvtext_buffer; a < tvtext_buffer + TVTEXT_BUFFER_WIDTH * TVTEXT_BUFFER_HEIGHT; a++) {
		if ((*a == FONT_SOKOBAN_PLAYER) || (*a == FONT_SOKOBAN_PLAYER_TARGET)) {
			return a;
		}
	}

	return NULL;
}

/**
 * Returns if level is cleared
 * @return uint8_t 1 if level is cleared (done), 0 otherwise
 */
inline uint8_t sokoban_is_level_cleared() {
	char* a;

	// iterate through tvtext buffer and return 0 if block, which is not on target is found
	for (a = tvtext_buffer; a < tvtext_buffer + TVTEXT_BUFFER_WIDTH * TVTEXT_BUFFER_HEIGHT; a++) {
		if (*a == FONT_SOKOBAN_BLOCK) {
			return 0;
		}
	}

	return 1;
}

/**
 * Process sokoban's move
 * @param int joypad joypad status
 */
inline void sokoban_move(int joypad) {
	// pointer to tile that sokoban stands on
	char* a;
	// pointer to tile where sokoban goes to
	char* b;
	// pointer to tile where sokoban pushes box
	char* c;

	// pointer offset to next tile (direction of sokoban's move)
	int8_t offset;

	// get offset according to sokoban's direction
	if (joypad & JOY_LEFT) {
		offset = SOKOBAN_OFFSET_LEFT;
	}
	if (joypad & JOY_RIGHT) {
		offset = SOKOBAN_OFFSET_RIGHT;
	}
	if (joypad & JOY_UP) {
		offset = SOKOBAN_OFFSET_UP;
	}
	if (joypad & JOY_DOWN) {
		offset = SOKOBAN_OFFSET_DOWN;
	}

	// restart level if FIRE1 is pressed
	if (joypad & JOY_FIRE1) {
		sokoban_load_level();
	}

	// return if no move should be processed
	if (!(joypad & (JOY_LEFT | JOY_RIGHT | JOY_UP | JOY_DOWN))) {
		return;
	}

	// search for sokoban and next 2 tiles in his way
	a = sokoban_find_player();
	b = a + offset;
	c = b + offset;

	// if sokoban can move that way...
	if (
		((*b >= FONT_SOKOBAN_FLOOR) && (*c >= FONT_SOKOBAN_FLOOR))
		&&
		(
				(*b <= FONT_SOKOBAN_TARGET)
				||
				((*b <= FONT_SOKOBAN_BLOCK_TARGET) && (*c <= FONT_SOKOBAN_TARGET))
		)
	) {
		// ... move him ...
		sokoban_moves++;
		sokoban_moves_level++;
		(*a) -= 6;
		// ... and if must push the block ...
		if (*b >= FONT_SOKOBAN_BLOCK) {
			// ... push it
			sokoban_pushes++;
			sokoban_pushes_level++;
			(*b) -= 2;
			(*c) += 2;
		}
		(*b) += 6;
	}

}

/**
 * Sokoban game
 */
void sokoban(void) {
	// joypad status
	uint8_t joypad;
	// temporary variable for reading level number to start at
	uint8_t tmp_level;

	// do the intro
	sokoban_intro();

	// move screen half-tile up to center the game
	tvtext_offset_y -= 8;

	// start new game
	sokoban_restart_game();

	// let player choose level to start at (multiply by rooms per level, to get level instead of room)
	tmp_level = sokoban_select_level() * SOKOBAN_ROOMS_PER_LEVEL;
	// skip to that level
	for (uint8_t i = 0; i < tmp_level; i++) {
		sokoban_load_level();
		sokoban_advance_level();
	}
	// load that level
	sokoban_load_level();
	// scroll game in
	scroll_in();

	// main game loop
	do {
		// read joypad status
		do {
			tvtext_wait_vsync();
			joypad = ~JOY_PIN & JOY_ALL;
		} while (joypad);
		do {
			tvtext_wait_vsync();
			joypad = ~JOY_PIN & JOY_ALL;
		} while (!joypad);

		// move sokoban
		sokoban_move(joypad);
		// refresh game statistics
		sokoban_draw_info();

		// if this move finished level, skip to next level
		if (sokoban_is_level_cleared()) {
			sokoban_congratulations();
			sokoban_advance_level();
			sokoban_load_level();
		}

	// FIRE2 ends the game
	} while (!(joypad & JOY_FIRE2));

	// return screen to original state
	tvtext_offset_y += 8;
	scroll_out();
	tvtext_clear();
	scroll_in_instant();
}
