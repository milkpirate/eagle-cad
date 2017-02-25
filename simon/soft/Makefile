# WinAVR cross-compiler toolchain is used here
CC = avr-gcc
OBJCOPY = avr-objcopy
DUDE = avrdude

# If you are not using ATtiny85 and the USBtiny programmer, 
# update the lines below to match your configuration
CFLAGS = -Wall -Os -Iusbdrv -mmcu=atmega8 -DF_CPU=16500000
OBJFLAGS = -j .text -j .data -O ihex
DUDEFLAGS = -p atmega8 -c usbtiny -v

# Object files for the firmware (usbdrv/oddebug.o not strictly needed I think)
OBJECTS = #usbdrv/usbdrv.o usbdrv/oddebug.o usbdrv/usbdrvasm.o main.o

# By default, build the firmware and command-line client, but do not flash
all: tpi.hex

# With this, you can flash the firmware by just typing "make flash" on command-line
flash: tpi.hex
	$(DUDE) $(DUDEFLAGS) -U flash:w:$<

eeprom: tpi.eep
	$(DUDE) $(DUDEFLAGS) -U eeprom:w:$<

# Housekeeping if you want it
clean:
	$(RM) *.o *.hex *.elf usbdrv/*.o

# From .elf file to .hex
%.hex: %.elf
	$(OBJCOPY) $(OBJFLAGS) $< $@

# tpi.elf requires additional objects to the firmware, not just tpi.o
tpi.elf: $(OBJECTS)
	$(CC) $(CFLAGS) $(OBJECTS) -o $@

# Without this dependance, .o files will not be recompiled if you change 
# the config! I spent a few hours debugging because of this...
$(OBJECTS): usbdrv/usbconfig.h

# From C source to .o object file
%.o: %.c	
	$(CC) $(CFLAGS) -c $< -o $@

# From assembler source to .o object file
%.o: %.S
	$(CC) $(CFLAGS) -x assembler-with-cpp -c $< -o $@
