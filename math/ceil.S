	.text
	
	.global ceil


/*	double ceil(double t)
*
*	Rückgabe: Rounds t up to the next integer in %fp0, falls FPU
*
*/

ceil:
	lea.l	(4,%A7),%A0	/* get pointer to parameters */

	fmove.d	(%a0),%fp0
	fint.x	%fp0
	//fmovecr.x #0x32 ,%fp1  // move 1.0 from ROM to FP1
	//fadd.x	%fp1,%fp0
	fadd.d #0x3ff0000000000000,%fp0 // add 1.0 to fp0 (gnu-as needs ieee representation !)

	rts	
