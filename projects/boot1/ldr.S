.text

#include "ldr.global"
 /* CO2SER */


 /*      BOOTLOADER PART2   (FAT16)            * */

 /*  Das ist Teil 2 des Bootloaders,der sich	* */
 /*  ab Sector 1 befindet  					* */



 /*  0x00.0000 - 0x0f.ffff 0-1MB */
 /*  0x10.0000 - 0x1f.ffff 1-2MB */

 /*  0x20.0000 - 0x2f.ffff 2-3MB */
 /*  0x30.0000 - 0x3f.ffff 3-4MB */

    .equ cpu            , 4   /*  68000 (2),68008(1) */
    .equ target		, 0x600 /*  in den 2ten MB Block (ROM-Kernel) */
 /* target			equ 0x400 * (RAM-Kernel, crt0_ram.S muss dann das ROMFS verschieben und BSS Segment löschen) */

 /*  Speicherbereiche EQU */

  .org  0x0

start:  						 /*  Part 2 laed das os image */
	 /* bsr cls                 * Bildschirm lüschen */
		lea meldung(%pc),%a0	 /*  Meldung ausgeben */
m001:  
		move.b (%A0)+,%D0        /*  Zeichen holen */
 		jeq m002             /*  Bei Null ist das Ende erreicht */
 		move.l #33,%D7         /*  Sonst Zeichen ausgeben */
 		trap #1
 		jra m001        	 /*  Wiederholen */
m002:  

		jbsr mtools			 /*  load mtools */

		lea fname(%pc),%a0	 /*  Dateiname nach %a0 */
		movea.l #target,%a1	 /*  Zieladresse nach %a1 */
		move #5,%d7			 /*  function mload */
		jbsr trap10			 /*  let mtools do the work */

		cmp #-1,%d0 			/*  */
		beq mainerr0 			/* if (d0 == -1) ==> error */

		jmp target			/*  else jmp !! */



mainend:  
        rts					 /*  Ende des Bootloadercodes */

mainerr0: 	move #2,%d7			 /*  function mdir */
			jbsr trap10			 /*  call mtools */
			lea txtcrlf(%pc),%a0 /*  CRLF */
 			jbsr writetxt
			move #1,%d7			 /*  function mdisk */
			jbsr trap10			 /*  call mtools */

mainerr:  bra mainerr 			/* infinite loop */

 /* *************** Unterprogramme aus MTOOLS ********************** */


 /*                MTOOLS                  * */

 /*    die Tools fýrs FAT16 Dateisystem    * */

 /*             von Jens Mewes             * */

 /*          V 0.9A : 2008.08.27           * */




mtools:  
 movem.l %d0-%d7/%a0-%fp,-(%sp)
 /* bsr cls                                * Bildschirm lüschen */
 lea allgm(%pc),%a4                      /*  Index fýr relativen Zugriff */
 /* lea trap10(%pc),%a0                     * Trap #10 initialisieren */
 /* move.l %a0,0xA8 */
 jbsr ClrVars                            /*  Variablen lüschen */
 /*  move #!getvers,%d7 */
 move #97,%d7
 trap #1
 cmp.l #0x710,%d0
 jge lp00
 move.l #29,errnum(%a4)
 jbsr error
 jra Exit
lp00:  
 move.l #4-1,%d3                         /*  4 Harddisks untersuchen */
 move.l #1,%d1                         /*  mit IDE-Master beginnen */
 clr.l %d2
lp01:  
 addq #1,%d1
 move %d1,%d0
 jbsr SetLW
 jbsr GetDrive                           /*  Laufwerksdaten laden */
 tst.l %d0                               /*  alles OK? */
 jne lp02                             /*  nein */
 move.l #1,%d2                           /*  als Merker dass was gefunden */
 move.b #0x06,%d0                        /*  FAT16 Type 06 */
 jbsr FSChk                              /*  Dateisystem suchen */
 move.b #0x04,%d0                        /*  FAT16 Type 04 */
 jbsr FSChk                              /*  und suchen */
 jra lp03
lp02:  
 cmp.l #-2,%d0                          /*  "nur" fehlerhafter MBR */
 jeq lp03
 cmp #2,%d1
 jne lp03                             /*  kein Fehler bei IDE-Master */
 addq #1,%d1
 subq #1,%d3                            /*  ansonsten IDE-Slave ýbergehen */
lp03:  
 dbra %d3,lp01
 tst %d2
 jne lp04                             /*  es wurde min. ein LW gefunden */
 move.l #1,errnum(%a4)
 jbsr error
 jra Exit
lp04:  
 tst.l hdbtfild(%a4)
 jne lp05
 move.l #2,errnum(%a4)
 jbsr error
 jra Exit
lp05:  
 jbsr ALW                                /*  aktives LW setzen */
 lea txtinit(%pc),%a0                    /*  freundliche Meldung */
 jbsr writetxt
Exit:  
 movem.l (%sp)+,%d0-%d7/%a0-%fp
 rts


ClrVars:  
 lea VarStart(%pc),%a0
 move.l #VarEnd-VarStart-1,%d3          /*  Alle Variablen und Puffer */
cb01:  
 clr.b (%a0)+
 dbra %d3,cb01
rts


SetLW:                                    /*  Laufwerk einstellen %d0=Nummer */
 and.l #0xff,%d0                         /*  nur Byte gýltig */
 move.b %d0,hdnum(%a4)                   /*  akt. Laufwerknummer setzen */
 subq.l #2,%d0                          /*  -2 da keine Floppys */
 mulu #hdoff,%d0                        /*  *Offset fýr LW-Speicher */
 lea hddat(%pc),%fp                      /*  Laufwerksspeicher laden */
 adda.l %d0,%fp                          /*  auf richtigen Bereich */
 rts


GetDrive:                                 /*  Laufwerksdaten laden */
 movem.l %d1-%d2/%a0,-(%sp)
 jbsr Ident                              /*  LW identifizieren/initialisieren */
 tst.l %d0
 jmi GDerr
 clr.l %d0
 lea buffer(%pc),%a0
 jbsr ReadSec                            /*  MBR lesen */
 tst.l %d0
 jmi GDerr
 cmp #0x55aa,-2(%a0)                     /*  %a0 steht "hinter" den Daten */
 jne GDerr2                             /*  MBR nicht gýltig */

 lea buffer(%pc),%a0
 move.b partoff1+typoff(%a0),typ1(%fp)   /*  Partitionsdaten speichern */
 move.l partoff1+startoff(%a0),%d0
 jbsr LBHLW
 move.l %d0,starts1(%fp)
 move.l partoff1+sizeoff(%a0),%d0
 jbsr LBHLW
 move.l %d0,groesse1(%fp)

 move.b partoff2+typoff(%a0),typ2(%fp)
 move.l partoff2+startoff(%a0),%d0
 jbsr LBHLW
 move.l %d0,starts2(%fp)
 move.l partoff2+sizeoff(%a0),%d0
 jbsr LBHLW
 move.l %d0,groesse2(%fp)

 move.b partoff3+typoff(%a0),typ3(%fp)
 move.l partoff3+startoff(%a0),%d0
 jbsr LBHLW
 move.l %d0,starts3(%fp)
 move.l partoff3+sizeoff(%a0),%d0
 jbsr LBHLW
 move.l %d0,groesse3(%fp)

 move.b partoff4+typoff(%a0),typ4(%fp)
 move.l partoff4+startoff(%a0),%d0
 jbsr LBHLW
 move.l %d0,starts4(%fp)
 move.l partoff4+sizeoff(%a0),%d0
 jbsr LBHLW
 move.l %d0,groesse4(%fp)

 clr.l %d0
 jra GDex
GDerr2:  
 move.l #-2,%d0
 jra GDex
GDerr:  
 move.l #-1,%d0
GDex:  
 movem.l (%sp)+,%d1-%d2/%a0
 rts


Ident:                            /*  Identifiziert ein Laufwerk */
 movem.l %d3/%d4/%a0/%a1,-(%sp)
 move.b hdnum(%a4),%d4
 sub.b #1,%d4                           /*  LW-Nr -1 (1 und 2 = IDE) */
 cmp.b #3,%d4
 jge idlp01                           /*  LW-Nr > 2 dann SD */
 jbsr idetest
 jcs idlp20                           /*  Laufwerk nicht gefunden */
 jra idlp02                           /*  sonst weiter */
idlp01:  
 sub.b #2,%d4                           /*  LW-Nr -2 (1 und 2 = SD) */
 cmp.b #3,%d4
 jge idlp20                           /*  LW-Nr > 2 dann Fehler */
 jbsr sdtest
 jcs idlp20                           /*  Laufwerk nicht gefunden */
idlp02:  
 movea.l %fp,%a1
 adda.l #Diskname,%a1
 adda.l #hdname,%a0
 move #12-1,%d3
idlp10:  
 move.b (%a0)+,(%a1)+
 dbra %d3,idlp10
 move #0x0,(%a1)+
 clr.l %d0
 jra idex
idlp20:  
 move.l #-1,%d0
idex:  
 movem.l (%sp)+,%d3/%d4/%a0/%a1
 rts


ReadSec:                  /*  liest einen Sektor %D0=Sektornummer,%A0=Puffer */
 movem.l %d1-%d4/%d7,-(%sp)
 move.l #1,%d1                         /*  Read-Befehl */
 move.l %d0,%d2                          /*  Sektornummer */
 move.l #1,%d3                         /*  einen Sektor */
 clr.l errnum(%a4)
 move.b hdnum(%a4),%d4
 sub.b #1,%d4                           /*  LW-Nr - 1 (1 und 2 = IDE) */
 cmp.b #3,%d4
 jge RdSlp01                          /*  LW-Nr > 3 dann SD */
 jbsr idedisk                            /*  Sektor lesen aufrufen */
 jcs RdSerr                           /*  Lesefehler */
 jra RdSlp20                          /*  sonst fertig */
RdSlp01:  
 sub.b #2,%d4                           /*  LW-Nr -2 (1 und 2 = SD) */
 cmp.b #3,%d4
 jge RdSerr1                          /*  LW-Nr > 3 dann Fehler */
 jbsr sddisk                             /*  Sektor lesen aufrufen */
 jcs RdSerr                           /*  Lesefehler */
 jra RdSlp20                          /*  sonst fertig */
RdSerr:  
 move.l #5,errnum(%a4)
RdSerr1:  
 move.l #-1,%d0
 jra RdSex
RdSlp20:  
 adda.l #512,%a0                        /*  %a0 bereit fýr nûchsten Sektor */
 clr.l %d0
RdSex:  
 movem.l (%sp)+,%d1-%d4/%d7
 rts


WriteSec:                 /*  schreibt einen Sektor %D0=Sektornummer,%A0=Puffer */

 movem.l %d1-%d4/%d7,-(%sp)
 move.l #2,%d1                         /*  Write-Befehl */
 move.l %d0,%d2                          /*  Sektornummer */
 move.l #1,%d3                         /*  einen Sektor */
 clr.l errnum(%a4)
 move.b hdnum(%a4),%d4
 sub.b #1,%d4                           /*  LW-Nr -1 (1 und 2 = IDE) */
 cmp.b #3,%d4
 jge WrSlp01                          /*  LW-Nr > 2 dann SD */
 jbsr idedisk                            /*  Sektor lesen aufrufen */
 jcs WrSerr                           /*  Lesefehler */
 jra WrSlp20                          /*  sonst fertig */
WrSlp01:  
 sub.b #2,%d4                           /*  LW-Nr - 2 (1 und 2 = SD) */
 cmp.b #3,%d4
 jge WrSerr1                          /*  LW-Nr > 2 dann Fehler */
 jbsr sddisk                             /*  Sektor lesen aufrufen */
 jcs WrSerr                           /*  Lesefehler */
 jra WrSlp20                          /*  sonst fertig */
WrSerr:  
 move.l #6,errnum(%a4)
WrSerr1:  
 move.l #-1,%d0
 jra WrSex
WrSlp20:  
 adda.l #512,%a0                        /*  %a0 bereit fýr nûchsten Sektor */
 clr.l %d0
WrSex:  
 movem.l (%sp)+,%d1-%d4/%d7
 rts


LBHLW:                            /*  dreht die Bytes in %d0.l */
 jbsr LowBHigh
 swap %d0

LowBHigh:                         /*  dreht die Bytes in %d0.w */
 ror #8,%d0
 rts


FSChk:                            /*  Prýft ob FS-Typ %d0 entspricht,legt das */
                                /*  Ergebnis in hdbtfild ab */
 movem.l %d0-%d1/%d6,-(%sp)
 move %d0,%d1                            /*  FS-Typ (0x06 oder 0x04 fýr FAT16) */
 move.b hdnum(%a4),%d0                   /*  Laufwerksnummer */
 and.l #0xff,%d0                         /*  nur Byte */
 subq.l #2,%d0                          /*  HD-Nr auf 0..n */
 jmi FSC10                            /*  keine Floppy */
 asl.l #2,%d0                           /*  *4 da max 4 Partitionen */
 addq #2,%d0                            /*  +2 fýr Position in Bitfield */
 clr.l %d6                               /*  als Bitfeld Merker */
 cmp.b typ1(%fp),%d1                     /*  Vergleich ob FS-Typ stimmt */
 jne FSC01
 bset.l %d0,%d6
FSC01:  
 addq #1,%d0
 cmp.b typ2(%fp),%d1
 jne FSC02
 bset.l %d0,%d6
FSC02:  
 addq #1,%d0
 cmp.b typ3(%fp),%d1
 jne FSC03
 bset.l %d0,%d6
FSC03:  
 addq #1,%d0
 cmp.b typ4(%fp),%d1
 jne FSC10
 bset.l %d0,%d6
FSC10:  
 or.l %d6,hdbtfild(%a4)
 movem.l (%sp)+,%d0-%d1/%d6
 rts


ALW:  
 movem.l %d0/%d3/%d6,-(%sp)
 clr aktlw(%a4)
 move.l hdbtfild(%a4),%d6
 asr.l #2,%d6                           /*  FD0 und FD1 nicht checken */
 move #1,%d0                            /*  erst mit HDA1 anfangen */
 move #16-1,%d3                         /*  HDA1 bis SDB4 */
ALW01:                                    /*  aktives LW ermitteln */
 addq #1,%d0
 asr.l #1,%d6
 jcs ALW10
 dbra %d3,ALW01
ALW10:  
 move %d0,aktlw(%a4)
 jbsr LoadLW
ALW11:  
 movem.l (%sp)+,%d0/%d3/%d6
 rts


LoadLW:                           /*  Liest die LW- (Parttitions-) Daten */
 movem.l %d1/%a0,-(%sp)
 move aktlw(%a4),%d0
 and.l #0xff,%d0                 /*  nur Byte gýltig */
 subq #2,%d0                    /*  LW-Nummer - 2 */
 jmi LLWErr                     /*  Disketten Laufwerke nicht unterstýtzt */
 cmp.b #16,%d0
 jge LLWErr                     /*  Reserve Laufwerke */
 divu #4,%d0                    /*  /4 */
 move.l %d0,%d1                  /*  Rest in %d1 als Partitionszûhler */
 swap %d1                        /*  im unteren Wort */
 addq #2,%d0                    /*  +2 dann HD-Nummer */
 jbsr SetLW
 cmp.b #0,%d1
 jne LLW00
 move.l starts1(%fp),%d0
 jra LLW20
LLW00:  
 cmp.b #1,%d1
 jne LLW01
 move.l starts2(%fp),%d0
 jra LLW20
LLW01:  
 cmp.b #2,%d1
 jne LLW02
 move.l starts3(%fp),%d0
 jra LLW20
LLW02:  
 cmp.b #3,%d1
 jne LLWErr
 move.l starts4(%fp),%d0
 jra LLW20
 lea buffer(%pc),%a0
LLW20:  
 jbsr LoadBPB
 tst.l %d0
 jmi LLWErr
 lea txtroot(%pc),%a0
 move.b (%a0)+,NoAD(%fp)
 move.b (%a0),NoAD+1(%fp)
LLWOK:  
 clr.l %d0
 jra LLWExit
LLWErr:  
 move.l #-1,%d0
LLWExit:  
 movem.l (%sp)+,%d1/%a0
 rts


LoadBPB:                          /*  Liest die BPB Daten ein %D0=Partitions-Offset */
 movem.l %d1-%d2/%a0,-(%sp)
 move.l %d0,%d2                          /*  sichern */
 lea buffer(%pc),%a0
 jbsr ReadSec                            /*  Boot-Sektor lesen */
 tst.l %d0
 jmi LdBPBerr
 lea buffer(%pc),%a0

 adda.l #0xB,%a0                         /*  BPS Offset */
 move.b (%a0)+,BPS+1(%fp)                /*  Bytes pro Sektor (immer 512!!!) */
 move.b (%a0)+,BPS(%fp)

 move.b (%a0)+,SPC(%fp)                  /*  Sektoren pro Cluster */

 move.b (%a0)+,RSC+1(%fp)                /*  Anzah der reservierten Sektoren */
 move.b (%a0)+,RSC(%fp)

 move.b (%a0)+,numFATs(%fp)              /*  Anzahl der FATs */

 move.b (%a0)+,REC+1(%fp)                /*  Anzahl der eintrûge im Root-DIR */
 move.b (%a0)+,REC(%fp)

 move.b (%a0)+,TotSec16+1(%fp)           /*  Anzahl der Sektoren (bei 16 Bit) */
 move.b (%a0),TotSec16(%fp)

 adda.l #2,%a0
 move.b (%a0)+,FATSz+1(%fp)              /*  Grüsse der FAT in Sektoren */
 move.b (%a0)+,FATSz(%fp)

 adda.l #8,%a0
 move.l (%a0),%d0
 jbsr LBHLW
 move.l %d0,TotSec32(%fp)                /*  Anzahl der Sektoren (bei 32 Bit) */

 clr.l %d0
 move REC(%fp),%d0                       /*  Anzahl der DIR Eintrûge */
 asl.l #5,%d0                           /*  *32 (Grüsse eines Eintrags in Byte) */
 add.l #511,%d0                         /*  +BPS-1 */
 asr.l #8,%d0
 asr.l #1,%d0                           /*  /512 (BPS) */
 move.l %d0,RtDrSec(%fp)                 /*  Anzahl der Root-DIR Sektoren */

 move.l %d2,%d0                          /*  Partitions-Offset (Boot-Offset) */
 clr.l %d1
 move RSC(%fp),%d1                       /*  Anzahl der reservierten Sektoren */
 add.l %d1,%d0                           /*  +Boot-Offset */
 move.l %d0,FATFrst(%fp)                 /*  =Erster FAT Sektor */

 clr.l %d2
 move.b numFATs(%fp),%d2                 /*  Anzahl der FATs */
 move FATSz(%fp),%d1                     /*  Grüsse der FATs in Sektoren */
 mulu %d2,%d1
 add.l %d1,%d0                           /*  +Ersten FAT-Sektor */
 move.l %d0,RootFrst(%fp)                /*  =Erster Root-DIR Sektor */

 clr.l %d2
 move.l RtDrSec(%fp),%d2                 /*  Anzahl der Root-DIR Sektoren */
 add.l %d2,%d0                           /*  +Erstem Root-DIR Sektor */
 move.l %d0,DataFrst(%fp)                /*  =Erster Daten-Sektor */

 tst TotSec16(%fp)               /*  falls Anzahl 16 Bit Sektoren=0 dann 32 Bit */
 jeq LBPB01
 move TotSec16(%fp),TotSec(%fp)          /*  sonst 16 Bit */
 jra LBPB02
LBPB01:  
 move.l TotSec32(%fp),TotSec(%fp)
LBPB02:  

 clr.l %d0
 move RSC(%fp),%d0
 add.l %d0,%d1                           /*  %D1=FATSz+RSC */
 move.l RtDrSec(%fp),%d0
 add.l %d0,%d1                           /*  %D1=FATSz+RSC+RtDrSec */
 move.l TotSec(%fp),%d0
 sub.l %d1,%d0                           /*  %D0=TotSec-FATSz+RSC+RtDrSec=DataSec */
 move.l %d0,DataSec(%fp)                 /*  Anzahl der Daten-Sektoren */

 clr.l %d1
 move.b SPC(%fp),%d1
 divu %d1,%d0                            /*  %D0=TotSec/SPC=CntClust */
 and.l #0x000FFFF,%d0
 move.l %d0,CntClust(%fp)                /*  Anzahl der Cluster */
 addq.l #2,%d0
 move.l %d0,lastClus(%fp)                /*  CntClust+2=lastClus */

 move.l #0xFFF8,eoClusCh(%fp)            /*  nur bei FAT16!!! */

 clr.l %d0
 move.b SPC(%fp),%d0                     /*  Sektoren pro Cluster */
 move BPS(%fp),%d1                       /*  Bytes pro Sektor */
 mulu %d1,%d0
 move.l %d0,BPC(%fp)                     /*  BytesPerCluster */

 move.l FATFrst(%fp),%d0                 /*  Laden des ersten FAT-Sektors */
 move.l %d0,FATCurr(%fp)
 lea fatbuff(%pc),%a0
 jbsr ReadSec
 tst.l %d0
 jmi LdBPBerr
 clr.b FATStat(%a4)
 clr.l FrstDIRC(%fp)                     /*  Erster DIR-Cluster = 0 (Root-DIR) */
 clr.l %d0
 jra LdBPBex
LdBPBerr:  
 move.l #-1,%d0
LdBPBex:  
 movem.l (%sp)+,%d1-%d2/%a0
 rts



 /* *****  FAT Teil  ****** */

UpFATBu:                          /*  Update FAT Buffer %d0=newsektor */
 movem.l %d1/%a0,-(%sp)
 cmp.l FATCurr(%fp),%d0
 jne UFB01
 clr.l %d0
 jra UFBex
UFB01:  
 move.l %d0,%d1                          /*  sichern */
 tst.b FATStat(%a4)
 jeq UFB02
 move.l FATCurr(%fp),%d0
 lea fatbuff(%pc),%a0
 jbsr WriteSec
 tst.l %d0
 jmi UFBerr                           /*  Schreibfehler */
UFB02:  
 move.l %d1,%d0
 lea fatbuff(%pc),%a0
 jbsr ReadSec
 tst.l %d0
 jmi UFBerr                           /*  Lesefehler */
 move.l %d1,FATCurr(%fp)
 clr.b FATStat(%a4)
 clr.l %d0
 jra UFBex
UFBerr:  
 move.l #-1,%d0
UFBex:  
 movem.l (%sp)+,%d1/%a0
 rts

FFAT:                             /*  Flush FAT Buffer */
 movem.l %a0,-(%sp)
 move.l FATCurr(%fp),%d0
 lea fatbuff(%pc),%a0
 jbsr WriteSec
 tst.l %d0
 jmi FFATerr                          /*  Schreibfehler */
 clr.b FATStat(%a4)
 clr.l %d0
 jra FFATex
FFATerr:  
 move.l #-1,%d0
FFATex:  
 movem.l (%sp)+,%a0
 rts

GNCN:                             /*  GetNextClusterNumber %d0=Clusternummer */
 movem.l %d1-%d2/%a0,-(%sp)
 and.l #0xffff,%d0                       /*  auf Wort */
 cmp.l lastClus(%fp),%d0
 jgt GNCNerr1                           /*  Disk voll */
 move.l %d0,%d2                          /*  sichern */
 lsr.l #8,%d0                           /*  *2 / 512 (BPS) */
 add.l FATFrst(%fp),%d0
 jbsr UpFATBu
 tst.l %d0
 jmi GNCNerr                          /*  Schreib-/Lesefehler */
 move.l %d2,%d0                          /*  zurýck */
 asl.l #1,%d0                           /*  *2 */
 and.l #0x1ff,%d0                        /*  Rest von /512 (BPS) */
 lea fatbuff(%pc),%a0
 clr.l %d1
 move.b 1(%a0,%d0),%d1
 lsl #8,%d1
 move.b 0(%a0,%d0),%d1
 move.l %d1,%d0
 jra GNCNex
GNCNerr1:  
 move.l #7,errnum(%a4)                  /*  Disk full */
GNCNerr:  
 move.l #-1,%d0
GNCNex:  
 movem.l (%sp)+,%d1-%d2/%a0
 rts

GFSOC:                            /*  GetFirstSektorOfCluster %d0=Cluster */
 move.l %d1,-(%sp)
 and.l #0xffff,%d0                       /*  auf Wort */
 subq.l #2,%d0
 clr.l %d1
 move.b SPC(%fp),%d1
 mulu %d1,%d0
 add.l DataFrst(%fp),%d0
 move.l (%sp)+,%d1
 rts

AllClus:                          /*  AllocCluster %d0=currentcluster */
 movem.l %d1-%d2,-(%sp)
 move.l %d0,%d1                          /*  CurrentCluster sichern */
 jbsr FFC                                /*  FindFreeCluster */
 cmp.l #-1,%d0                          /*  Fehler? */
 jeq ACerr                            /*  jo */
 move.l %d0,%d2                          /*  neuen Cluster sichern */
 tst.l %d1                               /*  neuer Clusterchain? */
 jeq AClp01                           /*  jo */
 exg %d0,%d1                             /*  neue Clusternr in Alten */
 jbsr WCN                                /*  WriteClusterNumber */
 tst.l %d0                               /*  hats geklappt? */
 jmi ACerr                            /*  nü */
AClp01:  
 move.l %d2,%d0                          /*  neuen Cluster zurýck */
 move.l #0xFFFF,%d1                      /*  Clusterchain Ende */
 jbsr WCN                                /*  WriteClusterNumber */
 tst.l %d0                               /*  alles OK? */
 jmi ACerr                            /*  nü */
 move.l %d2,%d0                          /*  neuen Cluster zurýck */
 jra ACex
ACerr:  
 move.l #-1,%d0
ACex:  
 movem.l (%sp)+,%d1-%d2
 rts

