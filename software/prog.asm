.NOLIST
.INCLUDE "tn11def.inc"
.LIST

.DEF	r1 = R16
.DEF	r2 = R17

ldi	r1,0xFF
ldi	r2,0x00
out	DDRB,r1
out PORTB,r1
out PORTB,r2
out DDRB,r2
