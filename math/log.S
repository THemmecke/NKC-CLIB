	.text

	.global log


/*	double log(double t)
*
*	Compute natural logarithm
	Returns the natural logarithm of x.

	The natural logarithm is the base-e logarithm: the inverse of the natural exponential function (exp)
*/


log:

      	flogn.d	4(%sp),%FP0

	rts	
