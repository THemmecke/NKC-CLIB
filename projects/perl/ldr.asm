*CO2SER
*********************************************
*                                           *
*     BOOTLOADER PART2   (FAT16)            *
*                                           *
* Das ist Teil 2 des Bootloaders,der sich	*
* ab Sector 1 befindet  					*
*********************************************


* 0x00.0000 - 0x0f.ffff 0-1MB
* 0x10.0000 - 0x1f.ffff 1-2MB

* 0x20.0000 - 0x2f.ffff 2-3MB
* 0x30.0000 - 0x3f.ffff 3-4MB

cpu             equ 4   * 68000 (2),68008(1)
target			equ $600 * in den 2ten MB Block (ROM-Kernel)
*target			equ $400 * (RAM-Kernel, crt0_ram.S muss dann das ROMFS verschieben und BSS Segment löschen)

* Speicherbereiche EQU

		org $0
		        
start:							* Part 2 laed das os image
		*bsr cls                 * Bildschirm lüschen
		lea meldung(pc),a0		* Meldung ausgeben
m001:
		move.b (A0)+,D0       	* Zeichen holen
 		beq.s m002            	* Bei Null ist das Ende erreicht
 		moveq #33,D7        	* Sonst Zeichen ausgeben
 		trap #1
 		bra.s m001        		* Wiederholen
m002:
		bsr mtools				* load mtools

		lea fname(pc),a0		* Dateiname nach a0
		movea.l #target,a1		* Zieladresse nach a1
		move #5,d7				* function mload
		
		bsr	trap10				* let mtools do the work
				
		jmp target				* jmp !!
		
								
        
mainend:
        rts						* Ende des Bootloadercodes
        
        
**************** Unterprogramme aus MTOOLS **********************
*****************************************
*                                       *
*               MTOOLS                  *
*                                       *
*   die Tools fýrs FAT16 Dateisystem    *
*                                       *
*            von Jens Mewes             *
*                                       *
*         V 0.9A : 2008.08.27           *
*                                       *
*****************************************
 

mtools:
 movem.l d0-d7/a0-a6,-(a7)
 *bsr cls                                * Bildschirm lüschen
 lea allgm(pc),a4                      * Index fýr relativen Zugriff
 *lea trap10(pc),a0                     * Trap #10 initialisieren
 *move.l a0,$A8
 bsr ClrVars                            * Variablen lüschen
 * move #!getvers,d7
 move #97,d7
 trap #1
 cmp.l #$710,d0
 bge.s lp00
 move.l #29,errnum(a4)
 bsr error
 bra.s Exit
lp00:
 moveq #4-1,d3                         * 4 Harddisks untersuchen
 moveq.l #1,d1                         * mit IDE-Master beginnen
 clr.l d2
lp01:
 addq #1,d1
 move d1,d0
 bsr SetLW
 bsr GetDrive                           * Laufwerksdaten laden
 tst.l d0                               * alles OK?
 bne.s lp02                             * nein
 moveq #1,d2                           * als Merker dass was gefunden
 move.b #$06,d0                        * FAT16 Type 06
 bsr FSChk                              * Dateisystem suchen
 move.b #$04,d0                        * FAT16 Type 04
 bsr FSChk                              * und suchen
 bra.s lp03
lp02:
 cmp.l #-2,d0                          * "nur" fehlerhafter MBR
 beq.s lp03
 cmp #2,d1
 bne.s lp03                             * kein Fehler bei IDE-Master
 addq #1,d1
 subq #1,d3                            * ansonsten IDE-Slave ýbergehen
lp03:
 dbra d3,lp01
 tst d2
 bne.s lp04                             * es wurde min. ein LW gefunden
 move.l #1,errnum(a4)
 bsr error
 bra.s Exit
lp04:
 tst.l hdbtfild(a4)
 bne.s lp05
 move.l #2,errnum(a4)
 bsr error
 bra.s Exit
lp05:
 bsr ALW                                * aktives LW setzen
 lea txtinit(pc),a0                    * freundliche Meldung
 bsr writetxt
Exit:
 movem.l (a7)+,d0-d7/a0-a6
 rts


ClrVars:
 lea VarStart(pc),a0
 move.l #VarEnd-VarStart-1,d3          * Alle Variablen und Puffer
cb01:
 clr.b (a0)+
 dbra d3,cb01
rts


SetLW:                                  * Laufwerk einstellen d0=Nummer
 and.l #$ff,d0                         * nur Byte gýltig
 move.b d0,hdnum(a4)                   * akt. Laufwerknummer setzen
 subq.l #2,d0                          * -2 da keine Floppys
 mulu #hdoff,d0                        * *Offset fýr LW-Speicher
 lea hddat(pc),a6                      * Laufwerksspeicher laden
 adda.l d0,a6                          * auf richtigen Bereich
 rts


GetDrive:                               * Laufwerksdaten laden
 movem.l d1-d2/a0,-(a7)
 bsr Ident                              * LW identifizieren/initialisieren
 tst.l d0
 bmi GDerr
 clr.l d0
 lea buffer(pc),a0
 bsr ReadSec                            * MBR lesen
 tst.l d0
 bmi GDerr
 cmp #$55aa,-2(a0)                     * a0 steht "hinter" den Daten
 bne GDerr2                             * MBR nicht gýltig

 lea buffer(pc),a0
 move.b partoff1+typoff(a0),typ1(a6)   * Partitionsdaten speichern
 move.l partoff1+startoff(a0),d0
 bsr LBHLW
 move.l d0,starts1(a6)
 move.l partoff1+sizeoff(a0),d0
 bsr LBHLW
 move.l d0,groesse1(a6)

 move.b partoff2+typoff(a0),typ2(a6)
 move.l partoff2+startoff(a0),d0
 bsr LBHLW
 move.l d0,starts2(a6)
 move.l partoff2+sizeoff(a0),d0
 bsr LBHLW
 move.l d0,groesse2(a6)

 move.b partoff3+typoff(a0),typ3(a6)
 move.l partoff3+startoff(a0),d0
 bsr LBHLW
 move.l d0,starts3(a6)
 move.l partoff3+sizeoff(a0),d0
 bsr LBHLW
 move.l d0,groesse3(a6)

 move.b partoff4+typoff(a0),typ4(a6)
 move.l partoff4+startoff(a0),d0
 bsr LBHLW
 move.l d0,starts4(a6)
 move.l partoff4+sizeoff(a0),d0
 bsr LBHLW
 move.l d0,groesse4(a6)

 clr.l d0
 bra.s GDex
GDerr2:
 move.l #-2,d0
 bra.s GDex
GDerr:
 move.l #-1,d0
GDex:
 movem.l (a7)+,d1-d2/a0
 rts


Ident:                          * Identifiziert ein Laufwerk
 movem.l d3/d4/a0/a1,-(a7)
 move.b hdnum(a4),d4
 sub.b #1,d4                           * LW-Nr -1 (1 und 2 = IDE)
 cmp.b #3,d4
 bge.s idlp01                           * LW-Nr > 2 dann SD
 bsr idetest
 bcs.s idlp20                           * Laufwerk nicht gefunden
 bra.s idlp02                           * sonst weiter
idlp01:
 sub.b #2,d4                           * LW-Nr -2 (1 und 2 = SD)
 cmp.b #3,d4
 bge.s idlp20                           * LW-Nr > 2 dann Fehler
 bsr sdtest
 bcs.s idlp20                           * Laufwerk nicht gefunden
idlp02:
 movea.l a6,a1
 adda.l #Diskname,a1
 adda.l #hdname,a0
 move #12-1,d3
idlp10:
 move.b (a0)+,(a1)+
 dbra d3,idlp10
 move #$0,(a1)+
 clr.l d0
 bra.s idex
idlp20:
 move.l #-1,d0
idex:
 movem.l (a7)+,d3/d4/a0/a1
 rts


ReadSec:                * liest einen Sektor D0=Sektornummer,A0=Puffer
 movem.l d1-d4/d7,-(a7)
 moveq.l #1,d1                         * Read-Befehl
 move.l d0,d2                          * Sektornummer
 moveq.l #1,d3                         * einen Sektor
 clr.l errnum(a4)
 move.b hdnum(a4),d4
 sub.b #1,d4                           * LW-Nr - 1 (1 und 2 = IDE)
 cmp.b #3,d4
 bge.s RdSlp01                          * LW-Nr > 3 dann SD
 bsr idedisk                            * Sektor lesen aufrufen
 bcs.s RdSerr                           * Lesefehler
 bra.s RdSlp20                          * sonst fertig
RdSlp01:
 sub.b #2,d4                           * LW-Nr -2 (1 und 2 = SD)
 cmp.b #3,d4
 bge.s RdSerr1                          * LW-Nr > 3 dann Fehler
 bsr sddisk                             * Sektor lesen aufrufen
 bcs.s RdSerr                           * Lesefehler
 bra.s RdSlp20                          * sonst fertig
RdSerr:
 move.l #5,errnum(a4)
RdSerr1:
 moveq.l #-1,d0
 bra.s RdSex
RdSlp20:
 adda.l #512,a0                        * a0 bereit fýr nûchsten Sektor
 clr.l d0
RdSex:
 movem.l (a7)+,d1-d4/d7
 rts


WriteSec:               * schreibt einen Sektor D0=Sektornummer,A0=Puffer

 movem.l d1-d4/d7,-(a7)
 moveq.l #2,d1                         * Write-Befehl
 move.l d0,d2                          * Sektornummer
 moveq.l #1,d3                         * einen Sektor
 clr.l errnum(a4)
 move.b hdnum(a4),d4
 sub.b #1,d4                           * LW-Nr -1 (1 und 2 = IDE)
 cmp.b #3,d4
 bge.s WrSlp01                          * LW-Nr > 2 dann SD
 bsr idedisk                            * Sektor lesen aufrufen
 bcs.s WrSerr                           * Lesefehler
 bra.s WrSlp20                          * sonst fertig
WrSlp01:
 sub.b #2,d4                           * LW-Nr - 2 (1 und 2 = SD)
 cmp.b #3,d4
 bge.s WrSerr1                          * LW-Nr > 2 dann Fehler
 bsr sddisk                             * Sektor lesen aufrufen
 bcs.s WrSerr                           * Lesefehler
 bra.s WrSlp20                          * sonst fertig
WrSerr:
 move.l #6,errnum(a4)
WrSerr1:
 moveq.l #-1,d0
 bra.s WrSex
WrSlp20:
 adda.l #512,a0                        * a0 bereit fýr nûchsten Sektor
 clr.l d0
WrSex:
 movem.l (a7)+,d1-d4/d7
 rts


LBHLW:                          * dreht die Bytes in d0.l
 bsr LowBHigh
 swap d0

LowBHigh:                       * dreht die Bytes in d0.w
 ror #8,d0
 rts


FSChk:                          * Prýft ob FS-Typ d0 entspricht,legt das
                                * Ergebnis in hdbtfild ab
 movem.l d0-d1/d6,-(a7)
 move d0,d1                            * FS-Typ ($06 oder $04 fýr FAT16)
 move.b hdnum(a4),d0                   * Laufwerksnummer
 and.l #$ff,d0                         * nur Byte
 subq.l #2,d0                          * HD-Nr auf 0..n
 bmi.s FSC10                            * keine Floppy
 asl.l #2,d0                           * *4 da max 4 Partitionen
 addq #2,d0                            * +2 fýr Position in Bitfield
 clr.l d6                               * als Bitfeld Merker
 cmp.b typ1(a6),d1                     * Vergleich ob FS-Typ stimmt
 bne.s FSC01
 bset.l d0,d6
FSC01:
 addq #1,d0
 cmp.b typ2(a6),d1
 bne.s FSC02
 bset.l d0,d6
FSC02:
 addq #1,d0
 cmp.b typ3(a6),d1
 bne.s FSC03
 bset.l d0,d6
FSC03:
 addq #1,d0
 cmp.b typ4(a6),d1
 bne.s FSC10
 bset.l d0,d6
FSC10:
 or.l d6,hdbtfild(a4)
 movem.l (a7)+,d0-d1/d6
 rts


ALW:
 movem.l d0/d3/d6,-(a7)
 clr aktlw(a4)
 move.l hdbtfild(a4),d6
 asr.l #2,d6                           * FD0 und FD1 nicht checken
 move #1,d0                            * erst mit HDA1 anfangen
 move #16-1,d3                         * HDA1 bis SDB4
ALW01:                                  * aktives LW ermitteln
 addq #1,d0
 asr.l #1,d6
 bcs.s ALW10
 dbra d3,ALW01
ALW10:
 move d0,aktlw(a4)
 bsr LoadLW
ALW11:
 movem.l (a7)+,d0/d3/d6
 rts


LoadLW:                         * Liest die LW- (Parttitions-) Daten
 movem.l d1/a0,-(a7)
 move aktlw(a4),d0
 and.l #$ff,d0                 * nur Byte gýltig
 subq #2,d0                    * LW-Nummer - 2
 bmi LLWErr                     * Disketten Laufwerke nicht unterstýtzt
 cmp.b #16,d0
 bge LLWErr                     * Reserve Laufwerke
 divu #4,d0                    * /4
 move.l d0,d1                  * Rest in d1 als Partitionszûhler
 swap d1                        * im unteren Wort
 addq #2,d0                    * +2 dann HD-Nummer
 bsr SetLW
 cmp.b #0,d1
 bne.s LLW00
 move.l starts1(a6),d0
 bra.s LLW20
LLW00:
 cmp.b #1,d1
 bne.s LLW01
 move.l starts2(a6),d0
 bra.s LLW20
LLW01:
 cmp.b #2,d1
 bne.s LLW02
 move.l starts3(a6),d0
 bra.s LLW20
LLW02:
 cmp.b #3,d1
 bne LLWErr
 move.l starts4(a6),d0
 bra.s LLW20
 lea buffer(pc),a0
LLW20:
 bsr LoadBPB
 tst.l d0
 bmi.s LLWErr
 lea txtroot(pc),a0
 move.b (a0)+,NoAD(a6)
 move.b (a0),NoAD+1(a6)
LLWOK:
 clr.l d0
 bra.s LLWExit
LLWErr:
 move.l #-1,d0
LLWExit:
 movem.l (a7)+,d1/a0
 rts


LoadBPB:                        * Liest die BPB Daten ein D0=Partitions-Offset
 movem.l d1-d2/a0,-(a7)
 move.l d0,d2                          * sichern
 lea buffer(pc),a0
 bsr ReadSec                            * Boot-Sektor lesen
 tst.l d0
 bmi LdBPBerr
 lea buffer(pc),a0

 adda.l #$B,a0                         * BPS Offset
 move.b (a0)+,BPS+1(a6)                * Bytes pro Sektor (immer 512!!!)
 move.b (a0)+,BPS(a6)

 move.b (a0)+,SPC(a6)                  * Sektoren pro Cluster

 move.b (a0)+,RSC+1(a6)                * Anzah der reservierten Sektoren
 move.b (a0)+,RSC(a6)

 move.b (a0)+,numFATs(a6)              * Anzahl der FATs

 move.b (a0)+,REC+1(a6)                * Anzahl der eintrûge im Root-DIR
 move.b (a0)+,REC(a6)

 move.b (a0)+,TotSec16+1(a6)           * Anzahl der Sektoren (bei 16 Bit)
 move.b (a0),TotSec16(a6)

 adda.l #2,a0
 move.b (a0)+,FATSz+1(a6)              * Grüsse der FAT in Sektoren
 move.b (a0)+,FATSz(a6)

 adda.l #8,a0
 move.l (a0),d0
 bsr LBHLW
 move.l d0,TotSec32(a6)                * Anzahl der Sektoren (bei 32 Bit)

 clr.l d0
 move REC(a6),d0                       * Anzahl der DIR Eintrûge
 asl.l #5,d0                           * *32 (Grüsse eines Eintrags in Byte)
 add.l #511,d0                         * +BPS-1
 asr.l #8,d0
 asr.l #1,d0                           * /512 (BPS)
 move.l d0,RtDrSec(a6)                 * Anzahl der Root-DIR Sektoren

 move.l d2,d0                          * Partitions-Offset (Boot-Offset)
 clr.l d1
 move RSC(a6),d1                       * Anzahl der reservierten Sektoren
 add.l d1,d0                           * +Boot-Offset
 move.l d0,FATFrst(a6)                 * =Erster FAT Sektor

 clr.l d2
 move.b numFATs(a6),d2                 * Anzahl der FATs
 move FATSz(a6),d1                     * Grüsse der FATs in Sektoren
 mulu d2,d1
 add.l d1,d0                           * +Ersten FAT-Sektor
 move.l d0,RootFrst(a6)                * =Erster Root-DIR Sektor

 clr.l d2
 move.l RtDrSec(a6),d2                 * Anzahl der Root-DIR Sektoren
 add.l d2,d0                           * +Erstem Root-DIR Sektor
 move.l d0,DataFrst(a6)                * =Erster Daten-Sektor

 tst TotSec16(a6)               * falls Anzahl 16 Bit Sektoren=0 dann 32 Bit
 beq.s LBPB01
 move TotSec16(a6),TotSec(a6)          * sonst 16 Bit
 bra.s LBPB02
LBPB01:
 move.l TotSec32(a6),TotSec(a6)
LBPB02:

 clr.l d0
 move RSC(a6),d0
 add.l d0,d1                           * D1=FATSz+RSC
 move.l RtDrSec(a6),d0
 add.l d0,d1                           * D1=FATSz+RSC+RtDrSec
 move.l TotSec(a6),d0
 sub.l d1,d0                           * D0=TotSec-FATSz+RSC+RtDrSec=DataSec
 move.l d0,DataSec(a6)                 * Anzahl der Daten-Sektoren

 clr.l d1
 move.b SPC(a6),d1
 divu d1,d0                            * D0=TotSec/SPC=CntClust
 and.l #$000FFFF,d0
 move.l d0,CntClust(a6)                * Anzahl der Cluster
 addq.l #2,d0
 move.l d0,lastClus(a6)                * CntClust+2=lastClus

 move.l #$FFF8,eoClusCh(a6)            * nur bei FAT16!!!

 clr.l d0
 move.b SPC(a6),d0                     * Sektoren pro Cluster
 move BPS(a6),d1                       * Bytes pro Sektor
 mulu d1,d0
 move.l d0,BPC(a6)                     * BytesPerCluster

 move.l FATFrst(a6),d0                 * Laden des ersten FAT-Sektors
 move.l d0,FATCurr(a6)
 lea fatbuff(pc),a0
 bsr ReadSec
 tst.l d0
 bmi.s LdBPBerr
 clr.b FATStat(a4)
 clr.l FrstDIRC(a6)                     * Erster DIR-Cluster = 0 (Root-DIR)
 clr.l d0
 bra.s LdBPBex
LdBPBerr:
 move.l #-1,d0
LdBPBex:
 movem.l (a7)+,d1-d2/a0
 rts



******  FAT Teil  ******

UpFATBu:                        * Update FAT Buffer d0=newsektor
 movem.l d1/a0,-(a7)
 cmp.l FATCurr(a6),d0
 bne.s UFB01
 clr.l d0
 bra.s UFBex
UFB01:
 move.l d0,d1                          * sichern
 tst.b FATStat(a4)
 beq.s UFB02
 move.l FATCurr(a6),d0
 lea fatbuff(pc),a0
 bsr WriteSec
 tst.l d0
 bmi.s UFBerr                           * Schreibfehler
UFB02:
 move.l d1,d0
 lea fatbuff(pc),a0
 bsr ReadSec
 tst.l d0
 bmi.s UFBerr                           * Lesefehler
 move.l d1,FATCurr(a6)
 clr.b FATStat(a4)
 clr.l d0
 bra.s UFBex
UFBerr:
 move.l #-1,d0
UFBex:
 movem.l (a7)+,d1/a0
 rts

FFAT:                           * Flush FAT Buffer
 movem.l a0,-(a7)
 move.l FATCurr(a6),d0
 lea fatbuff(pc),a0
 bsr WriteSec
 tst.l d0
 bmi.s FFATerr                          * Schreibfehler
 clr.b FATStat(a4)
 clr.l d0
 bra.s FFATex
FFATerr:
 move.l #-1,d0
FFATex:
 movem.l (a7)+,a0
 rts

GNCN:                           * GetNextClusterNumber d0=Clusternummer
 movem.l d1-d2/a0,-(a7)
 and.l #$ffff,d0                       * auf Wort
 cmp.l lastClus(a6),d0
 bgt GNCNerr1                           * Disk voll
 move.l d0,d2                          * sichern
 lsr.l #8,d0                           * *2 / 512 (BPS)
 add.l FATFrst(a6),d0
 bsr UpFATBu
 tst.l d0
 bmi.s GNCNerr                          * Schreib-/Lesefehler
 move.l d2,d0                          * zurýck
 asl.l #1,d0                           * *2
 and.l #$1ff,d0                        * Rest von /512 (BPS)
 lea fatbuff(pc),a0
 clr.l d1
 move.b 1(a0,d0),d1
 lsl #8,d1
 move.b 0(a0,d0),d1
 move.l d1,d0
 bra.s GNCNex
GNCNerr1:
 move.l #7,errnum(a4)                  * Disk full
GNCNerr:
 move.l #-1,d0
GNCNex:
 movem.l (a7)+,d1-d2/a0
 rts

GFSOC:                          * GetFirstSektorOfCluster d0=Cluster
 move.l d1,-(a7)
 and.l #$ffff,d0                       * auf Wort
 subq.l #2,d0
 clr.l d1
 move.b SPC(a6),d1
 mulu d1,d0
 add.l DataFrst(a6),d0
 move.l (a7)+,d1
 rts

AllClus:                        * AllocCluster d0=currentcluster
 movem.l d1-d2,-(a7)
 move.l d0,d1                          * CurrentCluster sichern
 bsr FFC                                * FindFreeCluster
 cmp.l #-1,d0                          * Fehler?
 beq.s ACerr                            * jo
 move.l d0,d2                          * neuen Cluster sichern
 tst.l d1                               * neuer Clusterchain?
 beq.s AClp01                           * jo
 exg d0,d1                             * neue Clusternr in Alten
 bsr WCN                                * WriteClusterNumber
 tst.l d0                               * hats geklappt?
 bmi.s ACerr                            * nü
