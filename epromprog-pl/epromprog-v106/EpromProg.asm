;	=================================================
;	EPROM-Programmiergerät mit AT90S8515 / ATmega8515
;	=================================================
;
;	Version 1.06, letzte Bearbeitung am 20.04.2013
;
;	----------------------
;	Belegung der I/O-Ports
;	----------------------
;
;	PortA:	Daten-Ein/Ausgänge D0-D7 für EPROM
;
;	PortB0:	Ausgang Aktivitäts-LED (0=ein)
;	PortB1:	Ausgang EEPROM-Spannung Vcc (1=ein)
;	PortB2:	Ausgang EEPROM-Spannung Vcc (0=6,4V, 1=5,0V)
;	PortB3:	Ausgang Programmierspannung Vpp (1=ein)
;	PortB4:	Ausgang /CE für EPROM
;	PortB5:	Ausgang /OE für EPROM
;	PortB6:	Ausgang /PR oder /WE für EPROM
;	PortB7:	Ausgang Latch für A8-A15 (0->1=Datenübernahme)
;
;	PortC0:	Ausgang EPROM A0 (Latch A8)
;	PortC1:	Ausgang EPROM A1 (Latch A9)
;	PortC2:	Ausgang EPROM A2 (Latch A10)
;	PortC3:	Ausgang EPROM A3 (Latch A11)
;	PortC4:	Ausgang EPROM A4 (Latch A12)
;	PortC5:	Ausgang EPROM A5 (Latch A13)
;	PortC6:	Ausgang EPROM A6 (Latch A14)
;	PortC7:	Ausgang EPROM A7 (Latch A15)
;
;	PortD0:	Eingang RS232-TXD
;	PortD1:	Ausgang RS232-RXD
;	PortD2:	Ausgang RS232-CTS
;	PortD3:	Eingang RS232-RTS
;	PortD4:	Ausgang EPROM A16
;	PortD5:	Ausgang EPROM A17
;	PortD6:	Ausgang EPROM A18
;	PortD7:	Ausgang EPROM A19
;
;	------------------
;	Belegung der Timer
;	------------------
;
;	Timer0:	Timeoutzähler für Aktivitäts-LED
;		die LED wird beim Aktivieren des Timers eingeschaltet
;		und beim Auslösen des Overflow-Interrupts wieder
;		augeschaltet
;
;	Timer1:	Timeoutzähler für UART Senden
;		wird bei nicht erfolgreichem Senden eines Zeichens
;		gestartet und nach erfolgreichem Senden wieder
;		deaktiviert; beim Auslösen des Overflow-Interrupts
;		(nach ca. 1,14s) wird in den Fehlerstatus gewechselt
;
;	-----------------------------------
;	Standard-Definitionen für AT90S8515
;	-----------------------------------
;
.nolist
.include "8515def.inc"
.list
;
;	-------------------------------------------------
;	Speicheradressen im SRAM, bitte nicht verschieben
;	-------------------------------------------------
;
.dseg
.org	0x60
;
eprbuf:	.byte	32		;EPROM-Puffer (32 Bytes)
rxbuff:	.byte	64		;UART Empfangspuffer (64 Bytes)
eprdat:	.byte	48		;EPROM-Daten-Puffer (max. 48 Bytes)
erflag:	.byte	1		;Fehler-Flag
				;0= alles ok
				;1= Empfangsregister-Überlauf
				;2= Rahmenfehler
				;3= Empfangspuffer-Überlauf
				;4= Hexfile-Fehler
				;5= Unbekannter Fehler
prmode:	.byte	1		;aktueller Gerätemodus (wird bei einem
				;Sendefehler zum Abschalten des EPROMs
				;benötigt)
				;0= Menüfunktion
				;1= Programmieren
				;2= Lesen
prgver:	.byte	1		;Programmieren/Vergleich-Flag (wird zur
				;Unterscheidung zwischen Programmieren
				;und Vergleichen benötigt)
				;0= Programmieren
				;1= Vergleichen
readmo:	.byte	1		;Lese-Modus
				;0= alle Bytes werden gelesen
				;1= 0xff-Zeilen werden nicht gelesen
langua:	.byte	1		;Sprachauswahl
				;0= deutsch
				;1= englisch
adbuf0:	.byte	1		;Adress-Puffer Byte 0 (A0-A7)
adbuf1:	.byte	1		;Adress-Puffer Byte 1 (A8-A15)
adbuf2:	.byte	1		;Adress-Puffer Byte 2 (A16-A19)
	.byte	8		;nicht genutzt
hexbuf:	.byte	100		;Hexpuffer für ein- und ausgehende
				;Daten
;
;	----------
;	Konstanten
;	----------
;
.equ	clock=	3686400		;Taktfrequenz= 3,6864 MHz
;
.equ	cr=	13		;Zeichencode Cariage Return / Enter
.equ	lf=	10		;Zeichencode Line Feed
.equ	esc=	27		;Zeichencode Escape
;
.equ	recsiz=	38		;Größe eines EPROM-Tabelleneintrages
.equ	eprjmp=	12		;Tabellenposition der Jumperstellung
.equ	eprsiz=	22		;Tabellenposition der EPROM-Größe
.equ	eproga=	26		;Tabellenposition Prog-Aktivieren
.equ	eprogb=	28		;Tabellenposition Prog-Deaktivieren
.equ	eprogc=	30		;Tabellenposition Programmieren 1
.equ	eprogd=	32		;Tabellenposition Programmieren 2
.equ	eerase=	34		;Tabellenposition Löschen ausführen
.equ	eprim1=	36		;Tab-Pos. Anzahl Programmierimpulse 1
.equ	eprim2=	37		;Tab-Pos. Anzahl Programmierimpulse 2
;
;	---------------------
;	Register-Definitionen
;	---------------------
;
.def	isreg=	r1		;Zwischenspeicher für SREG während
				;der Interrupt-Routinen
.def	rxpoi1=	r2		;UART Empfangspuffer-Pointer1
				;aktuelle Ringpuffer-Schreibposition
.def	rxpoi2=	r3		;UART Empfangspuffer-Pointer2
				;aktuelle Ringpuffer-Leseposition
.def	hexpo1=	r4		;Hexpuffer-Pointer Schreibposition
.def	hexpo2=	r5		;Hexpuffer-Pointer Leseposition
.def	chksum=	r6		;Checksumme für Hexfile
.def	dbcoun=	r7		;Datenbyte-Zähler
.def	adrlow=	r8		;EPROM-Adresse Low
.def	adrhig=	r9		;EPROM-Adresse High
.def	seglow=	r10		;EPROM-Segment Low
.def	seghig=	r11		;EPROM-Segment High
.def	tcount=	r12		;temporärer Zähler
.def	terrfl=	r13		;temporäres Fehlerflag
.def	itemp=	r25		;temporäres Register für Interrupt
;
;	------------------
;	Macro-Definitionen
;	------------------
;
.macro	led_on				;Aktiv-LED einschalten
	cbi	portb,0			;PortB1 löschen
.endmacro
.macro	led_off				;Aktiv-LED ausschalten
	sbi	portb,0			;PortB1 setzen
.endmacro
.macro	vcc_on				;Vcc einschalten
	sbi	portb,1			;PortB1 setzen
.endmacro
.macro	vcc_off				;Vcc ausschalten
	cbi	portb,1			;PortB1 löschen
.endmacro
.macro	vcc_50				;Vcc auf 5,0V setzen
	sbi	portb,2			;PortB2 setzen
.endmacro
.macro	vcc_64				;Vcc auf 6,4V setzen
	cbi	portb,2			;PortB2 löschen
.endmacro
.macro	vpp_on				;Vpp einschalten
	sbi	portb,3			;PortB3 setzen
.endmacro
.macro	vpp_off				;Vpp ausschalten
	cbi	portb,3			;PortB3 löschen
.endmacro
.macro	ce_low				;/CE auf Low setzen
	cbi	portb,4			;PortB4 löschen
.endmacro
.macro	ce_high				;/CE auf High setzen
	sbi	portb,4			;PortB4 setzen
.endmacro
.macro	oe_low				;/OE auf Low setzen
	cbi	portb,5			;PortB5 löschen
.endmacro
.macro	oe_high				;/OE auf High setzen
	sbi	portb,5			;PortB5 löschen
.endmacro
.macro	pr_low				;/PR auf Low setzen
	cbi	portb,6			;PortB6 löschen
.endmacro
.macro	pr_high				;/PR auf High setzen
	sbi	portb,6			;PortB6 löschen
.endmacro
.macro	cts_on				;RS232-CTS aktivieren
	cbi	portd,2			;PortD2 löschen
.endmacro
.macro	cts_off				;RS232-CTS deaktivieren
	sbi	portd,2			;PortD2 setzen
.endmacro
;
;	--------------
;	Programmbeginn
;	--------------
;
;	Interrupt-Vektoren
;
.cseg
.org	0x0000
;
reset:	rjmp	start			;Programmstart
exint0:	reti				;nicht genutzt
exint1:	reti				;nicht genutzt
t1icap:	reti				;nicht genutzt
t1coma:	reti				;nicht genutzt
t1comb:	reti				;nicht genutzt
t1ovfl:	rjmp	t1oint			;Timer1, Timeout UART senden
t0ovfl:	rjmp	t0oint			;Timer0, Leuchtdauer Status-LED
spiint:	reti				;nicht genutzt
uarrxc:	rjmp	rxcint			;UART Empfang komplett
uartxe:	reti				;nicht genutzt
uartxc:	reti				;nicht genutzt
ancomp:	reti				;nicht genutzt
;
;	Initialisierung von I/O, RAM und Interrupts
;
start:	cli				;Interrupts sperren
	ldi	zl,0x60			;Zeiger auf RAM-Anfang
	ldi	zh,0
	ldi	yl,low(ramend+1)	;Zeiger auf RAM-Ende+1
	ldi	yh,high(ramend+1)
	clr	r16
sta010:	st	z+,r16			;Speicherzelle löschen
	cp	zl,yl
	brne	sta010
	cp	zh,yh			;Ende erreicht?
	brne	sta010			;nein -> Schleife
	ldi	r16,low(ramend)
	ldi	r17,high(ramend)
	out	spl,r16
	out	sph,r17			;Stackpointer setzen
;
	clr	r16
	out	porta,r16		;PortA Pullup ausschalten
	out	ddra,r16		;PortA0-A7 als Eingänge
	out	portb,r16		;PortB0-B7 auf Low setzen
	ser	r16
	out	ddrb,r16		;PortB0-B7 als Ausgänge
	clr	r16
	out	portc,r16		;PortC0-C7 auf Low setzen
	ser	r16
	out	ddrc,r16		;PortC0-C7 als Ausgänge
	rcall	adrclr			;Adresse löschen und ausgeben
	clr	r16
	out	portd,r16		;PortD0-D7 auf Low setzen
	ldi	r16,0b11110110
	out	ddrd,r16		;PortD0,D3 als Eingänge (RTS)
;
	ldi	r16,rxbuff		;Pointer für Empfangspuffer
	mov	rxpoi1,r16		;Pointer 1 setzen
	mov	rxpoi2,r16		;Pointer 2 setzen
;
	ldi	r16,low(eptent)		;Zeiger auf EEPROM
	ldi	r17,high(eptent)	;(EPROM-Tabellen-Eintrag)
	rcall	eeread			;EEPROM lesen
	mov	r22,r18			;gelesenen Wert als Einer sp.
	andi	r22,0x0f		;unteres Nibble filtern
	mov	r23,r18			;gelesenen Wert als Zehner sp.
	swap	r23			;Nibbles tauschen
	andi	r23,0x0f		;unteres Nibble filtern
	cpi	r23,10			;Zehner>9?
	brcc	sta020			;ja -> Fehler, Eintrag 0 setzen
	cpi	r22,10			;Einer>9?
	brcs	sta030			;nein -> weiter
sta020:	clr	r23			;sonst Fehler, Zehner und
	clr	r22			;Einer auf Eintrag 0 setzen
sta030:	rcall	eprget			;EPROM-Daten in Puffer kopieren
;
	ldi	r16,low(ebaudr)		;Zeiger auf EEPROM
	ldi	r17,high(ebaudr)	;(gespeicherte RS232-Baudrate)
	rcall	eeread			;EEPROM lesen
	ldi	r16,(clock/(16*115200))-1;115200 Baud setzen (default)
	cpi	r18,5			;Baudrate=9600?
	brne	sta040			;nein -> weiter testen
	ldi	r16,(clock/(16*9600))-1	;sonst 9600 Baud setzen
	rjmp	sta070
sta040:	cpi	r18,4			;Baudrate=19200?
	brne	sta050			;nein -> weiter testen
	ldi	r16,(clock/(16*19200))-1;sonst 19200 Baud setzen
	rjmp	sta070
sta050:	cpi	r18,3			;Baudrate=38400?
	brne	sta060			;nein -> weiter testen
	ldi	r16,(clock/(16*38400))-1;sonst 38400 Baud setzen
	rjmp	sta070
sta060:	cpi	r18,2			;Baudrate=57600?
	brne	sta070			;nein -> default verwenden
	ldi	r16,(clock/(16*57600))-1;sonst 57600 Baud setzen
;
sta070:	out	ubrr,r16		;Baudratenwert setzen
	ldi	r16,(1<<rxcie)+(1<<rxen)+(1<<txen)
	out	ucr,r16			;RX/TX aktivieren (RX-Int)
	ldi	r16,(1<<toie1)+(1<<toie0);Timer0 und Timer1 Overflow
	out	timsk,r16		;Interrupt aktivieren
;
	ldi	r16,low(ereadm)		;Zeiger auf EEPROM
	ldi	r17,high(ereadm)	;(Lese-Modus)
	rcall	eeread			;EEPROM lesen
	sts	readmo,r18		;und Wert speichern
	ldi	r16,low(elangu)		;Zeiger auf EEPROM
	ldi	r17,high(elangu)	;(Sprachauswahl)
	rcall	eeread			;EEPROM lesen
	sts	langua,r18		;und Wert speichern
;
	cts_on				;CTS aktivieren
	sei				;Interrupts aktivieren
	led_on				;LED einsschalten
;
;
;	----------------------------------------------
;	Hauptprogrammschleife, Begrüßungstext ausgeben
;	----------------------------------------------
;
	ldi	r16,20			;20x50ms= 1 Sekunde warten
sta100:	rcall	wa50ms			;50ms Warteschleife
	dec	r16			;alle Zyklen komplett?
	brne	sta100			;nein -> Schleife
	ldi	r17,0x0d		;CR senden zur Synchronisation
	rcall	putchr			;nach dem Einschalten
	rcall	wa50ms			;nochmals 50ms warten
	ldi	zl,low(inistr*2)
	ldi	zh,high(inistr*2)	;Zeiger auf Start-Text
	rcall	sndtx1			;Text senden
	led_off				;LED aussschalten
	rjmp	menu1			;weiter mit Menü1
;
;	Rückkehr in Menü1, warten auf Enter-Taste
;
restrt:	ldi	zl,low(resstd*2)
	ldi	zh,high(resstd*2)	;Zeiger auf Restart-Text
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	res010			;ja -> weiter
	ldi	zl,low(resste*2)	;sonst englisch benutzen
	ldi	zh,high(resste*2)	;Zeiger auf Restart-Text
res010:	rcall	sndtx1			;Text senden
res020:	lds	r16,erflag		;Fehlerflag holen
	tst	r16			;Fehler aufgetreten?
	breq	res030			;nein -> weiter
	rjmp	error			;sonst zur Fehlerbehandlung
res030:	rcall	getchr			;Zeichen aus Puffer holen
	tst	r16			;neues Zeichen?
	brne	res020			;nein -> Schleife
	cpi	r17,cr			;ENTER empfangen?
	brne	res020			;nein -> Schleife
	rcall	sncrlf			;sonst CR/LF senden
	rcall	sncrlf			;CR/LF senden
;
;	Menü 1 - Text ausgeben
;
menu1:	clr	r16
	sts	prmode,r16		;Gerät in Menü-Modus setzen
	ldi	zl,low(m1astd*2)
	ldi	zh,high(m1astd*2)	;Zeiger auf Menü1-Text (Teil A)
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	m1x005			;ja -> weiter
	ldi	zl,low(m1aste*2)	;sonst englisch benutzen
	ldi	zh,high(m1aste*2)	;Zeiger auf Menü1-Text (Teil A)