FFC:                              /*  FindFreeCluster %d0 = currentcluster */
 movem.l %d1-%d2,-(%sp)
 move.l %d0,%d1                          /*  CurrentCluster sichern */
 addq.l #1,%d0
FFClp01:  
 cmp.l lastClus(%fp),%d0
 jge FFClp02
 move.l %d0,%d2                          /*  Cluster sichern */
 jbsr GNCN                               /*  GetNextClusterNumber */
 cmp.l #-1,%d0
 jeq FFCerr                           /*  Schreib-/Lesefehler */
 tst.l %d0
 jne FFClp03                          /*  Cluster nicht leer,weiter */
 move.l %d2,%d0
 jra FFCex
FFClp03:  
 move.l %d2,%d0
 addq.l #1,%d0
 jra FFClp01
FFClp02:  
 move.l #2,%d0                          /*  erster Cluster */
FFClp04:  
 cmp.l %d1,%d0
 jge FFCerr1                          /*  kein freier Cluster */
 move.l %d0,%d2
 jbsr GNCN                               /*  GetNextClusterNumber */
 cmp.l #-1,%d0
 jeq FFCerr                           /*  Schreib-/Lesefehler */
 tst.l %d0
 jne FFClp05                          /*  Cluster nicht leer,weiter */
 move.l %d2,%d0
 jra FFCex
FFClp05:  
 move.l %d2,%d0
 addq.l #1,%d0
 jra FFClp04
FFCerr1:  
 move.l #8,errnum(%a4)
FFCerr:  
 move.l #-1,%d0
FFCex:  
 movem.l (%sp)+,%d1-%d2
 rts

WCN:                              /*  WriteClusterNumber */
                                /*  %D0.l=Cluster Nummer,%D1.w=Wert */
 movem.l %d1/%d3/%a0,-(%sp)
 cmp.l lastClus(%fp),%d0
 jle WCN01
 move.l #25,errnum(%a4)
 jra WCNerr
WCN01:  
 move.l %d0,%d3                          /*  Cluster sichern */
 lsr.l #8,%d0                           /*  *2/512(BPS)=> /256 */
 add.l FATFrst(%fp),%d0                  /*  +FATFirst */
 jbsr UpFATBu                            /*  UpdateFATBuffer */
 tst.l %d0
 jmi WCNerr
 lea fatbuff(%pc),%a0
 move.l %d3,%d0
 asl.l #1,%d0                           /*  Cluster * 2 */
 and.l #0x1ff,%d0                        /*  => mod 512 */
 adda.l %d0,%a0
 move.b %d1,(%a0)+
 lsr #8,%d1
 move.b %d1,(%a0)
 move.b #1,FATStat(%a4)
 clr.l %d0
 jra WCNex
WCNerr:  
 move.l #-1,%d0
WCNex:  
 movem.l (%sp)+,%d1/%d3/%a0
 rts


 /* **** DOS Teil ***** */

FFFD:                             /*  Find Free File Descriptor */
 movem.l %d3/%a0,-(%sp)
 clr.l %d0
 move #maxofile-1,%d3
 lea filebuff(%pc),%a0
FFFD01:  
 tst.b FileFlag(%a0)
 jeq FFFD10
 addq #1,%d0
 adda.l #FDOff,%a0
 dbra %d3,FFFD01
 move.l #-1,%d0
 move.l #9,errnum(%a4)
 jra FFFDExit
FFFD10:  
 move.b #-1,FileFlag(%a0)               /*  File üffnen */
 clr.b FileDOff(%a0)
 clr.l FileCSec(%a0)
 clr.l File1CS(%a0)
 clr.l FileDSec(%a0)
 clr.l FileSize(%a0)
 clr.l FilePos(%a0)
 clr.b FileAttr(%a0)
 clr.l File1C(%a0)
 clr.l FileCurC(%a0)
 clr.l FileCC(%a0)
FFFDExit:  
 movem.l (%sp)+,%d3/%a0
 rts


FindName:                                 /*  %d0 = FileID */
 movem.l %d1,-(%sp)
 /*  cmp #-1,%d0 */
 cmp #0xFFFF,%d0
 jeq FNerr                            /*  keine Suche zu viele offene Dateien */
 cmp #maxofile,%d0
 jge FNerr                            /*  FileID zu gross */
 cmp.l #2,FrstDIRC(%fp)
 jge FN01
 jbsr ScRD                               /*  ScanRootDIR */
 jra FNex
FN01:  
 move.l FrstDIRC(%fp),%d1
 jbsr ScSD                               /*  Scan Sub-DIR */
 jra FNex
FNerr:  
 move.l #NO_MATCH,%d0
FNex:  
 movem.l (%sp)+,%d1
 rts


fload:                                    /*  Lûdt eine Datei in den Arbeitsspeicher */
                                        /*  %d0=FileID */
 movem.l %d2-%d4/%d6/%a0-%a3,-(%sp)
 jbsr FileDsct                           /*  File Daten in %a0 */
 movea.l %a0,%a2                         /*  in %a2 sichern */
 move.l FileSize(%a2),%d2                /*  Dateigrüsse */
 move.l %d2,%d3
 asr.l #8,%d3
 asr.l #1,%d3                           /*  %d0 = Dateigrüsse in Sektoren */
 and.l #0x1ff,%d2                        /*  noch ein Teilsektor ? */
 tst %d2
 jeq fld01                            /*  nü */
 addq.l #1,%d3                          /*  sonst ein Sektor mehr */
fld01:  
 subq.l #1,%d3                          /*  Als Zûhler */
 movea.l FileAdr(%a2),%a0                /*  RAM-Adresse in %a0 */

 movea.l %a0,%a3                         /*  sichern */
 move.l %d3,%d2                          /*  Sektoranzahl-1 */
 asl.l #8,%d2
 asl.l #1,%d2                           /*  *512 (BPS) */
 adda.l %d2,%a3                          /*  zum RAM-Start */
 move #512-1,%d2
fld02:  
 clr.b (%a3)+                            /*  die letzten 512 Byte lüschen */
 dbra %d2,fld02
 movea.l %a0,%a3
 move.l File1C(%a2),%d6                  /*  erster Cluster der Datei */
fld03:  
 cmp.l eoClusCh(%fp),%d6                 /*  vorzeitiges Ende ? */
 jge flderr
 movea.l %a3,%a0                         /*  Speicher wieder holen */
 move.l %d6,%d0
 jbsr GFSOC                              /*  GetFirstSektorOfCluster */
 move.l %d0,%d2                          /*  merken */
 clr.l %d4
 move.b SPC(%fp),%d4                     /*  Anzahl der Sektoren pro Cluster */
 subq.l #1,%d4                          /*  als Zûhler */
fld04:  
 move.l %d2,%d0                          /*  Sektor holen */
 jbsr ReadSec                            /*  lesen eines Sektors */
 tst.l %d0
 jmi flderr                           /*  Fehler beim lesen */
 addq.l #1,%d2                          /*  nûchster Sektor */
 subq.l #1,%d3
 jmi fld10                            /*  fertig! */
 dbra %d4,fld04                         /*  nûchster Sektor des Clusters */
 movea.l %a0,%a3                         /*  RAM sichern */
 move.l %d6,%d0
 jbsr GNCN                               /*  GetNextClusterNumber */
 tst.l %d0
 jmi flderr
 move.l %d0,%d6
 jra fld03
fld10:  
 clr.l %d0
 jra fldex
flderr:  
 move.l #-1,%d0
fldex:  
 movem.l (%sp)+,%d2-%d4/%d6/%a0-%a3
 rts


fsave:                                    /*  Speichert eine Datei */
                                        /*  %d0=FileID */
 movem.l %d2-%d4/%d6/%a0-%a3,-(%sp)
 jbsr FileDsct                           /*  File Daten in %a0 */
 movea.l %a0,%a2                         /*  in %a2 sichern */
 move.l FileSize(%a2),%d2                /*  Dateigrüsse */
 move.l %d2,%d3
 asr.l #8,%d3
 asr.l #1,%d3                           /*  %d3 = Dateigrüsse in Sektoren */
 and.l #0x1ff,%d2                        /*  noch ein Teilsektor ? */
 tst %d2
 jeq fsv01                            /*  nü */
 addq.l #1,%d3                          /*  sonst ein Sektor mehr */
fsv01:  
 subq.l #1,%d3                          /*  Als Zûhler */
 movea.l FileAdr(%a2),%a0                /*  RAM-Adresse in %a0 */
 movea.l %a0,%a3                         /*  sichern */
 move.l File1C(%a2),%d6                  /*  erster Cluster der Datei */
 tst.l %d6                               /*  neuer Clusterchain? */
 jne fsv02                            /*  nü */
 move.l %d6,%d0
 jbsr AllClus                            /*  neuen Cluster suchen */
 cmp.l #-1,%d0
 jeq fsverr                           /*  dann Fehler */
 move.l %d0,%d6
fsv02:  
 movea.l %a3,%a0                         /*  Speicher wieder holen */
 move.l %d6,%d0                          /*  akt. Cluster */
 jbsr GFSOC                              /*  GetFirstSektorOfCluster */
 move.l %d0,%d2                          /*  merken */
 clr.l %d4
 move.b SPC(%fp),%d4                     /*  Anzahl der Sektoren pro Cluster */
 subq.l #1,%d4                          /*  als Zûhler */
fsv03:  
 move.l %d2,%d0                          /*  Sektor holen */
 jbsr WriteSec                           /*  Sektor schreiben */
 tst.l %d0
 jmi fsverr                           /*  Schreibfehler */
 addq.l #1,%d2                          /*  nûchster Sektor */
 subq.l #1,%d3
 jmi fsv20                            /*  FERTIG */
 dbra %d4,fsv03                         /*  nûchster Sektor des Clusters */
 movea.l %a0,%a3                         /*  RAM-Adr. sichern */
 move.l %d6,%d0
 jbsr GNCN                               /*  GetNextClusterNumber */
 cmp.l #-1,%d0
 jeq fsverr
 cmp.l eoClusCh(%fp),%d0                 /*  Clusterchain zu Ende? */
 jge fsv10
 move.l %d0,%d6
 jra fsv02
fsv10:  
 move.l %d6,%d0
 jbsr AllClus                            /*  neuen Cluster suchen */
 cmp.l #-1,%d0
 jeq fsverr                           /*  dann Fehler */
 move.l %d0,%d6
 jra fsv02                            /*  sonst weiter */
fsv20:  
 jbsr FFAT                               /*  FAT speichern */
 tst.l %d0
 jmi fsverr
 clr.l %d0
 jra fsvex
fsverr:  
 move.l #-1,%d0
fsvex:  
 movem.l (%sp)+,%d2-%d4/%d6/%a0-%a3
 rts

remove:                           /*  Lüscht Datein. Name in parsdat */
 movem.l %d1/%a0-%a1,-(%sp)
 jbsr FFFD                               /*  FindFreeFileDiscriptor */
 tst.l %d0
 jmi rmverr1                            /*  keine freie FileID */
 move.l %d0,%d1                          /*  FileID sichern */
 jbsr FileDsct                           /*  FileDiscriptor in %a0 */
 movea.l %a0,%a1                         /*  sichern */
 jbsr FindFrst
 tst.l %d0                               /*  was gefunden? */
 jmi rmverr                             /*  nein */
 cmp.l #-1,ffpos(%a4)
 jne rmv01
 move.l #16,errnum(%a4)                 /*  keine Datei da */
 jra rmverr
rmv01:  
 move.l %d1,%d0                          /*  FileID zurýck */
 jbsr FFD
 btst #4,FileAttr(%a1)                /*  DIR? */
 jne rmv05                              /*  ja,nûchste */
 cmp.b #2,JNAFlag(%a4)
 jeq rmv03                            /*  Alle lüschen */
 tst.b quiet(%a4)                        /*  Ausgabe unterdrýcken? */
 jne rmv02                            /*  ja */
 move.l %d1,%d0
 lea txtcrlf(%pc),%a0                    /*  CRLF vorweg */
 jbsr writetxt
 jbsr NameOut
 lea txtloe(%pc),%a0                     /*  lüschen? */
 jbsr JNA                                /*  Ja/Nein/Alle */
rmv02:  
 cmp.b #2,JNAFlag(%a4)
 jeq rmv03                            /*  alle lüschen */
 tst.b JNAFlag(%a4)
 jeq rmv05                            /*  kein lüschen */
 clr.b JNAFlag(%a4)                      /*  nur diese lüschen */
rmv03:  
 move.l %d1,%d0                          /*  FileID zurýck */
 jbsr rem
 tst.l %d0
 jne rmverr
 tst.b quiet(%a4)                        /*  Ausgabe unterdrýcken? */
 jne rmv04                            /*  ja */
 move %d1,%d0
 lea txtcrlf(%pc),%a0                    /*  CRLF vorweg */
 jbsr writetxt
 jbsr NameOut
 lea txtdel(%pc),%a0
 jbsr writetxt
rmv04:  
 move.b #0xe5,FileName(%a1)              /*  Name gelüscht */
 clr.l FileSize(%a1)                     /*  Dateigrüsse = 0 */
 clr.l File1C(%a1)                       /*  ersterCluster = 0 */
 clr.b FileAttr(%a1)                     /*  Attribute = 0 */
 move.l %d1,%d0                          /*  FileID zurýck */
 jbsr UFE                                /*  UpdateFileEntry */
 tst.l %d0
 jmi rmverr
rmv05:  
 move.l %d1,%d0                          /*  FileID zurýck */
 jbsr FindNext
 tst.l %d0
 jmi rmverr                           /*  Fehler beim suchen */
 cmp.l #-1,ffpos(%a4)
 jeq rmv06                            /*  keine weiteren Dateien */
 jra rmv01
rmv06:  
 clr.l %d0
 jra rmvex
rmverr1:  
 move.l #-1,%d0
 jra rmvex1
rmverr:  
 move.l #-1,%d0
rmvex:  
 clr.b FileFlag(%a1)                     /*  FileID wieder frei */
rmvex1:  
 movem.l (%sp)+,%d1/%a0-%a1
 rts

rem:                              /*  Remove-Unterprogramm,%d0 = FileID */
 movem.l %d1-%d4/%a0-%a1,-(%sp)
 move.l %d0,%d4                          /*  FileID sichern */
 jbsr FileDsct
 movea.l %a0,%a1                         /*  sichern */
 move.b FileAttr(%a1),%d0                /*  DIR? */
 btst #4,%d0
 jeq rem02                            /*  nein */
 move.l #10,errnum(%a4)
 jra remerr
rem02:  
 move.l File1C(%a1),%d2
rem03:  
 move.l %d2,%d0                          /*  Cluster */
 jbsr GNCN
 tst.l %d0
 jmi remerr
 move.l %d0,%d3                          /*  nûchster Cluster */
 move.l %d2,%d0
 clr.l %d1
 jbsr WCN
 tst.l %d0
 jmi remerr
 cmp.l eoClusCh(%fp),%d3
 jge rem04                            /*  Clusterchain durch */
 move.l %d3,%d2                          /*  Cluster = nûchster Cluster */
 jra rem03
rem04:  
 jbsr FFAT
 tst.l %d0
 jmi remerr                           /*  Fehler beim schreiben */
rem05:  
 clr.l %d0
 jra remex
remerr:  
 move.l #-1,%d0
remex:  
 movem.l (%sp)+,%d1-%d4/%a0-%a1
 rts


QForm:                            /*  Quickformat des akt. Laufwerks */
 movem.l %d1-%d3/%a0-%a1,-(%sp)
 lea dirbuff(%pc),%a0                    /*  DIR Buffer in %a0 */
 movea.l %a0,%a1                         /*  nach %a1 sichern */
 move.l #512-1,%d3                      /*  512 Byte */
QF01:  
 move.b #0xe5,(%a0)+                     /*  DIR Buffer mit 0xe5 fýllen */
 dbra %d3,QF01
 move.l RtDrSec(%fp),%d3                 /*  Anzahl der RootDIR Sektoren */
 subq.l #1,%d3                          /*  -1 als Zûhler */
 move.l RootFrst(%fp),%d1                /*  Erster RootDIR Sektor */
QF02:  
 move.l %d1,%d0                          /*  Sektor */
 movea.l %a1,%a0                         /*  DIR Buffer */
 jbsr WriteSec                           /*  Sektor schreiben */
 tst.l %d0
 jmi QFerr                              /*  Fehler beim schreiben */
 addq.l #1,%d1                          /*  nûchster Sektor */
 dbra %d3,QF02
 movea.l %a1,%a0                         /*  DIR Buffer nach %a0 */
 move.l #512-1,%d3                      /*  512 Byte */
QF03:  
 clr.b (%a0)+                            /*  mit 0 fýllen */
 dbra %d3,QF03
 move.l FATFrst(%fp),%d1                 /*  Erster FAT Sektor */
 clr.l %d2
 move.b numFATs(%fp),%d2                 /*  Anzahl der FATs */
 subq.l #1,%d2                          /*  -1 als Zûhler */
QF04:  
 clr.l %d3
 move FATSz(%fp),%d3                     /*  Grüsse der FATs */
 subq.l #2,%d3                          /*  -2 als Zûhler 1.Sec gesondert */
 move.l %d1,%d0                          /*  Sektor */
 movea.l %a1,%a0                         /*  Buffer */
 move #0xf8ff,0(%a0)
 move #0xffff,2(%a0)                     /*  Media rein 2 Cluster */
 jbsr WriteSec                           /*  1. Sektor schreiben */
 tst.l %d0
 jmi QFerr                            /*  Fehler beim schreiben */
 clr.l 0(%a1)                            /*  Media raus 2 Cluster */
 addq.l #1,%d1                          /*  2. Sektor */
QF05:                                     /*  2. bis x. Sektor */
 move.l %d1,%d0                          /*  Sektor */
 movea.l %a1,%a0                         /*  Buffer */
 jbsr WriteSec                           /*  Sektor schreiben */
 tst.l %d0
 jmi QFerr                            /*  Fehler beim schreiben */
 addq.l #1,%d1                          /*  nûchster Sektor */
 dbra %d3,QF05
 dbra %d2,QF04                          /*  nûchte FAT */
 move.l RootFrst(%fp),%d0
 movea.l %a1,%a0
 jbsr ReadSec
 tst.l %d0
 jmi QFerr                            /*  Fehler beim lesen */
 move #0x2f00,NoAD(%fp)                  /*  /00 */
 clr.l FrstDIRC(%fp)                     /*  Erster DIR-Cluster = 0 (Root-DIR) */
 move.l FATFrst(%fp),%d0
 move.l %d0,FATCurr(%fp)                
 lea fatbuff(%pc),%a0
 jbsr ReadSec                            /*  neue FAT laden */
 tst.l %d0
 jmi QFerr                            /*  Fehler beim lesen */
 clr.b FATStat(%a4)
 clr.l %d0                               /*  alles OK */
 jra QFex
QFerr:  
 move.l #-1,%d0
QFex:  
 movem.l (%sp)+,%d1-%d3/%a0-%a1
 rts




 /* **** DIR Teil ***** */

ScRD:                                     /*  ScanRootDIR / %d0.w=FileID */
 movem.l %d1/%d3/%d6/%d7,-(%sp)
 move.l #NO_MATCH,%d7                   /*  %d7=result */
 move.l RtDrSec(%fp),%d3
 subq.l #1,%d3
 move.l RootFrst(%fp),%d1
 move.l %d0,%d6                          /*  FileID sichern */
ScRD01:  
 move.l %d6,%d0                          /*  FileID wieder herstellen */
 jbsr ScODS                              /*  ScanOneDirectorySektor */
 cmp.l #NO_MATCH,%d0
 jne ScRDex
 addq.l #1,%d1                          /*  nûchster Sektor */
 dbra %d3,ScRD01
ScRDerr:  
 move.l %d7,%d0
ScRDex:  
 movem.l (%sp)+,%d1/%d3/%d6/%d7
 rts


ScSD:                             /*  ScanSubDIR / %d0.w=FileID,%d1.l=Startcluster */
 movem.l %d1-%d7,-(%sp)
 move.l %d1,%d6                          /*  Startcluster merken */
 move.l %d0,%d5                          /*  FileID merken */
 move.l #NO_MATCH,%d7                   /*  result */
ScSD01:  
 cmp.l eoClusCh(%fp),%d6                 /*  Ende erreicht? */
 jeq ScSDerr
 move.l %d6,%d0
 jbsr GFSOC                              /*  GetFirstSektorOfCluster */
 move.l %d0,%d4                          /*  tmpSektor */
 clr.l %d3
 move.b SPC(%fp),%d3
 subq.l #1,%d3
ScSD02:  
 move.l %d5,%d0
 move.l %d4,%d1
 jbsr ScODS                              /*  ScanOneDirectorySektor */
 cmp.l #NO_MATCH,%d0
 jne ScSDex
 addq.l #1,%d4                          /*  tmpSektor+1 */
 dbra %d3,ScSD02
 move.l %d6,%d0                          /*  tmpCluster */
 jbsr GNCN                               /*  GetNextClusterNumber */
 cmp.l #-1,%d0
 jeq ScSDerr
 move.l %d0,%d6
 jra ScSD01
ScSDerr:  
 move.l %d7,%d0
ScSDex:  
 movem.l (%sp)+,%d1-%d7
 rts


ScODS:                             /*  ScanOnDirectorySektor %d0.w=FileID,%d1.l=Sec */
 movem.l %d1-%d7/%a0-%a3,-(%sp)
 move.l %d0,%d5                          /*  FileID sichern */
 move.l %d1,%d6                          /*  Sektor sichern */
 jbsr FileDsct
 movea.l %a0,%a2                         /*  Sichern */
 move.l %d1,%d0
 lea dirbuff(%pc),%a0
 jbsr ReadSec
 lea dirbuff(%pc),%a0
 movea.l %a0,%a3                         /*  Sichern */
 clr.l %d3                               /*  Als Zûhler */
ScODS01:  
 move.l #NO_MATCH,%d7
 tst.b DIRName(%a3)                      /*  =0 dann DIR Ende */
 jne ScODS10
 move.l #END_DIR,%d7
 jra ScODSex
ScODS10:  
 cmp.b #0xe5,DIRName(%a3)                /*  Eintrag leer */
 jeq ScODS90
 cmp.b #0x0f,DIRAttr(%a3)                /*  Long Filename */
 jeq ScODS90
 move.l #8,%d0
 movea.l %a2,%a0                         /*  FileDesc */
 adda.l #FileName,%a0
 movea.l %a3,%a1                         /*  Dirbuffer */
 adda.l #DIRName,%a1
 jbsr strgcmp                            /*  Stringvergleich */
 tst.l %d0
 jne ScODS21
 move.l #MATCH_N,%d7
ScODS21:  
 move.l #3,%d0
 movea.l %a2,%a0
 adda.l #FileExt,%a0
 movea.l %a3,%a1
 adda.l #DIRExt,%a1
 jbsr strgcmp                            /*  Stringvergleich */
 tst.l %d0
 jne ScODS20
 add.l #MATCH_E,%d7
ScODS20:  
 move.b DIRAttr(%a3),%d0
 btst #4,%d0
 jeq ScODS30                          /*  kein DIR */
                                        /*  DIR Teil */
 move DIR1CH(%a3),%d0                    /*  tmp */
 jbsr LowBHigh
 move %d0,%d4
 swap %d4
 move DIR1CL(%a3),%d0                    /*  tmp.l LBHW?????? */
 jbsr LowBHigh
 move %d0,%d4
 cmp.l #FULL_MAT,%d7
 jne ScODS30
 move.l %d4,File1C(%a2)
 jra ScODSex

ScODS30:  
 move DIR1CH(%a3),%d0                    /*  tmp.w */
 jbsr LowBHigh
 move %d0,%d4
 swap %d4
 move DIR1CL(%a3),%d0                    /*  tmp.l LBHW????? */
 jbsr LowBHigh
 move %d0,%d4
 cmp.l #FULL_MAT,%d7                    /*  stimmt die Datei? */
 jne ScODS90                          /*  nü also weiter */

 move.l %d6,FileDSec(%a2)                /*  File Teil */
 move.l %d3,%d0                          /*  Zûhler */
 lsr.l #5,%d0                           /*  / 32 */
 move.b %d0,FileDOff(%a2)
 move.l %d4,File1C(%a2)                  /*  tmp */
 move.l DIRSize(%a3),%d0
 jbsr LBHLW
 move.l %d0,FileSize(%a2)
 move.b #0,FileAttr(%a2)                /*  0=Datei */
 jra ScODSex
ScODS90:  
 adda.l #32,%a3
 add.l #32,%d3
 cmp BPS(%fp),%d3
 jge ScODSerr
 jra ScODS01
ScODSerr:  
 move.l #NO_MATCH,%d7
ScODSex:  
 move.l %d7,%d0
 movem.l (%sp)+,%d1-%d7/%a0-%a3
 rts


FileDsct:                         /*  liefert in %A0 den FileDiscriptor Block */
                                        /*  zur FileID in %d0.w */
 move.l %d0,-(%sp)
 and.l #0xFFFF,%d0                       /*  nur Wort gýltig */
 mulu #FDOff,%d0                        /*  FileID*FileDiscriptorOffset */
 lea filebuff(%pc),%a0                  
 adda.l %d0,%a0                          /*  + Basis */
 move.l (%sp)+,%d0
 rts


FNE:                              /*  FileNameEmpty / %d0.w=FileID */
 movem.l %d3/%a0-%a1,-(%sp)
 jbsr FileDsct
 movea.l %a0,%a1                         /*  Sichern */
 adda.l #FileName,%a0
 move #8-1,%d3                          /*  8 Stellen Name */
FNE01:  
 cmp.b #' ',(%a0)+
 jne FNEerr
 dbra %d3,FNE01
 adda.l #FileExt,%a1
 move #3-1,%d3                          /*  3 Stellen Extension */
