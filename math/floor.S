	.text
	.global floor


/*	double floor(double t)
*
*	Rückgabe: rundet t auf den nächsten Integer-Wert ab
*
*
*
*/

floor:


	fmove.d	4(%sp),%fp0
	fint.x	%fp0

	rts	