m1x005:	rcall	sndtx1			;Text senden
	ldi	zl,low(eprdat)		;Zeiger auf EPROM-Daten-Puffer
	ldi	zh,high(eprdat)		;(EPROM-Name)
	ldi	r18,eprjmp		;Länge des EPROM-Namens
m1x010:	ld	r17,z+			;Zeichen holen
	rcall	putchr			;Zeichen ausgeben
	dec	r18			;alle Zeichen ausgegeben?
	brne	m1x010			;nein -> Schleife
;
	ldi	zl,low(m1bstd*2)
	ldi	zh,high(m1bstd*2)	;Zeiger auf Menü1-Text (Teil B)
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	m1x013			;ja -> weiter
	ldi	zl,low(m1bste*2)	;sonst englisch benutzen
	ldi	zh,high(m1bste*2)	;Zeiger auf Menü1-Text (Teil B)
m1x013:	rcall	sndtx1			;Text senden
	lds	r16,eprdat+eprsiz+1	;EPROM-Größe, High-Byte
	lds	r17,eprdat+eprsiz+2	;EPROM-Größe, Byte3
	ror	r17
	ror	r16
	ror	r17			;Wert durch 4 teilen,
	ror	r16			;ergibt EPROM-Größe in kB
	clr	r15			;Vornull-Flag löschen
	ldi	r23,4			;4 Dezimalstellen ermitteln
	ldi	r18,low(1000)
	ldi	r19,high(1000)		;Tausender ermitteln
	cpi	r23,4			;Tausender-Stelle?
	breq	dez010			;ja -> weiter
dez000:	ldi	r18,low(100)
	ldi	r19,high(100)		;Hunderter ermitteln
	cpi	r23,3			;Hunderter-Stelle?
	breq	dez010			;ja -> weiter
	ldi	r18,low(10)
	ldi	r19,high(10)		;Zehner ermitteln
	cpi	r23,2			;Zehner-Stelle?
	breq	dez010			;ja -> weiter
	ldi	r18,low(1)
	ldi	r19,high(1)		;Einer ermitteln
dez010:	clr	r22			;Zähler löschen
dez020:	mov	r20,r16			;Eingangswert sichern
	mov	r21,r17
	sub	r16,r18			;Subtrahend abziehen
	sbc	r17,r19			;Ergebnis negativ?
	brcs	dez030			;ja -> weiter
	inc	r22			;sonst Zähler +1
	rjmp	dez020			;Schleife
dez030:	mov	r17,r22			;ermittelten Stellenwert holen
	tst	r17			;Wert=0?
	brne	dez040			;nein -> ausgeben
	tst	r15			;Vornull?
	breq	dez050			;ja -> Ausgabe überspringen
dez040:	ori	r17,0x30		;Zahl in ASCII wandeln
	rcall	putchr			;Zeichen ausgeben
	inc	r15			;Vornull-Flag setzen
dez050:	mov	r16,r20
	mov	r17,r21			;Eingangswert restaurieren
	dec	r23			;Stellenzähler-1, Ende?
	brne	dez000			;nein -> Schleife
;
	ldi	zl,low(m1cstd*2)
	ldi	zh,high(m1cstd*2)	;Zeiger auf Menü1-Text (Teil C)
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	m1x015			;ja -> weiter
	ldi	zl,low(m1cste*2)	;sonst englisch benutzen
	ldi	zh,high(m1cste*2)	;Zeiger auf Menü1-Text (Teil C)
m1x015:	rcall	sndtx1			;Text senden
	ldi	zl,low(eprdat+eprjmp)	;Zeiger auf EPROM-Daten-Puffer
	ldi	zh,high(eprdat+eprjmp)	;(Jumper-Stellung)
	ldi	r18,eprsiz-eprjmp	;Länge der EPROM-Jumperdaten
	ldi	r19,1			;Jumpernummer=1
m1x020:	mov	r17,r19			;Jumpernummer holen
	cpi	r17,10			;Jumpernummer zweistellig?
	brcs	m1x030			;nein -> weiter
	ldi	r17,'1'			;sonst erst Zehner ausgeben
	rcall	putchr			;Zeichen ausgeben
	mov	r17,r19			;dann Einer holen
	subi	r17,10			;und berechnen
m1x030:	ori	r17,0x30		;in ASCII wandeln
	rcall	putchr			;Zeichen ausgeben
	ldi	r17,'-'			;Trennzeichen
	rcall	putchr			;Zeichen ausgeben
	ld	r17,z+			;Jumper-Zeichen holen
	rcall	putchr			;Zeichen ausgeben
	inc	r19			;Jumpernummer erhöhen
	dec	r18			;alle Zeichen ausgegeben?
	breq	m1x040			;ja -> Schleife beenden
	ldi	r17,' '			;sonst Trennzeichen
	rcall	putchr			;Zeichen ausgeben
	rcall	putchr			;Zeichen ausgeben
	rjmp	m1x020			;Schleife
m1x040:	ldi	zl,low(m1dstd*2)
	ldi	zh,high(m1dstd*2)	;Zeiger auf Menü1-Text (Teil D)
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	m1x045			;ja -> weiter
	ldi	zl,low(m1dste*2)	;sonst englisch benutzen
	ldi	zh,high(m1dste*2)	;Zeiger auf Menü1-Text (Teil D)
m1x045:	rcall	sndtx1			;Text senden
	lds	r16,readmo		;Lese-Modus holen
	tst	r16			;Lese-Modus=0? (alle Bytes)
	brne	m1x050			;nein -> weiter
	ldi	zl,low(m1estd*2)
	ldi	zh,high(m1estd*2)	;Zeiger auf Menü1-Text (Teil E)
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	m1x060			;ja -> weiter
	ldi	zl,low(m1este*2)	;sonst englisch benutzen
	ldi	zh,high(m1este*2)	;Zeiger auf Menü1-Text (Teil E)
	rjmp	m1x060			;ausgeben
m1x050:	ldi	zl,low(m1fstd*2)
	ldi	zh,high(m1fstd*2)	;Zeiger auf Menü1-Text (Teil F)
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	m1x060			;ja -> weiter
	ldi	zl,low(m1fste*2)	;sonst englisch benutzen
	ldi	zh,high(m1fste*2)	;Zeiger auf Menü1-Text (Teil F)
m1x060:	rcall	sndtx1			;Text senden
	ldi	zl,low(m1gstd*2)
	ldi	zh,high(m1gstd*2)	;Zeiger auf Menü1-Text (Teil G)
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	m1x070			;ja -> weiter
	ldi	zl,low(m1gste*2)	;sonst englisch benutzen
	ldi	zh,high(m1gste*2)	;Zeiger auf Menü1-Text (Teil G)
m1x070:	rcall	sndtx1			;Text senden
;
;	Menü 1 - Auswahl abfragen
;
m1x100:	lds	r16,erflag		;Fehlerflag holen
	tst	r16			;Fehler aufgetreten?
	breq	m1x110			;nein -> weiter
	rjmp	error			;sonst zur Fehlerbehandlung
m1x110:	rcall	getchr			;Zeichen aus Puffer holen
	tst	r16			;neues Zeichen?
	brne	m1x100			;nein -> Schleife
	cpi	r17,'1'			;Typauswahl?
	brne	m1x120			;nein -> weiter testen
	rcall	putchr			;sonst Echo an Terminal senden
	rcall	sncrlf			;CR/LF senden
	rcall	sncrlf			;CR/LF senden
	rjmp	menu2			;weiter mit Menü2
m1x120:	cpi	r17,'2'			;Programmieren?
	brne	m1x130			;nein -> weiter testen
	rcall	putchr			;sonst Echo an Terminal senden
	rcall	sncrlf			;CR/LF senden
	rcall	sncrlf			;CR/LF senden
	clr	r16			;Status
	sts	prgver,r16		;auf Programmieren setzen
	rjmp	progrm			;weiter mit Programm./Vergleich
m1x130:	cpi	r17,'3'			;Vergleichen?
	brne	m1x140			;nein -> weiter testen
	rcall	putchr			;sonst Echo an Terminal senden
	rcall	sncrlf			;CR/LF senden
	rcall	sncrlf			;CR/LF senden
	ldi	r16,1			;Status
	sts	prgver,r16		;auf Vergleichen setzen
	rjmp	progrm			;weiter mit Programm./Vergleich
m1x140:	cpi	r17,'4'			;Lesen?
	brne	m1x150			;nein -> weiter testen
	rcall	putchr			;sonst Echo an Terminal senden
	rcall	sncrlf			;CR/LF senden
	rcall	sncrlf			;CR/LF senden
	rjmp	read			;weiter mit Lesen
m1x150:	cpi	r17,'5'			;Leertest?
	brne	m1x160			;nein -> weiter testen
	rcall	putchr			;sonst Echo an Terminal senden
	rcall	sncrlf			;CR/LF senden
	rcall	sncrlf			;CR/LF senden
	rjmp	cltest			;weiter mit Leertest
m1x160:	cpi	r17,'6'			;Löschen?
	brne	m1x170			;nein -> weiter testen
	rcall	putchr			;sonst Echo an Terminal senden
	rcall	sncrlf			;CR/LF senden
	rcall	sncrlf			;CR/LF senden
	rjmp	erase			;weiter mit Löschen
m1x170:	cpi	r17,'7'			;Lese-Modus ändern?
	brne	m1x180			;nein -> weiter testen
	rcall	putchr			;sonst Echo an Terminal senden
	rcall	sncrlf			;CR/LF senden
	rcall	sncrlf			;CR/LF senden
	rjmp	chread			;weiter mit Lese-Modus ändern
m1x180:	cpi	r17,'8'			;Sprache ändern?
	brne	m1x190			;nein -> weiter testen
	rcall	putchr			;sonst Echo an Terminal senden
	rcall	sncrlf			;CR/LF senden
	rcall	sncrlf			;CR/LF senden
	rjmp	chlang			;weiter mit Sprache ändern
m1x190:	cpi	r17,'9'			;RS232 einstellen?
	brne	m1x200			;nein -> Schleife
	rcall	putchr			;sonst Echo an Terminal senden
	rcall	sncrlf			;CR/LF senden
	rcall	sncrlf			;CR/LF senden
	rjmp	menu3			;weiter mit Menü3
m1x200:	cpi	r17,esc			;RS232 einstellen?
	breq	m1x210			;ja -> bearbeiten
	rjmp	m1x100			;sonst Schleife
m1x210:	rcall	sncrlf			;CR/LF senden
	rcall	sncrlf			;CR/LF senden
	rjmp	menu1			;Menü1 wieder neu aufbauen
;
;	Menü 2 - Text ausgeben
;
menu2:	clr	r16
	sts	prmode,r16		;Gerät in Menü-Modus setzen
	ldi	zl,low(m2astd*2)
	ldi	zh,high(m2astd*2)	;Zeiger auf Menü2-Text (Teil A)
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	m2x090			;ja -> weiter
	ldi	zl,low(m2aste*2)	;sonst englisch benutzen
	ldi	zh,high(m2aste*2)	;Zeiger auf Menü2-Text (Teil A)
m2x090:	rcall	sndtx1			;Text senden
	clr	r19			;Spaltenzähler löschen
	clr	r20			;EPROM-Zähler Einer löschen
	clr	r21			;EPROM-Zähler Zehner löschen
	ldi	r22,low(eprtab*2)
	ldi	r23,high(eprtab*2)	;Zeiger auf EPROM-Tabelle
m2x100:	tst	r19			;erste Spalte?
	brne	m2x110			;nein -> weiter
	rcall	sncrlf			;CR/LF senden
m2x110:	inc	r19			;Spaltenzähler erhöhen
	andi	r19,0x03		;Übertrag löschen
	mov	r17,r21			;Zehner holen
	ori	r17,0x30		;in ASCII wandeln
	rcall	putchr			;und ausgeben
	mov	r17,r20			;Einer holen
	ori	r17,0x30		;in ASCII wandeln
	rcall	putchr			;und ausgeben
	ldi	r17,':'
	rcall	putchr			;Trennzeichen ausgeben
	ldi	r17,' '
	rcall	putchr			;Trennzeichen ausgeben
	ldi	r18,eprjmp		;Länge des EPROM-Namens
	mov	zl,r22
	mov	zh,r23			;Zeiger auf EPROM-Text laden
	rcall	sndtx2			;Text ausgeben
	ldi	r17,' '
	rcall	putchr			;Trennzeichen ausgeben
	ldi	r17,' '
	rcall	putchr			;Trennzeichen ausgeben
	mov	zl,r22
	mov	zh,r23			;Zeiger auf EPROM-Text laden
	adiw	zl,recsiz		;nächste Position berechnen
	mov	r22,zl
	mov	r23,zh			;neue Position speichern
	lpm				;erstes zeichen holen
	inc	r0			;Endezeichen?
	breq	m2x200			;ja -> Ausgabe beenden
	inc	r20			;EPROM-Zähler Einer erhöhen
	cpi	r20,10			;Übertrag?
	brcs	m2x100			;nein -> Schleife
	clr	r20			;sonst Einer löschen und
	inc	r21			;EPROM-Zähler Zehner erhöhen
	rjmp	m2x100
;
m2x200:	ldi	zl,low(m2bstd*2)
	ldi	zh,high(m2bstd*2)	;Zeiger auf Menü2-Text (Teil B)
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	m2x210			;ja -> weiter
	ldi	zl,low(m2bste*2)	;sonst englisch benutzen
	ldi	zh,high(m2bste*2)	;Zeiger auf Menü2-Text (Teil B)
m2x210:	rcall	sndtx1			;Text senden
	mov	r17,r21			;Zähler Zehner holen
	ori	r17,0x30		;in ASCII wandeln
	rcall	putchr			;und ausgeben
	mov	r17,r20			;Zähler Einer holen
	ori	r17,0x30		;in ASCII wandeln
	rcall	putchr			;und ausgeben
	ldi	zl,low(m2cstd*2)
	ldi	zh,high(m2cstd*2)	;Zeiger auf Menü2-Text (Teil C)
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	m2x220			;ja -> weiter
	ldi	zl,low(m2cste*2)	;sonst englisch benutzen
	ldi	zh,high(m2cste*2)	;Zeiger auf Menü2-Text (Teil C)
m2x220:	rcall	sndtx1			;Text senden
;
;	Menü 2 - Auswahl abfragen
;
	clr	r23			;Puffer für Zehnereingabe
	clr	r22			;Puffer für Einereingabe
m2x300:	lds	r16,erflag		;Fehlerflag holen
	tst	r16			;Fehler aufgetreten?
	breq	m2x310			;nein -> weiter
	rjmp	error			;sonst zur Fehlerbehandlung
m2x310:	rcall	getchr			;Zeichen aus Puffer holen
	tst	r16			;neues Zeichen?
	brne	m2x300			;nein -> Schleife
	cpi	r17,esc			;ESC empfangen?
	breq	m2x500			;ja -> bearbeiten
	cpi	r17,'0'			;Zeichen<'0'?
	brcs	m2x300			;ja -> ignorieren
	cpi	r17,'9'+1		;Zeichen>'9'?
	brcc	m2x300			;ja -> ignorieren
	rcall	putchr			;Echo an Terminal senden
	tst	r23			;Zehner schon empfangen?
	brne	m2x320			;ja -> Einer bearbeiten
	mov	r23,r17			;sonst Zehner speichern
	rjmp	m2x300
m2x320:	mov	r22,r17			;Einer speichern
	andi	r23,0x0f		;Zehner-Ziffer filtern
	andi	r22,0x0f		;Einer-Ziffer filtern
	rcall	sncrlf			;CR/LF senden
	rcall	sncrlf			;CR/LF senden
	mov	r18,r21			;gespeicherten Zehner holen
	swap	r18			;in oberes Nibble legen
	add	r18,r20			;gespeicherten Einer holen
	mov	r19,r23			;eingegebenen Zehner holen
	swap	r19			;in oberes Nibble legen
	add	r19,r22			;eingegebenen Einer holen
	sub	r18,r19			;eingegebene Daten sinnvoll?
	brcc	m2x400			;ja -> weiter
	rjmp	menu2			;sonst neue Eingabe
m2x400:	ldi	r16,low(eptent)		;Zeiger auf EEPROM
	ldi	r17,high(eptent)	;(EPROM-Tabellen-Eintrag)
	mov	r18,r23			;Zehner holen
	swap	r18			;in oberes Nibble legen
	or	r18,r22			;mit Einer verknüpfen
	rcall	eewrit			;in EEPROM schreiben
	rcall	eprget			;EPROM-Tabellenplatz berechnen
	rjmp	menu1			;und Daten in Puffer legen
