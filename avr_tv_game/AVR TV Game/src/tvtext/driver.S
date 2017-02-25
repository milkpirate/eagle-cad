#include <avr/io.h>
#include "tvtext.h"

; Registers.
#define r_font_row           r15 /* Stores a row of pixels from the font data temporarily. */
#define r_characters_left    r16 /* Stores the number of characters left to draw on a scanline. */
#define r_font_data_l        r17 /* Points to the LSB of the font data table, offset by the current scanline. */
#define r_font_data_h        r18 /* Points to the MSB of the font data table, offset by the current scanline. */
#define r_font_invert_mask   r19 /* Stores a mask used to invert the display. Set to 0x00 (normal) or 0xFF (inverted). */
#define t_short_vsync          4 /* Length of the "short" sync pulses. */
#define t_long_vsync          28 /* Length of the "long" sync pulses. */
#define t_active_sync          4 /* Length of the sync pulse on active display. */
#define t_active_picture      60 /* Length of the picture data on active display. */

; Variables.
.lcomm timer1_compa_handler, 2   ; Function pointer to current TIMER1_COMPA_vect handler.
.lcomm scan_region_repeat, 2     ; Used to count down display regions when rasterising.
.lcomm cursor_cell, 2            ; Pointer to the buffer cell that contains the cursor.
.lcomm cursor_char, 1            ; Character to draw in the cursor's cell.
.lcomm scanline_counter, 2       ; Refers to the current scanline.

#define cycles_us(us) (us)*20-1

.global tvtext_driver_init
tvtext_driver_init:
	push r20
	ldi r20, lo8(pm(long_vsync_sync))
	sts timer1_compa_handler+0, r20
	ldi r20, hi8(pm(long_vsync_sync))
	sts timer1_compa_handler+1, r20
	ldi r20, 5
	sts scan_region_repeat, r20
	pop r20
	ret

.global TIMER1_COMPA_vect
TIMER1_COMPA_vect:
	in r_sreg_save,_SFR_IO_ADDR(SREG) ; [1]
	push ZL                           ; [2]
	push ZH                           ; [2]
	push YL                           ; [2]
	push YH                           ; [2]

	; Disable CTC.
	ldi ZL, _BV(CS10)
	sts _SFR_MEM_ADDR(TCCR1B),ZL

	lds ZL,_SFR_MEM_ADDR(TCNT1L) ; [2]
	sbrs ZL,0                    ; [2/1] \_ bit 0 = 0: 3cc \  00 -> 7
	rjmp .                       ; [2]   /  bit 0 = 1: 2cc  | 01 -> 6
	sbrs ZL,1                    ; [2/1] \_ bit 1 = 0: 4cc  | 10 -> 5
	lpm ZL,Z                     ; [3]   /  bit 1 = 1: 2cc /  11 -> 4

	lds ZL, timer1_compa_handler+0      ; [2]
	lds ZH, timer1_compa_handler+1      ; [2]
	ijmp                                ; [2]

; Exits the interrupt handler and sets the screen colour back to black.
exit_timer1_compa_vect:
	sts timer1_compa_handler+0, ZL
	sts timer1_compa_handler+1, ZH
	sts _SFR_MEM_ADDR(OCR1AH), YH
	sts _SFR_MEM_ADDR(OCR1AL), YL
exit_timer1_compa_vect_no_store:
	; Re-enable CTC.
	ldi ZL, _BV(WGM12) | _BV(CS10)
	sts _SFR_MEM_ADDR(TCCR1B),ZL

	; Clear interrupts (if any happened).
	sbi _SFR_IO_ADDR(TIFR1), OCF1A

	pop YH
	pop YL
	pop ZH
	pop ZL
	out _SFR_IO_ADDR(SREG),r_sreg_save ; [1]
	reti

; 30uS of sync.
long_vsync_sync:
	cbi _SFR_IO_ADDR(TVTEXT_SYNC_PORT),TVTEXT_SYNC_BIT
	ldi YL,lo8(cycles_us(t_long_vsync))
	ldi YH,hi8(cycles_us(t_long_vsync))
	ldi ZL,lo8(pm(long_vsync_black))
	ldi ZH,hi8(pm(long_vsync_black))
	jmp exit_timer1_compa_vect

