/*********************************************
*                                            *
*     BOOTLOADER STAGE1  (FAT16)             *
*                                            *
* Das ist Teil 1 des Bootloaders, der sich   *
* im MBR befindet		             	     *
*********************************************/
.text
.equ cpu,    4   		/* 68000 (2), 68008(1) */

.equ target, 0x1d0000 		/* Part2 des Bootloaders nach 1,8MB Laden */


.org 0x0
		
start:  jmp main(%pc)		/* springe zum Bootloader  */
        nop					/* an diesem NOP erkennt */
        nop					/* das GP den Loader */

        
main:						/* STAGE1 laed den eigentlichen */
							/* Bootloader (STAGE2) aus den */
							/* folgenden Sektoren */
		moveq #20,%d7		/* Bildschirm löschen (GP) */
 		trap #1
 		
		lea meldung(%pc),%a0	/* Meldung ausgeben */
m001:
		move.b (%a0)+,%d0       /* Zeichen holen */
 		beq.s m002            	/* Bei Null ist das Ende erreicht */
 		moveq #33,%d7        	/* Sonst Zeichen ausgeben */
 		trap #1
 		bra.s m001        		/* Wiederholen */
m002:
		
							/* Sektor 1 laden */
		moveq.l #1,%d4		/* select Master IDE */
		moveq.l #1,%d1		/* Sector Read */
		moveq.l #1,%d2		/* Start Sector */
		moveq.l #64,%d3		/* Number of Sectors to read */
		
		movea.l #target,%a0	/* Target Address */
		move.l #155,%d7		/* IDE functions */
		trap #1				/* call GP */
		
		jmp target			/* jmp !! */
		
								
        
mainend:
        rts					/* Ende des Bootloadercodes */
        
/* Texte         */
meldung: .ascii 	"MBR Bootloader (C) 2018 Torsten Hemmecke"
	 	.byte		0x0a,0x0d
	 	.ascii		"loading stage2 ..."
	 	.byte		0x0a,0x0d,0x00
		 

		 
        
.end

        
        