FNE02:  
 cmp.b #' ',(%a1)+
 jne FNEerr
 dbra %d3,FNE02
 clr.l %d0                               /*  ist leer */
 jra FNEex
FNEerr:  
 move.l #1,%d0
FNEex:  
 movem.l (%sp)+,%d3/%a0-%a1
 rts


MFN:                              /*  MakeFileName / %d0.w=FileID,ParsDat=Name.Ext */
                                /*  copiert den Dateiname/ext. in den FileDsc */
 movem.l %d0/%d3/%a0-%a3,-(%sp)
 lea parsdat(%pc),%a2
 movea.l %a2,%a1
 adda.l #pqdatn,%a1                     /*  %a1 auf Dateiname */
 adda.l #pqdate,%a2                     /*  %a2 auf Extension */
 jbsr FileDsct                           /*  FileDisct in %A0 */
 movea.l %a0,%a3
 adda.l #FileName,%a0
 move #8-1,%d3
MFN01:  
 move.b #' ',(%a0)+                     /*  Name mit Space fýllen */
 dbra %d3,MFN01
 movea.l %a3,%a0
 adda.l #FileExt,%a0
 move.b #' ',(%a0)+                     /*  Ext mit Space fýllen */
 move.b #' ',(%a0)+
 move.b #' ',(%a0)
 movea.l %a3,%a0
 adda.l #FileName,%a0
MFN03:  
 move #8-1,%d3
MFN04:  
 move.b (%a1)+,%d0
 tst.b %d0
 jeq MFN10
 move.b %d0,(%a0)+
 dbra %d3,MFN04
MFN10:  
MFN11:  
 movea.l %a3,%a0
 adda.l #FileExt,%a0
 move #3,%d3
MFN12:  
 move.b (%a2)+,%d0
 tst.b %d0
 jeq MFNex
 move.b %d0,(%a0)+
 dbra %d3,MFN12
MFNex:  
 movem.l (%sp)+,%d0/%d3/%a0-%a3
 rts


FFD:                              /*  FillFileDiscriptor */
                                /*  File-ID in %d0,Filedaten in ffsec und ffpos */
                                /*  Kopiert die Filedaten vom DIR in FileDsct */
 movem.l %d1/%a0-%a3,-(%sp)
 move.l ffpos(%a4),%d1                   /*  gýltige Daten? */
 jmi FFDerr                             /*  nein! */
 jbsr FileDsct                           /*  FileDiscriptor in %A0 */
 movea.l %a0,%a3                         /*  sichern */
 lea dirbuff(%pc),%a1
 adda.l ffpos(%a4),%a1                   /*  auf akt. Datei */
 movea.l %a1,%a2
 adda.l #FileName,%a0
 move #8-1,%d3
FFD01:  
 move.b #' ',(%a0)+                     /*  Name mit Space fýllen */
 dbra %d3,FFD01
 movea.l %a3,%a0
 adda.l #FileExt,%a0
 move.b #' ',(%a0)+                     /*  Ext mit Space fýllen */
 move.b #' ',(%a0)+
 move.b #' ',(%a0)
 movea.l %a3,%a0
 adda.l #FileName,%a0
 adda.l #DIRName,%a1
FFD03:  
 move #8-1,%d3
FFD04:                                    /*  Name kopieren */
 move.b (%a1)+,%d0
 tst.b %d0
 jeq FFD10
 move.b %d0,(%a0)+
 dbra %d3,FFD04
FFD10:  
FFD11:  
 movea.l %a3,%a0
 adda.l #FileExt,%a0
 movea.l %a2,%a1
 adda.l #DIRExt,%a1
 move #3,%d3
FFD12:                                    /*  Ext kopieren */
 move.b (%a1)+,%d0
 tst.b %d0
 jeq FFD13
 move.b %d0,(%a0)+
 dbra %d3,FFD12
FFD13:  
 move.l ffsec(%a4),FileDSec(%a3)         /*  File-DIR-Sektor */
 lsr.l #5,%d1                           /*  /32 */
 move.b %d1,FileDOff(%a3)                /*  File-DIR-Offset */
 move DIR1CH(%a2),%d0                    /*  First-File-Cluster-High */
 jbsr LowBHigh
 move %d0,%d1
 swap %d1
 move DIR1CL(%a2),%d0                    /*  First-File-Cluster-Low */
 jbsr LowBHigh
 move %d0,%d1
 move.l %d1,File1C(%a3)                  /*  FileFirstCluster */
 move.l DIRSize(%a2),%d0                 /*  File Size */
 jbsr LBHLW
 move.l %d0,FileSize(%a3)
 move.b DIRAttr(%a2),FileAttr(%a3)       /*  File Attribute */
 clr.l %d0
 jra FFDex
FFDerr:  
 move.l #-1,%d0
FFDex:  
 movem.l (%sp)+,%d1/%a0-%a3
 rts


chdir:                            /*  zum Verzeichnis wechseln */
                                /*  DIR-Name in parsdat */
                                /*  setzt FrstDIRC und NoAD */
 movem.l %d2-%d3/%a0-%a2,-(%sp)
 jbsr FFFD                               /*  FindFreeFileDiscriptor */
 tst.l %d0
 jmi cderr                              /*  kein freier Dateihûndel */
 move %d0,%d2                            /*  sichern */
 jbsr FileDsct                           /*  FileDiscriptor Adresse in %a0 laden */
 lea parsdat(%pc),%a2
 adda.l #pqdatn,%a2                     /*  %a2 auf Quell-Dateiname */
 cmp.b #'/',(%a2)                       /*  RootDIR ? */
 jne cd01                             /*  nü */
 clr.l FrstDIRC(%fp)                     /*  FirstDIRCluster=0 */
 move #0x2f00,NoAD(%fp)                  /*  akt DIRName = "/0" */
 jra cdok
cd01:  
 move %d2,%d0                            /*  FileID zurýck holen */
 jbsr MFN                                /*  MakeFileName */
 move %d2,%d0                            /*  Vorsichtshalber */
 jbsr FindName                           /*  FindName */
 cmp.l #FULL_MAT,%d0                    /*  Datei gefunden? */
 jne cderr1                           /*  nü */
 move.l File1C(%a0),%d0
 move.l %d0,FrstDIRC(%fp)
 move #8-1,%d3
 movea.l %a0,%a1
 adda.l #FileName,%a1                   /*  %a1 auf FileName im FileDesc */
 movea.l %fp,%a2
 adda.l #NoAD,%a2                       /*  %a2 auf akt. DIRname */
cd02:  
 move.b (%a1)+,%d0                       /*  DIRname einlesen */
 jeq cd03                             /*  falls ne 0 */
 cmp.b #' ',%d0
 jeq cd03                             /*  falls Leerzeichen */
 move.b %d0,(%a2)+                       /*  sonst speichern */
 dbra %d3,cd02
cd03:  
 clr.b (%a2)                             /*  mit 0 abschliessen */
cdok:  
 move.l FrstDIRC(%fp),%d0                /*  1. DIR-Cluster */
 cmp.l #2,%d0                           /*  RootDIR? */
 jge cd04                             /*  nü */
 move.l RootFrst(%fp),%d0                /*  1. Root-DIR Sektor */
 jra cd05
cd04:  
 jbsr GFSOC                              /*  GetFirstSektorOfCluster */
cd05:  
 clr.b FileFlag(%a0)                     /*  Dateihûndel wieder schliessen */
 lea dirbuff(%pc),%a0
 jbsr ReadSec                            /*  1. DIR-Sektor einlesen */
 tst.l %d0
 jmi cderr
 move #F_OK,%d0
 jra cdex
cderr1:  
 move.l #11,errnum(%a4)
cderr:  
 clr.b FileFlag(%a0)                     /*  Dateihûndel wieder schliessen */
 move #F_ERROR,%d0
cdex:  
 movem.l (%sp)+,%d2-%d3/%a0-%a2
 rts


UFE:                              /*  UpdateFileEntry */
                                /*  %d0 = FileID */
 movem.l %d1/%a0-%a3,-(%sp)
 jbsr FileDsct                           /*  FileDiscriptor in %a0 */
 movea.l %a0,%a3                         /*  sichern */
 lea dirbuff(%pc),%a2
 movea.l %a2,%a0
 move.l FileDSec(%a3),%d0                /*  DIR-Sektor nach %d0 */
 jbsr ReadSec                            /*  DIR-Sektor lesen */
 tst.l %d0
 jmi UFEerr                             /*  Lesefehler */
 clr.l %d0
 move.b FileDOff(%a3),%d0
 asl.l #5,%d0                           /*  *32 */
 adda.l %d0,%a2                          /*  %a2 auf akt. DIR-Eintrag */
 movea.l %a2,%a1
 adda.l #DIRName,%a1
 movea.l %a3,%a0
 adda.l #FileName,%a0
 move.l #8,%d0
 jbsr strgcopy                           /*  NAME kopieren */
 movea.l %a2,%a1
 adda.l #DIRExt,%a1
 movea.l %a3,%a0
 adda.l #FileExt,%a0
 move.l #3,%d0
 jbsr strgcopy                           /*  EXT kopieren */
 move.b FileAttr(%a3),%d0
 move.b %d0,DIRAttr(%a2)                 /*  Attribute kopieren */
 clr.b DIREZt(%a2)                       /*  Erstellungs 10tel lüschen */
                                        /*  Erstellungszeit bleibt! */
 movea.l %a3,%a0
 adda.l #Fiob,%a0                       /*  Fiob als Puffer fýr Uhr */
 jbsr getuhr
 movea.l %a3,%a0
 adda.l #Fiob,%a0                       /*  %a0 auf GP-Uhrzeit */
 clr.l %d1
 move.b 4(%a0),%d0                       /*  Jahr */
 jbsr bcdtobin
 add.b #20,%d0                          /*  +20 da ab 1980! */
 ror #7,%d0
 and #0xfe00,%d0                         /*  obersten 7 Bits */
 or %d0,%d1                              /*  in %d1 ýbertragen */
 move.b 3(%a0),%d0                       /*  Monat */
 jbsr bcdtobin
 asl #5,%d0
 and #0x01e0,%d0                         /*  4 Bits in der Mitte */
 or %d0,%d1                              /*  ab nach %d1 */
 move.b 2(%a0),%d0                       /*  Tag */
 jbsr bcdtobin
 and #0x001f,%d0                         /*  die untersten 5 Bits */
 or %d0,%d1                              /*  nach %d1 */
 swap %d1                                /*  nu die andere Hûlfte */
 move.b (%a0),%d0                        /*  Stunde */
 jbsr bcdtobin
 ror #5,%d0
 and #0xf800,%d0                         /*  obersten 5 Bits */
 or %d0,%d1                              /*  nach %d1 */
 move.b 1(%a0),%d0                       /*  Minute */
 jbsr bcdtobin
 asl #5,%d0
 and #0x07e0,%d0                         /*  6 Bits in der Mitte */
 or %d0,%d1                              /*  nach %d1 */
 move.b 6(%a0),%d0                       /*  Sekunde */
 jbsr bcdtobin
 asr #1,%d0                             /*  /2 */
 and #0x1f,%d0                           /*  untersten 5 Bits */
 or %d0,%d1                              /*  nach %d1 */
 move.l %d1,%d0                          /*  zurýck nach %d0 */
 jbsr LBHLW                              /*  LowByteHighLangWort */
 move.l %d0,DIRLCh(%a2)                  /*  im DIR speichern */
 clr DIR1CH(%a2)                         /*  HighCluster = 0 FAT16! */
 move.l File1C(%a3),%d0                  /*  LowCluster */
 jbsr LowBHigh                           /*  wieder nach IBM :-( */
 move %d0,DIR1CL(%a2)                    /*  und speichern */
 move.l FileSize(%a3),%d0                /*  Datei Grüsse */
 jbsr LBHLW                              /*  nach IBM */
 move.l %d0,DIRSize(%a2)                 /*  speichern */
 move.l FileDSec(%a3),%d0
 lea dirbuff(%pc),%a0
 jbsr WriteSec
 tst.l %d0
 jeq UFEex
UFEerr:  
 move.l #-1,%d0
UFEex:  
 movem.l (%sp)+,%d1/%a0-%a3
 rts


mkdir:                            /*  Verzeichnis erstellen */
                                /*  DIR-Name in parsdat */
 movem.l %d2-%d3/%a0-%a3,-(%sp)
 jbsr FFFD                               /*  FindFreeFileDiscriptor */
 tst.l %d0
 jmi mkdirer1                           /*  kein freier Dateihûndel */
 move.l %d0,%d2                          /*  sichern */
 jbsr MFN                                /*  MakeFileName */
 jbsr FindName                           /*  Name schon vorhanden? */
 cmp.l #FULL_MAT,%d0
 jne mkdir00
 move.l #13,errnum(%a4)
 jra mkdirerr                           /*  DIR ist vorhanden,Fehler */
mkdir00:  
 move.l %d2,%d0                          /*  FileID zurýck */
 jbsr FileDsct                           /*  FileDiscriptor Adresse in %a0 laden */
 movea.l %a0,%a1                         /*  sichern */
 move.b #0x10,FileAttr(%a1)              /*  DIR Attribut setzen */
 move.l %d2,%d0                          /*  FileID zurýck */
 jbsr MNFE                               /*  neuer DIR-Eintrag */
 tst.l %d0                               /*  alles OK? */
 jmi mkdirerr                           /*  nee */

 tst.b quiet(%a4)                        /*  Ausgabe unterdrýcken? */
 jne mkdir03                          /*  ja */
 lea txtcrlf(%pc),%a0                    /*  CRLF vorweg */
 jbsr writetxt
 lea txtverz(%pc),%a0
 jbsr writetxt
 move.l %d2,%d0
 jbsr NameOut
 lea txterst(%pc),%a0
 jbsr writetxt

mkdir03:  
 move.l File1C(%a1),%d0                  /*  der 1te Cluster */
 jbsr GFSOC                              /*  GetFirstSektorOfCluster */
 move.l %d0,FileDSec(%a1)                /*  1. Sektor speichern */
 move.l %d0,%d1                          /*  sichern */
 lea dirbuff(%pc),%a0
 move #512-1,%d3                        /*  BPS-1 */
mkdir01:  
 clr.b (%a0)+                            /*  Dirbuffer lüschen */
 dbra %d3,mkdir01
 clr.l %d3
 move.b SPC(%fp),%d3                     /*  SektorenProCluster */
 subq.l #1,%d3                          /*  -1 als Zûhler */
mkdir02:  
 lea dirbuff(%pc),%a0
 move.l %d1,%d0                          /*  Sektor zurýck */
 jbsr WriteSec                           /*  Sektor schreiben */
 tst.l %d0
 jmi mkdirerr                           /*  Schreibfehler */
 addq.l #1,%d1                          /*  nûchster Sektor */
 dbra %d3,mkdir02

 lea parsdat(%pc),%a2
 movea.l %a2,%a3
 adda.l #pqdatn,%a2                     /*  %a2 auf Quell-Dateiname */
 adda.l #pqdate,%a3                     /*  %a3 auf Quell-Extension */
 move.b #'.',(%a2)
 clr.b 1(%a2)                            /*  Dateiname = .0 */
 clr.b (%a3)                             /*  Extension = 0 */
 move %d2,%d0                            /*  FileID zurýck */
 clr.b FileDOff(%a1)
 jbsr MFN                                /*  MakeFileName */
 move %d2,%d0                            /*  FileID zurýck */
 jbsr UFE                                /*  UpdateFileEntry */
 tst.l %d0
 jmi mkdirerr

 move.b #'.',1(%a2)
 clr.b 2(%a2)                            /*  Dateiname auf ..0 */
 move.b #1,FileDOff(%a1)
 move.l %d2,%d0                          /*  FileID zurýck */
 jbsr MFN
 move.l %d2,%d0                          /*  FileID zurýck */
 move.l FrstDIRC(%fp),File1C(%a1)        /*  UpperDIR Cluster */
 jbsr UFE                                /*  UpdateFileEntry */
 tst.l %d0
 jmi mkdirerr

 jbsr FFAT
 tst.l %d0
 jmi mkdirerr                           /*  Schreibfehler */
 clr.l %d0                               /*  alles OK */
 jra mkdirex

mkdirer1:  
 move.l #-1,%d0
 jra mkdirex1
mkdirerr:  
 move.l #-1,%d0
mkdirex:  
 clr.b FileFlag(%a1)                     /*  File Hûndel wieder freigeben */
mkdirex1:  
 movem.l (%sp)+,%d2-%d3/%a0-%a3
 rts



SRD:                                      /*  SearchRootDIR %d0=FileID */
                                        /*  sucht nach freien DIR-Eintrag */
 movem.l %d1/%d3/%d6/%d7,-(%sp)
 move.l RtDrSec(%fp),%d3
 subq.l #1,%d3
 move.l RootFrst(%fp),%d1
 move.l %d0,%d6                          /*  FileID sichern */
SRD01:  
 move.l %d6,%d0                          /*  FileID wieder herstellen */
 jbsr SODS                               /*  SearchOneDirectorySektor */
 tst.l %d0
 jne SRDex
 addq.l #1,%d1                          /*  nûchster Sektor */
 dbra %d3,SRD01
SRDerr:  
 clr.l %d0                               /*  nichts gefunden */
SRDex:  
 movem.l (%sp)+,%d1/%d3/%d6/%d7
 rts


SSD:                             /*  SearchSubDIR / %d0.w=FileID,%d1.l=Startcluster */
 movem.l %d1-%d7,-(%sp)
 move.l %d1,%d6                          /*  Startcluster merken */
 move.l %d0,%d5                          /*  FileID merken */
SSD01:  
 cmp.l eoClusCh(%fp),%d6                 /*  Ende erreicht? */
 jge SSDerr
 move.l %d6,%d0
 jbsr GFSOC                              /*  GetFirstSektorOfCluster */
 move.l %d0,%d4                          /*  tmpSektor */
 clr.l %d3
 move.b SPC(%fp),%d3
 subq.l #1,%d3
SSD02:  
 move.l %d5,%d0
 move.l %d4,%d1
 jbsr SODS                               /*  SearchOneDirectorySektor */
 tst.l %d0                               /*  was gefunden? */
 jne SSDex                            /*  jo */
 addq.l #1,%d4                          /*  tmpSektor+1 */
 dbra %d3,SSD02
 move.l %d6,%d0                          /*  tmpCluster */
 jbsr GNCN                               /*  GetNextClusterNumber */
 cmp.l #-1,%d0
 jeq SSDerr
 move.l %d0,%d6
 jra SSD01
SSDerr:  
 clr.l %d0                               /*  nichts gefunden */
SSDex:  
 movem.l (%sp)+,%d1-%d7
 rts


SODS:                             /*  SearchOneDirectorySektor */
                                /*  %d0.w=FileID,%d1.l=Sektor */
 movem.l %d1/%d3/%a0-%a1,-(%sp)
 jbsr FileDsct
 movea.l %a0,%a1
 lea dirbuff(%pc),%a0
 move.l %d1,%d0                          /*  Sektor */
 jbsr ReadSec
 tst.l %d0
 jne SODSerr                          /*  konnte nicht gelesen werden */
 lea dirbuff(%pc),%a0
 clr.l %d3                               /*  als Zûhler */
SODS01:  
 move.b 0(%a0,%d3.w),%d0
 tst.b %d0
 jeq SODS02
 cmp.b #0xe5,%d0
 jeq SODS02
 add.l #32,%d3
 cmp.l #512,%d3                         /*  Ende erreicht? */
 jge SODSerr                          /*  ja,dann Fehler */
 jra SODS01
SODS02:  
 move.l #1,%d0
 move.l %d1,FileDSec(%a1)                /*  Sektor speichern */
 asr.l #5,%d3                           /*  DIR-Offset / 32 */
 move.b %d3,FileDOff(%a1)                /*  und speichern */
 jra SODSex
SODSerr:  
 clr.l %d0
SODSex:  
 movem.l (%sp)+,%d1/%d3/%a0-%a1
 rts


MNFE:                             /*  MakeNewFileEntry %d0.w=FileID */
 movem.l %d1-%d3/%d6/%a0-%a2,-(%sp)
 move.l %d0,%d6                          /*  FileID sichern */
 jbsr FileDsct                           /*  %a0=FileDiscriptor */
 move.l %d6,%d0                          /*  FileID zurýck */
 movea.l %a0,%a2                         /*  sichern */
 move.l FrstDIRC(%fp),%d2
 cmp.l #2,%d2                           /*  1. DIR-Cluster < 2? */
 jge MNFE01                           /*  nü */
 jbsr SRD                                /*  sonst SearchRootDIR */
 jra MNFE02
MNFE01:  
 move.l %d2,%d1                          /*  StartCluster */
 jbsr SSD                                /*  SearchSubDir */
MNFE02:  
 tst.l %d0
 jne MNFE10                             /*  hat was gefunden */
 cmp.l #2,%d2                           /*  wars Root-DIR? */
 jge MNFE02a                          /*  nü */
 move.l #12,errnum(%a4)
 jra MNFEerr                            /*  sonst Fehler! */
MNFE02a:  
 move.l %d2,%d0                          /*  FirstDIRC */
MNFE03:  
 move.l %d0,%d2                          /*  akt. Cluster merken */
 jbsr GNCN                               /*  GetNextClusterNumber */
 cmp.l #-1,%d0
 jeq MNFEerr
 cmp.l eoClusCh(%fp),%d0                 /*  EndOfClusterChain? */
 jlt MNFE03                           /*  nü,dann nochmal */
 move.l %d2,%d0                          /*  letzten Cluster zurýck */
 jbsr AllClus                            /*  Cluster fýrs DIR hohlen */
 cmp.l #-1,%d0                          /*  ham wir noch welche? */
 jeq MNFEerr                            /*  neee */
 move.l %d0,%d2                          /*  Cluster sichern */
 jbsr FFAT
 move #512-1,%d3                        /*  BPS -1,als Zûhler */
 lea dirbuff(%pc),%a0
MNFE04:  
 clr.b (%a0)+                            /*  Dirbuffer lüschen */
 dbra %d3,MNFE04
 move.l %d2,%d0                          /*  Cluster zurýck */
 jbsr GFSOC                              /*  GetFirstSektorOfCluster */
 move.l %d0,%d1                          /*  Sektor sichern */
 clr.l %d3
 move.b SPC(%fp),%d3                     /*  SektorenProCluster */
 subq.l #1,%d3                          /*  -1 als Zûhler */
MNFE05:  
 lea dirbuff(%pc),%a0
 move.l %d1,%d0
 jbsr WriteSec                           /*  Sektoren mit 0 (NULL) fýllen */
 tst.l %d0                               /*  Fehler beim schreiben? */
 jne MNFEerr                          /*  JA! */
 addq.l #1,%d1                          /*  nûchster Sektor */
 dbra %d3,MNFE05
 move.l %d2,%d0                          /*  Cluster wiederhohlen */
 jbsr GFSOC
 move.l %d0,FileDSec(%a2)                /*  DIR-Sektor speichern */
 clr.b FileDOff(%a2)                     /*  DIR-Offset = 0 */
MNFE10:  
 clr.l %d0
 jbsr AllClus                            /*  Cluster fýrs File hohlen */
 cmp.l #-1,%d0
 jeq MNFEerr                          /*  keine freien Cluster! */
 and.l #0xFFFF,%d0                       /*  auf LangWort */
 move.l %d0,File1C(%a2)                  /*  FileFirstCluster sichern */
 clr.l FileSize(%a2)                     /*  FileSize=0 */
 jbsr FFAT
 move.l %d6,%d0                          /*  FileID zurýck */
 jbsr UFE                                /*  UpdateFileEntry */
 clr.l %d0                               /*  alles OK */
 jra MNFEex
MNFEerr:  
 move.l #-1,%d0
MNFEex:  
 movem.l (%sp)+,%d1-%d3/%d6/%a0-%a2
 rts


FindFrst:                         /*  Sucht 1. Datei */
 movem.l %d1/%a0,-(%sp)
 move.l #-32,ffpos(%a4)                 /*  Dateiposition lüschen */
 clr.l ffsec(%a4)                        /*  DIR-Sektor lüschen */
 clr.l ffsecc(%a4)                       /*  DIR-Sektor-Count lüschen */
 clr.l ffclus(%a4)                       /*  DIR-Cluster lüschen */
 move.l FrstDIRC(%fp),%d0
 cmp.l #2,%d0
 jge FF01
 move.l RootFrst(%fp),%d0                /*  Root-DIR Sektor laden */
 move.l %d0,ffsec(%a4)
 jra FF02
FF01:  
 move.l %d0,ffclus(%a4)
 jbsr GFSOC                              /*  Sub-DIR Sektor laden */
 move.l %d0,ffsec(%a4)
FF02:  
 lea dirbuff(%pc),%a0
 jbsr ReadSec
 tst.l %d0
 jmi FFerr                            /*  Lesefehler aufgetreten */
 jbsr FindNext                           /*  1. Datei suchen */
 tst.l %d0
 jmi FFerr
 clr.l %d0
 jra FFex
FFerr:  
 move.l #-1,%d0
FFex:  
 movem.l (%sp)+,%d1/%a0
 rts

FindNext:                         /*  nûchsten DIR-Eintrag suchen */
 movem.l %d1-%d4/%a0-%a1,-(%sp)
 cmp.l #2,FrstDIRC(%fp)
 jge FNX10
FNX01:                                    /*  Root-DIR Teil */
 move.l ffsecc(%a4),%d3                  /*  Sektor Zûhler */
 move.l ffsec(%a4),%d2                   /*  akt. RootDIR-Sektor */
 move.l ffpos(%a4),%d1                   /*  akt. Position im Sektor */
