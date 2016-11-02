.NOLIST
.INCLUDE "tn11def.inc"
.LIST

.DEF	r = R16
.DEF	ar1 = R17
.DEF	ar2 = R18

rjmp	main

test_arithm:
	ldi	ar1,0x02
	ldi	ar2,0x04
	add	ar1,ar2
	cpi	ar1,0x06
	brne	error
	ret

turn_off:
	clr	r
	out	PORTB,r
	ret

turn_on:
	ser	r
	out	PORTB,r
	ret

main:
	ldi	r,0xFF
	out	DDRB,r
	rcall	test_arithm
loop:
	rcall	turn_off
	rcall	turn_on
	rjmp	loop

error:
	nop

