/*
	DWORD do_div(PLARGE_INTEGER pli, DWORD base)  
	DWORD div64(PLARGE_INTEGER pli, DWORD base) 
	DWORD div32(DWORD *divident, DWORD base)  	
	div_t       div(int __numer, int __denom);
	ldiv_t      ldiv(long __numer, long __denom);


	typedef struct _LARGE_INTEGER {
		    DWORD HighPart;
		    DWORD LowPart;
	} LARGE_INTEGER, *PLARGE_INTEGER;

	typedef struct {
        	int     quot;
        	int     rem;
	} div_t;

	typedef struct {
        	long    quot;
        	long    rem;
	} ldiv_t;

*/

	.text
	.global div32, div64, do_div, div,ldiv
/*	.global __umoddi3, __udivdi3 müssen noch realisiert werden, oder finden sich in fpgnulib_unstripped.c  */


#ifdef M68020
/*******************************************   Routinen für 68020 **********************************************/
/*

DWORD do_div(PLARGE_INTEGER pli, DWORD base) 
{
			
} 

 DIVU.L  < ea > ,Dr:Dq 64/32 ® 32r – 32q    // Dr:Dq/<ea>   -> Dq = Quotient, Dr=Rest (Division einer 64-bit Zahl in Dr:Dq)
 DIVUL.L < ea > ,Dr:Dq 32/32 ® 32r – 32q    // Dq/<ea>      -> Dq = Quotient, Dr=Rest (Division einer 32-bit Zahl in Dq)

*  Stack bei *1):
*   :
*   :
* +0012                                <- sp=sp* vor dem Sprung ins Unterprogramm
* +0008	base			<- parameter 1 upper 32 bit (0x00001234) fp+12   sp*-4
* +0004	pn			<- parameter 1 Pointer to LONGLONG       fp+ 8   sp*-8
* +0000	Rücksprungadresse
* -0004 	Alter Wert von %fp	<-%fp
* -0008	__rem                                     fp-4
* -0012   __upper                                    fp-8
* -0016   __n.n32[1]                                 fp-12
* -0020   __n.n32[0]		<-%sp         fp-16
*   :
*   :
*
*
*/

div64:
do_div:
	link.w %fp,#-16			// lokalen Stack-Bereich aufbauen
	movem.l %d2,-(%sp)	 	// *1) Register sichern	(%a0.%a1/%d0..%d1 sind scratch register und müssen nicht gesichert werden)

	move.l (8,%fp),%a0		// Zeiger auf li
	move.l (%a0),-16(%fp)    	// __n.n64 = (li)// (part 1)
	move.l 4(%a0),-12(%fp)	  	// __n.n64 = (li)// (part 2)
	move.l -16(%fp),-4(%fp)	 	// if ((__upper = __n.n32[0])) {	
	tst.l -4(%fp)
	jeq .L3				// beq.s wäre der "korrekte" Befehl .... (jeq gibt es eigentlich nicht)	

	move.l  -16(%fp), %d0		// move.l __n.n32[0],%d0
	move.l 	 -4(%fp), %d1		// move.l __upper,%d1
	move.l 	 12(%fp), %d2  		// move.l base,%d2
	
	divul.l %d2,%d1:%d0		// __n.n32[0] / base ==> %d0 = Quotient, %d1 = Rest

	move.l %d0, -16(%fp)		// Ergebnis/Quotient nach __n.n32[0]
	move.l %d1,  -4(%fp)		// Rest nach __upper
	
	.L3:
	
	move.l  -12(%fp), %d0		// move.l __n.n32[1],%d0
	move.l 	 -4(%fp), %d1		// move.l __upper,%d1
	move.l 	 12(%fp), %d2  		// move.l base,%d2

	divu.l %d2,%d1:%d0		// __n.n32[0] / base ==> %d0 = Quotient, %d1 = Rest

	move.l %d0, -12(%fp)		// Ergebnis/Quotient nach __n.n32[1]
	move.l %d1, -8(%fp)		// Rest nach __rem
	/* +++++++++ */


	move.l -16(%fp),(%a0)
	move.l -12(%fp),4(%a0)
	move.l -8(%fp),%d0
	movem.l (%sp)+,%d2		// Register wieder herstellen
	unlk %fp			// lokalen Stack-Bereich freigeben
	rts


