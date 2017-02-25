// License: do with it whatever you want

#define UART_DEBUG

#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <avr/pgmspace.h>
#include <util/delay.h>
#include <stdbool.h>
#include <stdlib.h>
#include <inttypes.h>

#ifdef UART_DEBUG

#include <stdio.h>

#define BAUD 115200
#define MYUBRR ((F_CPU/8/BAUD+1)/2-1)

static int usart_putchar(char c, FILE *stream)
{
	if (c == '\n') {
		usart_putchar('\r', stream);
	}

	while((UCSR0A & (1 << UDRE0)) == 0) ;
	UDR0 = c;

	return 0;
}

int usart_getchar(FILE *stream)
{
	while(!(UCSR0A & (1 << RXC0))) ;
	return UDR0;
}

static FILE mystdout = FDEV_SETUP_STREAM(usart_putchar, NULL, _FDEV_SETUP_WRITE);
static FILE mystdin = FDEV_SETUP_STREAM(NULL, usart_getchar, _FDEV_SETUP_READ);

#else

#define printf_P (void)

#endif

/* pinout of the TPI port. Can be arbitrarily chosen as long all lines are on the same port */
#define TPI_PORT PORTC
#define TPI_DDR DDRC
#define TPI_PIN PINC
#define TPI_RESET 2
#define TPI_CLK 1
#define TPI_DATA 0

/* TPI physical layer routines */

static inline void tpi_clk(void) {
	_delay_us(10);
	TPI_PIN = 1 << TPI_CLK;
}

void tpi_init(void) {
	TPI_PORT |= (1 << TPI_DATA) | (1 << TPI_CLK) | (1 << TPI_RESET);
	TPI_DDR |= (1 << TPI_RESET) | (1 << TPI_DATA) | (1 << TPI_CLK);

	_delay_ms(128);

	TPI_PORT &= ~(1 << TPI_RESET);

	for(uint8_t i = 0; i < 33; ++i) {
		tpi_clk();
	}
}

void tpi_break(void) {
	TPI_PORT &= ~(1 << TPI_DATA);

	for(uint8_t i = 0; i < 24; ++i) {
		tpi_clk();
	}

	TPI_PORT |= (1 << TPI_DATA);
}

void tpi_send(uint8_t byte) {
	TPI_PORT &= ~(1 << TPI_DATA);

	tpi_clk(); tpi_clk();

	bool parity = 0;

	for(uint8_t i = 0; i < 8; ++i) {
		if(byte & 1) {
			TPI_PORT |= (1 << TPI_DATA);
			parity ^= 1;
		} else {
			TPI_PORT &= ~(1 << TPI_DATA);
		}
		byte >>= 1;

		tpi_clk(); tpi_clk();
	}

	if(parity) {
		TPI_PORT |= (1 << TPI_DATA);
	} else {
		TPI_PORT &= ~(1 << TPI_DATA);
	}
	tpi_clk(); tpi_clk();

	TPI_PORT |= (1 << TPI_DATA);
	tpi_clk(); tpi_clk();
	tpi_clk(); tpi_clk();
}

uint8_t tpi_receive(void) {
	TPI_DDR &= ~(1 << TPI_DATA);
	tpi_clk();

	while(TPI_PIN & (1 << TPI_DATA)) {
		tpi_clk(); tpi_clk();
	}

	uint8_t ret = 0;
	bool parity = 0;

	for(uint8_t i = 0; i < 8; ++i) {
		tpi_clk(); tpi_clk();
		ret >>= 1;
		if(TPI_PIN & (1 << TPI_DATA)) {
			ret |= 0x80;
			parity ^= 1;
		}
	}

	tpi_clk(); tpi_clk();

	if(!!(TPI_PIN & (1 << TPI_DATA)) != parity) {
		printf_P(PSTR("parity error\n"));
	}

	tpi_clk(); tpi_clk();
	if(!(TPI_PIN & (1 << TPI_DATA))) {
		printf_P(PSTR("stop bit error\n"));
	}

	tpi_clk(); tpi_clk();
	if(!(TPI_PIN & (1 << TPI_DATA))) {
		printf_P(PSTR("stop bit error\n"));
	}

	tpi_clk();
	tpi_clk(); tpi_clk();
	TPI_DDR |= 1 << TPI_DATA;

	return ret;
}

/* tpi access layer utility functions */

void tpi_write_css(uint8_t addr, uint8_t value) {
	tpi_send(0xC0 | addr);
	tpi_send(value);
}

uint8_t tpi_read_css(uint8_t addr) {
	tpi_send(0x80 | addr);
	return tpi_receive();
}

void tpi_write_io(uint8_t addr, uint8_t value) {
	tpi_send(0x90 | (addr & 0x0F) | ((addr & 0x30) << 1));
	tpi_send(value);
}

uint8_t tpi_read_io(uint8_t addr) {
	tpi_send(0x10 | (addr & 0x0F) | ((addr & 0x30) << 1));
	return tpi_receive();
}

void tpi_set_pointer(uint16_t addr) {
	tpi_send(0x68);
	tpi_send(addr & 0xFF);
	tpi_send(0x69);
	tpi_send(addr >> 8);
}

uint8_t tpi_read_data(void) {
	tpi_send(0x24);
	return tpi_receive();
}

void tpi_write_data(uint8_t value) {
	tpi_send(0x64);
	tpi_send(value);
}

