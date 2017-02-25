#include <stdlib.h>
#include <string.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/pgmspace.h>

#include "tvtext/tvtext.h"
#include "fontchars.h"
#include "delay.h"
#include "joypad.h"
#include "level.h"
#include "rectangle.h"
#include "scroll.h"
#include "number.h"

#include "snakelogo.h"
#include "mazes.h"

// Position of the speed selection window.
#define SPEED_SELECT_LEFT 9
#define SPEED_SELECT_TOP  7

// Position of the maze selection window.
#define MAZE_SELECT_LEFT  4
#define MAZE_SELECT_TOP   2

// Position of the author text.
#define AUTHOR_TOP       11
#define AUTHOR_LEFT       4

// Defines the boundaries of the world.
#define WORLD_LEFT        0
#define WORLD_TOP         2
#define WORLD_RIGHT      23
#define WORLD_BOTTOM     15

// Defines the location of the score counter.
#define SCORE_LOCATION_RIGHT WORLD_RIGHT
#define SCORE_LOCATION_TOP   0

// The size of a maze data structure in bytes.
#define MAZE_SIZE_BYTES ((WORLD_BOTTOM - WORLD_TOP + 1) * ((WORLD_RIGHT - WORLD_LEFT + 8) / 8))

// Stores the position of the head.
int8_t head_x, head_y;

// Stores the movement vector of the snake's head.
int8_t head_dx, head_dy;

// Stores the position of the tail.
int8_t tail_x, tail_y;

// Advances the snake's head once unit.
void advance_head(void) {
	// Find the current snake head graphic.
	char old_snake_head = tvtext_buffer[head_y * TVTEXT_BUFFER_WIDTH + head_x];
	// Calculate the new snake head graphic.
	char snake_head = ' ';
	if (head_dy == 0) {
		snake_head = (head_dx > 0) ? FONT_SNAKE_HEAD_RIGHT : FONT_SNAKE_HEAD_LEFT;
	} else {
		snake_head = (head_dy > 0) ? FONT_SNAKE_HEAD_DOWN : FONT_SNAKE_HEAD_UP;
	}
	// Calculate the replacement body graphic to put under the old head.
	char body =  ' ';
	if (snake_head == old_snake_head) {
		// If the snake head graphic is the same this time around, we're moving in the same direction.
		body = (head_dy == 0) ? FONT_SNAKE_BODY_HORIZONTAL : FONT_SNAKE_BODY_VERTICAL;
	} else {
		// We need to insert a "bend".
		switch (old_snake_head) {
			case FONT_SNAKE_HEAD_UP:
				body = (snake_head == FONT_SNAKE_HEAD_LEFT) ? FONT_SNAKE_BODY_DOWN_LEFT : FONT_SNAKE_BODY_DOWN_RIGHT;
				break;
			case FONT_SNAKE_HEAD_DOWN:
				body = (snake_head == FONT_SNAKE_HEAD_LEFT) ? FONT_SNAKE_BODY_UP_LEFT : FONT_SNAKE_BODY_UP_RIGHT;
				break;
			case FONT_SNAKE_HEAD_LEFT:
				body = (snake_head == FONT_SNAKE_HEAD_UP) ? FONT_SNAKE_BODY_UP_RIGHT : FONT_SNAKE_BODY_DOWN_RIGHT;
				break;
			case FONT_SNAKE_HEAD_RIGHT:
				body = (snake_head == FONT_SNAKE_HEAD_UP) ? FONT_SNAKE_BODY_UP_LEFT : FONT_SNAKE_BODY_DOWN_LEFT;
				break;
		}
	}
	tvtext_buffer[head_y * TVTEXT_BUFFER_WIDTH + head_x] = body;

	// Move the snake.
	head_x += head_dx;
	if (head_x > WORLD_RIGHT) head_x = WORLD_LEFT;
	if (head_x < WORLD_LEFT) head_x = WORLD_RIGHT;

	head_y += head_dy;
	if (head_y > WORLD_BOTTOM) head_y = WORLD_TOP;
	if (head_y < WORLD_TOP) head_y = WORLD_BOTTOM;

	// Draw the new head.
	tvtext_buffer[head_y * TVTEXT_BUFFER_WIDTH + head_x] = snake_head;

}