m2x500:	rcall	sncrlf			;CR/LF senden
	rcall	sncrlf			;CR/LF senden
	rjmp	menu1			;zurück in Menü1
;
;	Menü 3 - Text ausgeben, Auswahl abfragen
;
menu3:	clr	r16
	sts	prmode,r16		;Gerät in Menü-Modus setzen
	ldi	zl,low(m3astd*2)
	ldi	zh,high(m3astd*2)	;Zeiger auf Menü3-Text (Teil A)
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	m3x090			;ja -> weiter
	ldi	zl,low(m3aste*2)	;sonst englisch benutzen
	ldi	zh,high(m3aste*2)	;Zeiger auf Menü3-Text (Teil A)
m3x090:	rcall	sndtx1			;Text senden
;
m3x100:	lds	r16,erflag		;Fehlerflag holen
	tst	r16			;Fehler aufgetreten?
	breq	m3x110			;nein -> weiter
	rjmp	error			;sonst zur Fehlerbehandlung
m3x110:	rcall	getchr			;Zeichen aus Puffer holen
	tst	r16			;neues Zeichen?
	brne	m3x100			;nein -> Schleife
	cpi	r17,esc			;ESC empfangen?
	breq	m2x500			;ja -> zurück in Menü1
	cpi	r17,'6'			;Eingabe>5?
	brcc	m3x100			;ja -> Schleife
	cpi	r17,'1'			;Eingabe<1?
	brcs	m3x100			;ja -> Schleife
	rcall	putchr			;sonst Echo an Terminal senden
	mov	r19,r17			;Zeichen kopieren
	andi	r19,0x0f		;in Binärcode wandeln
	ldi	r16,low(ebaudr)		;Zeiger auf EEPROM
	ldi	r17,high(ebaudr)	;(gespeicherte RS232-Baudrate)
	rcall	eeread			;aktuellen Baudratenwert holen
	cp	r18,r19			;Wert-Änderung?
	brne	m3x120			;ja -> weiter
	rcall	sncrlf			;CR/LF senden
	rcall	sncrlf			;CR/LF senden
	rjmp	menu1			;zurück ins Menü1
;
m3x120:	mov	r18,r19			;neuen Baudratenwert kopieren
	rcall	eewrit			;und im EEPROM speichern
	ldi	zl,low(m3bstd*2)
	ldi	zh,high(m3bstd*2)	;Zeiger auf Menü3-Text (Teil B)
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	m3x130			;ja -> weiter
	ldi	zl,low(m3bste*2)	;sonst englisch benutzen
	ldi	zh,high(m3bste*2)	;Zeiger auf Menü3-Text (Teil B)
m3x130:	rcall	sndtx1			;Text senden
;
m3x200:	led_on				;LED einschalten
	ldi	r16,10			;10x50ms= 0,5 Sekunde warten
m3x210:	rcall	wa50ms			;50ms Warteschleife
	dec	r16			;alle Zyklen komplett?
	brne	m3x210			;nein -> Schleife
	led_off				;LED ausschalten
	ldi	r16,10			;10x50ms= 0,5 Sekunde warten
m3x220:	rcall	wa50ms			;50ms Warteschleife
	dec	r16			;alle Zyklen komplett?
	brne	m3x220			;nein -> Schleife
	rjmp	m3x200			;Endlosschleife
;
;	EPROM programmieren oder vergleichen
;
progrm:	ldi	zl,low(pr1std*2)
	ldi	zh,high(pr1std*2)	;Zeiger auf Program-Text
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	pro010			;ja -> weiter
	ldi	zl,low(pr1ste*2)	;sonst englisch benutzen
	ldi	zh,high(pr1ste*2)	;Zeiger auf Program-Text
pro010:	rcall	sndtx1			;Text senden
	clr	seglow
	clr	seghig			;Segment-Adresse initialisieren
pro020:	clr	hexpo1			;Hexpuffer-Zeiger löschen
;
pro030:	lds	r16,erflag		;Fehlerflag holen
	tst	r16			;Fehler aufgetreten?
	breq	pro040			;nein -> weiter
	rjmp	error			;sonst zur Fehlerbehandlung
pro040:	rcall	getchr			;Zeichen aus Puffer holen
	tst	r16			;neues Zeichen?
	brne	pro030			;nein -> Schleife
	cpi	r17,esc			;ESC empfangen?
	brne	pro050			;nein -> weiter testen
	rjmp	menu1			;sonst zurück ins Menü1
pro050:	cpi	r17,cr			;ENTER empfangen?
	brne	pro060			;nein -> weiter testen
	rjmp	pro090			;sonst Hexpuffer bearbeiten
pro060:	cpi	r17,lf			;LF empfangen?
	brne	pro070			;nein -> weiter testen
	rjmp	pro090			;sonst Hexpuffer bearbeiten
pro070:	cpi	r17,' '			;Leerzeichen empfangen?
	brne	pro080			;nein -> weiter testen
	rjmp	pro030			;sonst ignorieren
pro080:	mov	yl,hexpo1
	ldi	yh,1			;sonst Hexpuffer-Zeiger laden
	cpi	yl,80			;mehr als 80 Zeichen im Puffer?
	brcc	pro030			;ja -> Zeichen verwerfen
	st	y+,r17			;sonst Zeichen speichern
	mov	hexpo1,yl		;Hexpuffer-Zeiger speichern
	rjmp	pro030			;Schleife
;
pro090:	mov	hexpo2,hexpo1		;Anzahl der empfangenen Zeichen
	tst	hexpo2			;sichern, Puffer leer?
	breq	pro030			;ja -> Schleife (ignorieren)
	clr	yl
	ldi	yh,1			;Zeiger auf Hexpuffer
	clr	chksum			;Checksumme initialisieren
	ld	r17,y+			;Zeichen aus Hexpuffer holen
	cpi	r17,':'			;Startzeichen?
	breq	pro100			;ja -> weiter
	rjmp	proerr			;sonst Hexfile-Fehler
pro100:	rcall	hexbin			;zwei Zeichen in Binärcode
	tst	r16			;wandeln, erfolgreich?
	breq	pro110			;ja -> weiter
	rjmp	proerr			;sonst Hexfile-Fehler
pro110:	cpi	r17,33			;Byteanzahl>32?
	brcs	pro120			;nein -> weiter
	rjmp	proerr			;sonst Hexfile-Fehler
pro120:	add	chksum,r17		;Checksumme aktualisieren
	mov	dbcoun,r17		;Byteanzahl speichern
	mov	tcount,r17		;Byteanzahl in temporär. Zähler
	rcall	hexbin			;zwei Zeichen in Binärcode
	tst	r16			;wandeln, erfolgreich?
	breq	pro130			;ja -> weiter
	rjmp	proerr			;sonst Hexfile-Fehler
pro130:	add	chksum,r17		;Checksumme aktualisieren
	mov	adrhig,r17		;EPROM-Adresse High speichern
	rcall	hexbin			;zwei Zeichen in Binärcode
	tst	r16			;wandeln, erfolgreich?
	breq	pro140			;ja -> weiter
	rjmp	proerr			;sonst Hexfile-Fehler
pro140:	mov	adrlow,r17		;EPROM-Adresse Low speichern
	add	chksum,r17		;Checksumme aktualisieren
	rcall	hexbin			;zwei Zeichen in Binärcode
	tst	r16			;wandeln, erfolgreich?
	breq	pro150			;ja -> weiter
	rjmp	proerr			;sonst Hexfile-Fehler
pro150:	add	chksum,r17		;Checksumme aktualisieren
	cpi	r17,1			;EOF-Record?
	brne	pro220			;nein -> weiter testen
	rcall	hexbin			;zwei Zeichen in Binärcode
	tst	r16			;wandeln, erfolgreich?
	breq	pro160			;ja -> weiter
	rjmp	proerr			;sonst Hexfile-Fehler
pro160:	add	chksum,r17		;Checksumme aktualisieren
	tst	chksum			;Checksumme=0?
	breq	pro170			;ja -> weiter
	rjmp	proerr			;sonst Hexfile-Fehler
pro170:	cp	hexpo2,yl		;Pufferende ok?
	breq	pro180			;ja -> weiter
	rjmp	proerr			;sonst Hexfile-Fehler
pro180:	tst	tcount			;Datenbytes=0?
	breq	pro190			;ja -> weiter
	rjmp	proerr			;sonst Hexfile-Fehler
pro190:	lds	r16,prgver		;Status holen
	tst	r16			;Status Programmieren?
	brne	pro200			;nein -> Vergleichen
	ldi	zl,low(pr4std*2)
	ldi	zh,high(pr4std*2)	;Zeiger auf Program-Ende-Text
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	pro210			;ja -> weiter
	ldi	zl,low(pr4ste*2)	;sonst englisch benutzen
	ldi	zh,high(pr4ste*2)	;Zeiger auf Program-Ende-Text
	rjmp	pro210
pro200:	ldi	zl,low(pr5std*2)
	ldi	zh,high(pr5std*2)	;Zeiger auf Vergl.-Ende-Text
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	pro210			;ja -> weiter
	ldi	zl,low(pr5ste*2)	;sonst englisch benutzen
	ldi	zh,high(pr5ste*2)	;Zeiger auf Vergl.-Ende-Text
pro210:	rcall	sndtx1			;Text senden
	rjmp	restrt			;Ende
;
pro220:	cpi	r17,2			;Segment-Adress-Record?
	brne	pro290			;nein -> weiter testen
	rcall	hexbin			;zwei Zeichen in Binärcode
	tst	r16			;wandeln, erfolgreich?
	breq	pro230			;ja -> weiter
	rjmp	proerr			;sonst Hexfile-Fehler
pro230:	add	chksum,r17		;Checksumme aktualisieren
	mov	seghig,r17		;Segment H speichern
	rcall	hexbin			;zwei Zeichen in Binärcode
	tst	r16			;wandeln, erfolgreich?
	breq	pro240			;ja -> weiter
	rjmp	proerr			;sonst Hexfile-Fehler
pro240:	add	chksum,r17		;Checksumme aktualisieren
	mov	seglow,r17		;Segment L speichern
	rcall	hexbin			;zwei Zeichen in Binärcode
	tst	r16			;wandeln, erfolgreich?
	breq	pro250			;ja -> weiter
	rjmp	proerr			;sonst Hexfile-Fehler
pro250:	add	chksum,r17		;Checksumme aktualisieren
	tst	chksum			;Checksumme=0?
	breq	pro260			;ja -> weiter
	rjmp	proerr			;sonst Hexfile-Fehler
pro260:	cp	hexpo2,yl		;Pufferende ok?
	breq	pro270			;ja -> weiter
	rjmp	proerr			;sonst Hexfile-Fehler
pro270:	mov	r16,tcount		;Datenbyte-Zähler kopieren
	cpi	r16,2			;Datenbytes=2?
	breq	pro280			;ja -> weiter
	rjmp	proerr			;sonst Hexfile-Fehler
pro280:	rjmp	pro020			;warten auf nächste Zeile
;
pro290:	cpi	r17,4			;Linear-Adress-Record?
	brne	pro360			;nein -> weiter testen
	rcall	hexbin			;zwei Zeichen in Binärcode
	tst	r16			;wandeln, erfolgreich?
	breq	pro300			;ja -> weiter
	rjmp	proerr			;sonst Hexfile-Fehler
pro300:	add	chksum,r17		;Checksumme aktualisieren
	rcall	hexbin			;zwei Zeichen in Binärcode
	tst	r16			;wandeln, erfolgreich?
	breq	pro310			;ja -> weiter
	rjmp	proerr			;sonst Hexfile-Fehler
pro310:	add	chksum,r17		;Checksumme aktualisieren
	swap	r17			;unteres Nibble von Adresse L
	andi	r17,0xf0		;filtern und als
	mov	seghig,r17		;Segment H speichern
	clr	seglow			;Segment L =0 setzen
	rcall	hexbin			;zwei Zeichen in Binärcode
	tst	r16			;wandeln, erfolgreich?
	breq	pro320			;ja -> weiter
	rjmp	proerr			;sonst Hexfile-Fehler
pro320:	add	chksum,r17		;Checksumme aktualisieren
	tst	chksum			;Checksumme=0?
	breq	pro330			;ja -> weiter
	rjmp	proerr			;sonst Hexfile-Fehler
pro330:	cp	hexpo2,yl		;Pufferende ok?
	breq	pro340			;ja -> weiter
	rjmp	proerr			;sonst Hexfile-Fehler
pro340:	mov	r16,tcount		;Datenbyte-Zähler kopieren
	cpi	r16,2			;Datenbytes=2?
	breq	pro350			;ja -> weiter
	rjmp	proerr			;sonst Hexfile-Fehler
pro350:	rjmp	pro020			;warten auf nächste Zeile
;
pro360:	cpi	r17,0			;Data-Record?
	breq	pro370			;ja -> weiter
	rjmp	proerr			;sonst unbekannter Record-Typ
pro370:	ldi	zl,low(eprbuf)
	ldi	zh,high(eprbuf)		;Zeiger auf EPROM-Puffer
;
pro380:	tst	tcount			;alle Datenbytes bearbeitet?
	breq	pro400			;ja -> Schleifenende
	rcall	hexbin			;zwei Zeichen in Binärcode
	tst	r16			;wandeln, erfolgreich?
	breq	pro390			;ja -> weiter
	rjmp	proerr			;sonst Hexfile-Fehler
pro390:	add	chksum,r17		;Checksumme aktualisieren
	st	z+,r17			;Byte in EPROM-Puffer legen
	dec	tcount			;Datenbyte-Zähler aktualisieren
	rjmp	pro380			;Schleife
;
pro400:	rcall	hexbin			;zwei Zeichen in Binärcode
	tst	r16			;wandeln, erfolgreich?
	breq	pro410			;ja -> weiter
	rjmp	proerr			;sonst Hexfile-Fehler
pro410:	add	chksum,r17		;Checksumme aktualisieren
	tst	chksum			;Checksumme=0?
	breq	pro420			;ja -> weiter
	rjmp	proerr			;sonst Hexfile-Fehler
pro420:	cp	hexpo2,yl		;Pufferende ok?
	breq	pro430			;ja -> weiter
	rjmp	proerr			;sonst Hexfile-Fehler
;
pro430:	rcall	adrcal			;absolute Adresse berechnen
	ldi	yl,low(hexbuf)
	ldi	yh,high(hexbuf)		;Zeiger auf Hexpuffer
	clr	r17			;Adresse A24-A31 (=0)
	rcall	binhex			;wandeln und in Puffer legen
	mov	r17,r22			;Adresse A16-A23
	rcall	binhex			;wandeln und in Puffer legen
	mov	r17,r21			;Adresse A8-A15
	rcall	binhex			;wandeln und in Puffer legen
	mov	r17,r20			;Adresse A0-A7
	rcall	binhex			;wandeln und in Puffer legen
	clr	terrfl			;temporäres Fehlerflag löschen
	lds	r16,prgver		;Status holen
	tst	r16			;Status Programmieren?
	breq	pro500			;ja -> starten
	rjmp	pro700			;sonst Vergleichen starten
;
;	Teilprogramm Programmieren
;
pro500:	ldi	r16,1
	sts	prmode,r16		;Gerät in Progr.-Modus setzen
	mov	tcount,dbcoun		;Datenbyte-Zähler kopieren
	ldi	yl,low(eprbuf)
	ldi	yh,high(eprbuf)		;Zeiger auf EPROM-Puffer
	rcall	dat_ip			;Datenleitungen auf Eing-Pullup
	lds	zl,eprdat+eproga	;Routine für "Progr. aktiv." L
	lds	zh,eprdat+eproga+1	;Routine für "Progr. aktiv." H
	icall				;aufrufen
;
pro510:	tst	tcount			;alle Bytes bearbeitet?
	breq	pro650			;ja -> Programmieren-Ende
	rcall	ledxon			;LED für ca. 71 ms einschalten
	rcall	adrset			;EPROM-Adresse setzen
	ld	r18,y+			;Byte aus EPROM-Puffer holen
	lds	r19,eprdat+eprim1	;Anzahl der Programmierimpulse
pro520:	tst	r19			;alle Prog-Impulse ausgegeben?
	breq	pro540			;ja -> Fehler
	rcall	dat_o1			;Datenleitungen auf Ausgang H
	lds	zl,eprdat+eprogc	;Routine für "Programmieren" L
	lds	zh,eprdat+eprogc+1	;Routine für "Programmieren" H
	icall				;aufrufen
	rcall	dat_ip			;Datenleitungen auf Eing-Pullup
	lds	zl,eprdat+eprogd	;Routine für "Vergleichen" L
	lds	zh,eprdat+eprogd+1	;Routine für "Vergleichen" H
	icall				;aufrufen
	dec	r19			;Impulszähler -1
	cp	r17,r18			;Programmierung erfolgreich?
	brne	pro520			;nein -> neuer Progr.-Impuls