FNX02:  
 add.l #32,%d1
 cmp.l #512,%d1                         /*  Sektor durch? */
 jlt FNX03                            /*  nein */
 clr.l %d1                               /*  Position auf Null */
 addq.l #1,%d2                          /*  nûchster Sektor */
 addq.l #1,%d3
 cmp.l RtDrSec(%fp),%d3                  /*  Ende des DIRs? */
 jge FNXnf                              /*  DIR ist durch,nichts gefunden */
 move.l %d2,%d0
 lea dirbuff(%pc),%a0
 jbsr ReadSec                            /*  neuen Sektor lesen */
 tst.l %d0
 jmi FNXerr                             /*  Lesefehler */
FNX03:  
 lea dirbuff(%pc),%a1
 adda.l %d1,%a1
 tst.b (%a1)                             /*  letzter Eintrag? */
 jeq FNXnf                              /*  Ja */
 cmp.b #0xe5,(%a1)                       /*  leerer Eintrag */
 jeq FNX02                            /*  ja,dann nochmal */
 cmp.b #0x0f,DIRAttr(%a1)                /*  langer Dateiname? */
 jeq FNX02                            /*  ja,dann weiter */
 jbsr dircmp
 tst.l %d0
 jmi FNX02                            /*  nichts gefunden,nochmal */
 move.l %d1,ffpos(%a4)
 move.l %d2,ffsec(%a4)
 move.l %d3,ffsecc(%a4)
 clr.l %d0
 jra FNXex

FNX10:                                    /*  Sub-DIR Teil */
 move.l ffsecc(%a4),%d4                  /*  Sektorzûhler */
 move.l ffclus(%a4),%d3                  /*  akt. SubDIR-Cluster */
 move.l ffsec(%a4),%d2                   /*  akt. SubDIR-Sektor */
 move.l ffpos(%a4),%d1                   /*  akt. Position im Sektor */
FNX11:  
 add.l #32,%d1                          /*  nûchster Eintrag */
 cmp.l #512,%d1                         /*  Sektor durch? */
 jlt FNX15                            /*  nein */
 clr.l %d1                               /*  Position auf Null */
 addq.l #1,%d2                          /*  Sektor + 1 */
 addq.l #1,%d4                          /*  Sektorzûhler + 1 */
 cmp.b SPC(%fp),%d4                      /*  letzter Sektor im Cluster? */
 jlt FNX14                            /*  noch ein Sektor im Cluster */
 clr.l %d4                               /*  Sektorzûhler auf Null */
 move.l %d3,%d0                          /*  akt. Cluster */
 jbsr GNCN                               /*  GetNextClusterNumber */
 cmp.l eoClusCh(%fp),%d0                 /*  Ende des DIRs? */
 jge FNXnf                            /*  Ja */
 move.l %d0,%d3                          /*  neuer Cluster */
 jbsr GFSOC                              /*  GetFirstSektorOfCluster */
 move.l %d0,%d2                          /*  neuer Sektor */
FNX14:  
 lea dirbuff(%pc),%a0
 move.l %d2,%d0
 jbsr ReadSec
 tst.l %d0
 jmi FNXerr                           /*  Lesefehler */
FNX15:  
 lea dirbuff(%pc),%a1
 adda.l %d1,%a1
 tst.b (%a1)                             /*  letzter Eintrag? */
 jeq FNXnf                            /*  Ja */
 cmp.b #0xe5,(%a1)                       /*  leerer Eintrag */
 jeq FNX11                            /*  ja,dann nochmal */
 cmp.b #0x0f,DIRAttr(%a1)                /*  langer Dateiname? */
 jeq FNX11                            /*  ja,dann weiter */
 jbsr dircmp
 tst.l %d0
 jmi FNX11                            /*  nichts gefunden,nochmal */
 move.l %d1,ffpos(%a4)
 move.l %d2,ffsec(%a4)
 move.l %d3,ffclus(%a4)
 move.l %d4,ffsecc(%a4)
 clr.l %d0
 jra FNXex
FNXnf:  
 move.l #-1,ffpos(%a4)
 clr.l %d0
 jra FNXex
FNXerr:  
 move.l #-1,ffpos(%a4)
 move.l #-1,%d0
FNXex:  
 movem.l (%sp)+,%d1-%d4/%a0-%a1
 rts


dircmp:  
 movem.l %d3/%a0-%a2,-(%sp)
 movea.l %a1,%a2                         /*  sichern */
 lea parsdat(%pc),%a0
 move.l pflag(%a0),%d3
 btst.l #pfqdatn,%d3
 jeq dircmp30                           /*  kein Name,auch gut */
 adda.l #pqdatn,%a0                     /*  %a0 auf Name */
 move #8-1,%d3
dircmp01:  
 move.b (%a0)+,%d0
 jeq dircmp05                         /*  Name stimmt (die Lûnge auch?) */
  cmp.b #'*',%d0
 jeq dircmp10                         /*  Name stimmt */
 cmp.b #'?',%d0
 jne dircmp02
 addq.l #1,%a1
 jra dircmp03
dircmp02:  
 cmp.b (%a1)+,%d0
 jne dircmp20                         /*  Name stimmt nicht :-( */
dircmp03:  
 dbra %d3,dircmp01
 jra dircmp10                         /*  weiter mit Ext. */
dircmp05:  
 move.b (%a1),%d0
 jeq dircmp10                         /*  Lûnge stimmt auch :-D */
 cmp.b #' ',%d0
 jeq dircmp10                         /*  ist auch gut */
 jra dircmp20                           /*  ansonsten nicht gut */

dircmp10:                                 /*  Vergleich der Ext */
 addq.l #8,%a2
 lea parsdat(%pc),%a0
 move.l pflag(%a0),%d3
 btst.l #pfqdate,%d3                    /*  Extension da? */
 jeq dircmp30                         /*  nü */
 adda.l #pqdate,%a0                     /*  %a0 auf Dateiextension */
 move #3-1,%d3
dircmp11:  
 move.b (%a0)+,%d0
 jeq dircmp15                         /*  Ext stimmt (Lûnge auch?) */
  cmp.b #'*',%d0
 jeq dircmp30                         /*  Ext stimmt auch */
 cmp.b #'?',%d0
 jne dircmp12
 addq.l #1,%a2
 jra dircmp13
dircmp12:  
 cmp.b (%a2)+,%d0
 jne dircmp20                         /*  Ext stimmt nicht :-( */
dircmp13:  
 dbra %d3,dircmp11
 jra dircmp30
dircmp15:  
 move.b (%a2),%d0
 jeq dircmp30                         /*  Lûnge stimmt auch */
 cmp.b #' ',%d0
 jeq dircmp30                         /*  genauso gut */

dircmp20:  
 move.l #-1,%d0
 jra dircmpex
dircmp30:  
 clr.l %d0
dircmpex:  
 movem.l (%sp)+,%d3/%a0-%a2
 rts




 /* **** Allgemeine Unterprogramme ***** */

csts:                             /*  Wartet auf Tastendruck */
 movem.l %d0,-(%sp)
 jbsr key
 movem.l (%sp)+,%d0
 rts


key:                              /*  Wartet bis Taste gedrýckt */
 movem.l %d1-%d7/%a0-%fp,-(%sp)     /*  liefert Taste in %d0 zurýck */
key01:  
 move #13,%d7
 trap #1                                /*  CSTS */
 tst.b %d0
 jeq key01
 move #12,%d7
 trap #1                                /*  CI zum Status rýcksetzen */
 movem.l (%sp)+,%d1-%d7/%a0-%fp
 rts


ci:                               /*  Zeichen von Tastatur einlesen */
 movem.l %d1-%d7/%a0-%fp,-(%sp)
 move #12,%d7
 trap #1
 movem.l (%sp)+,%d1-%d7/%a0-%fp
 rts


cls:                              /*  Bildschirm lüschen */
 movem.l %d0-%d7/%a0-%fp,-(%sp)
 move #20,%d7
 trap #1
 movem.l (%sp)+,%d0-%d7/%a0-%fp
 rts


co2:                              /*  ein Zeichen holen */
 movem.l %d0-%d7/%a0-%fp,-(%sp)
 move #33,%d7
 trap #1
 movem.l (%sp)+,%d0-%d7/%a0-%fp
 rts

idetest:                          /*  IDE-Laufwerk testen/initialisieren */
 movem.l %d1-%d7/%a1-%fp,-(%sp)
 move #154,%d7
 trap #1
 movem.l (%sp)+,%d1-%d7/%a1-%fp
 rts

idedisk:                          /*  Zugiffe auf IDE-Laufwerke */
 movem.l %d1-%d7/%a0-%fp,-(%sp)
 move #155,%d7
 trap #1
 movem.l (%sp)+,%d1-%d7/%a0-%fp
 rts

sdtest:                           /*  SD-Laufwerk testen/initialisieren */
 movem.l %d1-%d7/%a1-%fp,-(%sp)
 move #163,%d7
 trap #1
 movem.l (%sp)+,%d1-%d7/%a1-%fp
 rts

sddisk:                           /*  Zugiffe auf SD-Laufwerke */
 movem.l %d1-%d7/%a0-%fp,-(%sp)
 move #164,%d7
 trap #1
 movem.l (%sp)+,%d1-%d7/%a0-%fp
 rts

writetxt:                         /*  Textausgabe bis 0x0 */
 movem.l %d0-%d7/%a0-%fp,-(%sp)
wrtxt01:  
 move.b (%a0)+,%d0
 jeq wrtxtex
 move #33,%d7                           /*  CO2 */
 trap #1
 jra wrtxt01
wrtxtex:  
 movem.l (%sp)+,%d0-%d7/%a0-%fp
 rts

tron:                             /*  Trace ON */
 move.l #1,trace(%a4)
 rts

troff:                            /*  Trace OFF */
 clr.l trace(%a4)
 rts

trout:                            /*  Trace OUT */
 tst.l trace(%a4)
 jeq troex
 jbsr regout
 jbsr csts
troex:  
 rts

regout:                           /*  Register-Ausgabe fýr trout */
 movem.l %d0-%d7/%a0-%fp,-(%sp)
 move.l %d0,-(%sp)
 move #10,%d0
 jbsr co2
 move #13,%d0
 jbsr co2
 move.l (%sp)+,%d0
 jbsr printl
 move #' ',%d0
 jbsr co2
 move.l %d1,%d0
 jbsr printl
 move #' ',%d0
 jbsr co2
 move.l %d2,%d0
 jbsr printl
 move #' ',%d0
 jbsr co2
 move.l %d3,%d0
 jbsr printl
 move #' ',%d0
 jbsr co2
 move.l %d4,%d0
 jbsr printl
 move #' ',%d0
 jbsr co2
 move.l %d5,%d0
 jbsr printl
 move #' ',%d0
 jbsr co2
 move.l %d6,%d0
 jbsr printl
 move #' ',%d0
 jbsr co2
 move.l %d7,%d0
 jbsr printl
 move #13,%d0
 jbsr co2
 move #10,%d0
 jbsr co2
 move.l %a0,%d0
 jbsr printl
 move #' ',%d0
 jbsr co2
 move.l %a1,%d0
 jbsr printl
 move #' ',%d0
 jbsr co2
 move.l %a2,%d0
 jbsr printl
 move #' ',%d0
 jbsr co2
 move.l %a3,%d0
 jbsr printl
 move #' ',%d0
 jbsr co2
 move.l %a4,%d0
 jbsr printl
 move #' ',%d0
 jbsr co2
 move.l %a5,%d0
 jbsr printl
 move #' ',%d0
 jbsr co2
 move.l %fp,%d0
 jbsr printl
 move #' ',%d0
 jbsr co2
 move.l %sp,%d0
 jbsr printl
 move #13,%d0
 jbsr co2
 move #10,%d0
 jbsr co2
 movem.l (%sp)+,%d0-%d7/%a0-%fp
 rts


printl:  
 movem.l %d0-%d7/%a0-%fp,-(%sp)
 lea buffer(%pc),%a0
 move #44,%d7                           /*  PRINT8X */
 trap #1
 lea buffer(%pc),%a0
 jbsr writetxt
 movem.l (%sp)+,%d0-%d7/%a0-%fp
 rts


print8d:  
 movem.l %d0-%d7/%a0-%fp,-(%sp)
 lea buffer(%pc),%a0
 move #70,%d7                           /*  PRINT8D */
 trap #1
 lea buffer(%pc),%a1
 move.l %a1,%d1
 adda.l #15,%a1
 addq.l #1,%a0
 move.b -(%a0),-(%a1)                    /*  die Endnull */
 move #14-1,%d3                         /*  13 weitere Bytes */
 clr %d2
prt8d01:  
 addq #1,%d2
 subq #1,%d3
 move.b -(%a0),-(%a1)
 cmpa.l %d1,%a0
 jeq prt8d02
 cmp #3,%d2
 jne prt8d01
 clr %d2
 subq #1,%d3
 move.b #'.',-(%a1)
 jra prt8d01
prt8d02:  
 move.b #' ',-(%a1)
 dbra %d3,prt8d02

 lea buffer(%pc),%a0
 jbsr writetxt
 movem.l (%sp)+,%d0-%d7/%a0-%fp
 rts

print4d:  
 movem.l %d0-%d7/%a0-%fp,-(%sp)
 lea buffer(%pc),%a0
 move.l #/*'    '*/0x20202020,(%a0)
 move #46,%d7                           /*  PRINT4D */
 trap #1
 move.b #' ',(%a0)                      /*  Endnull lüschen */
 lea buffer(%pc),%a0
 clr.b 4(%a0)                            /*  neue Endnull */
 jbsr writetxt
 movem.l (%sp)+,%d0-%d7/%a0-%fp
 rts

print2d:  
 movem.l %d0-%d7/%a0-%fp,-(%sp)
 lea buffer(%pc),%a0
 and #0x7f,%d0                           /*  nur noch 7 Bit (0-99) */
 move #46,%d7                           /*  PRINT4D */
 trap #1
 lea buffer(%pc),%a1
 addq.l #2,%a1
 move.l %a1,%d1
 cmpa.l %d1,%a0
 jeq prt2d02
 move.b (%a0),(%a1)
 move.b -(%a0),-(%a1)
 move.b #' ',-(%a1)
prt2d02:  
 lea buffer(%pc),%a0
 jbsr writetxt
 movem.l (%sp)+,%d0-%d7/%a0-%fp
 rts


print2d0:  
 movem.l %d0-%d7/%a0-%fp,-(%sp)
 lea buffer(%pc),%a0
 and #0x7f,%d0                           /*  nur noch 7 Bit (0-99) */
 move #46,%d7                           /*  PRINT4D */
 trap #1
 lea buffer(%pc),%a1
 addq.l #2,%a1
 move.l %a1,%d1
 cmpa.l %d1,%a0
 jeq prt2d002
 move.b (%a0),(%a1)
 move.b -(%a0),-(%a1)
 move.b #'0',-(%a1)
prt2d002:  
 lea buffer(%pc),%a0
 jbsr writetxt
 movem.l (%sp)+,%d0-%d7/%a0-%fp
 rts


wert:  
 movem.l %d1-%d7/%a1-%fp,-(%sp)
 move.l %a0,-(%sp)                       /*  %A0 auf den Stack */
 move #29,%d7
 trap #1
 jcs werterr
 addq.l #4,%sp                          /*  %A0 nicht zurýck,Stack aufrûumen */
 movem.l (%sp)+,%d1-%d7/%a1-%fp
 rts
werterr:  
 move.l #-1,%d0
 movea.l (%sp)+,%a0                      /*  %A0 zurýck vom Stack */
 movem.l (%sp)+,%d1-%d7/%a1-%fp
 rts



getuhr:  
 movem.l %d0-%d7/%a0-%fp,-(%sp)
 move #65,%d7
 trap #6                                /*  JADOS Uhr da auch virtuelle Uhr!!! */
 movem.l (%sp)+,%d0-%d7/%a0-%fp
 rts


delay500:  
 movem.l %d0-%d7/%a0-%fp,-(%sp)
 move #50,%d0
 move #35,%d7
 trap #1
 movem.l (%sp)+,%d0-%d7/%a0-%fp
 rts


strgcopy:                         /*  Kopiert %D0.l Bytes von (%a0) nach (%a1) */
 movem.l %a0-%a1,-(%sp)
 subq.l #1,%d0
sc00:  
 move.b (%a0)+,(%a1)+
 subq.l #1,%d0
 jpl sc00                             /*  dbra geht nur auf Wort!!! */
 movem.l (%sp)+,%a0-%a1
 rts


strgcmp:                          /*  Vergleicht %d0.l Bytes zwischen (%a0) und (%a1) */
 movem.l %a0-%a1,-(%sp)
 subq.l #1,%d0
scmp01:  
 cmpm.b (%a0)+,(%a1)+
 jne scmperr
 subq.l #1,%d0
 jpl scmp01                           /*  dbra geht nur bis Wort!!! */
 clr.l %d0                               /*  %d0=0 Strings sind gleich */
 jra scmpex
scmperr:  
 move.l #1,%d0                          /*  %d0=1 Strings sind nicht gleich */
scmpex:  
 movem.l (%sp)+,%a0-%a1
 rts


toupper:                          /*  Wandelt den Buchstabe in %d0 zu Groþbuchstabe */
 cmp.b #'a',%d0
 jlt tupex
 cmp.b #'z',%d0
 jgt tupex                            /*  nichts umzuwandeln */
 sub.b #0x20,%d0
tupex:  
 rts


bcdtobin:                         /*  wandelt 2 BCD Ziffern in %d0.b nach binûr */
 move.l %d1,-(%sp)
 clr.l %d1
 move.b %d0,%d1
 asr.b #4,%d1                           /*  oberes Nibbel */
 and.b #0xF,%d1
 mulu #10,%d1                           /*  *10 */
 and.b #0xf,%d0                          /*  unteres Nibbel */
 add.b %d1,%d0                           /*  addiert */
 move.l (%sp)+,%d1
 rts


JNA:                              /*  Abfrage Ja/Nein/Alle %a0 = Text */
                                /*  setzt JNAFlag Flag,%D0=-1 bei CTRL-C */
 movem.l %a0,-(%sp)
 clr.b JNAFlag(%a4)
 jbsr writetxt
 lea txtjna(%pc),%a0
 jbsr writetxt
 jbsr ci
 cmp.b #0x03,%d0                         /*  CTRL-C */
 jne JNA00
 move.l #-1,%d0
 jra JNAex1
JNA00:  
 jbsr toupper
 cmp.b #'A',%d0                         /*  Alle */
 jne JNA01
 move.b #2,JNAFlag(%a4)
 jra JNAex
JNA01:  
 cmp.b #'J',%d0                         /*  Ja */
 jne JNAex
 move.b #1,JNAFlag(%a4)
JNAex:  
 jbsr co2                                /*  Eingabe ausgeben */
 clr.l %d0
JNAex1:  
 movem.l (%sp)+,%a0
 rts


JN:                               /*  Abfrage Ja/Nein %a0 = Text */
                                /*  setzt JNAFlag %D0=-1 bei CTRL-C */
 move.l %a0,-(%sp)
 clr.b JNAFlag(%a4)                       /*  Nein und der Rest */
 jbsr writetxt
 lea txtjn(%pc),%a0
 jbsr writetxt
 jbsr ci
 cmp.b #0x03,%d0                         /*  CTRL-C */
 jne JN01
 move.l #-1,%d0
 jra JNex1
JN01:  
 jbsr toupper
 cmp.b #'J',%d0                         /*  Ja */
 jne JNex
 move.b #1,JNAFlag(%a4)
JNex:  
 jbsr co2                                /*  Eingabe ausgeben */
 clr.l %d0
JNex1:  
 movea.l (%sp)+,%a0
 rts


NameOut:                          /*  Gibt Name.Ext von FileDsct aus */
                                /*  %d0 = FileID */
 movem.l %d0/%d3/%a0-%a2,-(%sp)
 jbsr FileDsct
 movea.l %a0,%a1
 lea buffer(%pc),%a2
 adda.l #FileName,%a0
 move #8-1,%d3
NO01:  
 move.b (%a0)+,%d0
 cmp.b #' ',%d0
 jeq NO02                             /*  Ende vom Name */
 move.b %d0,(%a2)+                       /*  in Buffer */
 dbra %d3,NO01
NO02:  
 move.b #'.',(%a2)+                     /*  der Punkt */
 adda.l #FileExt,%a1
 move #3-1,%d3
NO03:  
 move.b (%a1)+,%d0
 cmp.b #' ',%d0
 jeq NO04
 move.b %d0,(%a2)+
 dbra %d3,NO03
NO04:  
 move.b #' ',(%a2)+                     /*  ein Leerzeichen */
 clr.b (%a2)                             /*  und ne Null */
 lea buffer(%pc),%a0
 jbsr writetxt
 movem.l (%sp)+,%d0/%d3/%a0-%a2
 rts


trap10:  
 movem.l %d1-%d7/%a1-%fp,-(%sp)             /*  %d0/%a0 werden NICHT gesichert */
 cmp #trapanz,%d7
 jge trap10ex                         /*  Fehler,ungýltige Trapnummer */
 lea allgm(%pc),%a4                      /*  %a4 wiederherstellen */
 clr.l errnum(%a4)                       /*  Fehlernummer lüschen */
 move.b hdnum(%a4),%d0
 jbsr SetLW                              /*  %fp wiederherstellen */
 lea traptab(%pc),%a2
 asl #2,%d7                             /*  *4 fýr Langwort */
 adda.l 0(%a2,%d7.w),%a2
 jbsr (%a2)
trap10ex:  
 movem.l (%sp)+,%d1-%d7/%a1-%fp
 /* rte */
 rts




 /* **** JADOS Aufrufe/Prozeduren ***** */

jclrfcb:                          /*  lüscht den FileControlBlock */
 movem.l %d3/%a0,-(%sp)
 lea jfcb(%pc),%a0
 move.l #48-1,%d3
jcf01:  
 clr.b (%a0)+
 dbra %d3,jcf01
 movem.l (%sp)+,%d3/%a0
 rts

jfinfo:                           /*  JADOS File Info */
 movem.l %d4-%d7/%a1-%fp,-(%sp)
 lea jfcb(%pc),%a1
 move #71,%d7
 trap #6
 movem.l (%sp)+,%d4-%d7/%a1-%fp
 rts

jfillfcb:                         /*  Dateiname.Ext0 in (%a0) */
 movem.l %d1-%d7/%a0-%fp,-(%sp)
 lea jfcb(%pc),%a1
 move #18,%d7
 trap #6
 movem.l (%sp)+,%d1-%d7/%a0-%fp
 rts

jfload:                           /*  Lûdt eine Datei nach (%a0) */
 movem.l %d1-%d7/%a0-%fp,-(%sp)
 lea jfcb(%pc),%a1
 move #44,%d7
 trap #6
 and.l #0xff,%d0                         /*  auf Langwort */
 tst.b %d0
 jeq jfldex
 cmp.b #2,%d0                           /*  Datei da? */
 jne jfld01
 move.l #-1,%d0
 move.l #16,errnum(%a4)
 jra jfldex
jfld01:  
 cmp.b #99,%d0                          /*  genug Speicher? */
 jne jfld02
 move.l #-1,%d0
 move.l #19,errnum(%a4)
jfld02:  
 move.l #-1,%d0
 move.l #20,errnum(%a4)
jfldex:  
 movem.l (%sp)+,%d1-%d7/%a0-%fp
 rts

jfsave:                           /*  Speichert die Datei in (%a0) */
 movem.l %d1-%d7/%a0-%fp,-(%sp)
 lea jfcb(%pc),%a1
 clr.l %d1
 move JDatL(%a1),%d1                     /*  Dateilûnge nach %d1 */
 subq #1,%d1                            /*  -1 */
 move #45,%d7
 trap #6
 and.l #0xff,%d0                         /*  auf Langwort */
 tst.b %d0
 jeq jfsvex
 cmp.b #5,%d0                           /*  Disk voll? */
 jne jfsv01
 move.l #-1,%d0
 move.l #21,errnum(%a4)
 jra jfsvex
jfsv01:  
 cmp.b #6,%d0                           /*  DIR voll? */
 jne jfsv02
 move.l #-1,%d0
 move.l #22,errnum(%a4)
 jra jfsvex
jfsv02:  
 move.l #-1,%d0
 move.l #20,errnum(%a4)
jfsvex:  
 movem.l (%sp)+,%d1-%d7/%a0-%fp
 rts

jmotoff:                          /*  Schaltet den Diskettenmotor aus */
 movem.l %d0-%d7/%a0-%fp,-(%sp)
 move #5,%d7
 trap #6
 movem.l (%sp)+,%d0-%d7/%a0-%fp
 rts

jusradr:                          /*  Liefert die Adresse des Userbereichs in %A0 */
 movem.l %d0-%d7/%a1-%fp,-(%sp)
 move #58,%d7
 trap #6
 movem.l (%sp)+,%d0-%d7/%a1-%fp
 rts

jconvlw:                          /*  Convertiert die LW-Bezeichnug nach Binûr */
                                /*  %d0.b = 0-4/A-Z -> %d0.b = 0-4/5-30 */
 and.l #0xff,%d0                 /*  auf Langwort */
 cmp.b #0x30,%d0
 jlt jclwerr
 cmp.b #0x34,%d0
 jgt jclw01
 sub.b #0x30,%d0
 jra jclwex
jclw01:  
 cmp.b #0x41,%d0
 jlt jclwerr
 cmp.b #0x5a,%d0
 jgt jclwerr
 sub.b #0x3c,%d0
 jra jclwex
jclwerr:  
 move.l #-1,%d0
 move.l #23,errnum(%a4)
jclwex:  
 rts



JMDL:                             /*  JadosMakeDirList legt die Liste der */
                                /*  Jados Datein in jdirbuf,Anzahl in %d0 */
 movem.l %d1-%d7/%a0-%fp,-(%sp)
 lea parsdat(%pc),%a0
 movea.l %a0,%a2
 lea buffer(%pc),%a1
 adda.l #pqlw,%a0                       /*  Quell Laufwerk */
 move.b (%a0),(%a1)+
 move.b #':',(%a1)+                     /*  der Doppelpunkt */
 movea.l %a2,%a0
 adda.l #pqdatn,%a0                     /*  Quell Dateiname */
 move #8-1,%d3