AClp01:
 move.l d2,d0                          * neuen Cluster zurýck
 move.l #$FFFF,d1                      * Clusterchain Ende
 bsr WCN                                * WriteClusterNumber
 tst.l d0                               * alles OK?
 bmi.s ACerr                            * nü
 move.l d2,d0                          * neuen Cluster zurýck
 bra.s ACex
ACerr:
 move.l #-1,d0
ACex:
 movem.l (a7)+,d1-d2
 rts

FFC:                            * FindFreeCluster d0 = currentcluster
 movem.l d1-d2,-(a7)
 move.l d0,d1                          * CurrentCluster sichern
 addq.l #1,d0
FFClp01:
 cmp.l lastClus(a6),d0
 bge.s FFClp02
 move.l d0,d2                          * Cluster sichern
 bsr GNCN                               * GetNextClusterNumber
 cmp.l #-1,d0
 beq.s FFCerr                           * Schreib-/Lesefehler
 tst.l d0
 bne.s FFClp03                          * Cluster nicht leer,weiter
 move.l d2,d0
 bra.s FFCex
FFClp03:
 move.l d2,d0
 addq.l #1,d0
 bra.s FFClp01
FFClp02:
 move.l #2,d0                          * erster Cluster
FFClp04:
 cmp.l d1,d0
 bge.s FFCerr1                          * kein freier Cluster
 move.l d0,d2
 bsr GNCN                               * GetNextClusterNumber
 cmp.l #-1,d0
 beq.s FFCerr                           * Schreib-/Lesefehler
 tst.l d0
 bne.s FFClp05                          * Cluster nicht leer,weiter
 move.l d2,d0
 bra.s FFCex
FFClp05:
 move.l d2,d0
 addq.l #1,d0
 bra.s FFClp04
FFCerr1:
 move.l #8,errnum(a4)
FFCerr:
 move.l #-1,d0
FFCex:
 movem.l (a7)+,d1-d2
 rts

WCN:                            * WriteClusterNumber
                                * D0.l=Cluster Nummer,D1.w=Wert
 movem.l d1/d3/a0,-(a7)
 cmp.l lastClus(a6),d0
 ble.s WCN01
 move.l #25,errnum(a4)
 bra.s WCNerr
WCN01:
 move.l d0,d3                          * Cluster sichern
 lsr.l #8,d0                           * *2/512(BPS)=> /256
 add.l FATFrst(a6),d0                  * +FATFirst
 bsr UpFATBu                            * UpdateFATBuffer
 tst.l d0
 bmi.s WCNerr
 lea fatbuff(pc),a0
 move.l d3,d0
 asl.l #1,d0                           * Cluster * 2
 and.l #$1ff,d0                        * => mod 512
 adda.l d0,a0
 move.b d1,(a0)+
 lsr #8,d1
 move.b d1,(a0)
 move.b #1,FATStat(a4)
 clr.l d0
 bra.s WCNex
WCNerr:
 move.l #-1,d0
WCNex:
 movem.l (a7)+,d1/d3/a0
 rts


***** DOS Teil *****

FFFD:                           * Find Free File Descriptor
 movem.l d3/a0,-(a7)
 clr.l d0
 move #maxofile-1,d3
 lea filebuff(pc),a0
FFFD01:
 tst.b FileFlag(a0)
 beq.s FFFD10
 addq #1,d0
 adda.l #FDOff,a0
 dbra d3,FFFD01
 move.l #-1,d0
 move.l #9,errnum(a4)
 bra FFFDExit
FFFD10:
 move.b #-1,FileFlag(a0)               * File üffnen
 clr.b FileDOff(a0)
 clr.l FileCSec(a0)
 clr.l File1CS(a0)
 clr.l FileDSec(a0)
 clr.l FileSize(a0)
 clr.l FilePos(a0)
 clr.b FileAttr(a0)
 clr.l File1C(a0)
 clr.l FileCurC(a0)
 clr.l FileCC(a0)
FFFDExit:
 movem.l (a7)+,d3/a0
 rts


FindName:                               * d0 = FileID
 movem.l d1,-(a7)
 * cmp #-1,d0
 cmp #$FFFF,d0
 beq.s FNerr                            * keine Suche zu viele offene Dateien
 cmp #maxofile,d0
 bge.s FNerr                            * FileID zu gross
 cmp.l #2,FrstDIRC(a6)
 bge.s FN01
 bsr ScRD                               * ScanRootDIR
 bra.s FNex
FN01:
 move.l FrstDIRC(a6),d1
 bsr ScSD                               * Scan Sub-DIR
 bra.s FNex
FNerr:
 move.l #NO_MATCH,d0
FNex:
 movem.l (a7)+,d1
 rts


fload:                                  * Lûdt eine Datei in den Arbeitsspeicher
                                        * d0=FileID
 movem.l d2-d4/d6/a0-a3,-(a7)
 bsr FileDsct                           * File Daten in a0
 movea.l a0,a2                         * in a2 sichern
 move.l FileSize(a2),d2                * Dateigrüsse
 move.l d2,d3
 asr.l #8,d3
 asr.l #1,d3                           * d0 = Dateigrüsse in Sektoren
 and.l #$1ff,d2                        * noch ein Teilsektor ?
 tst d2
 beq.s fld01                            * nü
 addq.l #1,d3                          * sonst ein Sektor mehr
fld01:
 subq.l #1,d3                          * Als Zûhler
 movea.l FileAdr(a2),a0                * RAM-Adresse in a0

 movea.l a0,a3                         * sichern
 move.l d3,d2                          * Sektoranzahl-1
 asl.l #8,d2
 asl.l #1,d2                           * *512 (BPS)
 adda.l d2,a3                          * zum RAM-Start
 move #512-1,d2
fld02:
 clr.b (a3)+                            * die letzten 512 Byte lüschen
 dbra d2,fld02
 movea.l a0,a3
 move.l File1C(a2),d6                  * erster Cluster der Datei
fld03:
 cmp.l eoClusCh(a6),d6                 * vorzeitiges Ende ?
 bge.s flderr
 movea.l a3,a0                         * Speicher wieder holen
 move.l d6,d0
 bsr GFSOC                              * GetFirstSektorOfCluster
 move.l d0,d2                          * merken
 clr.l d4
 move.b SPC(a6),d4                     * Anzahl der Sektoren pro Cluster
 subq.l #1,d4                          * als Zûhler
fld04:
 move.l d2,d0                          * Sektor holen
 bsr ReadSec                            * lesen eines Sektors
 tst.l d0
 bmi.s flderr                           * Fehler beim lesen
 addq.l #1,d2                          * nûchster Sektor
 subq.l #1,d3
 bmi.s fld10                            * fertig!
 dbra d4,fld04                         * nûchster Sektor des Clusters
 movea.l a0,a3                         * RAM sichern
 move.l d6,d0
 bsr GNCN                               * GetNextClusterNumber
 tst.l d0
 bmi.s flderr
 move.l d0,d6
 bra.s fld03
fld10:
 clr.l d0
 bra.s fldex
flderr:
 move.l #-1,d0
fldex:
 movem.l (a7)+,d2-d4/d6/a0-a3
 rts


fsave:                                  * Speichert eine Datei
                                        * d0=FileID
 movem.l d2-d4/d6/a0-a3,-(a7)
 bsr FileDsct                           * File Daten in a0
 movea.l a0,a2                         * in a2 sichern
 move.l FileSize(a2),d2                * Dateigrüsse
 move.l d2,d3
 asr.l #8,d3
 asr.l #1,d3                           * d3 = Dateigrüsse in Sektoren
 and.l #$1ff,d2                        * noch ein Teilsektor ?
 tst d2
 beq.s fsv01                            * nü
 addq.l #1,d3                          * sonst ein Sektor mehr
fsv01:
 subq.l #1,d3                          * Als Zûhler
 movea.l FileAdr(a2),a0                * RAM-Adresse in a0
 movea.l a0,a3                         * sichern
 move.l File1C(a2),d6                  * erster Cluster der Datei
 tst.l d6                               * neuer Clusterchain?
 bne.s fsv02                            * nü
 move.l d6,d0
 bsr AllClus                            * neuen Cluster suchen
 cmp.l #-1,d0
 beq.s fsverr                           * dann Fehler
 move.l d0,d6
fsv02:
 movea.l a3,a0                         * Speicher wieder holen
 move.l d6,d0                          * akt. Cluster
 bsr GFSOC                              * GetFirstSektorOfCluster
 move.l d0,d2                          * merken
 clr.l d4
 move.b SPC(a6),d4                     * Anzahl der Sektoren pro Cluster
 subq.l #1,d4                          * als Zûhler
fsv03:
 move.l d2,d0                          * Sektor holen
 bsr WriteSec                           * Sektor schreiben
 tst.l d0
 bmi.s fsverr                           * Schreibfehler
 addq.l #1,d2                          * nûchster Sektor
 subq.l #1,d3
 bmi.s fsv20                            * FERTIG
 dbra d4,fsv03                         * nûchster Sektor des Clusters
 movea.l a0,a3                         * RAM-Adr. sichern
 move.l d6,d0
 bsr GNCN                               * GetNextClusterNumber
 cmp.l #-1,d0
 beq.s fsverr
 cmp.l eoClusCh(a6),d0                 * Clusterchain zu Ende?
 bge.s fsv10
 move.l d0,d6
 bra.s fsv02
fsv10:
 move.l d6,d0
 bsr AllClus                            * neuen Cluster suchen
 cmp.l #-1,d0
 beq.s fsverr                           * dann Fehler
 move.l d0,d6
 bra.s fsv02                            * sonst weiter
fsv20:
 bsr FFAT                               * FAT speichern
 tst.l d0
 bmi.s fsverr
 clr.l d0
 bra.s fsvex
fsverr:
 move.l #-1,d0
fsvex:
 movem.l (a7)+,d2-d4/d6/a0-a3
 rts

remove:                         * Lüscht Datein. Name in parsdat
 movem.l d1/a0-a1,-(a7)
 bsr FFFD                               * FindFreeFileDiscriptor
 tst.l d0
 bmi rmverr1                            * keine freie FileID
 move.l d0,d1                          * FileID sichern
 bsr FileDsct                           * FileDiscriptor in a0
 movea.l a0,a1                         * sichern
 bsr FindFrst
 tst.l d0                               * was gefunden?
 bmi rmverr                             * nein
 cmp.l #-1,ffpos(a4)
 bne.s rmv01
 move.l #16,errnum(a4)                 * keine Datei da
 bra rmverr
rmv01:
 move.l d1,d0                          * FileID zurýck
 bsr FFD
 btst #4,FileAttr(a1)                * DIR?
 bne rmv05                              * ja,nûchste
 cmp.b #2,JNAFlag(a4)
 beq.s rmv03                            * Alle lüschen
 tst.b quiet(a4)                        * Ausgabe unterdrýcken?
 bne.s rmv02                            * ja
 move.l d1,d0
 lea txtcrlf(pc),a0                    * CRLF vorweg
 bsr writetxt
 bsr NameOut
 lea txtloe(pc),a0                     * lüschen?
 bsr JNA                                * Ja/Nein/Alle
rmv02:
 cmp.b #2,JNAFlag(a4)
 beq.s rmv03                            * alle lüschen
 tst.b JNAFlag(a4)
 beq.s rmv05                            * kein lüschen
 clr.b JNAFlag(a4)                      * nur diese lüschen
rmv03:
 move.l d1,d0                          * FileID zurýck
 bsr rem
 tst.l d0
 bne.s rmverr
 tst.b quiet(a4)                        * Ausgabe unterdrýcken?
 bne.s rmv04                            * ja
 move d1,d0
 lea txtcrlf(pc),a0                    * CRLF vorweg
 bsr writetxt
 bsr NameOut
 lea txtdel(pc),a0
 bsr writetxt
rmv04:
 move.b #$e5,FileName(a1)              * Name gelüscht
 clr.l FileSize(a1)                     * Dateigrüsse = 0
 clr.l File1C(a1)                       * ersterCluster = 0
 clr.b FileAttr(a1)                     * Attribute = 0
 move.l d1,d0                          * FileID zurýck
 bsr UFE                                * UpdateFileEntry
 tst.l d0
 bmi.s rmverr
rmv05:
 move.l d1,d0                          * FileID zurýck
 bsr FindNext
 tst.l d0
 bmi.s rmverr                           * Fehler beim suchen
 cmp.l #-1,ffpos(a4)
 beq.s rmv06                            * keine weiteren Dateien
 bra rmv01
rmv06:
 clr.l d0
 bra.s rmvex
rmverr1:
 moveq.l #-1,d0
 bra.s rmvex1
rmverr:
 moveq.l #-1,d0
rmvex:
 clr.b FileFlag(a1)                     * FileID wieder frei
rmvex1:
 movem.l (a7)+,d1/a0-a1
 rts

rem:                            * Remove-Unterprogramm,d0 = FileID
 movem.l d1-d4/a0-a1,-(a7)
 move.l d0,d4                          * FileID sichern
 bsr FileDsct
 movea.l a0,a1                         * sichern
 move.b FileAttr(a1),d0                * DIR?
 btst #4,d0
 beq.s rem02                            * nein
 move.l #10,errnum(a4)
 bra.s remerr
rem02:
 move.l File1C(a1),d2
rem03:
 move.l d2,d0                          * Cluster
 bsr GNCN
 tst.l d0
 bmi.s remerr
 move.l d0,d3                          * nûchster Cluster
 move.l d2,d0
 clr.l d1
 bsr WCN
 tst.l d0
 bmi.s remerr
 cmp.l eoClusCh(a6),d3
 bge.s rem04                            * Clusterchain durch
 move.l d3,d2                          * Cluster = nûchster Cluster
 bra.s rem03
rem04:
 bsr FFAT
 tst.l d0
 bmi.s remerr                           * Fehler beim schreiben
rem05:
 clr.l d0
 bra.s remex
remerr:
 moveq.l #-1,d0
remex:
 movem.l (a7)+,d1-d4/a0-a1
 rts


QForm:                          * Quickformat des akt. Laufwerks
 movem.l d1-d3/a0-a1,-(a7)
 lea dirbuff(pc),a0                    * DIR Buffer in a0
 movea.l a0,a1                         * nach a1 sichern
 move.l #512-1,d3                      * 512 Byte
QF01:
 move.b #$e5,(a0)+                     * DIR Buffer mit $e5 fýllen
 dbra d3,QF01
 move.l RtDrSec(a6),d3                 * Anzahl der RootDIR Sektoren
 subq.l #1,d3                          * -1 als Zûhler
 move.l RootFrst(a6),d1                * Erster RootDIR Sektor
QF02:
 move.l d1,d0                          * Sektor
 movea.l a1,a0                         * DIR Buffer
 bsr WriteSec                           * Sektor schreiben
 tst.l d0
 bmi QFerr                              * Fehler beim schreiben
 addq.l #1,d1                          * nûchster Sektor
 dbra d3,QF02
 movea.l a1,a0                         * DIR Buffer nach a0
 move.l #512-1,d3                      * 512 Byte
QF03:
 clr.b (a0)+                            * mit 0 fýllen
 dbra d3,QF03
 move.l FATFrst(a6),d1                 * Erster FAT Sektor
 clr.l d2
 move.b numFATs(a6),d2                 * Anzahl der FATs
 subq.l #1,d2                          * -1 als Zûhler
QF04:
 clr.l d3
 move FATSz(a6),d3                     * Grüsse der FATs
 subq.l #2,d3                          * -2 als Zûhler 1.Sec gesondert
 move.l d1,d0                          * Sektor
 movea.l a1,a0                         * Buffer
 move #$f8ff,0(a0)
 move #$ffff,2(a0)                     * Media rein 2 Cluster
 bsr WriteSec                           * 1. Sektor schreiben
 tst.l d0
 bmi.s QFerr                            * Fehler beim schreiben
 clr.l 0(a1)                            * Media raus 2 Cluster
 addq.l #1,d1                          * 2. Sektor
QF05:                                   * 2. bis x. Sektor
 move.l d1,d0                          * Sektor
 movea.l a1,a0                         * Buffer
 bsr WriteSec                           * Sektor schreiben
 tst.l d0
 bmi.s QFerr                            * Fehler beim schreiben
 addq.l #1,d1                          * nûchster Sektor
 dbra d3,QF05
 dbra d2,QF04                          * nûchte FAT
 move.l RootFrst(a6),d0
 movea.l a1,a0
 bsr ReadSec
 tst.l d0
 bmi.s QFerr                            * Fehler beim lesen
 move #$2f00,NoAD(a6)                  * /00
 clr.l FrstDIRC(a6)                     * Erster DIR-Cluster = 0 (Root-DIR)
 move.l FATFrst(a6),d0
 move.l d0,FATCurr(a6)                 *
 lea fatbuff(pc),a0
 bsr ReadSec                            * neue FAT laden
 tst.l d0
 bmi.s QFerr                            * Fehler beim lesen
 clr.b FATStat(a4)
 clr.l d0                               * alles OK
 bra.s QFex
QFerr:
 move.l #-1,d0
QFex:
 movem.l (a7)+,d1-d3/a0-a1
 rts




***** DIR Teil *****

ScRD:                                   * ScanRootDIR / d0.w=FileID
 movem.l d1/d3/d6/d7,-(a7)
 move.l #NO_MATCH,d7                   * d7=result
 move.l RtDrSec(a6),d3
 subq.l #1,d3
 move.l RootFrst(a6),d1
 move.l d0,d6                          * FileID sichern
ScRD01:
 move.l d6,d0                          * FileID wieder herstellen
 bsr ScODS                              * ScanOneDirectorySektor
 cmp.l #NO_MATCH,d0
 bne.s ScRDex
 addq.l #1,d1                          * nûchster Sektor
 dbra d3,ScRD01
ScRDerr:
 move.l d7,d0
ScRDex:
 movem.l (a7)+,d1/d3/d6/d7
 rts


ScSD:                           * ScanSubDIR / d0.w=FileID,d1.l=Startcluster
 movem.l d1-d7,-(a7)
 move.l d1,d6                          * Startcluster merken
 move.l d0,d5                          * FileID merken
 move.l #NO_MATCH,d7                   * result
ScSD01:
 cmp.l eoClusCh(a6),d6                 * Ende erreicht?
 beq.s ScSDerr
 move.l d6,d0
 bsr GFSOC                              * GetFirstSektorOfCluster
 move.l d0,d4                          * tmpSektor
 clr.l d3
 move.b SPC(a6),d3
 subq.l #1,d3
ScSD02:
 move.l d5,d0
 move.l d4,d1
 bsr ScODS                              * ScanOneDirectorySektor
 cmp.l #NO_MATCH,d0
 bne.s ScSDex
 addq.l #1,d4                          * tmpSektor+1
 dbra d3,ScSD02
 move.l d6,d0                          * tmpCluster
 bsr GNCN                               * GetNextClusterNumber
 cmp.l #-1,d0
 beq.s ScSDerr
 move.l d0,d6
 bra.s ScSD01
ScSDerr:
 move.l d7,d0
ScSDex:
 movem.l (a7)+,d1-d7
 rts


ScODS:                           * ScanOnDirectorySektor d0.w=FileID,d1.l=Sec
 movem.l d1-d7/a0-a3,-(a7)
 move.l d0,d5                          * FileID sichern
 move.l d1,d6                          * Sektor sichern
 bsr FileDsct
 movea.l a0,a2                         * Sichern
 move.l d1,d0
 lea dirbuff(pc),a0
 bsr ReadSec
 lea dirbuff(pc),a0
 movea.l a0,a3                         * Sichern
 clr.l d3                               * Als Zûhler
ScODS01:
 move.l #NO_MATCH,d7
 tst.b DIRName(a3)                      * =0 dann DIR Ende
 bne.s ScODS10
 move.l #END_DIR,d7
 bra ScODSex
ScODS10:
 cmp.b #$e5,DIRName(a3)                * Eintrag leer
 beq ScODS90
 cmp.b #$0f,DIRAttr(a3)                * Long Filename
 beq ScODS90
 move.l #8,d0
 movea.l a2,a0                         * FileDesc
 adda.l #FileName,a0
 movea.l a3,a1                         * Dirbuffer
 adda.l #DIRName,a1
 bsr strgcmp                            * Stringvergleich
 tst.l d0
 bne.s ScODS21
 move.l #MATCH_N,d7
ScODS21:
 move.l #3,d0
 movea.l a2,a0
 adda.l #FileExt,a0
 movea.l a3,a1
 adda.l #DIRExt,a1
 bsr strgcmp                            * Stringvergleich
 tst.l d0
 bne.s ScODS20
 add.l #MATCH_E,d7
ScODS20:
 move.b DIRAttr(a3),d0
 btst #4,d0
 beq.s ScODS30                          * kein DIR
                                        * DIR Teil
 move DIR1CH(a3),d0                    * tmp
 bsr LowBHigh
 move d0,d4
 swap d4
 move DIR1CL(a3),d0                    * tmp.l LBHW??????
 bsr LowBHigh
 move d0,d4
 cmp.l #FULL_MAT,d7
 bne.s ScODS30
 move.l d4,File1C(a2)
 bra.s ScODSex

ScODS30:
 move DIR1CH(a3),d0                    * tmp.w
 bsr LowBHigh
 move d0,d4
 swap d4
 move DIR1CL(a3),d0                    * tmp.l LBHW?????
 bsr LowBHigh
 move d0,d4
 cmp.l #FULL_MAT,d7                    * stimmt die Datei?
 bne.s ScODS90                          * nü also weiter

 move.l d6,FileDSec(a2)                * File Teil
 move.l d3,d0                          * Zûhler
 lsr.l #5,d0                           * / 32
 move.b d0,FileDOff(a2)
 move.l d4,File1C(a2)                  * tmp
 move.l DIRSize(a3),d0
 bsr LBHLW
 move.l d0,FileSize(a2)
 move.b #0,FileAttr(a2)                * 0=Datei
 bra.s ScODSex
ScODS90:
 adda.l #32,a3
 add.l #32,d3
 cmp BPS(a6),d3
 bge.s ScODSerr
 bra ScODS01
ScODSerr:
 move.l #NO_MATCH,d7
ScODSex:
 move.l d7,d0
 movem.l (a7)+,d1-d7/a0-a3
 rts


