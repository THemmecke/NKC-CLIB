.text
.equ cpu,    4   		/* 68000 (2), 68008(1) */

main:		
		lea meldung(%pc),%a0	/* Meldung ausgeben */
m001:
		move.b (%a0)+,%d0       /* Zeichen holen */
 		beq.s m002            	/* Bei Null ist das Ende erreicht */
 		moveq #33,%d7        	/* Sonst Zeichen ausgeben */
 		trap #1
 		bra.s m001        	/* Wiederholen */
 		
m002:		bra.s m002		/* endlos ... */


meldung: .ascii 	"Hello World !"
	 .byte		0x0a,0x0d,0x00