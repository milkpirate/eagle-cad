#ifndef _SNAKELOGO_H_
#define _SNAKELOGO_H_

#include <avr/pgmspace.h>
#include "fontchars.h"

#define SNAKE_LOGO_TOP  4
#define SNAKE_LOGO_LEFT 3

const uint8_t snake_logo[] PROGMEM = {
	// S
	FONT_SNAKE_HEAD_LEFT, SNAKE_LOGO_LEFT + 0, SNAKE_LOGO_TOP + 2,
	0b01010001, // Left, Left, Forwards, Left,
	0b00010010, // Forwards, Left, Fowards, Right,
	0b10001100, // Right, Forwards, Stop.
	// N
	FONT_SNAKE_HEAD_UP, SNAKE_LOGO_LEFT + 4, SNAKE_LOGO_TOP + 2,
	0b00001010, // Forwards, Forwards, Right, Right,
	0b00000101, // Forwards, Forwards, Left, Left,
	0b00001111, // Forwards, Forwards, Stop.
	// A
	FONT_SNAKE_HEAD_RIGHT, SNAKE_LOGO_LEFT + 9, SNAKE_LOGO_TOP + 0,
	0b00100000, // Forwards, Right, Forwards, Forwards,
	0b10001000, // Right, Forwards, Right, Forwards,
	0b10111111, // Stop.
	// K |
	FONT_SNAKE_HEAD_UP, SNAKE_LOGO_LEFT + 12, SNAKE_LOGO_TOP + 2,
	0b00001111, // Forwards, Forwards, Stop.
	// K <
	FONT_SNAKE_HEAD_DOWN, SNAKE_LOGO_LEFT + 14, SNAKE_LOGO_TOP + 1,
	0b10010110, // Right, Left, Left, Right,
	0b11111111, // Stop.
	// E
	FONT_SNAKE_HEAD_RIGHT, SNAKE_LOGO_LEFT + 18, SNAKE_LOGO_TOP + 1,
	0b01010001, // Left, Left, Forwards, Left,
	0b00011001, // Forwards, Left, Right, Left,
	0b11111100, // Stop.
	// Underline
	FONT_SNAKE_HEAD_LEFT, SNAKE_LOGO_LEFT + 17, SNAKE_LOGO_TOP + 4,
	0b00000000, // Forwards x4,
	0b00000000, // Forwards x4,
	0b00000000, // Forwards x4,
	0b00000000, // Forwards x4,
	0b00111111, // Forwards, Stop.
	// End.
	0
};

#endif