FileDsct:                       * liefert in A0 den FileDiscriptor Block
                                        * zur FileID in d0.w
 move.l d0,-(a7)
 and.l #$FFFF,d0                       * nur Wort gýltig
 mulu #FDOff,d0                        * FileID*FileDiscriptorOffset
 lea filebuff(pc),a0                   *
 adda.l d0,a0                          * + Basis
 move.l (a7)+,d0
 rts


FNE:                            * FileNameEmpty / d0.w=FileID
 movem.l d3/a0-a1,-(a7)
 bsr FileDsct
 movea.l a0,a1                         * Sichern
 adda.l #FileName,a0
 move #8-1,d3                          * 8 Stellen Name
FNE01:
 cmp.b #' ',(a0)+
 bne.s FNEerr
 dbra d3,FNE01
 adda.l #FileExt,a1
 move #3-1,d3                          * 3 Stellen Extension
FNE02:
 cmp.b #' ',(a1)+
 bne.s FNEerr
 dbra d3,FNE02
 clr.l d0                               * ist leer
 bra.s FNEex
FNEerr:
 move.l #1,d0
FNEex:
 movem.l (a7)+,d3/a0-a1
 rts


MFN:                            * MakeFileName / d0.w=FileID,ParsDat=Name.Ext
                                * copiert den Dateiname/ext. in den FileDsc
 movem.l d0/d3/a0-a3,-(a7)
 lea parsdat(pc),a2
 movea.l a2,a1
 adda.l #pqdatn,a1                     * a1 auf Dateiname
 adda.l #pqdate,a2                     * a2 auf Extension
 bsr FileDsct                           * FileDisct in A0
 movea.l a0,a3
 adda.l #FileName,a0
 move #8-1,d3
MFN01:
 move.b #' ',(a0)+                     * Name mit Space fýllen
 dbra d3,MFN01
 movea.l a3,a0
 adda.l #FileExt,a0
 move.b #' ',(a0)+                     * Ext mit Space fýllen
 move.b #' ',(a0)+
 move.b #' ',(a0)
 movea.l a3,a0
 adda.l #FileName,a0
MFN03:
 move #8-1,d3
MFN04:
 move.b (a1)+,d0
 tst.b d0
 beq.s MFN10
 move.b d0,(a0)+
 dbra d3,MFN04
MFN10:
MFN11:
 movea.l a3,a0
 adda.l #FileExt,a0
 move #3,d3
MFN12:
 move.b (a2)+,d0
 tst.b d0
 beq.s MFNex
 move.b d0,(a0)+
 dbra d3,MFN12
MFNex:
 movem.l (a7)+,d0/d3/a0-a3
 rts


FFD:                            * FillFileDiscriptor
                                * File-ID in d0,Filedaten in ffsec und ffpos
                                * Kopiert die Filedaten vom DIR in FileDsct
 movem.l d1/a0-a3,-(a7)
 move.l ffpos(a4),d1                   * gýltige Daten?
 bmi FFDerr                             * nein!
 bsr FileDsct                           * FileDiscriptor in A0
 movea.l a0,a3                         * sichern
 lea dirbuff(pc),a1
 adda.l ffpos(a4),a1                   * auf akt. Datei
 movea.l a1,a2
 adda.l #FileName,a0
 move #8-1,d3
FFD01:
 move.b #' ',(a0)+                     * Name mit Space fýllen
 dbra d3,FFD01
 movea.l a3,a0
 adda.l #FileExt,a0
 move.b #' ',(a0)+                     * Ext mit Space fýllen
 move.b #' ',(a0)+
 move.b #' ',(a0)
 movea.l a3,a0
 adda.l #FileName,a0
 adda.l #DIRName,a1
FFD03:
 move #8-1,d3
FFD04:                                  * Name kopieren
 move.b (a1)+,d0
 tst.b d0
 beq.s FFD10
 move.b d0,(a0)+
 dbra d3,FFD04
FFD10:
FFD11:
 movea.l a3,a0
 adda.l #FileExt,a0
 movea.l a2,a1
 adda.l #DIRExt,a1
 move #3,d3
FFD12:                                  * Ext kopieren
 move.b (a1)+,d0
 tst.b d0
 beq.s FFD13
 move.b d0,(a0)+
 dbra d3,FFD12
FFD13:
 move.l ffsec(a4),FileDSec(a3)         * File-DIR-Sektor
 lsr.l #5,d1                           * /32
 move.b d1,FileDOff(a3)                * File-DIR-Offset
 move DIR1CH(a2),d0                    * First-File-Cluster-High
 bsr LowBHigh
 move d0,d1
 swap d1
 move DIR1CL(a2),d0                    * First-File-Cluster-Low
 bsr LowBHigh
 move d0,d1
 move.l d1,File1C(a3)                  * FileFirstCluster
 move.l DIRSize(a2),d0                 * File Size
 bsr LBHLW
 move.l d0,FileSize(a3)
 move.b DIRAttr(a2),FileAttr(a3)       * File Attribute
 clr.l d0
 bra.s FFDex
FFDerr:
 move.l #-1,d0
FFDex:
 movem.l (a7)+,d1/a0-a3
 rts


chdir:                          * zum Verzeichnis wechseln
                                * DIR-Name in parsdat
                                * setzt FrstDIRC und NoAD
 movem.l d2-d3/a0-a2,-(a7)
 bsr FFFD                               * FindFreeFileDiscriptor
 tst.l d0
 bmi cderr                              * kein freier Dateihûndel
 move d0,d2                            * sichern
 bsr FileDsct                           * FileDiscriptor Adresse in a0 laden
 lea parsdat(pc),a2
 adda.l #pqdatn,a2                     * a2 auf Quell-Dateiname
 cmp.b #'/',(a2)                       * RootDIR ?
 bne.s cd01                             * nü
 clr.l FrstDIRC(a6)                     * FirstDIRCluster=0
 move #$2f00,NoAD(a6)                  * akt DIRName = "/0"
 bra.s cdok
cd01:
 move d2,d0                            * FileID zurýck holen
 bsr MFN                                * MakeFileName
 move d2,d0                            * Vorsichtshalber
 bsr FindName                           * FindName
 cmp.l #FULL_MAT,d0                    * Datei gefunden?
 bne.s cderr1                           * nü
 move.l File1C(a0),d0
 move.l d0,FrstDIRC(a6)
 move #8-1,d3
 movea.l a0,a1
 adda.l #FileName,a1                   * a1 auf FileName im FileDesc
 movea.l a6,a2
 adda.l #NoAD,a2                       * a2 auf akt. DIRname
cd02:
 move.b (a1)+,d0                       * DIRname einlesen
 beq.s cd03                             * falls ne 0
 cmp.b #' ',d0
 beq.s cd03                             * falls Leerzeichen
 move.b d0,(a2)+                       * sonst speichern
 dbra d3,cd02
cd03:
 clr.b (a2)                             * mit 0 abschliessen
cdok:
 move.l FrstDIRC(a6),d0                * 1. DIR-Cluster
 cmp.l #2,d0                           * RootDIR?
 bge.s cd04                             * nü
 move.l RootFrst(a6),d0                * 1. Root-DIR Sektor
 bra.s cd05
cd04:
 bsr GFSOC                              * GetFirstSektorOfCluster
cd05:
 clr.b FileFlag(a0)                     * Dateihûndel wieder schliessen
 lea dirbuff(pc),a0
 bsr ReadSec                            * 1. DIR-Sektor einlesen
 tst.l d0
 bmi.s cderr
 move #F_OK,d0
 bra.s cdex
cderr1:
 move.l #11,errnum(a4)
cderr:
 clr.b FileFlag(a0)                     * Dateihûndel wieder schliessen
 move #F_ERROR,d0
cdex:
 movem.l (a7)+,d2-d3/a0-a2
 rts


