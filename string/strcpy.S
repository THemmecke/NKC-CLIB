	.text
	.global strcpy
	
/*
	char strcpy(char *s1, const char *s2)	
*/	

strcpy:
	move.l	(8,%a7),%a1	/* src	*/
	move.l	(4,%A7),%a0	/* dest	*/
	move.l	%a0,%d0		/* dest	*/
lp:
	move.b	(%a1)+,(%a0)+
	bne.b	lp
	move.l	%d0,%a0
	rts
