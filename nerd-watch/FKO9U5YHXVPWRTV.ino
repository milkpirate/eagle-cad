
//
// NerdWatch -- a simple PCB that displays the time in binary by flashing two LEDs.
//              The hour is first displayed using 4 bits, and then the position of the "big hand"
//              of the clock is displayed using the next 4 bits. The green LED indicates a binary 1,
//              and yellow indicates a binary zero. For instance, the time 6:50 would
//              be displayed using the following flashing pattern (Y = yellow, G = green):
//                   Y G G Y <pause> G Y G Y
//
// Written by Tony DeRose, April 2014
// (c) 428 Industries
//

#include <Button.h>
#include <Clock.h>
#include <LED.h>

#include <avr/power.h>

// Pin definitions
#define BUTTON_PIN              0
#define YELLOW_PIN              1
#define GREEN_PIN               2

// Delay definitions
#define BIT_DISPLAY_DELAY       500                     // Display a bit for this many millis
#define INTER_BIT_DELAY         100                     // Wait this many millis between bits
#define POST_DISPLAY_DELAY      500                     // Wait this many millis after displaying hours or minutes

LED                  OneLed(GREEN_PIN);
LED                  ZeroLed( YELLOW_PIN);

//
// A class to do serial single bit display using the two
// LEDs in a non-blocking fashion
//
class BitDisplayer {
public:
    typedef enum {
        OFF_STATE,
        DISPLAYING_BIT_STATE,
        BETWEEN_BITS_STATE,
        POST_DISPLAY_STATE,
    } DisplayerState;

    BitDisplayer() {}
    
    void SetValueToDisplay(uint8_t value) {
        _value = value;
    }
    
    void Start() {
        _state = BETWEEN_BITS_STATE;
        _bitNum = 3;
        _time = 0;
    }
    
    void Update() {
        switch (_state) {
            case OFF_STATE:
               // Do nothing
            break;
            
            case BETWEEN_BITS_STATE:
                if (millis() - _time > INTER_BIT_DELAY) {
                    // Display the next bit
                    if (_bitNum >= 0) {
                        uint8_t mask = 1 << _bitNum;
                        if (_value & mask) {
                            OneLed.SetMode(LED::ON);
                        } else {
                            ZeroLed.SetMode(LED::ON);
                        }
                        _time = millis();
                        _bitNum--;
                        _state = DISPLAYING_BIT_STATE;
                    } else {
                        _state = POST_DISPLAY_STATE;
                        _time = millis();
                    }
                }
            break;
                
            case DISPLAYING_BIT_STATE:
                if (millis() - _time > BIT_DISPLAY_DELAY) {
                    _time = millis();
                    _state = BETWEEN_BITS_STATE;
                    OneLed.SetMode(LED::OFF);
                    ZeroLed.SetMode(LED::OFF);
                }
            break;

            case POST_DISPLAY_STATE:
                if (millis() - _time > POST_DISPLAY_DELAY) {
                    _state = OFF_STATE;
                }
            break;        
        }
    }
    
    bool IsDone() {
        return _state == OFF_STATE;
    }
    
private:
    int                   _bitNum;      // Which bit is currently being displayed
    DisplayerState        _state;       // The current state
    uint32_t              _time;        // Used for accurate non-blocking delays
    uint8_t               _value;       // The value to display
};


// States of the system
typedef enum {
    OFF_STATE,
    DISPLAYING_HOUR_STATE,
    DISPLAYING_MINUTE_STATE,
} StateType;

BitDisplayer         Displayer;
Clock                Now( 9 /* hour */, 15 /* minutes */, 0 /* seconds */, false /* am */);
StateType            State = OFF_STATE;
Button               TellTimeButton( BUTTON_PIN, false /* isAnalogPin */, true /* pressedWhenLow */);

void setup()
{
    // Configure for low power operation
    power_adc_disable();
    
    pinMode(YELLOW_PIN, OUTPUT);
    ZeroLed.SetIsOnWhenHigh(false);
    ZeroLed.SetMode(LED::OFF);
    
    pinMode(GREEN_PIN, OUTPUT);
    OneLed.SetIsOnWhenHigh(false);
    OneLed.SetMode(LED::OFF);
    
    pinMode(BUTTON_PIN, INPUT);
    digitalWrite( BUTTON_PIN, HIGH);              // Connect internal pull up resistor
}

void loop()
{
    Displayer.Update();
    Now.Update();
    OneLed.Update();
    TellTimeButton.Update();
    ZeroLed.Update();
    
    switch(State) {
        case OFF_STATE:
            if (TellTimeButton.WasPressed()) {
                ZeroLed.SetMode(LED::OFF);
                Displayer.SetValueToDisplay( Now.GetHours());
                Displayer.Start();
                State = DISPLAYING_HOUR_STATE;
            }
        break;
        
        case DISPLAYING_HOUR_STATE:
            if (Displayer.IsDone()) {
                // Round minutes off to nearest five minutes
                Displayer.SetValueToDisplay( (Now.GetMinutes() + 2)/5);
                Displayer.Start();
                State = DISPLAYING_MINUTE_STATE;
            }
        break;

        case DISPLAYING_MINUTE_STATE:
            if (Displayer.IsDone()) {
                State = OFF_STATE;
            }
       break;
    }
}



