#include <string.h>

#include "tvtext/tvtext.h"

#include "fontchars.h"
#include "rectangle.h"

// Draws an "animated" rectangle.
void draw_animated_rectangle(uint8_t left, uint8_t top, uint8_t right, uint8_t bottom, uint8_t scroll_offset) {
	scroll_offset &= 3;
	// Top.
	memset(tvtext_buffer + top * TVTEXT_BUFFER_WIDTH + left + 1, FONT_ANIMATED_RECTANGLE_HORIZONTAL + scroll_offset, right - left - 1);
	// Bottom.
	memset(tvtext_buffer + bottom * TVTEXT_BUFFER_WIDTH + left + 1, FONT_ANIMATED_RECTANGLE_HORIZONTAL + (-scroll_offset & 3), right - left - 1);
	{
		char* p = tvtext_buffer + (top + 1) * TVTEXT_BUFFER_WIDTH + left;
		for (uint8_t row = top + 1; row < bottom; ++row, p += TVTEXT_BUFFER_WIDTH) {
			// Left.
			*p = FONT_ANIMATED_RECTANGLE_VERTICAL + (-scroll_offset & 3);
			// Right.
			*(p + (right - left)) = FONT_ANIMATED_RECTANGLE_VERTICAL + scroll_offset;
		}
	}
	// Corners.
	tvtext_buffer[top * TVTEXT_BUFFER_WIDTH + left] = FONT_ANIMATED_RECTANGLE_TOP_LEFT + scroll_offset;
	tvtext_buffer[top * TVTEXT_BUFFER_WIDTH + right] = FONT_ANIMATED_RECTANGLE_TOP_RIGHT + scroll_offset;
	tvtext_buffer[bottom * TVTEXT_BUFFER_WIDTH + left] = FONT_ANIMATED_RECTANGLE_BOTTOM_LEFT + scroll_offset;
	tvtext_buffer[bottom * TVTEXT_BUFFER_WIDTH + right] = FONT_ANIMATED_RECTANGLE_BOTTOM_RIGHT + scroll_offset;
}

// Draws a rounded rectangle.
void draw_rounded_rectangle(uint8_t left, uint8_t top, uint8_t right, uint8_t bottom) {
	memset(tvtext_buffer + top * TVTEXT_BUFFER_WIDTH + left + 1, FONT_ROUNDED_RECTANGLE_TOP, right - left - 1);
	memset(tvtext_buffer + bottom * TVTEXT_BUFFER_WIDTH + left + 1, FONT_ROUNDED_RECTANGLE_BOTTOM, right - left - 1);
	{
		char* p = tvtext_buffer + (top + 1) * TVTEXT_BUFFER_WIDTH + left;
		for (uint8_t row = top + 1; row < bottom; ++row, p += TVTEXT_BUFFER_WIDTH) {
			*p = FONT_ROUNDED_RECTANGLE_LEFT;
			*(p + (right - left)) = FONT_ROUNDED_RECTANGLE_RIGHT;
		}
	}
	tvtext_buffer[top * TVTEXT_BUFFER_WIDTH + left] = FONT_ROUNDED_RECTANGLE_TOP_LEFT;
	tvtext_buffer[top * TVTEXT_BUFFER_WIDTH + right] = FONT_ROUNDED_RECTANGLE_TOP_RIGHT;
	tvtext_buffer[bottom * TVTEXT_BUFFER_WIDTH + left] = FONT_ROUNDED_RECTANGLE_BOTTOM_LEFT;
	tvtext_buffer[bottom * TVTEXT_BUFFER_WIDTH + right] = FONT_ROUNDED_RECTANGLE_BOTTOM_RIGHT;
}

// Clears an animated or rounded rectangle.
void clear_rectangle(uint8_t left, uint8_t top, uint8_t right, uint8_t bottom) {
	memset(tvtext_buffer + top * TVTEXT_BUFFER_WIDTH + left, tvtext_cleared, right - left + 1);
	memset(tvtext_buffer + bottom * TVTEXT_BUFFER_WIDTH + left, tvtext_cleared, right - left + 1);
	{
		char* p = tvtext_buffer + top * TVTEXT_BUFFER_WIDTH + left;
		for (uint8_t row = top; row <= bottom; ++row, p += TVTEXT_BUFFER_WIDTH) {
			*p = tvtext_cleared;
			*(p + (right - left)) = tvtext_cleared;
		}
	}
}
