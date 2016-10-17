.NOLIST
.INCLUDE "tn11def.inc"
.LIST

.DEF	r = R16

rjmp	main

turn_off:
	ldi	r,0x00
	out	PORTB,r
	ret

turn_on:
	ldi	r,0xFF
	out	PORTB,r
	ret

main:
	ldi	r,0xFF
	out	DDRB,r
loop:
	rcall	turn_off
	rcall	turn_on
	rjmp	loop
