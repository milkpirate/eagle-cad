//!\file

#include <inttypes.h>
#include <avr/io.h>
#include <avr/delay.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <avr/pgmspace.h>
#include <stdio.h>
#include <stdlib.h>


#include "usrat.h"
#include "smatrix.h"


void init_io() {
	DDRC=0xff;	// outputs
	DDRD=0xff;
	DDRB=0xff;
	PORTC = 0x00;
	PORTD = 0x00;
}


static volatile uint16_t LED_time;
#define LED(x,t)	{ if (x) { PORTD |= 32; LED_time = t;} else { PORTD &= ~32; } }

int main() {
	uint8_t i;
	uint8_t cycle;
	char c;
	
	init_io();

	LED(1, 64);

	set_sleep_mode(SLEEP_MODE_IDLE);

    usart_init((F_CPU/(16*38400))-1);
	
    printf_P(PSTR("\033[2J\033[HJA OPERATOR\n"));

	
	smatrix_init();

	sei();
	
	for (cycle = 0;;cycle++) {
		if (uart_available()) {
			switch (c = uart_getc()) {
				case 'c':
					smatrix_init();
					break;
				default:
					uart_putchar(c);
					break;
			}
		}		
		
		if (LED_time != 0) {
			if (--LED_time == 0) {
				LED(0,0);
			}
		}
		
		smatrix_scan();

		if (smatrix_haschar()) {
			LED(1,16);
			uart_putchar(smatrix_getchar());
#ifdef WITH_BELL 							
			uart_putchar('\007');
#endif							
		}
		
	}
	
	return 0;
}

// $Id$
