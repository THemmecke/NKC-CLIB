	.text
	.global strrchr
	
/*
	char * strrchr (       char * str, int character )
*/	

strrchr:
	move.l	(8,%a7),%d1	/* char to search for	*/
	move.l	(4,%a7),%a0	/* string		*/
	move.l	%a0,%a1
	clr.l 	%d0
lp1:
	tst.b	(%a0)+
	bne.b	lp1
lp2:
	cmpa.l	%a0,%a1
	beq.b	out
	cmp.b	-(%a0),%d1
	bne.b	lp2
	move.l	%a0,%d0
out:
	move.l  %d0,%a0
	rts
