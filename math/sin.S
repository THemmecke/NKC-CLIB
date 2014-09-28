	.text

	.global sin

/*	double sin(double t)
*
*	Compute sine
	Returns the sine of an angle of x radians.
*
*
*/

sin:


      	fsin.d	4(%sp),%FP0
	rts	
