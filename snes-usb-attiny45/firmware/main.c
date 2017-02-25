#include <avr/io.h>
#include <avr/wdt.h>
#include <avr/eeprom.h>
#include <avr/interrupt.h>
#include <avr/pgmspace.h>
#include <util/delay.h>

#include "usbdrv.h"
#include "oddebug.h"

/* Pin assignment:
 * 
 * PB0 (5) = D- (2 ws)
 * PB2 (7) = D+ (3 gn)
 * 
 * PB1 (6) = CLOCK (4)
 * PB3 (2) = LATCH (3)
 * PB4 (3) = DATA  (2)
*/

//Define OSCCAL_VALUE
#define OSCCAL_VALUE 97
#define SNES_LATCH   (1<<PB3)
#define SNES_CLOCK   (1<<PB1)
#define SNES_DATA    (1<<PB4)


#define SNES_LATCH_LOW()	PORTB &= ~(SNES_LATCH);
#define SNES_LATCH_HIGH()	PORTB |= SNES_LATCH;
#define SNES_CLOCK_LOW()	PORTB &= ~(SNES_CLOCK);
#define SNES_CLOCK_HIGH()	PORTB |= SNES_CLOCK;
#define SNES_GET_DATA()		(PINB & SNES_DATA)

static unsigned char last_read_bytes[2];
static unsigned char last_reported_bytes[2];
static uchar reportBuffer[3];    /* buffer for HID reports */
static uchar idleRate;           /* in 4 ms units */

static void UpdateSNES(void);
static char ChangedSNES(void);

PROGMEM char usbHidReportDescriptor[USB_CFG_HID_REPORT_DESCRIPTOR_LENGTH] = { /* USB report descriptor */
	0x05, 0x01,        // USAGE_PAGE (Generic Desktop)
	0x09, 0x05,        // USAGE (Game Pad)
	0xa1, 0x01,        // COLLECTION (Application)
	0x09, 0x01,        //   USAGE (Pointer)
	0xa1, 0x00,        //   COLLECTION (Physical)
	0x09, 0x30,        //     USAGE (X)
	0x09, 0x31,        //     USAGE (Y)
	0x15, 0x00,        //   LOGICAL_MINIMUM (0)
	0x26, 0xff, 0x00,  //     LOGICAL_MAXIMUM (255)
	0x75, 0x08,        //   REPORT_SIZE (8)
	0x95, 0x02,        //   REPORT_COUNT (2)
	0x81, 0x02,        //   INPUT (Data,Var,Abs)
	0xc0,              // END_COLLECTION
	0x05, 0x09,        // USAGE_PAGE (Button)
	0x19, 0x01,        //   USAGE_MINIMUM (Button 1)
	0x29, 0x08,        //   USAGE_MAXIMUM (Button 8)
	0x15, 0x00,        //   LOGICAL_MINIMUM (0)
	0x25, 0x01,        //   LOGICAL_MAXIMUM (1)
	0x75, 0x01,        // REPORT_SIZE (1)
	0x95, 0x08,        // REPORT_COUNT (8)
	0x81, 0x02,        // INPUT (Data,Var,Abs)
	0xc0               // END_COLLECTION
};

static void UpdateSNES(void) {
	uchar tmp=0;

	SNES_LATCH_HIGH();
	_delay_us(12);
	SNES_LATCH_LOW();

	uchar i = 16;
	while(i) {
		i--;

		_delay_us(6);
		SNES_CLOCK_LOW();
		
		tmp <<= 1;	
		if(!SNES_GET_DATA()) tmp++; 

		_delay_us(6);
		
		SNES_CLOCK_HIGH();

		if(i == 8) last_read_bytes[0] = tmp;
	}
	last_read_bytes[1] = tmp;
}

static char ChangedSNES(void) {
	if(last_read_bytes[0] == last_reported_bytes[0] &&
	   last_read_bytes[1] == last_reported_bytes[1]) return 0;
	
	return 1;
}

static void buildReport(void) {
	int x, y;
	unsigned char lrcb1, lrcb2;

	lrcb1 = last_read_bytes[0];
	lrcb2 = last_read_bytes[1];

	last_reported_bytes[0] = lrcb1;
	last_reported_bytes[1] = lrcb2;

	y = x = 128;
	if(lrcb1 & 0x01) x = 255;
	if(lrcb1 & 0x02) x = 0;
	
	if(lrcb1 & 0x04) y = 255;
	if(lrcb1 & 0x08) y = 0;

	reportBuffer[0] = x;
	reportBuffer[1] = y;
	reportBuffer[2] = lrcb1 & 0xF0;
	reportBuffer[2] |= lrcb2 >> 4;
}

uchar usbFunctionSetup(uchar data[8]) {
	usbRequest_t *rq = (void *)data;

    usbMsgPtr = reportBuffer;
    if((rq->bmRequestType & USBRQ_TYPE_MASK) == USBRQ_TYPE_CLASS){    /* class request type */
        if(rq->bRequest == USBRQ_HID_GET_REPORT){  /* wValue: ReportType (highbyte), ReportID (lowbyte) */
            /* we only have one report type, so don't look at wValue */
            buildReport();
            return sizeof(reportBuffer);
        }else if(rq->bRequest == USBRQ_HID_GET_IDLE){
            usbMsgPtr = &idleRate;
            return 1;
        }else if(rq->bRequest == USBRQ_HID_SET_IDLE){
            idleRate = rq->wValue.bytes[1];
        }
    }else{
        /* no vendor specific requests implemented */
    }
	return 0;
}

int main(void) {
	odDebugInit();
    DDRB = (1 << USB_CFG_DMINUS_BIT) | (1 << USB_CFG_DPLUS_BIT);
    PORTB = 0; //indicate USB disconnect to host

	uchar i = 20;
    while(i){ //300 ms disconnect, also allows our oscillator to stabilize
        _delay_ms(15);
		i--;
    }
	
	//Init SNES-Controller + Reset 
	DDRB = SNES_LATCH | SNES_CLOCK;

	wdt_enable(WDTO_1S);
    usbInit();
    sei();
    for(;;) { //main event loop
        wdt_reset();
        usbPoll();

		UpdateSNES();
		        
		if(usbInterruptIsReady() && ChangedSNES()){
            buildReport();
            usbSetInterrupt(reportBuffer, sizeof(reportBuffer));
        }
    }
    return 0;
}

void    calibrateOscillator(void)
{
uchar       step = 128;
uchar       trialValue = 0, optimumValue;
int         x, optimumDev, targetValue = (unsigned)(1499 * (double)F_CPU / 10.5e6 + 0.5);

    /* do a binary search: */
    do{
        OSCCAL = trialValue + step;
        x = usbMeasureFrameLength();    /* proportional to current real frequency */
        if(x < targetValue)             /* frequency still too low */
            trialValue += step;
        step >>= 1;
    }while(step > 0);
    /* We have a precision of +/- 1 for optimum OSCCAL here */
    /* now do a neighborhood search for optimum value */
    optimumValue = trialValue;
    optimumDev = x; /* this is certainly far away from optimum */
    for(OSCCAL = trialValue - 1; OSCCAL <= trialValue + 1; OSCCAL++){
        x = usbMeasureFrameLength() - targetValue;
        if(x < 0)
            x = -x;
        if(x < optimumDev){
            optimumDev = x;
            optimumValue = OSCCAL;
        }
    }
    OSCCAL = optimumValue;
}

void    usbEventResetReady(void)
{
    calibrateOscillator();
}
