	.text
	.global atan

atan:
	fmove.d	(%a0),%FP0
	fmove.d	(8,%a0),%FP1
	clr.l 	%d0
	clr.l	%d1
	ftst.x	%fp0
	fbge	m1
	addq	#1,%d0
m1:
	ftst.x	fp1
	fbge	m2
	addq	#1,%d1
m2:
	fdiv.x	%fp0,%fp1
      	fatan.x	%FP1,%FP0
	fabs.x	%fp0
	tst.b	%d0
	fbeq	testneg
d0ne:
/*	fmovecr.X	#0,%fp1	*/	/* ??? PI ??? */
	fmove.x #0,%fp1
	fsub.x	%fp0,%fp1
	fmove.x	%fp1,%fp0
testneg:
	tst.b	%d1
	beq.b	out
	fneg.x	%fp0
out:
	rts	
