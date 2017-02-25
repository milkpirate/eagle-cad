#include <inttypes.h>
#include <avr/io.h>
#include <avr/delay.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <avr/pgmspace.h>
#include <stdio.h>
#include <stdlib.h>

#include "smatrix.h"

static volatile uint8_t*	drive_port;			// port to drive
static volatile uint8_t  	drive_bv;				// bit value to toggle

static volatile uint16_t 	drive_length;		// calibration value, pump this many times
static volatile uint16_t	drive_pulse_time; 	// drive pulse length

static volatile uint16_t	drive_ctr;			// current pump counter

static volatile uint8_t	y_bv_hi;
static volatile uint8_t	y_bv_lo;
static volatile uint8_t	y_admux;

static volatile uint8_t 	ac_captured;

static volatile int16_t 	measured;
static volatile int16_t   	measured_last;

static volatile uint8_t 	calibrating;

static volatile uint8_t 	scan_x, scan_y;

#define nop() asm volatile("nop"::)

static const int ROW2BIT[X_N] = {X0,X1,X2,X3,X4};

static const char KEYMAP[] = {'4','5', '6', '7', '8', '9', '*', '0', '#', '1', '2', '3'};


// Calibration info

// relaxed value of every key measured during calibration
int16_t cal_y_sense[Y_N][X_N];	// baseline for every key

// this many pulses to drive this nth sense capacitor
int16_t cal_y_burst[Y_N];

// translate drive row number into output port/output bit
static void translate_io(uint8_t row) {
	drive_port = (row < 4) ? &PORTD : &PORTB;//(volatile uint8_t *) ((row < 4) ? PORTD : PORTB);
	drive_bv = ROW2BIT[row];
}

static void timer1_startPumping() {
#ifdef PUMP_DIRECT
	// in direct pump mode timer is not working
#else 
	TCCR1A = 0b00000000; 				// OC1A/OC1B off, WGM11:WGM10 = 0
	TCCR1B = _BV(ICNC1) | _BV(WGM12); 	// CTC mode
	OCR1A = PULSE_PERIOD;
	TIFR |= _BV(TOV1);		// clear overflow bit
	TIMSK = _BV(OCIE1A); 	//_BV(TOIE1); 	// enable overflow interrupt

	TCCR1B |= 0b001; 		// enable clock source, start it
#endif	
}

// select sensing pair of lines
static void select_y(uint8_t y) {
	y_bv_hi = 1 << (y<<1);
	y_bv_lo = y_bv_hi << 1;
	y_admux = (y<<1) + 1;
	drive_length = cal_y_burst[y];
	PORTC = 0;
	DDRC = 0xff;	
}

// select X line and initiate charge pumping
static void pump_x(uint8_t x) {
	translate_io(x);
	
	//printf("x=%x yh=%x yl=%x mx=%x\n", drive_bv, y_bv_hi, y_bv_lo, y_admux);
	
	PORTC = 0;
	PORTB &= ~_BV(1); 	// no slope
	DDRB  &= ~_BV(1);  // PB1 = Z
	drive_ctr = drive_length;

#ifdef PUMP_DIRECT
	for (drive_ctr = drive_length; --drive_ctr > 0; ) {
		DDRC &= ~y_bv_hi; 		// top is tris
		DDRC |= y_bv_lo; 		// bottom is gnd
			
		*drive_port |= drive_bv;

		DDRC &= ~y_bv_lo;		// bottom is tris
		DDRC |= y_bv_hi;		// top is gnd
		*drive_port &= ~drive_bv;
	}
#else
	timer1_startPumping();
#endif	
}

// initiate measurement
// SIG_INPUT_CAPTURE1 happens when zero is crossed, 
// measured value will be stored in 'measured'
static void measure() {
	ac_captured = 0;
	
	//TCCR1B = _BV(ICNC1);		// input capture noise canceler, stop timer

	ADMUX = y_admux;			// select ADMUX
	SFIOR |= _BV(ACME);			// enable admux
	// Analog Comparator input capture enable
	ACSR = _BV(ACIC); 
	
	ICR1 = 0;
	TCNT1 = 0;
	TIFR &= ~_BV(ICF1);			// clear input capture bit	
	TIMSK = _BV(TICIE1); 			// enable input capture interrupt
	TCCR1A = 0b00000000;			// Timer1 normal mode
	TCCR1B = _BV(ICNC1) | 0b001;	// noise canceller, input capture on negative edge, go
	
	PORTB |= _BV(1);				// enable slope
	DDRB  |= _BV(1);  				// PB1 = +Vdd
}


static void recalibrate() {
	uint8_t i,j;
	
	for(i = 0; i < Y_N; i++) {
		cal_y_burst[i] = 16;
		for (j = 0; j < X_N; j++) {
			cal_y_sense[i][j] = 1;
		}
	}
#ifdef FIXED_BURST
	drive_length = FIXED_BURST;
#else
	drive_length = 16;
#endif	
	scan_y = 0;
	scan_x = 0;
	measured_last = 0;

	calibrating = 1;
	
#ifdef VERBOSE
	printf_P(PSTR("Recalibrate\n"));
#endif	
}

static volatile uint16_t wtemp;
static volatile uint8_t keycode;

static uint8_t keychar;
static uint8_t keychar_avail;