JMDL01:  
 move.b (%a0)+,%d0                       /*  Dateiname */
 tst.b %d0                               /*  zu Ende? */
 jeq JMDL02                           /*  jo */
 cmp.b #' ',%d0                         /*  Space auch Ende */
 jeq JMDL02
 move.b %d0,(%a1)+                       /*  sonst speichern */
 dbra %d3,JMDL01                        /*  nûchstes Zeichen */
JMDL02:  
 move.b #'.',(%a1)+                     /*  der Punkt */
 adda.l #pqdate,%a2                     /*  Extension */
 move #3-1,%d3
JMDL03:  
 move.b (%a2)+,%d0                       /*  Dateiextension */
 tst.b %d0                               /*  zu Ende? */
 jeq JMDL04                           /*  jo */
 cmp.b #' ',%d0                         /*  Space auch Ende */
 jeq JMDL04
 move.b %d0,(%a1)+                       /*  sonst speichern */
 dbra %d3,JMDL03                        /*  nûchstes Zeichen */
JMDL04:  
 clr.b (%a1)                             /*  zum Schluss noch ne NULL */

 lea buffer(%pc),%a1                     /*  Puffer mit Name */
 lea jdirbuf(%pc),%a0                    /*  der DIR-Puffer */
 move #0x1000,%d1                        /*  4kB DIR-Puffer */
 clr %d2                                 /*  nur Dateinamen */
 move.l #1,%d3                           /*  eine Spalte */
 move #74,%d7                           /*  Jados directory */
 trap #6
 tst.b %d0                               /*  Alles OK? */
 jne JMDLerr                          /*  nü Fehler */

 lea jdirbuf(%pc),%a0
 clr.l %d0
JMDL05:  
 cmp.b #' ',0(%a0,%d0.w)
 jle JMDL06                           /*  kleiner/gleich Space = Ende */
 add #16,%d0                            /*  nûchster Name */
 cmp #4096,%d0                          /*  Ende des Puffers? */
 jge JMDL06                           /*  jo */
 jra JMDL05                           /*  weiter */
JMDL06:  
 lsr.l #4,%d0                           /*  /16 als Zûhler */
 jra JMDLex
JMDLerr:  
 move.l #-1,%d0
 move.l #14,errnum(%a4)
JMDLex:  
 movem.l (%sp)+,%d1-%d7/%a0-%fp
 rts


JMFN:                             /*  JadosMakeFileName / jdirbuf=Name.Ext */
                                /*  %d0 = DIR Nummer */
                                /*  copiert den Dateiname/ext. in den FCB */
 movem.l %d0/%d3/%a0-%a3,-(%sp)
 lea jdirbuf(%pc),%a1
 asl.l #4,%d0                           /*  *16 als Offset */
 adda.l %d0,%a1                          /*  %a1 auf Dateiname */
 lea jfcb(%pc),%a0
 movea.l %a0,%a3
 adda.l #JDName,%a0
 move #8-1,%d3
JMFN01:  
 move.b #' ',(%a0)+                     /*  Name mit Space fýllen */
 dbra %d3,JMFN01
 movea.l %a3,%a0
 adda.l #JDExt,%a0
 move.b #' ',(%a0)+                     /*  Ext mit Space fýllen */
 move.b #' ',(%a0)+
 move.b #' ',(%a0)
 movea.l %a3,%a0
 adda.l #JDName,%a0
JMFN03:  
 move #8,%d3                            /*  9 Zeichen NAME+. */
JMFN04:  
 move.b (%a1)+,%d0
 cmp.b #'.',%d0                         /*  Ende Dateiname? */
 jeq JMFN10
 move.b %d0,(%a0)+
 dbra %d3,JMFN04
JMFN10:  
 movea.l %a3,%a0
 adda.l #JDExt,%a0
JMFN12:  
 move.b (%a1)+,(%a0)+                    /*  Extension kopieren */
 move.b (%a1)+,(%a0)+
 move.b (%a1)+,(%a0)+
JMFNex:  
 movem.l (%sp)+,%d0/%d3/%a0-%a3
 rts

jtom:                             /*  Kopiert/konvertiert den FCB nach FileDsct */
 movem.l %d1/%d3/%a0-%a3,-(%sp)
 jbsr FFFD                               /*  FindFreeFileDiscriptor */
 tst.l %d0
 jmi jtomerr                            /*  kein freier Datei Hûndel */
 move.l %d0,%d1                          /*  FileID sichern */
 jbsr FileDsct                           /*  FileDiscriptor in %a0 */
 movea.l %a0,%a2                         /*  sichern nach %a2 */
 lea jfcb(%pc),%a1                       /*  FCB in %a1 */
 movea.l %a1,%a3                         /*  sichern nach %a3 */
 adda.l #FileName,%a0
 adda.l #JDName,%a1
 move #8-1,%d3
jtom01:  
 move.b (%a1)+,(%a0)+                    /*  Dateiname kopieren */
 dbra %d3,jtom01
 movea.l %a2,%a0                         /*  FileDiscriptor zurýck */
 movea.l %a3,%a1                         /*  FCB zurýck */
 adda.l #FileExt,%a0
 adda.l #JDExt,%a1
 move.b 0(%a1),0(%a0)                    /*  Extension kopieren */
 move.b 1(%a1),1(%a0)
 move.b 2(%a1),2(%a0)
 move %d1,%d0                            /*  FileID zurýck */
 jbsr FindName
 cmp.l #FULL_MAT,%d0                    /*  Datei vorhanden */
 jne jtom02                           /*  nein */
 cmp.b #2,JNAFlag(%a4)                  /*  Alle ýberschreiben? */
 jeq jtom01a                          /*  ja! */
 tst.b quiet(%a4)
 jne jtomerr2                           /*  keine Ausgabe */
 lea txtcrlf(%pc),%a0                    /*  CRLF vorweg */
 jbsr writetxt
 move %d1,%d0
 jbsr NameOut
 lea txtueber(%pc),%a0
 jbsr JNA                                /*  Ja/Nein/Alle */
 tst.l %d0                               /*  Abbruch? */
 jmi jtomerr3                         /*  ja */
 cmp.b #2,JNAFlag(%a4)                  /*  Alle? */
 jeq jtom01a                          /*  jo */
 tst.b JNAFlag(%a4)                      /*  Nein? */
 jeq jtomerr2                         /*  jo Fehler aber weiter */
 clr.b JNAFlag(%a4)                      /*  ansonsten Ja zurýcksetzen */
jtom01a:  
 move.l %d1,%d0                          /*  FileID zurýck */
 jbsr rem                                /*  Datei lüschen */
 tst.l %d0
 jne jtomerr1                         /*  Fehler beim lüschen */
 move.b FileName(%a2),%d3                /*  erster Buchstabe des Namen */
 move.b #0xe5,FileName(%a2)              /*  Name gelüscht */
 clr.l FileSize(%a2)                     /*  Dateigrüsse = 0 */
 clr.l File1C(%a2)                       /*  ersterCluster = 0 */
 clr.b FileAttr(%a2)                     /*  Attribute = 0 */
 move.l %d1,%d0                          /*  FileID zurýck */
 jbsr UFE                                /*  UpdateFileEntry */
 tst.l %d0
 jmi jtomerr1
 move.b %d3,FileName(%a2)                /*  erster Buchstabe zurýck ;-) */
jtom02:  
 move.l %d1,%d0                          /*  FileID zurýck */
 jbsr MNFE                               /*  MakeNewFileEntry */
 tst.l %d0
 jmi jtomerr1
 clr.l %d0
 move JDatL(%a3),%d0                     /*  Dateilûnge in Sektoren */
 asl.l #8,%d0                           /*  *256 */
 asl.l #2,%d0                           /*  *4 = *1024 (Sektorlûnge) */
 move.l %d0,FileSize(%a2)                /*  in FileDsct */
 move.l %d1,%d0                          /*  FileID zurýck */
 jra jtomex
jtomerr3:  
 clr.b FileFlag(%a2)                     /*  FileID dicht */
 move.l #-3,%d0                         /*  Abbruch */
 jra jtomex
jtomerr2:  
 clr.b FileFlag(%a2)                     /*  FileID dicht */
 move.l #-2,%d0                         /*  Fehler aber weitermachen */
 jra jtomex
jtomerr1:  
 clr.b FileFlag(%a2)                     /*  FileID dicht */
jtomerr:  
 move.l #-1,%d0
jtomex:  
 movem.l (%sp)+,%d1/%d3/%a0-%a3
 rts


mtoj:                             /*  Kopiert/Konvertiert den FileDsct nach FCB */
                                /*  %d0 = FileID */
 movem.l %d0/%d3/%a0-%a3,-(%sp)
 jbsr FileDsct                           /*  FileDiscriptor in %a0 */
 movea.l %a0,%a2                         /*  nach %a2 sichern */
 jbsr jclrfcb                            /*  FCB lüschen */
 lea jfcb(%pc),%a1                       /*  FCB in %a1 */
 movea.l %a1,%a3                         /*  nach %a3 sichern */
 adda.l #FileName,%a0                   /*  %a0 auf Filename */
 adda.l #JDName,%a1                     /*  %a1 auf JFilename */
 move #8-1,%d3                          /*  Zûhler */
mtoj01:  
 move.b (%a0)+,(%a1)+                    /*  Name kopieren */
 dbra %d3,mtoj01
 movea.l %a2,%a0                         /*  FileDsct zurýck */
 movea.l %a3,%a1                         /*  FCB zurýck */
 adda.l #FileExt,%a0
 adda.l #JDExt,%a1                     
 move.b 0(%a0),0(%a1)
 move.b 1(%a0),1(%a1)
 move.b 2(%a0),2(%a1)                    /*  Ext kopiert */
 move.l FileSize(%a2),%d0                /*  Dateigrüsse in Byte */
 move.l %d0,%d3
 lsr.l #8,%d0                           /*  /256 */
 lsr.l #2,%d0                           /*  /4 -> /1024 (Sektorgrüsse) */
 and.l #0x3ff,%d3
 tst %d3                                 /*  noch ein Teilsektor? */
 jeq mtoj02                           /*  nü */
 addq.l #1,%d0                          /*  Ansonsten 1 Sektor mehr */
mtoj02:  
 move %d0,JDatL(%a3)                     /*  Grüsse in Sektoren */
 movem.l (%sp)+,%d0/%d3/%a0-%a3
 rts



 /* **** User IOs ***** */

parser:  
 movem.l %d1-%d7/%a0-%a2,-(%sp)

 jbsr parsclr                            /*  Parserspeicher lüschen */

 lea parsdat(%pc),%a1
 move.l pflag(%a1),%d6                   /*  Parser Flag */
 tst.b (%a0)
 jeq parsex                             /*  keine Parameter */

pars02:                                   /*  fýhrende Leerzeichen entfernen */
 cmp.b #' ',(%a0)+
 jeq pars02
 subq.l #1,%a0
 tst.b (%a0)
 jeq parsex                             /*  nichts nach den Leerzeichen */

 cmp.b #'-',(%a0)                       /*  Optionen? */
 jne pars04
 addq.l #1,%a0                          /*  Zeichen nach '-' */
pars02a:  
 tst.b (%a0)                             /*  ne Null? */
 jeq parsex                             /*  ja! */
 move.l popt(%a1),%d5                    /*  Optionen in %d5 */
 move.b (%a0)+,%d0                       /*  Option laden */
 sub.b #0x40,%d0                         /*  in Nummer umwandeln A=1...Z=26 */
 jmi pars03                           /*  Ungýltige Option <@ */
 cmp.b #26,%d0
 jgt pars03                           /*  Ungýltige Option >Z */
 bset.l %d0,%d5                          /*  Optionsbit setzten */
 move.l %d5,popt(%a1)                    /*  Optionen abspeichern */
 bset.l #pfopt,%d6                      /*  Options-Flag setzen */
 cmp.b #' ',(%a0)                       /*  Space -> keine weiteren Optionen */
 jeq pars03
 cmp.b #'-',(%a0)
 jne pars02a
pars02b:  
 addq.l #1,%a0                          /*  Zeichen nach '-' */
 jra pars02a

pars03:                                   /*  Leerzeichen raus */
 cmp.b #' ',(%a0)+
 jeq pars03
 subq.l #1,%a0                          /*  wieder auf nicht Leerzeichen */
 cmp.b #'-',(%a0)                      
 jeq pars02b                          /*  doch noch ne Option! */

pars04:                                   /*  Quell Laufwerk */
 cmp.b #':',1(%a0)                      /*  ":" als 2.Zeichen */
 jne pars04a                          /*  nü,kein JADOS */
 bset.l #pfqlw,%d6                      /*  Quell-Laufwerks Flag setzen */
 move.b 0(%a0),pqlw(%a1)                 /*  JADOS Laufwerk */
 move.b #'J',pqtyp(%a1)                 /*  Typ JADOS */
 addq.l #2,%a0                          /*  Zeichen nach Laufwerk */
 tst.b (%a0)                             /*  Ende? */
 jeq parsex                             /*  Ja! */
 jra pars04ex

pars04a:  
 tst.b 1(%a0)                            /*  2. Zeichen Null? */
 jeq pars04ex                           /*  Ja */
 cmp.b #' ',1(%a0)                      /*  2. Zeichen SPACE? */
 jeq pars04ex                           /*  Ja */
 tst.b 2(%a0)                            /*  3. Zeichen Null? */
 jeq pars04ex                           /*  Ja */
 cmp.b #' ',2(%a0)                      /*  3. Zeichen SPACE? */
 jeq pars04ex                           /*  Ja */
 cmp.b #':',3(%a0)                      /*  ":" als 4. Zeichen ? */
 jne pars04b                          /*  nü */
 bset.l #pfqlw,%d6                      /*  Quell-Laufwerks Flag setzen */
 move.b #'M',pqtyp(%a1)                 /*  Typ MS */
 move.b (%a0)+,pqlw(%a1)
 move.b (%a0)+,pqlw+1(%a1)
 move.b (%a0)+,pqlw+2(%a1)
 addq.l #1,%a0                          /*  nach : */
 tst.b (%a0)                             /*  Ende? */
 jeq parsex                             /*  Ja! */
 jra pars04ex

pars04b:  
 tst.b 3(%a0)                            /*  4. Zeichen Null? */
 jeq pars04ex                           /*  Ja */
 cmp.b #' ',3(%a0)                      /*  4. Zeichen SPACE? */
 jeq pars04ex                           /*  Ja */
 cmp.b #':',4(%a0)                      /*  ":" als 5. Zeichen ? */
 jne pars04c                          /*  nü */
 bset.l #pfqlw,%d6                      /*  Quell-Laufwerks Flag setzen */
 move.b #'M',pqtyp(%a1)                 /*  Typ MS */
 move.b (%a0)+,pqlw(%a1)
 move.b (%a0)+,pqlw+1(%a1)
 move.b (%a0)+,pqlw+2(%a1)
 move.b (%a0)+,pqlw+3(%a1)
 addq.l #1,%a0                          /*  nach : */
 tst.b (%a0)                             /*  Ende? */
 jeq parsex                             /*  Ja! */
 jra pars04ex

pars04c:  
 tst.b 4(%a0)                            /*  5. Zeichen Null? */
 jeq pars04ex                           /*  Ja */
 cmp.b #' ',4(%a0)                      /*  5. Zeichen SPACE? */
 jeq pars04ex                           /*  Ja */
 cmp.b #':',5(%a0)                      /*  ":" als 6. Zeichen ? */
 jne pars05                           /*  nü,kein Laufwerk */
 bset.l #pfqlw,%d6                      /*  Quell-Laufwerks Flag setzen */
 move.b #'M',pqtyp(%a1)                 /*  Typ MS */
 move.b (%a0)+,pqlw(%a1)
 move.b (%a0)+,pqlw+1(%a1)
 move.b (%a0)+,pqlw+2(%a1)
 move.b (%a0)+,pqlw+3(%a1)
 move.b (%a0)+,pqlw+4(%a1)
 addq.l #1,%a0                          /*  nach : */
 tst.b (%a0)                             /*  Ende? */
 jeq parsex

pars04ex:  
 cmp.b #' ',(%a0)+                      /*  Leerzeichen raus */
 jeq pars04ex
 subq.l #1,%a0                          /*  wieder auf nicht Leerzeichen */

pars05:                                   /*  frei fýr Pfad */

pars06:                                   /*  Quell-Dateiname */
 movea.l %a1,%a2
 adda.l #pqdatn,%a2                     /*  %a2 auf Quell Dateiname */
 cmp.b #'.',(%a0)                       /*  "." zum Anfang? */
 jne pars06z                          /*  nü */
 bset.l #pfqdatn,%d6                    /*  Quell-Dateiname Flag setzen */
 move.b (%a0)+,(%a2)+
 cmp.b #'.',(%a0)                       /*  noch n "." */
 jne parsex                             /*  nü dann schluss */
 move.b (%a0)+,(%a2)+
 jra parsex                             /*  hier ist Schluss! */
pars06z:  
 move #8-1,%d3                          /*  maximal 8 Zeichen */
 bset.l #pfqdatn,%d6                    /*  Quell-Dateiname Flag setzen */
pars06a:  
 move.b (%a0)+,%d0
 jeq parsex                             /*  String durch */
 cmp.b #'.',%d0
 jeq pars07                           /*  Quell-Dateiname durch */
 move.b %d0,(%a2)+                       /*  Zeichen speichern */
 dbra %d3,pars06a
 tst.b (%a0)
 jeq parsex                             /*  Ende! */
 cmp.b #'.',(%a0)
 jne pars06b
 addq.l #1,%a0
 jra pars07
pars06b:  
 cmp.b #' ',(%a0)                       /*  Leerzeichen? */
 jeq pars08                           /*  Ja,dann keine Extension! */

pars07:                                   /*  Quell-Dateiextension */
 movea.l %a1,%a2
 adda.l #pqdate,%a2                     /*  %a2 auf Quell-Dateiextension */
 move #3-1,%d3                          /*  max. 3 Zeichen */
 bset.l #pfqdate,%d6                    /*  Quell-Dateiextension Flag setzen */
pars07a:  
 move.b (%a0)+,%d0
 jeq parsex                             /*  Ende String */
 cmp.b #' ',%d0                         /*  Leerzeichen? */
 jeq pars07ex                         /*  Ja! */
 move.b %d0,(%a2)+                       /*  Zeichen speichern */
 dbra %d3,pars07a
 tst.b (%a0)                             /*  Null? */
 jeq parsex                             /*  dann Schluss */
pars07ex:  
 cmp.b #' ',(%a0)+                      /*  Leerzeichen raus */
 jeq pars07ex
 subq.l #1,%a0                          /*  zurýck auf nicht Leerzeichen */
 tst.b (%a0)                             /*  Ende? */
 jeq parsex                             /*  Ja! */

pars08:                                   /*  1. Adresswert */
 cmp.b #'#',(%a0)
 jne pars10                           /*  keine Adresswert */
 addq.l #1,%a0
 jbsr wert
 cmp.l #-1,%d0
 jne pars08a                          /*  kein Fehler */
 move.l #28,errnum(%a4)
 jra parserr
pars08a:  
 bset.l #pfadr1,%d6                     /*  Adresswert1 Flag setzen */
 move.l %d0,padr1(%a1)                   /*  Adresswert1 speichern */
pars08ex:  
 cmp.b #' ',(%a0)+                      /*  Leerzeichen raus */
 jeq pars08ex
 subq.l #1,%a0                          /*  zurýck auf nicht Leerzeichen */
 tst.b (%a0)                             /*  Ende? */
 jeq parsex                             /*  Ja! */

pars10:                                   /*  Ziel Laufwerk */
 cmp.b #':',1(%a0)                      /*  ":" als 2.Zeichen */
 jne pars10a                          /*  nü,kein JADOS */
 bset.l #pfzlw,%d6                      /*  Ziel-Laufwerks Flag setzen */
 move.b 0(%a0),pzlw(%a1)                 /*  JADOS Laufwerk */
 move.b #'J',pztyp(%a1)                 /*  Typ JADOS */
 addq.l #2,%a0                          /*  Zeichen nach Laufwerk */
 tst.b (%a0)                             /*  Ende? */
 jeq parsex                             /*  Ja! */
 jra pars10ex

pars10a:  
 cmp.b #':',3(%a0)                      /*  ":" als 4. Zeichen ? */
 jne pars10b                          /*  nü */
 bset.l #pfzlw,%d6                      /*  Ziel-Laufwerks Flag setzen */
 move.b #'M',pztyp(%a1)                 /*  Typ MS */
 move.b (%a0)+,pzlw(%a1)
 move.b (%a0)+,pzlw+1(%a1)
 move.b (%a0)+,pzlw+2(%a1)
 addq.l #1,%a0                          /*  nach : */
 tst.b (%a0)                             /*  Ende? */
 jeq parsex                             /*  Ja! */
 jra pars10ex

pars10b:  
 cmp.b #':',4(%a0)                      /*  ":" als 5. Zeichen ? */
 jne pars10c                          /*  nü */
 bset.l #pfzlw,%d6                      /*  Ziel-Laufwerks Flag setzen */
 move.b #'M',pztyp(%a1)                 /*  Typ MS */
 move.b (%a0)+,pzlw(%a1)
 move.b (%a0)+,pzlw+1(%a1)
 move.b (%a0)+,pzlw+2(%a1)
 move.b (%a0)+,pzlw+3(%a1)
 addq.l #1,%a0                          /*  nach : */
 tst.b (%a0)                             /*  Ende? */
 jeq parsex                             /*  Ja! */
 jra pars10ex

pars10c:  
 cmp.b #':',5(%a0)                      /*  ":" als 6. Zeichen ? */
 jne pars11                           /*  nü,kein Laufwerk */
 bset.l #pfzlw,%d6                      /*  Ziel-Laufwerks Flag setzen */
 move.b #'M',pztyp(%a1)                 /*  Typ MS */
 move.b (%a0)+,pzlw(%a1)
 move.b (%a0)+,pzlw+1(%a1)
 move.b (%a0)+,pzlw+2(%a1)
 move.b (%a0)+,pzlw+3(%a1)
 move.b (%a0)+,pzlw+4(%a1)
 addq.l #1,%a0                          /*  nach : */
 tst.b (%a0)                             /*  Ende? */
 jeq parsex

pars10ex:  
 cmp.b #' ',(%a0)+                      /*  Leerzeichen raus */
 jeq pars10ex
 subq.l #1,%a0                          /*  wieder auf nicht Leerzeichen */

pars11:                                   /*  frei fýr Pfad */

pars12:                                   /*  Ziel-Dateiname */
 cmp.b #'.',(%a0)                       /*  "." zum Anfang? */
 jeq parsex                             /*  geht nicht! */
 movea.l %a1,%a2
 adda.l #pzdatn,%a2                     /*  %a2 auf Ziel Dateiname */
 move #8-1,%d3                          /*  maximal 8 Zeichen */
 bset.l #pfzdatn,%d6                    /*  Ziel-Dateiname Flag setzen */
pars12a:  
 move.b (%a0)+,%d0
 jeq parsex                           /*  String durch */
 cmp.b #'.',%d0
 jeq pars13                           /*  Ziel-Dateiname durch */
 move.b %d0,(%a2)+                       /*  Zeichen speichern */
 dbra %d3,pars12a
 tst.b (%a0)
 jeq parsex                             /*  Ende! */
 cmp.b #'.',(%a0)
 jne pars12b
 addq.l #1,%a0
 jra pars13
pars12b:  
 cmp.b #' ',(%a0)                       /*  Leerzeichen? */
 jeq parsex                           /*  Ja,dann keine Extension! */

pars13:                                   /*  Ziel-Dateiextension */
 movea.l %a1,%a2
 adda.l #pzdate,%a2                     /*  %a2 auf Ziel-Dateiextension */
 move #3-1,%d3                          /*  max. 3 Zeichen */
 bset.l #pfzdate,%d6                    /*  Ziel-Dateiextension Flag setzen */
pars13a:  
 move.b (%a0)+,%d0
 jeq parsex                             /*  Ende String */
 cmp.b #' ',%d0                         /*  Leerzeichen? */
 jeq parsex                           /*  Ja! Dann Ende */
 move.b %d0,(%a2)+                       /*  Zeichen speichern */
 dbra %d3,pars13a

pars14:                                   /*  2. Adresswert */
 cmp.b #'#',(%a0)
 jne parsex                           /*  keine Adresswert */
 addq.l #1,%a0
 jbsr wert
 cmp.l #-1,%d0
 jne pars14a                          /*  kein Fehler */
 move.l #28,errnum(%a4)
 jra parserr
pars14a:  
 bset.l #pfadr2,%d6                     /*  Adresswert2 Flag setzen */
 move.l %d0,padr2(%a1)                   /*  Adresswert2 speichern */

                                        /*  Was danach kommt? Wen interessierts? */
parsex:  
 clr.l %d0
 move.l %d6,pflag(%a1)                   /*  Parser Flag sichern */
 movem.l (%sp)+,%d1-%d7/%a0-%a2
 rts

parserr:  
 jbsr error
 move.l #-1,%d0
 jbsr parsclr
 movem.l (%sp)+,%d1-%d7/%a0-%a2
 rts

parsclr:                                  /*  Parserspeicher lüschen */
 movem.l %d3/%a1,-(%sp)
 lea parsdat(%pc),%a1
 move #64-1,%d3
parsclr1:                                 /*  Parser Daten lüschen */
 clr.b (%a1)+
 dbra %d3,parsclr1
 movem.l (%sp)+,%d3/%a1
 rts

