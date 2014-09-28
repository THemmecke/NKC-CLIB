	.text

	.global fmod

/*	double fmod(double __x, double __y)
*
*	Returns the floating-point remainder of __x/__y (rounded towards zero):
*	fmod = numer - tquot * denom
*
*	Where tquot is the truncated (i.e., rounded towards zero) result of: numer/denom
*
*/

fmod:
	lea.l	(4,%A7),%A0	/* get pointer to parameters */	
	

      	fmove.d	(%a0),%FP0		// __x-> fp0
	fmod.d	(8,%a0),%fp0		// remainder of (fp0 / __y) -> fp0

	
	rts	