//
//
//  Für 68020 konzipiert
// 
//   DWORD div32 ( DWORD *didident32, DWORD divisor32) - Für Aufruf aus C-Funktion
//   _div32 (dident32, divisor32)  
//
//  DIVUL.L < ea > ,Dr:Dq 32/32 ® 32r – 32q    // Dq/<ea>      -> Dq = Quotient, Dr=Rest (Division einer 32-bit Zahl in Dq)
//
//  Rückgabe: D1=Quotient, D0=Rest
//
// Stack *1):
//  Divisor						<-%fp+12
//  *Divident/Divident		    <-%fp+8
//  Rücksprungadresse			<-%fp+4
//  %fp alt						<-%fp,%sp
//

div32:
       link    %fp,#0
                 						// *1)
       movea.l  8(%fp),%A0      			// Divident nach D0
       move.l (%a0),%D0
       move.l  12(%fp),%D1     			// Divisor nach D1

       bsr.s  _div32_0
       move.l %D1,(%A0)                  // Quotient zurückliefern
       unlk  %fp
       rts

_div32:
       link    %fp,#0
                 						// *1)
       move.l  8(%fp),%D1      			// Divident nach D1
       move.l  12(%fp),%D0     			// Divisor nach D0

       bsr.s  _div32_0
       unlk  %fp
       rts

_div32_0:

       divul.l %d0,%d0:%d1		// %d1/%d0  => Q=%d1, R=%d0
       rts

/*
	uint64 __udivdi3(uint64 a, uint64 b)  

	Return a / b


__udivdi3:
	rts
*/


/*
	uint64 __umoddi3(uint64 a, uint64 b)  

	


__umoddi3:
	rts

*/

#endif


#ifdef M68000
/*******************************************   Routinen für 68000 **********************************************/

//  Für 68000 konzipiert
//
//  DWORD do_div_(PLARGE_INTEGER pli, DWORD base)
//
//
//   DIVU.L  < ea > ,Dr:Dq 64/32 Â® 32r â€“ 32q    // Dr:Dq/<ea>   -> Dq = Quotient, Dr=Rest (Division einer 64-bit Zahl in Dr:Dq)
//   DIVUL.L < ea > ,Dr:Dq 32/32 Â® 32r â€“ 32q    // Dq/<ea>      -> Dq = Quotient, Dr=Rest (Division einer 32-bit Zahl in Dq)
//
//
//  Stack bei *1):
//   :
//   :
// +0012                 <- sp=sp* vor dem Sprung ins Unterprogramm
// +0008	base			<- parameter 1 upper 32 bit (0x00001234) fp+12   sp*-4
// +0004	pn				<- parameter 1 Pointer to LONGLONG       fp+ 8   sp*-8
// +0000	Rücksprungadresse
// -0004 	Alter Wert von 	%fp	<-%fp
// -0008	  __rem                                      fp-4
// -0012   __upper                                    fp-8
// -0010              __n.n16[3]                      fp-10
// -0016   __n.n32[1] __n.n16[2]                      fp-12
// -0018              __n.n16[1]						 fp-14
// -0020   __n.n32[0] __n.n16[0]		   <-%sp         fp-16
//   :
//   :
//
//

div64:
do_div:
	link.w %fp,#-16	      // lokalen Stack-Bereich aufbauen
	movem.l %a0/%d1-%d3,-(%sp)	 	     // Register sichern      *1)

    	move.l (8,%fp),%a0                // Zeiger auf LONGLONG nach a0
	move.l (%a0),-16(%fp)    	      	// __n.n32[0]
	move.l 4(%a0),-12(%fp)	  	    // __n.n32[1]
	clr.l %d0

	// Step 1:			// Im ersten Step können bereits die oberen 32Bit des Divisors bearbeitet werden,
					// da noch kein Rest aus einer vorhergehenden Division berücksichtigt werden muss.

	move.l 12(%fp),-(%sp)				// Divisor auf den Stack
	move.l -16(%fp),%d0				// Divident auf den Stack
	move.l %d0,-(%sp)
	bsr.s _div32					// D1=Q1, D0=Rest
	addq.l  #8,%sp					// Stackpointer korrigieren
	move.l %d1,-16(%fp)				// Q1 zurück

