#ifndef _RECTANGLE_H_
#define _RECTANGLE_H_

#include <stdint.h>

// Draws an "animated" rectangle.
void draw_animated_rectangle(uint8_t left, uint8_t top, uint8_t right, uint8_t bottom, uint8_t scroll_offset);

// Draws a rounded rectangle.
void draw_rounded_rectangle(uint8_t left, uint8_t top, uint8_t right, uint8_t bottom);

// Clears an animated or rounded rectangle.
void clear_rectangle(uint8_t left, uint8_t top, uint8_t right, uint8_t bottom);

#endif
