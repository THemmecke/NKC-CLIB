	.text
	.global	strchr
	
/*
	char * strchr(const char *string, int character);
*/		

strchr:
	move.l	(8,%a7),%d0	/* char	*/
	move.l	(4,%A7),%a0	/* buf	*/
lp:
	tst.b	(%a0)
	beq.b	zerout
	cmp.b	(%a0)+,%d0
	bne	lp
	subq.l  #1,%a0
	rts
zerout:
	movea.l	#0,%a0
	rts