UFE:                            * UpdateFileEntry
                                * d0 = FileID
 movem.l d1/a0-a3,-(a7)
 bsr FileDsct                           * FileDiscriptor in a0
 movea.l a0,a3                         * sichern
 lea dirbuff(pc),a2
 movea.l a2,a0
 move.l FileDSec(a3),d0                * DIR-Sektor nach d0
 bsr ReadSec                            * DIR-Sektor lesen
 tst.l d0
 bmi UFEerr                             * Lesefehler
 clr.l d0
 move.b FileDOff(a3),d0
 asl.l #5,d0                           * *32
 adda.l d0,a2                          * a2 auf akt. DIR-Eintrag
 movea.l a2,a1
 adda.l #DIRName,a1
 movea.l a3,a0
 adda.l #FileName,a0
 move.l #8,d0
 bsr strgcopy                           * NAME kopieren
 movea.l a2,a1
 adda.l #DIRExt,a1
 movea.l a3,a0
 adda.l #FileExt,a0
 move.l #3,d0
 bsr strgcopy                           * EXT kopieren
 move.b FileAttr(a3),d0
 move.b d0,DIRAttr(a2)                 * Attribute kopieren
 clr.b DIREZt(a2)                       * Erstellungs 10tel lüschen
                                        * Erstellungszeit bleibt!
 movea.l a3,a0
 adda.l #Fiob,a0                       * Fiob als Puffer fýr Uhr
 bsr getuhr
 movea.l a3,a0
 adda.l #Fiob,a0                       * a0 auf GP-Uhrzeit
 clr.l d1
 move.b 4(a0),d0                       * Jahr
 bsr bcdtobin
 add.b #20,d0                          * +20 da ab 1980!
 ror #7,d0
 and #$fe00,d0                         * obersten 7 Bits
 or d0,d1                              * in d1 ýbertragen
 move.b 3(a0),d0                       * Monat
 bsr bcdtobin
 asl #5,d0
 and #$01e0,d0                         * 4 Bits in der Mitte
 or d0,d1                              * ab nach d1
 move.b 2(a0),d0                       * Tag
 bsr bcdtobin
 and #$001f,d0                         * die untersten 5 Bits
 or d0,d1                              * nach d1
 swap d1                                * nu die andere Hûlfte
 move.b (a0),d0                        * Stunde
 bsr bcdtobin
 ror #5,d0
 and #$f800,d0                         * obersten 5 Bits
 or d0,d1                              * nach d1
 move.b 1(a0),d0                       * Minute
 bsr bcdtobin
 asl #5,d0
 and #$07e0,d0                         * 6 Bits in der Mitte
 or d0,d1                              * nach d1
 move.b 6(a0),d0                       * Sekunde
 bsr bcdtobin
 asr #1,d0                             * /2
 and #$1f,d0                           * untersten 5 Bits
 or d0,d1                              * nach d1
 move.l d1,d0                          * zurýck nach d0
 bsr LBHLW                              * LowByteHighLangWort
 move.l d0,DIRLCh(a2)                  * im DIR speichern
 clr DIR1CH(a2)                         * HighCluster = 0 FAT16!
 move.l File1C(a3),d0                  * LowCluster
 bsr LowBHigh                           * wieder nach IBM :-(
 move d0,DIR1CL(a2)                    * und speichern
 move.l FileSize(a3),d0                * Datei Grüsse
 bsr LBHLW                              * nach IBM
 move.l d0,DIRSize(a2)                 * speichern
 move.l FileDSec(a3),d0
 lea dirbuff(pc),a0
 bsr WriteSec
 tst.l d0
 beq.s UFEex
UFEerr:
 moveq.l #-1,d0
UFEex:
 movem.l (a7)+,d1/a0-a3
 rts


mkdir:                          * Verzeichnis erstellen
                                * DIR-Name in parsdat
 movem.l d2-d3/a0-a3,-(a7)
 bsr FFFD                               * FindFreeFileDiscriptor
 tst.l d0
 bmi mkdirer1                           * kein freier Dateihûndel
 move.l d0,d2                          * sichern
 bsr MFN                                * MakeFileName
 bsr FindName                           * Name schon vorhanden?
 cmp.l #FULL_MAT,d0
 bne.s mkdir00
 move.l #13,errnum(a4)
 bra mkdirerr                           * DIR ist vorhanden,Fehler
mkdir00:
 move.l d2,d0                          * FileID zurýck
 bsr FileDsct                           * FileDiscriptor Adresse in a0 laden
 movea.l a0,a1                         * sichern
 move.b #$10,FileAttr(a1)              * DIR Attribut setzen
 move.l d2,d0                          * FileID zurýck
 bsr MNFE                               * neuer DIR-Eintrag
 tst.l d0                               * alles OK?
 bmi mkdirerr                           * nee

 tst.b quiet(a4)                        * Ausgabe unterdrýcken?
 bne.s mkdir03                          * ja
 lea txtcrlf(pc),a0                    * CRLF vorweg
 bsr writetxt
 lea txtverz(pc),a0
 bsr writetxt
 move.l d2,d0
 bsr NameOut
 lea txterst(pc),a0
 bsr writetxt

mkdir03:
 move.l File1C(a1),d0                  * der 1te Cluster
 bsr GFSOC                              * GetFirstSektorOfCluster
 move.l d0,FileDSec(a1)                * 1. Sektor speichern
 move.l d0,d1                          * sichern
 lea dirbuff(pc),a0
 move #512-1,d3                        * BPS-1
mkdir01:
 clr.b (a0)+                            * Dirbuffer lüschen
 dbra d3,mkdir01
 clr.l d3
 move.b SPC(a6),d3                     * SektorenProCluster
 subq.l #1,d3                          * -1 als Zûhler
mkdir02:
 lea dirbuff(pc),a0
 move.l d1,d0                          * Sektor zurýck
 bsr WriteSec                           * Sektor schreiben
 tst.l d0
 bmi mkdirerr                           * Schreibfehler
 addq.l #1,d1                          * nûchster Sektor
 dbra d3,mkdir02

 lea parsdat(pc),a2
 movea.l a2,a3
 adda.l #pqdatn,a2                     * a2 auf Quell-Dateiname
 adda.l #pqdate,a3                     * a3 auf Quell-Extension
 move.b #'.',(a2)
 clr.b 1(a2)                            * Dateiname = .0
 clr.b (a3)                             * Extension = 0
 move d2,d0                            * FileID zurýck
 clr.b FileDOff(a1)
 bsr MFN                                * MakeFileName
 move d2,d0                            * FileID zurýck
 bsr UFE                                * UpdateFileEntry
 tst.l d0
 bmi.s mkdirerr

 move.b #'.',1(a2)
 clr.b 2(a2)                            * Dateiname auf ..0
 move.b #1,FileDOff(a1)
 move.l d2,d0                          * FileID zurýck
 bsr MFN
 move.l d2,d0                          * FileID zurýck
 move.l FrstDIRC(a6),File1C(a1)        * UpperDIR Cluster
 bsr UFE                                * UpdateFileEntry
 tst.l d0
 bmi.s mkdirerr

 bsr FFAT
 tst.l d0
 bmi mkdirerr                           * Schreibfehler
 clr.l d0                               * alles OK
 bra.s mkdirex

mkdirer1:
 move.l #-1,d0
 bra.s mkdirex1
mkdirerr:
 move.l #-1,d0
mkdirex:
 clr.b FileFlag(a1)                     * File Hûndel wieder freigeben
mkdirex1:
 movem.l (a7)+,d2-d3/a0-a3
 rts



SRD:                                    * SearchRootDIR d0=FileID
                                        * sucht nach freien DIR-Eintrag
 movem.l d1/d3/d6/d7,-(a7)
 move.l RtDrSec(a6),d3
 subq.l #1,d3
 move.l RootFrst(a6),d1
 move.l d0,d6                          * FileID sichern
SRD01:
 move.l d6,d0                          * FileID wieder herstellen
 bsr SODS                               * SearchOneDirectorySektor
 tst.l d0
 bne.s SRDex
 addq.l #1,d1                          * nûchster Sektor
 dbra d3,SRD01
SRDerr:
 clr.l d0                               * nichts gefunden
SRDex:
 movem.l (a7)+,d1/d3/d6/d7
 rts


SSD:                           * SearchSubDIR / d0.w=FileID,d1.l=Startcluster
 movem.l d1-d7,-(a7)
 move.l d1,d6                          * Startcluster merken
 move.l d0,d5                          * FileID merken
SSD01:
 cmp.l eoClusCh(a6),d6                 * Ende erreicht?
 bge.s SSDerr
 move.l d6,d0
 bsr GFSOC                              * GetFirstSektorOfCluster
 move.l d0,d4                          * tmpSektor
 clr.l d3
 move.b SPC(a6),d3
 subq.l #1,d3
SSD02:
 move.l d5,d0
 move.l d4,d1
 bsr SODS                               * SearchOneDirectorySektor
 tst.l d0                               * was gefunden?
 bne.s SSDex                            * jo
 addq.l #1,d4                          * tmpSektor+1
 dbra d3,SSD02
 move.l d6,d0                          * tmpCluster
 bsr GNCN                               * GetNextClusterNumber
 cmp.l #-1,d0
 beq.s SSDerr
 move.l d0,d6
 bra.s SSD01
SSDerr:
 clr.l d0                               * nichts gefunden
SSDex:
 movem.l (a7)+,d1-d7
 rts


SODS:                           * SearchOneDirectorySektor
                                * d0.w=FileID,d1.l=Sektor
 movem.l d1/d3/a0-a1,-(a7)
 bsr FileDsct
 movea.l a0,a1
 lea dirbuff(pc),a0
 move.l d1,d0                          * Sektor
 bsr ReadSec
 tst.l d0
 bne.s SODSerr                          * konnte nicht gelesen werden
 lea dirbuff(pc),a0
 clr.l d3                               * als Zûhler
SODS01:
 move.b 0(a0,d3.w),d0
 tst.b d0
 beq.s SODS02
 cmp.b #$e5,d0
 beq.s SODS02
 add.l #32,d3
 cmp.l #512,d3                         * Ende erreicht?
 bge.s SODSerr                          * ja,dann Fehler
 bra.s SODS01
SODS02:
 move.l #1,d0
 move.l d1,FileDSec(a1)                * Sektor speichern
 asr.l #5,d3                           * DIR-Offset / 32
 move.b d3,FileDOff(a1)                * und speichern
 bra.s SODSex
SODSerr:
 clr.l d0
SODSex:
 movem.l (a7)+,d1/d3/a0-a1
 rts


MNFE:                           * MakeNewFileEntry d0.w=FileID
 movem.l d1-d3/d6/a0-a2,-(a7)
 move.l d0,d6                          * FileID sichern
 bsr FileDsct                           * a0=FileDiscriptor
 move.l d6,d0                          * FileID zurýck
 movea.l a0,a2                         * sichern
 move.l FrstDIRC(a6),d2
 cmp.l #2,d2                           * 1. DIR-Cluster < 2?
 bge.s MNFE01                           * nü
 bsr SRD                                * sonst SearchRootDIR
 bra.s MNFE02
MNFE01:
 move.l d2,d1                          * StartCluster
 bsr SSD                                * SearchSubDir
MNFE02:
 tst.l d0
 bne MNFE10                             * hat was gefunden
 cmp.l #2,d2                           * wars Root-DIR?
 bge.s MNFE02a                          * nü
 move.l #12,errnum(a4)
 bra MNFEerr                            * sonst Fehler!
MNFE02a:
 move.l d2,d0                          * FirstDIRC
MNFE03:
 move.l d0,d2                          * akt. Cluster merken
 bsr GNCN                               * GetNextClusterNumber
 cmp.l #-1,d0
 beq MNFEerr
 cmp.l eoClusCh(a6),d0                 * EndOfClusterChain?
 blt.s MNFE03                           * nü,dann nochmal
 move.l d2,d0                          * letzten Cluster zurýck
 bsr AllClus                            * Cluster fýrs DIR hohlen
 cmp.l #-1,d0                          * ham wir noch welche?
 beq MNFEerr                            * neee
 move.l d0,d2                          * Cluster sichern
 bsr FFAT
 move #512-1,d3                        * BPS -1,als Zûhler
 lea dirbuff(pc),a0
MNFE04:
 clr.b (a0)+                            * Dirbuffer lüschen
 dbra d3,MNFE04
 move.l d2,d0                          * Cluster zurýck
 bsr GFSOC                              * GetFirstSektorOfCluster
 move.l d0,d1                          * Sektor sichern
 clr.l d3
 move.b SPC(a6),d3                     * SektorenProCluster
 subq.l #1,d3                          * -1 als Zûhler
MNFE05:
 lea dirbuff(pc),a0
 move.l d1,d0
 bsr WriteSec                           * Sektoren mit 0 (NULL) fýllen
 tst.l d0                               * Fehler beim schreiben?
 bne.s MNFEerr                          * JA!
 addq.l #1,d1                          * nûchster Sektor
 dbra d3,MNFE05
 move.l d2,d0                          * Cluster wiederhohlen
 bsr GFSOC
 move.l d0,FileDSec(a2)                * DIR-Sektor speichern
 clr.b FileDOff(a2)                     * DIR-Offset = 0
MNFE10:
 clr.l d0
 bsr AllClus                            * Cluster fýrs File hohlen
 cmp.l #-1,d0
 beq.s MNFEerr                          * keine freien Cluster!
 and.l #$FFFF,d0                       * auf LangWort
 move.l d0,File1C(a2)                  * FileFirstCluster sichern
 clr.l FileSize(a2)                     * FileSize=0
 bsr FFAT
 move.l d6,d0                          * FileID zurýck
 bsr UFE                                * UpdateFileEntry
 clr.l d0                               * alles OK
 bra MNFEex
MNFEerr:
 move.l #-1,d0
MNFEex:
 movem.l (a7)+,d1-d3/d6/a0-a2
 rts


FindFrst:                       * Sucht 1. Datei
 movem.l d1/a0,-(a7)
 move.l #-32,ffpos(a4)                 * Dateiposition lüschen
 clr.l ffsec(a4)                        * DIR-Sektor lüschen
 clr.l ffsecc(a4)                       * DIR-Sektor-Count lüschen
 clr.l ffclus(a4)                       * DIR-Cluster lüschen
 move.l FrstDIRC(a6),d0
 cmp.l #2,d0
 bge.s FF01
 move.l RootFrst(a6),d0                * Root-DIR Sektor laden
 move.l d0,ffsec(a4)
 bra.s FF02
FF01:
 move.l d0,ffclus(a4)
 bsr GFSOC                              * Sub-DIR Sektor laden
 move.l d0,ffsec(a4)
FF02:
 lea dirbuff(pc),a0
 bsr ReadSec
 tst.l d0
 bmi.s FFerr                            * Lesefehler aufgetreten
 bsr FindNext                           * 1. Datei suchen
 tst.l d0
 bmi.s FFerr
 clr.l d0
 bra.s FFex
FFerr:
 move.l #-1,d0
FFex:
 movem.l (a7)+,d1/a0
 rts

FindNext:                       * nûchsten DIR-Eintrag suchen
 movem.l d1-d4/a0-a1,-(a7)
 cmp.l #2,FrstDIRC(a6)
 bge.s FNX10
FNX01:                                  * Root-DIR Teil
 move.l ffsecc(a4),d3                  * Sektor Zûhler
 move.l ffsec(a4),d2                   * akt. RootDIR-Sektor
 move.l ffpos(a4),d1                   * akt. Position im Sektor
FNX02:
 add.l #32,d1
 cmp.l #512,d1                         * Sektor durch?
 blt.s FNX03                            * nein
 clr.l d1                               * Position auf Null
 addq.l #1,d2                          * nûchster Sektor
 addq.l #1,d3
 cmp.l RtDrSec(a6),d3                  * Ende des DIRs?
 bge FNXnf                              * DIR ist durch,nichts gefunden
 move.l d2,d0
 lea dirbuff(pc),a0
 bsr ReadSec                            * neuen Sektor lesen
 tst.l d0
 bmi FNXerr                             * Lesefehler
FNX03:
 lea dirbuff(pc),a1
 adda.l d1,a1
 tst.b (a1)                             * letzter Eintrag?
 beq FNXnf                              * Ja
 cmp.b #$e5,(a1)                       * leerer Eintrag
 beq.s FNX02                            * ja,dann nochmal
 cmp.b #$0f,DIRAttr(a1)                * langer Dateiname?
 beq.s FNX02                            * ja,dann weiter
 bsr dircmp
 tst.l d0
 bmi.s FNX02                            * nichts gefunden,nochmal
 move.l d1,ffpos(a4)
 move.l d2,ffsec(a4)
 move.l d3,ffsecc(a4)
 clr.l d0
 bra FNXex

FNX10:                                  * Sub-DIR Teil
 move.l ffsecc(a4),d4                  * Sektorzûhler
 move.l ffclus(a4),d3                  * akt. SubDIR-Cluster
 move.l ffsec(a4),d2                   * akt. SubDIR-Sektor
 move.l ffpos(a4),d1                   * akt. Position im Sektor
FNX11:
 add.l #32,d1                          * nûchster Eintrag
 cmp.l #512,d1                         * Sektor durch?
 blt.s FNX15                            * nein
 clr.l d1                               * Position auf Null
 addq.l #1,d2                          * Sektor + 1
 addq.l #1,d4                          * Sektorzûhler + 1
 cmp.b SPC(a6),d4                      * letzter Sektor im Cluster?
 blt.s FNX14                            * noch ein Sektor im Cluster
 clr.l d4                               * Sektorzûhler auf Null
 move.l d3,d0                          * akt. Cluster
 bsr GNCN                               * GetNextClusterNumber
 cmp.l eoClusCh(a6),d0                 * Ende des DIRs?
 bge.s FNXnf                            * Ja
 move.l d0,d3                          * neuer Cluster
 bsr GFSOC                              * GetFirstSektorOfCluster
 move.l d0,d2                          * neuer Sektor
FNX14:
 lea dirbuff(pc),a0
 move.l d2,d0
 bsr ReadSec
 tst.l d0
 bmi.s FNXerr                           * Lesefehler
FNX15:
 lea dirbuff(pc),a1
 adda.l d1,a1
 tst.b (a1)                             * letzter Eintrag?
 beq.s FNXnf                            * Ja
 cmp.b #$e5,(a1)                       * leerer Eintrag
 beq.s FNX11                            * ja,dann nochmal
 cmp.b #$0f,DIRAttr(a1)                * langer Dateiname?
 beq.s FNX11                            * ja,dann weiter
 bsr dircmp
 tst.l d0
 bmi.s FNX11                            * nichts gefunden,nochmal
 move.l d1,ffpos(a4)
 move.l d2,ffsec(a4)
 move.l d3,ffclus(a4)
 move.l d4,ffsecc(a4)
 clr.l d0
 bra.s FNXex
FNXnf:
 move.l #-1,ffpos(a4)
 clr.l d0
 bra.s FNXex
FNXerr:
 move.l #-1,ffpos(a4)
 move.l #-1,d0
FNXex:
 movem.l (a7)+,d1-d4/a0-a1
 rts


dircmp:
 movem.l d3/a0-a2,-(a7)
 movea.l a1,a2                         * sichern
 lea parsdat(pc),a0
 move.l pflag(a0),d3
 btst.l #pfqdatn,d3
 beq dircmp30                           * kein Name,auch gut
 adda.l #pqdatn,a0                     * a0 auf Name
 move #8-1,d3
dircmp01:
 move.b (a0)+,d0
 beq.s dircmp05                         * Name stimmt (die Lûnge auch?)
 cmp.b #'*',d0
 beq.s dircmp10                         * Name stimmt
 cmp.b #'?',d0
 bne.s dircmp02
 addq.l #1,a1
 bra.s dircmp03
dircmp02:
 cmp.b (a1)+,d0
 bne.s dircmp20                         * Name stimmt nicht :-(
dircmp03:
 dbra d3,dircmp01
 bra.s dircmp10                         * weiter mit Ext.
dircmp05:
 move.b (a1),d0
 beq.s dircmp10                         * Lûnge stimmt auch :-D
 cmp.b #' ',d0
 beq.s dircmp10                         * ist auch gut
 bra dircmp20                           * ansonsten nicht gut

dircmp10:                               * Vergleich der Ext
 addq.l #8,a2
 lea parsdat(pc),a0
 move.l pflag(a0),d3
 btst.l #pfqdate,d3                    * Extension da?
 beq.s dircmp30                         * nü
 adda.l #pqdate,a0                     * a0 auf Dateiextension
 move #3-1,d3
dircmp11:
 move.b (a0)+,d0
 beq.s dircmp15                         * Ext stimmt (Lûnge auch?)
 cmp.b #'*',d0
 beq.s dircmp30                         * Ext stimmt auch
 cmp.b #'?',d0
 bne.s dircmp12
 addq.l #1,a2
 bra.s dircmp13
dircmp12:
 cmp.b (a2)+,d0
 bne.s dircmp20                         * Ext stimmt nicht :-(
dircmp13:
 dbra d3,dircmp11
 bra.s dircmp30
dircmp15:
 move.b (a2),d0
 beq.s dircmp30                         * Lûnge stimmt auch
 cmp.b #' ',d0
 beq.s dircmp30                         * genauso gut

dircmp20:
 move.l #-1,d0
 bra.s dircmpex
dircmp30:
 clr.l d0
dircmpex:
 movem.l (a7)+,d3/a0-a2
 rts




***** Allgemeine Unterprogramme *****

csts:                           * Wartet auf Tastendruck
 movem.l d0,-(a7)
 bsr key
 movem.l (a7)+,d0
 rts


key:                            * Wartet bis Taste gedrýckt
 movem.l d1-d7/a0-a6,-(a7)     * liefert Taste in d0 zurýck
key01:
 move #13,d7
 trap #1                                * CSTS
 tst.b d0
 beq.s key01
 move #12,d7
 trap #1                                * CI zum Status rýcksetzen
 movem.l (a7)+,d1-d7/a0-a6
 rts


ci:                             * Zeichen von Tastatur einlesen
 movem.l d1-d7/a0-a6,-(a7)
 move #12,d7
 trap #1
 movem.l (a7)+,d1-d7/a0-a6
 rts


cls:                            * Bildschirm lüschen
 movem.l d0-d7/a0-a6,-(a7)
 move #20,d7
 trap #1
 movem.l (a7)+,d0-d7/a0-a6
 rts


co2:                            * ein Zeichen holen
 movem.l d0-d7/a0-a6,-(a7)
 move #33,d7
 trap #1
 movem.l (a7)+,d0-d7/a0-a6
 rts

idetest:                        * IDE-Laufwerk testen/initialisieren
 movem.l d1-d7/a1-a6,-(a7)
 move #154,d7
 trap #1
 movem.l (a7)+,d1-d7/a1-a6
 rts

idedisk:                        * Zugiffe auf IDE-Laufwerke
 movem.l d1-d7/a0-a6,-(a7)
 move #155,d7
 trap #1
 movem.l (a7)+,d1-d7/a0-a6
 rts

sdtest:                         * SD-Laufwerk testen/initialisieren
 movem.l d1-d7/a1-a6,-(a7)
 move #163,d7
 trap #1
 movem.l (a7)+,d1-d7/a1-a6
 rts

sddisk:                         * Zugiffe auf SD-Laufwerke
 movem.l d1-d7/a0-a6,-(a7)
 move #164,d7
 trap #1
 movem.l (a7)+,d1-d7/a0-a6
 rts

writetxt:                       * Textausgabe bis $0
 movem.l d0-d7/a0-a6,-(a7)
wrtxt01:
 move.b (a0)+,d0
 beq.s wrtxtex
 move #33,d7                           * CO2
 trap #1
 bra.s wrtxt01
wrtxtex:
 movem.l (a7)+,d0-d7/a0-a6
 rts

tron:                           * Trace ON
 move.l #1,trace(a4)
 rts

troff:                          * Trace OFF
 clr.l trace(a4)
 rts

trout:                          * Trace OUT
 tst.l trace(a4)
 beq.s troex
 bsr regout
 bsr csts
troex:
 rts

regout:                         * Register-Ausgabe fýr trout
 movem.l d0-d7/a0-a6,-(a7)
 move.l d0,-(a7)
 move #10,d0
 bsr co2
 move #13,d0
 bsr co2
 move.l (a7)+,d0
 bsr printl
 move #' ',d0
 bsr co2
 move.l d1,d0
 bsr printl
 move #' ',d0
 bsr co2
 move.l d2,d0
 bsr printl
 move #' ',d0
 bsr co2
 move.l d3,d0
 bsr printl
 move #' ',d0
 bsr co2
 move.l d4,d0
 bsr printl
 move #' ',d0
 bsr co2
 move.l d5,d0
 bsr printl
 move #' ',d0
 bsr co2
 move.l d6,d0
 bsr printl
 move #' ',d0
 bsr co2
 move.l d7,d0
 bsr printl
 move #13,d0
 bsr co2
 move #10,d0
 bsr co2
 move.l a0,d0
 bsr printl
 move #' ',d0
 bsr co2
 move.l a1,d0
 bsr printl
 move #' ',d0
 bsr co2
 move.l a2,d0
 bsr printl
 move #' ',d0
 bsr co2
 move.l a3,d0
 bsr printl
 move #' ',d0
 bsr co2
 move.l a4,d0
 bsr printl
 move #' ',d0
 bsr co2
 move.l a5,d0
 bsr printl
 move #' ',d0
 bsr co2
 move.l a6,d0
 bsr printl
 move #' ',d0
 bsr co2
 move.l a7,d0
 bsr printl
 move #13,d0
 bsr co2
 move #10,d0
 bsr co2
 movem.l (a7)+,d0-d7/a0-a6
 rts


printl:
 movem.l d0-d7/a0-a6,-(a7)
 lea buffer(pc),a0
 move #44,d7                           * PRINT8X
 trap #1
 lea buffer(pc),a0
 bsr writetxt
 movem.l (a7)+,d0-d7/a0-a6
 rts


print8d:
 movem.l d0-d7/a0-a6,-(a7)
 lea buffer(pc),a0
 move #70,d7                           * PRINT8D
 trap #1
 lea buffer(pc),a1
 move.l a1,d1
 adda.l #15,a1
 addq.l #1,a0
 move.b -(a0),-(a1)                    * die Endnull
 move #14-1,d3                         * 13 weitere Bytes
 clr d2
prt8d01:
 addq #1,d2
 subq #1,d3
 move.b -(a0),-(a1)
 cmpa.l d1,a0
 beq.s prt8d02
 cmp #3,d2
 bne.s prt8d01
 clr d2
 subq #1,d3
 move.b #'.',-(a1)
 bra.s prt8d01
prt8d02:
 move.b #' ',-(a1)
 dbra d3,prt8d02

 lea buffer(pc),a0
 bsr writetxt
 movem.l (a7)+,d0-d7/a0-a6
 rts

print4d:
 movem.l d0-d7/a0-a6,-(a7)
 lea buffer(pc),a0
 move.l #'    ',(a0)
 move #46,d7                           * PRINT4D
 trap #1
 move.b #' ',(a0)                      * Endnull lüschen
 lea buffer(pc),a0
 clr.b 4(a0)                            * neue Endnull
 bsr writetxt
 movem.l (a7)+,d0-d7/a0-a6
 rts

print2d:
 movem.l d0-d7/a0-a6,-(a7)
 lea buffer(pc),a0
 and #$7f,d0                           * nur noch 7 Bit (0-99)
 move #46,d7                           * PRINT4D
 trap #1
 lea buffer(pc),a1
 addq.l #2,a1
 move.l a1,d1
 cmpa.l d1,a0
 beq.s prt2d02
 move.b (a0),(a1)
 move.b -(a0),-(a1)
 move.b #' ',-(a1)
prt2d02:
 lea buffer(pc),a0
 bsr writetxt
 movem.l (a7)+,d0-d7/a0-a6
 rts


print2d0:
 movem.l d0-d7/a0-a6,-(a7)
 lea buffer(pc),a0
 and #$7f,d0                           * nur noch 7 Bit (0-99)
 move #46,d7                           * PRINT4D
 trap #1
 lea buffer(pc),a1
 addq.l #2,a1
 move.l a1,d1
 cmpa.l d1,a0
 beq.s prt2d002
 move.b (a0),(a1)
 move.b -(a0),-(a1)
 move.b #'0',-(a1)
prt2d002:
 lea buffer(pc),a0
 bsr writetxt
 movem.l (a7)+,d0-d7/a0-a6
 rts


wert:
 movem.l d1-d7/a1-a6,-(a7)
 move.l a0,-(a7)                       * A0 auf den Stack
 move #29,d7
 trap #1
 bcs.s werterr
 addq.l #4,a7                          * A0 nicht zurýck,Stack aufrûumen
 movem.l (a7)+,d1-d7/a1-a6
 rts
werterr:
 moveq.l #-1,d0
 movea.l (a7)+,a0                      * A0 zurýck vom Stack
 movem.l (a7)+,d1-d7/a1-a6
 rts
 
 

getuhr:
 movem.l d0-d7/a0-a6,-(a7)
 move #65,d7
 trap #6                                * JADOS Uhr da auch virtuelle Uhr!!!
 movem.l (a7)+,d0-d7/a0-a6
 rts


delay500:
 movem.l d0-d7/a0-a6,-(a7)
 move #50,d0
 move #35,d7
 trap #1
 movem.l (a7)+,d0-d7/a0-a6
 rts


strgcopy:                       * Kopiert D0.l Bytes von (a0) nach (a1)
 movem.l a0-a1,-(a7)
 subq.l #1,d0
sc00:
 move.b (a0)+,(a1)+
 subq.l #1,d0
 bpl.s sc00                             * dbra geht nur auf Wort!!!
 movem.l (a7)+,a0-a1
 rts


strgcmp:                        * Vergleicht d0.l Bytes zwischen (a0) und (a1)
 movem.l a0-a1,-(a7)
 subq.l #1,d0
scmp01:
 cmpm.b (a0)+,(a1)+
 bne.s scmperr
 subq.l #1,d0
 bpl.s scmp01                           * dbra geht nur bis Wort!!!
 clr.l d0                               * d0=0 Strings sind gleich
 bra.s scmpex
scmperr:
 move.l #1,d0                          * d0=1 Strings sind nicht gleich
scmpex:
 movem.l (a7)+,a0-a1
 rts


toupper:                        * Wandelt den Buchstabe in d0 zu Groþbuchstabe
 cmp.b #'a',d0
 blt.s tupex
 cmp.b #'z',d0
 bgt.s tupex                            * nichts umzuwandeln
 sub.b #$20,d0
tupex:
 rts


bcdtobin:                       * wandelt 2 BCD Ziffern in d0.b nach binûr
 move.l d1,-(a7)
 clr.l d1
 move.b d0,d1
 asr.b #4,d1                           * oberes Nibbel
 and.b #$F,d1
 mulu #10,d1                           * *10
 and.b #$f,d0                          * unteres Nibbel
 add.b d1,d0                           * addiert
 move.l (a7)+,d1
 rts


JNA:                            * Abfrage Ja/Nein/Alle a0 = Text
                                * setzt JNAFlag Flag,D0=-1 bei CTRL-C
 movem.l a0,-(a7)
 clr.b JNAFlag(a4)
 bsr writetxt
 lea txtjna(pc),a0
 bsr writetxt
 bsr ci
 cmp.b #$03,d0                         * CTRL-C
 bne.s JNA00
 move.l #-1,d0
 bra.s JNAex1
JNA00:
 bsr toupper
 cmp.b #'A',d0                         * Alle
 bne.s JNA01
 move.b #2,JNAFlag(a4)
 bra.s JNAex
JNA01:
 cmp.b #'J',d0                         * Ja
 bne.s JNAex
 move.b #1,JNAFlag(a4)
JNAex:
 bsr co2                                * Eingabe ausgeben
 clr.l d0
JNAex1:
 movem.l (a7)+,a0
 rts


JN:                             * Abfrage Ja/Nein a0 = Text
                                * setzt JNAFlag D0=-1 bei CTRL-C
 move.l a0,-(a7)
 clr.b JNAFlag(a4)                       * Nein und der Rest
 bsr writetxt
 lea txtjn(pc),a0
 bsr writetxt
 bsr ci
 cmp.b #$03,d0                         * CTRL-C
 bne.s JN01
 move.l #-1,d0
 bra.s JNex1
JN01:
 bsr toupper
 cmp.b #'J',d0                         * Ja
 bne.s JNex
 move.b #1,JNAFlag(a4)
JNex:
 bsr co2                                * Eingabe ausgeben
 clr.l d0
JNex1:
 movea.l (a7)+,a0
 rts


NameOut:                        * Gibt Name.Ext von FileDsct aus
                                * d0 = FileID
 movem.l d0/d3/a0-a2,-(a7)
 bsr FileDsct
 movea.l a0,a1
 lea buffer(pc),a2
 adda.l #FileName,a0
 move #8-1,d3
NO01:
 move.b (a0)+,d0
 cmp.b #' ',d0
 beq.s NO02                             * Ende vom Name
 move.b d0,(a2)+                       * in Buffer
 dbra d3,NO01
NO02:
 move.b #'.',(a2)+                     * der Punkt
 adda.l #FileExt,a1
 move #3-1,d3
NO03:
 move.b (a1)+,d0
 cmp.b #' ',d0
 beq.s NO04
 move.b d0,(a2)+
 dbra d3,NO03
NO04:
 move.b #' ',(a2)+                     * ein Leerzeichen
 clr.b (a2)                             * und ne Null
 lea buffer(pc),a0
 bsr writetxt
 movem.l (a7)+,d0/d3/a0-a2
 rts


trap10:
 movem.l d1-d7/a1-a6,-(a7)             * d0/a0 werden NICHT gesichert
 cmp #trapanz,d7
 bge.s trap10ex                         * Fehler,ungýltige Trapnummer
 lea allgm(pc),a4                      * a4 wiederherstellen
 clr.l errnum(a4)                       * Fehlernummer lüschen
 move.b hdnum(a4),d0
 bsr SetLW                              * a6 wiederherstellen
 lea traptab(pc),a2
 asl #2,d7                             * *4 fýr Langwort
 adda.l 0(a2,d7.w),a2
 jsr (a2)
trap10ex:
 movem.l (a7)+,d1-d7/a1-a6
 *rte
 rts




***** JADOS Aufrufe/Prozeduren *****

jclrfcb:                        * lüscht den FileControlBlock
 movem.l d3/a0,-(a7)
 lea jfcb(pc),a0
 move.l #48-1,d3
jcf01:
 clr.b (a0)+
 dbra d3,jcf01
 movem.l (a7)+,d3/a0
 rts

jfinfo:                         * JADOS File Info
 movem.l d4-d7/a1-a6,-(a7)
 lea jfcb(pc),a1
 move #71,d7
 trap #6
 movem.l (a7)+,d4-d7/a1-a6
 rts

jfillfcb:                       * Dateiname.Ext0 in (a0)
 movem.l d1-d7/a0-a6,-(a7)
 lea jfcb(pc),a1
 move #18,d7
 trap #6
 movem.l (a7)+,d1-d7/a0-a6
 rts

jfload:                         * Lûdt eine Datei nach (a0)
 movem.l d1-d7/a0-a6,-(a7)
 lea jfcb(pc),a1
 move #44,d7
 trap #6
 and.l #$ff,d0                         * auf Langwort
 tst.b d0
 beq.s jfldex
 cmp.b #2,d0                           * Datei da?
 bne.s jfld01
 move.l #-1,d0
 move.l #16,errnum(a4)
 bra.s jfldex
jfld01:
 cmp.b #99,d0                          * genug Speicher?
 bne.s jfld02
 move.l #-1,d0
 move.l #19,errnum(a4)
jfld02:
 move.l #-1,d0
 move.l #20,errnum(a4)
jfldex:
 movem.l (a7)+,d1-d7/a0-a6
 rts

jfsave:                         * Speichert die Datei in (a0)
 movem.l d1-d7/a0-a6,-(a7)
 lea jfcb(pc),a1
 clr.l d1
 move JDatL(a1),d1                     * Dateilûnge nach d1
 subq #1,d1                            * -1
 move #45,d7
 trap #6
 and.l #$ff,d0                         * auf Langwort
 tst.b d0
 beq.s jfsvex
 cmp.b #5,d0                           * Disk voll?
 bne.s jfsv01
 move.l #-1,d0
 move.l #21,errnum(a4)
 bra.s jfsvex
jfsv01:
 cmp.b #6,d0                           * DIR voll?
 bne.s jfsv02
 move.l #-1,d0
 move.l #22,errnum(a4)
 bra.s jfsvex
jfsv02:
 move.l #-1,d0
 move.l #20,errnum(a4)
jfsvex:
 movem.l (a7)+,d1-d7/a0-a6
 rts

jmotoff:                        * Schaltet den Diskettenmotor aus
 movem.l d0-d7/a0-a6,-(a7)
 move #5,d7
 trap #6
 movem.l (a7)+,d0-d7/a0-a6
 rts

jusradr:                        * Liefert die Adresse des Userbereichs in A0
 movem.l d0-d7/a1-a6,-(a7)
 move #58,d7
 trap #6
 movem.l (a7)+,d0-d7/a1-a6
 rts

jconvlw:                        * Convertiert die LW-Bezeichnug nach Binûr
                                * d0.b = 0-4/A-Z -> d0.b = 0-4/5-30
 and.l #$ff,d0                 * auf Langwort
 cmp.b #$30,d0
 blt.s jclwerr
 cmp.b #$34,d0
 bgt.s jclw01
 sub.b #$30,d0
 bra.s jclwex
jclw01:
 cmp.b #$41,d0
 blt.s jclwerr
 cmp.b #$5a,d0
 bgt.s jclwerr
 sub.b #$3c,d0
 bra.s jclwex
jclwerr:
 move.l #-1,d0
 move.l #23,errnum(a4)
jclwex:
 rts



JMDL:                           * JadosMakeDirList legt die Liste der
                                * Jados Datein in jdirbuf,Anzahl in d0
 movem.l d1-d7/a0-a6,-(a7)
 lea parsdat(pc),a0
 movea.l a0,a2
 lea buffer(pc),a1
 adda.l #pqlw,a0                       * Quell Laufwerk
 move.b (a0),(a1)+
 move.b #':',(a1)+                     * der Doppelpunkt
 movea.l a2,a0
 adda.l #pqdatn,a0                     * Quell Dateiname
 move #8-1,d3
JMDL01:
 move.b (a0)+,d0                       * Dateiname
 tst.b d0                               * zu Ende?
 beq.s JMDL02                           * jo
 cmp.b #' ',d0                         * Space auch Ende
 beq.s JMDL02
 move.b d0,(a1)+                       * sonst speichern
 dbra d3,JMDL01                        * nûchstes Zeichen
JMDL02:
 move.b #'.',(a1)+                     * der Punkt
 adda.l #pqdate,a2                     * Extension
 move #3-1,d3
JMDL03:
 move.b (a2)+,d0                       * Dateiextension
 tst.b d0                               * zu Ende?
 beq.s JMDL04                           * jo
 cmp.b #' ',d0                         * Space auch Ende
 beq.s JMDL04
 move.b d0,(a1)+                       * sonst speichern
 dbra d3,JMDL03                        * nûchstes Zeichen
JMDL04:
 clr.b (a1)                             * zum Schluss noch ne NULL

 lea buffer(pc),a1                     * Puffer mit Name
 lea jdirbuf(pc),a0                    * der DIR-Puffer
 move #$1000,d1                        * 4kB DIR-Puffer
 clr d2                                 * nur Dateinamen
 moveq #1,d3                           * eine Spalte
 move #74,d7                           * Jados directory
 trap #6
 tst.b d0                               * Alles OK?
 bne.s JMDLerr                          * nü Fehler

 lea jdirbuf(pc),a0
 clr.l d0
JMDL05:
 cmp.b #' ',0(a0,d0.w)
 ble.s JMDL06                           * kleiner/gleich Space = Ende
 add #16,d0                            * nûchster Name
 cmp #4096,d0                          * Ende des Puffers?
 bge.s JMDL06                           * jo
 bra.s JMDL05                           * weiter
JMDL06:
 lsr.l #4,d0                           * /16 als Zûhler
 bra.s JMDLex
JMDLerr:
 move.l #-1,d0
 move.l #14,errnum(a4)
JMDLex:
 movem.l (a7)+,d1-d7/a0-a6
 rts


JMFN:                           * JadosMakeFileName / jdirbuf=Name.Ext
                                * d0 = DIR Nummer
                                * copiert den Dateiname/ext. in den FCB
 movem.l d0/d3/a0-a3,-(a7)
 lea jdirbuf(pc),a1
 asl.l #4,d0                           * *16 als Offset
 adda.l d0,a1                          * a1 auf Dateiname
 lea jfcb(pc),a0
 movea.l a0,a3
 adda.l #JDName,a0
 move #8-1,d3
JMFN01:
 move.b #' ',(a0)+                     * Name mit Space fýllen
 dbra d3,JMFN01
 movea.l a3,a0
 adda.l #JDExt,a0
 move.b #' ',(a0)+                     * Ext mit Space fýllen
 move.b #' ',(a0)+
 move.b #' ',(a0)
 movea.l a3,a0
 adda.l #JDName,a0
JMFN03:
 move #8,d3                            * 9 Zeichen NAME+.
JMFN04:
 move.b (a1)+,d0
 cmp.b #'.',d0                         * Ende Dateiname?
 beq.s JMFN10
 move.b d0,(a0)+
 dbra d3,JMFN04
JMFN10:
 movea.l a3,a0
 adda.l #JDExt,a0
JMFN12:
 move.b (a1)+,(a0)+                    * Extension kopieren
 move.b (a1)+,(a0)+
 move.b (a1)+,(a0)+
JMFNex:
 movem.l (a7)+,d0/d3/a0-a3
 rts

jtom:                           * Kopiert/konvertiert den FCB nach FileDsct
 movem.l d1/d3/a0-a3,-(a7)
 bsr FFFD                               * FindFreeFileDiscriptor
 tst.l d0
 bmi jtomerr                            * kein freier Datei Hûndel
 move.l d0,d1                          * FileID sichern
 bsr FileDsct                           * FileDiscriptor in a0
 movea.l a0,a2                         * sichern nach a2
 lea jfcb(pc),a1                       * FCB in a1
 movea.l a1,a3                         * sichern nach a3
 adda.l #FileName,a0
 adda.l #JDName,a1
 move #8-1,d3
jtom01:
 move.b (a1)+,(a0)+                    * Dateiname kopieren
 dbra d3,jtom01
 movea.l a2,a0                         * FileDiscriptor zurýck
 movea.l a3,a1                         * FCB zurýck
 adda.l #FileExt,a0
 adda.l #JDExt,a1
 move.b 0(a1),0(a0)                    * Extension kopieren
 move.b 1(a1),1(a0)
 move.b 2(a1),2(a0)
 move d1,d0                            * FileID zurýck
 bsr FindName
 cmp.l #FULL_MAT,d0                    * Datei vorhanden
 bne.s jtom02                           * nein
 cmp.b #2,JNAFlag(a4)                  * Alle ýberschreiben?
 beq.s jtom01a                          * ja!
 tst.b quiet(a4)
 bne jtomerr2                           * keine Ausgabe
 lea txtcrlf(pc),a0                    * CRLF vorweg
 bsr writetxt
 move d1,d0
 bsr NameOut
 lea txtueber(pc),a0
 bsr JNA                                * Ja/Nein/Alle
 tst.l d0                               * Abbruch?
 bmi.s jtomerr3                         * ja
 cmp.b #2,JNAFlag(a4)                  * Alle?
 beq.s jtom01a                          * jo
 tst.b JNAFlag(a4)                      * Nein?
 beq.s jtomerr2                         * jo Fehler aber weiter
 clr.b JNAFlag(a4)                      * ansonsten Ja zurýcksetzen
jtom01a:
 move.l d1,d0                          * FileID zurýck
 bsr rem                                * Datei lüschen
 tst.l d0
 bne.s jtomerr1                         * Fehler beim lüschen
 move.b FileName(a2),d3                * erster Buchstabe des Namen
 move.b #$e5,FileName(a2)              * Name gelüscht
 clr.l FileSize(a2)                     * Dateigrüsse = 0
 clr.l File1C(a2)                       * ersterCluster = 0
 clr.b FileAttr(a2)                     * Attribute = 0
 move.l d1,d0                          * FileID zurýck
 bsr UFE                                * UpdateFileEntry
 tst.l d0
 bmi.s jtomerr1
 move.b d3,FileName(a2)                * erster Buchstabe zurýck ;-)
jtom02:
 move.l d1,d0                          * FileID zurýck
 bsr MNFE                               * MakeNewFileEntry
 tst.l d0
 bmi.s jtomerr1
 clr.l d0
 move JDatL(a3),d0                     * Dateilûnge in Sektoren
 asl.l #8,d0                           * *256
 asl.l #2,d0                           * *4 = *1024 (Sektorlûnge)
 move.l d0,FileSize(a2)                * in FileDsct
 move.l d1,d0                          * FileID zurýck
 bra.s jtomex
jtomerr3:
 clr.b FileFlag(a2)                     * FileID dicht
 move.l #-3,d0                         * Abbruch
 bra.s jtomex
jtomerr2:
 clr.b FileFlag(a2)                     * FileID dicht
 move.l #-2,d0                         * Fehler aber weitermachen
 bra.s jtomex
jtomerr1:
 clr.b FileFlag(a2)                     * FileID dicht
jtomerr:
 move.l #-1,d0
jtomex:
 movem.l (a7)+,d1/d3/a0-a3
 rts


mtoj:                           * Kopiert/Konvertiert den FileDsct nach FCB
                                * d0 = FileID
 movem.l d0/d3/a0-a3,-(a7)
 bsr FileDsct                           * FileDiscriptor in a0
 movea.l a0,a2                         * nach a2 sichern
 bsr jclrfcb                            * FCB lüschen
 lea jfcb(pc),a1                       * FCB in a1
 movea.l a1,a3                         * nach a3 sichern
 adda.l #FileName,a0                   * a0 auf Filename
 adda.l #JDName,a1                     * a1 auf JFilename
 move #8-1,d3                          * Zûhler
mtoj01:
 move.b (a0)+,(a1)+                    * Name kopieren
 dbra d3,mtoj01
 movea.l a2,a0                         * FileDsct zurýck
 movea.l a3,a1                         * FCB zurýck
 adda.l #FileExt,a0
 adda.l #JDExt,a1                      *
 move.b 0(a0),0(a1)
 move.b 1(a0),1(a1)
 move.b 2(a0),2(a1)                    * Ext kopiert
 move.l FileSize(a2),d0                * Dateigrüsse in Byte
 move.l d0,d3
 lsr.l #8,d0                           * /256
 lsr.l #2,d0                           * /4 -> /1024 (Sektorgrüsse)
 and.l #$3ff,d3
 tst d3                                 * noch ein Teilsektor?
 beq.s mtoj02                           * nü
 addq.l #1,d0                          * Ansonsten 1 Sektor mehr
mtoj02:
 move d0,JDatL(a3)                     * Grüsse in Sektoren
 movem.l (a7)+,d0/d3/a0-a3
 rts



***** User IOs *****

parser:
 movem.l d1-d7/a0-a2,-(a7)

 bsr parsclr                            * Parserspeicher lüschen
 
 lea parsdat(pc),a1
 move.l pflag(a1),d6                   * Parser Flag
 tst.b (a0)
 beq parsex                             * keine Parameter

pars02:                                 * fýhrende Leerzeichen entfernen
 cmp.b #' ',(a0)+
 beq.s pars02
 subq.l #1,a0
 tst.b (a0)
 beq parsex                             * nichts nach den Leerzeichen

 cmp.b #'-',(a0)                       * Optionen?
 bne.s pars04
 addq.l #1,a0                          * Zeichen nach '-'
pars02a:
 tst.b (a0)                             * ne Null?
 beq parsex                             * ja!
 move.l popt(a1),d5                    * Optionen in d5
 move.b (a0)+,d0                       * Option laden
 sub.b #$40,d0                         * in Nummer umwandeln A=1...Z=26
 bmi.s pars03                           * Ungýltige Option <@
 cmp.b #26,d0
 bgt.s pars03                           * Ungýltige Option >Z
 bset.l d0,d5                          * Optionsbit setzten
 move.l d5,popt(a1)                    * Optionen abspeichern
 bset.l #pfopt,d6                      * Options-Flag setzen
 cmp.b #' ',(a0)                       * Space -> keine weiteren Optionen
 beq.s pars03
 cmp.b #'-',(a0)
 bne.s pars02a
pars02b:
 addq.l #1,a0                          * Zeichen nach '-'
 bra.s pars02a

pars03:                                 * Leerzeichen raus
 cmp.b #' ',(a0)+
 beq.s pars03
 subq.l #1,a0                          * wieder auf nicht Leerzeichen
 cmp.b #'-',(a0)                       *
 beq.s pars02b                          * doch noch ne Option!

pars04:                                 * Quell Laufwerk
 cmp.b #':',1(a0)                      * ":" als 2.Zeichen
 bne.s pars04a                          * nü,kein JADOS
 bset.l #pfqlw,d6                      * Quell-Laufwerks Flag setzen
 move.b 0(a0),pqlw(a1)                 * JADOS Laufwerk
 move.b #'J',pqtyp(a1)                 * Typ JADOS
 addq.l #2,a0                          * Zeichen nach Laufwerk
 tst.b (a0)                             * Ende?
 beq parsex                             * Ja!
 bra pars04ex

pars04a:
 tst.b 1(a0)                            * 2. Zeichen Null?
 beq pars04ex                           * Ja
 cmp.b #' ',1(a0)                      * 2. Zeichen SPACE?
 beq pars04ex                           * Ja
 tst.b 2(a0)                            * 3. Zeichen Null?
 beq pars04ex                           * Ja
 cmp.b #' ',2(a0)                      * 3. Zeichen SPACE?
 beq pars04ex                           * Ja
 cmp.b #':',3(a0)                      * ":" als 4. Zeichen ?
 bne.s pars04b                          * nü
 bset.l #pfqlw,d6                      * Quell-Laufwerks Flag setzen
 move.b #'M',pqtyp(a1)                 * Typ MS
 move.b (a0)+,pqlw(a1)
 move.b (a0)+,pqlw+1(a1)
 move.b (a0)+,pqlw+2(a1)
 addq.l #1,a0                          * nach :
 tst.b (a0)                             * Ende?
 beq parsex                             * Ja!
 bra.s pars04ex

pars04b:
 tst.b 3(a0)                            * 4. Zeichen Null?
 beq pars04ex                           * Ja
 cmp.b #' ',3(a0)                      * 4. Zeichen SPACE?
 beq pars04ex                           * Ja
 cmp.b #':',4(a0)                      * ":" als 5. Zeichen ?
 bne.s pars04c                          * nü
 bset.l #pfqlw,d6                      * Quell-Laufwerks Flag setzen
 move.b #'M',pqtyp(a1)                 * Typ MS
 move.b (a0)+,pqlw(a1)
 move.b (a0)+,pqlw+1(a1)
 move.b (a0)+,pqlw+2(a1)
 move.b (a0)+,pqlw+3(a1)
 addq.l #1,a0                          * nach :
 tst.b (a0)                             * Ende?
 beq parsex                             * Ja!
 bra.s pars04ex

pars04c:
 tst.b 4(a0)                            * 5. Zeichen Null?
 beq pars04ex                           * Ja
 cmp.b #' ',4(a0)                      * 5. Zeichen SPACE?
 beq pars04ex                           * Ja
 cmp.b #':',5(a0)                      * ":" als 6. Zeichen ?
 bne.s pars05                           * nü,kein Laufwerk
 bset.l #pfqlw,d6                      * Quell-Laufwerks Flag setzen
 move.b #'M',pqtyp(a1)                 * Typ MS
 move.b (a0)+,pqlw(a1)
 move.b (a0)+,pqlw+1(a1)
 move.b (a0)+,pqlw+2(a1)
 move.b (a0)+,pqlw+3(a1)
 move.b (a0)+,pqlw+4(a1)
 addq.l #1,a0                          * nach :
 tst.b (a0)                             * Ende?
 beq parsex

pars04ex:
 cmp.b #' ',(a0)+                      * Leerzeichen raus
 beq.s pars04ex
 subq.l #1,a0                          * wieder auf nicht Leerzeichen

pars05:                                 * frei fýr Pfad

pars06:                                 * Quell-Dateiname
 movea.l a1,a2
 adda.l #pqdatn,a2                     * a2 auf Quell Dateiname
 cmp.b #'.',(a0)                       * "." zum Anfang?
 bne.s pars06z                          * nü
 bset.l #pfqdatn,d6                    * Quell-Dateiname Flag setzen
 move.b (a0)+,(a2)+
 cmp.b #'.',(a0)                       * noch n "."
 bne parsex                             * nü dann schluss
 move.b (a0)+,(a2)+
 bra parsex                             * hier ist Schluss!
pars06z:
 move #8-1,d3                          * maximal 8 Zeichen
 bset.l #pfqdatn,d6                    * Quell-Dateiname Flag setzen
pars06a:
 move.b (a0)+,d0
 beq parsex                             * String durch
 cmp.b #'.',d0
 beq.s pars07                           * Quell-Dateiname durch
 move.b d0,(a2)+                       * Zeichen speichern
 dbra d3,pars06a
 tst.b (a0)
 beq parsex                             * Ende!
 cmp.b #'.',(a0)
 bne.s pars06b
 addq.l #1,a0
 bra.s pars07
pars06b:
 cmp.b #' ',(a0)                       * Leerzeichen?
 beq.s pars08                           * Ja,dann keine Extension!

pars07:                                 * Quell-Dateiextension
 movea.l a1,a2
 adda.l #pqdate,a2                     * a2 auf Quell-Dateiextension
 move #3-1,d3                          * max. 3 Zeichen
 bset.l #pfqdate,d6                    * Quell-Dateiextension Flag setzen
pars07a:
 move.b (a0)+,d0
 beq parsex                             * Ende String
 cmp.b #' ',d0                         * Leerzeichen?
 beq.s pars07ex                         * Ja!
 move.b d0,(a2)+                       * Zeichen speichern
 dbra d3,pars07a
 tst.b (a0)                             * Null?
 beq parsex                             * dann Schluss
pars07ex:
 cmp.b #' ',(a0)+                      * Leerzeichen raus
 beq.s pars07ex
 subq.l #1,a0                          * zurýck auf nicht Leerzeichen
 tst.b (a0)                             * Ende?
 beq parsex                             * Ja!

pars08:                                 * 1. Adresswert
 cmp.b #'#',(a0)
 bne.s pars10                           * keine Adresswert
 addq.l #1,a0
 bsr wert
 cmp.l #-1,d0
 bne.s pars08a                          * kein Fehler
 move.l #28,errnum(a4)
 bra parserr
pars08a:
 bset.l #pfadr1,d6                     * Adresswert1 Flag setzen
 move.l d0,padr1(a1)                   * Adresswert1 speichern
pars08ex:
 cmp.b #' ',(a0)+                      * Leerzeichen raus
 beq.s pars08ex
 subq.l #1,a0                          * zurýck auf nicht Leerzeichen
 tst.b (a0)                             * Ende?
 beq parsex                             * Ja!

pars10:                                 * Ziel Laufwerk
 cmp.b #':',1(a0)                      * ":" als 2.Zeichen
 bne.s pars10a                          * nü,kein JADOS
 bset.l #pfzlw,d6                      * Ziel-Laufwerks Flag setzen
 move.b 0(a0),pzlw(a1)                 * JADOS Laufwerk
 move.b #'J',pztyp(a1)                 * Typ JADOS
 addq.l #2,a0                          * Zeichen nach Laufwerk
 tst.b (a0)                             * Ende?
 beq parsex                             * Ja!
 bra pars10ex

pars10a:
 cmp.b #':',3(a0)                      * ":" als 4. Zeichen ?
 bne.s pars10b                          * nü
 bset.l #pfzlw,d6                      * Ziel-Laufwerks Flag setzen
 move.b #'M',pztyp(a1)                 * Typ MS
 move.b (a0)+,pzlw(a1)
 move.b (a0)+,pzlw+1(a1)
 move.b (a0)+,pzlw+2(a1)
 addq.l #1,a0                          * nach :
 tst.b (a0)                             * Ende?
 beq parsex                             * Ja!
 bra.s pars10ex

pars10b:
 cmp.b #':',4(a0)                      * ":" als 5. Zeichen ?
 bne.s pars10c                          * nü
 bset.l #pfzlw,d6                      * Ziel-Laufwerks Flag setzen
 move.b #'M',pztyp(a1)                 * Typ MS
 move.b (a0)+,pzlw(a1)
 move.b (a0)+,pzlw+1(a1)
 move.b (a0)+,pzlw+2(a1)
 move.b (a0)+,pzlw+3(a1)
 addq.l #1,a0                          * nach :
 tst.b (a0)                             * Ende?
 beq parsex                             * Ja!
 bra.s pars10ex

pars10c:
 cmp.b #':',5(a0)                      * ":" als 6. Zeichen ?
 bne.s pars11                           * nü,kein Laufwerk
 bset.l #pfzlw,d6                      * Ziel-Laufwerks Flag setzen
 move.b #'M',pztyp(a1)                 * Typ MS
 move.b (a0)+,pzlw(a1)
 move.b (a0)+,pzlw+1(a1)
 move.b (a0)+,pzlw+2(a1)
 move.b (a0)+,pzlw+3(a1)
 move.b (a0)+,pzlw+4(a1)
 addq.l #1,a0                          * nach :
 tst.b (a0)                             * Ende?
 beq parsex

pars10ex:
 cmp.b #' ',(a0)+                      * Leerzeichen raus
 beq.s pars10ex
 subq.l #1,a0                          * wieder auf nicht Leerzeichen

pars11:                                 * frei fýr Pfad

pars12:                                 * Ziel-Dateiname
 cmp.b #'.',(a0)                       * "." zum Anfang?
 beq parsex                             * geht nicht!
 movea.l a1,a2
 adda.l #pzdatn,a2                     * a2 auf Ziel Dateiname
 move #8-1,d3                          * maximal 8 Zeichen
 bset.l #pfzdatn,d6                    * Ziel-Dateiname Flag setzen
pars12a:
 move.b (a0)+,d0
 beq.s parsex                           * String durch
 cmp.b #'.',d0
 beq.s pars13                           * Ziel-Dateiname durch
 move.b d0,(a2)+                       * Zeichen speichern
 dbra d3,pars12a
 tst.b (a0)
 beq parsex                             * Ende!
 cmp.b #'.',(a0)
 bne.s pars12b
 addq.l #1,a0
 bra.s pars13
pars12b:
 cmp.b #' ',(a0)                       * Leerzeichen?
 beq.s parsex                           * Ja,dann keine Extension!

pars13:                                 * Ziel-Dateiextension
 movea.l a1,a2
 adda.l #pzdate,a2                     * a2 auf Ziel-Dateiextension
 move #3-1,d3                          * max. 3 Zeichen
 bset.l #pfzdate,d6                    * Ziel-Dateiextension Flag setzen
pars13a:
 move.b (a0)+,d0
 beq parsex                             * Ende String
 cmp.b #' ',d0                         * Leerzeichen?
 beq.s parsex                           * Ja! Dann Ende
 move.b d0,(a2)+                       * Zeichen speichern
 dbra d3,pars13a

pars14:                                 * 2. Adresswert
 cmp.b #'#',(a0)
 bne.s parsex                           * keine Adresswert
 addq.l #1,a0
 bsr wert
 cmp.l #-1,d0
 bne.s pars14a                          * kein Fehler
 move.l #28,errnum(a4)
 bra parserr
pars14a:
 bset.l #pfadr2,d6                     * Adresswert2 Flag setzen
 move.l d0,padr2(a1)                   * Adresswert2 speichern
 
                                        * Was danach kommt? Wen interessierts?
parsex:
 clr.l d0
 move.l d6,pflag(a1)                   * Parser Flag sichern
 movem.l (a7)+,d1-d7/a0-a2
 rts

parserr:
 bsr error
 move.l #-1,d0
 bsr parsclr
 movem.l (a7)+,d1-d7/a0-a2
 rts
 
parsclr:                                * Parserspeicher lüschen
 movem.l d3/a1,-(a7)
 lea parsdat(pc),a1
 move #64-1,d3
parsclr1:                               * Parser Daten lüschen
 clr.b (a1)+
 dbra d3,parsclr1
 movem.l (a7)+,d3/a1
 rts

mdiska:                         * Zeigt die vorhandenen FS-Typ Laufwerke
 movem.l d0/d1/d3/d6/a0/a1,-(a7)
 tst.l hdbtfild(a4)                     * ein Laufwerk vorhanden?
 beq mdaex                              * nü
 clr d1
 bsr parser
 moveq.l #1,d0
 bsr option
 bne mdaex

mda00a:
 lea parsdat(pc),a0
 move.l pflag(a0),d3
 btst.l #pfqlw,d3
 beq.s mda00                            * keine LW Parameter
 cmp.b #'M',pqtyp(a0)                  * MS?
 bne.s mda00                            * nü
 bsr hdpars
 tst.l d0
 bne mdaerr
 cmp aktlw(a4),d1
 beq.s mda00                            * ist aktuelles LW
 move d1,aktlw(a4)
 bsr LoadLW                             * ansonsten neu laden
mda00:                                  * Laufwerks Liste
 move.l hdbtfild(a4),d6
 move #32-1,d3                         * auf alle 32 Laufwerke testen
 clr.l d0                               * Nummer des gefundenen LWs
mda01:
 asr.l #1,d6
 bcc.s mda02
 bsr mdiskb                             * Ausgabe
mda02:
 addq #1,d0                            * sonst nûchstes LW
 dbra d3,mda01
 lea txtcrlf(pc),a0
 bsr writetxt
 lea txtaktlw(pc),a0
 bsr writetxt
 bra.s mdaex
mdaerr:
 lea txtnv(pc),a0
 bsr writetxt
mdaex:
 movem.l (a7)+,d0/d1/d3/d6/a0/a1
 rts


mdiskb:
 move.l d0,-(a7)
 lea hdtab(pc),a0                      * Laufwerk-Tabelle
 mulu #6,d0                            * 6 Byte pro Eintrag
 adda.l d0,a0
 bsr writetxt
 move.l (a7)+,d0
 bsr komma
 rts


komma:
 cmp aktlw(a4),d0
 bne.s komma02
 lea txtstern(pc),a0
 bsr writetxt
komma02:
 lea txtkomma(pc),a0
 bsr writetxt
komma01:
 rts


hdpars:                         * sucht in der hdtab nach passendem LW
 lea hdtab(pc),a1                      * a1 zeigt auf die HD-Tabelle
 adda.l #pqlw,a0                       * a0 zeigt auf Quell-Laufwerk
 clr d1                                 * d1 ist Laufwerkszûhler
 move #32-1,d3
hdp02:
 move.l (a0),d0                        * Langwort Vergleich
 cmp.l (a1),d0
 beq.s hdp04                            * da stimmts
hdp03:                                  * sonst weiter
 addq.l #6,a1                          * nûchster Eintrag
 addq #1,d1                            * LW Zûhler
 dbra d3,hdp02
 bra.s hdperr                           * Laufwerk nicht vorhanden
hdp04:
 move.b 4(a0),d0
 cmp.b 4(a1),d0
 beq.s hdp05                            * mügliches Laufwerk gefunden
 bra.s hdp03                            * weiter gehts
hdp05:
 move.l hdbtfild(a4),d6
 btst.l d1,d6                          * Laufwerk wirklich da?
 beq.s hdperr                           * nü :-(
 clr.l d0
 bra.s hdpex
hdperr:
 move.l #-1,d0
hdpex:
 rts


mdira:                          * gibt das akt. DIR von aktlw aus
 movem.l d0-d7/a1-a2,-(a7)
 tst.l hdbtfild(a4)                     * ein LW vorhanden?
 beq mdiraer                            * nü
 bsr parser                             * Parameter holen (JADOS)
 moveq.l #2,d0
 bsr option
 tst.l d0
 bne mdiraer
 clr.l d4                               * Dateienzûhler
 clr.l d5                               * Grüssenzûhler
 clr.l d6                               * DIRzûhler
 clr.l d7                               * Anzahl der Zeilen
 bsr dirkopf
 bsr FindFrst                           * 1. Eintrag
 tst.l d0                               * Fehler?
 bne mdiraer                            * Ja
 cmp.l #-1,ffpos(a4)                   * was Gefunden?
 beq.s mdira10                          * nein
 addq.l #1,d7                          * Anzahl der Zeilen
 lea dirbuff(pc),a1
 adda.l ffpos(a4),a1                   * a1 auf Datei
 btst #4,DIRAttr(a1)
 beq.s mdira00
 addq.l #1,d6                          * Anzahl der DIRs
 bra.s mdira00a
mdira00:
 addq.l #1,d4                          * Anzahl der Dateien
mdira00a:
 bsr mdirausg                           * Ausgeben
mdira01:
 bsr FindNext                           * nûchster Eintrag
 tst.l d0                               * Fehler?
 bne.s mdiraer                          * Ja
 cmp.l #-1,ffpos(a4)                   * was gefunden?
 beq.s mdira10                          * nein
 addq.l #1,d7                          * Anzahl der Zeilen
 lea dirbuff(pc),a1
 adda.l ffpos(a4),a1                   * a1 auf Datei
 btst #4,DIRAttr(a1)
 beq.s mdira05
 addq.l #1,d6                          * Anzahl der DIRs
 bra.s mdira06
mdira05:
 addq.l #1,d4                          * Anzahl der Dateien
mdira06:
 bsr mdirausg                           * Ausgabe
 cmp #19,d7                            * Ende der Seite?
 bne.s mdira01                          * nein,weiter
 bsr nextside                           * sonst neue Seite
 tst d0                                 * Abbruch?
 bmi.s mdira10                          * ja!
 clr.l d7                               * Zeilenzûhler auf 0
 bra.s mdira01                          * nûchsten suchen
mdira10:
 bsr dirfuss
 clr.l d0
 bra.s mdiraex
mdiraer:
 bsr error
 move.l #-1,d0
mdiraex:
 movem.l (a7)+,d0-d7/a1-a2
 rts


mdirausg:
 movem.l d1-d3/a0-a2,-(a7)
 move #8-1,d2
 movea.l a1,a2
mdaus02:
 move.b (a2)+,d0                       * Datei Name
 bsr co2
 dbra d2,mdaus02
 move.b #' ',d0                        * "Space"
 bsr co2
 move #3-1,d2
mdaus03:
 move.b (a2)+,d0                       * Datei Erweiterung
 bsr co2
 dbra d2,mdaus03
 move.b #' ',d0
 bsr co2
 bsr co2                                * 2 Spaces ausgeben
 move.b (a2),d1
 btst #4,d1                          * DIR Attribut
 beq.s mdaus04
 lea txtdirat(pc),a0                   * Text: <DIR>
 bsr writetxt
 lea txt15spc(pc),a0                   * 15 Spaces
 bsr writetxt
 bra.s mdaus06
mdaus04:
 move.b #' ',d0
 bsr co2                                * Space
 move.b #'R',d0
 btst #0,d1                          * R = Schreibgeschýtzt
 bne.s mdaus04a
 move.b #' ',d0
mdaus04a:
 bsr co2
 move.b #'H',d0
 btst #1,d1                          * H = Versteckt
 bne.s mdaus04b
 move.b #' ',d0
mdaus04b:
 bsr co2
 move.b #'S',d0
 btst #2,d1                          * S = System
 bne.s mdaus04c
 move.b #' ',d0
mdaus04c:
 bsr co2
 move.b #'A',d0
 btst #5,d1                          * A = Archiv
 bne.s mdaus04d
 move.b #' ',d0
mdaus04d:
 bsr co2
 move.b #' ',d0
 bsr co2
mdaus05:
 move #' ',d0
 bsr co2
 movea.l a1,a2
 move.l DIRSize(a2),d0                 * Dateigrüsse in Byte
 bsr LBHLW
 add.l d0,d5                           * Gesamt Grüsse
 bsr print8d                            * Ausgabe
mdaus06:
 movea.l a1,a2
 move.b #' ',d0
 bsr co2
 bsr co2
 move.l DIRLCh(a2),d0          * Datum/Zeit der letzten ûnderung LBHLW!
 bsr LBHLW
 move.l d0,d1                          * sichern
 swap d0
 and.l #$1f,d0                         * 5 Bit = Tag
 bsr print2d
 move.b #'.',d0
 bsr co2
 move.l d1,d0
 swap d0
 asr #5,d0
 and.l #$f,d0                          * 4 Bit = Monat
 bsr print2d0
 move.b #'.',d0
 bsr co2
 move.l d1,d0
 rol.l #7,d0
 and.l #$7f,d0                         * 7 Bit = Jahr
 add #1980,d0                          * ab 1980
 bsr print4d
 move.b #' ',d0
 bsr co2
 bsr co2
 move d1,d0
 rol #5,d0
 and #$1f,d0                           * 5 Bit = Stunde
 bsr print2d
 move.b #':',d0
 bsr co2
 move d1,d0
 asr #5,d0
 and #$3f,d0                           * 6 Bit = Minuten
 bsr print2d0
 move.b #':',d0
 bsr co2
 move d1,d0
 and #$1f,d0                           * 5 Bit = Sekunden
 bsr print2d0
 lea txtcrlf(pc),a0                    * nûchste Zeile
 bsr writetxt
mdausex:
 movem.l (a7)+,d1-d3/a0-a2
 rts


dirkopf:
 bsr cls
 lea txtlw(pc),a0
 bsr writetxt
 move aktlw(a4),d0
 lea hdtab(pc),a0                      * Laufwerk-Tabelle
 mulu #6,d0                            * 6 Byte pro Eintrag
 adda.l d0,a0
 bsr writetxt
 lea txtcrlf(pc),a0
 bsr writetxt
 lea txtverz(pc),a0
 bsr writetxt
 lea NoAD(a6),a0
 bsr writetxt
 lea txtcrlf(pc),a0
 bsr writetxt
 bsr writetxt                           * eine Leerzeile
 rts


dirfuss:
 lea txtcrlf(pc),a0
 bsr writetxt                           * Eine Leerzeile
 move.l d4,d0
 bsr print8d                            * Anzahl der Dateien
 move.b #' ',d0
 bsr co2
 lea txtdatei(pc),a0
 bsr writetxt
 move.b #' ',d0
 bsr co2
 bsr co2
 move.l d5,d0
 bsr print8d                            * Grüsse aller Dateien
 move.b #' ',d0
 bsr co2
 lea txtbyte(pc),a0
 bsr writetxt
 lea txtcrlf(pc),a0
 bsr writetxt                           * Eine Leerzeile
 move.l d6,d0
 bsr print8d                            * Anzahl der DIRs
 move.b #' ',d0
 bsr co2
 lea txtdir(pc),a0
 bsr writetxt
 rts


nextside:
 movem.l a0,-(a7)
 clr d7
 lea txtweit(pc),a0
 bsr writetxt
 bsr key
 cmp.b #$03,d0                         * CTRL-C
 bne.s nxtsd01
 move.l #-1,d0
 bra.s nxtsdex
nxtsd01:
 lea txtcrlf(pc),a0
 bsr writetxt
 bsr writetxt
 lea txtverz(pc),a0
 bsr writetxt
 lea NoAD(a6),a0
 bsr writetxt
 move.b #' ',d0
 bsr co2
 lea txtforts(pc),a0
 bsr writetxt
 lea txtcrlf(pc),a0
 bsr writetxt
 clr.l d0
nxtsdex:
 movem.l (a7)+,a0
 rts



mcda:                                   * ûndert das akt. Verzeichniss
 movem.l d0/a0,-(a7)
 tst.l hdbtfild(a4)                     * LW vorhanden?
 beq.s mcdaex                           * nü
 bsr parser
 moveq.l #3,d0                         * Befehlsnummer
 bsr option                             * 'H' und 'Q' müglich
 tst.l d0
 bne.s mcdaex                           * nach Hilfe nicht weiter
mcda01:
 lea parsdat(pc),a0
 move.l pflag(a0),d0
 btst.l #pfqdatn,d0
 beq.s mcdaerr
 bsr chdir
 cmp #F_OK,d0
 beq.s mcdaex
mcdaerr:
 move.l #-1,d0
 bsr error
 bra.s mcdaex1
mcdaex:
 tst.b quiet(a4)                        * Ausgabe unterdrýcken?
 bne.s mcdaex1                          * ja
 lea txtcrlf(pc),a0                    * CRLF vorweg
 bsr writetxt
 lea NoAD(a6),a0                       * DIR-Name
 bsr writetxt
 lea txtakt(pc),a0
 bsr writetxt
 lea txtverz(pc),a0
 bsr writetxt
mcdaex1:
 movem.l (a7)+,d0/a0
 rts


mmda:                                   * erstellt ein neues Verzeichnis
 movem.l d0/a0,-(a7)
 tst.l hdbtfild(a4)                     * LW vorhanden?
 beq.s mmdaex                           * nü
 bsr parser
 moveq.l #6,d0                         * Befehlsnummer
 bsr option                             * 'H','Q' und 'K' müglich
 tst.l d0
 bne.s mmdaex
mmda02:
 lea parsdat(pc),a0
 move.l pflag(a0),d0
 btst.l #pfqdatn,d0
 bne.s mmda03
 move.l #-1,d0                         * kein Dateiname
 move.l #15,errnum(a4)
 bra.s mmdaerr
mmda03:
 bsr mkdir
 tst.l d0
 beq.s mmdaex
mmdaerr:
 bsr error
mmdaex:
 movem.l (a7)+,d0/a0
 rts


mloada:                                 * Lûdt eine Datei in den Speicher
                                        * a0=Dateiname,a1=Ladeadresse
 movem.l d1-d2/a0-a1,-(a7)
 tst.l hdbtfild(a4)                     * LW vorhanden?
 beq mldaex1                            * nü
 bsr parser
 moveq.l #5,d0
 bsr option
 tst.l d0
 bne mldaex1
mlda00a:
 lea parsdat(pc),a0
 move.l pflag(a0),d0
 btst.l #pfqdatn,d0
 bne.s mlda01
 move.l #15,errnum(a4)
 bra.s mldaerr1                         * kein Dateiname!
mlda01:
 btst.l #pfadr1,d0                     * Adresse eingegeben?
 beq.s mlda01a                          * nein
 movea.l padr1(a0),a1                  * eingegebene Adresse laden
mlda01a:
 bsr FFFD                               * FindFreeFileDiscriptor
 tst.l d0
 bmi.s mldaerr1                         * kein freier Dateihûndel
 move.l d0,d2                          * sichern
 bsr MFN                                * MakeFileName
 move d2,d0                            * Dateihûndel zurýck
 bsr FindName                           * Datei suchen
 cmp.l #FULL_MAT,d0                    * gefunden?
 beq.s mlda02                           * jo
 move.l #16,errnum(a4)
 bra.s mldaerr
mlda02:
 move.l d2,d0                          * Dateihûndel zurýck
 bsr FileDsct                           * a0=Adresse des Dateihûndels
 move.l a1,FileAdr(a0)                 * Speicheradresse setzen
 move.l d2,d0                          * Vorsichtshalber
 bsr fload                              * Datei in Speicher laden
 tst.l d0
 bne.s mldaerr
 tst.b quiet(a4)                        * Ausgabe unterdrýcken?
 bne.s mlda10                           * ja
 lea txtcrlf(pc),a0                    * CRLF vorweg
 bsr writetxt
 move.l d2,d0
 bsr NameOut
 lea txtload(pc),a0
 bsr writetxt
mlda10:
 clr.l d0                               * alles OK
 bra.s mldaex
mldaerr:
 move.l #-1,d0                         * Fehler
 bsr error
 bra.s mldaex
mldaerr1:
 move.l #-1,d0
 bsr error
 bra.s mldaex1

mldaex:

 *** FileID wieder freigeben muss spûter durch fclose erfolgen
 move.l d0,-(a7)
 move d2,d0
 bsr FileDsct
 clr.b FileFlag(a0)
 move.l (a7)+,d0
 ***

mldaex1:
 movem.l (a7)+,d1-d2/a0-a1
 rts



mcopya:                         * Kopiert Dateien von/nach Jados
 movem.l d1-d3/a0-a3,-(a7)
 moveq.l #-1,d1                        * keine FileID
 tst.l hdbtfild(a4)                     * LW vorhanden?
 beq mcpaex1                            * nü
 bsr parser
 moveq.l #4,d0
 bsr option
 tst.l d0
 bne mcpaex1
mcpa01:
 lea parsdat(pc),a3
 move.l pflag(a3),d0
 btst.l #pfqdatn,d0
 bne.s mcpa01a
 move.l #15,errnum(a4)                 * kein Dateiname
 bra mcpaerr
mcpa01a:
 btst.l #pfqlw,d0
 beq mcpa10                             * keine Laufwerksbezeichnung

 cmp.b #'J',pqtyp(a3)                  * JADOS?
 bne mcpa10                             * nü

 bsr JMDL                               * JadosMakeDirList
 tst.l d0
 bmi mcpaerr                            * Fehler in DIR-Liste
 move.l d0,d3                          * Anzahl der DIR-Eintrûge
 beq mcpaex                             * keine Dateien - Ende!
 subq.l #1,d3                          * als Zûhler
 clr.l d2                               * DIR-Nummer
mcpa02:
 moveq.l #-1,d1                        * keine FileID
 bsr jclrfcb                            * FCB lüschen
 move.l d2,d0                          * DIR Nummer
 bsr JMFN                               * Dateiname/Ext. in FCB
 clr.l d0
 move.b pqlw(a3),d0                    * Laufwerksbuchstabe
 bsr jconvlw                            * nach binûr
 cmp.l #-1,d0
 beq mcpaerr                            * Fehler
 lea jfcb(pc),a1
 move d0,JLW(a1)                       * Laufwerk im FCB setzen
 bsr jusradr                            * Adresse des Userbereichs laden
 movea.l a0,a2                         * sichern
 bsr jfload                             * Datei laden
 cmp.l #-1,d0
 beq mcpaerr                            * Datei konnte nicht geladen werden
 bsr jtom                               * Jados-FCB -> Mtools-FileDsct
 cmp.l #-1,d0
 beq mcpaerr                            * Schwerer Fehler
 cmp.l #-2,d0
 beq.s mcpa05                           * nicht ýberschreiben
 cmp.l #-3,d0                          * Abbruch?
 beq mcpaex                             * ja!
mcpa03:
 move.l d0,d1                          * FileID sichern
 bsr FileDsct                           * FileDiscriptor in a0
 movea.l a0,a1                         * sichern
 move.l a2,FileAdr(a1)
 move.l d1,d0                          * FileID zurýck!!!
 tst.b convflag(a4)                     * Konvertieren?
 beq.s mcpa03a                          * nein
 bsr NKCtoIBM
 tst.l d0
 bmi mcpaerr                            * Fehler beim Konvertieren
mcpa03a:
 move.l d1,d0                          * FileID zurýck
 bsr fsave                              * Datei speichern
 cmp.l #-1,d0                          * Speichern OK?
 beq mcpaerr                            * nü
 move.l d1,d0                          * FileID zurýck
 bsr UFE                                * UpdateFileEntry
 cmp.l #-1,d0
 beq mcpaerr
 tst.b quiet(a4)                        * mit Ausgabe?
 bne.s mcpa04                           * nü
 lea txtcrlf(pc),a0                    * CRLF vorweg
 bsr writetxt
 move.l d1,d0                          * FileID zurýck
 bsr NameOut                            * Name ausgeben
 lea txtcopy(pc),a0
 bsr writetxt
mcpa04:
 clr.b FileFlag(a1)                     * FileID schliessen
mcpa05:
 addq.l #1,d2                          * nûchste Datei
 subq.l #1,d3
 bpl mcpa02                             * dbra geht nur bis Wort!!!
 clr.b JNAFlag(a4)                      * nicht mehr ýberschreiben
 clr.l d0
 bra mcpaex1                            * geht ohne FileID schliessen

mcpa10:
 btst.l #pfzlw,d0                      * Ziel-Laufwerk vorhanden?
 beq mcpaerr                            * nü
 cmp.b #'J',pztyp(a3)                  * Ziel = Jados?
 beq.s mcpa11                           * jo
 move.l #24,errnum(a4)                 * ungýltiges Laufwerk
 bra mcpaerr
mcpa11:
 move.l #-1,d1                         * keine FileID
 bsr FFFD                               * FindFreeFileDiscriptor
 tst.l d0
 bmi mcpaerr                            * Fehler
 move.l d0,d1                          * FileID sichern
 bsr FileDsct                           * Filediscriptor in a0
 movea.l a0,a2                         * sichern
 bsr FindFrst
 tst.l d0
 bmi mcpaerr
 cmp.l #-1,ffpos(a4)
 bne.s mcpa12
 move.l #16,errnum(a4)                 * keine Datei da
 bra mcpaerr
mcpa12:
 move.l d1,d0                          * FileID zurýck
 bsr FFD
 btst #4,FileAttr(a2)                * DIR?
 bne mcpa14                             * Ja
 bsr mtoj                               * FCB anlegen
 clr.l d0
 move.b pzlw(a3),d0
 bsr jconvlw                            * JADOS Lw
 tst.b d0
 bmi mcpaerr                            * kein gýltiges Laufwerk
 lea jfcb(pc),a0
 move d0,JLW(a0)                       * Laufwerk setzen
 bsr jusradr                            * User Speicher holen
 move.l a0,FileAdr(a2)                 * in FileDsct speichern
 movea.l a0,a1                         * und sichern

 cmp.b #2,JNAFlag(a4)
 beq.s mcpa13                           * Alles ýberschreiben
 movem.l d1-d3,-(a7)
 bsr jfinfo
 movem.l (a7)+,d1-d3
 tst.b d0
 bmi.s mcpa13                           * Datei nicht vorhanden
 tst.b quiet(a4)
 bne.s mcpa14                           * nûchste Datei
 lea txtcrlf(pc),a0
 bsr writetxt
 move.l d1,d0
 bsr NameOut
 lea txtueber(pc),a0
 bsr JNA
 tst.l d0                               * Abbruch?
 bmi.s mcpaex                           * ja
 cmp.b #2,JNAFlag(a4)                  * Alle ýberschreiben
 beq.s mcpa13
 tst.b JNAFlag(a4)                      * Nicht ýbeschreiben
 beq.s mcpa14                           * nûchste Datei
 clr.b JNAFlag(a4)
mcpa13:
 move.l d1,d0                          * FileID zurýck
 bsr fload                              * Datei laden
 tst d0                                 * OK?
 bmi.s mcpaerr                          * nü
 tst.b convflag(a4)                     * konvertieren?
 beq.s mcpa13a                          * nü
 move.l d1,d0                          * FileID zurýck
 bsr IBMtoNKC
 tst.l d0
 bmi.s mcpaerr                          * Fehler beim konvertieren
mcpa13a:
 movea.l a1,a0                         * Speicheradresse nach a0
 bsr jfsave                             * und speichern
 tst.b d0                               * OK?
 bne.s mcpaerr                          * Nein
 tst.b quiet(a4)                        * mit Ausgabe?
 bne.s mcpa14                           * nü
 lea txtcrlf(pc),a0                    * CRLF vorweg
 bsr writetxt
 move d1,d0                            * FileID zurýck
 bsr NameOut                            * Name ausgeben
 lea txtcopy(pc),a0
 bsr writetxt
mcpa14:
 bsr FindNext
 tst.l d0
 bmi.s mcpaerr
 cmp.l #-1,ffpos(a4)
 beq.s mcpaex
 bra mcpa12

mcpaerr:
 moveq.l #-1,d0
 bsr error
mcpaex:
 tst.l d1
 bmi.s mcpaex1                          * keine FileID!!!
 exg d0,d1
 bsr FileDsct
 clr.b FileFlag(a0)                     * FileID schliessen
 exg d0,d1
mcpaex1:
 movem.l (a7)+,d1-d3/a0-a3
 rts


mdela:
 movem.l d0/a3,-(a7)
 tst.l hdbtfild(a4)
 beq.s mdelaex
 bsr parser
 moveq.l #7,d0
 bsr option
 tst.l d0
 bne.s mdelaex
mdela02:
 bsr remove
 tst.l d0
 beq.s mdelaex
mdelaer:
 bsr error
mdelaex:
 movem.l (a7)+,d0/a3
 rts


mforma:
 movem.l d0/a0,-(a7)           * Formatiert das akt. Laufwerk
 tst.l hdbtfild(a4)
 beq mfrmaex                            * kein LW da
 bsr parser
 moveq.l #8,d0
 bsr option
 tst.l d0
 bne mfrmaex
 tst.b JNAFlag(a4)
 bne.s mfrma01                          * loslegen
 tst.b quiet(a4)
 bne.s mfrmaex
 bsr cls
 lea txtlw(pc),a0
 bsr writetxt
 move aktlw(a4),d0
 lea hdtab(pc),a0                      * Laufwerk-Tabelle
 mulu #6,d0                            * 6 Byte pro Eintrag
 adda.l d0,a0
 bsr writetxt
 lea txtform(pc),a0
 bsr JN
 tst.l d0
 bmi.s mfrmaex                          * Abbruch mit CTRL-C
 tst.b JNAFlag(a4)
 beq.s mfrmaex                          * nicht formatieren
mfrma01:
 bsr QForm
 tst.l d0
 bmi.s mfrmaer
 tst.l quiet(a4)
 bne.s mfrmaex
 lea txtcrlf(pc),a0
 bsr writetxt
 lea txtlw(pc),a0
 bsr writetxt
 move aktlw(a4),d0
 lea hdtab(pc),a0                      * Laufwerk-Tabelle
 mulu #6,d0                            * 6 Byte pro Eintrag
 adda.l d0,a0
 bsr writetxt
 lea txtform1(pc),a0
 bsr writetxt
 bra.s mfrmaex
mfrmaer:
 bsr error
mfrmaex:
 movem.l (a7)+,d0/a0
 rts


hilfe:
 movem.l d0/a0,-(a7)
 bsr cls
 asl.l #2,d0
 lea hilfetab(pc),a0
 adda.l 0(a0,d0.w),a0
 bsr writetxt
 movem.l (a7)+,d0/a0
 rts


error:
 movem.l d0/a0,-(a7)
 cmp.b #2,quiet(a4)
 beq.s errex                            * keine Fehlerausgabe
 lea txtcrlf(pc),a0
 bsr writetxt
 move.l errnum(a4),d0
 cmp.l #erranz,d0
 blt.s err01
 move.l #27,d0                         * undefinierter Fehler
err01:
 asl.l #2,d0
 lea errtab(pc),a0
 adda.l 0(a0,d0.w),a0
 bsr writetxt
errex:
 movem.l (a7)+,d0/a0
 rts


option:                         * Optionen einstellen
                                * d0=Nummer des Befehls
 movem.l d1-d2/a0,-(a7)
 move.l d0,d2                          * Befehlsnummer sichern
 bmi opterr                             * Ungýltige Befehlsnummer
 cmp.l #trapanz,d2
 bge opterr                             * Ungýltige Befehlsnummer
 clr.b quiet(a4)
 clr.b JNAFlag(a4)
 clr.b convflag(a4)
 lea parsdat(pc),a0
 move.l pflag(a0),d1
 btst.l #pfopt,d1
 bne.s opt00
 clr.l d0
 bra.s optex                            * keine Option
opt00:
 move.l popt(a0),d1                    * angegebene Optionen
 lea opttab(pc),a0
 asl.l #2,d2                           * Befehlsnummer als Offset
 move.l 0(a0,d2.w),d2                 * mügliche Befehlsoption
 not.l d2
 and.l d1,d2
 bne.s opterr                           * ungýltige Option

 btst.l #$08,d1                        * H: Hilfe
 beq.s opt01
 bsr hilfe
 move.l #-1,d0
 bra.s optex                            * keine weitere Befehlsausfýhrung
opt01:
 btst.l #$17,d1                        * Q: Quiet - Ausgabe unterdrýcken
 beq.s opt02
 move.b #1,quiet(a4)
 clr.l d0
opt02:
 btst.l #$01,d1                        * A: Alle
 beq.s opt03
 move.b #2,JNAFlag(a4)                 * Alle ýberschreiben/lüschen...
 clr.l d0
opt03:
 btst.l #$11,d1                        * K: Keinerlei Ausgabe
 beq.s opt04
 move.b #2,quiet(a4)                   * keine Ausgabe (auch keine Fehler)
 clr.l d0
opt04:
 btst.l #$03,d1                        * C: Kovertieren
 beq.s opt05
 move.b #-1,convflag(a4)
 clr.l d0
opt05:
 nop
 bra.s optex                            * weiter mit Befehl

opterr:
 move.l #17,errnum(a4)                 * Falsche Option
 bsr error
 move.l #-1,d0                         * keine weitere Befehlsausfýhrung
optex:
 movem.l (a7)+,d1-d2/a0
 rts


NKCtoIBM:                       * konvertiert NKC Textdateien nach IBM
 movem.l d1-d5/a0-a3/a5,-(a7)          * FileID in d0
 bsr FileDsct
 movea.l FileAdr(a0),a3                * RAM Adresse der Datei
 movea.l a3,a2                         * sichern
 move.l FileSize(a0),d3                * Dateigrüsse (von JADOS)
 move.l d3,d2                          * sichern
 lea nkctab(pc),a1
 lea ibmtab(pc),a5
 sub.l #1024,d3                        * letzten Sektor raus
 bmi.s NtI02                            * Datei < 1024 Byte
 subq.l #1,d3                          * als Zûhler
 bmi.s NtI02                            * Datei = 1024 Byte
NtI01:
* tst.b (a3)+                            * ne Null?
* beq NtIerr                             * Ja,dann kein Text!!!
* subq.l #1,d3
* bpl.s NtI01                            * dbra geht nur bis Wort!!!
 movea.l a2,a3                         * Dateistart zurýck
NtI02:
 clr.l d1                               * als Bytezûhler
 move.l d2,d3                          * Lûnge zurýck
NtI03:
 move.b (a3),d0                        * Zeichen einlesen
 beq.s NtI20                            * Ende erreicht
 bmi.s NtI05                            * Umlaut
NtI04:                                  * Regulûr
 addq.l #1,d1
 addq.l #1,a3
 bra.s NtI03                            * Nûchstes Zeichen
NtI05:
 clr.l d4
NtI05a:
 move.b 0(a1,d4.w),d5                 * NKC Umlaut
 beq.s NtI05b                           * Tabelle durch
 cmp.b d5,d0                           *
 bne.s NtI05c                           * ist es nicht
 move.b 0(a5,d4.w),d0                 * IBM Umlaut laden
 bra.s NtI10
NtI05b:
 move.b #' ',d0                        * Space laden
 bra.s NtI10
NtI05c:
 addq #1,d4                            * nûchster Umlaut
 bra.s NtI05a
NtI10:
 move.b d0,(a3)                        * abspeichern
 bra.s NtI04                            * und weiter
NtI20:
 move.l d1,FileSize(a0)                * neue Lûnge speichern
 clr.l d0
 bra.s NtIex
NtIerr:
 move.l #-1,d0
 move.l #26,errnum(a4)
NtIex:
 movem.l (a7)+,d1-d5/a0-a3/a5
 rts


IBMtoNKC:                       * konvertiert IBM Textdateien nach NKC
 movem.l d1-d5/a0-a3/a5,-(a7)          * FileID in d0
 bsr FileDsct
 movea.l FileAdr(a0),a3                * RAM Adresse der Datei
 movea.l a3,a2                        * sichern
 move.l FileSize(a0),d3                * Dateigrüsse
 move.l d3,d2                          * sichern
 lea nkctab(pc),a5
 lea ibmtab(pc),a1
 subq.l #1,d3                          * als Zûhler
ItN01:
 tst.b (a3)+                            * ne Null?
 beq ItNerr                             * Ja,dann kein Text!!!
 subq.l #1,d3
 bpl.s ItN01                            * dbra geht nur bis Wort!!!
 clr.b (a3)                             * Ende setzten
 movea.l a2,a3                         * Dateistart zurýck
ItN02:
 clr.l d1                               * als Bytezûhler
 clr.l d3                               * als Zeichen / Zeile
ItN03:
 move.b (a3),d0                        * Zeichen einlesen
 bmi.s NtI05                            * Umlaut
 cmp.b #$09,d0                         * HTAB
 bne ItN03a
 bsr TABtoSP                            * durch Space ersetzen
 bra.s ItN04
ItN03a:
 cmp.b #$0a,d0                         * LF?
 bne.s ItN04                            * nü
 moveq.l #-1,d3                        * sonst Zeichen/Zeile auf 0 ;-)
ItN04:                                  * Regulûr
 addq.l #1,d3                          * nûchstes Zeichen in Zeile
 addq.l #1,d1
 addq.l #1,a3
 cmp.l d2,d1                           * Ende?
 bge.s ItN20
 cmp.l #79,d3                          * Zeilenumbruch nütig?
 ble.s ItN04a                           * nein
 cmp.b #$0a,0(a3)                      * nûchstes Zeichen ein LF?
 bne.s ItN04b                           * Nein,weiter
 clr.l d3
 addq.l #1,a3
 bra.s ItN03
ItN04b:
 cmp.b #$0a,1(a3)                      * ýbernûchstes Zeichen LF?
 bne.s ItN04c                           * nein dann neuer Umbruch
 addq.l #2,a3
 clr.l d3
 bra.s ItN03
ItN04c:
 bsr umbruch
 clr.l d3
ItN04a:
 bra.s ItN03                            * Nûchstes Zeichen
ItN05:
 clr.l d4
ItN05a:
 move.b 0(a1,d4.w),d5                 * IBM Umlaut
 beq.s ItN05b                           * Tabelle durch
 cmp.b d5,d0                           *
 bne.s ItN05c                           * ist es nicht
 move.b 0(a5,d4.w),d0                 * NKC Umlaut laden
 bra.s ItN10
ItN05b:
 move.b #' ',d0                        * ansonsten Space laden
 bra.s ItN10
ItN05c:
 addq #1,d4                            * nûchster Umlaut
 bra.s ItN05a
ItN10:
 move.b d0,(a3)                        * abspeichern
 bra.s ItN04                            * und weiter
ItN20:
 adda.l d1,a2                          * a2 auf Ende der Datei
* addq.l #1,d1
 move.l d1,FileSize(a0)                * neue Lûnge speichern
 lea jfcb(pc),a0
 move.l d1,d0
 lsr.l #8,d0                           * /256
 lsr.l #2,d0                           * /4 -> /1024 (Sektorgrüsse)
 and.l #$3ff,d1
 tst d1                                 * noch ein Teilsektor?
 beq.s ItN20a                           * nü
 addq.l #1,d0                          * Ansonsten 1 Sektor mehr
 move #1024,d2
 sub d1,d2                             * 1024-Restdaten
 subq #1,d2                            * -1 da Zûhler
ItN201:
 clr.b (a2)+
 dbra d2,ItN201                        * Restsektor mit 00 fýllen
ItN20a:
 move d0,JDatL(a0)                     * Grüsse in Sektoren
 clr.l d0
 bra.s ItNex
ItNerr:
 move.l #-1,d0
 move.l #26,errnum(a4)
ItNex:
 movem.l (a7)+,d1-d5/a0-a3/a5
 rts


umbruch:                        * Zeilenumbruch einfýgen
 movem.l d1-d2/a0,-(a7)
 movea.l a3,a0                         * aktuelle Position
 sub.l d1,d2                           * Lûnge - akt. Position = Rest
 move.l d2,d1                          * nach d1
 move.l #2,d0                          * um 2 verschieben
 bsr mover
 move.b #$0d,0(a0)
 move.b #$0a,1(a0)
 movem.l (a7)+,d1-d2/a0
 addq.l #2,d2                          * Text um 2 Byte lûnger
 rts


TABtoSP:                        * einen Tabulator in Spaces umwandeln
 movem.l d0-d1/d3/a0,-(a7)
 move.l d3,d0                          * akt. Zeichenposition in Zeile
 and.l #$7,d0                          * mod 8
 move.l #8,d3
 sub.l d0,d3
 move.l d3,d0
TtS01:
 subq.l #1,d0
 movea.l a3,a0                         * aktuelle Position
 move.l d2,-(a7)                       * d2 retten
 sub.l d1,d2                           * Lûnge - akt. Position = Rest
 move.l d2,d1                          * nach d1
 move.l (a7)+,d2                       * d2 zurýck
 bsr mover
 move.l d0,d1
TtS02:
 move.b #' ',(a0)+                     * mit Space fýllen
 dbra d1,TtS02
 add.l d0,d2                           * neue Textlûnge
 movem.l (a7)+,d0-d1/d3/a0
 rts


mover:                          * Verschiebt um d0.w Bytes nach hinten
 movem.l d1/a0,-(a7)           * d1.l = Lûnge,a0 = Start
 adda.l d1,a0                          * a0 Auf Ende
mvrlp01:
 move.b (a0),0(a0,d0.w)
 subq.l #1,a0
 subq.l #1,d1
 bpl.s mvrlp01                          * dbra geht nur bis Wort!!!
 movem.l (a7)+,d1/a0
 rts



***** Texte *****

 ds 0

txtinit:
 dc.b 'MTOOLS V 0.9A sind initialisiert',0

txtcrlf:
 dc.b $0d,$0a,0

txtnv:
 dc.b 'Laufwerk nicht verfýgbar',0

txtcyl:
 dc.b 'Zylinder: ',0

txtsec:
 dc.b 'Sektoren: ',0

txthd:
 dc.b 'Küpfe: ',0

txtpart:
 dc.b 'Partitionen:',0

txtnr:
 dc.b 'Nr',0

txtstart:
 dc.b 'Start-',0

txt1start:
 dc.b 'sektor',0

txtgroess:
 dc.b 'Anzahl',0

txt1groess:
 dc.b 'Sektoren',0

txtMB:
 dc.b 'Grüsse in',0

txt1MB:
 dc.b 'MiB',0

txttyp:
 dc.b 'Partitionstyp',0

txtkomma:
 dc.b ',',0

txtstern:
 dc.b ' *',0

txtaktlw:
 dc.b '* = aktives Laufwerk',0

txtweit:
 dc.b 'Weiter mit beliebiger Taste . . .',0

txtforts:
 dc.b 'wird fortgesetzt',0

txtlw:
 dc.b 'Laufwerk ',0

txtverz:
 dc.b 'Verzeichnis ',0

txterst:
 dc.b 'erstellt',0

txtdirat:
 dc.b '<DIR> ',0

txtdatei:
 dc.b 'Datei(en) ',0

txtdir:
 dc.b 'Verzeichnis(se) ',0

txtbyte:
 dc.b 'Byte ',0

txt15spc:
 dc.b '               ',0

txtroot:
 dc.b '/',0

txtjn:
 dc.b ' (Ja/Nein) ',0

txtjna:
 dc.b ' (Ja/Nein/Alle) ',0

txtueber:
 dc.b 'ýberschreiben?',0

txtcopy:
 dc.b 'kopiert',0

txtdel:
 dc.b 'gelüscht',0

txtloe:
 dc.b 'lüschen?',0

txtload:
 dc.b 'ins RAM geladen',0

txtakt:
 dc.b ' ist aktuelles ',0

txtform:
 dc.b ' formatieren?',0

txtform1:
 dc.b ' ist formatiert!',0


***** Fehler Texte *****

terr1:
 dc.b 'kein Laufwerk vorhanden',0

terr2:
 dc.b 'keine FAT16 Partition verfýgbar',0

terr3:
 dc.b 'Laufwerk nicht ready',0

terr4:
 dc.b 'Daten sind nicht bereit',0

terr5:
 dc.b 'Sektor kann nicht gelesen werden',0

terr6:
 dc.b 'Sektor kann nicht geschrieben werden',0

terr7:
 dc.b 'Disk ist voll',0

terr8:
 dc.b 'kein freier Cluster',0

terr9:
 dc.b 'kein freier Datei-Hûndel',0

terr10:
 dc.b 'DIR kann nicht gelüscht werden',0

terr11:
 dc.b 'Verzeichnis nicht vorhanden',0

terr12:
 dc.b 'Verzeichnis ist voll',0

terr13:
 dc.b 'Verzeichnis schon vorhanden',0

terr14:
 dc.b 'JADOS Directory Fehler',0

terr15:
 dc.b 'kein Dateiname angegeben',0

terr16:
 dc.b 'Datei nicht vorhanden',0

terr17:
 dc.b 'falsche Option',0

terr18:
 dc.b 'keine Laufwerk angegeben',0

terr19:
 dc.b 'Userspeicher ist voll',0

terr20:
 dc.b 'JADOS Laufwerk nicht erreichbar',0

terr21:
 dc.b 'JADOS Laufwerk ist voll',0

terr22:
 dc.b 'JADOS Verzeichnis ist voll',0

terr23:
 dc.b 'kein gýltiges JADOS Laufwerk',0

terr24:
 dc.b 'ungýltige Laufwerks-Angabe',0

terr25:
 dc.b 'ungýltige Cluster Nummer',0
 
terr26:
 dc.b 'Fehler beim konvertieren',0
 
terr27:
 dc.b 'undefinierter Fehler',0
 
terr28:
 dc.b 'Fehler im Parser bei Adressberechnung',0

terr29:
 dc.b 'Zu alte Grundprogrammversion! Vorraussetztung min. V7.10',0

 ds 0



OSanz           equ     86

 ds 0
 
 OStype:
 dc.b $00,'Eintrag leer                            ',0
 dc.b $01,'FAT12                                   ',0
 dc.b $02,'Xenix                                   ',0
 dc.b $03,'Xenix                                   ',0
 dc.b $04,'FAT16 (max. 32 MB)                      ',0
 dc.b $05,'extended DOS-Partition (max. 2 GB)      ',0
 dc.b $06,'FAT16 (max. 2 GB)                       ',0
 dc.b $07,'HPFS/NTFS                               ',0
 dc.b $08,'AIX                                     ',0
 dc.b $09,'AIX bootable                            ',0
 dc.b $0A,'OS/2 Bootmanager                        ',0
 dc.b $0B,'FAT32 (CHS Adressierung)                ',0
 dc.b $0C,'FAT32 (LBA Adressierung)                ',0
 dc.b $0E,'FAT16 (LBA Adressierung)                ',0
 dc.b $0F,'ext. Partition (LBA,mehr als 1024 Zyl.)',0
 dc.b $10,'OPUS                                    ',0
 dc.b $11,'hidden FAT12                            ',0
 dc.b $12,'Compaq diagnost                         ',0
 dc.b $14,'hidden FAT16 bis 32MB                   ',0
 dc.b $16,'hidden FAT16                            ',0
 dc.b $17,'hidden HPFS / NTFS                      ',0
 dc.b $18,'AST Windows swap                        ',0
 dc.b $1B,'hidden WIN95 FAT32                      ',0
 dc.b $1C,'hidden WIN95 FAT32 (LBA)                ',0
 dc.b $1E,'hidden WIN95 FAT16 (LBA)                ',0
 dc.b $24,'NEC DOS                                 ',0
 dc.b $39,'Plan 9                                  ',0
 dc.b $3C,'Partition Magic                         ',0
 dc.b $40,'Venix 80286                             ',0
 dc.b $41,'PPC PReP boot                           ',0
 dc.b $42,'SFS                                     ',0
 dc.b $4D,'QNX4.x                                  ',0
 dc.b $4E,'QNX4.x 2nd partition                    ',0
 dc.b $4F,'QNX4.x 3rd partition                    ',0
 dc.b $50,'OnTrack DM                              ',0
 dc.b $51,'OnTrack DM6 Aux                         ',0
 dc.b $52,'CP/M                                    ',0
 dc.b $53,'OnTrack DM6 Aux                         ',0
 dc.b $54,'OnTrack DM6                             ',0
 dc.b $55,'EZ-Drive                                ',0
 dc.b $56,'Golden Bow                              ',0
 dc.b $5c,'Priam Edisk                             ',0
 dc.b $61,'Speed Stor                              ',0
 dc.b $63,'GNU HURD or SYS                         ',0
 dc.b $64,'Novell NetWare                          ',0
 dc.b $70,'Disk Secure Mult                        ',0
 dc.b $75,'UNIX PC/IX                              ',0
 dc.b $80,'aktiv (old Minix)                       ',0
 dc.b $81,'Booten von Laufwerk D:                  ',0
 dc.b $82,'Linux Swap                              ',0
 dc.b $83,'Linux native                            ',0
 dc.b $84,'OS/2 hidden C:                          ',0
 dc.b $85,'LINUX extended                          ',0
 dc.b $86,'NTFS volume set                         ',0
 dc.b $87,'NTFS volume set                         ',0
 dc.b $8e,'LINUX LVM                               ',0
 dc.b $93,'Amoebla                                 ',0
 dc.b $94,'Amoebla BBT                             ',0
 dc.b $9F,'BSD/OS                                  ',0
 dc.b $A0,'IBM Thinkpad hidden                     ',0
 dc.b $A5,'BSD/386                                 ',0
 dc.b $A6,'Open BSD                                ',0
 dc.b $A7,'NeXT STEP                               ',0
 dc.b $B0,'JADOS                                   ',0
 dc.b $B7,'BSDI fs                                 ',0
 dc.b $B8,'BSDI swap                               ',0
 dc.b $C1,'DRDOS/sec (FAT32)                       ',0
 dc.b $C4,'DRDOS/sec (FAT32(LBA))                  ',0
 dc.b $C6,'DRDOS/sec (FAT16(LBA))                  ',0
 dc.b $C7,'Syrinx                                  ',0
 dc.b $DA,'Non-Fs data                             ',0
 dc.b $DB,'Concurrent DOS,CP/M,CTOS              ',0
 dc.b $DE,'Dell Utility                            ',0
 dc.b $E1,'DOS access                              ',0
 dc.b $E3,'DOS R/o                                 ',0
 dc.b $E4,'Speed Stor                              ',0
 dc.b $EB,'BeOS fs                                 ',0
 dc.b $EE,'EFI GPT                                 ',0
 dc.b $EF,'EFI (FAT12/16/32)                       ',0
 dc.b $F1,'Speed Stor                              ',0
 dc.b $F2,'DOS secondary                           ',0
 dc.b $F4,'Speed Stor                              ',0
 dc.b $FD,'LINUX raid auto                         ',0
 dc.b $FE,'LANstep                                 ',0
 dc.b $FF,'BBT                                     ',0

 ds 0

hdtab:
fd0:
        dc.b 'FD0',0,0,0
fd1:
        dc.b 'FD1',0,0,0
hda1:
        dc.b 'HDA1',0,0
hda2:
        dc.b 'HDA2',0,0
hda3:
        dc.b 'HDA3',0,0
hda4:
        dc.b 'HDA4',0,0
hdb1:
        dc.b 'HDB1',0,0
hdb2:
        dc.b 'HDB2',0,0
hdb3:
        dc.b 'HDB3',0,0
hdb4:
        dc.b 'HDB4',0,0
sda1:
        dc.b 'SDA1',0,0
sda2:
        dc.b 'SDA2',0,0
sda3:
        dc.b 'SDA3',0,0
sda4:
        dc.b 'SDA4',0,0
sdb1:
        dc.b 'SDB1',0,0
sdb2:
        dc.b 'SDB2',0,0
sdb3:
        dc.b 'SDB3',0,0
sdb4:
        dc.b 'SDB4',0,0
res1:
        dc.b 'RES1',0,0
res2:
        dc.b 'RES2',0,0
res3:
        dc.b 'RES3',0,0
res4:
        dc.b 'RES4',0,0
res5:
        dc.b 'RES5',0,0
res6:
        dc.b 'RES6',0,0
res7:
        dc.b 'RES7',0,0
res8:
        dc.b 'RES8',0,0
res9:
        dc.b 'RES9',0,0
res10:
        dc.b 'RES10',0
res11:
        dc.b 'RES11',0
res12:
        dc.b 'RES12',0
res13:
        dc.b 'RES13',0
res14:
        dc.b 'RES14',0

 ds 0

***** Hilfe Texte *****

hmdisk:
 dc.b 'Syntax: MDISK              ->  Listet verfýgbare Laufwerke auf',13,10
 dc.b '        MDISK lw:          ->  Macht lw: zum aktiven Laufwerk',13,10,0
 ds 0

hmdir:
 dc.b 'Syntax: MDIR               ->  Liefert das Inhaltsverzeichnis',13,10
 dc.b '                               des aktiven Laufwerks',13,10
 dc.b '        MDIR name.ext      ->  Gibt ein eingeschrûnktes',13,10
 dc.b '                               Inhaltsverzeichnis aus',13,10
 dc.b '                               Wilscards ( *,? ) sind müglich',13,10,0
 ds 0

hmcd:
 dc.b 'Syntax: MCD name           ->  Wechselt in das Unterverzeichnis',13,10
 dc.b '                               "name"',13,10
 dc.b '        MCD ..             ->  Wechsel in das ýbergeordnete',13,10
 dc.b '                               Verzeichnis',13,10
 dc.b '        MCD /              ->  Wechselt in das Root-Verzeichnis',13,10,0
 ds 0

hmcopy:
 dc.b 'Syntax: MCOPY lw:name.ext  ->  kopiert von JADOS nach FAT16',13,10
 dc.b '                               Wildcards ( *,? ) sind müglich',13,10
 dc.b '        MCOPY name.ext lw: ->  kopiert von FAT16 nach JADOS',13,10
 dc.b '                               Wildcards ( *,? ) sind müglich',13,10,0
 ds 0

hmload:
 dc.b 'Syntax: MLOAD name.ext     ->  Lûdt die Datei "name.ext"',13,10
 dc.b '                               in den JADOS USER-Bereich',13,10
 dc.b '        MLOAD name.ext #aa     Lûdt die Datei "name.ext"',13,10
 dc.b '                               in die Adresse #aaaaaaaa ',13,10,0
 ds 0

hmmd:
 dc.b 'Syntax: MMD name           ->  Erstellt das Unterverzeichnis',13,10
 dc.b '                               "name"',13,10,0
 ds 0

hmdel:
 dc.b 'Syntax: MDEL name.ext      ->  Lüscht die Datei "name.ext"',13,10
 dc.b '                               Wildcards ( *,? ) sind müglich',13,10,0
 ds 0

hmform:
 dc.b 'Syntax: MFORMAT            ->  Formatiert das aktuelle Laufwerk',13,10,0
 ds 0


***** Trap10 Tabelle *****

traptab:
 dc.l   0                               * frei          0
 dc.l   mdiska-traptab                  * mdisk         1
 dc.l   mdira-traptab                   * mdir          2
 dc.l   mcda-traptab                    * mcd           3
 dc.l   mcopya-traptab                  * mcopy         4
 dc.l   mloada-traptab                  * mload         5
 dc.l   mmda-traptab                    * mmd           6
 dc.l   mdela-traptab                   * mdel          7
 dc.l   mforma-traptab                  * mformat       8
trapend:

trapanz equ (trapend-traptab)/4         * Anzahl der Trap #10 Eintrûge


***** Hilfe Tabelle *****

hilfetab:
 dc.l   0                               * frei          0
 dc.l   hmdisk-hilfetab                 * mdisk         1
 dc.l   hmdir-hilfetab                  * mdir          2
 dc.l   hmcd-hilfetab                   * mcd           3
 dc.l   hmcopy-hilfetab                 * mcopy         4
 dc.l   hmload-hilfetab                 * mload         5
 dc.l   hmmd-hilfetab                   * mmd           6
 dc.l   hmdel-hilfetab                  * mdel          7
 dc.l   hmform-hilfetab                 * mformat       8
htabend:


***** Optionstabelle *****
*        33222222222211111111110000000000
*        10987654321098765432109876543210
*        .....ZYXWVUTSRQPONMLKJIHGFEDCBA@
opttab:
 dc.l   %00000000000000000000000000000000  * frei    #0
 dc.l   %00000000000000000000000100000000  * mdisk   #1 H
 dc.l   %00000000000000000000000100000000  * mdir    #2 H
 dc.l   %00000000000000100000100100000000  * mcd     #3 H,Q,K
 dc.l   %00000000000000100000100100001010  * mcopy   #4 H,Q,A,K,C
 dc.l   %00000000000000100000100100000000  * mload   #5 H,Q,K
 dc.l   %00000000000000100000100100000010  * mmd     #6 H,Q,A,K
 dc.l   %00000000000000100000100100000010  * mdel    #7 H,Q,A,K
 dc.l   %00000000000000100000100100000010  * mformat #8 H,Q,A,K
otabend:


***** Fehlertabelle *****

errtab:
 dc.l   0                               * kein Fehler                   0
 dc.l   terr1-errtab                    * kein LW                       1
 dc.l   terr2-errtab                    * keine FAT16                   2
 dc.l   terr3-errtab                    * LW nicht ready                3
 dc.l   terr4-errtab                    * Daten nicht bereit            4
 dc.l   terr5-errtab                    * Sektor nicht lesbar           5
 dc.l   terr6-errtab                    * Sektor nicht schreibbar       6
 dc.l   terr7-errtab                    * Disk voll                     7
 dc.l   terr8-errtab                    * kein freier Cluster           8
 dc.l   terr9-errtab                    * kein freier Datei-Hûndel      9
 dc.l   terr10-errtab                   * DIR nicht lüschbar            10
 dc.l   terr11-errtab                   * Verzeichnis nicht da          11
 dc.l   terr12-errtab                   * Verzeichnis voll              12
 dc.l   terr13-errtab                   * Verzeichnis schon da          13
 dc.l   terr14-errtab                   * JADOS Dirctory Fehler         14
 dc.l   terr15-errtab                   * kein Dateiname                15
 dc.l   terr16-errtab                   * Datei nicht da                16
 dc.l   terr17-errtab                   * falsche Option                17
 dc.l   terr18-errtab                   * kein Laufwerk angegeben       18
 dc.l   terr19-errtab                   * UserSpeicher voll             19
 dc.l   terr20-errtab                   * JADOS LW nicht da             20
 dc.l   terr21-errtab                   * JADOS LW voll                 21
 dc.l   terr22-errtab                   * JADOS DIR voll                22
 dc.l   terr23-errtab                   * JADOS LW ungýltig             23
 dc.l   terr24-errtab                   * ungýltiges LW                 24
 dc.l   terr25-errtab                   * ungýltiger Cluster            25
 dc.l   terr26-errtab                   * konvertierungs Fehler         26
 dc.l   terr27-errtab                   * undefinierter Fehler          27
 dc.l   terr28-errtab                   * fehlerhafte Adressberechnung  28
 dc.l   terr29-errtab                   * Zu niedrige GP Version        29
errend:

erranz  equ (errend-errtab)/4           * Anzahl der Fehler Eintrûge


nkctab:
 dc.b $db,$dc,$dd,$fb,$fc,$fd,$fe,0
 ds 0

ibmtab:
 dc.b $c4,$d6,$dc,$e4,$f6,$fc,$df,0
 ds 0


***** Diskparameter *****

Diskname        equ     4

typ1            equ     46              * FS Typ der Partition
typ2            equ     48              * Wort Grüsse (Byte reicht auch)
typ3            equ     50
typ4            equ     52

starts1         equ     54              * Startsektor der Partition
starts2         equ     58              * Langwort
starts3         equ     62
starts4         equ     66

groesse1        equ     70              * Grüsse der PART in Sektoren
groesse2        equ     74              * Langwort
groesse3        equ     78
groesse4        equ     82

NoAD            equ     86              * Name des akt. DIRs


** Boot-Parameter-Block
BPBOff          equ     128

BPS             equ     0+BPBOff  * Bytes pro Sektor immer 512!!!     OFF=0x0B
SPC             equ     2+BPBOff  * Sektoren pro Cluster              OFF=0x0D
RSC             equ     4+BPBOff  * Anzahl der reservierten Sektoren  OFF=0x0E
numFATs         equ     6+BPBOff  * Anzahl der FATs                   OFF=0x10
REC             equ     8+BPBOff  * Anzahl der Eintrûge im Root-Verz. OFF=0x11
TotSec16        equ    10+BPBOff  * Gesamtzahl Sektoren 16 Bit        OFF=0x13
FATSz           equ    12+BPBOff  * Grüþe der FATs                    OFF=0x16
TotSec32        equ    14+BPBOff  * Gesamtzahl Sektoren 32 Bit        OFF=0x20

FATFrst         equ    18+BPBOff  * erster FAT Sektor
RootFrst        equ    22+BPBOff  * erster Root-DIR Sektor
DataFrst        equ    26+BPBOff  * erster Daten Sektor
TotSec          equ    30+BPBOff  * Sektoren gesamt
DataSec         equ    34+BPBOff  * Datensektoren gesamt
FATCurr         equ    38+BPBOff  * aktueller FAT-Sektor
eoClusCh        equ    42+BPBOff  * Endekennzeichen fýr Clusterchain
BPC             equ    46+BPBOff  * Bytes pro Cluster
lastSec         equ    50+BPBOff  * letzter Sektor des LWs
lastClus        equ    54+BPBOff  * letzter benutzbare Cluster
CntClust        equ    58+BPBOff  * Anzahl der Cluster

RtDrSec         equ    62+BPBOff  * Anzahl der Root-DIR Sektoren
FrstDIRC        equ    66+BPBOff  * Erster DIR Cluster


***** Master Boot Record *****

** Partitions-Offsets

partoff1        equ     $1be
partoff2        equ     $1ce
partoff3        equ     $1de
partoff4        equ     $1ee

** Partition Infos

Bootflag        equ     $00
SHdoff          equ     $01             * nicht ausgewertet
SSecoff         equ     $02             * nicht ausgewertet
SCyloff         equ     $03             * nicht ausgewertet
typoff          equ     $04
EHdoff          equ     $05             * nicht ausgewertet
ESecoff         equ     $06             * nicht ausgewertet
ECyloff         equ     $07             * nicht ausgewertet
startoff        equ     $08
sizeoff         equ     $0c


END_DIR         equ     0
NO_MATCH        equ     1
MATCH_N         equ     2               * Match Name
MATCH_E         equ     3               * Match Extension
FULL_MAT        equ     MATCH_N+MATCH_E

F_CLOSED        equ     0
F_READ          equ     1
F_WRITE         equ     2

F_ERROR         equ     0
F_OK            equ     1


maxofile        equ     2               * Max. offene Dateien a 1074 Byte
FDOff           equ     128             * Offset fýr File Discriptoren

***** File Descriptor *****

FileName        equ        0            * file name
FileExt         equ        8            * file extension
FileDOff        equ       11            * dir entry offset in FileDirSektor/
FileCSec        equ       12            * current File Sektor
File1CS         equ       16            * 1st sektor of current cluster used
FileDSec        equ       20            * dir sektor holding this fileentry
FileSize        equ       24            * Size in Byte
FilePos         equ       28            * file byte position
FileFlag        equ       32            * open or closed
FileAttr        equ       33            * file attribute / dir functions
FileCC          equ       34            * FileClusterCount
File1C          equ       38            * FileFirstCluster
FileCurC        equ       42            * number of cluster in use
FileAdr         equ       46            * Startadresse im RAM
Fiob            equ       50            * 64 Byte Puffer

***** DIR Eintrûge *****

DIRName         equ     $0              * Dateiname
DIRExt          equ     $8              * Dateierweiterung
DIRAttr         equ     $b              * Attribute
DIREZt          equ     $d              * Erstellungs Zeit 10tel Sek.
DIRLDt          equ     $e              * Datum letzter Zugriff (unbenutzt)
DIR1CH          equ     $14             * 1. Cluster high Word (FAT32)
DIRLCh          equ     $16             * Zeit letzte ûnderung
DIR1CL          equ     $1a             * Erster Cluster der Datei (low Word)
DIRSize         equ     $1c             * Grüsse der Datei in Byte

***** Parser Flag Bits *****

pfopt           equ     0       * Parser Flag Option

pfqlw           equ     1       * Parser Flag Quell-Laufwerk
pfqpath         equ     2       * Parser Flag Quell-Pfad (noch unbenutzt)
pfqdatn         equ     3       * Parser Flag Quell-Dateiname
pfqdate         equ     4       * Parser Flag Quell-Dateiextension

pfzlw           equ     5       * Parser Flag Ziel-Laufwerk
pfzpath         equ     6       * Parser Flag Ziel-Pfad (noch unbenutzt)
pfzdatn         equ     7       * Parser Flag Ziel-Dateiname
pfzdate         equ     8       * Parser Flag Ziel-Dateiextension

pfadr1          equ     9       * Parser Flag Adresswert1
pfadr2          equ     10      * Parser Flag Adresswert2

***** Parser Offsets (immer auf gerader Adresse!) *****

pflag           equ     0       * Parser Flag                   (1 Langwort)
popt            equ     4       * Parser Optionen               (1 Langwort)
pqlw            equ     8       * Parser Quell-Laufwerk         (5 Byte)
                                *                               (1 Byte frei)
pqtyp           equ     14      * Parser Quell-Laufwerkstyp     (1 Byte)
                                *                               (1 Byte frei)
pqdatn          equ     16      * Parser Quell-Dateiname        (8 Byte)
pqdate          equ     24      * Parser Quell-Dateiextension   (3 Byte)
                                *                               (1 Byte frei)
pzlw            equ     28      * Parser Ziel-Laufwerk          (5 Byte)
                                *                               (1 Byte frei)
pztyp           equ     34      * Parser Ziel-Laufwerkstyp      (1 Byte)
                                *                               (1 Byte frei)
pzdatn          equ     36      * Parser Ziel-Dateiname         (8 Byte)
pzdate          equ     44      * Parser Ziel-Dateiextension    (3 Byte)
                                *                               (1 Byte frei)
padr1           equ     48      * Parser Adresswert1            (1 Langwort)
padr2           equ     52      * Parser Adresswert2            (1 Langwort)


***** JADOS File Control Block *****

JLW             equ     0               * Laufwerk
JDName          equ     2               * Dateiname
                                        * 2 Byte Reserve (0)
JDExt           equ     12              * Dateityp
                                        * 1 Byte Reserve (0)
JSSpr           equ     16              * Startspur
JESec           equ     18              * Endsektor
JEByte          equ     20              * Endbyte (unbenutzt)
JDat            equ     22              * Datum
JDatL           equ     26              * Dateilûnge in Sektoren (1024 Byte)
JDatMod         equ     28              * Dateimodus
                                        * 3 Byte reserve
JDirSec         equ     32              * Sektor des DIRs
JDirBt          equ     34              * Startbyte im Sektor des DIRs
JDatStat        equ     36              * Dateistatus
JAktSpur        equ     38              * Nummer der akt. Spur
JAktSec         equ     40              * akt. Sektor der akt. Spur
JLSpur          equ     42              * Nummer des letzten Dateispur
JAktAdr         equ     44              * akt. Speichertransferadresse


***** Allgemeine Variablen *****

hdnum           equ     0               * 0=FD0,2=IDE-Master,4=SD-Card 0

hdbtfild        equ     4               * Bitfeld fýr LWs mit passendem FS-Typ
aktlw           equ     8               * Nummer des aktiven Laufwerks
                                        * #0=FD0,#2=HDA1,#6=HDB1,#10=SDA1
FATStat         equ     10              * FAT Status Byte
JNAFlag         equ     12              * ýberschreiben? Byte
                                        * 0=nein,1=ja,2=alle
quiet           equ     14              * Ausgabe unterdrýcken? Byte
                                        * 0=nein,1=nur noch Fehler,
                                        * 2=alle unterdrýcken
errnum          equ     16              * Fehlernummer Langwort
trace           equ     20              * Fehlersuche Langwort
ffpos           equ     24              * FindFile Fileposition
                                        * -1=nichts gefunden LW
ffsec           equ     28              * FindFile Sektor
ffclus          equ     32              * FindFile Cluster
ffsecc          equ     36              * FindFile Sektor-Count
convflag        equ     40              * Konvertierungs Flag Byte
                                        * 0 = nicht Konvertieren

hdname          equ     8               * Offset fýr Laufwerkname in GP
hdoff           equ     256             * Offset fýr Laufwerkspeicherbereiche

***** VARIABLEN *****
VarStart:
 ds 0
allgm:          ds.b 64                 * Allgemeine Variablen
parsdat:        ds.b 64                 * Parser Daten
hddat:          ds.b 1024               * Diskparameter + BPB fýr 4 HDs
fatbuff:        ds.b 512                * FAT Puffer 1 Sektor
dirbuff:        ds.b 512                * DIR Puffer 1 Sektor
buffer:         ds.b 512                * Puffer fýr allgm. Verwendung
jfcb:           ds.b 48                 * JADOS FileControlBlock
jdirbuf:        ds.b 4096               * JADOS DIR Buffer
filebuff:       ds.b FDOff*maxofile     * File Buffer
VarEnd:



        
*************************** Texte ********************************
meldung:  dc.b 'loading os ...',$d,$a,$d,$a,0   
fname: dc.b 'NKC68K.ROM',0   
* fname: dc.b 'MONITOR.68K',0   
		 
 		
ende:

        
        