;
	lds	r19,eprdat+eprim2	;Anzahl der Sicherheitsimpulse
pro530:	tst	r19			;alle Prog-Impulse ausgegeben?
	breq	pro600			;ja -> ok (nächstes Byte)
	rcall	dat_o1			;Datenleitungen auf Ausgang H
	lds	zl,eprdat+eprogc	;Routine für "Programmieren" L
	lds	zh,eprdat+eprogc+1	;Routine für "Programmieren" H
	icall				;aufrufen
	rcall	dat_ip			;Datenleitungen auf Eing-Pullup
	dec	r19			;Impulszähler -1
	rjmp	pro530			;neuer Sicherheits-Impuls
;
pro540:	inc	terrfl			;Fehlerflag erhöhen
pro600:	rcall	adrinc			;Adresse erhöhen
	dec	tcount			;Bytezähler -1
	rjmp	pro510			;Schleife
;
pro650:	rcall	adrclr			;Adresse löschen und ausgeben
	lds	zl,eprdat+eprogb	;Routine für "Progr. deakt." L
	lds	zh,eprdat+eprogb+1	;Routine für "Progr. deakt." H
	icall				;aufrufen
	rcall	dat_in			;Datenleitungen auf Eingang
	rjmp	pro900
;
;	Teilprogramm Vergleichen
;
pro700:	ldi	r16,2
	sts	prmode,r16		;Gerät in Lese-Modus setzen
	mov	tcount,dbcoun		;Datenbyte-Zähler kopieren
	ldi	yl,low(eprbuf)
	ldi	yh,high(eprbuf)		;Zeiger auf EPROM-Puffer
	rcall	ledxon			;LED für ca. 71 ms einschalten
	rcall	dat_ip			;Datenleitungen auf Eing-Pullup
	rcall	reada1			;Lesen aktivieren
;
pro710:	tst	tcount			;alle Bytes bearbeitet?
	breq	pro800			;ja -> Vergleichen-Ende
	rcall	adrset			;EPROM-Adresse setzen
	ld	r18,y+			;Byte aus EPROM-Puffer holen
	rcall	dat_in			;Datenleitungen auf Eingang
	rcall	readc1			;EPROM Lesen
	dec	r19			;Impulszähler -1
	cp	r17,r18			;Vergleichen erfolgreich?
	breq	pro720			;ja -> weiter
	inc	terrfl			;sonst Fehlerflag erhöhen
pro720:	rcall	adrinc			;Adresse erhöhen
	dec	tcount			;Bytezähler -1
	rjmp	pro710			;Schleife
;
pro800:	rcall	adrclr			;Adresse löschen und ausgeben
	rcall	dat_in			;Datenleitungen auf Eingang
	rcall	readb1			;Lesen deaktivieren
;
pro900:	ldi	zl,low(hexbuf)
	ldi	zh,high(hexbuf)		;Zeiger auf Hexpuffer
	ldi	r18,8			;8 Zeichen (Adresse)
pro910:	ld	r17,z+			;Zeichen holen
	rcall	putchr			;Zeichen ausgeben
	dec	r18			;alle Zeichen ausgegeben?
	brne	pro910			;nein -> Schleife
	tst	terrfl			;Programmierfehler aufgetreten?
	brne	pro920			;ja -> Fehlermeldung ausgeben
	ldi	zl,low(pr2std*2)	;
	ldi	zh,high(pr2std*2)	;Zeiger auf ok-Text
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	pro930			;ja -> weiter
	ldi	zl,low(pr2ste*2)	;sonst englisch benutzen
	ldi	zh,high(pr2ste*2)	;Zeiger auf ok-Text
	rjmp	pro930
pro920:	ldi	zl,low(pr3std*2)
	ldi	zh,high(pr3std*2)	;Zeiger auf Fehler-Text
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	pro930			;ja -> weiter
	ldi	zl,low(pr3ste*2)	;sonst englisch benutzen
	ldi	zh,high(pr3ste*2)	;Zeiger auf Fehler-Text
pro930:	rcall	sndtx1			;Text senden
	rjmp	pro020			;warten auf nächste Zeile
;
proerr:	ldi	r16,4			;Fehler 4 (Hexfile-Fehler)
	sts	erflag,r16		;Fehlercode speichern
	rjmp	error			;Fehler behandeln
;
;	EPROM lesen
;
read:	ldi	zl,low(reastd*2)
	ldi	zh,high(reastd*2)	;Zeiger auf Read-Text
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	rea005			;ja -> weiter
	ldi	zl,low(reaste*2)	;sonst englisch benutzen
	ldi	zh,high(reaste*2)	;Zeiger auf Read-Text
rea005:	rcall	sndtx1			;Text senden
rea010:	lds	r16,erflag		;Fehlerflag holen
	tst	r16			;Fehler aufgetreten?
	breq	rea020			;nein -> weiter
	rjmp	error			;sonst zur Fehlerbehandlung
rea020:	rcall	getchr			;Zeichen aus Puffer holen
	tst	r16			;neues Zeichen?
	brne	rea010			;nein -> Schleife
	cpi	r17,esc			;ESC empfangen?
	brne	rea030			;nein -> weiter testen
	rjmp	menu1			;sonst zurück ins Menü1
rea030:	cpi	r17,cr			;ENTER empfangen?
	brne	rea010			;nein -> Schleife
	rcall	ledxon			;LED für ca. 71 ms einschalten
	ldi	r16,2
	sts	prmode,r16		;Gerät in Lese-Modus setzen
	clr	r20			;A0-A7=0
	clr	r21			;A8-A15=0
	clr	r22			;A16-A23=0
	rcall	dat_ip			;Datenleitungen auf Eing-Pullup
	rcall	reada1			;Lesen aktivieren
;
rea040:	mov	r16,r20			;Adressen A0-A7 holen und mit
	or	r16,r21			;Adressen A8-A15 verknüpfen
	brne	rea060			;A0-A15=0? nein -> weiter
;
	ldi	yl,low(hexbuf)
	ldi	yh,high(hexbuf)		;Zeiger auf Hexpuffer
	ldi	r17,':'			;Startzeichen
	st	y+,r17			;in Puffer legen
	clr	chksum			;Checksumme initialisieren
	ldi	r17,2			;Länge= 2 Bytes
	sub	chksum,r17		;Checksumme aktualisieren
	rcall	binhex			;wandeln und in Puffer legen
	clr	r17			;Adresse H
	rcall	binhex			;wandeln und in Puffer legen
	clr	r17			;Adresse L
	rcall	binhex			;wandeln und in Puffer legen
	ldi	r17,2			;Kennung für Segment-Record
	sub	chksum,r17		;Checksumme aktualisieren
	rcall	binhex			;wandeln und in Puffer legen
	mov	r17,r22			;A16-A23 holen
	andi	r17,0x0f		;A16-A19 filtern
	swap	r17			;in oberes Nibble (Segment H)
	sub	chksum,r17		;Checksumme aktualisieren
	rcall	binhex			;wandeln und in Puffer legen
	clr	r17			;Segment L
	rcall	binhex			;wandeln und in Puffer legen
	mov	r17,chksum		;Checksumme holen
	rcall	binhex			;wandeln und in Puffer legen
	ldi	zl,low(hexbuf)
	ldi	zh,high(hexbuf)		;Zeiger auf Hexpuffer
	mov	r18,yl			;Anzahl der Zeichen
rea050:	ld	r17,z+			;Zeichen holen
	rcall	putchr			;Zeichen ausgeben
	dec	r18			;alle Zeichen ausgegeben?
	brne	rea050			;nein -> Schleife
	rcall	sncrlf			;CR/LF ausgeben
;
rea060:	rcall	ledxon			;LED für ca. 71 ms einschalten
	ldi	r16,32			;32 Datenbytes lesen
	clr	r18			;Flag für leere Speicherzellen
	mov	dbcoun,r16		;Zähler setzen
	ldi	yl,low(hexbuf)
	ldi	yh,high(hexbuf)		;Zeiger auf Hexpuffer
	ldi	r17,':'			;Startzeichen
	st	y+,r17			;in Puffer legen
	clr	chksum			;Checksumme initialisieren
	mov	r17,dbcoun		;Länge holen
	sub	chksum,r17		;Checksumme aktualisieren
	rcall	binhex			;wandeln und in Puffer legen
	mov	r17,r21			;Adresse H holen
	sub	chksum,r17		;Checksumme aktualisieren
	rcall	binhex			;wandeln und in Puffer legen
	mov	r17,r20			;Adresse L holen
	sub	chksum,r17		;Checksumme aktualisieren
	rcall	binhex			;wandeln und in Puffer legen
	clr	r17			;Kennung für Data-Record
	rcall	binhex			;wandeln und in Puffer legen
;
rea100:	rcall	adrset			;EPROM-Adresse setzen
	rcall	readc1			;EPROM lesen
	cpi	r17,0xff		;Speicherzelle leer?
	breq	rea110			;ja -> weiter
	inc	r18			;sonst Flag setzen
rea110:	sub	chksum,r17		;Checksumme aktualisieren
	rcall	binhex			;wandeln und in Puffer legen
	rcall	adrinc			;Adresse erhöhen
	dec	dbcoun			;alle Bytes ausgegeben?
	brne	rea100			;nein -> Schleife
	mov	r17,chksum		;Checksumme holen
	rcall	binhex			;wandeln und in Puffer legen
	lds	r16,readmo		;aktuellen Lese-Modus holen
	tst	r16			;alle Bytes lesen?
	breq	rea120			;ja -> Bytes ausgeben
	tst	r18			;alle Speicherzellen leer?
	breq	rea140			;ja -> Ausgabe überspringen
;
rea120:	ldi	zl,low(hexbuf)
	ldi	zh,high(hexbuf)		;Zeiger auf Hexpuffer
	mov	r18,yl			;Anzahl der Zeichen
rea130:	ld	r17,z+			;Zeichen holen
	rcall	putchr			;Zeichen ausgeben
	dec	r18			;alle Zeichen ausgegeben?
	brne	rea130			;nein -> Schleife
	rcall	sncrlf			;CR/LF ausgeben
	rcall	w500us			;500 µs warten
;
rea140:	rcall	adrchk			;EPROM-Ende erreicht/überschr.?
	breq	rea170			;ja -> Lesen beenden
	brcs	rea170			;ja -> Lesen beenden
;
	lds	r16,erflag		;Fehlerflag holen
	tst	r16			;Fehler aufgetreten?
	breq	rea150			;nein -> weiter
	rjmp	error			;sonst zur Fehlerbehandlung
rea150:	rcall	getchr			;Zeichen aus Puffer holen
	tst	r16			;neues Zeichen?
	brne	rea160			;nein -> weiter
	cpi	r17,esc			;ESC empfangen?
	breq	rea300			;ja -> Lesen beenden
rea160:	rjmp	rea040			;Schleife
;
rea170:	rcall	adrclr			;Adresse löschen und ausgeben
	rcall	readb1			;Lesen deaktivieren
	rcall	dat_in			;Datenleitungen auf Eingang
	ldi	zl,low(eofstr*2)
	ldi	zh,high(eofstr*2)	;Zeiger auf Hexfile-Ende-Text
	rcall	sndtx1
;
rea200:	lds	r16,erflag		;Fehlerflag holen
	tst	r16			;Fehler aufgetreten?
	breq	rea210			;nein -> weiter
	rjmp	error			;sonst zur Fehlerbehandlung
rea210:	rcall	getchr			;Zeichen aus Puffer holen
	tst	r16			;neues Zeichen?
	brne	rea200			;nein -> Schleife
	cpi	r17,cr			;ENTER empfangen?
	brne	rea200			;nein -> Schleife
	rcall	sncrlf			;CR/LF ausgeben
	rjmp	menu1	
;
rea300:	rcall	adrclr			;Adresse löschen und ausgeben
	rcall	readb1			;Lesen deaktivieren
	rcall	dat_in			;Datenleitungen auf Eingang
	rcall	sncrlf
	rjmp	menu1
;
;	EPROM Leertest
;
cltest:	ldi	zl,low(clt1sd*2)
	ldi	zh,high(clt1sd*2)	;Zeiger auf Leertest-Text
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	clt005			;ja -> weiter
	ldi	zl,low(clt1se*2)	;sonst englisch benutzen
	ldi	zh,high(clt1se*2)	;Zeiger auf Leertest-Text
clt005:	rcall	sndtx1			;Text senden
	ldi	r16,2
	sts	prmode,r16		;Gerät in Lese-Modus setzen
	clr	r20			;A0-A7=0
	clr	r21			;A8-A15=0
	clr	r22			;A16-A23=0
	rcall	dat_ip			;Datenleitungen auf Eing-Pullup
	rcall	reada1			;Lesen aktivieren
	clr	terrfl			;temporäres Fehlerflag löschen
;
clt010:	rcall	ledxon			;LED für ca. 71 ms einschalten
	rcall	adrset			;EPROM-Adresse setzen
	rcall	readc1			;EPROM lesen
	cpi	r17,0xff		;Speicherzelle leer (0xff)?
	breq	clt020			;ja -> weiter
	inc	terrfl			;temporäres Fehlerflag setzen
	rjmp	clt100			;Leertest beenden
clt020:	rcall	adrinc			;Adresse erhöhen
	rcall	adrchk			;EPROM-Ende erreicht/überschr.?
	breq	clt100			;ja -> Lesen beenden
	brcs	clt100			;ja -> Lesen beenden
	rjmp	clt010			;Schleife
;
clt100:	rcall	adrclr			;Adresse löschen und ausgeben
	rcall	readb1			;Lesen deaktivieren
	rcall	dat_in			;Datenleitungen auf Eingang
	tst	terrfl			;Fehler aufgetreten?
	brne	clt110			;ja -> Fehlertext ausgeben
	ldi	zl,low(clt2sd*2)
	ldi	zh,high(clt2sd*2)	;sonst Zeiger auf Leer-Text
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	clt120			;ja -> weiter
	ldi	zl,low(clt2se*2)	;sonst englisch benutzen
	ldi	zh,high(clt2se*2)	;sonst Zeiger auf Leer-Text
	rjmp	clt120
clt110:	ldi	zl,low(clt3sd*2)
	ldi	zh,high(clt3sd*2)	;Zeiger auf Nicht-Leer-Text
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	clt120			;ja -> weiter
	ldi	zl,low(clt3se*2)	;sonst englisch benutzen
	ldi	zh,high(clt3se*2)	;Zeiger auf Nicht-Leer-Text
clt120:	rcall	sndtx1
	rjmp	restrt
;
;	EPROM Löschen
;
erase:	lds	zl,eprdat+eerase	;Routine für "Löschen" L
	lds	zh,eprdat+eerase+1	;Routine für "Löschen" H
	mov	r16,zl
	or	r16,zh			;Routinen-Adresse=0?
	brne	era010			;nein -> weiter
	ldi	zl,low(era1sd*2)
	ldi	zh,high(era1sd*2)	;Zeiger auf Nicht-möglich-Text
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	era005			;ja -> weiter
	ldi	zl,low(era1se*2)	;sonst englisch benutzen
	ldi	zh,high(era1se*2)	;Zeiger auf Nicht-möglich-Text
era005:	rcall	sndtx1
	rjmp	restrt
;
era010:	ldi	r16,1
	sts	prmode,r16		;Gerät in Progr.-Modus setzen
	ldi	zl,low(era2sd*2)
	ldi	zh,high(era2sd*2)	;Zeiger auf Löschen-Text
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	era015			;ja -> weiter
	ldi	zl,low(era2se*2)	;sonst englisch benutzen
	ldi	zh,high(era2se*2)	;Zeiger auf Löschen-Text
