	.text
	.global strlen
/*
	size_t strlen ( const char * str )
*/		

strlen:
	move.l (4,%A7),%a0	/* string	*/
	clr.l	%d0
lp:
	addq.l	#1,%d0
	tst.b	(%a0)+
	bne.b	lp
	subq.l	#1,%d0
	rts
