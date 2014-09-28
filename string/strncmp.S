	.text
	.global strncmp

/*
	int strncmp ( const char * str1, const char * str2, size_t num )
*/
	
strncmp:
	move.l 	(12,%a7),%d0	/* size	*/
	beq.b	zerout
	move.l  (8,%a7),%a1	/* buf2	*/
	move.l	(4,%a7),%a0	/* buf1	*/
lp:
	move.b	(%a1)+,%d1
	beq.b	posout
	tst.b	(%a0)
	beq.b	negout
	cmp.b	(%a0)+,%d1
	beq.b	lp2
	bcc.b	negout
	bcs.b	posout
lp2:
	subq	#1,%d0
	bne	lp
zerout:
   	clr.l	%d0
	rts
posout:
	tst.b	(%a0)
	beq	zerout
	clr.l	%d0
	addq	#1,%d0
	rts
negout:
	clr.l	%d0
	subq	#1,%d0
	rts
