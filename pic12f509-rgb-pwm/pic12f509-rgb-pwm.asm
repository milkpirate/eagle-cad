;--------------------------------------------------------------------
;
; RGB.asm
;
; Version:    17
; Datum:      24.07.2007
; Controller: PIC12F509-Prozessor mit internem Oszillator
; Licenses:   GPL 3 or any later 
;             GFDL 1.2 or any later
;     
; Funktion:
; Eine 3-Farb-LED wird so angesteuert, so dass der komplette
; RGB-Farbraum abgefahren wird.
;--------------------------------------------------------------------
 
; Assembler-Direktiven
 
                list      P=12F509, r=hex
                include   p12f509.inc
                __CONFIG _WDT_OFF & _MCLRE_OFF & _CP_OFF & _IntRC_OSC
 
#Define Blue  B'001'
#Define Green B'010'
#Define Red   B'100'
#Define Black B'000'
 
;--------------------------------------------------------------------
; MACROS
;--------------------------------------------------------------------
 
movlf   macro const8,var1
            movlw     const8
            movwf     var1
        endm
 
movff   macro var1,var2
            movf      var1,w
            movwf     var2
        endm
 
fade    macro Start,Stopp
            movlf       Start,           b0
            movlf       Stopp,           b1
            Call       FADE0
        endm
 
;--------------------------------------------------------------------
; Variablen
;--------------------------------------------------------------------
 
                cblock     h'10'      
                        c0
                        c1
                        c2
 
                        b1                      ; (=Bitmuster 1)
                        b0                      ; (=Bitmuster 0)
                        ver                     ; Verhaeltnis
                        zu			; (=Zustand -> Entscheid über Startfarbe)
                        zu1			; (=Zustand -> Anzahldurchläufe)
 
                        r0			;Temporäre Zählervariable
                        r1			;Temporäre Zählervariable
        endc
 
;--------------------------------------------------------------------
; Initialisierung
;--------------------------------------------------------------------
                movlf   Black,    GPIO                ; init outputs
 
                movlw   B'01001111'                   ; see Datasheet
                option
 
                movlf   B'00000000',OSCCAL
 
                movlw   B'00011000'                   ;init tris-register
                tris   GPIO
 
;--------------------------------------------------------------------
; Das eigentliche Programm
;--------------------------------------------------------------------
BEGIN   
                movlf   d'1',  zu1			;Ein Durchlauf
 
                btfsc  GPIO,4
                goto   START
 
                movlf   d'3',  zu1			;Alle drei Durchläufe
 
START:
                BTFSC  zu,1				;bei jedem mal drücken eine neue Start Farbe
                goto   Z2
                BTFSC  zu,0
                goto   Z1
 
Z0:             ;fade    Black,  Green
                fade    Blue,  Green
                fade    Green,   Red
                fade    Red,    Blue
                ;fade    Green,  Black
 
                movlf   d'1',  zu
                goto   FOOT
 
Z1:             ;fade    Black,  Blue
                fade    Blue,   Green
                fade    Green,  Red
                fade    Red,    Blue
                ;fade    Blue,   Black
 
                movlf   d'2',  zu
                goto   FOOT
 
Z2:             ;fade    Black,  Red
                fade    Red,    Green
                fade    Green,  Blue
                fade    Blue,   Red
                ;fade    Red,    Black
 
                movlf   d'0',  zu
                goto   FOOT
 
FOOT:           call   BREAK
                decfsz zu1,    f	;mehrere Durchläufe ausführen
                goto   START
 
                btfsc  GPIO,4		;nochmal drei Durchläufe?
                goto   S0
                movlf   d'3',  zu1
                goto   START
 
S0:             btfsc  GPIO,3		;nochmal ein Durchlauf?
                goto   S1
                movlf   d'1',  zu1     
                goto   START
 
S1:             movlf   Black,    GPIO
 
SLP:    sleep                                          ; Wechsel in Sleep Modus
                goto   SLP
 
;--------------------------------------------------------------------
; Unterprogramm fade
;--------------------------------------------------------------------
; Parameter:
;     b0 (=Bitmuster 0) beginnt bei 100% und geht nach   0%
;     b1 (=Bitmuster 1) beginnt bei   0% und geht nach 100%
;
; Wenn das Verhältniss zwischen 0100 0000b  (64d)
;                           und 0111 1111b (127d)
; (also Bit 6 gesetzt) ist, werden mehr durchläufe
; gemacht als sonst. (32 statt 16 durchläufe)
; Damit werden die Mischfarben betont.
 
FADE0:   movlf   d'0',          ver                   ;Verhaeltnis=0
LOP1:           incf   ver,            1              ;Verhaeltnis=Verhaeltnis+1
                btfsc  ver,            6              ;Verhaeltnis Bit 6 gesetzt?
                goto   JA
                movlf   d'16',         r1              ;r1=16
                goto   LOP2
 
JA:             movlf   d'32',         r1              ;r1=32
 
 
 
LOP2:           movff   b0,                     GPIO    ;b0 ausgeben
 
                COMF   ver,            0              ;r0=254-Verhaeltnis
                movwf  r0
 
L1:             DECFSZ r0,                     1              ;r0=r0-1, bis r0=0
                goto   L1
 
                movff   ver,            r0              ;r0=Verhaeltnis
                movff   b1,                     GPIO    ;b1 ausgeben
 
L0:             DECFSZ r0,                     1              ;R0=R0-1, Bis R0=0
                goto   L0
 
                DECFSZ r1,                     1              ;R1=R1-1, Bis R1=0
                goto   LOP2
 
 
                movf   ver,w           ;Bis Verhaeltnis=254
                xorlw  h'FE'
                btfss  STATUS,Z
                goto   LOP1
 
                retlw  h'0'
 
;--------------------------------------------------------------------
; Subprogramm Break
;--------------------------------------------------------------------
; Zeit die vergeht:
;     Rund 500ms
 
BREAK:  movlf     d'5',c2
BL2:    movlf   d'133',c1
BL1:    movlf   d'250',c0
BL0:    DECFSZ c0, f
        goto   BL0
        DECFSZ c1, f
        goto   BL1
        DECFSZ c2, f
        goto   BL2
        retlw  d'0'
;--------------------------------------------------------------------
 
 END