inline void advance_tail(void) {
	// Find the current snake tail graphic.
	char tail = tvtext_buffer[tail_y * TVTEXT_BUFFER_WIDTH + tail_x];
	// Where is the body in relation to the tail?
	int8_t body_x = tail_x, body_y = tail_y;
	switch (tail) {
		case FONT_SNAKE_TAIL_UP:
			--body_y;
			break;
		case FONT_SNAKE_TAIL_DOWN:
			++body_y;
			break;
		case FONT_SNAKE_TAIL_LEFT:
			--body_x;
			break;
		case FONT_SNAKE_TAIL_RIGHT:
			++body_x;
			break;
	}
	// Ensure the body is on the buffer.
	if (body_x < WORLD_LEFT) body_x = WORLD_RIGHT;
	if (body_x > WORLD_RIGHT) body_x = WORLD_LEFT;
	if (body_y < WORLD_TOP) body_y = WORLD_BOTTOM;
	if (body_y > WORLD_BOTTOM) body_y = WORLD_TOP;
	// Find the current body graphic.
	char body = tvtext_buffer[body_y * TVTEXT_BUFFER_WIDTH + body_x];
	// Is it a bend? If so, we'll need to rotate the tail graphic.
	switch (body) {
		case FONT_SNAKE_BODY_DOWN_RIGHT:
			tail = (tail == FONT_SNAKE_TAIL_UP) ? FONT_SNAKE_TAIL_RIGHT : FONT_SNAKE_TAIL_DOWN;
			break;
		case FONT_SNAKE_BODY_DOWN_LEFT:
			tail = (tail == FONT_SNAKE_TAIL_UP) ? FONT_SNAKE_TAIL_LEFT : FONT_SNAKE_TAIL_DOWN;
			break;
		case FONT_SNAKE_BODY_UP_RIGHT:
			tail = (tail == FONT_SNAKE_TAIL_DOWN) ? FONT_SNAKE_TAIL_RIGHT : FONT_SNAKE_TAIL_UP;
			break;
		case FONT_SNAKE_BODY_UP_LEFT:
			tail = (tail == FONT_SNAKE_TAIL_DOWN) ? FONT_SNAKE_TAIL_LEFT : FONT_SNAKE_TAIL_UP;
			break;
	}
	// Erase the old tail.
	tvtext_buffer[tail_y * TVTEXT_BUFFER_WIDTH + tail_x] = tvtext_cleared;
	// Draw the new tail.
	tail_x = body_x;
	tail_y = body_y;
	tvtext_buffer[tail_y * TVTEXT_BUFFER_WIDTH + tail_x] = tail;
}

// Add a food pellet at a random location on the board.
void add_food(void) {
	uint8_t food_x, food_y;
	do {
		food_x = WORLD_LEFT + rand() % (WORLD_RIGHT - WORLD_LEFT + 1);
		food_y = WORLD_TOP + rand() % (WORLD_BOTTOM - WORLD_TOP + 1);
	} while (tvtext_buffer[food_y * TVTEXT_BUFFER_WIDTH + food_x] != tvtext_cleared);
	tvtext_buffer[food_y * TVTEXT_BUFFER_WIDTH + food_x] = FONT_SNAKE_FOOD;
}

// Load a maze.
inline void load_maze(uint8_t maze_number) {
	tvtext_clear();
	if (maze_number == 0) return;
	--maze_number;
	for (uint8_t i = 0; i < MAZE_SIZE_BYTES; ++i) {
		uint8_t maze_bits = pgm_read_byte(mazes + i + maze_number * MAZE_SIZE_BYTES);
		for (uint8_t b = 0; b < 8; ++b) {
			if (bit_is_set(maze_bits, 7)) {
				tvtext_buffer[i * 8 + b + WORLD_LEFT + WORLD_TOP * TVTEXT_BUFFER_WIDTH] = FONT_BLOCK_100;
			}
			maze_bits <<= 1;
		}
	}
}

