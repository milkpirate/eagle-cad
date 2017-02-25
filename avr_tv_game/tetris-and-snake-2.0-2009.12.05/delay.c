#include "tvtext/tvtext.h"

// Wait for a particular number of ms.
void delay_ms(int ms) {
	ms /= 20; // At 50 frames per second, there are 20ms per frame.
	while (ms-- > 0) tvtext_wait_vsync();
}
