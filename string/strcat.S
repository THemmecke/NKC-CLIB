	.text
	.global strcat
	
/*
	char *strcat(char *dest, const char *src)
*/		

strcat:
	move.l 	(8,%a7),%a1	/* source	*/
	move.l	(4,%a7),%a0	/* dest		*/
	move.l	%a0,%d0		/* ret vall	*/
lp1:
	tst.b	(%a0)+
	bne	lp1
	subq.l	#1,%a0
lp2:
	move.b	(%a1)+,(%a0)+
	bne	lp2
	move %d0,%a0
	rts