/* some useful magic numbers from the datasheet */
enum {
	TPI_IO_NVMCSR = 0x32,
	TPI_IO_NVMCMD = 0x33
};

enum {
	TPI_CSS_TPISR = 0x0,
	TPI_CSS_TPIPCR = 0x2,
	TPI_CSS_TPIIR = 0xF
};

enum {
	TPI_NVMCMD_NO_OPERATION = 0x00,
	TPI_NVMCMD_CHIP_ERASE = 0x10,
	TPI_NVMCMD_SECTION_ERASE = 0x14,
	TPI_NVMCMD_WORD_WRITE = 0x1D
};

enum {
	TPI_SECTION_SRAM = 0x0040,
	TPI_SECTION_LOCK = 0x3F00,
	TPI_SECTION_CONFIGURATION = 0x3F40,
	TPI_SECTION_CALIBRATION = 0x3F80,
	TPI_SECTION_ID = 0x3FC0,
	TPI_SECTION_CODE = 0x4000
};

/* the actual program; one could make a real programmer by either loading this
 * from somewhere else (USART, USB?) or accepting commands for the access layer
 * functions */
PROGMEM const uint8_t PROGRAM[] = {
#include "firmware.c"
};

int main(void) {
#ifdef UART_DEBUG
	DDRD = (1 << 1);

	/* setup serial communication */
	UBRR0H = MYUBRR >> 8;
	UBRR0L = MYUBRR;
	UCSR0B = (1<<RXEN0)|(1<<TXEN0);

	/* setup stdin and stdout so printf and friends work */
	stdout = &mystdout;
	stdin = &mystdin;

	usart_putchar('', NULL);
#endif

	tpi_init();
	tpi_break();
	tpi_break();

	tpi_send(0xE0); // wtf?! why is this required?! why doesn't this break everything?!

	/* reduce number of clock cycles on direction change to a sane value */
	tpi_write_css(TPI_CSS_TPIPCR, 0x03);

	/* check the identification byte */
	if(tpi_read_css(TPI_CSS_TPIIR) != 0x80) {
		printf_P(PSTR("initialization error\n"));
		return -1;
	}

	/* send the key that enables memory programming */
	tpi_send(0xE0);
	tpi_send(0xFF);
	tpi_send(0x88);
	tpi_send(0xD8);
	tpi_send(0xCD);
	tpi_send(0x45);
	tpi_send(0xAB);
	tpi_send(0x89);
	tpi_send(0x12);

	for(;;) {
		uint8_t tpisr = tpi_read_css(TPI_CSS_TPISR);
		if(tpisr & (1 << 1)) {
			break;
		}
	}

	printf_P(PSTR("ready to program\n"));

	/* erase chip */
	tpi_write_io(TPI_IO_NVMCMD, TPI_NVMCMD_CHIP_ERASE);
	tpi_set_pointer(TPI_SECTION_CODE + 1);
	tpi_write_data(0x42);

	for(;;) {
		uint8_t nvmcsr = tpi_read_io(TPI_IO_NVMCSR);
		if(!(nvmcsr & (1 << 7))) {
			break;
		}
	}

	printf_P(PSTR("chip erased\n"));

	tpi_write_io(TPI_IO_NVMCMD, TPI_NVMCMD_WORD_WRITE);

	/* write configuration byte to disable the reset pin */
	tpi_set_pointer(TPI_SECTION_CONFIGURATION);
	tpi_write_data(0xFE);
	tpi_write_data(0xFF);
	for(;;) {
		uint8_t nvmcsr = tpi_read_io(TPI_IO_NVMCSR);
		if(!(nvmcsr & (1 << 7))) {
			break;
		}
	}

	/* write the actual program */
	tpi_set_pointer(TPI_SECTION_CODE);
	for(int i = 0; i < sizeof(PROGRAM); i += 2) {
		tpi_write_data(pgm_read_byte(&PROGRAM[i]));
		tpi_write_data(pgm_read_byte(&PROGRAM[i+1]));
		for(;;) {
			uint8_t nvmcsr = tpi_read_io(TPI_IO_NVMCSR);
			if(!(nvmcsr & (1 << 7))) {
				break;
			}
		}
	}

	tpi_write_io(TPI_IO_NVMCMD, TPI_NVMCMD_NO_OPERATION);

	/* verify the program */
	tpi_set_pointer(TPI_SECTION_CODE);
	for(int i = 0; i < sizeof(PROGRAM); ++i) {
		uint8_t value = tpi_read_data();
		if(value != pgm_read_byte(&PROGRAM[i])) {
			printf_P(PSTR("mismatch: [0x%04X] = 0x%02X, should be 0x%02X\n"), i, value, pgm_read_byte(&PROGRAM[i]));
		}
	}

	printf_P(PSTR("all done\n"));

	/* end programming mode */
	tpi_write_css(TPI_CSS_TPISR, 0x00);

	/* a few extra clock cycles appear to be necessary to latch in TPISR and have the CPU resume after reset is released */
	for(uint8_t i = 0; i < 16; ++i) {
		tpi_clk();
	}

	/* release all I/O lines */
	TPI_DDR &= ~((1 << TPI_RESET) | (1 << TPI_DATA) | (1 << TPI_CLK));
	TPI_PORT &= ~((1 << TPI_DATA) | (1 << TPI_CLK));
	TPI_PORT |= (1 << TPI_RESET);
}
