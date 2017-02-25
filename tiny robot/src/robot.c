/* -----------------------------------------------------------------------
 * Title:    tiny braitenberg
 * Author:   Alexander Weber <alex@tinkerlog.com>
 *           http://tinkerlog.com
 * Date:     24.07.2009
 * Hardware: ATtiny25v, ATtiny45 or 85 will work as well.
 *
 * If using a lipo-cell, never get under 2.5 V.
 */

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include <stdlib.h>

#define min(a,b) ((a)<(b)?(a):(b))
#define max(a,b) ((a)>(b)?(a):(b))
#define saturation(x,a,b) min(max(x,a),b)

#define LED_BIT PB0
#define LEFT_MOTOR_BIT PB1
#define RIGHT_MOTOR_BIT PB2
#define LEFT_SENSOR_BIT PB3
#define RIGHT_SENSOR_BIT PB4

#define LEFT_OFFSET 10
#define RIGHT_OFFSET 0

static int16_t left_sensor = 0;
static int16_t right_sensor = 0;
static volatile uint8_t left_motor = 0;
static volatile uint8_t right_motor = 0;
static volatile uint8_t act_left_motor = 0;
static volatile uint8_t act_right_motor = 0;
static uint8_t count = 0;


/* -----------------------------------------------------
 * ADC interrupt
 * TODO: use ADC in free running mode
 */
SIGNAL(ADC_vect) {
  // act_light = ADCH;        // read only 8-bit
}


/* -----------------------------------------------------
 * Timer0 overflow interrupt
 * F_CPU 8.000.000 Hz 
 * -> prescaler 0, overrun 256 -> 31.250 Hz 
 * -> 256 steps -> 122 Hz
 *
 */
SIGNAL(TIM0_OVF_vect) {	
  // every 256th step take over new values
  if (++count == 0) {    
    act_left_motor = left_motor + LEFT_OFFSET;
    act_right_motor = right_motor + RIGHT_OFFSET;
    if (act_left_motor > 40) {
      PORTB |= (1 << LEFT_MOTOR_BIT);      
    }
    if (act_right_motor > 40) {
      PORTB |= (1 << RIGHT_MOTOR_BIT);
    }
  }
  if (count == act_left_motor) {
    PORTB &= ~(1 << LEFT_MOTOR_BIT);
  }
  if (count == act_right_motor) {
    PORTB &= ~(1 << RIGHT_MOTOR_BIT);
  }
}



/*
 * get_adc
 * Return the 8 bit value of the selected adc channel.
 */
uint16_t get_adc(uint8_t channel) {

  // ADC setup
  ADCSRA = 
    (1 << ADEN) |                   // enable ADC
    (1 << ADPS1) | (1 << ADPS0);    // set prescaler to 8	
		
  // select channel
  ADMUX = channel;
	
  // select reference voltage
  // ADMUX |= (1 << REFS0);	   // use internal reference

  // warm up the ADC, discard the first conversion
  ADCSRA |= (1 << ADSC);
  while (ADCSRA & (1 << ADSC)); 

  ADCSRA |= (1 << ADSC);           // start single conversion
  while (ADCSRA & (1 << ADSC));    // wait until conversion is done
		
  return ADCW;
}


uint16_t scale_down(uint16_t v) {
  v = max(300, v);
  v -= 300;
  // v /= 6;
  v >>= 2;
  v = min(120, v);
  return v;
}


int main(void) {	
	
  uint8_t i = 0;
	
  // eneable pins as output
  DDRB |= 
    (1 << LED_BIT) |
    (1 << LEFT_MOTOR_BIT) |
    (1 << RIGHT_MOTOR_BIT);

  // timer 0 setup, prescaler none
  TCCR0B |= (0 << CS02) | (0 << CS01) | (1 << CS00);

  // enable timer 0 interrupt
  TIMSK |= (1 << TOIE0);	
  // TIMSK0 |= (1 << TOIE0);	

  // enable all interrupts
  sei();


  // intro, blink led
  for (i = 0; i < 5; i++) {
    PORTB |= (1 << LED_BIT);	
    _delay_ms(100);
    PORTB &= ~(1 << LED_BIT);
    _delay_ms(100);
  }

  _delay_ms(5000);

  while (1) {

    /* motor starts with 5 
    for (i = 0; i < 15; i++) {
      right_motor = i * 10;
      left_motor = i * 10;
      _delay_ms(5000);
      right_motor = 0;
      left_motor = 0;
      PORTB |= (1 << LED_BIT);	
      _delay_ms(500);
      PORTB &= ~(1 << LED_BIT);
    }
    */

    // sensor reads from ~100 to 800
    left_sensor = get_adc(2);
    right_sensor = get_adc(3);

    // scale down
    left_sensor = scale_down(left_sensor);
    right_sensor = scale_down(right_sensor);

    // give some visual feedback
    if (abs(left_sensor - right_sensor) < 10) {
      PORTB |= (1 << LED_BIT);
    }
    else {
      PORTB &= ~(1 << LED_BIT);
    }

    // aggression
    right_motor = left_sensor;
    left_motor = right_sensor;

    // love
    // right_motor = 120 - right_sensor;
    // left_motor = 120 - left_sensor;

    // fear
    // right_motor = right_sensor;
    // left_motor = left_sensor;

    _delay_ms(10);
  }
  return 0;
}