void smatrix_init() {
	PORTC = 0; // no pullups on port C, ever
	
	// ADC disable
	ADCSRA = 0;
	
	// Analog Comparator: input capture enable
	ACSR = _BV(ACIC); 
	
	TCCR1A = 0b00000000;			// Timer1
	TCCR1B = _BV(ICNC1);			// noise canceller on, stop
	
	keycode = 255;
	keychar = 0;
	keychar_avail = 0;
	
	recalibrate();
}

void smatrix_scan() {
	static uint8_t foul_count = 0;
	static uint8_t lastkeycode = 255;
	static uint8_t nsample = CALSAMPLES;
	static uint8_t deadtime = DEBOUNCE;

	select_y(scan_y);
	pump_x(scan_x);
	for(wtemp=32767; --wtemp && drive_ctr != 0;);		// wait until pumped if in timer pump mode

	measure();
	for(wtemp=32767; --wtemp && ac_captured == 0;);	// wait until capture
#ifdef DEBUG		
	printf("%d %d\n", measured, cal_y_sense[scan_y]);
#endif		
	if (measured >= cal_y_sense[scan_y][0]/2) {
		foul_count = 0;
		switch (calibrating) {
			// calibrate burst drive length (cal_y_burst) and y sense baseline (cal_y_sense)
		case 1: 
#ifdef FIXED_BURST
			cal_y_burst[scan_y] = FIXED_BURST;
			nsample = CALSAMPLES;
			calibrating = 2;
#else			
			if (abs(measured_last - measured) < measured/100) {
				nsample = CALSAMPLES;
				calibrating = 2;
			} else {
				cal_y_burst[scan_y] += 16;
			}
#endif				
			measured_last = measured;
			break;
		case 2:
			measured_last = (measured_last + measured)/2;
			if (--nsample == 0) {
				cal_y_sense[scan_y][scan_x] = (measured_last + measured)/2;
				scan_x = (scan_x + 1) % X_N;
				nsample = CALSAMPLES;
				
				if (scan_x == 0) {
					scan_y = (scan_y+1) % Y_N;
					if (scan_y == 0) {
						// all done
						calibrating = 0;
#ifdef VERBOSE							
						printf_P(PSTR("Calibrated\n"));
						for (scan_x = 0; scan_x < X_N; scan_x++) {
							for (scan_y = 0; scan_y < Y_N; scan_y++) {
								printf_P(PSTR("%d "), cal_y_sense[scan_y][scan_x]);
							}
							printf_P(PSTR("\n"));
						}
						scan_x = 0;
						scan_y = 0;
#endif							
					} else {
						// calibrating, next Y
						measured_last = 0;
						drive_length = 16;
						calibrating = 1;
					}
				}
			}
			
			break;
			
		case 16:
			// skip a cycle
			calibrating = 0;
			break;
			
		case 0:
		default:
		
			wtemp = cal_y_sense[scan_y][scan_x];
			if (abs(measured - wtemp) > wtemp/11) {	
#ifdef DEBUG				
				printf("[%02x] %d\n", (scan_x<<4) + scan_y, measured);
#endif					
				keycode = scan_x*3 + scan_y;
			}
			
			scan_x = (scan_x+1) % X_N;
			if (scan_x == 0) {
				scan_y = (scan_y+1) % Y_N;
				// 1-scan time delay 
				calibrating = 16;
			}
			
			if (scan_x == 0 && scan_y == 0) {
				if (deadtime == 0 && keycode != 255) {
					//LED(1,16);
					if (lastkeycode != keycode) {
						keychar = KEYMAP[keycode];
						keychar_avail = 1;
					}
				} else {
					if (lastkeycode != keycode) {
						//LED(0,0);
						deadtime = DEBOUNCE;
#ifdef RELEASE_CHAR							
						printf("^");
#endif							
					}
				}
				lastkeycode = keycode;
				keycode = 255;
			}
		}
	}
	if (deadtime != 0) deadtime--;
}

uint8_t smatrix_getchar() {
	if (keychar_avail) {
		keychar_avail = 0;
		return keychar;
	}
	return 255;
}

uint8_t smatrix_haschar() {
	return keychar_avail;
}

//--
void SIG_INPUT_CAPTURE1( void ) __attribute__ ( ( signal ) );  
void SIG_INPUT_CAPTURE1( void ) {
	SFIOR &= ~_BV(ACME);	// disable admux
	// magic
	ACSR &= ~_BV(ACIC); 	// disable AC capture input
	DDRC = 0xFF;			// drain all
	PORTB &= ~_BV(1); 		// slope to gnd
	
	ac_captured = 1;
	measured = ICR1;
	TIMSK &= ~_BV(TICIE1); 		
	TCCR1B = 0b00000000;
}


void SIG_OUTPUT_COMPARE1A( void ) __attribute__ ( ( signal ) );  
void SIG_OUTPUT_COMPARE1A( void ) {
#ifdef PUMP_DIRECT
	// nothing
#else
	DDRC &= ~y_bv_hi; 		// top is tris
	DDRC |= y_bv_lo; 	// bottom is gnd
		
	*drive_port |= drive_bv;

	DDRC &= ~y_bv_lo;	// bottom is tris
	DDRC |= y_bv_hi;		// top is gnd
	*drive_port &= ~drive_bv;

	if (--drive_ctr == 0) {
		// end of burst: end drive, enable slope, enter capture mode			
		TIMSK &= ~_BV(OCIE1A); 	// disable overflow interrupt
	}
#endif
}

