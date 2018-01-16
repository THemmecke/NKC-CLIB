	.text
	.global pow 
/*
	double      pow     (double __x, double __y);

	returns __x ^ __y in fp0

	calculation:

	e^(y*ln(x)) = e^(ln(x^y)) = x^y
*/

pow:

	lea.l	(4,%A7),%A0		/* get pointer to parameters */
	link %fp,#-8			/* local double variable */	

    flogn.d	(%a0),%FP0		/* fp0 = logn(__x) */
	fmul.d	(8,%a0),%FP0	/* fp0 = __y * fp0 */
	fmove.d %fp0,-8(%fp)	/* exp(fp0) directly only in extended mode ! */
	fetox.d	-8(%fp),%fp0	/* fp0 = exp(fp0)  */

	unlk %fp	
	rts	
