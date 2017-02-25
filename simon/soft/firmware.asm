; License: do with it whatever you want

; "global" variables:
; [r16; r19]: random number generator state

#define IO_PINB 0x00
#define IO_DDRB 0x01
#define IO_PORTB 0x02
#define IO_PUEB 0x03
#define IO_CLKPSR 0x36
#define IO_OSCCAL 0x39
#define IO_CCP 0x3C

main:
	; initialize random numbers with random numbers. See http://xkcd.com/221/ for details
	ldi r16, 0x7D
	ldi r17, 0xFF
	ldi r18, 0x44
	ldi r19, 0xB5

	; disable clock divider
	ldi r16, 0x00
	ldi r17, 0xD8
	out IO_CCP, r17
	out IO_CLKPSR, r16
	;ldi r31, 0xFF
	;out IO_OSCCAL, r31

	; initialize port
	ldi r31, 0x0F
	out IO_DDRB, r31
	ldi r31, 0x00
	out IO_PORTB, r31

	ldi r30, 1

loop:
	rcall display_pattern
	rcall check_pattern

	rcall delay

	rjmp loop

; display pattern for the user to remember
; this saves the RNG state so it can be used to reconstruct the pattern
; r31:r30 is the length of the pattern
; stack usage = 14
display_pattern:
	push r16
	push r17
	push r18
	push r19
	push r30
	push r31

display_pattern.loop:
	push r31
	ldi r31, 0
	out IO_DDRB, r31
	rcall delay
	rcall crc
	rcall demux
	out IO_DDRB, r31
	rcall delay
	pop r31

	subi r30, 1
	sbci r31, 0
	brne display_pattern.loop

	out IO_DDRB, r31 ; turn all LEDs off

	pop r31
	pop r30
	pop r19
	pop r18
	pop r17
	pop r16
	ret

; allow the user to enter what they remembered
; r31:r30 is the length of the pattern, which will be adjusted according to the user's performance
; stack usage = 12
check_pattern:
	push r30
	push r31

check_pattern.loop:
	push r30
	push r31
	rcall crc
	rcall demux

	push r29
	ldi r29, 0x0F
check_pattern.inner_loop:
	in r30, IO_PINB
	eor r30, r29
	breq check_pattern.inner_loop
	pop r29

	eor r30, r31
	brne check_pattern.wrong_button

	out IO_DDRB, r31
	rcall delay
	ldi r31, 0
	out IO_DDRB, r31

	pop r31
	pop r30
	subi r30, 1
	sbci r31, 0
	brne check_pattern.loop

	; all buttons correct: blink in joy
	ldi r31, 8
check_pattern.blink_loop:
	ldi r30, (1 << 0)
	out IO_DDRB, r30
	rcall delay_tiny
	ldi r30, (1 << 1)
	out IO_DDRB, r30
	rcall delay_tiny
	ldi r30, (1 << 2)
	out IO_DDRB, r30
	rcall delay_tiny
	ldi r30, (1 << 3)
	out IO_DDRB, r30
	rcall delay_tiny

	subi r31, 1
	brne check_pattern.blink_loop

	out IO_DDRB, r31

	; increment round counter and return
	pop r31
	pop r30

	subi r30, -1
	sbci r31, -1
	ret

check_pattern.wrong_button:
	pop r31
	pop r31
	pop r31
	pop r31

	; wrong sequence: blink in agony
	ldi r31, 8
check_pattern.error_loop:
	ldi r30, 0x0F
	out IO_DDRB, r30
	rcall delay_short
	ldi r30, 0x00
	out IO_DDRB, r30
	rcall delay_short

	subi r31, 1
	brne check_pattern.error_loop

	; set round counter to 1 and return
	ldi r30, 1
	ret

; delay for some time
; stack usage = 5
delay:
	push r16
	push r17
	push r18

	ldi r16, 0xFF ; LSB
	ldi r17, 0xFF
	ldi r18, 0x0F ; MSB

delay.loop:
	subi r16, 1
	sbci r17, 0
	sbci r18, 0
	brne delay.loop

	pop r18
	pop r17
	pop r16

	ret

; delay for less time
; stack usage = 5
delay_short:
	push r16
	push r17
	push r18

	ldi r16, 0xFF ; LSB
	ldi r17, 0xFF
	ldi r18, 0x07 ; MSB
	rjmp delay.loop

; delay for even less time
; stack usage = 5
delay_tiny:
	push r16
	push r17
	push r18

	ldi r16, 0xFF ; LSB
	ldi r17, 0xFF
	ldi r18, 0x00 ; MSB
	rjmp delay.loop

; stack usage = 3
crc: ; based on http://www.avrfreaks.net/index.php?name=PNphpBB2&file=viewtopic&p=367227#367227
	lsl r16
	rol r17
	rol r18
	rol r19
	sbrs r19, 7
	ret

	push r20
	ldi   r20,0xB5
	eor   r16,r20
	ldi   r20,0x95
	eor   r17,r20
	ldi   r20,0xAA
	eor   r18,r20
	ldi   r20,0x20
	eor   r19,r20
	pop r20
	ret

; demultiplex current random number into a one-of-four coding (result: r31)
; stack usage = 3
demux:
	push r30

	mov r30, r16
	andi r30, 0x3

	ldi r31, (1 << 4)
demux.loop:
	lsr r31
	subi r30, 1
	brge demux.loop

	pop r30
	ret
