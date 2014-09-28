	.text

	.global modf 
/*

	double modf (double x, double* intpart);

	Break into fractional and integral parts
	Breaks x into an integral and a fractional part.

	The integer part is stored in the object pointed by intpart, and the fractional part is returned by the function.

	Both parts have the same sign as x.

*/

modf:
	lea.l	(4,%A7),%A0	/* get pointer to parameters */


	FINTRZ.d	(%a0),%FP1
	fmove.d		(%a0),%FP0
	fsub.x		%FP1,%FP0
	move.l		(8,%a0),%a0
	fmove.d		%fp1,(%a0)

	rts
