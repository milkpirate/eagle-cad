# Name: Makefile
# Author: <insert your name here>
# Copyright: <insert your copyright message here>
# License: <insert your license reference here>

# This is a prototype Makefile. Modify it according to your needs.
# You should at least check the settings for
# DEVICE ....... The AVR device you compile for
# CLOCK ........ Target AVR clock rate in Hertz
# OBJECTS ...... The object files created from your source files. This list is
#                usually the same as the list of source files with suffix ".o".
# PROGRAMMER ... Options to avrdude which define the hardware you use for
#                uploading to the AVR and the interface where this hardware
#                is connected.
# FUSES ........ Parameters for avrdude to flash the fuses appropriately.

DEVICE     = attiny45
CLOCK      = 8000000
# PROGRAMMER = -c avr910 -P /dev/tty.SLAB_USBtoUART -C /Users/alex/etc/avrdude.conf
PROGRAMMER = -c usbasp -v 
OBJECTS    = robot.o
# Fuses: internal oscilator, no prescale
# FUSES      = -U lfuse:w:0xe2:m -U hfuse:w:0xde:m 
# attiny45
# FUSES      = -U lfuse:w:0xe2:m -U hfuse:w:0xde:m

# attiny85
FUSES      = -U lfuse:w:0xe2:m -U hfuse:w:0xdf:m

# attiny13
# DEVICE     = attiny13
# CLOCK      = 9600000
# FUSES      =  -U hfuse:w:0xFF:m -U lfuse:w:0x7A:m

# Tune the lines below only if you know what you are doing:

AVRDUDE = avrdude $(PROGRAMMER) -p $(DEVICE) -B 10
OBJDUMP = avr-objdump
COMPILE = avr-gcc -Wall -Os -DF_CPU=$(CLOCK) -mmcu=$(DEVICE)

# symbolic targets:
all:	robot.hex robot.lss

.c.o:
	$(COMPILE) -c $< -o $@

.S.o:
	$(COMPILE) -x assembler-with-cpp -c $< -o $@
# "-x assembler-with-cpp" should not be necessary since this is the default
# file type for the .S (with capital S) extension. However, upper case
# characters are not always preserved on Windows. To ensure WinAVR
# compatibility define the file type manually.

.c.s:
	$(COMPILE) -S $< -o $@

flash:	all
	$(AVRDUDE) -U flash:w:robot.hex:i

fuse:
	$(AVRDUDE) $(FUSES)

# Xcode uses the Makefile targets "", "clean" and "install"
install: flash fuse

# if you use a bootloader, change the command below appropriately:
load: all
	bootloadHID main.hex

clean:
	rm -f robot.hex robot.elf $(OBJECTS)

# file targets:
robot.elf: $(OBJECTS)
	$(COMPILE) -o robot.elf $(OBJECTS)

robot.hex: robot.elf
	rm -f robot.hex
	avr-objcopy -j .text -j .data -O ihex robot.elf robot.hex
# If you have an EEPROM section, you must also create a hex file for the
# EEPROM and add it to the "flash" target.

# Targets for code debugging and analysis:
disasm:	robot.elf
	avr-objdump -d robot.elf

%.lss: %.elf
	@echo
	$(OBJDUMP) -h -S $< > $@

cpp:
	$(COMPILE) -E robot.c
