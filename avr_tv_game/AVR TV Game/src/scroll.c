#include <stdint.h>
#include "tvtext/tvtext.h"

void scroll_out(void) {
	for (uint8_t scroll_out = 0; scroll_out < (128 + 8) / 2; ++scroll_out) {
		tvtext_wait_vsync();
		tvtext_offset_y += 4;
	}
}
void scroll_out_instant(void) {
	tvtext_offset_y += (128 + 8) * 2;
}
void scroll_in(void) {
	for (uint8_t scroll_in = 0; scroll_in < (128 + 8) / 2; ++scroll_in) {
		tvtext_wait_vsync();
		tvtext_offset_y -= 4;
	}
}
void scroll_in_instant(void) {
	tvtext_offset_y -= (128 + 8) * 2;
}