mdiska:                           /*  Zeigt die vorhandenen FS-Typ Laufwerke */
 movem.l %d0/%d1/%d3/%d6/%a0/%a1,-(%sp)
 tst.l hdbtfild(%a4)                     /*  ein Laufwerk vorhanden? */
 jeq mdaex                              /*  nü */
 clr %d1
 /* jbsr parser */
 move.l #1,%d0
 jbsr option
 jne mdaex

mda00a:  
 lea parsdat(%pc),%a0
 move.l pflag(%a0),%d3
 btst.l #pfqlw,%d3
 jeq mda00                            /*  keine LW Parameter */
 cmp.b #'M',pqtyp(%a0)                  /*  MS? */
 jne mda00                            /*  nü */
 jbsr hdpars
 tst.l %d0
 jne mdaerr
 cmp aktlw(%a4),%d1
 jeq mda00                            /*  ist aktuelles LW */
 move %d1,aktlw(%a4)
 jbsr LoadLW                             /*  ansonsten neu laden */
mda00:                                    /*  Laufwerks Liste */
 move.l hdbtfild(%a4),%d6
 move #32-1,%d3                         /*  auf alle 32 Laufwerke testen */
 clr.l %d0                               /*  Nummer des gefundenen LWs */
mda01:  
 asr.l #1,%d6
 jcc mda02
 jbsr mdiskb                             /*  Ausgabe */
mda02:  
 addq #1,%d0                            /*  sonst nûchstes LW */
 dbra %d3,mda01
 lea txtcrlf(%pc),%a0
 jbsr writetxt
 lea txtaktlw(%pc),%a0
 jbsr writetxt
 jra mdaex
mdaerr:  
 lea txtnv(%pc),%a0
 jbsr writetxt
mdaex:  
 movem.l (%sp)+,%d0/%d1/%d3/%d6/%a0/%a1
 rts


mdiskb:  
 move.l %d0,-(%sp)
 lea hdtab(%pc),%a0                      /*  Laufwerk-Tabelle */
 mulu #6,%d0                            /*  6 Byte pro Eintrag */
 adda.l %d0,%a0
 jbsr writetxt
 move.l (%sp)+,%d0
 jbsr komma
 rts


komma:  
 cmp aktlw(%a4),%d0
 jne komma02
 lea txtstern(%pc),%a0
 jbsr writetxt
komma02:  
 lea txtkomma(%pc),%a0
 jbsr writetxt
komma01:  
 rts


hdpars:                           /*  sucht in der hdtab nach passendem LW */
 lea hdtab(%pc),%a1                      /*  %a1 zeigt auf die HD-Tabelle */
 adda.l #pqlw,%a0                       /*  %a0 zeigt auf Quell-Laufwerk */
 clr %d1                                 /*  %d1 ist Laufwerkszûhler */
 move #32-1,%d3
hdp02:  
 move.l (%a0),%d0                        /*  Langwort Vergleich */
 cmp.l (%a1),%d0
 jeq hdp04                            /*  da stimmts */
hdp03:                                    /*  sonst weiter */
 addq.l #6,%a1                          /*  nûchster Eintrag */
 addq #1,%d1                            /*  LW Zûhler */
 dbra %d3,hdp02
 jra hdperr                           /*  Laufwerk nicht vorhanden */
hdp04:  
 move.b 4(%a0),%d0
 cmp.b 4(%a1),%d0
 jeq hdp05                            /*  mügliches Laufwerk gefunden */
 jra hdp03                            /*  weiter gehts */
hdp05:  
 move.l hdbtfild(%a4),%d6
 btst.l %d1,%d6                          /*  Laufwerk wirklich da? */
 jeq hdperr                           /*  nü :-( */
 clr.l %d0
 jra hdpex
hdperr:  
 move.l #-1,%d0
hdpex:  
 rts


mdira:                            /*  gibt das akt. DIR von aktlw aus */
 movem.l %d0-%d7/%a1-%a2,-(%sp)
 tst.l hdbtfild(%a4)                     /*  ein LW vorhanden? */
 jeq mdiraer                            /*  nü */
 /*jbsr parser*/                             /*  Parameter holen (JADOS) */
 move.l #2,%d0
 jbsr option
 tst.l %d0
 jne mdiraer
 clr.l %d4                               /*  Dateienzûhler */
 clr.l %d5                               /*  Grüssenzûhler */
 clr.l %d6                               /*  DIRzûhler */
 clr.l %d7                               /*  Anzahl der Zeilen */
 jbsr dirkopf
 jbsr FindFrst                           /*  1. Eintrag */
 tst.l %d0                               /*  Fehler? */
 jne mdiraer                            /*  Ja */
 cmp.l #-1,ffpos(%a4)                   /*  was Gefunden? */
 jeq mdira10                          /*  nein */
 addq.l #1,%d7                          /*  Anzahl der Zeilen */
 lea dirbuff(%pc),%a1
 adda.l ffpos(%a4),%a1                   /*  %a1 auf Datei */
 btst #4,DIRAttr(%a1)
 jeq mdira00
 addq.l #1,%d6                          /*  Anzahl der DIRs */
 jra mdira00a
mdira00:  
 addq.l #1,%d4                          /*  Anzahl der Dateien */
mdira00a:  
 jbsr mdirausg                           /*  Ausgeben */
mdira01:  
 jbsr FindNext                           /*  nûchster Eintrag */
 tst.l %d0                               /*  Fehler? */
 jne mdiraer                          /*  Ja */
 cmp.l #-1,ffpos(%a4)                   /*  was gefunden? */
 jeq mdira10                          /*  nein */
 addq.l #1,%d7                          /*  Anzahl der Zeilen */
 lea dirbuff(%pc),%a1
 adda.l ffpos(%a4),%a1                   /*  %a1 auf Datei */
 btst #4,DIRAttr(%a1)
 jeq mdira05
 addq.l #1,%d6                          /*  Anzahl der DIRs */
 jra mdira06
mdira05:  
 addq.l #1,%d4                          /*  Anzahl der Dateien */
mdira06:  
 jbsr mdirausg                           /*  Ausgabe */
 cmp #19,%d7                            /*  Ende der Seite? */
 jne mdira01                          /*  nein,weiter */
 jbsr nextside                           /*  sonst neue Seite */
 tst %d0                                 /*  Abbruch? */
 jmi mdira10                          /*  ja! */
 clr.l %d7                               /*  Zeilenzûhler auf 0 */
 jra mdira01                          /*  nûchsten suchen */
mdira10:  
 jbsr dirfuss
 clr.l %d0
 jra mdiraex
mdiraer:  
 jbsr error
 move.l #-1,%d0
mdiraex:  
 movem.l (%sp)+,%d0-%d7/%a1-%a2
 rts


mdirausg:  
 movem.l %d1-%d3/%a0-%a2,-(%sp)
 move #8-1,%d2
 movea.l %a1,%a2
mdaus02:  
 move.b (%a2)+,%d0                       /*  Datei Name */
 jbsr co2
 dbra %d2,mdaus02
 move.b #' ',%d0                        /*  "Space" */
 jbsr co2
 move #3-1,%d2
mdaus03:  
 move.b (%a2)+,%d0                       /*  Datei Erweiterung */
 jbsr co2
 dbra %d2,mdaus03
 move.b #' ',%d0
 jbsr co2
 jbsr co2                                /*  2 Spaces ausgeben */
 move.b (%a2),%d1
 btst #4,%d1                          /*  DIR Attribut */
 jeq mdaus04
 lea txtdirat(%pc),%a0                   /*  Text: <DIR> */
 jbsr writetxt
 lea txt15spc(%pc),%a0                   /*  15 Spaces */
 jbsr writetxt
 jra mdaus06
mdaus04:  
 move.b #' ',%d0
 jbsr co2                                /*  Space */
 move.b #'R',%d0
 btst #0,%d1                          /*  R = Schreibgeschýtzt */
 jne mdaus04a
 move.b #' ',%d0
mdaus04a:  
 jbsr co2
 move.b #'H',%d0
 btst #1,%d1                          /*  H = Versteckt */
 jne mdaus04b
 move.b #' ',%d0
mdaus04b:  
 jbsr co2
 move.b #'S',%d0
 btst #2,%d1                          /*  S = System */
 jne mdaus04c
 move.b #' ',%d0
mdaus04c:  
 jbsr co2
 move.b #'A',%d0
 btst #5,%d1                          /*  A = Archiv */
 jne mdaus04d
 move.b #' ',%d0
mdaus04d:  
 jbsr co2
 move.b #' ',%d0
 jbsr co2
mdaus05:  
 move #' ',%d0
 jbsr co2
 movea.l %a1,%a2
 move.l DIRSize(%a2),%d0                 /*  Dateigrüsse in Byte */
 jbsr LBHLW
 add.l %d0,%d5                           /*  Gesamt Grüsse */
 jbsr print8d                            /*  Ausgabe */
mdaus06:  
 movea.l %a1,%a2
 move.b #' ',%d0
 jbsr co2
 jbsr co2
 move.l DIRLCh(%a2),%d0          /*  Datum/Zeit der letzten ûnderung LBHLW! */
 jbsr LBHLW
 move.l %d0,%d1                          /*  sichern */
 swap %d0
 and.l #0x1f,%d0                         /*  5 Bit = Tag */
 jbsr print2d
 move.b #'.',%d0
 jbsr co2
 move.l %d1,%d0
 swap %d0
 asr #5,%d0
 and.l #0xf,%d0                          /*  4 Bit = Monat */
 jbsr print2d0
 move.b #'.',%d0
 jbsr co2
 move.l %d1,%d0
 rol.l #7,%d0
 and.l #0x7f,%d0                         /*  7 Bit = Jahr */
 add #1980,%d0                          /*  ab 1980 */
 jbsr print4d
 move.b #' ',%d0
 jbsr co2
 jbsr co2
 move %d1,%d0
 rol #5,%d0
 and #0x1f,%d0                           /*  5 Bit = Stunde */
 jbsr print2d
 move.b #':',%d0
 jbsr co2
 move %d1,%d0
 asr #5,%d0
 and #0x3f,%d0                           /*  6 Bit = Minuten */
 jbsr print2d0
 move.b #':',%d0
 jbsr co2
 move %d1,%d0
 and #0x1f,%d0                           /*  5 Bit = Sekunden */
 jbsr print2d0
 lea txtcrlf(%pc),%a0                    /*  nûchste Zeile */
 jbsr writetxt
mdausex:  
 movem.l (%sp)+,%d1-%d3/%a0-%a2
 rts


dirkopf:  
 jbsr cls
 lea txtlw(%pc),%a0
 jbsr writetxt
 move aktlw(%a4),%d0
 lea hdtab(%pc),%a0                      /*  Laufwerk-Tabelle */
 mulu #6,%d0                            /*  6 Byte pro Eintrag */
 adda.l %d0,%a0
 jbsr writetxt
 lea txtcrlf(%pc),%a0
 jbsr writetxt
 lea txtverz(%pc),%a0
 jbsr writetxt
 lea NoAD(%fp),%a0
 jbsr writetxt
 lea txtcrlf(%pc),%a0
 jbsr writetxt
 jbsr writetxt                           /*  eine Leerzeile */
 rts


dirfuss:  
 lea txtcrlf(%pc),%a0
 jbsr writetxt                           /*  Eine Leerzeile */
 move.l %d4,%d0
 jbsr print8d                            /*  Anzahl der Dateien */
 move.b #' ',%d0
 jbsr co2
 lea txtdatei(%pc),%a0
 jbsr writetxt
 move.b #' ',%d0
 jbsr co2
 jbsr co2
 move.l %d5,%d0
 jbsr print8d                            /*  Grüsse aller Dateien */
 move.b #' ',%d0
 jbsr co2
 lea txtbyte(%pc),%a0
 jbsr writetxt
 lea txtcrlf(%pc),%a0
 jbsr writetxt                           /*  Eine Leerzeile */
 move.l %d6,%d0
 jbsr print8d                            /*  Anzahl der DIRs */
 move.b #' ',%d0
 jbsr co2
 lea txtdir(%pc),%a0
 jbsr writetxt
 rts


nextside:  
 movem.l %a0,-(%sp)
 clr %d7
 lea txtweit(%pc),%a0
 jbsr writetxt
 jbsr key
 cmp.b #0x03,%d0                         /*  CTRL-C */
 jne nxtsd01
 move.l #-1,%d0
 jra nxtsdex
nxtsd01:  
 lea txtcrlf(%pc),%a0
 jbsr writetxt
 jbsr writetxt
 lea txtverz(%pc),%a0
 jbsr writetxt
 lea NoAD(%fp),%a0
 jbsr writetxt
 move.b #' ',%d0
 jbsr co2
 lea txtforts(%pc),%a0
 jbsr writetxt
 lea txtcrlf(%pc),%a0
 jbsr writetxt
 clr.l %d0
nxtsdex:  
 movem.l (%sp)+,%a0
 rts



mcda:                                     /*  ûndert das akt. Verzeichniss */
 movem.l %d0/%a0,-(%sp)
 tst.l hdbtfild(%a4)                     /*  LW vorhanden? */
 jeq mcdaex                           /*  nü */
 jbsr parser
 move.l #3,%d0                         /*  Befehlsnummer */
 jbsr option                             /*  'H' und 'Q' müglich */
 tst.l %d0
 jne mcdaex                           /*  nach Hilfe nicht weiter */
mcda01:  
 lea parsdat(%pc),%a0
 move.l pflag(%a0),%d0
 btst.l #pfqdatn,%d0
 jeq mcdaerr
 jbsr chdir
 cmp #F_OK,%d0
 jeq mcdaex
mcdaerr:  
 move.l #-1,%d0
 jbsr error
 jra mcdaex1
mcdaex:  
 tst.b quiet(%a4)                        /*  Ausgabe unterdrýcken? */
 jne mcdaex1                          /*  ja */
 lea txtcrlf(%pc),%a0                    /*  CRLF vorweg */
 jbsr writetxt
 lea NoAD(%fp),%a0                       /*  DIR-Name */
 jbsr writetxt
 lea txtakt(%pc),%a0
 jbsr writetxt
 lea txtverz(%pc),%a0
 jbsr writetxt
mcdaex1:  
 movem.l (%sp)+,%d0/%a0
 rts


mmda:                                     /*  erstellt ein neues Verzeichnis */
 movem.l %d0/%a0,-(%sp)
 tst.l hdbtfild(%a4)                     /*  LW vorhanden? */
 jeq mmdaex                           /*  nü */
 jbsr parser
 move.l #6,%d0                         /*  Befehlsnummer */
 jbsr option                             /*  'H','Q' und 'K' müglich */
 tst.l %d0
 jne mmdaex
mmda02:  
 lea parsdat(%pc),%a0
 move.l pflag(%a0),%d0
 btst.l #pfqdatn,%d0
 jne mmda03
 move.l #-1,%d0                         /*  kein Dateiname */
 move.l #15,errnum(%a4)
 jra mmdaerr
mmda03:  
 jbsr mkdir
 tst.l %d0
 jeq mmdaex
mmdaerr:  
 jbsr error
mmdaex:  
 movem.l (%sp)+,%d0/%a0
 rts


mloada:                                   /*  Lûdt eine Datei in den Speicher */
                                        /*  %a0=Dateiname,%a1=Ladeadresse */
 movem.l %d1-%d2/%a0-%a1,-(%sp)
 tst.l hdbtfild(%a4)                     /*  LW vorhanden? */
 jeq mldaex1                            /*  nü */
 jbsr parser
 move.l #5,%d0
 jbsr option
 tst.l %d0
 jne mldaex1
mlda00a:  
 lea parsdat(%pc),%a0
 move.l pflag(%a0),%d0
 btst.l #pfqdatn,%d0
 jne mlda01
 move.l #15,errnum(%a4)
 jra mldaerr1                         /*  kein Dateiname! */
mlda01:  
 btst.l #pfadr1,%d0                     /*  Adresse eingegeben? */
 jeq mlda01a                          /*  nein */
 movea.l padr1(%a0),%a1                  /*  eingegebene Adresse laden */
mlda01a:  
 jbsr FFFD                               /*  FindFreeFileDiscriptor */
 tst.l %d0
 jmi mldaerr1                         /*  kein freier Dateihûndel */
 move.l %d0,%d2                          /*  sichern */
 jbsr MFN                                /*  MakeFileName */
 move %d2,%d0                            /*  Dateihûndel zurýck */
 jbsr FindName                           /*  Datei suchen */
 cmp.l #FULL_MAT,%d0                    /*  gefunden? */
 jeq mlda02                           /*  jo */
 move.l #16,errnum(%a4)
 jra mldaerr
mlda02:  
 move.l %d2,%d0                          /*  Dateihûndel zurýck */
 jbsr FileDsct                           /*  %a0=Adresse des Dateihûndels */
 move.l %a1,FileAdr(%a0)                 /*  Speicheradresse setzen */
 move.l %d2,%d0                          /*  Vorsichtshalber */
 jbsr fload                              /*  Datei in Speicher laden */
 tst.l %d0
 jne mldaerr
 tst.b quiet(%a4)                        /*  Ausgabe unterdrýcken? */
 jne mlda10                           /*  ja */
 lea txtcrlf(%pc),%a0                    /*  CRLF vorweg */
 jbsr writetxt
 move.l %d2,%d0
 jbsr NameOut
 lea txtload(%pc),%a0
 jbsr writetxt
mlda10:  
 clr.l %d0                               /*  alles OK */
 jra mldaex
mldaerr:  
 move.l #-1,%d0                         /*  Fehler */
 jbsr error
 jra mldaex
mldaerr1:  
 move.l #-1,%d0
 jbsr error
 jra mldaex1

mldaex:  

 /* ** FileID wieder freigeben muss spûter durch fclose erfolgen */
 move.l %d0,-(%sp)
 move %d2,%d0
 jbsr FileDsct
 clr.b FileFlag(%a0)
 move.l (%sp)+,%d0


mldaex1:  
 movem.l (%sp)+,%d1-%d2/%a0-%a1
 rts



mcopya:                           /*  Kopiert Dateien von/nach Jados */
 movem.l %d1-%d3/%a0-%a3,-(%sp)
 move.l #-1,%d1                        /*  keine FileID */
 tst.l hdbtfild(%a4)                     /*  LW vorhanden? */
 jeq mcpaex1                            /*  nü */
 jbsr parser
 move.l #4,%d0
 jbsr option
 tst.l %d0
 jne mcpaex1
mcpa01:  
 lea parsdat(%pc),%a3
 move.l pflag(%a3),%d0
 btst.l #pfqdatn,%d0
 jne mcpa01a
 move.l #15,errnum(%a4)                 /*  kein Dateiname */
 jra mcpaerr
mcpa01a:  
 btst.l #pfqlw,%d0
 jeq mcpa10                             /*  keine Laufwerksbezeichnung */

 cmp.b #'J',pqtyp(%a3)                  /*  JADOS? */
 jne mcpa10                             /*  nü */

 jbsr JMDL                               /*  JadosMakeDirList */
 tst.l %d0
 jmi mcpaerr                            /*  Fehler in DIR-Liste */
 move.l %d0,%d3                          /*  Anzahl der DIR-Eintrûge */
 jeq mcpaex                             /*  keine Dateien - Ende! */
 subq.l #1,%d3                          /*  als Zûhler */
 clr.l %d2                               /*  DIR-Nummer */
mcpa02:  
 move.l #-1,%d1                        /*  keine FileID */
 jbsr jclrfcb                            /*  FCB lüschen */
 move.l %d2,%d0                          /*  DIR Nummer */
 jbsr JMFN                               /*  Dateiname/Ext. in FCB */
 clr.l %d0
 move.b pqlw(%a3),%d0                    /*  Laufwerksbuchstabe */
 jbsr jconvlw                            /*  nach binûr */
 cmp.l #-1,%d0
 jeq mcpaerr                            /*  Fehler */
 lea jfcb(%pc),%a1
 move %d0,JLW(%a1)                       /*  Laufwerk im FCB setzen */
 jbsr jusradr                            /*  Adresse des Userbereichs laden */
 movea.l %a0,%a2                         /*  sichern */
 jbsr jfload                             /*  Datei laden */
 cmp.l #-1,%d0
 jeq mcpaerr                            /*  Datei konnte nicht geladen werden */
 jbsr jtom                               /*  Jados-FCB -> Mtools-FileDsct */
 cmp.l #-1,%d0
 jeq mcpaerr                            /*  Schwerer Fehler */
 cmp.l #-2,%d0
 jeq mcpa05                           /*  nicht ýberschreiben */
 cmp.l #-3,%d0                          /*  Abbruch? */
 jeq mcpaex                             /*  ja! */
mcpa03:  
 move.l %d0,%d1                          /*  FileID sichern */
 jbsr FileDsct                           /*  FileDiscriptor in %a0 */
 movea.l %a0,%a1                         /*  sichern */
 move.l %a2,FileAdr(%a1)
 move.l %d1,%d0                          /*  FileID zurýck!!! */
 tst.b convflag(%a4)                     /*  Konvertieren? */
 jeq mcpa03a                          /*  nein */
 jbsr NKCtoIBM
 tst.l %d0
 jmi mcpaerr                            /*  Fehler beim Konvertieren */
mcpa03a:  
 move.l %d1,%d0                          /*  FileID zurýck */
 jbsr fsave                              /*  Datei speichern */
 cmp.l #-1,%d0                          /*  Speichern OK? */
 jeq mcpaerr                            /*  nü */
 move.l %d1,%d0                          /*  FileID zurýck */
 jbsr UFE                                /*  UpdateFileEntry */
 cmp.l #-1,%d0
 jeq mcpaerr
 tst.b quiet(%a4)                        /*  mit Ausgabe? */
 jne mcpa04                           /*  nü */
 lea txtcrlf(%pc),%a0                    /*  CRLF vorweg */
 jbsr writetxt
 move.l %d1,%d0                          /*  FileID zurýck */
 jbsr NameOut                            /*  Name ausgeben */
 lea txtcopy(%pc),%a0
 jbsr writetxt
mcpa04:  
 clr.b FileFlag(%a1)                     /*  FileID schliessen */
mcpa05:  
 addq.l #1,%d2                          /*  nûchste Datei */
 subq.l #1,%d3
 jpl mcpa02                             /*  dbra geht nur bis Wort!!! */
 clr.b JNAFlag(%a4)                      /*  nicht mehr ýberschreiben */
 clr.l %d0
 jra mcpaex1                            /*  geht ohne FileID schliessen */

mcpa10:  
 btst.l #pfzlw,%d0                      /*  Ziel-Laufwerk vorhanden? */
 jeq mcpaerr                            /*  nü */
 cmp.b #'J',pztyp(%a3)                  /*  Ziel = Jados? */
 jeq mcpa11                           /*  jo */
 move.l #24,errnum(%a4)                 /*  ungýltiges Laufwerk */
 jra mcpaerr
mcpa11:  
 move.l #-1,%d1                         /*  keine FileID */
 jbsr FFFD                               /*  FindFreeFileDiscriptor */
 tst.l %d0
 jmi mcpaerr                            /*  Fehler */
 move.l %d0,%d1                          /*  FileID sichern */
 jbsr FileDsct                           /*  Filediscriptor in %a0 */
 movea.l %a0,%a2                         /*  sichern */
 jbsr FindFrst
 tst.l %d0
 jmi mcpaerr
 cmp.l #-1,ffpos(%a4)
 jne mcpa12
 move.l #16,errnum(%a4)                 /*  keine Datei da */
 jra mcpaerr
mcpa12:  
 move.l %d1,%d0                          /*  FileID zurýck */
 jbsr FFD
 btst #4,FileAttr(%a2)                /*  DIR? */
 jne mcpa14                             /*  Ja */
 jbsr mtoj                               /*  FCB anlegen */
 clr.l %d0
 move.b pzlw(%a3),%d0
 jbsr jconvlw                            /*  JADOS Lw */
 tst.b %d0
 jmi mcpaerr                            /*  kein gýltiges Laufwerk */
 lea jfcb(%pc),%a0
 move %d0,JLW(%a0)                       /*  Laufwerk setzen */
 jbsr jusradr                            /*  User Speicher holen */
 move.l %a0,FileAdr(%a2)                 /*  in FileDsct speichern */
 movea.l %a0,%a1                         /*  und sichern */

 cmp.b #2,JNAFlag(%a4)
 jeq mcpa13                           /*  Alles ýberschreiben */
 movem.l %d1-%d3,-(%sp)
 jbsr jfinfo
 movem.l (%sp)+,%d1-%d3
 tst.b %d0
 jmi mcpa13                           /*  Datei nicht vorhanden */
 tst.b quiet(%a4)
 jne mcpa14                           /*  nûchste Datei */
 lea txtcrlf(%pc),%a0
 jbsr writetxt
 move.l %d1,%d0
 jbsr NameOut
 lea txtueber(%pc),%a0
 jbsr JNA
 tst.l %d0                               /*  Abbruch? */
 jmi mcpaex                           /*  ja */
 cmp.b #2,JNAFlag(%a4)                  /*  Alle ýberschreiben */
 jeq mcpa13
 tst.b JNAFlag(%a4)                      /*  Nicht ýbeschreiben */
 jeq mcpa14                           /*  nûchste Datei */
 clr.b JNAFlag(%a4)
mcpa13:  
 move.l %d1,%d0                          /*  FileID zurýck */
 jbsr fload                              /*  Datei laden */
 tst %d0                                 /*  OK? */
 jmi mcpaerr                          /*  nü */
 tst.b convflag(%a4)                     /*  konvertieren? */
 jeq mcpa13a                          /*  nü */
 move.l %d1,%d0                          /*  FileID zurýck */
 jbsr IBMtoNKC
 tst.l %d0
 jmi mcpaerr                          /*  Fehler beim konvertieren */
