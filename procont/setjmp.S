	.text
	.global _setjmp,_longjmp

_setjmp:
	lea.l	(4,%A7),%A0
	move.l 	(%a0),%a0
	movem.l	%d1-%d7/%a1-%a7,(%a0)
#ifdef M68000
	move	%sr,%d0
	and.w	#0x00FF,%d0
	move.w	%d0,(59,%a0)
#else
	move	%CCR,(59,%a0)
#endif
	move.l  (%a7),(60,%a0)
	clr.l	%d0
	rts
_longjmp:
	lea.l	(4,%A7),%A0
	move.l	(4,%a0),%d0
	move.l	(%a0),%a0
	movem.l	(%a0),%d1-%d7/%a1-%a7
	addq	#4,%A7
	move.l	(60,%a0),(%a7)
	move	(59,%a0),%CCR
	rts