void draw_maze_preview(uint8_t maze) {
	// Draw a preview of the maze.
	tvtext_wait_vsync();
	if (maze == 0) {
		for (uint8_t r = WORLD_TOP / 2; r <= WORLD_BOTTOM / 2; ++r) {
			for (uint8_t c = WORLD_LEFT / 2; c <= WORLD_RIGHT / 2; ++c) {
				tvtext_buffer[(r + MAZE_SELECT_TOP + 1 - WORLD_TOP / 2) * TVTEXT_BUFFER_WIDTH + (c + MAZE_SELECT_LEFT + 1 - WORLD_LEFT / 2)] = FONT_QUARTER_BLOCK_JOINED;
			}
		}
	} else {
		for (uint8_t r = WORLD_TOP; r <= WORLD_BOTTOM; ++r) {
			for (uint8_t c = WORLD_LEFT; c <= WORLD_RIGHT; ++c) {
				uint16_t character_offset = (r / 2 + MAZE_SELECT_TOP + 1 - WORLD_TOP / 2) * TVTEXT_BUFFER_WIDTH + (c / 2 + MAZE_SELECT_LEFT + 1 - WORLD_LEFT / 2);
				if (((r | c) & 1) == 0) tvtext_buffer[character_offset] = FONT_QUARTER_BLOCK_JOINED;
				tvtext_buffer[character_offset] += (((pgm_read_byte(mazes + (maze - 1) * MAZE_SIZE_BYTES + (r - WORLD_TOP) * ((WORLD_RIGHT - WORLD_LEFT + 8) / 8) + (c - WORLD_LEFT) / 8) >> (7 - (c & 7))) & 1) << (((1 - c) & 1) + ((r & 1) * 2)));
			}
		}
	}
	tvtext_cleared = ' ';
}