mcpa13a:  
 movea.l %a1,%a0                         /*  Speicheradresse nach %a0 */
 jbsr jfsave                             /*  und speichern */
 tst.b %d0                               /*  OK? */
 jne mcpaerr                          /*  Nein */
 tst.b quiet(%a4)                        /*  mit Ausgabe? */
 jne mcpa14                           /*  nü */
 lea txtcrlf(%pc),%a0                    /*  CRLF vorweg */
 jbsr writetxt
 move %d1,%d0                            /*  FileID zurýck */
 jbsr NameOut                            /*  Name ausgeben */
 lea txtcopy(%pc),%a0
 jbsr writetxt
mcpa14:  
 jbsr FindNext
 tst.l %d0
 jmi mcpaerr
 cmp.l #-1,ffpos(%a4)
 jeq mcpaex
 jra mcpa12

mcpaerr:  
 move.l #-1,%d0
 jbsr error
mcpaex:  
 tst.l %d1
 jmi mcpaex1                          /*  keine FileID!!! */
 exg %d0,%d1
 jbsr FileDsct
 clr.b FileFlag(%a0)                     /*  FileID schliessen */
 exg %d0,%d1
mcpaex1:  
 movem.l (%sp)+,%d1-%d3/%a0-%a3
 rts


mdela:  
 movem.l %d0/%a3,-(%sp)
 tst.l hdbtfild(%a4)
 jeq mdelaex
 jbsr parser
 move.l #7,%d0
 jbsr option
 tst.l %d0
 jne mdelaex
mdela02:  
 jbsr remove
 tst.l %d0
 jeq mdelaex
mdelaer:  
 jbsr error
mdelaex:  
 movem.l (%sp)+,%d0/%a3
 rts


mforma:  
 movem.l %d0/%a0,-(%sp)           /*  Formatiert das akt. Laufwerk */
 tst.l hdbtfild(%a4)
 jeq mfrmaex                            /*  kein LW da */
 jbsr parser
 move.l #8,%d0
 jbsr option
 tst.l %d0
 jne mfrmaex
 tst.b JNAFlag(%a4)
 jne mfrma01                          /*  loslegen */
 tst.b quiet(%a4)
 jne mfrmaex
 jbsr cls
 lea txtlw(%pc),%a0
 jbsr writetxt
 move aktlw(%a4),%d0
 lea hdtab(%pc),%a0                      /*  Laufwerk-Tabelle */
 mulu #6,%d0                            /*  6 Byte pro Eintrag */
 adda.l %d0,%a0
 jbsr writetxt
 lea txtform(%pc),%a0
 jbsr JN
 tst.l %d0
 jmi mfrmaex                          /*  Abbruch mit CTRL-C */
 tst.b JNAFlag(%a4)
 jeq mfrmaex                          /*  nicht formatieren */
mfrma01:  
 jbsr QForm
 tst.l %d0
 jmi mfrmaer
 tst.l quiet(%a4)
 jne mfrmaex
 lea txtcrlf(%pc),%a0
 jbsr writetxt
 lea txtlw(%pc),%a0
 jbsr writetxt
 move aktlw(%a4),%d0
 lea hdtab(%pc),%a0                      /*  Laufwerk-Tabelle */
 mulu #6,%d0                            /*  6 Byte pro Eintrag */
 adda.l %d0,%a0
 jbsr writetxt
 lea txtform1(%pc),%a0
 jbsr writetxt
 jra mfrmaex
mfrmaer:  
 jbsr error
mfrmaex:  
 movem.l (%sp)+,%d0/%a0
 rts


hilfe:  
 movem.l %d0/%a0,-(%sp)
 jbsr cls
 asl.l #2,%d0
 lea hilfetab(%pc),%a0
 adda.l 0(%a0,%d0.w),%a0
 jbsr writetxt
 movem.l (%sp)+,%d0/%a0
 rts


error:  
 movem.l %d0/%a0,-(%sp)
 cmp.b #2,quiet(%a4)
 jeq errex                            /*  keine Fehlerausgabe */
 lea txtcrlf(%pc),%a0
 jbsr writetxt
 move.l errnum(%a4),%d0
 cmp.l #erranz,%d0
 jlt err01
 move.l #27,%d0                         /*  undefinierter Fehler */
err01:  
 asl.l #2,%d0
 lea errtab(%pc),%a0
 adda.l 0(%a0,%d0.w),%a0
 jbsr writetxt
errex:  
 movem.l (%sp)+,%d0/%a0
 rts


option:                           /*  Optionen einstellen */
                                /*  %d0=Nummer des Befehls */
 movem.l %d1-%d2/%a0,-(%sp)
 move.l %d0,%d2                          /*  Befehlsnummer sichern */
 jmi opterr                             /*  Ungýltige Befehlsnummer */
 cmp.l #trapanz,%d2
 jge opterr                             /*  Ungýltige Befehlsnummer */
 clr.b quiet(%a4)
 clr.b JNAFlag(%a4)
 clr.b convflag(%a4)
 lea parsdat(%pc),%a0
 move.l pflag(%a0),%d1
 btst.l #pfopt,%d1
 jne opt00
 clr.l %d0
 jra optex                            /*  keine Option */
opt00:  
 move.l popt(%a0),%d1                    /*  angegebene Optionen */
 lea opttab(%pc),%a0
 asl.l #2,%d2                           /*  Befehlsnummer als Offset */
 move.l 0(%a0,%d2.w),%d2                 /*  mügliche Befehlsoption */
 not.l %d2
 and.l %d1,%d2
 jne opterr                           /*  ungýltige Option */

 btst.l #0x08,%d1                        /*  H: Hilfe */
 jeq opt01
 jbsr hilfe
 move.l #-1,%d0
 jra optex                            /*  keine weitere Befehlsausfýhrung */
opt01:  
 btst.l #0x17,%d1                        /*  Q: Quiet - Ausgabe unterdrýcken */
 jeq opt02
 move.b #1,quiet(%a4)
 clr.l %d0
opt02:  
 btst.l #0x01,%d1                        /*  A: Alle */
 jeq opt03
 move.b #2,JNAFlag(%a4)                 /*  Alle ýberschreiben/lüschen... */
 clr.l %d0
opt03:  
 btst.l #0x11,%d1                        /*  K: Keinerlei Ausgabe */
 jeq opt04
 move.b #2,quiet(%a4)                   /*  keine Ausgabe (auch keine Fehler) */
 clr.l %d0
opt04:  
 btst.l #0x03,%d1                        /*  C: Kovertieren */
 jeq opt05
 move.b #-1,convflag(%a4)
 clr.l %d0
opt05:  
 nop
 jra optex                            /*  weiter mit Befehl */

opterr:  
 move.l #17,errnum(%a4)                 /*  Falsche Option */
 jbsr error
 move.l #-1,%d0                         /*  keine weitere Befehlsausfýhrung */
optex:  
 movem.l (%sp)+,%d1-%d2/%a0
 rts


NKCtoIBM:                         /*  konvertiert NKC Textdateien nach IBM */
 movem.l %d1-%d5/%a0-%a3/%a5,-(%sp)          /*  FileID in %d0 */
 jbsr FileDsct
 movea.l FileAdr(%a0),%a3                /*  RAM Adresse der Datei */
 movea.l %a3,%a2                         /*  sichern */
 move.l FileSize(%a0),%d3                /*  Dateigrüsse (von JADOS) */
 move.l %d3,%d2                          /*  sichern */
 lea nkctab(%pc),%a1
 lea ibmtab(%pc),%a5
 sub.l #1024,%d3                        /*  letzten Sektor raus */
 jmi NtI02                            /*  Datei < 1024 Byte */
 subq.l #1,%d3                          /*  als Zûhler */
 jmi NtI02                            /*  Datei = 1024 Byte */
NtI01:  
 /*  tst.b (%a3)+                            * ne Null? */
 /*  beq NtIerr                             * Ja,dann kein Text!!! */
 /*  subq.l #1,%d3 */
 /*  bpl.s NtI01                            * dbra geht nur bis Wort!!! */
 movea.l %a2,%a3                         /*  Dateistart zurýck */
NtI02:  
 clr.l %d1                               /*  als Bytezûhler */
 move.l %d2,%d3                          /*  Lûnge zurýck */
NtI03:  
 move.b (%a3),%d0                        /*  Zeichen einlesen */
 jeq NtI20                            /*  Ende erreicht */
 jmi NtI05                            /*  Umlaut */
NtI04:                                    /*  Regulûr */
 addq.l #1,%d1
 addq.l #1,%a3
 jra NtI03                            /*  Nûchstes Zeichen */
NtI05:  
 clr.l %d4
NtI05a:  
 move.b 0(%a1,%d4.w),%d5                 /*  NKC Umlaut */
 jeq NtI05b                           /*  Tabelle durch */
 cmp.b %d5,%d0                          
 jne NtI05c                           /*  ist es nicht */
 move.b 0(%a5,%d4.w),%d0                 /*  IBM Umlaut laden */
 jra NtI10
NtI05b:  
 move.b #' ',%d0                        /*  Space laden */
 jra NtI10
NtI05c:  
 addq #1,%d4                            /*  nûchster Umlaut */
 jra NtI05a
NtI10:  
 move.b %d0,(%a3)                        /*  abspeichern */
 jra NtI04                            /*  und weiter */
NtI20:  
 move.l %d1,FileSize(%a0)                /*  neue Lûnge speichern */
 clr.l %d0
 jra NtIex
NtIerr:  
 move.l #-1,%d0
 move.l #26,errnum(%a4)
NtIex:  
 movem.l (%sp)+,%d1-%d5/%a0-%a3/%a5
 rts


IBMtoNKC:                         /*  konvertiert IBM Textdateien nach NKC */
 movem.l %d1-%d5/%a0-%a3/%a5,-(%sp)          /*  FileID in %d0 */
 jbsr FileDsct
 movea.l FileAdr(%a0),%a3                /*  RAM Adresse der Datei */
 movea.l %a3,%a2                        /*  sichern */
 move.l FileSize(%a0),%d3                /*  Dateigrüsse */
 move.l %d3,%d2                          /*  sichern */
 lea nkctab(%pc),%a5
 lea ibmtab(%pc),%a1
 subq.l #1,%d3                          /*  als Zûhler */
ItN01:  
 tst.b (%a3)+                            /*  ne Null? */
 jeq ItNerr                             /*  Ja,dann kein Text!!! */
 subq.l #1,%d3
 jpl ItN01                            /*  dbra geht nur bis Wort!!! */
 clr.b (%a3)                             /*  Ende setzten */
 movea.l %a2,%a3                         /*  Dateistart zurýck */
ItN02:  
 clr.l %d1                               /*  als Bytezûhler */
 clr.l %d3                               /*  als Zeichen / Zeile */
ItN03:  
 move.b (%a3),%d0                        /*  Zeichen einlesen */
 jmi NtI05                            /*  Umlaut */
 cmp.b #0x09,%d0                         /*  HTAB */
 jne ItN03a
 jbsr TABtoSP                            /*  durch Space ersetzen */
 jra ItN04
ItN03a:  
 cmp.b #0x0a,%d0                         /*  LF? */
 jne ItN04                            /*  nü */
 move.l #-1,%d3                        /*  sonst Zeichen/Zeile auf 0 ;-) */
ItN04:                                    /*  Regulûr */
 addq.l #1,%d3                          /*  nûchstes Zeichen in Zeile */
 addq.l #1,%d1
 addq.l #1,%a3
 cmp.l %d2,%d1                           /*  Ende? */
 jge ItN20
 cmp.l #79,%d3                          /*  Zeilenumbruch nütig? */
 jle ItN04a                           /*  nein */
 cmp.b #0x0a,0(%a3)                      /*  nûchstes Zeichen ein LF? */
 jne ItN04b                           /*  Nein,weiter */
 clr.l %d3
 addq.l #1,%a3
 jra ItN03
ItN04b:  
 cmp.b #0x0a,1(%a3)                      /*  ýbernûchstes Zeichen LF? */
 jne ItN04c                           /*  nein dann neuer Umbruch */
 addq.l #2,%a3
 clr.l %d3
 jra ItN03
ItN04c:  
 jbsr umbruch
 clr.l %d3
ItN04a:  
 jra ItN03                            /*  Nûchstes Zeichen */
ItN05:  
 clr.l %d4
ItN05a:  
 move.b 0(%a1,%d4.w),%d5                 /*  IBM Umlaut */
 jeq ItN05b                           /*  Tabelle durch */
 cmp.b %d5,%d0                          
 jne ItN05c                           /*  ist es nicht */
 move.b 0(%a5,%d4.w),%d0                 /*  NKC Umlaut laden */
 jra ItN10
ItN05b:  
 move.b #' ',%d0                        /*  ansonsten Space laden */
 jra ItN10
ItN05c:  
 addq #1,%d4                            /*  nûchster Umlaut */
 jra ItN05a
ItN10:  
 move.b %d0,(%a3)                        /*  abspeichern */
 jra ItN04                            /*  und weiter */
ItN20:  
 adda.l %d1,%a2                          /*  %a2 auf Ende der Datei */
 /*  addq.l #1,%d1 */
 move.l %d1,FileSize(%a0)                /*  neue Lûnge speichern */
 lea jfcb(%pc),%a0
 move.l %d1,%d0
 lsr.l #8,%d0                           /*  /256 */
 lsr.l #2,%d0                           /*  /4 -> /1024 (Sektorgrüsse) */
 and.l #0x3ff,%d1
 tst %d1                                 /*  noch ein Teilsektor? */
 jeq ItN20a                           /*  nü */
 addq.l #1,%d0                          /*  Ansonsten 1 Sektor mehr */
 move #1024,%d2
 sub %d1,%d2                             /*  1024-Restdaten */
 subq #1,%d2                            /*  -1 da Zûhler */
ItN201:  
 clr.b (%a2)+
 dbra %d2,ItN201                        /*  Restsektor mit 00 fýllen */
ItN20a:  
 move %d0,JDatL(%a0)                     /*  Grüsse in Sektoren */
 clr.l %d0
 jra ItNex
ItNerr:  
 move.l #-1,%d0
 move.l #26,errnum(%a4)
ItNex:  
 movem.l (%sp)+,%d1-%d5/%a0-%a3/%a5
 rts


umbruch:                          /*  Zeilenumbruch einfýgen */
 movem.l %d1-%d2/%a0,-(%sp)
 movea.l %a3,%a0                         /*  aktuelle Position */
 sub.l %d1,%d2                           /*  Lûnge - akt. Position = Rest */
 move.l %d2,%d1                          /*  nach %d1 */
 move.l #2,%d0                          /*  um 2 verschieben */
 jbsr mover
 move.b #0x0d,0(%a0)
 move.b #0x0a,1(%a0)
 movem.l (%sp)+,%d1-%d2/%a0
 addq.l #2,%d2                          /*  Text um 2 Byte lûnger */
 rts


TABtoSP:                          /*  einen Tabulator in Spaces umwandeln */
 movem.l %d0-%d1/%d3/%a0,-(%sp)
 move.l %d3,%d0                          /*  akt. Zeichenposition in Zeile */
 and.l #0x7,%d0                          /*  mod 8 */
 move.l #8,%d3
 sub.l %d0,%d3
 move.l %d3,%d0
TtS01:  
 subq.l #1,%d0
 movea.l %a3,%a0                         /*  aktuelle Position */
 move.l %d2,-(%sp)                       /*  %d2 retten */
 sub.l %d1,%d2                           /*  Lûnge - akt. Position = Rest */
 move.l %d2,%d1                          /*  nach %d1 */
 move.l (%sp)+,%d2                       /*  %d2 zurýck */
 jbsr mover
 move.l %d0,%d1
TtS02:  
 move.b #' ',(%a0)+                     /*  mit Space fýllen */
 dbra %d1,TtS02
 add.l %d0,%d2                           /*  neue Textlûnge */
 movem.l (%sp)+,%d0-%d1/%d3/%a0
 rts


mover:                            /*  Verschiebt um %d0.w Bytes nach hinten */
 movem.l %d1/%a0,-(%sp)           /*  %d1.l = Lûnge,%a0 = Start */
 adda.l %d1,%a0                          /*  %a0 Auf Ende */
mvrlp01:  
 move.b (%a0),0(%a0,%d0.w)
 subq.l #1,%a0
 subq.l #1,%d1
 jpl mvrlp01                          /*  dbra geht nur bis Wort!!! */
 movem.l (%sp)+,%d1/%a0
 rts



 /* **** Texte ***** */

   .align 4

txtinit:  

   .ascii "MTOOLS V 0.9A sind initialisiert"    
   .byte 0

txtcrlf:  
   .byte   0x0d,0x0a,0

txtnv:  

   .ascii "Laufwerk nicht verfýgbar"    
   .byte 0

txtcyl:  

   .ascii "Zylinder: "    
   .byte 0

txtsec:  

   .ascii "Sektoren: "    
   .byte 0

txthd:  

   .ascii "Küpfe: "    
   .byte 0

txtpart:  

   .ascii "Partitionen:"    
   .byte 0

txtnr:  

   .ascii "Nr"    
   .byte 0

txtstart:  

   .ascii "Start-"    
   .byte 0

txt1start:  

   .ascii "sektor"    
   .byte 0

txtgroess:  

   .ascii "Anzahl"    
   .byte 0

txt1groess:  

   .ascii "Sektoren"    
   .byte 0

txtMB:  

   .ascii "Grüsse in"    
   .byte 0

txt1MB:  

   .ascii "MiB"    
   .byte 0

txttyp:  

   .ascii "Partitionstyp"    
   .byte 0

txtkomma:  

   .ascii ","
   .byte 0

txtstern:  

   .ascii " *"    
   .byte 0

txtaktlw:  

   .ascii "* = aktives Laufwerk"    
   .byte 0

txtweit:  

   .ascii "Weiter mit beliebiger Taste . . ."    
   .byte 0

txtforts:  

   .ascii "wird fortgesetzt"    
   .byte 0

txtlw:  

   .ascii "Laufwerk "    
   .byte 0

txtverz:  

   .ascii "Verzeichnis "    
   .byte 0

txterst:  

   .ascii "erstellt"    
   .byte 0

txtdirat:  

   .ascii "<DIR> "    
   .byte 0

txtdatei:  

   .ascii "Datei(en) "    
   .byte 0

txtdir:  

   .ascii "Verzeichnis(se) "    
   .byte 0

txtbyte:  

   .ascii "Byte "    
   .byte 0

txt15spc:  

   .ascii "               "    
   .byte 0

txtroot:  

   .ascii "/"    
   .byte 0

txtjn:  

   .ascii " (Ja/Nein) "    
   .byte 0

txtjna:  

   .ascii " (Ja/Nein/Alle) "    
   .byte 0

txtueber:  

   .ascii "ýberschreiben?"    
   .byte 0

txtcopy:  

   .ascii "kopiert"    
   .byte 0

txtdel:  

   .ascii "gelüscht"    
   .byte 0

txtloe:  

   .ascii "lüschen?"    
   .byte 0

txtload:  

   .ascii "ins RAM geladen"    
   .byte 0

txtakt:  

   .ascii " ist aktuelles "    
   .byte 0

txtform:  

   .ascii " formatieren?"    
   .byte 0

txtform1:  

   .ascii " ist formatiert!"    
   .byte 0


 /* **** Fehler Texte ***** */

terr1:  

   .ascii "kein Laufwerk vorhanden"    
   .byte 0

terr2:  

   .ascii "keine FAT16 Partition verfýgbar"    
   .byte 0

terr3:  

   .ascii "Laufwerk nicht ready"    
   .byte 0

terr4:  

   .ascii "Daten sind nicht bereit"    
   .byte 0

terr5:  

   .ascii "Sektor kann nicht gelesen werden"    
   .byte 0

terr6:  

   .ascii "Sektor kann nicht geschrieben werden"    
   .byte 0

terr7:  

   .ascii "Disk ist voll"    
   .byte 0

terr8:  

   .ascii "kein freier Cluster"    
   .byte 0

terr9:  

   .ascii "kein freier Datei-Hûndel"    
   .byte 0

terr10:  

   .ascii "DIR kann nicht gelüscht werden"    
   .byte 0

terr11:  

   .ascii "Verzeichnis nicht vorhanden"    
   .byte 0

terr12:  

   .ascii "Verzeichnis ist voll"    
   .byte 0

terr13:  

   .ascii "Verzeichnis schon vorhanden"    
   .byte 0

terr14:  

   .ascii "JADOS Directory Fehler"    
   .byte 0

terr15:  

   .ascii "kein Dateiname angegeben"    
   .byte 0

terr16:  

   .ascii "Datei nicht vorhanden"    
   .byte 0

terr17:  

   .ascii "falsche Option"    
   .byte 0

terr18:  

   .ascii "keine Laufwerk angegeben"    
   .byte 0

terr19:  

   .ascii "Userspeicher ist voll"    
   .byte 0

terr20:  

   .ascii "JADOS Laufwerk nicht erreichbar"    
   .byte 0

terr21:  

   .ascii "JADOS Laufwerk ist voll"    
   .byte 0

terr22:  

   .ascii "JADOS Verzeichnis ist voll"    
   .byte 0

terr23:  

   .ascii "kein gýltiges JADOS Laufwerk"    
   .byte 0

terr24:  

   .ascii "ungýltige Laufwerks-Angabe"    
   .byte 0

terr25:  

   .ascii "ungýltige Cluster Nummer"    
   .byte 0

terr26:  

   .ascii "Fehler beim konvertieren"    
   .byte 0

terr27:  

   .ascii "undefinierter Fehler"    
   .byte 0

terr28:  

   .ascii "Fehler im Parser bei Adressberechnung"    
   .byte 0

terr29:  

   .ascii "Zu alte Grundprogrammversion! Vorraussetztung min. V7.10"    
   .byte 0

   .align 4



    .equ OSanz          , 86

   .align 4

 OStype:  
   .byte   0x00
   .ascii "Eintrag leer                            "    
   .byte 0
   .byte   0x01
   .ascii "FAT12                                   "    
   .byte 0
   .byte   0x02
   .ascii "Xenix                                   "    
   .byte 0
   .byte   0x03
   .ascii "Xenix                                   "    
   .byte 0
   .byte   0x04
   .ascii "FAT16 (max. 32 MB)                      "    
   .byte 0
   .byte   0x05
   .ascii "extended DOS-Partition (max. 2 GB)      "    
   .byte 0
   .byte   0x06
   .ascii "FAT16 (max. 2 GB)                       "    
   .byte 0
   .byte   0x07
   .ascii "HPFS/NTFS                               "    
   .byte 0
   .byte   0x08
   .ascii "AIX                                     "    
   .byte 0
   .byte   0x09
   .ascii "AIX bootable                            "    
   .byte 0
   .byte   0x0A
   .ascii "OS/2 Bootmanager                        "    
   .byte 0
   .byte   0x0B
   .ascii "FAT32 (CHS Adressierung)                "    
   .byte 0
   .byte   0x0C
   .ascii "FAT32 (LBA Adressierung)                "    
   .byte 0
   .byte   0x0E
   .ascii "FAT16 (LBA Adressierung)                "    
   .byte 0
   .byte   0x0F
   .ascii "ext. Partition (LBA,mehr als 1024 Zyl.)"
   .byte 0
   .byte   0x10
   .ascii "OPUS                                    "    
   .byte 0
   .byte   0x11
   .ascii "hidden FAT12                            "    
   .byte 0
   .byte   0x12
   .ascii "Compaq diagnost                         "    
   .byte 0
   .byte   0x14
   .ascii "hidden FAT16 bis 32MB                   "    
   .byte 0
   .byte   0x16
   .ascii "hidden FAT16                            "    
   .byte 0
   .byte   0x17
   .ascii "hidden HPFS / NTFS                      "    
   .byte 0
   .byte   0x18
   .ascii "AST Windows swap                        "    
   .byte 0
   .byte   0x1B
   .ascii "hidden WIN95 FAT32                      "    
   .byte 0
   .byte   0x1C
   .ascii "hidden WIN95 FAT32 (LBA)                "    
   .byte 0
   .byte   0x1E
   .ascii "hidden WIN95 FAT16 (LBA)                "    
   .byte 0
   .byte   0x24
   .ascii "NEC DOS                                 "    
   .byte 0
   .byte   0x39
   .ascii "Plan 9                                  "    
   .byte 0
   .byte   0x3C
   .ascii "Partition Magic                         "    
   .byte 0
   .byte   0x40
   .ascii "Venix 80286                             "    
   .byte 0
   .byte   0x41
   .ascii "PPC PReP boot                           "    
   .byte 0
   .byte   0x42
   .ascii "SFS                                     "    
   .byte 0
   .byte   0x4D
   .ascii "QNX4.x                                  "    
   .byte 0
   .byte   0x4E
   .ascii "QNX4.x 2nd partition                    "    
   .byte 0
   .byte   0x4F
   .ascii "QNX4.x 3rd partition                    "    
   .byte 0
   .byte   0x50
   .ascii "OnTrack DM                              "    
   .byte 0
   .byte   0x51
   .ascii "OnTrack DM6 Aux                         "    
   .byte 0
   .byte   0x52
   .ascii "CP/M                                    "    
   .byte 0
   .byte   0x53
   .ascii "OnTrack DM6 Aux                         "    
   .byte 0
   .byte   0x54
   .ascii "OnTrack DM6                             "    
   .byte 0
   .byte   0x55
   .ascii "EZ-Drive                                "    
   .byte 0
   .byte   0x56
   .ascii "Golden Bow                              "    
   .byte 0
   .byte   0x5c
   .ascii "Priam Edisk                             "    
   .byte 0
   .byte   0x61
   .ascii "Speed Stor                              "    
   .byte 0
   .byte   0x63
   .ascii "GNU HURD or SYS                         "    
   .byte 0
   .byte   0x64
   .ascii "Novell NetWare                          "    
   .byte 0
   .byte   0x70
   .ascii "Disk Secure Mult                        "    
   .byte 0
   .byte   0x75
   .ascii "UNIX PC/IX                              "    
   .byte 0
   .byte   0x80
   .ascii "aktiv (old Minix)                       "    
   .byte 0
   .byte   0x81
   .ascii "Booten von Laufwerk D:                  "    
   .byte 0
   .byte   0x82
   .ascii "Linux Swap                              "    
   .byte 0
   .byte   0x83
   .ascii "Linux native                            "    
   .byte 0
   .byte   0x84
   .ascii "OS/2 hidden C:                          "    
   .byte 0
   .byte   0x85
   .ascii "LINUX extended                          "    
   .byte 0
   .byte   0x86
   .ascii "NTFS volume set                         "    
   .byte 0
   .byte   0x87
   .ascii "NTFS volume set                         "    
   .byte 0
   .byte   0x8e
   .ascii "LINUX LVM                               "    
   .byte 0
   .byte   0x93
   .ascii "Amoebla                                 "    
   .byte 0
   .byte   0x94
   .ascii "Amoebla BBT                             "    
   .byte 0
   .byte   0x9F
   .ascii "BSD/OS                                  "    
   .byte 0
   .byte   0xA0
   .ascii "IBM Thinkpad hidden                     "    
   .byte 0
   .byte   0xA5
   .ascii "BSD/386                                 "    
   .byte 0
   .byte   0xA6
   .ascii "Open BSD                                "    
   .byte 0
   .byte   0xA7
   .ascii "NeXT STEP                               "    
   .byte 0
   .byte   0xB0
   .ascii "JADOS                                   "    
   .byte 0
   .byte   0xB7
   .ascii "BSDI fs                                 "    
   .byte 0
   .byte   0xB8
   .ascii "BSDI swap                               "    
   .byte 0
   .byte   0xC1
   .ascii "DRDOS/sec (FAT32)                       "    
   .byte 0
   .byte   0xC4
   .ascii "DRDOS/sec (FAT32(LBA))                  "    
   .byte 0
   .byte   0xC6
   .ascii "DRDOS/sec (FAT16(LBA))                  "    
   .byte 0
   .byte   0xC7
   .ascii "Syrinx                                  "    
   .byte 0
   .byte   0xDA
   .ascii "Non-Fs data                             "    
   .byte 0
   .byte   0xDB
   .ascii "Concurrent DOS,CP/M,CTOS              "
   .byte 0
   .byte   0xDE
   .ascii "Dell Utility                            "    
   .byte 0
   .byte   0xE1
   .ascii "DOS access                              "    
   .byte 0
   .byte   0xE3
   .ascii "DOS R/o                                 "    
   .byte 0
   .byte   0xE4
   .ascii "Speed Stor                              "    
   .byte 0
   .byte   0xEB
   .ascii "BeOS fs                                 "    
   .byte 0
   .byte   0xEE
   .ascii "EFI GPT                                 "    
   .byte 0
   .byte   0xEF
   .ascii "EFI (FAT12/16/32)                       "    
   .byte 0
   .byte   0xF1
   .ascii "Speed Stor                              "    
   .byte 0
   .byte   0xF2
   .ascii "DOS secondary                           "    
   .byte 0
   .byte   0xF4
   .ascii "Speed Stor                              "    
   .byte 0
   .byte   0xFD
   .ascii "LINUX raid auto                         "    
   .byte 0
   .byte   0xFE
   .ascii "LANstep                                 "    
   .byte 0
   .byte   0xFF
   .ascii "BBT                                     "    
   .byte 0

   .align 4