era015:	rcall	sndtx1
	led_on
	rcall	dat_ip			;Datenleitungen auf Eing-Pullup
	lds	zl,eprdat+eproga	;Routine für "Progr. aktiv." L
	lds	zh,eprdat+eproga+1	;Routine für "Progr. aktiv." H
	icall				;aufrufen
	lds	zl,eprdat+eerase	;Routine für "Löschen" L
	lds	zh,eprdat+eerase+1	;Routine für "Löschen" H
	icall				;Löschroutine aufrufen
	rcall	adrclr			;Adresse löschen und ausgeben
	lds	zl,eprdat+eprogb	;Routine für "Progr. deakt." L
	lds	zh,eprdat+eprogb+1	;Routine für "Progr. deakt." H
	icall				;aufrufen
	rcall	dat_in			;Datenleitungen auf Eingang
	led_off
	tst	r18			;Löschen ok?
	brne	era020			;nein -> Fehler
	ldi	zl,low(era3sd*2)
	ldi	zh,high(era3sd*2)	;Zeiger auf Löschen-Ok-Text
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	era030			;ja -> weiter
	ldi	zl,low(era3se*2)	;sonst englisch benutzen
	ldi	zh,high(era3se*2)	;Zeiger auf Löschen-Ok-Text
	rjmp	era030
era020:	ldi	zl,low(era4sd*2)
	ldi	zh,high(era4sd*2)	;Zeiger auf Löschfehler-Text
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	era030			;ja -> weiter
	ldi	zl,low(era4se*2)	;sonst englisch benutzen
	ldi	zh,high(era4se*2)	;Zeiger auf Löschfehler-Text
era030:	rcall	sndtx1
	rjmp	restrt
;
;	Lese-Modus ändern
;
chread:	lds	r18,readmo		;aktuellen Lese-Modus holen
	inc	r18			;Lese-Modus wechseln
	andi	r18,0x01		;Übertrag abschneiden
	sts	readmo,r18		;Lese-Modus wieder speichern
	ldi	r16,low(ereadm)		;Zeiger auf EEPROM
	ldi	r17,high(ereadm)	;(Lese-Modus)
	rcall	eewrit			;EEPROM schreiben
	rjmp	menu1			;zurück ins Menü 1
;
;	Sprache ändern
;
chlang:	lds	r18,langua		;aktuelle Sprache holen
	inc	r18			;Sprache ändern
	andi	r18,0x01		;Übertrag abschneiden
	sts	langua,r18		;Sprache wieder speichern
	ldi	r16,low(elangu)		;Zeiger auf EEPROM
	ldi	r17,high(elangu)	;(Sprachauswahl)
	rcall	eewrit			;EEPROM schreiben
	rjmp	menu1
;
;	Fehler-Behandlung, folgende Fehler werden bearbeitet:
;	1:Empfangsregister-Überlauf
;	2:Rahmenfehler
;	3:Empfangspuffer-Überlauf
;	4:Fehler im Hex-File
;
error:	lds	r16,erflag		;Fehlerflag holen
	dec	r16			;Fehlercode 1?
	brne	err020			;nein -> weiter testen
	ldi	zl,low(er1std*2)
	ldi	zh,high(er1std*2)	;Zeiger auf Fehler1-Text
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	err100			;ja -> weiter
	ldi	zl,low(er1ste*2)	;sonst englisch benutzen	
	ldi	zh,high(er1ste*2)	;Zeiger auf Fehler1-Text
	rjmp	err100			;Fehlertext ausgeben
err020:	dec	r16			;Fehlercode 2?
	brne	err030			;nein -> weiter testen
	ldi	zl,low(er2std*2)
	ldi	zh,high(er2std*2)	;Zeiger auf Fehler2-Text
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	err100			;ja -> weiter
	ldi	zl,low(er2ste*2)	;sonst englisch benutzen
	ldi	zh,high(er2ste*2)	;Zeiger auf Fehler2-Text
	rjmp	err100			;Fehlertext ausgeben
err030:	dec	r16			;Fehlercode 3?
	brne	err040			;nein -> weiter testen
	ldi	zl,low(er3std*2)
	ldi	zh,high(er3std*2)	;Zeiger auf Fehler3-Text
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	err100			;ja -> weiter
	ldi	zl,low(er3ste*2)	;sonst englisch benutzen
	ldi	zh,high(er3ste*2)	;Zeiger auf Fehler3-Text
	rjmp	err100			;Fehlertext ausgeben
err040:	dec	r16			;Fehlercode 4?
	brne	err050			;nein -> unbekannter Fehler
	ldi	zl,low(er4std*2)
	ldi	zh,high(er4std*2)	;Zeiger auf Fehler4-Text
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	err100			;ja -> weiter
	ldi	zl,low(er4ste*2)	;sonst englisch benutzen
	ldi	zh,high(er4ste*2)	;Zeiger auf Fehler4-Text
	rjmp	err100			;Fehlertext ausgeben
err050:	ldi	zl,low(er5std*2)
	ldi	zh,high(er5std*2)	;Zeiger auf Fehler5-Text
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	err100			;ja -> weiter
	ldi	zl,low(er5ste*2)	;sonst englisch benutzen
	ldi	zh,high(er5ste*2)	;Zeiger auf Fehler5-Text
err100:	rcall	sndtx1			;Text ausgeben
	ldi	zl,low(er9std*2)
	ldi	zh,high(er9std*2)	;Zeiger auf 2. Fehler-Text
	lds	r16,langua		;Sprachauswahl holen
	tst	r16			;deutsch?
	breq	err110			;ja -> weiter
	ldi	zl,low(er9ste*2)	;sonst englisch benutzen
	ldi	zh,high(er9ste*2)	;Zeiger auf 2. Fehler-Text
err110:	rcall	sndtx1			;Text ausgeben
err120:	rcall	getchr			;Zeichen aus Puffer holen
	tst	r16			;neues Zeichen?
	brne	err120			;nein -> Schleife
	cpi	r17,esc			;ESC empfangen?
	brne	err120			;nein -> Schleife
	rcall	sncrlf			;sonst CR/LF senden
	rcall	sncrlf			;CR/LF senden
	clr	r16
	sts	erflag,r16		;Fehlercode löschen
	rjmp	menu1			;zurück zum Menü1
;
;	EPROM-Datenleitungen auf Eingang setzen (hochohmig)
;
dat_in:	clr	r16
	out	porta,r16		;PortA Pullups ausschalten
	out	ddra,r16		;PortA0-A7 auf Eingang schalten
	ret
;
;	EPROM-Datenleitungen auf Eingang setzen (mit Pullup)
;
dat_ip:	ser	r16
	out	porta,r16		;PortA Pullups einschalten
	clr	r16
	out	ddra,r16		;PortA0-A7 auf Eingang schalten
	ret
;
;	EPROM-Datenleitungen auf Ausgang setzen (high)
;
dat_o1:	ser	r16
	out	ddra,r16		;PortA0-A7 auf Ausgang schalten
	out	porta,r16		;PortA0-A7 auf High setzen
	ret
;
;	Alle Adressleitungen auf 0 setzen und ausgeben
;	Register: r16,r17,r20,r21,r22
;		  r20-r22 Adresse (24 Bit)
;
adrclr:	clr	r20
	clr	r21
	clr	r22
;
;	Unterprogramm zur Ausgabe der aktuellen Adresse an die Ports
;	Register: r16,r17,r20,r21,r22
;		  r20-r22 Adresse (24 Bit)
;
adrset:	out	portc,r21		;Adresse A8-A15 ausgeben
	cbi	portb,7			;PortB7 löschen
	sbi	portb,7			;PortB7 setzen (Latchübernahme)
	cbi	portb,7			;PortB7 wieder auf löschen
	out	portc,r20		;Adresse A0-A7 ausgeben
	mov	r16,r22			;Adresse A16-A23 kopieren
	cli				;Interrupts sperren
	andi	r16,0x0f		;Adresse A16-A19 filtern
	swap	r16			;in oberes Nibble schieben
	in	r17,portd		;PortD einlesen
	andi	r17,0x0f		;D4-D7 löschen (A16-A19)
	or	r17,r16			;mit neuen Daten verknüpfen
	out	portd,r17		;und wieder ausgeben
	sei				;Interrupts wieder freigeben
	ret
;
;	Unterprogramm zur Erhöhung der EPROM-Adresse um 1
;	Register: r16,r20,r21,r22
;		  r20-r22 Adresse (24 Bit)
;
adrinc:	ldi	r16,1			;wird zur Addition benötigt
	add	r20,r16			;A0-A7 um 1 erhöhen
	clr	r16			;wird zur Addition benötigt
	adc	r21,r16			;Übertrag addieren
	adc	r22,r16			;Übertrag addieren
	ret
;
;	Unterprogramm zum Prüfen der EPROM-Endes 
;	Register: r16-r23
;		  r20-r22 Adresse (24 Bit)
;		  C - 0=ok, 1=Ende überschritten
;		  Z - 1=Ende erreicht
;
adrchk:	lds	r16,eprdat+eprsiz
	lds	r17,eprdat+eprsiz+1
	lds	r18,eprdat+eprsiz+2
	lds	r19,eprdat+eprsiz+3	;EPROM-Größe laden
	clr	r23			;wird zur Addition benötigt
	sub	r16,r20
	sbc	r17,r21
	sbc	r18,r22
	sbc	r19,r23			;EPROM-Ende erreicht?
	ret
;
;	Unterprogramm zum Berechnen der absoluten Speicheradresse aus
;	Segment und 16-Bit-Adresse (Segment*16+Adresse)
;	Register: r20-r23
;
adrcal:	mov	r20,seglow
	mov	r21,seghig		;Segment-Adresse holen
	clr	r22			;Adresse A16-A23=0
	ldi	r23,4			;4 Linksverschiebungen (*16)
adr100:	clc				;Carry löschen
	rol	r20
	rol	r21			;Segment-Adresse nach
	rol	r22			;links verschieben
	dec	r23			;alle Verschiebungen komplett?
	brne	adr100			;nein -> Schleife
	add	r20,adrlow
	adc	r21,adrhig		;16-Bit-Adresse addieren
	adc	r22,r23			;Übertrag addieren
	ret
;
;	Unterprogramm zur Wandlung eines Bytes BIN->HEX
;	Register: r0,r16,r17,y
;		  r17 zu wandelndes Byte
;		  y Zeiger auf Hexpuffer
;
binhex:	ldi	r16,7			;Konstante setzen
	mov	r0,r17			;Byte sichern
	swap	r17			;Nibbles tauschen
	andi	r17,0x0f		;unteres Nibble filtern
	ori	r17,0x30		;in ASCII wandeln
	cpi	r17,0x3a		;Ziffernwert<10?
	brcs	bin010			;ja -> weiter
	add	r17,r16			;sonst ASCII-Wert korrigieren
bin010:	st	y+,r17			;in Puffer legen
	mov	r17,r0			;gesichertes Byte holen
	andi	r17,0x0f		;unteres Nibble filtern
	ori	r17,0x30		;in ASCII wandeln
	cpi	r17,0x3a		;Zifferwert<10?
	brcs	bin020			;ja -> weiter
	add	r17,r16			;sonst ASCII-Wert korrigieren
bin020:	st	y+,r17			;in Puffer legen
	ret
;
;	Unterprogramm zur Wandlung eines Bytes HEX->BIN
;	Register: r0,r16,r17,y
;		  y Zeiger auf Hexpuffer
;		  r16 Fehlercode (0=ok, ff=Fehler)
;		  r17 gewandeltes Byte
;
hexbin:	clr	r16			;Fehlerstatus löschen
	rcall	hex100			;ein Zeichen holen und wandeln
	swap	r17			;in oberes Nibble schieben
	mov	r0,r17			;Zwischenergebnis sichern
	rcall	hex100			;ein Zeichen holen und wandeln
	or	r17,r0			;mit vorherigem Wert verknüpfen
	ret
;
hex100:	ld	r17,y+			;Zeichen aus Hexpuffer holen
	cpi	r17,'0'			;Zeichencode<'0'?
	brcs	hex200			;ja -> Fehler
	cpi	r17,'9'+1		;Zeichencode>'9'?
	brcc	hex110			;ja -> Großbuchstaben testen
	subi	r17,48			;in Binärcode wandeln
	ret
hex110:	cpi	r17,'A'			;Zeichencode<'A'?
	brcs	hex200			;ja -> Fehler
	cpi	r17,'F'+1		;Zeichencode>'F'?
	brcc	hex120			;ja -> Kleinbuchstaben testen
	subi	r17,55			;in Binärcode wandeln
	ret
hex120:	cpi	r17,'a'			;Zeichencode<'a'?
	brcs	hex200			;ja -> Fehler
	cpi	r17,'f'+1		;Zeichencode>'f'?
	brcc	hex200			;ja -> Fehler
	subi	r17,87			;in Binärcode wandeln
	ret
hex200:	ser	r16			;Fehlerstatus setzen
	ret
;
;	Unterprogramm zum Ermitteln des EPROM-Tabellenplatzes und
;	Kopieren der EPROM-Daten aus dem Prgogrammspeicher in den SRAM
;	Register r0,r16,r20,r21,r22,r23,y,z
;		 r23 Zehner (0-9)
;		 r22 Einer (0-9)
;
eprget:	ldi	zl,low(eprtab*2)
	ldi	zh,high(eprtab*2)	;Zeiger auf EPROM-Tabelle
epr010:	tst	r23			;Zehnerwert=0?
	breq	epr020			;ja -> Einer bearbeiten
	ldi	r20,low(recsiz*10)	;sonst Offset auf 10 Tabellen-
	ldi	r21,high(recsiz*10)	;plätze setzen
	add	zl,r20			;Offset addieren
	adc	zh,r21			;Übertrag
	dec	r23			;Zehnerwert vermindern
	rjmp	epr010			;Schleife
epr020:	tst	r22			;Einerwert=0?
	breq	epr030			;ja -> Ergebnis speichern
	ldi	r20,low(recsiz)		;sonst Offset auf 1 Tabellen-
	ldi	r21,high(recsiz)	;platz setzen
	add	zl,r20			;Offset addieren
	adc	zh,r21			;Übertrag
	dec	r22			;Einerwert vermindern
	rjmp	epr020			;Schleife
;
epr030:	ldi	r16,recsiz		;Anzahl der zu kopierenden
	ldi	yl,low(eprdat)		;Bytes setzen
	ldi	yh,high(eprdat)		;Zeiger auf EPROM-Daten-Puffer
epr040:	lpm				;Zeichen aus Programmsp. holen
	st	y+,r0			;in SRAM schreiben, Zeiger+1
	ld	r0,z+			;Programmspeicher-Zeiger+1
	dec	r16			;alle Zeichen kopiert?
	brne	epr040			;nein -> Schleife
	ret
;
;	Unterprogramm zum Lesen eines Byte aus dem EEPROM
;	Register: r16 EEPROM-Adresse Low
;		  r17 EEPROM-Adresse High
;		  r18 EEPROM-Daten
;		  r0  interner Zwischenspeicher
;
eeread:	sbic	eecr,eewe		;läuft Schreibzyklus?
	rjmp	eeread			;ja - warten
	out 	eearh,r17		;EEPROM-Adresse High setzen
	out	eearl,r16		;EEPROM-Adresse Low setzen
	sbi	eecr,eere		;EEPROM lesen aktivieren
	in	r18,eedr		;Daten lesen
	rjmp	eew020			;EEPROM-Adresse auf 0 setzen
;
;	Unterprogramm zum Schreiben eines Byte in den EEPROM
;	Register: r16 EEPROM-Adresse Low
;		  r17 EEPROM-Adresse High
;		  r18 EEPROM-Daten
;		  r0  interner Zwischenspeicher
;
eewrit:	sbic	eecr,eewe		;läuft Schreibzyklus?
	rjmp	eewrit			;ja -> warten
	out	eearh,r17		;EEPROM-Adresse H setzen
	out	eearl,r16		;EEPROM-Adresse L setzen
	out	eedr,r18		;EEPROM-Datenbyte setzen
	sbi	eecr,eemwe		;Masterwrite-Bit setzen
	sbi	eecr,eewe		;Write-Bit setzen
;
eew010:	sbic	eecr,eewe		;Schreibvorgang noch aktiv?
	rjmp	eew010			;ja -> Schleife
eew020:	clr	r0
	out	eearh,r0		;EEPROM-Adresse H=0 setzen
	out	eearl,r0		;EEPROM-Adresse L=0 setzen
	ret
;
;	Unterprogramm Warteschleife ca. 2 µs
;	Register: keine
;
wai2us:	nop
	ret
;
;	Unterprogramm Warteschleife ca. 6 µs
;	Register: r24,r15
;
wai6us:	ldi	r24,3			;Zeitkonstanten für ca. 6 µs
	mov	r15,r24			;Wert für innere Schleife
	ldi	r24,1			;Wert für äußere Schleife
	rjmp	wait00
