#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "tvtext/tvtext.h"

// Draws a right-aligned number.
void draw_right_number(uint32_t number, uint8_t right, uint8_t top) {
	char number_s[10];
	ltoa(number, number_s, 10);
	tvtext_cursor_move(right - strlen(number_s) + 1, top);
	tvtext_puts(number_s);
}