void snake(void) {

	// Start from a blank slate.
	tvtext_clear();

	uint16_t logo_byte_offset = 0;

	// Read the snake's head type and position.
	char head;
	while ((head = pgm_read_byte(snake_logo + logo_byte_offset++))) {
		head_x = pgm_read_byte(snake_logo + logo_byte_offset++);
		head_y = pgm_read_byte(snake_logo + logo_byte_offset++);
		// Draw the head.
		tvtext_buffer[head_y * TVTEXT_BUFFER_WIDTH + head_x] = head;
		// Append the tail.
		switch (head) {
			case FONT_SNAKE_HEAD_LEFT:
				head_dx = -1; head_dy = 0;
				tvtext_buffer[(head_y + 0) * TVTEXT_BUFFER_WIDTH + head_x + 1] = FONT_SNAKE_TAIL_LEFT;
				break;
			case FONT_SNAKE_HEAD_RIGHT:
				head_dx = +1; head_dy = 0;
				tvtext_buffer[(head_y + 0) * TVTEXT_BUFFER_WIDTH + head_x - 1] = FONT_SNAKE_TAIL_RIGHT;
				break;
			case FONT_SNAKE_HEAD_UP:
				head_dx = 0; head_dy = -1;
				tvtext_buffer[(head_y + 1) * TVTEXT_BUFFER_WIDTH + head_x + 0] = FONT_SNAKE_TAIL_UP;
				break;
			case FONT_SNAKE_HEAD_DOWN:
				head_dx = 0; head_dy = +1;
				tvtext_buffer[(head_y - 1) * TVTEXT_BUFFER_WIDTH + head_x + 0] = FONT_SNAKE_TAIL_DOWN;
				break;
		}

		uint8_t logo_bit_offset = 0;
		uint8_t finished_letter = 0;
		while (!finished_letter) {
			int8_t swap = 0;
			// Are we rotating, going straight, or hitting the end?
			switch ((pgm_read_byte(snake_logo + logo_byte_offset) >> (6 - logo_bit_offset)) & 0b11) {
				case 0b00: // Straight ahead.
					break;
				case 0b01: // Turn left.
					swap = head_dx;
					head_dx = head_dy;
					head_dy = -swap;
					break;
				case 0b10: // Turn right.
					swap = head_dy;
					head_dy = head_dx;
					head_dx = -swap;
					break;
				case 0b11: // Finished!
					finished_letter = 1;
					logo_bit_offset = 6; // We want to skip into the next byte when we exit this function.
					break;
			}
			// If we haven't finished, advance the head.
			if (!finished_letter) {
				delay_ms(60);
				advance_head();
			}
			logo_bit_offset = (logo_bit_offset + 2) % 8;
			if (logo_bit_offset == 0) ++logo_byte_offset;
		}
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

	// Stores the selected maze and speed.
	uint8_t maze = 1;
	uint8_t speed = 0;

	for (;;) {

		scroll_out();

		tvtext_clear();
		tvtext_cursor_move(MAZE_SELECT_LEFT + 5, MAZE_SELECT_TOP - 1);
		tvtext_puts_P(PSTR("Maze"));
		do {
			// Allow the user to pick a maze.
			tvtext_wait_vsync();

			draw_rounded_rectangle(MAZE_SELECT_LEFT, MAZE_SELECT_TOP, MAZE_SELECT_LEFT + (WORLD_RIGHT - WORLD_LEFT + 1) / 2 + 1, MAZE_SELECT_TOP + (WORLD_BOTTOM - WORLD_TOP + 1) / 2 + 1);
			draw_maze_preview(maze);

			if (tvtext_offset_y != 0) scroll_in();

			// Preload the old_joypad value.
			uint8_t old_joypad = ~JOY_PIN & JOY_ALL;
			uint8_t joypad;
			uint8_t old_maze = maze;
			do {

				// Grab the joystick state.
				joypad = ~JOY_PIN & JOY_ALL;
				if (joypad != old_joypad) {
					old_joypad= joypad;
				} else {
					joypad = 0;
				}

				// Pick the next maze.
				switch (joypad & (JOY_LEFT | JOY_RIGHT | JOY_UP | JOY_DOWN)) {
					case JOY_LEFT:
					case JOY_UP:
						maze += (MAZE_COUNT - 1);
						break;
					case JOY_RIGHT:
					case JOY_DOWN:
						++maze;
						break;
				}
				if (maze != old_maze) {
					maze %= MAZE_COUNT;
					draw_maze_preview(maze);
					old_maze = maze;
				}

				// If we've hit FIRE2, exit the snake game.
				if (joypad & JOY_FIRE2) {
					scroll_out();
					tvtext_clear();
					tvtext_offset_y -= (128 + 8) * 2;
					return;
				}

			} while (!(joypad & JOY_FIRE1));

			// Allow the user to pick their speed.
			tvtext_cursor_move(SPEED_SELECT_LEFT + 4, SPEED_SELECT_TOP + 7);
			tvtext_puts_P(PSTR("Speed"));
			draw_level_select_form(SPEED_SELECT_LEFT, SPEED_SELECT_TOP);
		} while (!(process_level_select_form(&speed, SPEED_SELECT_LEFT, SPEED_SELECT_TOP) & JOY_FIRE1));

		do {
			// Scroll out before loading.
			scroll_out();

			// Main game starts under here.

			// Load the maze.
			load_maze(maze);

			// Add a dummy score counter.
			draw_right_number(0, SCORE_LOCATION_RIGHT, SCORE_LOCATION_TOP);
			// Draw a line under the score.
			memset(tvtext_buffer + (WORLD_TOP - 1) * TVTEXT_BUFFER_WIDTH, FONT_ANIMATED_RECTANGLE_HORIZONTAL, TVTEXT_BUFFER_WIDTH);

			// Initialise the snake.
			head_x =  5; head_y = WORLD_BOTTOM - 2;
			head_dx = 1; head_dy = 0;
			tail_x = head_x - 2; tail_y = head_y;
			// Draw the initial snake.
			tvtext_buffer[head_y * TVTEXT_BUFFER_WIDTH + head_x - 0] = FONT_SNAKE_HEAD_RIGHT;
			tvtext_buffer[head_y * TVTEXT_BUFFER_WIDTH + head_x - 1] = FONT_SNAKE_BODY_HORIZONTAL;
			tvtext_buffer[head_y * TVTEXT_BUFFER_WIDTH + head_x - 2] = FONT_SNAKE_TAIL_RIGHT;

			// Add some food.
			srand(tvtext_frame_counter);
			add_food();

			// Scroll the level in.
			scroll_in();

			// Use the "previous" head tracking variables to prevent the user from going back on themselves.
			int8_t previous_head_dx, previous_head_dy;
			previous_head_dx = head_dx;
			previous_head_dy = head_dy;

			// Set the speed of the snake.
			uint8_t speed_period = (10 - speed) * 2;

			// Initialise the movement timer.
			uint8_t advance_head_delay = speed_period * 2;

			// Flag set when the game is over.
			uint8_t game_over = 0;

			// Score.
			uint32_t score = 0;

			// Main game loop.
			while (!game_over) {
				tvtext_wait_vsync();

				// Is it time to move the snake?
				if (--advance_head_delay == 0) {
					// What's under the snake's new head?
					int8_t new_head_x = head_x + head_dx, new_head_y = head_y + head_dy;
					if (new_head_x < WORLD_LEFT) new_head_x = WORLD_RIGHT;
					if (new_head_x > WORLD_RIGHT) new_head_x = WORLD_LEFT;
					if (new_head_y < WORLD_TOP) new_head_y = WORLD_BOTTOM;
					if (new_head_y > WORLD_BOTTOM) new_head_y = WORLD_TOP;
					char under_head = tvtext_buffer[new_head_y * TVTEXT_BUFFER_WIDTH + new_head_x];
					if (under_head == tvtext_cleared || (under_head >= FONT_SNAKE_TAIL_LEFT && under_head <= FONT_SNAKE_TAIL_DOWN)) {
						// We're moving into empty space/tail. Advance the snake!
						advance_tail();
						advance_head();
					} else if (under_head == FONT_SNAKE_FOOD) {
						// We're eating some food.
						score += (speed + 1);
						draw_right_number(score, SCORE_LOCATION_RIGHT, SCORE_LOCATION_TOP);
						advance_head();
						add_food();
					} else {
						// We've hit something that's not food or empty space. Game over, man, game over!
						game_over = 1;
						advance_head();
						if (under_head == FONT_BLOCK_100) {
							tvtext_buffer[head_y * TVTEXT_BUFFER_WIDTH + head_x] = FONT_BLOCK_100;
						}
					}
					// Reset the delay counter and store the current movement vector.
					previous_head_dx = head_dx;
					previous_head_dy = head_dy;
					advance_head_delay = speed_period;
				}

				// Handle joypad input.
				uint8_t joypad = ~JOY_PIN & JOY_ALL;
				switch (joypad & (JOY_UP | JOY_DOWN | JOY_LEFT | JOY_RIGHT)) {
					case JOY_UP:
						if (previous_head_dy == 0) {
							head_dy = -1;
							head_dx = 0;
						}
						break;
					case JOY_DOWN:
						if (previous_head_dy == 0) {
							head_dy = +1;
							head_dx = 0;
						}
						break;
					case JOY_LEFT:
						if (previous_head_dx == 0) {
							head_dx = -1;
							head_dy = 0;
						}
						break;
					case JOY_RIGHT:
						if (previous_head_dx == 0) {
							head_dx = +1;
							head_dy = 0;
						}
						break;
				}
			}
			// Game over!
			delay_ms(100);
			tvtext_flags ^= _BV(TVTEXT_INVERTED);
			delay_ms(100);
			tvtext_flags ^= _BV(TVTEXT_INVERTED);
		
			// Wait for all keys to be released.
			while (~PINC & JOY_ALL);
			// Wait for the fire key to be pressed.
			while (!(~PINC & (JOY_FIRE1 | JOY_FIRE2)));
		} while (!(~PINC & JOY_FIRE2));
	}
}