;
;	Unterprogramm Warteschleife ca. 10 µs
;	Register: r24,r15
;
wa10us:	ldi	r24,8			;Zeitkonstanten für ca. 10 µs
	mov	r15,r24			;Wert für innere Schleife
	ldi	r24,1			;Wert für äußere Schleife
	rjmp	wait00
;
;	Unterprogramm Warteschleife ca. 050 µs
;	Register: r24,r15
;
wa50us:	ldi	r24,57			;Zeitkonstanten für ca. 50 µs
	mov	r15,r24			;Wert für innere Schleife
	ldi	r24,1			;Wert für äußere Schleife
	rjmp	wait00
;
;	Unterprogramm Warteschleife ca. 100 µs
;	Register: r24,r15
;
w100us:	ldi	r24,118			;Zeitkonstanten für ca. 100 µs
	mov	r15,r24			;Wert für innere Schleife
	ldi	r24,1			;Wert für äußere Schleife
	rjmp	wait00
;
;	Unterprogramm Warteschleife ca. 500 µs
;	Register: r24,r15
;
w500us:	ldi	r24,97			;Zeitkonstanten für ca. 500 µs
	mov	r15,r24			;Wert für innere Schleife
	ldi	r24,3			;Wert für äußere Schleife
	rjmp	wait00
;
;	Unterprogramm Warteschleife ca. 1 ms
;	Register: r24,r15
;
wai1ms:	ldi	r24,197			;Zeitkonstanten für ca. 1 ms
	mov	r15,r24			;Wert für innere Schleife
	ldi	r24,5			;Wert für äußere Schleife
	rjmp	wait00
;
;	Unterprogramm Warteschleife ca. 10 ms
;	Register: r24,r15
;
wa10ms:	ldi	r24,48			;Zeitkonstante für ca. 10 ms
	clr	r15			;Wert für innere Schleife
	rjmp	wait00
;
;	Unterprogramm Warteschleife ca. 50 ms
;	Register: r24,r15
;
wa50ms:	ldi	r24,239			;Zeitkonstante für ca. 50 ms
	clr	r15			;Wert für innere Schleife
wait00:	dec	r15
	brne	wait00			;innere Schleife
	dec	r24
	brne	wait00			;äußere Schleife
	ret
;
;	Unterprogramm zum Auslesen eines Zeichens aus dem Empfangs-
;	puffer, bei weniger als 32 Zeichen im Puffer wird CTS wieder
;	aktiviert
;	Register: r18,r19,y
;		  r17 gelesenes Zeichen
;		  r16 0= Zeichen gültig, ff= kein Zeichen im Puffer
;
getchr:	cp	rxpoi1,rxpoi2		;sind Zeichen im Puffer?
	brne	get010			;ja -> weiter
	ser	r16			;kein Zeichen im Puffer
	ret
get010:	cli				;Int vorübergehend sperren
	mov	yl,rxpoi2		;Empfangspuffer-Pointer2 laden
	clr	yh			;High-Byte löschen
	ld	r17,y+			;Byte laden, Pointer+1
	andi	yl,0x3f
	ori	yl,rxbuff		;Übertrag korrigieren
	mov	rxpoi2,yl		;Pointer2 wieder speichern
	sei				;Int wieder freigeben
	mov	r19,rxpoi1		;Pointer1 holen
	mov	r18,rxpoi2		;Pointer2 holen
	cp	rxpoi1,rxpoi2		;Pointer1>Pointer2?
	brcc	get020			;ja -> weiter
	subi	r18,0x40		;sonst Übertrag korrigieren
get020:	sub	r19,r18			;Anzahl der Zeichen im Puffer
	cpi	r19,0x20		;Anzahl<32?
	brcc	get030			;nein -> weiter
	cts_on				;sonst RS232-CTS aktivieren
get030:	clr	r16			;Zeichen ist gültig
	ret
;
;	Unterprogramm zum Senden eines Zeichens über RS232 ohne
;	Interrupt
;	Register: r16,r17
;		  r17 zu sendendes Zeichen
;
putchr:	in	r16,pind		;PortD Eingänge lesen
	bst	r16,3			;RS232-RTS aktiv (low)?
	brts	put010			;nein -> Timeout bearbeiten
	sbis	usr,udre		;Senderegister leer?
	rjmp	put010			;nein -> Timeout bearbeiten
	out	udr,r17			;Zeichen in Senderegister
	clr	r16
	out	tccr1b,r16		;Timeout-Zähler stoppen
	ret
put010:	in	r16,tccr1b		;ist Timeout bereits aktiv?
	tst	r16
	brne	putchr			;ja -> neuer Sendeversuch
	out	tcnt1h,r16
	out	tcnt1l,r16		;sonst Timeout auf ca. 1,1 s
	ldi	r16,(1<<cs11)+(1<<cs10)	;Vorteiler auf Ck/64 setzen
	out	tccr1b,r16		;Timeout starten
	rjmp	putchr			;neuer Sendeversuch
;
;	Unterprogramm zum Senden einer beliebigen Zeichenkette aus dem
;	Programmspeicher bis zum Endezeichen 0xff oder bis zum
;	Erreichen der Länge in r18
;	Register: r18 Länge der Zeichenkette
;		  r17
;
sndtx1:	ser	r18			;Länge auf 255 Zeichen setzen
sndtx2:	lpm				;Zeichen aus Programmspeicher
	mov	r17,r0			;holen und bereit legen
	cpi	r17,0xff		;Endezeichen?
	breq	snd030			;ja -> Ende
	tst	r17			;Zeichencode=0?
	breq	snd020			;ja -> Ausgabe überspringen
	rcall	putchr			;sonst Zeichen ausgeben
snd020:	ld	r0,z+			;Pointer erhöhen
	dec	r18			;alle Zeichen ausgegeben?
	brne	sndtx2			;nein -> Schleife
snd030:	ret
;
;	Unterprogramm zum Senden von CR/LF (neue Zeile)
;
sncrlf:	ldi	r17,cr			;Code für CR laden
	rcall	putchr			;senden
	ldi	r17,lf			;Code für LF laden
	rcall	putchr			;senden
	ret
;
;	Unterprogramm zum Einschalten der Status-LED für ca. 71 ms
;	Register: r16
;
ledxon:	led_on				;LED einschalten
	clr	r16
	out	tcnt0,r16		;Timer0 zurücksetzen
	ldi	r16,(1<<cs02)+(1<<cs00)	;Vorteiler auf Ck/1024 setzen
	out	tccr0,r16		;Timeout starten
	ret
;
;	Interrupt-Routine "Timer 0 Overflow"
;	wird ausgelöst, wenn der LED-Timer abgelaufen ist - die LED
;	wird dann wieder ausgeschaltet
;
t0oint:	ldi	itemp,0
	out	tccr0,itemp		;Timer0 stoppen
	led_off				;LED ausschalten
	reti
;
;	Interrupt-Routine "Timer 1 Overflow"
;	wird ausgelöst, wenn Senden von Daten wegen Deaktivierung von
;	RTS nicht möglich ist;
;
t1oint:	cts_off				;Daten-Emfang sperren
	clr	r16
	out	tccr1b,r16		;Timer stoppen
	lds	r16,prmode		;Gerätemodus holen
	tst	r16			;Menü-Modus?
	breq	t1o100			;ja -> Ende
	rcall	dat_in			;Datenleitungen auf Eingang
	rcall	adrclr			;Adresse löschen und ausgeben
	lds	r16,prmode		;Gerätemodus holen
	cpi	r16,1			;Programmier-Modus?
	brne	t1o010			;nein -> Lese-Modus
	lds	zl,eprdat+eprogb	;Routine für "Progr. deakt." L
	lds	zh,eprdat+eprogb+1	;Routine für "Progr. deakt." H
	icall
	rjmp	t1o100
t1o010:	rcall	readb1			;Lesen deaktivieren
;
t1o100:	led_on				;LED einschalten
	rcall	wa50ms			;50 ms warten
	rcall	wa50ms			;50 ms warten
	led_off				;LED ausschalten
	rcall	wa50ms			;50 ms warten
	rcall	wa50ms			;50 ms warten
	rjmp	t1o100			;Endlosschleife
;
;	Interrupt-Routine "UART Empfang komplett"
;	UART-Fehlerflags lesen und dem Hauptprogramm signalisieren,
;	empfangenes Byte im Ringpuffer speichern, wenn nur noch 10
;	Pufferplätze frei sind -> CTS deaktivieren, bei vollem Puffer
;	Fehlermeldung
;
rxcint:	in	isreg,sreg		;SREG sichern
	in	itemp,udr		;empfangenes Byte lesen
	sbic	usr,3			;Überlauf-Fehler?
	rjmp	rxcer1			;ja -> Fehler bearbeiten
rxc010:	sbic	usr,fe			;Rahmen-Fehler?
	rjmp	rxcer2			;ja -> Fehler bearbeiten
rxc020:	mov	xl,rxpoi1		;Empfangspuffer-Pointer1 laden
	clr	xh			;H-Byte löschen
	st	x+,itemp		;Byte speichern, Pointer+1
	andi	xl,0x3f
	ori	xl,rxbuff		;Übertrag korrigieren
	mov	rxpoi1,xl		;Pointer1 wieder speichern
	cp	rxpoi1,rxpoi2		;letzter Platz belegt?
	breq	rxcer3			;ja -> Fehler bearbeiten
	subi	xl,-10			;Pointer1 + 10
	andi	xl,0x3f
	ori	xl,rxbuff		;Übertrag korrigieren
	cp	xl,rxpoi2		;zehnt-letzter Platz erreicht?
	brne	rxcend			;nein -> Ende
	cts_off				;sonst RS232-CTS deaktivieren
	rjmp	rxcend
;
rxcer1:	ldi	itemp,1			;Fehlercode 1 (Reg-Überlauf)
	rjmp	rxcer9
rxcer2:	ldi	itemp,2			;Fehlercode 2 (Rahmen-Fehler)
	rjmp	rxcer9
rxcer3:	ldi	itemp,3			;Fehlercode 3 (Puffer-Überlauf)
rxcer9:	sts	erflag,itemp		;Fehlercode speichern
rxcend:	out	sreg,isreg		;SREG wiederherstellen
	reti
;
;
;	-------------------------
;	Textmeldungen (allgemein)
;	-------------------------
;
inistr:	.db	cr,lf,cr,lf,cr,lf
	.db	"EPROM-Prog v1.06 (20.04.2013) Scott-Falk Huehn"
	.db	cr,lf,cr,lf,0xff,0
eofstr:	.db	":00000001FF",cr,lf,0xff
;
;	-----------------------
;	Textmeldungen (deutsch)
;	-----------------------
;
resstd:	.db	", weiter mit ENTER: ",0xff,0
m1astd:	.db	"Aktueller IC-Typ: ",0xff,0
m1bstd:	.db	cr,lf,"EPROM-Groesse   : ",0xff,0
m1cstd:	.db	" kB",cr,lf,"Jumper-Stellung : ",0xff
m1dstd:	.db	cr,lf,cr,lf
	.db	"1 - IC-Typ waehlen     7 - Lese-Modus: ",0xff
m1estd:	.db	"alle Bytes",cr,lf,0xff,0
m1fstd:	.db	"ohne 0xFF",cr,lf,0xff
m1gstd:	.db	"2 - Programmieren      8 - Sprache: deutsch",cr,lf,0
	.db	"3 - Vergleichen        9 - RS232 Baudrate",cr,lf,0
	.db	"4 - Lesen",cr,lf,0
	.db	"5 - Leertest",cr,lf
	.db	"6 - Loeschen",cr,lf,cr,lf
	.db	"Auswahl (1-9): ",0xff
m2astd:	.db	"EPROM-Liste:",cr,lf,0xff,0
m2bstd:	.db	cr,lf,cr,lf
	.db	"Auswahl (00-",0xff,0
m2cstd:	.db	"): ",0xff
m3astd:	.db	"RS232 Baudrate: ",cr,lf,cr,lf
	.db	"1: 115200   2: 57600   3: 38400   4: 19200   5: 9600"
	.db	cr,lf,cr,lf,"Auswahl (1-4): ",0xff
m3bstd:	.db	cr,lf,cr,lf,"Bitte jetzt das Terminal umstellen"
	.db	" und das Programmiergeraet",cr,lf
	.db	"fuer einige Sekunden ausschalten ... ",0xff
pr1std:	.db	"Bitte jetzt am Terminal das Hex-File senden, ",0
	.db	"Abbruch mit ESC",cr,lf,cr,lf,0xff
pr2std:	.db	" Ok",cr,0xff,0
pr3std:	.db	" Fehler",cr,lf,0xff
pr4std:	.db	cr,lf,cr,lf,"Programmieren beendet",0xff
pr5std:	.db	cr,lf,cr,lf,"Vergleichen beendet",0xff
reastd:	.db	"Bitte jetzt die Textaufzeichnung am Terminal"
	.db	" starten und ENTER",cr,lf
	.db	"druecken. Nach erfolgreicher Uebertragung die "
	.db	"Textaufzeichnung",cr,lf
	.db	"am Terminal stoppen und nochmals ENTER druecken."
	.db	" Abbruch mit ESC",cr,lf,cr,lf,0xff,0
clt1sd:	.db	"Leertest ... ",0xff
clt2sd:	.db	"EPROM leer",0xff,0
clt3sd:	.db	"EPROM nicht leer",0xff,0
era1sd:	.db	"Loeschen nicht moeglich",0xff
era2sd:	.db	"Loeschen ... ",0xff
era3sd:	.db	"Ok",0xff,0
era4sd:	.db	"Fehler",0xff,0
er1std:	.db	cr,lf,cr,lf,"RS232 Ueberlauf-Fehler",0xff,0
er2std:	.db	cr,lf,cr,lf,"RS232 Rahmen-Fehler",0xff
er3std:	.db	cr,lf,cr,lf,"RS232 Puffer-Fehler",0xff
er4std:	.db	cr,lf,cr,lf,"Fehler im Hexfile",0xff
er5std:	.db	cr,lf,cr,lf,"Unbekannter Fehler",0xff,0
er9std:	.db	", weiter mit ESC: ",0xff,0
;
;	-----------------------
;	text messages (english)
;	-----------------------
;
resste:	.db	", press ENTER to continue: ",0xff
m1aste:	.db	"Current IC type : ",0xff,0
m1bste:	.db	cr,lf,"EPROM size      : ",0xff,0
m1cste:	.db	" kB",cr,lf,"Jumper settings : ",0xff
m1dste:	.db	cr,lf,cr,lf
	.db	"1 - Select IC type     7 - Read mode: ",0xff,0
m1este:	.db	"all bytes",cr,lf,0xff
m1fste:	.db	"without 0xFF",cr,lf,0xff,0
m1gste:	.db	"2 - Program            8 - Language: english",cr,lf
	.db	"3 - Verify             9 - RS232 baud rate",cr,lf
	.db	"4 - Read",cr,lf
	.db	"5 - Empty check",cr,lf,0
	.db	"6 - Erase",cr,lf,cr,lf,0
	.db	"Select (1-9): ",0xff,0
m2aste:	.db	"EPROM list:",cr,lf,0xff
m2bste:	.db	cr,lf,cr,lf
	.db	"Select (00-",0xff
m2cste:	.db	"): ",0xff
m3aste:	.db	"RS232 baud rate:",cr,lf,cr,lf
	.db	"1: 115200   2: 57600   3: 38400   4: 19200   5: 9600"
	.db	cr,lf,cr,lf,"Select (1-4): ",0xff,0
m3bste:	.db	cr,lf,cr,lf,"Please change the terminal settings now "
	.db	"and after this",cr,lf,"turn off the programmer "
	.db	"for a few seconds ... ",0xff,0
pr1ste:	.db	"Please send Hex file now on terminal, "
	.db	"press ESC to interrupt",cr,lf,cr,lf,0xff,0
pr2ste:	.db	" Ok",cr,0xff,0
pr3ste:	.db	" Error",cr,lf,0xff,0
pr4ste:	.db	cr,lf,cr,lf,"Program done",0xff,0
pr5ste:	.db	cr,lf,cr,lf,"Verify done",0xff
reaste:	.db	"Now start the text recording function on the"
	.db	" terminal and press ENTER.",cr,lf
	.db	"If the transmission was successful, "
	.db	"then stop the text recording",cr,lf
	.db	"on the terminal and press ENTER again."
	.db	" Press ESC to interrupt",cr,lf,cr,lf,0xff