//	// Step 2:
//
//	move.l 12(%fp),-(%sp)				// Divisor auf den Stack
//	swap.l %d0
//	move.w -14(%fp),%d0				// Divident auf den Stack
//	move.l %d0,-(%sp)
//	bsr.s __div32					// D1=Q2, D0=Rest
//	addq.l  #8,%sp					// Stackpointer korrigieren
//	move.w %d1,-14(%fp)				// Q2 zurück

	// Step 3:

	move.l 12(%fp),-(%sp)				// Divisor auf den Stack
	swap %d0
	move.w -12(%fp),%d0				// Divident auf den Stack
	move.l %d0,-(%sp)
	bsr.s _div32					// D1=Q3, D0=Rest
	addq.l  #8,%sp					// Stackpointer korrigieren
	move.w %d1,-12(%fp)				// Q3 zurück

	// Step 4:

	move.l 12(%fp),-(%sp)				// Divisor auf den Stack
	swap %d0
	move.w -10(%fp),%d0				// Divident auf den Stack
	move.l %d0,-(%sp)
	bsr.s _div32					// D1=Quotient, D0=Rest
	addq.l  #8,%sp					// Stackpointer korrigieren
	move.w %d1,-10(%fp)				// Q4 zurück

	// Ergebnis zurückliefern

	move.l -16(%fp),(%a0)		// Ergebnis zurück nach n
	move.l -12(%fp),4(%a0)
			// Rest in %d0

	movem.l (%sp)+,%a0/%d1-%d3	// Register wieder herstellen
	unlk %fp			// lokalen Stack-Bereich freigeben
	rts


//
//
//  Für 68000 konzipiert
// 
//   DWORD div32 ( DWORD *didident32, DWORD divisor32) - Für Aufruf aus C-Funktion
//   _div32 (dident32, divisor32)  - Für Aufruf aus ASM (_div64_)
//
//  Rückgabe: D1=Quotient, D0=Rest
//
// Stack *1):
//  Divisor						<-%fp+12
//  *Divident/Divident		    <-%fp+8
//  Rücksprungadresse			<-%fp+4
//  %fp alt						<-%fp,%sp
//
div32:
       link    %fp,#0
                 						// *1)
       movea.l  8(%fp),%A0      			// Divident nach D0
       move.l (%a0),%D0
       move.l  12(%fp),%D1     			// Divisor nach D1

       bsr.s  _div32_0
       move.l %D1,(%A0)                  // Quotient zurückliefern
       unlk  %fp
       rts

_div32:
       link    %fp,#0
                 						// *1)
       move.l  8(%fp),%D0      			// Divident nach D0
       move.l  12(%fp),%D1     			// Divisor nach D1

       bsr.s  _div32_0
       unlk  %fp
       rts

_div32_0:

       cmpi.l  #0xFFFF,%D1     		// D1-$ffff: wenn  D1 > 16bit => Carry/Zero Flag gesetzt

       bhi.s   _div32_2       		// Divident D1>$ffff ? ja, verzweige nach _div32_2
       								// nein, weiter
       cmpi.l  #0xFFFF,%D0     		// D0-$ffff: wenn D0 > 16bit => Carry/Zero Flag gesetzt

       bhi.s   _div32_1       		// Divisor D0>$ffff ? ja, verzweige nach _div32_1
       								// nein, dann weiter

       								// hier sind D1 und D0 16 Bit gross und können direkt
       								// dividiert werden....
       divu    %D1,%D0         		// D0 = D0 / D1  => D0 = [Rest|Quotient]
       move.l  %D0,%D1         		// D1 = D0
       clr.w   %D0            		// lösche Quotient
       swap    %D0            		// Rest nach D0
       andi.l  #0xFFFF,%D1     		// Quotient nach D1
       rts


_div32_1:                     		// Divident D0 ist 16 Bit, Divisor D1 32 Bit gross
       movem.l %D0/%D2,-(%sp)   		// Register sichern
       clr.w   %D0            		// HiWord des Dividenten nach D0 ...
       swap    %D0            		// ...
       divu    %D1,%D0         		// D0 = D0/D1  (Division des HiWords des Divisors)   => D0 = [HiRest|HiQuotient]
       move.w  %D0,%D2         		// => D2 = HiQuotient
       addq    #2,%sp                   // Stack korrigieren
       move.w  (%sp)+,%D0      		// LowWord des Dividenten nach D0.w => D0 = [HiRest|LowDivisor]
       divu    %D1,%D0         		// D0 = D0/D1  (Division HiRest|LowDivisor)   => D0 = [LowRest|LowQuotient]
       clr.l   %D1                      // D1 löschen
       move.w  %D0,%D1         		// LowQuotient nach D1
       swap    %D2					// D2 = [HiQuotient|0]
       move.w  %D1,%D2         		// LoQuotient.w nach D2 => D2 = [HiQuotient|LowQuotient]
       move.l  %d2,%d1				// Quotient Zurückliefern
       clr.w   %d0					// LowQuotient in d0 löschen
       swap    %d0					// Rest in d0
       movem.l  (%sp)+,%D2      		// Register wieder herstellen
       rts                   		// Rücksprung





       								// Hier folgt ein "böser" Algorithmus ...