; 2uS of black.
long_vsync_black:
	sbi _SFR_IO_ADDR(TVTEXT_SYNC_PORT),TVTEXT_SYNC_BIT
	; Is this the last long vsync?
	lds YL, scan_region_repeat
	dec YL
	brne long_vsync_not_finished
	; Long sync is always followed by 5x short sync.
	ser YL
	sts scan_region_repeat+1, YL ; Used to denote that we're entering short sync from long sync.
	ldi YL, 5
	ldi ZL,lo8(pm(short_vsync_sync))
	ldi ZH,hi8(pm(short_vsync_sync))
	jmp long_vsync_finished
long_vsync_not_finished:
	ldi ZL,lo8(pm(long_vsync_sync))
	ldi ZH,hi8(pm(long_vsync_sync))
long_vsync_finished:
	sts scan_region_repeat, YL
	ldi YL,lo8(cycles_us(t_short_vsync))
	ldi YH,hi8(cycles_us(t_short_vsync))
	jmp exit_timer1_compa_vect

; 2uS of sync.
short_vsync_sync:
	cbi _SFR_IO_ADDR(TVTEXT_SYNC_PORT),TVTEXT_SYNC_BIT
	cbi _SFR_IO_ADDR(TVTEXT_PICTURE_PORT),TVTEXT_PICTURE_BIT
	ldi YL,lo8(cycles_us(t_short_vsync))
	ldi YH,hi8(cycles_us(t_short_vsync))
	ldi ZL,lo8(pm(short_vsync_black))
	ldi ZH,hi8(pm(short_vsync_black))
	jmp exit_timer1_compa_vect

; 30uS of black.
short_vsync_black:
	sbi _SFR_IO_ADDR(TVTEXT_SYNC_PORT), TVTEXT_SYNC_BIT
	; Is this the last short vsync?
	lds YL,scan_region_repeat
	dec YL
	brne short_vsync_not_finished
	; Short sync is either followed by 5x long sync or active display.
	lds YL,scan_region_repeat+1
	inc YL
	breq short_vsync_enter_active_display
short_vsync_enter_long_sync:
	; We've just finished a frame!
	lds ZL,tvtext_frame_counter+0
	lds ZH,tvtext_frame_counter+1
	adiw ZL,1
	sts tvtext_frame_counter+0,ZL
	sts tvtext_frame_counter+1,ZH
		
	ldi YL, 5
	ldi ZL,lo8(pm(long_vsync_sync))
	ldi ZH,hi8(pm(long_vsync_sync))
	jmp short_vsync_finished
short_vsync_enter_active_display:
	; We're about to enter active display.
	call set_up_cursor
	; Initialise the scanline counter, skipping the first few lines.
	ldi YL,lo8(-(32+1))
	ldi YH,hi8(-(32+1))
	lds ZL,tvtext_offset_y+0
	lds ZH,tvtext_offset_y+1
	sub YL,ZL
	sbc YH,ZH
	; If the screen is blanked, hide the display by using a scanline counter offset that would result in the display never being shown.
	lds ZL,tvtext_flags
	sbrs ZL,TVTEXT_VISIBLE
	ldi YH,0x80
	sts scanline_counter+0, YL
	sts scanline_counter+1, YH
	; 304 lines in PAL.
	ldi YH,hi8(-304)
	sts scan_region_repeat+1, YH
	ldi YL,lo8(-304)
	ldi ZL,lo8(pm(active_sync))
	ldi ZH,hi8(pm(active_sync))
	jmp short_vsync_finished
short_vsync_not_finished:
	ldi ZL,lo8(pm(short_vsync_sync))
	ldi ZH,hi8(pm(short_vsync_sync))
short_vsync_finished:
	sts scan_region_repeat, YL
	ldi YL,lo8(cycles_us(t_long_vsync))
	ldi YH,hi8(cycles_us(t_long_vsync))
	jmp exit_timer1_compa_vect

