	.text

	.global frexp 

/*
	double      frexp   (double __x, int *__exponent);

	Get significand and exponent
	Breaks the floating point number x into its binary significand (a floating point value between 0.5(included) and 1.0(excluded)) and an integral exponent for 2, such that:

	x = significand * 2 exponent
	The exponent is stored in the location pointed by exp, and the significand is the value returned by the function.

	If x is zero, both parts (significand and exponent) are zero.

*/

frexp:
	lea.l	(4,%A7),%A0	/* get pointer to parameters */

	FMOVE.D		(%a0),%fp1  // __x -> fp1
	FGETMAN.x	%FP1,%FP0   // get significant/mantissa -> fp0
	FGETEXP.X	%FP1,%FP2   // get exponent	-> fp2
	move.l		(8,%a0),%a0 // store exponent...
	FMOVE.L		%FP2,(%a0)  // ...
	FDIV.x		#0x400000008000000000000000,%FP0  // i.e fdiv.x #2,fp0 !!
	add.l 		#1,(%a0) 

	rts