clt1se:	.db	"Empty check ... ",0xff,0
clt2se:	.db	"EPROM empty",0xff
clt3se:	.db	"EPROM not empty",0xff
era1se:	.db	"Erase not possible",0xff,0
era2se:	.db	"Erasing ... ",0xff,0
era3se:	.db	"Ok",0xff,0
era4se:	.db	"Error",0xff
er1ste:	.db	cr,lf,cr,lf,"RS232 Overrun error",0xff
er2ste:	.db	cr,lf,cr,lf,"RS232 Frame error",0xff
er3ste:	.db	cr,lf,cr,lf,"RS232 Buffer error",0xff,0
er4ste:	.db	cr,lf,cr,lf,"Error in Hex file",0xff
er5ste:	.db	cr,lf,cr,lf,"Unknown error",0xff
er9ste:	.db	", ESC to continue: ",0xff
;
;
;	-----------------------------------------------
;	Spezielle Programmier- und Lese-Routinen (fest)
;	-----------------------------------------------
;
;	Lesen aktivieren, EPROM-Spannung auswählen und einschalten,
;	sonstige Steuersignale aktivieren, für alle IC-Typen gleich
;
reada1:	vcc_50				;Vcc auf 5,0V setzen
	vcc_on				;Vcc einschalten
	pr_high				;/PR high
	ce_high				;/CE high
	oe_high				;/OE high
	rcall	wa10us			;10 µs warten
	ret
;
;	Lesen deaktivieren, alle Steuersignale auf Low setzen, EPROM-
;	Spannung abschalten, für alle IC-Typen
;
readb1:	oe_low				;/OE low
	ce_low				;/CE low
	pr_low				;/PR low
	vcc_off				;Vcc ausschalten
	ret
;
;	Daten lesen, kompletter Lesezyklus, Datenbyte muss von PortA
;	gelesen werden und in R17 übergeben werden, für alle IC-Typen
;
readc1:	ce_low				;/CE low
	oe_low				;/OE low
	nop				;
	nop				;ca. 540 ns warten
	in	r17,pina		;Daten einlesen
	oe_high				;/OE high
	ce_high				;/CE high
	ret
;
;	---------------------------------------------------
;	Spezielle Programmier- und Lese-Routinen (variabel)
;	---------------------------------------------------
;
;	Programmieren aktivieren, EPROM-Spannung auswählen und ein-
;	schalten, Programmierspannung einschalten, sonstige Steuer-
;	signale aktivieren
;
;	Routine für: 2716
;
proga1:	vcc_50				;Vcc auf 5,0V setzen
	vcc_on				;Vcc einschalten
	vpp_on				;Vpp einschalten
	ce_low				;/CE low
	oe_low				;/OE low
	ret
;
;	Routine für: 2732A,27512
;
proga2:	vcc_50				;Vcc auf 5,0V setzen
	vcc_on				;Vcc einschalten
	ce_high				;/CE high
	oe_low				;/OE low
	ret
;
;	Routine für: 2764A,27128A
;
proga3:	vcc_50				;Vcc auf 5,0V setzen
	vcc_on				;Vcc einschalten
	pr_high				;/PR high
	oe_high				;/OE high
	ce_low				;/CE low
	rcall	wa10us			;10µs warten
	vpp_on				;Vpp einschalten
	ret
;
;	Routine für: 27C64,27C128,27C1001,27C2001
;
proga4:	vcc_64				;Vcc auf 6,4V setzen
	vcc_on				;Vcc einschalten
	pr_high				;/PR high
	oe_high				;/OE high
	ce_low				;/CE low
	rcall	wa10us			;10µs warten
	vpp_on				;Vpp einschalten
	ret
;
;	Routine für: 27256
;
proga5:	vcc_50				;Vcc auf 5,0V setzen
	vcc_on				;Vcc einschalten
	oe_high				;/OE high
	ce_high				;/CE high
	rcall	wa10us			;10µs warten
	vpp_on				;Vpp einschalten
	ret
;
;	Routine für: 27C256,27C4001
;
proga6:	vcc_64				;Vcc auf 6,4V setzen
	vcc_on				;Vcc einschalten
	oe_high				;/OE high
	ce_high				;/CE high
	rcall	wa10us			;10µs warten
	vpp_on				;Vpp einschalten
	ret
;
;	Routine für: 27C512,27C8001
;
proga7:	vcc_50				;Vcc auf 5,0V setzen
	vcc_on				;Vcc einschalten
	ce_high				;/CE high
	oe_low				;/OE low
	rcall	wai2us			;2µs warten
	vcc_64				;Vcc auf 6,4V setzen
	ret
;
;	Routine für: 28F010,28F020
;
proga8:	vcc_50				;Vcc auf 5,0V setzen
	vcc_on				;Vcc einschalten
	pr_high				;/PR high
	oe_high				;/OE high
	ce_high				;/CE high
	rcall	wa10us			;10µs warten
	vpp_on				;Vpp einschalten
	ret
;
;	Routine für: 29F010B,29F040B
;
proga9:	vcc_50				;Vcc auf 5,0V setzen
	vcc_on				;Vcc einschalten
	pr_high				;/PR high
	oe_high				;/OE high
	ce_high				;/CE high
	rcall	wa50us			;50µs warten
	ret
;
;	Routine für: 28C64B,28C256
;
progaa:	vcc_50				;Vcc auf 5,0V setzen
	vcc_on				;Vcc einschalten
	pr_high				;/PR high
	oe_high				;/OE high
	ce_high				;/CE high
	rcall	wa10ms			;10ms warten
	ret
;
;	Programmieren deaktivieren, alle Steuersignale auf Low setzen,
;	EPROM-Spannungen abschalten
;
;	Routine für: 2716,2732A,2764A,27C64,27128A,27C128,27256,27C256,
;		     27512,27C512,27C1001,27C2001,27C4001,27C8001
;		     28F010,28F020
;
progb1:	vpp_off				;Vpp ausschalten
	rcall	wa10us			;10µs warten (bis Vpp=Vcc)
	oe_low				;/OE low
	ce_low				;/CE low
	pr_low				;/PR low
	vcc_off				;Vcc ausschalten
	ret
;
;	Routine für: 28C64B,28C256,29F010B,29F040B
;
progb2:	oe_low				;/OE low
	ce_low				;/CE low
	pr_low				;/PR low
	vcc_off				;Vcc ausschalten
	ret
;
;	Programmieren, kompletter Programmierzyklus, Datenbyte in R18
;	muss an PortA ausgeben werden
;
;	Routine für: 2716
;
progc1:	out	porta,r18		;Byte an EPROM ausgeben
	ce_high				;/CE high
	rcall	wai2us			;2µs warten
	oe_high				;/OE high
	rcall	wai1ms			;Programmierimpuls 1 ms
	oe_low				;/OE low
	rcall	wai2us			;2µs warten
	ce_low				;/CE low
	ret
;
;	Routine für: 2732A,27512,27C512,27C8001
;
progc2:	out	porta,r18		;Byte an EPROM ausgeben
	vpp_on				;Vpp einschalten
	rcall	wai2us			;2µs warten
	ce_low				;/CE low
	rcall	wai1ms			;Programmierimpuls 1 ms
	ce_high				;/CE high
	rcall	wai2us			;2µs warten
	vpp_off				;Vpp ausschalten
	rcall	wa10us			;10µs warten (bis Vpp=0)
	ret
;
;	Routine für: 2764A,27128A
;
progc3:	out	porta,r18		;Byte an EPROM ausgeben
	pr_low				;/PR low
	rcall	wai1ms			;Programmierimpuls 1 ms
	pr_high				;/PR high
	rcall	wai2us			;2µs warten
	ret
;
;	Routine für: 27C64,27C128,27C1001,27C2001
;
progc4:	out	porta,r18		;Byte an EPROM ausgeben
	pr_low				;/PR low
	rcall	w100us			;Programmierimpuls 100 µs
	pr_high				;/PR high
	rcall	wai2us			;2µs warten
	ret
;
;	Routine für: 27256
;
progc5:	out	porta,r18		;Byte an EPROM ausgeben
	ce_low				;/CE low
	rcall	wai1ms			;Programmierimpuls 1 ms
	ce_high				;/CE high
	rcall	wai2us			;2µs warten
	ret
;
;	Routine für: 27C256,27C4001
;
progc6:	out	porta,r18		;Byte an EPROM ausgeben
	ce_low				;/CE low
	rcall	w100us			;Programmierimpuls 100 µs
	ce_high				;/CE high
	rcall	wai2us			;2µs warten
	ret
;
;	Routine für: 28F010,28F020
;
progc7:	ldi	r16,0x40		;Programmieren-Kommando
	out	porta,r16		;ausgeben
	ce_low				;/CE low
	pr_low				;/PR low
	pr_high				;/PR high
	ce_high				;/CE high
	out	porta,r18
	ce_low				;/CE low
	pr_low				;/PR low
	pr_high				;/PR high
	ce_high				;/CE high
	rcall	wa10us			;10µs warten
	ret
;
;	Routine für: 29F010B,29F040B
;
progc8:	sts	adbuf0,r20
	sts	adbuf1,r21
	sts	adbuf2,r22		;aktuelle Adresse sichern
	ldi	r20,low(0x0555)
	ldi	r21,high(0x0555)
	clr	r22
	rcall	adrset			;Adresse und Kommandobyte 1
	ldi	r16,0xaa		;für Programmieren
	out	porta,r16		;ausgeben
	ce_low				;/CE low
	pr_low				;/PR low
	pr_high				;/PR high
	ce_high				;/CE high
	ldi	r20,low(0x02AA)
	ldi	r21,high(0x02AA)
	clr	r22
	rcall	adrset			;Adresse und Kommandobyte 2
	ldi	r16,0x55		;für Programmieren
	out	porta,r16		;ausgeben
	ce_low				;/CE low
	pr_low				;/PR low
	pr_high				;/PR high
	ce_high				;/CE high
	ldi	r20,low(0x0555)
	ldi	r21,high(0x0555)
	clr	r22
	rcall	adrset			;Adresse und Kommandobyte 3
	ldi	r16,0xA0		;für Programmieren
	out	porta,r16		;ausgeben
	ce_low				;/CE low
	pr_low				;/PR low
	pr_high				;/PR high
	ce_high				;/CE high
	lds	r20,adbuf0
	lds	r21,adbuf1
	lds	r22,adbuf2		;aktuelle Adresse holen
	rcall	adrset			;und setzen
	out	porta,r18		;Byte ausgeben
	ce_low				;/CE low
	pr_low				;/PR low
	pr_high				;/PR high
	ce_high				;/CE high
	ret
;
;	Routine für: 28C64B,28C256
;
progc9:	out	porta,r18
	ce_low				;/CE low
	pr_low				;/PR low
	pr_high				;/PR high
	ce_high				;/CE high
	ret
;
;	Vergleichen, kompletter Lesezyklus, Datenbyte muss von PortA
;	gelesen werden und in R17 übergeben werden
;
;	Routine für: 2716
;
progd1:	in	r17,pina		;Daten einlesen
	ret
;
;	Routine für: 2732A,27512,27C512,27C8001
;
progd2:	ce_low				;/CE low
	nop
	nop
	nop
	nop				;ca. 1,1 µs warten
	in	r17,pina		;Daten einlesen
	ce_high				;/CE high
	ret
;
;	Routine für: 2764A,27C64,27128A,27C128,27256,27C256,27C1001
;		     27C2001,27C4001
;
progd3:	rcall	wai2us			;2µs warten
	oe_low				;/OE low
	nop
	nop				;ca. 540 ns warten
	in	r17,pina		;Daten einlesen
	oe_high				;/OE high
	ret
;
;	Routine für: 28F010,28F020
;
progd4:	rcall	dat_o1			;Datenleitungen auf Ausgang H
	ldi	r16,0xC0		;Verify-Kommando
	out	porta,r16		;ausgeben
	ce_low				;/CE low
	pr_low				;/PR low
	pr_high				;/PR high
	ce_high				;/CE high
	rcall	wai6us			;6µs warten
	rcall	dat_ip			;Datenleitungen auf Eing-Pullup
	ce_low				;/CE low
	oe_low				;/OE low
	nop				;ca. 270 ns warten
	in	r17,pina		;Daten einlesen
	oe_high				;/OE high
	ce_high				;/CE high
	ret
;
;	Routine für: 29F010
;
progd5:	ldi	r24,80			;Zeitkonstante für ca. 300 µs
prd5_1:	ce_low				;/CE low
	oe_low				;/OE low
	nop				;ca. 270 ns warten
	in	r17,pina		;Datenbyte einlesen
	oe_high				;/OE high
	ce_high				;/CE high
	mov	r15,r17			;Datenbyte sichern
	mov	r16,r18			;Sollbyte kopieren
	andi	r16,0x80		;Bit 7 filtern
	andi	r17,0x80		;Bit 7 bei Istbyte filtern
	cp	r17,r16			;Data-Polling-Bit vergleichen
	breq	prd5_2			;ok? ja -> Ende
	dec	r24			;sonst Zähler dekrementieren
	brne	prd5_1			;Timeout? nein -> Schleife
prd5_2:	mov	r17,r15			;gesichertes Datenbyte holen
	ret
;
;	Routine für: 28C64B
;
progd6:	ldi	r24,20			;20x im Abstand von 500µs lesen
prd6_1:	push	r24                     ;Zähler sichern
	rcall	w500us			;500µs warten
	pop	r24			;Zähler wieder herstellen
	ce_low				;/CE low
	oe_low				;/OE low
	nop				;ca. 270 ns warten
	in	r17,pina		;Datenbyte einlesen
	oe_high				;/OE high
	ce_high				;/CE high
	cp	r17,r18			;gelesen Byte vergleichen
	breq	prd6_2			;ok? ja -> Ende
	dec	r24			;sonst Zähler dekrementieren
	brne	prd6_1			;Timeout? nein -> Schleife
prd6_2:	ret
;
;	EEPROM löschen
;	Register r16,r17,r18,r19,r20,r21,r22,yl,yh,zl,zh
;		 r18 Fehlerstatus (0=ok)
;
;	Routine für 28F010,28F020
;	zuerst alle Bytes mit 0 beschreiben, dann spezieller
;	Lösch-Algorithmus
;
erase1:	rcall	adrclr			;Adresse löschen und ausgeben
eras10:	rcall	adrset			;EPROM-Adresse setzen
	clr	r18			;Datenbyte=0 setzen
	lds	r19,eprdat+eprim1	;Anzahl der Programmierimpulse
eras11:	tst	r19			;alle Prog-Impulse ausgegeben?
	breq	eras12			;ja -> weiter
	rcall	dat_o1			;Datenleitungen auf Ausgang H
	lds	zl,eprdat+eprogc	;Routine für "Programmieren" L
	lds	zh,eprdat+eprogc+1	;Routine für "Programmieren" H
	icall				;aufrufen
	rcall	dat_ip			;Datenleitungen auf Eing-Pullup
	lds	zl,eprdat+eprogd	;Routine für "Vergleichen" L
	lds	zh,eprdat+eprogd+1	;Routine für "Vergleichen" H
	icall				;aufrufen
	dec	r19			;Impulszähler -1
	cp	r17,r18			;Programmierung erfolgreich?
	brne	eras11			;nein -> neuer Progr.-Impuls
eras12:	rcall	adrinc			;Adresse erhöhen
	rcall	adrchk			;EPROM-Ende erreicht/überschr.?
	breq	eras13			;ja -> Programmieren beenden
	brcs	eras13			;ja -> Programmieren beenden
	rjmp	eras10			;sonst Schleife
;
eras13:	rcall	adrclr			;Adresse löschen und ausgeben
	ldi	yl,low(1000)
	ldi	yh,high(1000)		;maximal 1000 Löschzyklen
eras14:	rcall	dat_o1			;Datenleitungen auf Ausgang H
	ldi	r18,0x20		;Löschen-Kommando
	out	porta,r18		;ausgeben
	ce_low				;/CE low
	pr_low				;/PR low
	pr_high				;/PR high
	ce_high				;/CE high
	ce_low				;/CE low, nochmals ausgeben
	pr_low				;/PR low
	pr_high				;/PR high
	ce_high				;/CE high
	rcall	wa10ms			;10ms warten
