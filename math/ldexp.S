	.text

	.global	ldexp 

/*
	double      ldexp   (double __x, int __exponent);

	Generate value from significand and exponent
	Returns the result of multiplying x (the significand) by 2 raised to the power of exp (the exponent).

	ldexp(x,exp) = x * 2 exp
*/

ldexp:
	lea.l	(4,%A7),%A0	/* get pointer to parameters */

	FTWOTOX.l	(8,%a0),%FP0
	FMUL.d		(%a0),%FP0

	rts
