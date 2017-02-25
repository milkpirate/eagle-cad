#ifndef _SMATRIX_H
#define _SMATRIX_H

#include <inttypes.h>

#define WITH_BELL
#define PUMP_DIRECT
#define PULSE_PERIOD	5
#define FIXED_BURST	100
#define DEBOUNCE	200
#define CALSAMPLES	16
#define VERBOSE

#define X0 0x10	// PORTD.4
#define X1 0x08 // PORTD.3
#define X2 0x04 // PORTD.2
#define X3 0x80 // PORTD.7
#define X4 0x01 // PORTB.0 - port B!
#define X_N 4
#define Y_N 3



void smatrix_init();
void smatrix_scan();
uint8_t smatrix_haschar();
uint8_t smatrix_getchar();

#endif