set_up_cursor:
	; Calculate the cursor offset and character.
	push r0
	push r1
	lds r0,tvtext_cursor_row
	ldi YL,TVTEXT_BUFFER_WIDTH
	mul r0,YL
	lds YL,tvtext_cursor_column
	clr YH
	add r0,YL
	adc r1,YH
	ldi YL,lo8(tvtext_buffer)
	ldi YH,hi8(tvtext_buffer)
	add r0,YL
	adc r1,YH
	sts cursor_cell+0,r0
	sts cursor_cell+1,r1
	movw YL,r0
	ld YL,Y
	lds YH,tvtext_flags
	; Is the cursor visible?
	sbrs YH,TVTEXT_CURSOR_ENABLED
	rjmp found_cursor_char
	sbrs YH,TVTEXT_CURSOR_VISIBLE
	rjmp found_cursor_char
	lds YL,tvtext_cursor
found_cursor_char:
	sts cursor_char,YL
	; Do we need to blink the cursor?
	lds YL,tvtext_cursor_flash_timer
	dec YL
	brne no_flash_cursor
	; Blink the cursor.
	ldi YL,_BV(TVTEXT_CURSOR_VISIBLE)
	eor YH,YL
	sts tvtext_flags,YH
	lds YL,tvtext_cursor_flash_period
no_flash_cursor:
	sts tvtext_cursor_flash_timer,YL
	pop r1
	pop r0
	ret

; 4uS of sync.
active_sync:
	cbi _SFR_IO_ADDR(TVTEXT_SYNC_PORT),TVTEXT_SYNC_BIT
	cbi _SFR_IO_ADDR(TVTEXT_PICTURE_PORT),TVTEXT_PICTURE_BIT

	; Increment the scanline counter. [10]
	lds YL,scanline_counter+0 ; [2]
	lds YH,scanline_counter+1 ; [2]
	adiw YL,1                 ; [1]
	sts scanline_counter+0,YL ; [2]
	sts scanline_counter+1,YH ; [2]

	ldi YL,lo8(cycles_us(t_active_sync))
	ldi YH,hi8(cycles_us(t_active_sync))
	ldi ZL,lo8(pm(active_back_porch))
	ldi ZH,hi8(pm(active_back_porch))
	jmp exit_timer1_compa_vect

; 8uS of back porch.
active_back_porch:
	sbi _SFR_IO_ADDR(TVTEXT_SYNC_PORT),TVTEXT_SYNC_BIT ; [1]

	; Have we finished scanning the active display? [25]
	lds YL,scan_region_repeat+0             ; [2]
	lds YH,scan_region_repeat+1             ; [2]
	adiw YL,1                               ; [2]
	sts scan_region_repeat+0,YL             ; [2]
	sts scan_region_repeat+1,YH             ; [2]
	brne active_display_not_finished        ; [2/1]

active_display_finished:
	ldi ZL,lo8(pm(short_vsync_sync))        ; [1] \.
	ldi ZH,hi8(pm(short_vsync_sync))        ; [1]  |
	ldi YL,6                                ; [1]  |_ [7]
	sts scan_region_repeat,YL               ; [2]  |
	jmp active_display_exit                 ; [2] /'
active_display_not_finished_delay:
	rjmp .                                  ; [2] \.
	rjmp .                                  ; [2]  |_ [6]
	rjmp .                                  ; [2] /'
active_display_not_finished:
	ldi ZL,lo8(pm(active_sync))             ; [1] \_ [2]
	ldi ZH,hi8(pm(active_sync))             ; [1] /

	rjmp .                                  ; [2] \.
	rjmp .                                  ; [2]  |_ [5]
	nop                                     ; [1] /'

active_display_exit:
	ldi YL,lo8(cycles_us(t_active_picture)) ; [1] \_ [2]
	ldi YH,hi8(cycles_us(t_active_picture)) ; [1] /

	sts timer1_compa_handler+0,ZL           ; [2] \.
	sts timer1_compa_handler+1,ZH           ; [2]  |_ [8]
	sts _SFR_MEM_ADDR(OCR1AH),YH            ; [2]  |
	sts _SFR_MEM_ADDR(OCR1AL),YL            ; [2] /'

	push r0
	push r1
	push r_font_data_l
	push r_font_data_h
	push r_characters_left
	push r_font_row
	push r_font_invert_mask
	push XL
	push XH

active_display:

	; Delay by the screen offset value.
	lds r_characters_left,tvtext_offset_x
	inc r_characters_left
