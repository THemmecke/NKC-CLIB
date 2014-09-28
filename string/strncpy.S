	.text
	.global strncpy

/*
	char * strncpy ( char * destination, const char * source, size_t num )
*/
	
strncpy:
	move.l	(12,%a7),%d1	/* count*/
	move.l	(8,%a7),%a1	/* src	*/
	move.l	(4,%a7),%a0	/* dest	*/
	move.l	%a0,%d0		/* dest	*/
lp:
	move.b	(%a1)+,(%a0)+
	beq.b	pad
	subq	#1,%d1
	bne	lp
quit:
	move.l	%d0,%a0
	rts
pad:
	subq	#1,%d1
	beq.b	quit
	move.b	#0,(%a0)+
	bra	pad