eras15:	rcall	adrset			;EPROM-Adresse setzen
	rcall	dat_o1			;Datenleitungen auf Ausgang H
	ldi	r18,0xA0		;EraseVerify-Kommando
	out	porta,r18		;ausgeben
	ce_low				;/CE low
	pr_low				;/PR low
	pr_high				;/PR high
	ce_high				;/CE high
	rcall	wai6us			;6µs warten
	rcall	dat_ip			;Datenleitungen auf Eing-Pullup
	ce_low				;/CE low
	oe_low				;/OE low
	nop				;ca. 270 ns warten
	in	r17,pina		;Daten einlesen
	oe_high				;/OE high
	ce_high				;/CE high
	cpi	r17,0xff		;Speicherzelle leer?
	breq	eras16			;ja -> weiter
	ld	r16,-y			;Löschzyklenzähler -1
	mov	r16,yl
	or	r16,yh			;Löschzyklenzähler=0?
	breq	eras18			;ja -> Fehler
	rjmp	eras14			;sonst Löschen wiederholen
eras16:	rcall	adrinc			;Adresse erhöhen
	rcall	adrchk			;EPROM-Ende erreicht/überschr.?
	breq	eras17			;ja -> Löschen beenden
	brcs	eras17			;ja -> Löschen beenden
	rjmp	eras15			;Schleife
eras17:	clr	r18			;kein Fehler
	ret
eras18:	ser	r18			;Lösch-Fehler
	ret
;
;	Routine für 29F010B
;
erase2:	ldi	r19,8			;Timeout für Löschen 8 s
;
eras20:	rcall	dat_o1			;Datenleitungen auf Ausgang
	ldi	r18,2			;2x3 Kommandobytes ausgeben
eras21:	ldi	r20,low(0x0555)
	ldi	r21,high(0x0555)
	clr	r22
	rcall	adrset			;Adresse und Kommandobyte 1/4
	ldi	r16,0xaa		;für Chip Erase
	out	porta,r16		;ausgeben
	ce_low				;/CE low
	pr_low				;/PR low
	pr_high				;/PR high
	ce_high				;/CE high
	ldi	r20,low(0x02AA)
	ldi	r21,high(0x02AA)
	clr	r22
	rcall	adrset			;Adresse und Kommandobyte 2/5
	ldi	r16,0x55		;für Chip Erase
	out	porta,r16		;ausgeben
	ce_low				;/CE low
	pr_low				;/PR low
	pr_high				;/PR high
	ce_high				;/CE high
	ldi	r20,low(0x0555)
	ldi	r21,high(0x0555)
	clr	r22
	rcall	adrset			;Adresse und Kommandobyte 3/6
	ldi	r16,0x80		;für Chip Erase
	cpi	r18,2			;erster Durchlauf?
	breq	eras22			;ja -> weiter
	ldi	r16,0x10		;sonst Datenbyte ändern
eras22:	out	porta,r16		;ausgeben
	ce_low				;/CE low
	pr_low				;/PR low
	pr_high				;/PR high
	ce_high				;/CE high
	dec	r18			;2 Durchläufe komplett?
	brne	eras21			;nein -> Schleife
;
	rcall	adrclr			;Adresse löschen und ausgeben
	rcall	dat_ip			;Datenleitungen auf Eing-Pullup
	ldi	r18,20			;2. Zeitschleife 1s (20 x 50ms)
	ce_low				;/CE low
	oe_low				;/OE low
	nop				;ca. 270 ns warten
	in	r16,pina		;Datenbyte einlesen
	oe_high				;/OE high
	ce_high				;/CE high
	andi	r16,0x40		;Toggle-Bit filtern
eras23:	rcall	wa50ms			;50 ms warten
	ce_low				;/CE low
	oe_low				;/OE low
	nop				;ca. 270 ns warten
	in	r17,pina		;Datenbyte einlesen
	oe_high				;/OE high
	ce_high				;/CE high
	andi	r17,0x40		;Toggle-Bit filtern
	cp	r16,r17			;Statusänderung?
	breq	eras24			;nein -> Ende
	mov	r16,r17			;letzten Status speichern
	dec	r18			;innere Schleife dekrementieren
	brne	eras23			;Ende? nein -> Schleife
	dec	r19			;äußere Schleife dekrementieren
	brne	eras23			;Timeout? nein -> Schleife
	ser	r18			;sonst Lösch-Fehler
	ret
eras24:	clr	r18			;kein Fehler
	ret
;
;	Routine für 29F040B
;
erase3:	ldi	r19,64			;Timeout für Löschen 64 s
	rjmp	eras20			;gleiche Routine wie 29F010B
;
;	Routine für 28C64B,28C256
;
erase4:	vpp_on				;Vpp einschalten (12V)
	ce_low				;/CE low
	rcall	wa10us			;10µs warten
	pr_low				;/PR low
	rcall	wa10ms			;10ms warten
	pr_high				;/PR high
	rcall	wa10us			;10µs warten
	ce_high				;/CE high
	vpp_off				;Vpp ausschalten
	rcall	wa10us			;10µs warten
	clr	r18			;kein Fehler
	ret
;
;
;	-----------------------------------------------------------
;	EPROM-Tabelle, ein Tabellenplatz belegt 19 Words (38 Bytes)
;	-----------------------------------------------------------
;
eprtab:	.db	"2716-25V    16xx111xxx";Name (12) + Jumper (10)
	.dd	0x000800		;Größe (0x000800 = 2kB)
	.dw	proga1			;Programmieren aktivieren
	.dw	progb1			;Programmieren deaktivieren
	.dw	progc1			;Programmieren (Schreibzyklus)
	.dw	progd1			;Programmieren (Vergl.-Zyklus)
	.dw	0			;Löschen (nicht unterstützt)
	.db	45,5			;Anzahl der Programmierimpulse
					;Anzahl der Sicherheitsimpulse
;
	.db	"2732-21V    35xx221xxx";Name (12) + Jumper (10)
	.dd	0x001000		;Größe (0x001000 = 4kB)
	.dw	proga2			;Programmieren aktivieren
	.dw	progb1			;Programmieren deaktivieren
	.dw	progc2			;Programmieren (Schreibzyklus)
	.dw	progd2			;Programmieren (Vergl.-Zyklus)
	.dw	0			;Löschen (nicht unterstützt)
	.db	45,5			;Anzahl der Programmierimpulse
					;Anzahl der Sicherheitsimpulse
;
	.db	"2764        12x112411x";Name (12) + Jumper (10)
	.dd	0x002000		;Größe (0x002000 = 8kB)
	.dw	proga3			;Programmieren aktivieren
	.dw	progb1			;Programmieren deaktivieren
	.dw	progc3			;Programmieren (Schreibzyklus)
	.dw	progd3			;Programmieren (Vergl.-Zyklus)
	.dw	0			;Löschen (nicht unterstützt)
	.db	25,5			;Anzahl der Programmierimpulse
					;Anzahl der Sicherheitsimpulse
;
	.db	"27C64       12x112411x";Name (12) + Jumper (10)
	.dd	0x002000		;Größe (0x002000 = 8kB)
	.dw	proga4			;Programmieren aktivieren
	.dw	progb1			;Programmieren deaktivieren
	.dw	progc4			;Programmieren (Schreibzyklus)
	.dw	progd3			;Programmieren (Vergl.-Zyklus)
	.dw	0			;Löschen (nicht unterstützt)
	.db	20,0			;Anzahl der Programmierimpulse
					;Anzahl der Sicherheitsimpulse
;
	.db	"27128       12x112211x";Name (12) + Jumper (10)
	.dd	0x004000		;Größe (0x004000 = 16kB)
	.dw	proga3			;Programmieren aktivieren
	.dw	progb1			;Programmieren deaktivieren
	.dw	progc3			;Programmieren (Schreibzyklus)
	.dw	progd3			;Programmieren (Vergl.-Zyklus)
	.dw	0			;Löschen (nicht unterstützt)
	.db	25,5			;Anzahl der Programmierimpulse
					;Anzahl der Sicherheitsimpulse
;
	.db	"27C128      12x112211x";Name (12) + Jumper (10)
	.dd	0x004000		;Größe (0x004000 = 16kB)
	.dw	proga4			;Programmieren aktivieren
	.dw	progb1			;Programmieren deaktivieren
	.dw	progc4			;Programmieren (Schreibzyklus)
	.dw	progd3			;Programmieren (Vergl.-Zyklus)
	.dw	0			;Löschen (nicht unterstützt)
	.db	20,0			;Anzahl der Programmierimpulse
					;Anzahl der Sicherheitsimpulse
;
	.db	"27256       12x112221x";Name (12) + Jumper (10)
	.dd	0x008000		;Größe (0x008000 = 32kB)
	.dw	proga5			;Programmieren aktivieren
	.dw	progb1			;Programmieren deaktivieren
	.dw	progc5			;Programmieren (Schreibzyklus)
	.dw	progd3			;Programmieren (Vergl.-Zyklus)
	.dw	0			;Löschen (nicht unterstützt)
	.db	25,5			;Anzahl der Programmierimpulse
					;Anzahl der Sicherheitsimpulse
;
	.db	"27C256      12x112221x";Name (12) + Jumper (10)
	.dd	0x008000		;Größe (0x008000 = 32kB)
	.dw	proga6			;Programmieren aktivieren
	.dw	progb1			;Programmieren deaktivieren
	.dw	progc6			;Programmieren (Schreibzyklus)
	.dw	progd3			;Programmieren (Vergl.-Zyklus)
	.dw	0			;Löschen (nicht unterstützt)
	.db	20,0			;Anzahl der Programmierimpulse
					;Anzahl der Sicherheitsimpulse
;
	.db	"27512       32x222221x";Name (12) + Jumper (10)
	.dd	0x010000		;Größe (0x010000 = 64kB)
	.dw	proga2			;Programmieren aktivieren
	.dw	progb1			;Programmieren deaktivieren
	.dw	progc2			;Programmieren (Schreibzyklus)
	.dw	progd2			;Programmieren (Vergl.-Zyklus)
	.dw	0			;Löschen (nicht unterstützt)
	.db	25,5			;Anzahl der Programmierimpulse
					;Anzahl der Sicherheitsimpulse
;
	.db	"27C512      32x222221x";Name (12) + Jumper (10)
	.dd	0x010000		;Größe (0x010000 = 64kB)
	.dw	proga7			;Programmieren aktivieren
	.dw	progb1			;Programmieren deaktivieren
	.dw	progc2			;Programmieren (Schreibzyklus)
	.dw	progd2			;Programmieren (Vergl.-Zyklus)
	.dw	0			;Löschen (nicht unterstützt)
	.db	20,0			;Anzahl der Programmierimpulse
					;Anzahl der Sicherheitsimpulse
;
	.db	"27C1001(010)1212122241";Name (12) + Jumper (10)
	.dd	0x020000		;Größe (0x020000 = 128kB)
	.dw	proga4			;Programmieren aktivieren
	.dw	progb1			;Programmieren deaktivieren
	.dw	progc4			;Programmieren (Schreibzyklus)
	.dw	progd3			;Programmieren (Vergl.-Zyklus)
	.dw	0			;Löschen (nicht unterstützt)
	.db	20,0			;Anzahl der Programmierimpulse
					;Anzahl der Sicherheitsimpulse
;
	.db	"27C2001(020)1212122221";Name (12) + Jumper (10)
	.dd	0x040000		;Größe (0x040000 = 256kB)
	.dw	proga4			;Programmieren aktivieren
	.dw	progb1			;Programmieren deaktivieren
	.dw	progc4			;Programmieren (Schreibzyklus)
	.dw	progd3			;Programmieren (Vergl.-Zyklus)
	.dw	0			;Löschen (nicht unterstützt)
	.db	20,0			;Anzahl der Programmierimpulse
					;Anzahl der Sicherheitsimpulse
;
	.db	"27C4001(040)1212122222";Name (12) + Jumper (10)
	.dd	0x080000		;Größe (0x080000 = 512kB)
	.dw	proga6			;Programmieren aktivieren
	.dw	progb1			;Programmieren deaktivieren
	.dw	progc6			;Programmieren (Schreibzyklus)
	.dw	progd3			;Programmieren (Vergl.-Zyklus)
	.dw	0			;Löschen (nicht unterstützt)
	.db	20,0			;Anzahl der Programmierimpulse
					;Anzahl der Sicherheitsimpulse
;
	.db	"27C8001(080)3222222222";Name (12) + Jumper (10)
	.dd	0x100000		;Größe (0x100000 = 1024kB)
	.dw	proga7			;Programmieren aktivieren
	.dw	progb1			;Programmieren deaktivieren
	.dw	progc2			;Programmieren (Schreibzyklus)
	.dw	progd2			;Programmieren (Vergl.-Zyklus)
	.dw	0			;Löschen (nicht unterstützt)
	.db	20,0			;Anzahl der Programmierimpulse
					;Anzahl der Sicherheitsimpulse
;
	.db	"28C64B      31x422411x";Name (12) + Jumper (10)
	.dd	0x002000		;Größe (0x002000 = 8kB)
	.dw	progaa			;Programmieren aktivieren
	.dw	progb2			;Programmieren deaktivieren
	.dw	progc9			;Programmieren (Schreibzyklus)
	.dw	progd6			;Programmieren (Vergl.-Zyklus)
	.dw	erase4			;Löschen
	.db	1,0			;Anzahl der Programmierimpulse
					;Anzahl der Sicherheitsimpulse
;

	.db	"28C256      31x322211x";Name (12) + Jumper (10)
	.dd	0x008000		;Größe (0x008000 = 32kB)
	.dw	progaa			;Programmieren aktivieren
	.dw	progb2			;Programmieren deaktivieren
	.dw	progc9			;Programmieren (Schreibzyklus)
	.dw	progd6			;Programmieren (Vergl.-Zyklus)
	.dw	erase4			;Löschen
	.db	1,0			;Anzahl der Programmierimpulse
					;Anzahl der Sicherheitsimpulse
;
	.db	"28F010      1112122241";Name (12) + Jumper (10)
	.dd	0x020000		;Größe (0x020000 = 128kB)
	.dw	proga8			;Programmieren aktivieren
	.dw	progb1			;Programmieren deaktivieren
	.dw	progc7			;Programmieren (Schreibzyklus)
	.dw	progd4			;Programmieren (Vergl.-Zyklus)
	.dw	erase1			;Löschen
	.db	25,0			;Anzahl der Programmierimpulse
					;Anzahl der Sicherheitsimpulse
;
	.db	"28F020      1112122221";Name (12) + Jumper (10)
	.dd	0x040000		;Größe (0x040000 = 256kB)
	.dw	proga8			;Programmieren aktivieren
	.dw	progb1			;Programmieren deaktivieren
	.dw	progc7			;Programmieren (Schreibzyklus)
	.dw	progd4			;Programmieren (Vergl.-Zyklus)
	.dw	erase1			;Löschen
	.db	25,0			;Anzahl der Programmierimpulse
					;Anzahl der Sicherheitsimpulse
;
	.db	"29F010B     2x42122241";Name (12) + Jumper (10)
	.dd	0x020000		;Größe (0x020000 = 128kB)
	.dw	proga9			;Programmieren aktivieren
	.dw	progb2			;Programmieren deaktivieren
	.dw	progc8			;Programmieren (Schreibzyklus)
	.dw	progd5			;Programmieren (Vergl.-Zyklus)
	.dw	erase2			;Löschen
	.db	1,0			;Anzahl der Programmierimpulse
					;Anzahl der Sicherheitsimpulse
;
	.db	"29F040B     2x32122221";Name (12) + Jumper (10)
	.dd	0x080000		;Größe (0x080000 = 512kB)
	.dw	proga9			;Programmieren aktivieren
	.dw	progb2			;Programmieren deaktivieren
	.dw	progc8			;Programmieren (Schreibzyklus)
	.dw	progd5			;Programmieren (Vergl.-Zyklus)
	.dw	erase3			;Löschen
	.db	1,0			;Anzahl der Programmierimpulse
					;Anzahl der Sicherheitsimpulse
;
	.db	0xff,0xff		;Tabellen-Ende
;
.eseg
;
;	----------------------------
;	EEPROM-Bereich des AT90S8515
;	----------------------------
;
dummy:	.db	0xff		;erstes Byte wird nicht genutzt
eptent:	.db	0		;EPROM-Tabellen-Eintrag, enthält die
				;Nummer des zuletzt gewählten EPROMs im
				;BCD-Code, wird beim Einschalten des
				;Gerätes gelesen
ebaudr:	.db	1		;Baudrate für RS232-Schnittstelle
				;1: 115200 Baud
				;2:  57600 Baud
				;3:  38400 Baud
				;4:  19200 Baud
				;5:   9600 Baud
ereadm:	.db	1		;Lese-Modus:
				;0: alle Bytes werden gelesen
				;1: 0xff-Zeilen werden nicht gelesen
elangu:	.db	0		;Sprachauswahl:
				;0: deutsch
				;1: englisch
;
