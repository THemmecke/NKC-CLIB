	.text

	.global sinh

/*	double sinh(double t)
*
*	Compute hyperbolic sine
	Returns the hyperbolic sine of x radians.
*
*
*/

sinh:

      	fsinh.d	4(%sp),%FP0

	rts	