1:	dec r_characters_left
	brne 1b

	; Is the screen inverted?
	lds r_font_row,tvtext_flags                              ; [1]
	clr r_font_invert_mask                                   ; [1]
	sbrc r_font_row,TVTEXT_INVERTED                          ; [2/1]
	ser r_font_invert_mask                                   ; [1]
	out _SFR_IO_ADDR(TVTEXT_PICTURE_PORT),r_font_invert_mask ; [1]

	; Are we on the screen?
	lds r_characters_left,scanline_counter+1
	or r_characters_left,r_characters_left
	breq 1f
	jmp active_display_skip_scanline
1:

	.if TVTEXT_SKIP_ALTERNATE_ROWS
		lds r_characters_left,scanline_counter+0 ; [2]
		sbrc r_characters_left,0                 ; [2/1]
		jmp active_display_skip_scanline         ; [2]
	.endif

	; Handle the cursor.
	lds YL,cursor_cell+0 ; [2]
	lds YH,cursor_cell+1 ; [2]
	ld r0,Y              ; [1]
	push r0              ; [2]
	lds r0,cursor_char   ; [2]
	st Y,r0              ; [2]

	; Get font data offset.
	ldi r_font_data_l,lo8(tvtext_font_data)
	ldi r_font_data_h,hi8(tvtext_font_data)

	; Offset the font data by the scanline number.
	lds XL,scanline_counter+0
	lsr XL
	andi XL,7
	clr XH
	add r_font_data_l,XL
	adc r_font_data_h,XH

	; Calculate the position in the text buffer:
	lds XL,scanline_counter+0  ; [2]
	swap XL                    ; [1]
	andi XL,15                 ; [1]
	ldi XH,TVTEXT_BUFFER_WIDTH ; [1]
	mul XH,XL                  ; [2]
	
	ldi XL,lo8(tvtext_buffer) ; [1]
	ldi XH,hi8(tvtext_buffer) ; [1]
	add XL,r0                 ; [1]
	adc XH,r1                 ; [1]
	; Fetch first character.

	ldi ZL, 8             ; [1]
	ld r0, X+             ; [2]
	mul r0, ZL            ; [2] Multiply character index by 8.
	add r0, r_font_data_l ; [1] \_ Offset font data row by scanline number.
	adc r1, r_font_data_h ; [1] /
	movw ZL, r0           ; [1]

	; Display first five columns of first character and fetch second one.
	
	; (1)
	lpm r_font_row,Z                                 ; [3]
	eor r_font_row,r_font_invert_mask                ; [1]
	out _SFR_IO_ADDR(TVTEXT_PICTURE_PORT),r_font_row ; [1]
	nop                                              ; [1]
	rol r_font_row                                   ; [1]

	; (2)
	rjmp .                                           ; [2] <- [2] before.
	out _SFR_IO_ADDR(TVTEXT_PICTURE_PORT),r_font_row ; [1]
	ldi ZL,8                                         ; [1] \_ [2] after.
	rol r_font_row                                   ; [1] /

	; (3)
	ld r0,X+                                         ; [2] <- [2] before.
	out _SFR_IO_ADDR(TVTEXT_PICTURE_PORT),r_font_row ; [1]
	mul r0,ZL                                        ; [2] <- [2] after. (Multiply character index by 8).

	; (4)
	rol r_font_row                                   ; [1] \_ [2] before.
	add r0,r_font_data_l                             ; [1] /
	out _SFR_IO_ADDR(TVTEXT_PICTURE_PORT),r_font_row ; [1]
	nop                                              ; [1] \_ [2] after.
	adc r1,r_font_data_h                             ; [1] /  Offset font data row by scanline number.

	; (5)
	movw ZL,r0                                       ; [1] \_ [2] before.
	rol r_font_row                                   ; [1] /
	out _SFR_IO_ADDR(TVTEXT_PICTURE_PORT),r_font_row ; [1]
	ldi r_characters_left,TVTEXT_BUFFER_WIDTH-1      ; [1] \_ [2] after.
	nop                                              ; [1] /

