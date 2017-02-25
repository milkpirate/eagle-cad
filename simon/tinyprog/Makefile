# name of MCU
MCU := atmega1284p
#MCU := atmega8

# frequency of CPU in Hz
F_CPU := 20000000

AVR_CFLAGS := -mmcu=$(MCU) -DF_CPU=$(F_CPU)UL -Os -funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums -Wall -Wstrict-prototypes --std=gnu99 -mcall-prologues
AVR_LDFLAGS := -lm

AVR_CC := avr-gcc
AVR_AS := avr-as
AVR_LD := avr-ld
AVR_OBJCOPY := avr-objcopy

all: tpi.hex

tpi.o: tpi.c firmware.c
	$(AVR_CC) $(AVR_CFLAGS) -c -o $@ $<

%.S: %.c
	$(AVR_CC) $(AVR_CFLAGS) -S -o $@ $<

tpi.elf: tpi.o
	$(AVR_CC) $(AVR_CFLAGS) $(AVR_LDFLAGS) -o $@ $^

tpi.hex: tpi.elf
	$(AVR_OBJCOPY) -O ihex -R .eeprom $< $@

firmware.s: firmware.asm
	cpp -x assembler-with-cpp $< -o $@

firmware.o: firmware.s
	$(AVR_AS) -mmcu=attiny22 $< -o $@

firmware.elf: firmware.o
	$(AVR_LD) $< -o $@

firmware.bin: firmware.elf
	$(AVR_OBJCOPY) -O binary $< $@

firmware.c: firmware.bin
	hexdump -ve '1/1 "0x%02X,\n"' $< > $@

clean:
	rm -f firmware.s firmware.o firmware.elf firmware.bin firmware.c tpi.o tpi.S tpi.elf tpi.hex

.PHONY: clean all