_div32_2:							// Divisor D1 ist 32 Bit gross, Divident D0 ist 16 oder 32 Bit gross
       movem.l %D2/%D3/%D4,-(%sp)		// Register D2..D4 sichern
       move.l  %D1,%D2         		// Divisor nach D2
       clr.w   %D2            		// D2 = HiDivisor ...
       swap    %D2            		// ...
       addq.l  #1,%D2         		// D2 = HiDivisor + 1
       move.l  %D0,%D3         		// Divident nach D3
       move.l  %D1,%D4         		// Divisor nach D4
       move.l  %D2,%D1         		// HiDivisor+1 nach D1
       bsr.s   _div32_1       		// (HiDivisor+1) / Divident  =>  D0=Q1,  D1=R1
       move.l  %D4,%D1         		// Divisor nach D1
       divu    %D2,%D1         		// D1 = D1/D2 i.e. Divisor/(HiDivisor+1)
       divu    %D1,%D0         		// D0 = D0/D1
       andi.l  #0xFFFF,%D0     		// lösche Rest der leten Division

_div32_3:
       move.l  %D4,%D1         		// Divisor nach D1
       move.l  %D4,%D2         		// Divisor nach D2
       swap    %D2            		//
       mulu    %D0,%D1
       mulu    %D0,%D2
       swap    %D2
       add.l   %D2,%D1
       sub.l   %D3,%D1
       bhi.s   _div32_4
       neg.l   %D1
       cmp.l   %D1,%D4
       bhi.s   _div32_5
       addq.l  #1,%D0
       bra.s   _div32_3
_div32_4:
       subq.l  #1,%D0
       bra.s   _div32_3
_div32_5:
       move.l  %d0,%d2				// Quotient Zurückliefern
       move.l  %d1,%d0				// Rest nach d0
       move.l  %d2,%d1				// Quotient nach D1
       movem.l (%sp)+,%D2/%D3/%	D4		// Register wieder herstellen
       rts                   		// Rücksprung


/*
	uint64 __udivdi3(uint64 a, uint64 b)  

	Return a / b


__udivdi3:
	rts

*/

/*
	uint64 __umoddi3(uint64 a, uint64 b)  

	


__umoddi3:
	rts

*/
#endif


/*
	div_t       div(int __numer, int __denom);
	ldiv_t      ldiv(long __numer, long __denom);
	
	(__numer / __denom = div_t)
	
	typedef struct {
        	int     quot;
        	int     rem;
	} div_t;

	typedef struct {
        	long    quot;
        	long    rem;
	} ldiv_t;


	Aufruf für ldiv und div:

	link.w %fp,#-24
  	move.l -8(%fp),-(%sp)		// larg2 __denom
  	move.l -4(%fp),-(%sp)		// larg1 __numer
  	jsr ldiv
  	addq.l #8,%sp
  	move.l %d0,-24(%fp)		// ldiv.quot
  	move.l %d1,-20(%fp)		// ldiv.rem

  	unlk %fp
*/
div:
ldiv:
	lea.l	(4,%A7),%A0	/* get pointer to parameters */

	move.l	(4,%a0),-(%A7)	/* arg2 __denom 	*/
	move.l	(%a0),-(%A7)   	/* arg1 __numer 	*/

	bsr	_div32		/* call div32 		*/	

	add.l #8,%sp		/* Stack aufräumen 	*/

	move.l %d0,-(%sp)	/* Quotient -> D0 ! 	*/
	move.l %d1,-(%sp)	/* Rest -> D1 ! 	*/
	move.l (%sp)+,%d0	/* swap d0<->d1 	*/
	move.l (%sp)+,%d1
	

	rts
