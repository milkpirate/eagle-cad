#ifndef _JOYPAD_H_
#define _JOYPAD_H_

#define JOY_PORT  PORTC
#define JOY_DDR   DDRC
#define JOY_PIN   PINC
#define JOY_NONE  0
#define JOY_LEFT  _BV(0)
#define JOY_RIGHT _BV(1)
#define JOY_UP    _BV(2)
#define JOY_DOWN  _BV(3)
#define JOY_FIRE1 _BV(4)
#define JOY_FIRE2 _BV(5)
#define JOY_ALL   (JOY_LEFT | JOY_RIGHT | JOY_UP | JOY_DOWN | JOY_FIRE1 | JOY_FIRE2)

#endif
