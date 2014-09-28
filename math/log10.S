	.text

	.global log10

/*	double log10(double t)
*
*	Compute common logarithm
*	Returns the common (base-10) logarithm of x.
*
*
*/

log10:
	
      	flog10.d	4(%sp),%FP0

	rts	