output_scanline_loop:                                ; Clock out the rest of the scanline.

	; (6)
	nop                                              ; [1] \_ [2] before.
	rol r_font_row                                   ; [1] /
	out _SFR_IO_ADDR(TVTEXT_PICTURE_PORT),r_font_row ; [1]
	
	.ifeq TVTEXT_CHARACTER_WIDTH-8
		
		; Shift out an extra two pixels.
		rjmp .                                           ; [2] <- [2] after.
		
		; (7)
		nop                                              ; [1] \_ [2] before.
		rol r_font_row                                   ; [1] /
		out _SFR_IO_ADDR(TVTEXT_PICTURE_PORT),r_font_row ; [1]
		.if TVTEXT_SQUASHED_HORIZONTALLY
			nop                                              ; [1] <- [1] after.
		.else
			rjmp .                                           ; [2] <- [2] after.
		.endif
	
		; (8)
		nop                                              ; [1] \_ [2] before.
		rol r_font_row                                   ; [1] / 
		out _SFR_IO_ADDR(TVTEXT_PICTURE_PORT),r_font_row ; [1]

	.endif
	lpm r_font_row,Z                                 ; [3] <- One of these clock cycles is used below.

	; (1)
	/* One clock cycle left over from LPM */         ; [1] \_ [2] before.
	eor r_font_row,r_font_invert_mask                ; [1]
	out _SFR_IO_ADDR(TVTEXT_PICTURE_PORT),r_font_row ; [1]
	ldi ZL,8                                         ; [1] \_ [2] after.
	rol r_font_row                                   ; [1] /

	; (2)
	ld r0,X+                                         ; [2] <- [2] before.
	out _SFR_IO_ADDR(TVTEXT_PICTURE_PORT),r_font_row ; [1]
	mul r0,ZL                                        ; [2] <- [2] after. (Multiply character index by 8).

	; (3)
	rol r_font_row                                   ; [1] \_ [2] before.
	nop                                              ; [1] /
	out _SFR_IO_ADDR(TVTEXT_PICTURE_PORT),r_font_row ; [1]
	add r0,r_font_data_l                             ; [1] \_ [2] after.
	adc r1,r_font_data_h                             ; [1] /  Offset font data row by scanline number.

	; (4)
	movw ZL,r0                                       ; [1] \_ [2] before.
	rol r_font_row                                   ; [1] /
	out _SFR_IO_ADDR(TVTEXT_PICTURE_PORT),r_font_row ; [1]
	.if TVTEXT_SQUASHED_HORIZONTALLY
		nop                                              ; [2] <- [2] after.
	.else
		rjmp .                                           ; [1] <- [1] after.
	.endif

	; (5)
	rol r_font_row                                   ; [1] \_ [2] before.
	dec r_characters_left                            ; [1] /
	out _SFR_IO_ADDR(TVTEXT_PICTURE_PORT),r_font_row ; [1]
	brne output_scanline_loop                        ; [2/1] \_ [2] after.
	nop                                              ; [1]   /

	; Output final pixel(s).
	; (6)
	nop                                              ; [1]
	rol r_font_row                                   ; [1]
	out _SFR_IO_ADDR(TVTEXT_PICTURE_PORT),r_font_row ; [1]

	.ifeq TVTEXT_CHARACTER_WIDTH-8
		
		; Shift out an extra two pixels.
		rjmp .                                           ; [2] <- [2] after.
		
		; (7)
		nop                                              ; [1] \_ [2] before.
		rol r_font_row                                   ; [1] /
		out _SFR_IO_ADDR(TVTEXT_PICTURE_PORT),r_font_row ; [1]
		.if TVTEXT_SQUASHED_HORIZONTALLY
			nop                                              ; [1] <- [1] after.
		.else
			rjmp .                                           ; [2] <- [2] after.
		.endif

		; (8)
		nop                                              ; [1] \_ [2] before.
		rol r_font_row                                   ; [1] / 
		out _SFR_IO_ADDR(TVTEXT_PICTURE_PORT),r_font_row ; [1]

	.endif

	pop r0                                           ; [2] (Restore character under cursor part 1).

	; Blank rest of scanline.
	st Y,r0                                                  ; [2] (Restore character under cursor part 2).
	out _SFR_IO_ADDR(TVTEXT_PICTURE_PORT),r_font_invert_mask ; [1]

active_display_skip_scanline:

	pop XH
	pop XL
	pop r_font_invert_mask
	pop r_font_row
	pop r_characters_left
	pop r_font_data_h
	pop r_font_data_l
	pop r1
	pop r0

	jmp exit_timer1_compa_vect_no_store
