	.text
	.global strncat
	
/*
	char *strncat(char *dest, const char *src, size_t n)
*/
		
strncat:
	move.l	(12,%a7),%d1	/* dest len	*/
	move.l 	(8,%a7),%a1	/* source	*/
	move.l	(4,%A7),%a0	/* dest		*/
	move.l	%a0,%d0		/* ret vall	*/
lp1:
	tst.b	(%a0)+
	bne	lp1
	subq	#1,%a0
lp2:
	move.b	(%a1),(%a0)+
	subq	#1,%d1
	beq.b	out
	tst.b	(%a1)+
	bne	lp2
	move.l %d0,%a0	
	rts
out:
	clr.b	(%a0)
	move.l %d0,%a0
	rts
