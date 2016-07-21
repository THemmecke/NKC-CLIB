/*********************************************
*                                            *
*     BOOTLOADER PART1   (FAT16)             *
*                                            *
* Das ist Teil 1 des Bootloaders, der sich   *
* im MBR befindet			     *
*********************************************/
.text
.equ cpu,    4   		/* 68000 (2), 68008(1) */

.equ target, 0x1d0000 		/* Part2 des Bootloaders nach 1,8MB Laden */


.org 0x0
		
start:  jmp main(%pc)		/* springe zum Bootloader  */
        nop			/* an diesem NOP erkennt */
        nop			/* das GP den Loader */

        
main:				/* Part 1 laed den eigentlichen */
				/* Bootloader aus den folgenden */
				/* Sektoren */
		moveq #20,%d7	/* Bildschirm löschen (GP) */
 		trap #1
 		
		lea meldung(%pc),%a0	/* Meldung ausgeben */
m001:
		move.b (%a0)+,%d0       /* Zeichen holen */
 		beq.s m002            	/* Bei Null ist das Ende erreicht */
 		moveq #33,%d7        	/* Sonst Zeichen ausgeben */
 		trap #1
 		bra.s m001        	/* Wiederholen */
m002:
		
					/* Sektor 1 laden */
		moveq.l #1,%d4		/* select Master IDE */
		moveq.l #1,%d1		/* Sector Read */
		moveq.l #1,%d2		/* Start Sector */
		moveq.l #64,%d3		/* Number of Sectors to read */
		
		movea.l #target,%a0	/* Target Address */
		move.l #155,%d7		/* IDE functions */
		trap #1			/* call GP */
		
		jmp target		/* jmp !! */
		
								
        
mainend:
        rts				/* Ende des Bootloadercodes */
        
/* Texte         */
meldung: .ascii 	"MBR Bootloader (C) 2009 Torsten Hemmecke"
	 .byte		0x0a,0x0d
	 .ascii		"loading bootstrap routine ..."
	 .byte		0x0a,0x0d,0x00
		 


.org 0x01B8				

dsksig:	
		.byte	0,0,0,0			/* Disk Signatur */
		.byte	0,0			/* NULL */
		
parttbl:					/* 0x01BE: Partitionstabelle (4 Einträge maximal) */
part1:			
						/* erster Eintrag:		*/
		.byte	0x80			/* Bootable			*/
						/* CHS erster Sektor:	*/
		.byte	0xFF			/* HEAD			*/
		.byte	0xFF			/* Cyl./Sector		*/
		.byte	0xFF			/* Cylinder		*/
		.byte	0x06			/* Typ: FAT16 > 32MB	*/
						/* CHS letzter Sektor:	*/
		.byte	0xFF			/* HEAD			*/
		.byte	0xFF			/* Cyl./Sector		*/
		.byte	0xFF			/* Cylinder		*/
		.byte	0x42,0x00,0x00,0x00 	/* Startsektor relativ zum Anfang der HD (66) */
		.byte  	0x9E,0x0F,0x3D,0x00	/* Anzahl der Sektoren in der Partition	(4001694) */
part2:
						/* zweiter Eintrag:		*/
		.byte	0x00			/* Bootable			*/
						/* CHS erster Sektor:		*/
		.byte	0x00			/* HEAD				*/
		.byte	0x00			/* Cyl./Sector			*/
		.byte	0x00			/* Cylinder			*/
		.byte	0x00			/* Typ: FAT16 > 32MB		*/
						/* CHS letzter Sektor:		*/
		.byte	0x00			/* HEAD				*/
		.byte	0x00			/* Cyl./Sector			*/
		.byte	0x00			/* Cylinder			*/
		.byte	0x00,0x00,0x00,0x00 	/* Startsektor relativ zum Anfang der HD 	*/
		.byte	0x00,0x00,0x00,0x00	/* Anzahl der Sektoren in der Partition		*/
part3:	
						/* dritter Eintrag:		*/
		.byte	0x00			/* Bootable			*/
						/* CHS erster Sektor:		*/
		.byte	0x00			/* HEAD				*/
		.byte	0x00			/* Cyl./Sector			*/
		.byte	0x00			/* Cylinder			*/
		.byte	0x00			/* Typ: FAT16 > 32MB		*/
						/* CHS letzter Sektor:		*/
		.byte	0x00			/* HEAD				*/
		.byte	0x00			/* Cyl./Sector			*/
		.byte	0x00			/* Cylinder			*/
		.byte	0x00,0x00,0x00,0x00 	/* Startsektor relativ zum Anfang der HD */
		.byte	0x00,0x00,0x00,0x00	/* Anzahl der Sektoren in der Partition	 */
part4:		
						/* vierter Eintrag:		*/
		.byte	0x00			/* Bootable			*/
						/* CHS erster Sektor:		*/
		.byte	0x00			/* HEAD				*/
		.byte	0x00			/* Cyl./Sector			*/
		.byte	0x00			/* Cylinder			*/
		.byte	0x00			/* Typ: FAT16 > 32MB		*/
						/* CHS letzter Sektor:		*/
		.byte	0x00			/* HEAD				*/
		.byte	0x00			/* Cyl./Sector			*/
		.byte	0x00			/* Cylinder			*/
		.byte	0x00,0x00,0x00,0x00 	/* Startsektor relativ zum Anfang der HD */
		.byte	0x00,0x00,0x00,0x00	/* Anzahl der Sektoren in der Partition	 */
		
sig:		.byte	0x55,0xaa			/* MBR Signatur			*/
		 
        
.end

        
        