hdtab:  
fd0:  

   .ascii "FD0"    
   .byte 0,0,0
fd1:  

   .ascii "FD1"    
   .byte 0,0,0
hda1:  

   .ascii "HDA1"    
   .byte 0,0
hda2:  

   .ascii "HDA2"    
   .byte 0,0
hda3:  

   .ascii "HDA3"    
   .byte 0,0
hda4:  

   .ascii "HDA4"    
   .byte 0,0
hdb1:  

   .ascii "HDB1"    
   .byte 0,0
hdb2:  

   .ascii "HDB2"    
   .byte 0,0
hdb3:  

   .ascii "HDB3"    
   .byte 0,0
hdb4:  

   .ascii "HDB4"    
   .byte 0,0
sda1:  

   .ascii "SDA1"    
   .byte 0,0
sda2:  

   .ascii "SDA2"    
   .byte 0,0
sda3:  

   .ascii "SDA3"    
   .byte 0,0
sda4:  

   .ascii "SDA4"    
   .byte 0,0
sdb1:  

   .ascii "SDB1"    
   .byte 0,0
sdb2:  

   .ascii "SDB2"    
   .byte 0,0
sdb3:  

   .ascii "SDB3"    
   .byte 0,0
sdb4:  

   .ascii "SDB4"    
   .byte 0,0
res1:  

   .ascii "RES1"    
   .byte 0,0
res2:  

   .ascii "RES2"    
   .byte 0,0
res3:  

   .ascii "RES3"    
   .byte 0,0
res4:  

   .ascii "RES4"    
   .byte 0,0
res5:  

   .ascii "RES5"    
   .byte 0,0
res6:  

   .ascii "RES6"    
   .byte 0,0
res7:  

   .ascii "RES7"    
   .byte 0,0
res8:  

   .ascii "RES8"    
   .byte 0,0
res9:  

   .ascii "RES9"    
   .byte 0,0
res10:  

   .ascii "RES10"    
   .byte 0
res11:  

   .ascii "RES11"    
   .byte 0
res12:  

   .ascii "RES12"    
   .byte 0
res13:  

   .ascii "RES13"    
   .byte 0
res14:  

   .ascii "RES14"    
   .byte 0

   .align 4

 /* **** Hilfe Texte ***** */

hmdisk:  

   .ascii "Syntax: MDISK              ->  Listet verfýgbare Laufwerke auf"    
   .byte 13,10

   .ascii "        MDISK lw:          ->  Macht lw: zum aktiven Laufwerk"    
   .byte 13,10,0
   .align 4

hmdir:  

   .ascii "Syntax: MDIR               ->  Liefert das Inhaltsverzeichnis"    
   .byte 13,10

   .ascii "                               des aktiven Laufwerks"    
   .byte 13,10

   .ascii "        MDIR name.ext      ->  Gibt ein eingeschrûnktes"    
   .byte 13,10

   .ascii "                               Inhaltsverzeichnis aus"    
   .byte 13,10

   .ascii "                               Wilscards ( *,? ) sind müglich"
   .byte 13,10,0
   .align 4

hmcd:  

   .ascii "Syntax: MCD name           ->  Wechselt in das Unterverzeichnis"    
   .byte 13,10

   .ascii "                               \"name\""    
   .byte 13,10

   .ascii "        MCD ..             ->  Wechsel in das ýbergeordnete"    
   .byte 13,10

   .ascii "                               Verzeichnis"    
   .byte 13,10

   .ascii "        MCD /              ->  Wechselt in das Root-Verzeichnis"    
   .byte 13,10,0
   .align 4

hmcopy:  

   .ascii "Syntax: MCOPY lw:name.ext  ->  kopiert von JADOS nach FAT16"    
   .byte 13,10

   .ascii "                               Wildcards ( *,? ) sind müglich"
   .byte 13,10

   .ascii "        MCOPY name.ext lw: ->  kopiert von FAT16 nach JADOS"    
   .byte 13,10

   .ascii "                               Wildcards ( *,? ) sind müglich"
   .byte 13,10,0
   .align 4

hmload:  

   .ascii "Syntax: MLOAD name.ext     ->  Lûdt die Datei \"name.ext\""    
   .byte 13,10

   .ascii "                               in den JADOS USER-Bereich"    
   .byte 13,10

   .ascii "        MLOAD name.ext #aa     Lûdt die Datei \"name.ext\""    
   .byte 13,10

   .ascii "                               in die Adresse #aaaaaaaa "    
   .byte 13,10,0
   .align 4

hmmd:  

   .ascii "Syntax: MMD name           ->  Erstellt das Unterverzeichnis"    
   .byte 13,10

   .ascii "                               \"name\""    
   .byte 13,10,0
   .align 4

hmdel:  

   .ascii "Syntax: MDEL name.ext      ->  Lüscht die Datei \"name.ext\""    
   .byte 13,10

   .ascii "                               Wildcards ( *,? ) sind müglich"
   .byte 13,10,0
   .align 4

hmform:  

   .ascii "Syntax: MFORMAT            ->  Formatiert das aktuelle Laufwerk"    
   .byte 13,10,0
   .align 4


 /* **** Trap10 Tabelle ***** */

traptab:  
   .long     0                               /*  frei          0 */
   .long     mdiska-traptab                  /*  mdisk         1 */
   .long     mdira-traptab                   /*  mdir          2 */
   .long     mcda-traptab                    /*  mcd           3 */
   .long     mcopya-traptab                  /*  mcopy         4 */
   .long     mloada-traptab                  /*  mload         5 */
   .long     mmda-traptab                    /*  mmd           6 */
   .long     mdela-traptab                   /*  mdel          7 */
   .long     mforma-traptab                  /*  mformat       8 */
trapend:  

    .equ trapanz, (trapend-traptab)/4         /*  Anzahl der Trap #10 Eintrûge */


 /* **** Hilfe Tabelle ***** */

hilfetab:  
   .long     0                               /*  frei          0 */
   .long     hmdisk-hilfetab                 /*  mdisk         1 */
   .long     hmdir-hilfetab                  /*  mdir          2 */
   .long     hmcd-hilfetab                   /*  mcd           3 */
   .long     hmcopy-hilfetab                 /*  mcopy         4 */
   .long     hmload-hilfetab                 /*  mload         5 */
   .long     hmmd-hilfetab                   /*  mmd           6 */
   .long     hmdel-hilfetab                  /*  mdel          7 */
   .long     hmform-hilfetab                 /*  mformat       8 */
htabend:  


 /* **** Optionstabelle ***** */
 /*         33222222222211111111110000000000 */
 /*         10987654321098765432109876543210 */
 /*         .....ZYXWVUTSRQPONMLKJIHGFEDCBA@ */
opttab:  
   .long     0b00000000000000000000000000000000  /*  frei    #0 */
   .long     0b00000000000000000000000100000000  /*  mdisk   #1 H */
   .long     0b00000000000000000000000100000000  /*  mdir    #2 H */
   .long     0b00000000000000100000100100000000  /*  mcd     #3 H,Q,K */
   .long     0b00000000000000100000100100001010  /*  mcopy   #4 H,Q,A,K,C */
   .long     0b00000000000000100000100100000000  /*  mload   #5 H,Q,K */
   .long     0b00000000000000100000100100000010  /*  mmd     #6 H,Q,A,K */
   .long     0b00000000000000100000100100000010  /*  mdel    #7 H,Q,A,K */
   .long     0b00000000000000100000100100000010  /*  mformat #8 H,Q,A,K */
otabend:  


 /* **** Fehlertabelle ***** */

errtab:  
   .long     0                               /*  kein Fehler                   0 */
   .long     terr1-errtab                    /*  kein LW                       1 */
   .long     terr2-errtab                    /*  keine FAT16                   2 */
   .long     terr3-errtab                    /*  LW nicht ready                3 */
   .long     terr4-errtab                    /*  Daten nicht bereit            4 */
   .long     terr5-errtab                    /*  Sektor nicht lesbar           5 */
   .long     terr6-errtab                    /*  Sektor nicht schreibbar       6 */
   .long     terr7-errtab                    /*  Disk voll                     7 */
   .long     terr8-errtab                    /*  kein freier Cluster           8 */
   .long     terr9-errtab                    /*  kein freier Datei-Hûndel      9 */
   .long     terr10-errtab                   /*  DIR nicht lüschbar            10 */
   .long     terr11-errtab                   /*  Verzeichnis nicht da          11 */
   .long     terr12-errtab                   /*  Verzeichnis voll              12 */
   .long     terr13-errtab                   /*  Verzeichnis schon da          13 */
   .long     terr14-errtab                   /*  JADOS Dirctory Fehler         14 */
   .long     terr15-errtab                   /*  kein Dateiname                15 */
   .long     terr16-errtab                   /*  Datei nicht da                16 */
   .long     terr17-errtab                   /*  falsche Option                17 */
   .long     terr18-errtab                   /*  kein Laufwerk angegeben       18 */
   .long     terr19-errtab                   /*  UserSpeicher voll             19 */
   .long     terr20-errtab                   /*  JADOS LW nicht da             20 */
   .long     terr21-errtab                   /*  JADOS LW voll                 21 */
   .long     terr22-errtab                   /*  JADOS DIR voll                22 */
   .long     terr23-errtab                   /*  JADOS LW ungýltig             23 */
   .long     terr24-errtab                   /*  ungýltiges LW                 24 */
   .long     terr25-errtab                   /*  ungýltiger Cluster            25 */
   .long     terr26-errtab                   /*  konvertierungs Fehler         26 */
   .long     terr27-errtab                   /*  undefinierter Fehler          27 */
   .long     terr28-errtab                   /*  fehlerhafte Adressberechnung  28 */
   .long     terr29-errtab                   /*  Zu niedrige GP Version        29 */
errend:  

    .equ erranz , (errend-errtab)/4           /*  Anzahl der Fehler Eintrûge */


nkctab:  
   .byte   0xdb,0xdc,0xdd,0xfb,0xfc,0xfd,0xfe,0
   .align 4

ibmtab:  
   .byte   0xc4,0xd6,0xdc,0xe4,0xf6,0xfc,0xdf,0
   .align 4


 /* **** Diskparameter ***** */

    .equ Diskname       , 4

    .equ typ1           , 46              /*  FS Typ der Partition */
    .equ typ2           , 48              /*  Wort Grüsse (Byte reicht auch) */
    .equ typ3           , 50
    .equ typ4           , 52

    .equ starts1        , 54              /*  Startsektor der Partition */
    .equ starts2        , 58              /*  Langwort */
    .equ starts3        , 62
    .equ starts4        , 66

    .equ groesse1       , 70              /*  Grüsse der PART in Sektoren */
    .equ groesse2       , 74              /*  Langwort */
    .equ groesse3       , 78
    .equ groesse4       , 82

    .equ NoAD           , 86              /*  Name des akt. DIRs */


 /* * Boot-Parameter-Block */
    .equ BPBOff         , 128

    .equ BPS            , 0+BPBOff  /*  Bytes pro Sektor immer 512!!!     OFF=0x0B */
    .equ SPC            , 2+BPBOff  /*  Sektoren pro Cluster              OFF=0x0D */
    .equ RSC            , 4+BPBOff  /*  Anzahl der reservierten Sektoren  OFF=0x0E */
    .equ numFATs        , 6+BPBOff  /*  Anzahl der FATs                   OFF=0x10 */
    .equ REC            , 8+BPBOff  /*  Anzahl der Eintrûge im Root-Verz. OFF=0x11 */
    .equ TotSec16       , 10+BPBOff  /*  Gesamtzahl Sektoren 16 Bit        OFF=0x13 */
    .equ FATSz          , 12+BPBOff  /*  Grüþe der FATs                    OFF=0x16 */
    .equ TotSec32       , 14+BPBOff  /*  Gesamtzahl Sektoren 32 Bit        OFF=0x20 */

    .equ FATFrst        , 18+BPBOff  /*  erster FAT Sektor */
    .equ RootFrst       , 22+BPBOff  /*  erster Root-DIR Sektor */
    .equ DataFrst       , 26+BPBOff  /*  erster Daten Sektor */
    .equ TotSec         , 30+BPBOff  /*  Sektoren gesamt */
    .equ DataSec        , 34+BPBOff  /*  Datensektoren gesamt */
    .equ FATCurr        , 38+BPBOff  /*  aktueller FAT-Sektor */
    .equ eoClusCh       , 42+BPBOff  /*  Endekennzeichen fýr Clusterchain */
    .equ BPC            , 46+BPBOff  /*  Bytes pro Cluster */
    .equ lastSec        , 50+BPBOff  /*  letzter Sektor des LWs */
    .equ lastClus       , 54+BPBOff  /*  letzter benutzbare Cluster */
    .equ CntClust       , 58+BPBOff  /*  Anzahl der Cluster */

    .equ RtDrSec        , 62+BPBOff  /*  Anzahl der Root-DIR Sektoren */
    .equ FrstDIRC       , 66+BPBOff  /*  Erster DIR Cluster */


 /* **** Master Boot Record ***** */

 /* * Partitions-Offsets */

    .equ partoff1       , 0x1be
    .equ partoff2       , 0x1ce
    .equ partoff3       , 0x1de
    .equ partoff4       , 0x1ee

 /* * Partition Infos */

    .equ Bootflag       , 0x00
    .equ SHdoff         , 0x01             /*  nicht ausgewertet */
    .equ SSecoff        , 0x02             /*  nicht ausgewertet */
    .equ SCyloff        , 0x03             /*  nicht ausgewertet */
    .equ typoff         , 0x04
    .equ EHdoff         , 0x05             /*  nicht ausgewertet */
    .equ ESecoff        , 0x06             /*  nicht ausgewertet */
    .equ ECyloff        , 0x07             /*  nicht ausgewertet */
    .equ startoff       , 0x08
    .equ sizeoff        , 0x0c


    .equ END_DIR        , 0
    .equ NO_MATCH       , 1
    .equ MATCH_N        , 2               /*  Match Name */
    .equ MATCH_E        , 3               /*  Match Extension */
    .equ FULL_MAT       , MATCH_N+MATCH_E

    .equ F_CLOSED       , 0
    .equ F_READ         , 1
    .equ F_WRITE        , 2

    .equ F_ERROR        , 0
    .equ F_OK           , 1


    .equ maxofile       , 2               /*  Max. offene Dateien a 1074 Byte */
    .equ FDOff          , 128             /*  Offset fýr File Discriptoren */

 /* **** File Descriptor ***** */

    .equ FileName       , 0            /*  file name */
    .equ FileExt        , 8            /*  file extension */
    .equ FileDOff       , 11            /*  dir entry offset in FileDirSektor/ */
    .equ FileCSec       , 12            /*  current File Sektor */
    .equ File1CS        , 16            /*  1st sektor of current cluster used */
    .equ FileDSec       , 20            /*  dir sektor holding this fileentry */
    .equ FileSize       , 24            /*  Size in Byte */
    .equ FilePos        , 28            /*  file byte position */
    .equ FileFlag       , 32            /*  open or closed */
    .equ FileAttr       , 33            /*  file attribute / dir functions */
    .equ FileCC         , 34            /*  FileClusterCount */
    .equ File1C         , 38            /*  FileFirstCluster */
    .equ FileCurC       , 42            /*  number of cluster in use */
    .equ FileAdr        , 46            /*  Startadresse im RAM */
    .equ Fiob           , 50            /*  64 Byte Puffer */

 /* **** DIR Eintrûge ***** */

    .equ DIRName        , 0x0              /*  Dateiname */
    .equ DIRExt         , 0x8              /*  Dateierweiterung */
    .equ DIRAttr        , 0xb              /*  Attribute */
    .equ DIREZt         , 0xd              /*  Erstellungs Zeit 10tel Sek. */
    .equ DIRLDt         , 0xe              /*  Datum letzter Zugriff (unbenutzt) */
    .equ DIR1CH         , 0x14             /*  1. Cluster high Word (FAT32) */
    .equ DIRLCh         , 0x16             /*  Zeit letzte ûnderung */
    .equ DIR1CL         , 0x1a             /*  Erster Cluster der Datei (low Word) */
    .equ DIRSize        , 0x1c             /*  Grüsse der Datei in Byte */

 /* **** Parser Flag Bits ***** */

    .equ pfopt          , 0       /*  Parser Flag Option */

    .equ pfqlw          , 1       /*  Parser Flag Quell-Laufwerk */
    .equ pfqpath        , 2       /*  Parser Flag Quell-Pfad (noch unbenutzt) */
    .equ pfqdatn        , 3       /*  Parser Flag Quell-Dateiname */
    .equ pfqdate        , 4       /*  Parser Flag Quell-Dateiextension */

    .equ pfzlw          , 5       /*  Parser Flag Ziel-Laufwerk */
    .equ pfzpath        , 6       /*  Parser Flag Ziel-Pfad (noch unbenutzt) */
    .equ pfzdatn        , 7       /*  Parser Flag Ziel-Dateiname */
    .equ pfzdate        , 8       /*  Parser Flag Ziel-Dateiextension */

    .equ pfadr1         , 9       /*  Parser Flag Adresswert1 */
    .equ pfadr2         , 10      /*  Parser Flag Adresswert2 */

 /* **** Parser Offsets (immer auf gerader Adresse!) ***** */

    .equ pflag          , 0       /*  Parser Flag                   (1 Langwort) */
    .equ popt           , 4       /*  Parser Optionen               (1 Langwort) */
    .equ pqlw           , 8       /*  Parser Quell-Laufwerk         (5 Byte) */
                                /*                                (1 Byte frei) */
    .equ pqtyp          , 14      /*  Parser Quell-Laufwerkstyp     (1 Byte) */
                                /*                                (1 Byte frei) */
    .equ pqdatn         , 16      /*  Parser Quell-Dateiname        (8 Byte) */
    .equ pqdate         , 24      /*  Parser Quell-Dateiextension   (3 Byte) */
                                /*                                (1 Byte frei) */
    .equ pzlw           , 28      /*  Parser Ziel-Laufwerk          (5 Byte) */
                                /*                                (1 Byte frei) */
    .equ pztyp          , 34      /*  Parser Ziel-Laufwerkstyp      (1 Byte) */
                                /*                                (1 Byte frei) */
    .equ pzdatn         , 36      /*  Parser Ziel-Dateiname         (8 Byte) */
    .equ pzdate         , 44      /*  Parser Ziel-Dateiextension    (3 Byte) */
                                /*                                (1 Byte frei) */
    .equ padr1          , 48      /*  Parser Adresswert1            (1 Langwort) */
    .equ padr2          , 52      /*  Parser Adresswert2            (1 Langwort) */


 /* **** JADOS File Control Block ***** */

    .equ JLW            , 0               /*  Laufwerk */
    .equ JDName         , 2               /*  Dateiname */
                                        /*  2 Byte Reserve (0) */
    .equ JDExt          , 12              /*  Dateityp */
                                        /*  1 Byte Reserve (0) */
    .equ JSSpr          , 16              /*  Startspur */
    .equ JESec          , 18              /*  Endsektor */
    .equ JEByte         , 20              /*  Endbyte (unbenutzt) */
    .equ JDat           , 22              /*  Datum */
    .equ JDatL          , 26              /*  Dateilûnge in Sektoren (1024 Byte) */
    .equ JDatMod        , 28              /*  Dateimodus */
                                        /*  3 Byte reserve */
    .equ JDirSec        , 32              /*  Sektor des DIRs */
    .equ JDirBt         , 34              /*  Startbyte im Sektor des DIRs */
    .equ JDatStat       , 36              /*  Dateistatus */
    .equ JAktSpur       , 38              /*  Nummer der akt. Spur */
    .equ JAktSec        , 40              /*  akt. Sektor der akt. Spur */
    .equ JLSpur         , 42              /*  Nummer des letzten Dateispur */
    .equ JAktAdr        , 44              /*  akt. Speichertransferadresse */


 /* **** Allgemeine Variablen ***** */

    .equ hdnum          , 0               /*  0=FD0,2=IDE-Master,4=SD-Card 0 */

    .equ hdbtfild       , 4               /*  Bitfeld fýr LWs mit passendem FS-Typ */
    .equ aktlw          , 8               /*  Nummer des aktiven Laufwerks */
                                        /*  #0=FD0,#2=HDA1,#6=HDB1,#10=SDA1 */
    .equ FATStat        , 10              /*  FAT Status Byte */
    .equ JNAFlag        , 12              /*  ýberschreiben? Byte */
                                        /*  0=nein,1=ja,2=alle */
    .equ quiet          , 14              /*  Ausgabe unterdrýcken? Byte */
                                        /*  0=nein,1=nur noch Fehler, */
                                        /*  2=alle unterdrýcken */
    .equ errnum         , 16              /*  Fehlernummer Langwort */
    .equ trace          , 20              /*  Fehlersuche Langwort */
    .equ ffpos          , 24              /*  FindFile Fileposition */
                                        /*  -1=nichts gefunden LW */
    .equ ffsec          , 28              /*  FindFile Sektor */
    .equ ffclus         , 32              /*  FindFile Cluster */
    .equ ffsecc         , 36              /*  FindFile Sektor-Count */
    .equ convflag       , 40              /*  Konvertierungs Flag Byte */
                                        /*  0 = nicht Konvertieren */

    .equ hdname         , 8               /*  Offset fýr Laufwerkname in GP */
    .equ hdoff          , 256             /*  Offset fýr Laufwerkspeicherbereiche */

 /* **** VARIABLEN ***** */
VarStart:  
   .align 4
allgm:              .space  64                 /*  Allgemeine Variablen */
parsdat:            .space  64                 /*  Parser Daten */
hddat:              .space  1024               /*  Diskparameter + BPB fýr 4 HDs */
fatbuff:            .space  512                /*  FAT Puffer 1 Sektor */
dirbuff:            .space  512                /*  DIR Puffer 1 Sektor */
buffer:             .space  512                /*  Puffer fýr allgm. Verwendung */
jfcb:               .space  48                 /*  JADOS FileControlBlock */
jdirbuf:            .space  4096               /*  JADOS DIR Buffer */
filebuff:           .space  FDOff*maxofile     /*  File Buffer */
VarEnd:  




 /* ************************** Texte ******************************** */
meldung:  
   .ascii "loading os ..."    
   .byte 0xd,0xa,0xd,0xa,0   
fname:  
   .ascii "NKC68K.ROM"    
   .byte 0   
 /*  fname: dc.b 'MONITOR.68K',0    */


ende:  



