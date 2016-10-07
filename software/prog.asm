.NOLIST
.INCLUDE "tn11def.inc"
.LIST

.DEF	r = R16

rjmp	main

main:
	ldi	r,0b11111111
	out	DDRB,r
loop:
	ldi	r,0x00
	out	PORTB,r
	ldi	r,0xFF
	out	PORTB,r
	rjmp	loop
