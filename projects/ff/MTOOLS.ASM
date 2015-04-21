*****************************************
*                                       *
*               MTOOLS                  *
*                                       *
*   die Tools fürs FAT16 Dateisystem    *
*                                       *
*            von Jens Mewes             *
*                                       *
*         V 0.8F : 2007.11.01           *
*                                       *
*****************************************


CPU     equ     4               * 68008 = 1, 68000 = 2, 68020 = 4

clk     equ     25              * Taktfrequenz in MHz

delay   equ     100000            * Wartezeit bis LW ready, (*TH)
                                * bei Bedarf (altes LW) bis 100000 erhöhen

GIDE    equ     $FFFFFF10       * Adresse der GIDE Baugruppe


IdeDOR  equ     (GIDE+6)*CPU
IdeDat  equ     (GIDE+8)*CPU
IdeErr  equ     (GIDE+9)*CPU
IdeSCnt equ     (GIDE+$0A)*CPU
IdeSNum equ     (GIDE+$0B)*CPU
IdeCLo  equ     (GIDE+$0C)*CPU
IdeCHi  equ     (GIDE+$0D)*CPU
IdeSDH  equ     (GIDE+$0E)*CPU
IdeCmd  equ     (GIDE+$0F)*CPU

CmdRd   equ     $20
CmdWr   equ     $30
CmdInit equ     $91

* (*TH) Cache Flush Command
CmdFl   equ     $e7


start:
 movem.l d0-d7/a0-a6, -(a7)
 lea allgm(pc), a4                      * Index für relativen Zugriff
 lea trap10(pc), a0                     * Trap #10 initialisieren
 move.l a0, $A8
 bsr cls                                * Bildschirm löschen
 bsr ClrVars                            * Variablen löschen
 bsr SetMaster                          * Master Laufwerk auswählen
 bsr GetDrive                           * Laufwerksdaten laden
 tst.l d0                               * alles OK?
 beq lp01                               * ja
 move.l #1, errnum(a4)
 bsr error
 bra.b Exit
lp01:
 bsr SetSlave                           * Slave setzen
 bsr GetDrive                           * Slavedaten laden
 tst.l d0                               * alles OK?
 beq.b lp03                             * ja
 move.b #-1, slavflag(a4)               * kein Slave vorhanden
 lea txtnv(pc), a0                      * Text "Laufwerk nicht vorhanden"
 lea slave(pc), a1                      * in Diskname
 adda.l #Diskname, a1
lp02:
 move.b (a0)+, (a1)+
 bne.b lp02
lp03:
 move.b #$06, d0                        * FAT16 Type 06
 bsr FSChk                              * Dateisystem suchen
 move.b #$04, d0                        * FAT16 Type 04
 bsr FSChk                              * und suchen
 bsr ALW                                * aktives LW setzen
 tst.l hdbtfild(a4)
 bne.b lp04
 move.l #2, errnum(a4)
 bsr error
 bra.b Exit
lp04:
 lea txtinit(pc), a0                    * freundliche Meldung
 bsr writetxt
Exit:
 movem.l (a7)+, d0-d7/a0-a6
 rts


ClrVars:
 lea VarStart(pc), a0
 move.l #VarEnd-VarStart-1, d3           * Alle Variablen und Puffer
cb01:
 clr.b (a0)+
 dbra d3, cb01
rts


SetMaster:                              * Masterlaufwerk einstellen
 move.b #$a0, msbyte(a4)
 lea master(pc), a6
 rts


SetSlave:                               * Slavelaufwerk einstellen
 move.b #$b0, msbyte(a4)
 lea slave(pc), a6
 rts


GetDrive:                               * Laufwerksdaten laden
 movem.l d1-d2/a0, -(a7)
 bsr Ident                              * LW Identifizieren
 tst.l d0
 bmi GDerr
 bsr HDInit                             * LW initialisieren
 tst.l d0
 bmi GDerr
 clr.l d0
 lea buffer(PC), a0
 bsr ReadSec                            * MBR lesen
 tst.l d0
 bmi GDerr
 lea buffer(PC), a0

 move.b partoff1+typoff(a0), typ1(a6)   * Partitionsdaten speichern
 move.l partoff1+startoff(a0), d0
 bsr LBHLW
 move.l d0, starts1(a6)
 move.l partoff1+sizeoff(a0), d0
 bsr LBHLW
 move.l d0, groesse1(a6)

 move.b partoff2+typoff(a0), typ2(a6)
 move.l partoff2+startoff(a0), d0
 bsr LBHLW
 move.l d0, starts2(a6)
 move.l partoff2+sizeoff(a0), d0
 bsr LBHLW
 move.l d0, groesse2(a6)

 move.b partoff3+typoff(a0), typ3(a6)
 move.l partoff3+startoff(a0), d0
 bsr LBHLW
 move.l d0, starts3(a6)
 move.l partoff3+sizeoff(a0), d0
 bsr LBHLW
 move.l d0, groesse3(a6)

 move.b partoff4+typoff(a0), typ4(a6)
 move.l partoff4+startoff(a0), d0
 bsr LBHLW
 move.l d0, starts4(a6)
 move.l partoff4+sizeoff(a0), d0
 bsr LBHLW
 move.l d0, groesse4(a6)

 clr.l d0
 bra.b GDex
GDerr:
 move.l #-1, d0
GDex:
 movem.l (a7)+, d1-d2/a0
 rts


Ident:                          * Identifiziert ein Laufwerk
 move.b msbyte(a4), IdeSDH              * Master / Slave
idlp01:
 clr numCyl(a6)
 clr.b numHead(a6)
 clr.b numSec(a6)
 bsr waitready
 tst.l d0
 bmi idlp20
 move.b #$ec, IdeCmd
 bsr waitdrq
 tst.l d0
 bmi idlp20
 lea buffer(PC), a0
 lea IdeDat, a1
 move.l #512-1, d3
idlp04:
 move.b (a1), (a0)+
 dbra d3, idlp04
 bsr waitready
 tst.l d0
 bmi idlp20
 lea buffer(PC), a0
 clr.l d0
 move.b 3(a0), d0
 lsl #8, d0
 move.b 2(a0), d0
 move d0, numCyl(a6)
 clr.l d0
 move.b 6(a0), numHead(a6)
 move.b 12(a0), numSec(a6)
 movea.l a6, a1
 adda.l #Diskname, a1
 adda.l #54, a0
 move #20-1, d3
idlp10:
 move.b 1(a0), (a1)+
 move.b 0(a0), (a1)+
 addq.l #2, a0
 dbra d3, idlp10
 move #$0, (a1)+
 clr.l d0
 bra.b idex
idlp20:
 move.l #-1, d0
idex:
 rts


HDInit:                         * Initialisiert das Laufwerk
 move.b #6, IdeDOR
 move.l #255, d3
HDIlp01:
 dbra d3, HDIlp01
 move.b #2, IdeDOR
 bsr waitready
 tst.l d0
 beq.b HDIlp03
 bra HDIex
HDIlp03:
 move.b numSec(a6), IdeSCnt
 move.b numCyl+1(a6), IdeCLo
 move.b numCyl(a6), IdeCHi
 move.b numHead(a6), d0
 subq.b #1, d0
 or.b msbyte(a4), d0
 move.b d0, IdeSDH
 move.b #CmdInit, IdeCmd
HDIex:
 rts


LBAtoCHS:                       * Rechenet LBA (d0.l) in Head (d1.b),
                                * Sektor (d2.b) und Cylinder (d3.w) um
                                * a6 = Master/Slave-Buffer
 clr.l d1
 move.b numSec(a6), d1
 divu d1, d0
 swap d0
 move.b d0, d2                          * Sektor
 addq.b #1, d2
 clr d0
 swap d0
 move.b numHead(a6), d1
 divu d1, d0
 move d0, d3                            * Cylinders
 swap d0                                * Head
 move.b d0, d1
 rts


ReadSec:                * liest einen Sektor D0=Sektornummer, A0=Puffer
 movem.l d1-d5/a1-a2, -(a7)
 clr.l errnum(a4)
 move.l d0, d2                          * sichern
 bsr waitready
 tst.l d0
 beq.b Rdlp01
 bra Rderr
Rdlp01:
 move.b #1, IdeSCnt                     * einen Sektor
 move.l d2, d0                          * Sektor zurück
 bsr LBAtoCHS                           * nach CHS umrechnen
 move.b d2, IdeSNum
 move.b d3, IdeCLo
 lsr #8, d3
 move.b d3, IdeCHi
 or.b msbyte(a4), d1
Rdlp10:
 move.b d1, IdeSDH
 move.l #10-1, d2                       * 10 Versuche
 movea.l a0, a2                         * retten
Rdlp12:
 movea.l a2, a0
 lea IdeDat, a1
 move.l #512-1,d3                       * Anzahl Bytes
 move.b #CmdRd, IdeCmd
 bsr waitdrq
 tst.l d0
 bne Rderr
Rdlp13:
 move.b (a1), (a0)+                     * lesen
 dbra d3, Rdlp13
 bsr waitready
 tst.l d0
 bne Rderr
 move.b IdeCmd, d0
 and.b #%10001001, d0                   * irgend welche Fehler?
 beq.b Rdlp20                           * nö, fertig
 dbra d2, Rdlp12                        * sonst nochmal
 move.l #5, errnum(a4)
Rderr:
 moveq.l #-1, d0
 bra.b Rdex
Rdlp20:
 clr.l d0
Rdex:
 movem.l (a7)+, d1-d5/a1-a2
 rts


WriteSec:               * schreibt einen Sektor D0=Sektornummer, A0=Puffer

 movem.l d1-d5/a1-a2, -(a7)
 clr.l errnum(a4)
 move.l d0, d2                          * sichern
 bsr waitready
 tst.l d0
 beq.b Wrlp01
 bra Wrerr
Wrlp01:
 move.b #1, IdeSCnt                     * einen Sektor
 move.l d2, d0                          * Sektor zurück
 bsr LBAtoCHS                           * in CHS umrechnen
 move.b d2, IdeSNum
 move.b d3, IdeCLo
 lsr #8, d3
 move.b d3, IdeCHi
 or.b msbyte(a4), d1
 move.b d1, IdeSDH
 move.l #10-1, d2                       * 10 Versuche
 movea.l a0, a2                         * retten
 lea IdeDat, a1
Wrlp12:
 move.b #CmdWr, IdeCmd
 movea.l a2, a0
 move.l #512-1,d3                       * Anzahl Bytes
 bsr waitdrq
 tst.l d0
 bne Wrerr
Wrlp13:
 bra	*+4                             * kleines DELAY (*TH)
 move.b (a0)+, (a1)                     * schreiben
 dbra d3, Wrlp13
 bsr waitready
 tst.l d0
 bne Wrerr
 move.b IdeCmd, d0
 and.b #%10001001, d0                   * irgend welche Fehler?
                                        * sollten hier nicht DE und ERR
                                        * also 00100001 abgefragt werden ? (*TH)
 beq.b Wrlp20                           * nö, fertig
 dbra d2, Wrlp12                        * sonst noch'n Versuch
 move.l #6, errnum(a4)
Wrerr:
 moveq.l #-1, d0
 bra.b Wrex
Wrlp20:
 clr.l d0
Wrex:
 bsr idefl                              * (*TH) IDE Cache FLush
 movem.l (a7)+, d1-d5/a1-a2
 rts


waitready:                      * Warten bis Laufwerk ready
 move.l #delay*clk, d0
wr01:
 subq.l #1, d0
 bmi wr02                               * Abbruch
 btst.b #7, IdeCmd
 bne.b wr01
 clr.l d0                               * ist ready
 bra.b wrexit
wr02:
 move.l #-1, d0                         * ist NICHT ready
 move.l #3, errnum(a4)
wrexit:
 rts


waitdrq:                        * Warten bis LW bereit für Daten
 move.l #delay*clk, d0
wd01:
 subq.l #1, d0
 bmi wd02                               * Abbruch
 btst.b #3, IdeCmd
 beq.b wd01
 clr.l d0                               * Daten bereit
 bra.b wdex
wd02:
 move.l #-1, d0                         * Daten NICHT bereit
 move.l #4, errnum(a4)
wdex:
 rts

idefl:
 move.b #CmdFl, idecmd.w
 bsr waitready
 rts

LBHLW:                          * dreht die Bytes in d0.l
bsr LowBHigh
swap d0

LowBHigh:                       * dreht die Bytes in d0.w
 ror #8, d0
 rts


FSChk:                          * Prüft ob FS-Typ d0 entspricht, legt das
                                * Ergebnis in hdbtfild ab und setzt
                                * das erste gefundene LW "aktiv"
 movem.l d0-d3/d6, -(a7)
 move d0, d1                            * FS-Typ ($06 für FAT16)
 bsr SetMaster
 clr.l d6                               * als Bitfeld Merker
 cmp.b typ1(a6), d1                     * Vergleich ob FS-Typ stimmt
 bne.b FSC01
 bset.l #2, d6
FSC01:
 cmp.b typ2(a6), d1
 bne.b FSC02
 bset.l #3, d6
FSC02:
 cmp.b typ3(a6), d1
 bne.b FSC03
 bset.l #4, d6
FSC03:
 cmp.b typ4(a6), d1
 bne.b FSC04
 bset.l #5, d6
FSC04:
 bsr SetSlave
 cmp.b typ1(a6), d1
 bne.b FSC11
 bset.l #17, d6
FSC11:
 cmp.b typ2(a6), d1
 bne.b FSC12
 bset.l #18, d6
FSC12:
 cmp.b typ3(a6), d1
 bne.b FSC13
 bset.l #19, d6
FSC13:
 cmp.b typ4(a6), d1
 bne.b FSC14
 bset.l #20, d6
FSC14:
 or.l d6, hdbtfild(a4)
 movem.l (a7)+, d0-d3/d6
 rts


ALW:
 movem.l d0/d3/d6, -(a7)
 clr aktlw(a4)
 move.l hdbtfild(a4), d6
 asr.l #2, d6                           * FD0 und FD1 nicht cheken
 move #1, d0                            * erst mit HDA1 anfangen
 move #4-1, d3                          * HDA1 bis HDA4
ALW01:                                  * aktives LW ermitteln
 addq #1, d0
 asr.l #1, d6
 bcs.b ALW10
 dbra d3, ALW01

 move.l hdbtfild(a4), d6
 swap d6
 asr #1, d6                             * weiter mit Bit 17 ???
 move #16, d0                           * dann mit HDB1 weiter
 move #4-1, d3                          * HDB1 bis HDB4
ALW02:
 addq #1, d0
 asr.l #1, d6
 bcs.b ALW10
 dbra d3, ALW02
 bra.b ALW11
ALW10:
 move d0, aktlw(a4)
 bsr LoadLW
ALW11:
 movem.l (a7)+, d0/d3/d6
 rts


LoadLW:                         * Liest die LW- (Parttitions-) Daten
 movem.l d1/a0, -(a7)
 move aktlw(a4), d1
 cmp #2, d1
 blt LLWErr                     * Disketten Laufwerke nicht unterstützt
 cmp #17, d1
 bge LLW10                              * Slave Laufwerk
 cmp #6, d1
 bge LLWErr                     * HDA5 bis HDA15 noch nicht unterstützt
 bsr SetMaster
 cmp #2, d1
 bne.b LLW00
 move.l starts1(a6), d0
 bra.b LLW20
LLW00:
 cmp #3, d1
 bne.b LLW01
 move.l starts2(a6), d0
 bra.b LLW20
LLW01:
 cmp #4, d1
 bne.b LLW02
 move.l starts3(a6), d0
 bra.b LLW20
LLW02:
 cmp #5, d1
 bne LLWErr
 move.l starts4(a6), d0
 bra.b LLW20
 lea buffer(pc), a0

LLW10:
 tst.b slavflag(a4)
 bne.b LLWErr                           * kein Slave vorhanden
 cmp #21, d1
 bge LLWErr                     * HDB5 bis HDB15 noch nicht unterstützt
 bsr SetSlave
 cmp #17, d1
 bne.b LLW11
 move.l starts1(a6), d0
 bra.b LLW20
LLW11:
 cmp #18, d1
 bne.b LLW12
 move.l starts2(a6), d0
 bra.b LLW20
LLW12:
 cmp #19, d1
 bne.b LLW13
 move.l starts3(a6), d0
 bra.b LLW20
LLW13:
 cmp #20, d1
 bne LLWErr
 move.l starts4(a6), d0

LLW20:
 bsr LoadBPB
 tst.l d0
 bmi.b LLWErr
 lea txtroot(pc), a0
 move.b (a0)+, NoAD(a6)
 move.b (a0), NoAD+1(a6)

LLWOK:
 clr.l d0
 bra.b LLWExit
LLWErr:
 move.l #-1, d0
LLWExit:
 movem.l (a7)+, d1/a0
 rts


LoadBPB:                        * Liest die BPB Daten ein D0=Partitions-Offset
 movem.l d1-d2/a0, -(a7)
 move.l d0, d2                          * sichern
 lea buffer(pc), a0
 bsr ReadSec                            * Boot-Sektor lesen
 tst.l d0
 bmi LdBPBerr
 lea buffer(pc), a0

 adda.l #$B, a0                         * BPS Offset
 move.b (a0)+, BPS+1(a6)                * Bytes pro Sektor (immer 512!!!)
 move.b (a0)+, BPS(a6)

 move.b (a0)+, SPC(a6)                  * Sektoren pro Cluster

 move.b (a0)+, RSC+1(a6)                * Anzah der reservierten Sektoren
 move.b (a0)+, RSC(a6)

 move.b (a0)+, numFATs(a6)              * Anzahl der FATs

 move.b (a0)+, REC+1(a6)                * Anzahl der einträge im Root-DIR
 move.b (a0)+, REC(a6)

 move.b (a0)+, TotSec16+1(a6)           * Anzahl der Sektoren (bei 16 Bit)
 move.b (a0), TotSec16(a6)

 adda.l #2, a0
 move.b (a0)+, FATSz+1(a6)              * Grösse der FAT in Sektoren
 move.b (a0)+, FATSz(a6)

 adda.l #8, a0
 move.l (a0), d0
 bsr LBHLW
 move.l d0, TotSec32(a6)                * Anzahl der Sektoren (bei 32 Bit)

 clr.l d0
 move REC(a6), d0                       * Anzahl der DIR Einträge
 asl.l #5, d0                           * *32 (Grösse eines Eintrags in Byte)
 add.l #511, d0                         * +BPS-1
 asr.l #8, d0
 asr.l #1, d0                            * /512 (BPS)
 move.l d0, RtDrSec(a6)                  * Anzahl der Root-DIR Sektoren

 move.l d2, d0                          * Partitions-Offset (Boot-Offset)
 clr.l d1
 move RSC(a6), d1                       * Anzahl der reservierten Sektoren
 add.l d1, d0                           * +Boot-Offset
 move.l d0, FATFrst(a6)                 * =Erster FAT Sektor

 clr.l d2
 move.b numFATs(a6), d2                 * Anzahl der FATs
 move FATSz(a6), d1                     * Grösse der FATs in Sektoren
 mulu d2, d1
 add.l d1, d0                           * +Ersten FAT-Sektor
 move.l d0, RootFrst(a6)                * =Erster Root-DIR Sektor

 clr.l d2
 move.l RtDrSec(a6), d2                 * Anzahl der Root-DIR Sektoren
 add.l d2, d0                           * +Erstem Root-DIR Sektor
 move.l d0, DataFrst(a6)                * =Erster Daten-Sektor

 tst TotSec16(a6)               * falls Anzahl 16 Bit Sektoren=0 dann 32 Bit
 beq.b LBPB01
 move TotSec16(a6), TotSec(a6)          * sonst 16 Bit
 bra.b LBPB02
LBPB01:
 move.l TotSec32(a6), TotSec(a6)
LBPB02:

 clr.l d0
 move RSC(a6), d0
 add.l d0, d1                           * D1=FATSz+RSC
 move.l RtDrSec(a6), d0
 add.l d0, d1                           * D1=FATSz+RSC+RtDrSec
 move.l TotSec(a6), d0
 sub.l d1, d0                           * D0=TotSec-FATSz+RSC+RtDrSec=DataSec
 move.l d0, DataSec(a6)                 * Anzahl der Daten-Sektoren

 clr.l d1
 move.b SPC(a6), d1
 divu d1, d0                            * D0=TotSec/SPC=CntClust
 and.l #$000FFFF, d0
 move.l d0, CntClust(a6)                * Anzahl der Cluster
 addq.l #2, d0
 move.l d0, lastClus(a6)                * CntClust+2=lastClus

 move.l #$FFF8, eoClusCh(a6)            * nur bei FAT16!!!

 clr.l d0
 move.b SPC(a6), d0                     * Sektoren pro Cluster
 move BPS(a6), d1                       * Bytes pro Sektor
 mulu d1,d0
 move.l d0, BPC(a6)                     * BytesPerCluster

 move.l FATFrst(a6), d0                 * Laden des ersten FAT-Sektors
 move.l d0, FATCurr(a6)
 lea fatbuff(PC), a0
 bsr ReadSec
 tst.l d0
 bmi.b LdBPBerr
 clr.b FATStat(a4)
 clr.l FrstDIRC(a6)                     * Erster DIR-Cluster = 0 (Root-DIR)
 clr.l d0
 bra.b LdBPBex
LdBPBerr:
 move.l #-1, d0
LdBPBex:
 movem.l (a7)+, d1-d2/a0
 rts



******  FAT Teil  ******

UpFATBu:                        * Update FAT Buffer d0=newsektor
 movem.l d1/a0, -(a7)
 cmp.l FATCurr(a6), d0
 bne.b UFB01
 clr.l d0
 bra.b UFBex
UFB01:
 move.l d0, d1                          * sichern
 tst.b FATStat(a4)
 beq.b UFB02
 move.l FATCurr(a6), d0
 lea fatbuff(PC), a0
 bsr WriteSec
 tst.l d0
 bmi.b UFBerr                           * Schreibfehler
UFB02:
 move.l d1, d0
 lea fatbuff(PC), a0
 bsr ReadSec
 tst.l d0
 bmi.b UFBerr                           * Lesefehler
 move.l d1, FATCurr(a6)
 clr.b FATStat(a4)
 clr.l d0
 bra.b UFBex
UFBerr:
 move.l #-1, d0
UFBex:
 movem.l (a7)+, d1/a0
 rts

FFAT:                           * Flush FAT Buffer
 movem.l a0, -(a7)
 move.l FATCurr(a6), d0
 lea fatbuff(PC), a0
 bsr WriteSec
 tst.l d0
 bmi.b FFATerr                          * Schreibfehler
 clr.b FATStat(a4)
 clr.l d0
 bra.b FFATex
FFATerr:
 move.l #-1, d0
FFATex:
 movem.l (a7)+, a0
 rts

GNCN:                           * GetNextClusterNumber d0=Clusternummer
 movem.l d1-d2/a0, -(a7)
 and.l #$ffff, d0                       * auf Wort
 cmp.l lastClus(a6), d0
 bgt GNCNerr1                           * Disk voll
 move.l d0, d2                          * sichern
 lsr.l #8, d0                           * *2 / 512 (BPS)
 add.l FATFrst(a6), d0
 bsr UpFATBu
 tst.l d0
 bmi.b GNCNerr                          * Schreib-/Lesefehler
 move.l d2, d0                          * zurück
 asl.l #1, d0                           * *2
 and.l #$1ff, d0                        * Rest von /512 (BPS)
 lea fatbuff(PC), a0
 clr.l d1
 move.b 1(a0,d0), d1
 lsl #8, d1
 move.b 0(a0,d0), d1
 move.l d1, d0
 bra.b GNCNex
GNCNerr1:
 move.l #7, errnum(a4)                  * Disk full
GNCNerr:
 move.l #-1, d0
GNCNex:
 movem.l (a7)+, d1-d2/a0
 rts

GFSOC:                          * GetFirstSektorOfCluster d0=Cluster
 move.l d1, -(a7)
 and.l #$ffff, d0                       * auf Wort
 subq.l #2, d0
 clr.l d1
 move.b SPC(a6), d1
 mulu d1, d0
 add.l DataFrst(a6), d0
 move.l (a7)+, d1
 rts

AllClus:                        * AllocCluster d0=currentcluster
 movem.l d1-d2, -(a7)
 move.l d0, d1                          * CurrentCluster sichern
 bsr FFC                                * FindFreeCluster
 cmp.l #-1, d0                          * Fehler?
 beq.b ACerr                            * jo
 move.l d0, d2                          * neuen Cluster sichern
 tst.l d1                               * neuer Clusterchain?
 beq.b AClp01                           * jo
 exg d0, d1                             * neue Clusternr in Alten
 bsr WCN                                * WriteClusterNumber
 tst.l d0                               * hats geklappt?
 bmi.b ACerr                            * nö
AClp01:
 move.l d2, d0                          * neuen Cluster zurück
 move.l #$FFFF, d1                      * Clusterchain Ende
 bsr WCN                                * WriteClusterNumber
 tst.l d0                               * alles OK?
 bmi.b ACerr                            * nö
 move.l d2, d0                          * neuen Cluster zurück
 bra.b ACex
ACerr:
 move.l #-1, d0
ACex:
 movem.l (a7)+, d1-d2
 rts

FFC:                            * FindFreeCluster d0 = currentcluster
 movem.l d1-d2, -(a7)
 move.l d0, d1                          * CurrentCluster sichern
 addq.l #1, d0
FFClp01:
 cmp.l lastClus(a6), d0
 bge.b FFClp02
 move.l d0, d2                          * Cluster sichern
 bsr GNCN                               * GetNextClusterNumber
 cmp.l #-1, d0
 beq.b FFCerr                           * Schreib-/Lesefehler
 tst.l d0
 bne.b FFClp03                          * Cluster nicht leer, weiter
 move.l d2, d0
 bra.b FFCex
FFClp03:
 move.l d2, d0
 addq.l #1, d0
 bra.b FFClp01
FFClp02:
 move.l #2, d0                          * erster Cluster
FFClp04:
 cmp.l d1, d0
 bge.b FFCerr1                          * kein freier Cluster
 move.l d0, d2
 bsr GNCN                               * GetNextClusterNumber
 cmp.l #-1, d0
 beq.b FFCerr                           * Schreib-/Lesefehler
 tst.l d0
 bne.b FFClp05                          * Cluster nicht leer, weiter
 move.l d2, d0
 bra.b FFCex
FFClp05:
 move.l d2, d0
 addq.l #1, d0
 bra.b FFClp04
FFCerr1:
 move.l #8, errnum(a4)
FFCerr:
 move.l #-1, d0
FFCex:
 movem.l (a7)+, d1-d2
 rts

WCN:                            * WriteClusterNumber
                                * D0.l=Cluster Nummer, D1.w=Wert
 movem.l d1/d3/a0, -(a7)
 cmp.l lastClus(a6), d0
 ble.b WCN01
 move.l #25, errnum(a4)
 bra.b WCNerr
WCN01:
 move.l d0, d3                          * Cluster sichern
 lsr.l #8, d0                           * *2/512(BPS)=> /256
 add.l FATFrst(a6), d0                  * +FATFirst
 bsr UpFATBu                            * UpdateFATBuffer
 tst.l d0
 bmi.b WCNerr
 lea fatbuff(PC), a0
 move.l d3, d0
 asl.l #1, d0                           * Cluster * 2
 and.l #$1ff, d0                        * => mod 512
 adda.l d0, a0
 move.b d1, (a0)+
 lsr #8, d1
 move.b d1, (a0)
 move.b #1, FATStat(a4)
 clr.l d0
 bra.b WCNex
WCNerr:
 move.l #-1, d0
WCNex:
 movem.l (a7)+, d1/d3/a0
 rts


***** DOS Teil *****

FFFD:                           * Find Free File Descriptor
 movem.l d3/a0, -(a7)
 clr.l d0
 move #maxofile-1, d3
 lea filebuff(pc), a0
FFFD01:
 tst.b FileFlag(a0)
 beq.b FFFD10
 addq #1, d0
 adda.l #FDOff, a0
 dbra d3, FFFD01
 move.l #-1, d0
 move.l #9, errnum(a4)
 bra FFFDExit
FFFD10:
 move.b #-1, FileFlag(a0)               * File öffnen
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
 movem.l (a7)+, d3/a0
 rts


FindName:                               * d0 = FileID
 movem.l d1, -(a7)
 cmp #-1, d0
 beq.b FNerr                            * keine Suche zu viele offene Dateien
 cmp #maxofile, d0
 bge.b FNerr                            * FileID zu gross
 cmp.l #2, FrstDIRC(a6)
 bge.b FN01
 bsr ScRD                               * ScanRootDIR
 bra.b FNex
FN01:
 move.l FrstDIRC(a6), d1
 bsr ScSD                               * Scan Sub-DIR
 bra.b FNex
FNerr:
 move.l #NO_MATCH, d0
FNex:
 movem.l (a7)+, d1
 rts


fload:                                  * Lädt eine Datei in den Arbeitsspeicher
                                        * d0=FileID
 movem.l d2-d4/d6/a0-a3, -(a7)
 bsr FileDsct                           * File Daten in a0
 movea.l a0, a2                         * in a2 sichern
 move.l FileSize(a2), d2                * Dateigrösse
 move.l d2, d3
 asr.l #8, d3
 asr.l #1, d3                           * d0 = Dateigrösse in Sektoren
 and.l #$1ff, d2                        * noch ein Teilsektor ?
 tst d2
 beq.b fld01                            * nö
 addq.l #1, d3                          * sonst ein Sektor mehr
fld01:
 subq.l #1, d3                          * Als Zähler
 movea.l FileAdr(a2), a0                * RAM-Adresse in a0
 movea.l a0, a3                         * sichern
 move.l File1C(a2), d6                  * erster Cluster der Datei
fld02:
 cmp.l eoClusCh(a6), d6                 * vorzeitiges Ende ?
 bge.b flderr
 movea.l a3, a0                         * Speicher wieder holen
 move.l d6, d0
 bsr GFSOC                              * GetFirstSektorOfCluster
 move.l d0, d2                          * merken
 clr.l d4
 move.b SPC(a6), d4                     * Anzahl der Sektoren pro Cluster
 subq.l #1, d4                          * als Zähler
fld03:
 move.l d2, d0                          * Sektor holen
 bsr ReadSec                            * lesen eines Sektors
 tst.l d0
 bmi.b flderr                           * Fehler beim lesen
 addq.l #1, d2                          * nächster Sektor
 subq.l #1, d3
 bmi.b fld10                            * fertig!
 dbra d4, fld03                         * nächster Sektor des Clusters
 movea.l a0, a3                         * RAM sichern
 move.l d6, d0
 bsr GNCN                               * GetNextClusterNumber
 tst.l d0
 bmi.b flderr
 move.l d0, d6
 bra.b fld02
fld10:
 clr.l d0
 bra.b fldex
flderr:
 move.l #-1, d0
fldex:
 movem.l (a7)+, d2-d4/d6/a0-a3
 rts


fsave:                                  * Speichert eine Datei
                                        * d0=FileID
 movem.l d2-d4/d6/a0-a3, -(a7)
 bsr FileDsct                           * File Daten in a0
 movea.l a0, a2                         * in a2 sichern
 move.l FileSize(a2), d2                * Dateigrösse
 move.l d2, d3
 asr.l #8, d3
 asr.l #1, d3                           * d3 = Dateigrösse in Sektoren
 and.l #$1ff, d2                        * noch ein Teilsektor ?
 tst d2
 beq.b fsv01                            * nö
 addq.l #1, d3                          * sonst ein Sektor mehr
fsv01:
 subq.l #1, d3                          * Als Zähler
 movea.l FileAdr(a2), a0                * RAM-Adresse in a0
 movea.l a0, a3                         * sichern
 move.l File1C(a2), d6                  * erster Cluster der Datei
 tst.l d6                               * neuer Clusterchain?
 bne.b fsv02                            * nö
 move.l d6, d0
 bsr AllClus                            * neuen Cluster suchen
 cmp.l #-1, d0
 beq.b fsverr                           * dann Fehler
 move.l d0, d6
fsv02:
 movea.l a3, a0                         * Speicher wieder holen
 move.l d6, d0                          * akt. Cluster
 bsr GFSOC                              * GetFirstSektorOfCluster
 move.l d0, d2                          * merken
 clr.l d4
 move.b SPC(a6), d4                     * Anzahl der Sektoren pro Cluster
 subq.l #1, d4                          * als Zähler
fsv03:
 move.l d2, d0                          * Sektor holen
 bsr WriteSec                           * Sektor schreiben
 tst.l d0
 bmi.b fsverr                           * Schreibfehler
 addq.l #1, d2                          * nächster Sektor
 subq.l #1, d3
 bmi.b fsv20                            * FERTIG
 dbra d4, fsv03                         * nächster Sektor des Clusters
 movea.l a0, a3                         * RAM-Adr. sichern
 move.l d6, d0
 bsr GNCN                               * GetNextClusterNumber
 cmp.l #-1, d0
 beq.b fsverr
 cmp.l eoClusCh(a6), d0                 * Clusterchain zu Ende?
 bge.b fsv10
 move.l d0, d6
 bra.b fsv02
fsv10:
 move.l d6, d0
 bsr AllClus                            * neuen Cluster suchen
 cmp.l #-1, d0
 beq.b fsverr                           * dann Fehler
 move.l d0, d6
 bra.b fsv02                            * sonst weiter
fsv20:
 bsr FFAT                               * FAT speichern
 tst.l d0
 bmi.b fsverr
 clr.l d0
 bra.b fsvex
fsverr:
 move.l #-1, d0
fsvex:
 movem.l (a7)+, d2-d4/d6/a0-a3
 rts

remove:                         * Löscht Datein. Name in parsdat
 movem.l d1/a0-a1, -(a7)
 bsr FFFD                               * FindFreeFileDiscriptor
 tst.l d0
 bmi rmverr1                            * keine freie FileID
 move.l d0, d1                          * FileID sichern
 bsr FileDsct                           * FileDiscriptor in a0
 movea.l a0, a1                         * sichern
 bsr FindFrst
 tst.l d0                               * was gefunden?
 bmi rmverr                             * nein
 cmp.l #-1, ffpos(a4)
 bne.b rmv01
 move.l #16, errnum(a4)                 * keine Datei da
 bra rmverr
rmv01:
 move.l d1, d0                          * FileID zurück
 bsr FFD
 btst.b #4, FileAttr(a1)                * DIR?
 bne rmv05                              * ja, nächste
 cmp.b #2, JNAFlag(a4)
 beq.b rmv03                            * Alle löschen
 tst.b quiet(a4)                        * Ausgabe unterdrücken?
 bne.b rmv02                            * ja
 move.l d1, d0
 lea txtcrlf(pc), a0                    * CRLF vorweg
 bsr writetxt
 bsr NameOut
 lea txtloe(pc), a0                     * löschen?
 bsr JNA                                * Ja/Nein/Alle
rmv02:
 cmp.b #2, JNAFlag(a4)
 beq.b rmv03                            * alle löschen
 tst.b JNAFlag(a4)
 beq.b rmv05                            * kein löschen
 clr.b JNAFlag(a4)                      * nur diese löschen
rmv03:
 move.l d1, d0                          * FileID zurück
 bsr rem
 tst.l d0
 bne.b rmverr
 tst.b quiet(a4)                        * Ausgabe unterdrücken?
 bne.b rmv04                            * ja
 move d1, d0
 lea txtcrlf(pc), a0                    * CRLF vorweg
 bsr writetxt
 bsr NameOut
 lea txtdel(pc), a0
 bsr writetxt
rmv04:
 move.b #$e5, FileName(a1)              * Name gelöscht
 clr.l FileSize(a1)                     * Dateigrösse = 0
 clr.l File1C(a1)                       * ersterCluster = 0
 clr.b FileAttr(a1)                     * Attribute = 0
 move.l d1, d0                          * FileID zurück
 bsr UFE                                * UpdateFileEntry
 tst.l d0
 bmi.b rmverr
rmv05:
 move.l d1, d0                          * FileID zurück
 bsr FindNext
 tst.l d0
 bmi.b rmverr                           * Fehler beim suchen
 cmp.l #-1, ffpos(a4)
 beq.b rmv06                            * keine weiteren Dateien
 bra rmv01
rmv06:
 clr.l d0
 bra.b rmvex
rmverr1:
 moveq.l #-1, d0
 bra.b rmvex1
rmverr:
 moveq.l #-1, d0
rmvex:
 clr.b FileFlag(a1)                     * FileID wieder frei
rmvex1:
 movem.l (a7)+, d1/a0-a1
 rts

rem:                            * Remove-Unterprogramm, d0 = FileID
 movem.l d1-d4/a0-a1, -(a7)
 move.l d0, d4                          * FileID sichern
 bsr FileDsct
 movea.l a0, a1                         * sichern
 move.b FileAttr(a1), d0                * DIR?
 btst.b #4, d0
 beq.b rem02                            * nein
 move.l #10, errnum(a4)
 bra.b remerr
rem02:
 move.l File1C(a1), d2
rem03:
 move.l d2, d0                          * Cluster
 bsr GNCN
 tst.l d0
 bmi.b remerr
 move.l d0, d3                          * nächster Cluster
 move.l d2, d0
 clr.l d1
 bsr WCN
 tst.l d0
 bmi.b remerr
 cmp.l eoClusCh(a6), d3
 bge.b rem04                            * Clusterchain durch
 move.l d3, d2                          * Cluster = nächster Cluster
 bra.b rem03
rem04:
 bsr FFAT
 tst.l d0
 bmi.b remerr                           * Fehler beim schreiben
rem05:
 clr.l d0
 bra.b remex
remerr:
 moveq.l #-1, d0
remex:
 movem.l (a7)+, d1-d4/a0-a1
 rts


QForm:                          * Quickformat des akt. Laufwerks
 movem.l d1-d3/a0-a1, -(a7)
 lea dirbuff(pc), a0                    * DIR Buffer in a0
 movea.l a0, a1                         * nach a1 sichern
 move.l #512-1, d3                      * 512 Byte
QF01:
 move.b #$e5, (a0)+                     * DIR Buffer mit $e5 füllen
 dbra d3, QF01
 move.l RtDrSec(a6), d3                 * Anzahl der RootDIR Sektoren
 subq.l #1, d3                          * -1 als Zähler
 move.l RootFrst(a6), d1                * Erster RootDIR Sektor
QF02:
 move.l d1, d0                          * Sektor
 movea.l a1, a0                         * DIR Buffer
 bsr WriteSec                           * Sektor schreiben
 tst.l d0
 bmi QFerr                              * Fehler beim schreiben
 addq.l #1, d1                          * nächster Sektor
 dbra d3, QF02
 movea.l a1, a0                         * DIR Buffer nach a0
 move.l #512-1, d3                      * 512 Byte
QF03:
 clr.b (a0)+                            * mit 0 füllen
 dbra d3, QF03
 move.l FATFrst(a6), d1                 * Erster FAT Sektor
 clr.l d2
 move.b numFATs(a6), d2                 * Anzahl der FATs
 subq.l #1, d2                          * -1 als Zähler
QF04:
 clr.l d3
 move FATSz(a6), d3                     * Grösse der FATs
 subq.l #2, d3                          * -2 als Zähler 1.Sec gesondert
 move.l d1, d0                          * Sektor
 movea.l a1, a0                         * Buffer
 move #$f8ff, 0(a0)
 move #$ffff, 2(a0)                     * Media rein 2 Cluster
 bsr WriteSec                           * 1. Sektor schreiben
 tst.l d0
 bmi.b QFerr                            * Fehler beim schreiben
 clr.l 0(a1)                            * Media raus 2 Cluster
 addq.l #1, d1                          * 2. Sektor
QF05:                                   * 2. bis x. Sektor
 move.l d1, d0                          * Sektor
 movea.l a1, a0                         * Buffer
 bsr WriteSec                           * Sektor schreiben
 tst.l d0
 bmi.b QFerr                            * Fehler beim schreiben
 addq.l #1, d1                          * nächster Sektor
 dbra d3, QF05
 dbra d2, QF04                          * nächte FAT
 move.l RootFrst(a6), d0
 movea.l a1, a0
 bsr ReadSec
 tst.l d0
 bmi.b QFerr                            * Fehler beim lesen
 move #$2f00, NoAD(a6)                  * /00
 clr.l FrstDIRC(a6)                     * Erster DIR-Cluster = 0 (Root-DIR)
 move.l FATFrst(a6), d0
 move.l d0, FATCurr(a6)                 *
 lea fatbuff(pc), a0
 bsr ReadSec                            * neue FAT laden
 tst.l d0
 bmi.b QFerr                            * Fehler beim lesen
 clr.b FATStat(a4)
 clr.l d0                               * alles OK
 bra.b QFex
QFerr:
 move.l #-1, d0
QFex:
 movem.l (a7)+, d1-d3/a0-a1
 rts




***** DIR Teil *****

ScRD:                                   * ScanRootDIR / d0.w=FileID
 movem.l d1/d3/d6/d7, -(a7)
 move.l #NO_MATCH, d7                   * d7=result
 move.l RtDrSec(a6), d3
 subq.l #1, d3
 move.l RootFrst(a6), d1
 move.l d0, d6                          * FileID sichern
ScRD01:
 move.l d6, d0                          * FileID wieder herstellen
 bsr ScODS                              * ScanOneDirectorySektor
 cmp.l #NO_MATCH, d0
 bne.b ScRDex
 addq.l #1, d1                          * nächster Sektor
 dbra d3, ScRD01
ScRDerr:
 move.l d7, d0
ScRDex:
 movem.l (a7)+, d1/d3/d6/d7
 rts


ScSD:                           * ScanSubDIR / d0.w=FileID, d1.l=Startcluster
 movem.l d1-d7, -(a7)
 move.l d1, d6                          * Startcluster merken
 move.l d0, d5                          * FileID merken
 move.l #NO_MATCH, d7                   * result
ScSD01:
 cmp.l eoClusCh(a6), d6                 * Ende erreicht?
 beq.b ScSDerr
 move.l d6, d0
 bsr GFSOC                              * GetFirstSektorOfCluster
 move.l d0, d4                          * tmpSektor
 clr.l d3
 move.b SPC(a6), d3
 subq.l #1, d3
ScSD02:
 move.l d5, d0
 move.l d4, d1
 bsr ScODS                              * ScanOneDirectorySektor
 cmp.l #NO_MATCH, d0
 bne.b ScSDex
 addq.l #1, d4                          * tmpSektor+1
 dbra d3, ScSD02
 move.l d6, d0                          * tmpCluster
 bsr GNCN                               * GetNextClusterNumber
 cmp.l #-1, d0
 beq.b ScSDerr
 move.l d0, d6
 bra.b ScSD01
ScSDerr:
 move.l d7, d0
ScSDex:
 movem.l (a7)+, d1-d7
 rts


ScODS:                           * ScanOnDirectorySektor d0.w=FileID, d1.l=Sec
 movem.l d1-d7/a0-a3, -(a7)
 move.l d0, d5                          * FileID sichern
 move.l d1, d6                          * Sektor sichern
 bsr FileDsct
 movea.l a0, a2                         * Sichern
 move.l d1, d0
 lea dirbuff(pc), a0
 bsr ReadSec
 lea dirbuff(pc), a0
 movea.l a0, a3                         * Sichern
 clr.l d3                               * Als Zähler
ScODS01:
 move.l #NO_MATCH, d7
 tst.b DIRName(a3)                      * =0 dann DIR Ende
 bne.b ScODS10
 move.l #END_DIR, d7
 bra ScODSex
ScODS10:
 cmp.b #$e5, DIRName(a3)                * Eintrag leer
 beq ScODS90
 cmp.b #$0f, DIRAttr(a3)                * Long Filename
 beq ScODS90
 move.l #8, d0
 movea.l a2, a0                         * FileDesc
 adda.l #FileName, a0
 movea.l a3, a1                         * Dirbuffer
 adda.l #DIRName, a1
 bsr strgcmp                            * Stringvergleich
 tst.l d0
 bne.b ScODS21
 move.l #MATCH_N, d7
ScODS21:
 move.l #3, d0
 movea.l a2, a0
 adda.l #FileExt, a0
 movea.l a3, a1
 adda.l #DIRExt, a1
 bsr strgcmp                            * Stringvergleich
 tst.l d0
 bne.b ScODS20
 add.l #MATCH_E, d7
ScODS20:
 move.b DIRAttr(a3), d0
 btst.b #4, d0
 beq.b ScODS30                          * kein DIR
                                        * DIR Teil
 move DIR1CH(a3), d0                    * tmp
 bsr LowBHigh
 move d0, d4
 swap d4
 move DIR1CL(a3), d0                    * tmp.l LBHW??????
 bsr LowBHigh
 move d0, d4
 cmp.l #FULL_MAT, d7
 bne.b ScODS30
 move.l d4, File1C(a2)
 bra.b ScODSex

ScODS30:
 move DIR1CH(a3), d0                    * tmp.w
 bsr LowBHigh
 move d0, d4
 swap d4
 move DIR1CL(a3), d0                    * tmp.l LBHW?????
 bsr LowBHigh
 move d0, d4
 cmp.l #FULL_MAT, d7                    * stimmt die Datei?
 bne.b ScODS90                          * nö also weiter

 move.l d6, FileDSec(a2)                * File Teil
 move.l d3, d0                          * Zähler
 lsr.l #5, d0                           * / 32
 move.b d0, FileDOff(a2)
 move.l d4, File1C(a2)                  * tmp
 move.l DIRSize(a3), d0
 bsr LBHLW
 move.l d0, FileSize(a2)
 move.b #0, FileAttr(a2)                * 0=Datei
 bra.b ScODSex
ScODS90:
 adda.l #32, a3
 add.l #32, d3
 cmp BPS(a6), d3
 bge.b ScODSerr
 bra ScODS01
ScODSerr:
 move.l #NO_MATCH, d7
ScODSex:
 move.l d7, d0
 movem.l (a7)+, d1-d7/a0-a3
 rts


FileDsct:                       * liefert in A0 den FileDiscriptor Block
                                        * zur FileID in d0.w
 move.l d0, -(a7)
 and.l #$FFFF, d0                       * nur Wort gültig
 mulu #FDOff, d0                        * FileID*FileDiscriptorOffset
 lea filebuff(pc), a0                   *
 adda.l d0, a0                          * + Basis
 move.l (a7)+, d0
 rts


FNE:                            * FileNameEmpty / d0.w=FileID
 movem.l d3/a0-a1, -(a7)
 bsr FileDsct
 movea.l a0, a1                         * Sichern
 adda.l #FileName, a0
 move #8-1, d3                          * 8 Stellen Name
FNE01:
 cmp.b #' ', (a0)+
 bne.b FNEerr
 dbra d3, FNE01
 adda.l #FileExt, a1
 move #3-1, d3                          * 3 Stellen Extension
FNE02:
 cmp.b #' ', (a1)+
 bne.b FNEerr
 dbra d3, FNE02
 clr.l d0                               * ist leer
 bra.b FNEex
FNEerr:
 move.l #1, d0
FNEex:
 movem.l (a7)+, d3/a0-a1
 rts


MFN:                            * MakeFileName / d0.w=FileID, ParsDat=Name.Ext
                                * copiert den Dateiname/ext. in den FileDsc
 movem.l d0/d3/a0-a3, -(a7)
 lea parsdat(pc), a2
 movea.l a2, a1
 adda.l #pqdatn, a1                     * a1 auf Dateiname
 adda.l #pqdate, a2                     * a2 auf Extension
 bsr FileDsct                           * FileDisct in A0
 movea.l a0, a3
 adda.l #FileName, a0
 move #8-1, d3
MFN01:
 move.b #' ', (a0)+                     * Name mit Space füllen
 dbra d3, MFN01
 movea.l a3, a0
 adda.l #FileExt, a0
 move.b #' ', (a0)+                     * Ext mit Space füllen
 move.b #' ', (a0)+
 move.b #' ', (a0)
 movea.l a3, a0
 adda.l #FileName, a0
MFN03:
 move #8-1, d3
MFN04:
 move.b (a1)+, d0
 tst.b d0
 beq.b MFN10
 move.b d0, (a0)+
 dbra d3, MFN04
MFN10:
MFN11:
 movea.l a3, a0
 adda.l #FileExt, a0
 move #3, d3
MFN12:
 move.b (a2)+, d0
 tst.b d0
 beq.b MFNex
 move.b d0, (a0)+
 dbra d3, MFN12
MFNex:
 movem.l (a7)+, d0/d3/a0-a3
 rts


FFD:                            * FillFileDiscriptor
                                * File-ID in d0, Filedaten in ffsec und ffpos
                                * Kopiert die Filedaten vom DIR in FileDsct
 movem.l d1/a0-a3, -(a7)
 move.l ffpos(a4), d1           * gültige Daten?
 bmi FFDerr                     * nein!
 bsr FileDsct                   * FileDiscriptor in A0
 movea.l a0, a3                 * sichern
 lea dirbuff(pc), a1
 adda.l ffpos(a4), a1           * auf akt. Datei
 movea.l a1, a2
 adda.l #FileName, a0
 move #8-1, d3
FFD01:
 move.b #' ', (a0)+                     * Name mit Space füllen
 dbra d3, FFD01
 movea.l a3, a0
 adda.l #FileExt, a0
 move.b #' ', (a0)+                     * Ext mit Space füllen
 move.b #' ', (a0)+
 move.b #' ', (a0)
 movea.l a3, a0
 adda.l #FileName, a0
 adda.l #DIRName, a1
FFD03:
 move #8-1, d3
FFD04:                                  * Name kopieren
 move.b (a1)+, d0
 tst.b d0
 beq.b FFD10
 move.b d0, (a0)+
 dbra d3, FFD04
FFD10:
FFD11:
 movea.l a3, a0
 adda.l #FileExt, a0
 movea.l a2, a1
 adda.l #DIRExt, a1
 move #3, d3
FFD12:                                  * Ext kopieren
 move.b (a1)+, d0
 tst.b d0
 beq.b FFD13
 move.b d0, (a0)+
 dbra d3, FFD12
FFD13:
 move.l ffsec(a4), FileDSec(a3)         * File-DIR-Sektor
 lsr.l #5, d1                           * /32
 move.b d1, FileDOff(a3)                * File-DIR-Offset
 move DIR1CH(a2), d0                    * First-File-Cluster-High
 bsr LowBHigh
 move d0, d1
 swap d1
 move DIR1CL(a2), d0                    * First-File-Cluster-Low
 bsr LowBHigh
 move d0, d1
 move.l d1, File1C(a3)                  * FileFirstCluster
 move.l DIRSize(a2), d0                 * File Size
 bsr LBHLW
 move.l d0, FileSize(a3)
 move.b DIRAttr(a2), FileAttr(a3)       * File Attribute
 clr.l d0
 bra.b FFDex
FFDerr:
 move.l #-1, d0
FFDex:
 movem.l (a7)+, d1/a0-a3
 rts


chdir:                          * zum Verzeichnis wechseln
                                * DIR-Name in parsdat
                                * setzt FrstDIRC und NoAD
 movem.l d2-d3/a0-a2, -(a7)
 bsr FFFD                               * FindFreeFileDiscriptor
 tst.l d0
 bmi cderr                              * kein freier Dateihändel
 move d0, d2                            * sichern
 bsr FileDsct                           * FileDiscriptor Adresse in a0 laden
 lea parsdat(pc), a2
 adda.l #pqdatn, a2                     * a2 auf Quell-Dateiname
 cmp.b #'/', (a2)                       * RootDIR ?
 bne.b cd01                             * nö
 clr.l FrstDIRC(a6)                     * FirstDIRCluster=0
 move #$2f00, NoAD(a6)                  * akt DIRName = "/0"
 bra.b cdok
cd01:
 move d2, d0                            * FileID zurück holen
 bsr MFN                                * MakeFileName
 move d2, d0                            * Vorsichtshalber
 bsr FindName                           * FindName
 cmp.l #FULL_MAT, d0                    * Datei gefunden?
 bne.b cderr1                           * nö
 move.l File1C(a0), d0
 move.l d0, FrstDIRC(a6)
 move #8-1, d3
 movea.l a0, a1
 adda.l #FileName, a1                   * a1 auf FileName im FileDesc
 movea.l a6, a2
 adda.l #NoAD, a2                       * a2 auf akt. DIRname
cd02:
 move.b (a1)+, d0                       * DIRname einlesen
 beq.b cd03                             * falls ne 0
 cmp.b #' ', d0
 beq.b cd03                             * falls Leerzeichen
 move.b d0, (a2)+                       * sonst speichern
 dbra d3, cd02
cd03:
 clr.b (a2)                             * mit 0 abschliessen
cdok:
 move.l FrstDIRC(a6), d0                * 1. DIR-Cluster
 cmp.l #2, d0                           * RootDIR?
 bge.b cd04                             * nö
 move.l RootFrst(a6), d0                * 1. Root-DIR Sektor
 bra.b cd05
cd04:
 bsr GFSOC                              * GetFirstSektorOfCluster
cd05:
 clr.b FileFlag(a0)                     * Dateihändel wieder schliessen
 lea dirbuff(pc), a0
 bsr ReadSec                            * 1. DIR-Sektor einlesen
 tst.l d0
 bmi.b cderr
 move #F_OK, d0
 bra.b cdex
cderr1:
 move.l #11, errnum(a4)
cderr:
 clr.b FileFlag(a0)                     * Dateihändel wieder schliessen
 move #F_ERROR, d0
cdex:
 movem.l (a7)+, d2-d3/a0-a2
 rts


UFE:                            * UpdateFileEntry
                                * d0 = FileID
 movem.l d1/a0-a3, -(a7)
 bsr FileDsct                           * FileDiscriptor in a0
 movea.l a0, a3                         * sichern
 lea dirbuff(pc), a2
 movea.l a2, a0
 move.l FileDSec(a3), d0                * DIR-Sektor nach d0
 bsr ReadSec                            * DIR-Sektor lesen
 tst.l d0
 bmi UFEerr                             * Lesefehler
 clr.l d0
 move.b FileDOff(a3), d0
 asl.l #5, d0                           * *32
 adda.l d0, a2                          * a2 auf akt. DIR-Eintrag
 movea.l a2, a1
 adda.l #DIRName, a1
 movea.l a3, a0
 adda.l #FileName, a0
 move.l #8, d0
 bsr strgcopy                           * NAME kopieren
 movea.l a2, a1
 adda.l #DIRExt, a1
 movea.l a3, a0
 adda.l #FileExt, a0
 move.l #3, d0
 bsr strgcopy                           * EXT kopieren
 move.b FileAttr(a3), d0
 move.b d0, DIRAttr(a2)                 * Attribute kopieren
 clr.b DIREZt(a2)                       * Erstellungs 10tel löschen
                                        * Erstellungszeit bleibt!
 movea.l a3, a0
 adda.l #Fiob, a0                       * Fiob als Puffer für Uhr
 bsr getuhr
 movea.l a3, a0
 adda.l #Fiob, a0                       * a0 auf GP-Uhrzeit
 clr.l d1
 move.b 4(a0), d0                       * Jahr
 bsr bcdtobin
 add.b #20, d0                          * +20 da ab 1980!
 ror #7, d0
 and #$fe00, d0                         * obersten 7 Bits
 or d0, d1                              * in d1 übertragen
 move.b 3(a0), d0                       * Monat
 bsr bcdtobin
 asl #5, d0
 and #$01e0, d0                         * 4 Bits in der Mitte
 or d0, d1                              * ab nach d1
 move.b 2(a0), d0                       * Tag
 bsr bcdtobin
 and #$001f, d0                         * die untersten 5 Bits
 or d0, d1                              * nach d1
 swap d1                                * nu die andere Hälfte
 move.b (a0), d0                        * Stunde
 bsr bcdtobin
 ror #5, d0
 and #$f800, d0                         * obersten 5 Bits
 or d0, d1                              * nach d1
 move.b 1(a0), d0                       * Minute
 bsr bcdtobin
 asl #5, d0
 and #$07e0, d0                         * 6 Bits in der Mitte
 or d0, d1                              * nach d1
 move.b 6(a0), d0                       * Sekunde
 bsr bcdtobin
 asr #1, d0                             * /2
 and #$1f, d0                           * untersten 5 Bits
 or d0, d1                              * nach d1
 move.l d1, d0                          * zurück nach d0
 bsr LBHLW                              * LowByteHighLangWort
 move.l d0, DIRLCh(a2)                  * im DIR speichern
 clr DIR1CH(a2)                         * HighCluster = 0 FAT16!
 move.l File1C(a3), d0                  * LowCluster
 bsr LowBHigh                           * wieder nach IBM :-(
 move d0, DIR1Cl(a2)                    * und speichern
 move.l FileSize(a3), d0                * Datei Grösse
 bsr LBHLW                              * nach IBM
 move.l d0, DIRSize(a2)                 * speichern
 move.l FileDSec(a3), d0
 lea dirbuff(pc), a0
 bsr WriteSec
 tst.l d0
 beq.b UFEex
UFEerr:
 moveq.l #-1, d0
UFEex:
 movem.l (a7)+, d1/a0-a3
 rts


mkdir:                          * Verzeichnis erstellen
                                * DIR-Name in parsdat
 movem.l d2-d3/a0-a3, -(a7)
 bsr FFFD                               * FindFreeFileDiscriptor
 tst.l d0
 bmi mkdirer1                           * kein freier Dateihändel
 move.l d0, d2                          * sichern
 bsr MFN                                * MakeFileName
 bsr FindName                           * Name schon vorhanden?
 cmp.l #FULL_MAT, d0
 bne.b mkdir00
 move.l #13, errnum(a4)
 bra mkdirerr                           * DIR ist vorhanden, Fehler
mkdir00:
 move.l d2, d0                          * FileID zurück
 bsr FileDsct                           * FileDiscriptor Adresse in a0 laden
 movea.l a0, a1                         * sichern
 move.b #$10, FileAttr(a1)              * DIR Attribut setzen
 move.l d2, d0                          * FileID zurück
 bsr MNFE                               * neuer DIR-Eintrag
 tst.l d0                               * alles OK?
 bmi mkdirerr                           * nee

 tst.b quiet(a4)                        * Ausgabe unterdrücken?
 bne.b mkdir03                          * ja
 lea txtcrlf(pc), a0                    * CRLF vorweg
 bsr writetxt
 lea txtverz(pc), a0
 bsr writetxt
 move.l d2, d0
 bsr NameOut
 lea txterst(pc), a0
 bsr writetxt

mkdir03:
 move.l File1C(a1), d0                  * der 1te Cluster
 bsr GFSOC                              * GetFirstSektorOfCluster
 move.l d0, FileDSec(a1)                * 1. Sektor speichern
 move.l d0, d1                          * sichern
 lea dirbuff(pc), a0
 move #512-1, d3                        * BPS-1
mkdir01:
 clr.b (a0)+                            * Dirbuffer löschen
 dbra d3, mkdir01
 clr.l d3
 move.b SPC(a6), d3                     * SektorenProCluster
 subq.l #1, d3                          * -1 als Zähler
mkdir02:
 lea dirbuff(pc), a0
 move.l d1, d0                          * Sektor zurück
 bsr WriteSec                           * Sektor schreiben
 tst.l d0
 bmi mkdirerr                           * Schreibfehler
 addq.l #1, d1                          * nächster Sektor
 dbra d3, mkdir02

 lea parsdat(pc), a2
 movea.l a2, a3
 adda.l #pqdatn, a2                     * a2 auf Quell-Dateiname
 adda.l #pqdate, a3                     * a3 auf Quell-Extension
 move.b #'.', (a2)
 clr.b 1(a2)                            * Dateiname = .0
 clr.b (a3)                             * Extension = 0
 move d2, d0                            * FileID zurück
 clr.b FileDOff(a1)
 bsr MFN                                * MakeFileName
 move d2, d0                            * FileID zurück
 bsr UFE                                * UpdateFileEntry
 tst.l d0
 bmi.b mkdirerr

 move.b #'.', 1(a2)
 clr.b 2(a2)                            * Dateiname auf ..0
 move.b #1, FileDOff(a1)
 move.l d2, d0                          * FileID zurück
 bsr MFN
 move.l d2, d0                          * FileID zurück
 move.l FrstDIRC(a6), File1C(a1)        * UpperDIR Cluster
 bsr UFE                                * UpdateFileEntry
 tst.l d0
 bmi.b mkdirerr

 bsr FFAT
 tst.l d0
 bmi mkdirerr                           * Schreibfehler
 clr.l d0                               * alles OK
 bra.b mkdirex

mkdirer1:
 move.l #-1, d0
 bra.b mkdirex1
mkdirerr:
 move.l #-1, d0
mkdirex:
 clr.b FileFlag(a1)                     * File Händel wieder freigeben
mkdirex1:
 movem.l (a7)+, d2-d3/a0-a3
 rts



SRD:                                    * SearchRootDIR d0=FileID
                                        * sucht nach freien DIR-Eintrag
 movem.l d1/d3/d6/d7, -(a7)
 move.l RtDrSec(a6), d3
 subq.l #1, d3
 move.l RootFrst(a6), d1
 move.l d0, d6                          * FileID sichern
SRD01:
 move.l d6, d0                          * FileID wieder herstellen
 bsr SODS                               * SearchOneDirectorySektor
 tst.l d0
 bne.b SRDex
 addq.l #1, d1                          * nächster Sektor
 dbra d3, SRD01
SRDerr:
 clr.l d0                               * nichts gefunden
SRDex:
 movem.l (a7)+, d1/d3/d6/d7
 rts


SSD:                           * SearchSubDIR / d0.w=FileID, d1.l=Startcluster
 movem.l d1-d7, -(a7)
 move.l d1, d6                          * Startcluster merken
 move.l d0, d5                          * FileID merken
SSD01:
 cmp.l eoClusCh(a6), d6                 * Ende erreicht?
 bge.b SSDerr
 move.l d6, d0
 bsr GFSOC                              * GetFirstSektorOfCluster
 move.l d0, d4                          * tmpSektor
 clr.l d3
 move.b SPC(a6), d3
 subq.l #1, d3
SSD02:
 move.l d5, d0
 move.l d4, d1
 bsr SODS                               * SearchOneDirectorySektor
 tst.l d0                               * was gefunden?
 bne.b SSDex                            * jo
 addq.l #1, d4                          * tmpSektor+1
 dbra d3, SSD02
 move.l d6, d0                          * tmpCluster
 bsr GNCN                               * GetNextClusterNumber
 cmp.l #-1, d0
 beq.b SSDerr
 move.l d0, d6
 bra.b SSD01
SSDerr:
 clr.l d0                               * nichts gefunden
SSDex:
 movem.l (a7)+, d1-d7
 rts


SODS:                           * SearchOneDirectorySektor
                                * d0.w=FileID, d1.l=Sektor
 movem.l d1/d3/a0-a1, -(a7)
 bsr FileDsct
 movea.l a0, a1
 lea dirbuff(pc), a0
 move.l d1, d0                          * Sektor
 bsr ReadSec
 tst.l d0
 bne.b SODSerr                          * konnte nicht gelesen werden
 lea dirbuff(pc), a0
 clr.l d3                               * als Zähler
SODS01:
 move.b 0(a0,d3.w), d0
 tst.b d0
 beq.b SODS02
 cmp.b #$e5, d0
 beq.b SODS02
 add.l #32, d3
 cmp.l #512, d3                         * Ende erreicht?
 bge.b SODSerr                          * ja, dann Fehler
 bra.b SODS01
SODS02:
 move.l #1, d0
 move.l d1, FileDSec(a1)                * Sektor speichern
 asr.l #5, d3                           * DIR-Offset / 32
 move.b d3, FileDOff(a1)                * und speichern
 bra.b SODSex
SODSerr:
 clr.l d0
SODSex:
 movem.l (a7)+, d1/d3/a0-a1
 rts


MNFE:                           * MakeNewFileEntry d0.w=FileID
 movem.l d1-d3/d6/a0-a2, -(a7)
 move.l d0, d6                          * FileID sichern
 bsr FileDsct                           * a0=FileDiscriptor
 move.l d6, d0                          * FileID zurück
 movea.l a0, a2                         * sichern
 move.l FrstDIRC(a6), d2
 cmp.l #2, d2                           * 1. DIR-Cluster < 2?
 bge.b MNFE01                           * nö
 bsr SRD                                * sonst SearchRootDIR
 bra.b MNFE02
MNFE01:
 move.l d2, d1                          * StartCluster
 bsr SSD                                * SearchSubDir
MNFE02:
 tst.l d0
 bne MNFE10                             * hat was gefunden
 cmp.l #2, d2                           * wars Root-DIR?
 bge.b MNFE02a                          * nö
 move.l #12, errnum(a4)
 bra MNFEerr                            * sonst Fehler!
MNFE02a:
 move.l d2, d0                          * FirstDIRC
MNFE03:
 move.l d0, d2                          * akt. Cluster merken
 bsr GNCN                               * GetNextClusterNumber
 cmp.l #-1, d0
 beq MNFEerr
 cmp.l eoClusCh(a6), d0                 * EndOfClusterChain?
 blt.b MNFE03                           * nö, dann nochmal
 move.l d2, d0                          * letzten Cluster zurück
 bsr AllClus                            * Cluster fürs DIR hohlen
 cmp.l #-1, d0                          * ham wir noch welche?
 beq MNFEerr                            * neee
 move.l d0, d2                          * Cluster sichern
 bsr FFAT
 move #512-1, d3                        * BPS -1, als Zähler
 lea dirbuff(pc), a0
MNFE04:
 clr.b (a0)+                            * Dirbuffer löschen
 dbra d3, MNFE04
 move.l d2, d0                          * Cluster zurück
 bsr GFSOC                              * GetFirstSektorOfCluster
 move.l d0, d1                          * Sektor sichern
 clr.l d3
 move.b SPC(a6), d3                     * SektorenProCluster
 subq.l #1, d3                          * -1 als Zähler
MNFE05:
 lea dirbuff(pc), a0
 move.l d1, d0
 bsr WriteSec                           * Sektoren mit 0 (NULL) füllen
 tst.l d0                               * Fehler beim schreiben?
 bne.b MNFEerr                          * JA!
 addq.l #1, d1                          * nächster Sektor
 dbra d3, MNFE05
 move.l d2, d0                          * Cluster wiederhohlen
 bsr GFSOC
 move.l d0, FileDSec(a2)                * DIR-Sektor speichern
 clr.b FileDOff(a2)                     * DIR-Offset = 0
MNFE10:
 clr.l d0
 bsr AllClus                            * Cluster fürs File hohlen
 cmp.l #-1, d0
 beq.b MNFEerr                          * keine freien Cluster!
 and.l #$FFFF, d0                       * auf LangWort
 move.l d0, File1C(a2)                  * FileFirstCluster sichern
 clr.l FileSize(a2)                     * FileSize=0
 bsr FFAT
 move.l d6, d0                          * FileID zurück
 bsr UFE                                * UpdateFileEntry
 clr.l d0                               * alles OK
 bra MNFEex
MNFEerr:
 move.l #-1, d0
MNFEex:
 movem.l (a7)+, d1-d3/d6/a0-a2
 rts


FindFrst:                       * Sucht 1. Datei
 movem.l d1/a0, -(a7)
 move.l #-32, ffpos(a4)                 * Dateiposition löschen
 clr.l ffsec(a4)                        * DIR-Sektor löschen
 clr.l ffsecc(a4)                       * DIR-Sektor-Count löschen
 clr.l ffclus(a4)                       * DIR-Cluster löschen
 move.l FrstDIRC(a6), d0
 cmp.l #2, d0
 bge.b FF01
 move.l RootFrst(a6), d0                * Root-DIR Sektor laden
 move.l d0, ffsec(a4)
 bra.b FF02
FF01:
 move.l d0, ffclus(a4)
 bsr GFSOC                              * Sub-DIR Sektor laden
 move.l d0, ffsec(a4)
FF02:
 lea dirbuff(pc), a0
 bsr ReadSec
 tst.l d0
 bmi.b FFerr                            * Lesefehler aufgetreten
 bsr FindNext                           * 1. Datei suchen
 tst.l d0
 bmi.b FFerr
 clr.l d0
 bra.b FFex
FFerr:
 move.l #-1, d0
FFex:
 movem.l (a7)+, d1/a0
 rts

FindNext:                       * nächsten DIR-Eintrag suchen
 movem.l d1-d4/a0-a1, -(a7)
 cmp.l #2, FrstDIRC(a6)
 bge.b FNX10
FNX01:                                  * Root-DIR Teil
 move.l ffsecc(a4), d3                  * Sektor Zähler
 move.l ffsec(a4), d2                   * akt. RootDIR-Sektor
 move.l ffpos(a4), d1                   * akt. Position im Sektor
FNX02:
 add.l #32, d1
 cmp.l #512, d1                         * Sektor durch?
 blt.b FNX03                            * nein
 clr.l d1                               * Position auf Null
 addq.l #1, d2                          * nächster Sektor
 addq.l #1, d3
 cmp.l RtDrSec(a6), d3                  * Ende des DIRs?
 bge FNXnf                              * DIR ist durch, nichts gefunden
 move.l d2, d0
 lea dirbuff(pc), a0
 bsr ReadSec                            * neuen Sektor lesen
 tst.l d0
 bmi FNXerr                             * Lesefehler
FNX03:
 lea dirbuff(pc), a1
 adda.l d1, a1
 tst.b (a1)                             * letzter Eintrag?
 beq FNXnf                              * Ja
 cmp.b #$e5, (a1)                       * leerer Eintrag
 beq.b FNX02                            * ja, dann nochmal
 cmp.b #$0f, DirAttr(a1)                * langer Dateiname?
 beq.b FNX02                            * ja, dann weiter
 bsr dircmp
 tst.l d0
 bmi.b FNX02                            * nichts gefunden, nochmal
 move.l d1, ffpos(a4)
 move.l d2, ffsec(a4)
 move.l d3, ffsecc(a4)
 clr.l d0
 bra FNXex

FNX10:                                  * Sub-DIR Teil
 move.l ffsecc(a4), d4                  * Sektorzähler
 move.l ffclus(a4), d3                  * akt. SubDIR-Cluster
 move.l ffsec(a4), d2                   * akt. SubDIR-Sektor
 move.l ffpos(a4), d1                   * akt. Position im Sektor
FNX11:
 add.l #32, d1                          * nächster Eintrag
 cmp.l #512, d1                         * Sektor durch?
 blt.b FNX15                            * nein
 clr.l d1                               * Position auf Null
 addq.l #1, d2                          * Sektor + 1
 addq.l #1, d4                          * Sektorzähler + 1
 cmp.b SPC(a6), d4                      * letzter Sektor im Cluster?
 blt.b FNX14                            * noch ein Sektor im Cluster
 clr.l d4                               * Sektorzähler auf Null
 move.l d3, d0                          * akt. Cluster
 bsr GNCN                               * GetNextClusterNumber
 cmp.l eoClusCh(a6), d0                 * Ende des DIRs?
 bge.b FNXnf                            * Ja
 move.l d0, d3                          * neuer Cluster
 bsr GFSOC                              * GetFirstSektorOfCluster
 move.l d0, d2                          * neuer Sektor
FNX14:
 lea dirbuff(pc), a0
 move.l d2, d0
 bsr ReadSec
 tst.l d0
 bmi.b FNXerr                           * Lesefehler
FNX15:
 lea dirbuff(pc), a1
 adda.l d1, a1
 tst.b (a1)                             * letzter Eintrag?
 beq.b FNXnf                            * Ja
 cmp.b #$e5, (a1)                       * leerer Eintrag
 beq.b FNX11                            * ja, dann nochmal
 cmp.b #$0f, DirAttr(a1)                * langer Dateiname?
 beq.b FNX11                            * ja, dann weiter
 bsr dircmp
 tst.l d0
 bmi.b FNX11                            * nichts gefunden, nochmal
 move.l d1, ffpos(a4)
 move.l d2, ffsec(a4)
 move.l d3, ffclus(a4)
 move.l d4, ffsecc(a4)
 clr.l d0
 bra.b FNXex
FNXnf:
 move.l #-1, ffpos(a4)
 clr.l d0
 bra.b FNXex
FNXerr:
 move.l #-1, ffpos(a4)
 move.l #-1, d0
FNXex:
 movem.l (a7)+, d1-d4/a0-a1
 rts


dircmp:
 movem.l d3/a0-a2, -(a7)
 movea.l a1, a2                         * sichern
 lea parsdat(pc), a0
 move.l pflag(a0), d3
 btst.l #pfqdatn, d3
 beq dircmp30                           * kein Name, auch gut
 adda.l #pqdatn, a0                     * a0 auf Name
 move #8-1, d3
dircmp01:
 move.b (a0)+, d0
 beq.b dircmp05                         * Name stimmt (die Länge auch?)
 cmp.b #'*', d0
 beq.b dircmp10                         * Name stimmt
 cmp.b #'?', d0
 bne.b dircmp02
 addq.l #1, a1
 bra.b dircmp03
dircmp02:
 cmp.b (a1)+, d0
 bne.b dircmp20                         * Name stimmt nicht :-(
dircmp03:
 dbra d3, dircmp01
 bra.b dircmp10                         * weiter mit Ext.
dircmp05:
 move.b (a1), d0
 beq.b dircmp10                         * Länge stimmt auch :-D
 cmp.b #' ', d0
 beq.b dircmp10                         * ist auch gut
 bra dircmp20                           * ansonsten nicht gut

dircmp10:                               * Vergleich der Ext
 addq.l #8, a2
 lea parsdat(pc), a0
 move.l pflag(a0), d3
 btst.l #pfqdate, d3                    * Extension da?
 beq.b dircmp30                         * nö
 adda.l #pqdate, a0                     * a0 auf Dateiextension
 move #3-1, d3
dircmp11:
 move.b (a0)+, d0
 beq.b dircmp15                         * Ext stimmt (Länge auch?)
 cmp.b #'*', d0
 beq.b dircmp30                         * Ext stimmt auch
 cmp.b #'?', d0
 bne.b dircmp12
 addq.l #1, a2
 bra.b dircmp13
dircmp12:
 cmp.b (a2)+, d0
 bne.b dircmp20                         * Ext stimmt nicht :-(
dircmp13:
 dbra d3, dircmp11
 bra.b dircmp30
dircmp15:
 move.b (a2), d0
 beq.b dircmp30                         * Länge stimmt auch
 cmp.b #' ', d0
 beq.b dircmp30                         * genauso gut

dircmp20:
 move.l #-1, d0
 bra.b dircmpex
dircmp30:
 clr.l d0
dircmpex:
 movem.l (a7)+, d3/a0-a2
 rts




***** Allgemeine Unterprogramme *****

csts:                           * Wartet auf Tastendruck
 movem.l d0, -(a7)
 bsr key
 movem.l (a7)+, d0
 rts


key:                            * Wartet bis Taste gedrückt
 movem.l d1-d7/a0-a6, -(a7)     * liefert Taste in d0 zurück
key01:
 move #13, d7
 trap #1                                * CSTS
 tst.b d0
 beq.b key01
 move #12, d7
 trap #1                                * CI zum Status rücksetzen
 movem.l (a7)+, d1-d7/a0-a6
 rts


ci:                             * Zeichen von Tastatur einlesen
 movem.l d1-d7/a0-a6, -(a7)
 move #12, d7
 trap #1
 movem.l (a7)+, d1-d7/a0-a6
 rts


cls:
 movem.l d0-d7/a0-a6, -(a7)
 move #20, d7
 trap #1
 movem.l (a7)+, d0-d7/a0-a6
 rts


co2:
 movem.l d0-d7/a0-a6, -(a7)
 move #33, d7
 trap #1
 movem.l (a7)+, d0-d7/a0-a6
 rts


writetxt:                       * Textausgabe bis $0
 movem.l d0-d7/a0-a6, -(a7)
wrtxt01:
 move.b (a0)+, d0
 beq.b wrtxtex
 move #33, d7                           * CO2
 trap #1
 bra.s wrtxt01
wrtxtex:
 movem.l (a7)+, d0-d7/a0-a6
 rts

tron:
 move.l #1, trace(a4)
 rts

troff:
 clr.l trace(a4)
 rts

trout:
 tst.l trace(a4)
 beq.b troex
 bsr regout
 bsr csts
troex:
 rts

regout:
 movem.l d0-d7/a0-a6, -(a7)
 move.l d0, -(a7)
 move #10, d0
 bsr co2
 move #13, d0
 bsr co2
 move.l (a7)+, d0
 bsr printl
 move #' ', d0
 bsr co2
 move.l d1, d0
 bsr printl
 move #' ', d0
 bsr co2
 move.l d2, d0
 bsr printl
 move #' ', d0
 bsr co2
 move.l d3, d0
 bsr printl
 move #' ', d0
 bsr co2
 move.l d4, d0
 bsr printl
 move #' ', d0
 bsr co2
 move.l d5, d0
 bsr printl
 move #' ', d0
 bsr co2
 move.l d6, d0
 bsr printl
 move #' ', d0
 bsr co2
 move.l d7, d0
 bsr printl
 move #13, d0
 bsr co2
 move #10, d0
 bsr co2
 move.l a0, d0
 bsr printl
 move #' ', d0
 bsr co2
 move.l a1, d0
 bsr printl
 move #' ', d0
 bsr co2
 move.l a2, d0
 bsr printl
 move #' ', d0
 bsr co2
 move.l a3, d0
 bsr printl
 move #' ', d0
 bsr co2
 move.l a4, d0
 bsr printl
 move #' ', d0
 bsr co2
 move.l a5, d0
 bsr printl
 move #' ', d0
 bsr co2
 move.l a6, d0
 bsr printl
 move #' ', d0
 bsr co2
 move.l a7, d0
 bsr printl
 move #13, d0
 bsr co2
 move #10, d0
 bsr co2
 movem.l (a7)+, d0-d7/a0-a6
 rts


printl:
 movem.l d0-d7/a0-a6, -(a7)
 lea buffer(pc), a0
 move #44, d7                           * PRINT8X
 trap #1
 lea buffer(pc), a0
 bsr writetxt
 movem.l (a7)+, d0-d7/a0-a6
 rts


print8d:
 movem.l d0-d7/a0-a6, -(a7)
 lea buffer(pc), a0
 move #70, d7                           * PRINT8D
 trap #1
 lea buffer(pc), a1
 move.l a1, d1
 adda.l #15, a1
 addq.l #1, a0
 move.b -(a0), -(a1)                    * die Endnull
 move #14-1, d3                         * 13 weitere Bytes
 clr d2
prt8d01:
 addq #1, d2
 subq #1, d3
 move.b -(a0), -(a1)
 cmpa.l d1, a0
 beq.b prt8d02
 cmp #3, d2
 bne.b prt8d01
 clr d2
 subq #1, d3
 move.b #'.', -(a1)
 bra.b prt8d01
prt8d02:
 move.b #' ', -(a1)
 dbra d3, prt8d02

 lea buffer(pc), a0
 bsr writetxt
 movem.l (a7)+, d0-d7/a0-a6
 rts

print4d:
 movem.l d0-d7/a0-a6, -(a7)
 lea buffer(pc), a0
 move.l #'    ', (a0)
 move #46, d7                           * PRINT4D
 trap #1
 move.b #' ', (a0)                      * Endnull löschen
 lea buffer(pc), a0
 clr.b 4(a0)                            * neue Endnull
 bsr writetxt
 movem.l (a7)+, d0-d7/a0-a6
 rts

print2d:
 movem.l d0-d7/a0-a6, -(a7)
 lea buffer(pc), a0
 and #$7f, d0                           * nur noch 7 Bit (0-99)
 move #46, d7                           * PRINT4D
 trap #1
 lea buffer(pc), a1
 addq.l #2, a1
 move.l a1, d1
 cmpa.l d1, a0
 beq.b prt2d02
 move.b (a0), (a1)
 move.b -(a0), -(a1)
 move.b #' ', -(a1)
prt2d02:
 lea buffer(pc), a0
 bsr writetxt
 movem.l (a7)+, d0-d7/a0-a6
 rts


print2d0:
 movem.l d0-d7/a0-a6, -(a7)
 lea buffer(pc), a0
 and #$7f, d0                           * nur noch 7 Bit (0-99)
 move #46, d7                           * PRINT4D
 trap #1
 lea buffer(pc), a1
 addq.l #2, a1
 move.l a1, d1
 cmpa.l d1, a0
 beq.b prt2d002
 move.b (a0), (a1)
 move.b -(a0), -(a1)
 move.b #'0', -(a1)
prt2d002:
 lea buffer(pc), a0
 bsr writetxt
 movem.l (a7)+, d0-d7/a0-a6
 rts


wert:
 movem.l d1-d7/a1-a6, -(a7)
 move.l a0, -(a7)                       * A0 auf den Stack
 move #29, d7
 trap #1
 bcs.s werterr
 addq.l #4, a7                          * A0 nicht zurück, Stack aufräumen
 movem.l (a7)+, d1-d7/a1-a6
 rts
werterr:
 moveq.l #-1, d0
 movea.l (a7)+, a0                      * A0 zurück vom Stack
 movem.l (a7)+, d1-d7/a1-a6
 rts
 
 

getuhr:
 movem.l d0-d7/a0-a6, -(a7)
 move #65, d7
 trap #6                                * JADOS Uhr da auch virtuelle Uhr!!!
 movem.l (a7)+, d0-d7/a0-a6
 rts


delay500:
 movem.l d0-d7/a0-a6, -(a7)
 move #50, d0
 move #35, d7
 trap #1
 movem.l (a7)+, d0-d7/a0-a6
 rts


strgcopy:                       * Kopiert D0.l Bytes von (a0) nach (a1)
 movem.l a0-a1, -(a7)
 subq.l #1, d0
sc00:
 move.b (a0)+, (a1)+
 subq.l #1, d0
 bpl.b sc00                             * dbra geht nur auf Wort!!!
 movem.l (a7)+, a0-a1
 rts


strgcmp:                        * Vergleicht d0.l Bytes zwischen (a0) und (a1)
 movem.l a0-a1, -(a7)
 subq.l #1, d0
scmp01:
 cmpm.b (a0)+, (a1)+
 bne.b scmperr
 subq.l #1, d0
 bpl.b scmp01                           * dbra geht nur bis Wort!!!
 clr.l d0                               * d0=0 Strings sind gleich
 bra.b scmpex
scmperr:
 move.l #1, d0                          * d0=1 Strings sind nicht gleich
scmpex:
 movem.l (a7)+, a0-a1
 rts


toupper:                        * Wandelt den Buchstabe in d0 zu Großbuchstabe
 cmp.b #'a', d0
 blt.b tupex
 cmp.b #'z', d0
 bgt.b tupex                            * nichts umzuwandeln
 sub.b #$20, d0
tupex:
 rts


bcdtobin:                       * wandelt 2 BCD Ziffern in d0.b nach binär
 move.l d1, -(a7)
 clr.l d1
 move.b d0, d1
 asr.b #4, d1                           * oberes Nibbel
 and.b #$F, d1
 mulu #10, d1                           * *10
 and.b #$f, d0                          * unteres Nibbel
 add.b d1, d0                           * addiert
 move.l (a7)+, d1
 rts


JNA:                            * Abfrage Ja/Nein/Alle a0 = Text
                                * setzt JNAFlag Flag, D0=-1 bei CTRL-C
 movem.l a0, -(a7)
 clr.b JNAFlag(a4)
 bsr writetxt
 lea txtjna(pc), a0
 bsr writetxt
 bsr ci
 cmp.b #$03, d0                         * CTRL-C
 bne.b JNA00
 move.l #-1, d0
 bra.b JNAex1
JNA00:
 bsr toupper
 cmp.b #'A', d0                         * Alle
 bne.b JNA01
 move.b #2, JNAFlag(a4)
 bra.b JNAex
JNA01:
 cmp.b #'J', d0                         * Ja
 bne.b JNAex
 move.b #1, JNAFlag(a4)
JNAex:
 bsr co2                                * Eingabe ausgeben
 clr.l d0
JNAex1:
 movem.l (a7)+, a0
 rts


JN:                             * Abfrage Ja/Nein a0 = Text
                                * setzt JNAFlag D0=-1 bei CTRL-C
 move.l a0, -(a7)
 clr.b JNAFlag(a4)                       * Nein und der Rest
 bsr writetxt
 lea txtjn(pc), a0
 bsr writetxt
 bsr ci
 cmp.b #$03, d0                         * CTRL-C
 bne.b JN01
 move.l #-1, d0
 bra.b JNex1
JN01:
 bsr toupper
 cmp.b #'J', d0                         * Ja
 bne.b JNex
 move.b #1, JNAFlag(a4)
JNex:
 bsr co2                                * Eingabe ausgeben
 clr.l d0
JNex1:
 movea.l (a7)+, a0
 rts


NameOut:                        * Gibt Name.Ext von FileDsct aus
                                * d0 = FileID
 movem.l d0/d3/a0-a2, -(a7)
 bsr FileDsct
 movea.l a0, a1
 lea buffer(pc), a2
 adda.l #FileName, a0
 move #8-1, d3
NO01:
 move.b (a0)+, d0
 cmp.b #' ', d0
 beq.b NO02                             * Ende vom Name
 move.b d0, (a2)+                       * in Buffer
 dbra d3, NO01
NO02:
 move.b #'.', (a2)+                     * der Punkt
 adda.l #FileExt, a1
 move #3-1, d3
NO03:
 move.b (a1)+, d0
 cmp.b #' ', d0
 beq.b NO04
 move.b d0, (a2)+
 dbra d3, NO03
NO04:
 move.b #' ', (a2)+                     * ein Leerzeichen
 clr.b (a2)                             * und ne Null
 lea buffer(pc), a0
 bsr writetxt
 movem.l (a7)+, d0/d3/a0-a2
 rts


trap10:
 movem.l d1-d7/a1-a6, -(a7)             * d0/a0 werden NICHT gesichert
 cmp #trapanz, d7
 bge.b trap10ex                         * Fehler, ungültige Trapnummer
 lea allgm(pc), a4                      * a4 wiederherstellen
 clr.l errnum(a4)                       * Fehlernummer löschen
 cmp.b #$a0, msbyte(a4)                 * Master?
 bne.b trap10a
 bsr SetMaster
 bra.b trap10b
trap10a:
 bsr SetSlave
trap10b:
 lea traptab(pc), a2
 asl #2, d7                             * *4 für Langwort
 adda.l 0(a2, d7.w), a2
 jsr (a2)
trap10ex:
 movem.l (a7)+, d1-d7/a1-a6
 rte




***** JADOS Aufrufe/Prozeduren *****

jclrfcb:                        * löscht den FileControlBlock
 movem.l d3/a0, -(a7)
 lea jfcb(pc), a0
 move.l #48-1, d3
jcf01:
 clr.b (a0)+
 dbra d3, jcf01
 movem.l (a7)+, d3/a0
 rts

jfinfo:                         * JADOS File Info
 movem.l d4-d7/a1-a6, -(a7)
 lea jfcb(pc), a1
 move #71, d7
 trap #6
 movem.l (a7)+, d4-d7/a1-a6
 rts

jfillfcb:                       * Dateiname.Ext0 in (a0)
 movem.l d1-d7/a0-a6, -(a7)
 lea jfcb(pc), a1
 move #18, d7
 trap #6
 movem.l (a7)+, d1-d7/a0-a6
 rts

jfload:                         * Lädt eine Datei nach (a0)
 movem.l d1-d7/a0-a6, -(a7)
 lea jfcb(pc), a1
 move #44, d7
 trap #6
 and.l #$ff, d0                         * auf Langwort
 tst.b d0
 beq.b jfldex
 cmp.b #2, d0                           * Datei da?
 bne.b jfld01
 move.l #-1, d0
 move.l #16, errnum(a4)
 bra.b jfldex
jfld01:
 cmp.b #99, d0                          * genug Speicher?
 bne.b jfld02
 move.l #-1, d0
 move.l #19, errnum(a4)
jfld02:
 move.l #-1, d0
 move.l #20, errnum(a4)
jfldex:
 movem.l (a7)+, d1-d7/a0-a6
 rts

jfsave:                         * Speichert die Datei in (a0)
 movem.l d1-d7/a0-a6, -(a7)
 lea jfcb(pc), a1
 clr.l d1
 move JDatL(a1), d1                     * Dateilänge nach d1
 subq #1, d1                            * -1
 move #45, d7
 trap #6
 and.l #$ff, d0                         * auf Langwort
 tst.b d0
 beq.b jfsvex
 cmp.b #5, d0                           * Disk voll?
 bne.b jfsv01
 move.l #-1, d0
 move.l #21, errnum(a4)
 bra.b jfsvex
jfsv01:
 cmp.b #6, d0                           * DIR voll?
 bne.b jfsv02
 move.l #-1, d0
 move.l #22, errnum(a4)
 bra.b jfsvex
jfsv02:
 move.l #-1, d0
 move.l #20, errnum(a4)
jfsvex:
 movem.l (a7)+, d1-d7/a0-a6
 rts

jmotoff:                        * Schaltet den Diskettenmotor aus
 movem.l d0-d7/a0-a6, -(a7)
 move #5, d7
 trap #6
 movem.l (a7)+, d0-d7/a0-a6
 rts

jusradr:                        * Liefert die Adresse des Userbereichs in A0
 movem.l d0-d7/a1-a6, -(a7)
 move #58, d7
 trap #6
 movem.l (a7)+, d0-d7/a1-a6
 rts

jconvlw:                        * Convertiert die LW-Bezeichnug nach Binär
                                * d0.b = 0-4/A-Z -> d0.b = 0-4/5-30
 and.l #$ff, d0                 * auf Langwort
 cmp.b #$30, d0
 blt.b jclwerr
 cmp.b #$34, d0
 bgt.b jclw01
 sub.b #$30, d0
 bra.b jclwex
jclw01:
 cmp.b #$41, d0
 blt.b jclwerr
 cmp.b #$5a, d0
 bgt.b jclwerr
 sub.b #$3c, d0
 bra.b jclwex
jclwerr:
 move.l #-1, d0
 move.l #23, errnum(a4)
jclwex:
 rts



JMDL:                           * JadosMakeDirList legt die Liste der
                                * Jados Datein in jdirbuf, Anzahl in d0
 movem.l d1-d7/a0-a6, -(a7)
 lea parsdat(pc), a0
 movea.l a0, a2
 lea buffer(pc), a1
 adda.l #pqlw, a0                       * Quell Laufwerk
 move.b (a0), (a1)+
 move.b #':', (a1)+                     * der Doppelpunkt
 movea.l a2, a0
 adda.l #pqdatn, a0                     * Quell Dateiname
 move #8-1, d3
JMDL01:
 move.b (a0)+, d0                       * Dateiname
 tst.b d0                               * zu Ende?
 beq.b JMDL02                           * jo
 cmp.b #' ', d0                         * Space auch Ende
 beq.b JMDL02
 move.b d0, (a1)+                       * sonst speichern
 dbra d3, JMDL01                        * nächstes Zeichen
JMDL02:
 move.b #'.', (a1)+                     * der Punkt
 adda.l #pqdate, a2                     * Extension
 move #3-1, d3
JMDL03:
 move.b (a2)+, d0                       * Dateiextension
 tst.b d0                               * zu Ende?
 beq.b JMDL04                           * jo
 cmp.b #' ', d0                         * Space auch Ende
 beq.b JMDL04
 move.b d0, (a1)+                       * sonst speichern
 dbra d3, JMDL03                        * nächstes Zeichen
JMDL04:
 clr.b (a1)                             * zum Schluss noch ne NULL

 lea buffer(pc), a1                     * Puffer mit Name
 lea jdirbuf(pc), a0                    * der DIR-Puffer
 move #$1000, d1                        * 4kB DIR-Puffer
 clr d2                                 * nur Dateinamen
 moveq #1, d3                           * eine Spalte
 move #74, d7                           * Jados directory
 trap #6
 tst.b d0                               * Alles OK?
 bne.b JMDLerr                          * nö Fehler

 lea jdirbuf(pc), a0
 clr.l d0
JMDL05:
 cmp.b #' ', 0(a0, d0.w)
 ble.b JMDL06                           * kleiner/gleich Space = Ende
 add #16, d0                            * nächster Name
 cmp #4096, d0                          * Ende des Puffers?
 bge.b JMDL06                           * jo
 bra.b JMDL05                           * weiter
JMDL06:
 lsr.l #4, d0                           * /16 als Zähler
 bra.b JMDLex
JMDLerr:
 move.l #-1, d0
 move.l #14, errnum(a4)
JMDLex:
 movem.l (a7)+, d1-d7/a0-a6
 rts


JMFN:                           * JadosMakeFileName / jdirbuf=Name.Ext
                                * d0 = DIR Nummer
                                * copiert den Dateiname/ext. in den FCB
 movem.l d0/d3/a0-a3, -(a7)
 lea jdirbuf(pc), a1
 asl.l #4, d0                           * *16 als Offset
 adda.l d0, a1                          * a1 auf Dateiname
 lea jfcb(pc), a0
 movea.l a0, a3
 adda.l #JDName, a0
 move #8-1, d3
JMFN01:
 move.b #' ', (a0)+                     * Name mit Space füllen
 dbra d3, JMFN01
 movea.l a3, a0
 adda.l #JDExt, a0
 move.b #' ', (a0)+                     * Ext mit Space füllen
 move.b #' ', (a0)+
 move.b #' ', (a0)
 movea.l a3, a0
 adda.l #JDName, a0
JMFN03:
 move #8, d3                            * 9 Zeichen NAME+.
JMFN04:
 move.b (a1)+, d0
 cmp.b #'.', d0                         * Ende Dateiname?
 beq.b JMFN10
 move.b d0, (a0)+
 dbra d3, JMFN04
JMFN10:
 movea.l a3, a0
 adda.l #JDExt, a0
JMFN12:
 move.b (a1)+, (a0)+                    * Extension kopieren
 move.b (a1)+, (a0)+
 move.b (a1)+, (a0)+
JMFNex:
 movem.l (a7)+, d0/d3/a0-a3
 rts

jtom:                           * Kopiert/konvertiert den FCB nach FileDsct
 movem.l d1/d3/a0-a3, -(a7)
 bsr FFFD                               * FindFreeFileDiscriptor
 tst.l d0
 bmi jtomerr                            * kein freier Datei Händel
 move.l d0, d1                          * FileID sichern
 bsr FileDsct                           * FileDiscriptor in a0
 movea.l a0, a2                         * sichern nach a2
 lea jfcb(pc), a1                       * FCB in a1
 movea.l a1, a3                         * sichern nach a3
 adda.l #FileName, a0
 adda.l #JDName, a1
 move #8-1, d3
jtom01:
 move.b (a1)+, (a0)+                    * Dateiname kopieren
 dbra d3, jtom01
 movea.l a2, a0                         * FileDiscriptor zurück
 movea.l a3, a1                         * FCB zurück
 adda.l #FileExt, a0
 adda.l #JDExt, a1
 move.b 0(a1), 0(a0)                    * Extension kopieren
 move.b 1(a1), 1(a0)
 move.b 2(a1), 2(a0)
 move d1, d0                            * FileID zurück
 bsr FindName
 cmp.l #FULL_MAT, d0                    * Datei vorhanden
 bne.b jtom02                           * nein
 cmp.b #2, JNAFlag(a4)                  * Alle überschreiben?
 beq.b jtom01a                          * ja!
 tst.b quiet(a4)
 bne jtomerr2                           * keine Ausgabe
 lea txtcrlf(pc), a0                    * CRLF vorweg
 bsr writetxt
 move d1, d0
 bsr NameOut
 lea txtueber(pc), a0
 bsr JNA                                * Ja/Nein/Alle
 tst.l d0                               * Abbruch?
 bmi.b jtomerr3                         * ja
 cmp.b #2, JNAFlag(a4)                  * Alle?
 beq.b jtom01a                          * jo
 tst.b JNAFlag(a4)                      * Nein?
 beq.b jtomerr2                         * jo Fehler aber weiter
 clr.b JNAFlag(a4)                      * ansonsten Ja zurücksetzen
jtom01a:
 move.l d1, d0                          * FileID zurück
 bsr rem                                * Datei löschen
 tst.l d0
 bne.b jtomerr1                         * Fehler beim löschen
 move.b FileName(a2), d3                * erster Buchstabe des Namen
 move.b #$e5, FileName(a2)              * Name gelöscht
 clr.l FileSize(a2)                     * Dateigrösse = 0
 clr.l File1C(a2)                       * ersterCluster = 0
 clr.b FileAttr(a2)                     * Attribute = 0
 move.l d1, d0                          * FileID zurück
 bsr UFE                                * UpdateFileEntry
 tst.l d0
 bmi.b jtomerr1
 move.b d3, FileName(a2)                * erster Buchstabe zurück ;-)
jtom02:
 move.l d1, d0                          * FileID zurück
 bsr MNFE                               * MakeNewFileEntry
 tst.l d0
 bmi.b jtomerr1
 clr.l d0
 move JDatL(a3), d0                     * Dateilänge in Sektoren
 asl.l #8, d0                           * *256
 asl.l #2, d0                           * *4 = *1024 (Sektorlänge)
 move.l d0, FileSize(a2)                * in FileDsct
 move.l d1, d0                          * FileID zurück
 bra.b jtomex
jtomerr3:
 clr.b FileFlag(a2)                     * FileID dicht
 move.l #-3, d0                         * Abbruch
 bra.b jtomex
jtomerr2:
 clr.b FileFlag(a2)                     * FileID dicht
 move.l #-2, d0                         * Fehler aber weitermachen
 bra.b jtomex
jtomerr1:
 clr.b FileFlag(a2)                     * FileID dicht
jtomerr:
 move.l #-1, d0
jtomex:
 movem.l (a7)+, d1/d3/a0-a3
 rts


mtoj:                           * Kopiert/Konvertiert den FileDsct nach FCB
                                * d0 = FileID
 movem.l d0/d3/a0-a3, -(a7)
 bsr FileDsct                           * FileDiscriptor in a0
 movea.l a0, a2                         * nach a2 sichern
 bsr jclrfcb                            * FCB löschen
 lea jfcb(pc), a1                       * FCB in a1
 movea.l a1, a3                         * nach a3 sichern
 adda.l #FileName, a0                   * a0 auf Filename
 adda.l #JDName, a1                     * a1 auf JFilename
 move #8-1, d3                          * Zähler
mtoj01:
 move.b (a0)+, (a1)+                    * Name kopieren
 dbra d3, mtoj01
 movea.l a2, a0                         * FileDsct zurück
 movea.l a3, a1                         * FCB zurück
 adda.l #FileExt, a0
 adda.l #JDExt, a1                      *
 move.b 0(a0), 0(a1)
 move.b 1(a0), 1(a1)
 move.b 2(a0), 2(a1)                    * Ext kopiert
 move.l FileSize(a2), d0                * Dateigrösse in Byte
 move.l d0, d3
 lsr.l #8, d0                           * /256
 lsr.l #2, d0                           * /4 -> /1024 (Sektorgrösse)
 and.l #$3ff, d3
 tst d3                                 * noch ein Teilsektor?
 beq.b mtoj02                           * nö
 addq.l #1, d0                          * Ansonsten 1 Sektor mehr
mtoj02:
 move d0, JDatL(a3)                     * Grösse in Sektoren
 movem.l (a7)+, d0/d3/a0-a3
 rts



***** User IOs *****

parser:
 movem.l d1-d7/a0-a2, -(a7)

 bsr parsclr                            * Parserspeicher löschen
 
 lea parsdat(pc), a1
 move.l pflag(a1), d6                   * Parser Flag
 tst.b (a0)
 beq parsex                             * keine Parameter

pars02:                                 * führende Leerzeichen entfernen
 cmp.b #' ', (a0)+
 beq.b pars02
 subq.l #1, a0
 tst.b (a0)
 beq parsex                             * nichts nach den Leerzeichen

 cmp.b #'-', (a0)                       * Optionen?
 bne.b pars04
 addq.l #1, a0                          * Zeichen nach '-'
pars02a:
 tst.b (a0)                             * ne Null?
 beq parsex                             * ja!
 move.l popt(a1), d5                    * Optionen in d5
 move.b (a0)+, d0                       * Option laden
 sub.b #$40, d0                         * in Nummer umwandeln A=1...Z=26
 bmi.b pars03                           * Ungültige Option <@
 cmp.b #26, d0
 bgt.b pars03                           * Ungültige Option >Z
 bset.l d0, d5                          * Optionsbit setzten
 move.l d5, popt(a1)                    * Optionen abspeichern
 bset.l #pfopt, d6                      * Options-Flag setzen
 cmp.b #' ', (a0)                       * Space -> keine weiteren Optionen
 beq.b pars03
 cmp.b #'-', (a0)
 bne.b pars02a
pars02b:
 addq.l #1, a0                          * Zeichen nach '-'
 bra.b pars02a

pars03:                                 * Leerzeichen raus
 cmp.b #' ', (a0)+
 beq.b pars03
 subq.l #1, a0                          * wieder auf nicht Leerzeichen
 cmp.b #'-', (a0)                       *
 beq.b pars02b                          * doch noch ne Option!

pars04:                                 * Quell Laufwerk
 cmp.b #':', 1(a0)                      * ":" als 2.Zeichen
 bne.b pars04a                          * nö, kein JADOS
 bset.l #pfqlw, d6                      * Quell-Laufwerks Flag setzen
 move.b 0(a0), pqlw(a1)                 * JADOS Laufwerk
 move.b #'J', pqtyp(a1)                 * Typ JADOS
 addq.l #2, a0                          * Zeichen nach Laufwerk
 tst.b (a0)                             * Ende?
 beq parsex                             * Ja!
 bra pars04ex

pars04a:
 tst.b 1(a0)                            * 2. Zeichen Null?
 beq pars04ex                           * Ja
 cmp.b #' ', 1(a0)                      * 2. Zeichen SPACE?
 beq pars04ex                           * Ja
 tst.b 2(a0)                            * 3. Zeichen Null?
 beq pars04ex                           * Ja
 cmp.b #' ', 2(a0)                      * 3. Zeichen SPACE?
 beq pars04ex                           * Ja
 cmp.b #':', 3(a0)                      * ":" als 4. Zeichen ?
 bne.b pars04b                          * nö
 bset.l #pfqlw, d6                      * Quell-Laufwerks Flag setzen
 move.b #'M', pqtyp(a1)                 * Typ MS
 move.b (a0)+, pqlw(a1)
 move.b (a0)+, pqlw+1(a1)
 move.b (a0)+, pqlw+2(a1)
 addq.l #1, a0                          * nach :
 tst.b (a0)                             * Ende?
 beq parsex                             * Ja!
 bra.b pars04ex

pars04b:
 tst.b 3(a0)                            * 4. Zeichen Null?
 beq pars04ex                           * Ja
 cmp.b #' ', 3(a0)                      * 4. Zeichen SPACE?
 beq pars04ex                           * Ja
 cmp.b #':', 4(a0)                      * ":" als 5. Zeichen ?
 bne.b pars04c                          * nö
 bset.l #pfqlw, d6                      * Quell-Laufwerks Flag setzen
 move.b #'M', pqtyp(a1)                 * Typ MS
 move.b (a0)+, pqlw(a1)
 move.b (a0)+, pqlw+1(a1)
 move.b (a0)+, pqlw+2(a1)
 move.b (a0)+, pqlw+3(a1)
 addq.l #1, a0                          * nach :
 tst.b (a0)                             * Ende?
 beq parsex                             * Ja!
 bra.b pars04ex

pars04c:
 tst.b 4(a0)                            * 5. Zeichen Null?
 beq pars04ex                           * Ja
 cmp.b #' ', 4(a0)                      * 5. Zeichen SPACE?
 beq pars04ex                           * Ja
 cmp.b #':', 5(a0)                      * ":" als 6. Zeichen ?
 bne.b pars05                           * nö, kein Laufwerk
 bset.l #pfqlw, d6                      * Quell-Laufwerks Flag setzen
 move.b #'M', pqtyp(a1)                 * Typ MS
 move.b (a0)+, pqlw(a1)
 move.b (a0)+, pqlw+1(a1)
 move.b (a0)+, pqlw+2(a1)
 move.b (a0)+, pqlw+3(a1)
 move.b (a0)+, pqlw+4(a1)
 addq.l #1, a0                          * nach :
 tst.b (a0)                             * Ende?
 beq parsex

pars04ex:
 cmp.b #' ', (a0)+                      * Leerzeichen raus
 beq.b pars04ex
 subq.l #1, a0                          * wieder auf nicht Leerzeichen

pars05:                                 * frei für Pfad

pars06:                                 * Quell-Dateiname
 movea.l a1, a2
 adda.l #pqdatn, a2                     * a2 auf Quell Dateiname
 cmp.b #'.', (a0)                       * "." zum Anfang?
 bne.b pars06z                          * nö
 bset.l #pfqdatn, d6                    * Quell-Dateiname Flag setzen
 move.b (a0)+, (a2)+
 cmp.b #'.', (a0)                       * noch n "."
 bne parsex                             * nö dann schluss
 move.b (a0)+, (a2)+
 bra parsex                             * hier ist Schluss!
pars06z:
 move #8-1, d3                          * maximal 8 Zeichen
 bset.l #pfqdatn, d6                    * Quell-Dateiname Flag setzen
pars06a:
 move.b (a0)+, d0
 beq parsex                             * String durch
 cmp.b #'.', d0
 beq.b pars07                           * Quell-Dateiname durch
 move.b d0, (a2)+                       * Zeichen speichern
 dbra d3, pars06a
 tst.b (a0)
 beq parsex                             * Ende!
 cmp.b #'.', (a0)
 bne.b pars06b
 addq.l #1, a0
 bra.b pars07
pars06b:
 cmp.b #' ', (a0)                       * Leerzeichen?
 beq.b pars08                           * Ja, dann keine Extension!

pars07:                                 * Quell-Dateiextension
 movea.l a1, a2
 adda.l #pqdate, a2                     * a2 auf Quell-Dateiextension
 move #3-1, d3                          * max. 3 Zeichen
 bset.l #pfqdate, d6                    * Quell-Dateiextension Flag setzen
pars07a:
 move.b (a0)+, d0
 beq parsex                             * Ende String
 cmp.b #' ', d0                         * Leerzeichen?
 beq.b pars07ex                         * Ja!
 move.b d0, (a2)+                       * Zeichen speichern
 dbra d3, pars07a
 tst.b (a0)                             * Null?
 beq parsex                             * dann Schluss
pars07ex:
 cmp.b #' ', (a0)+                      * Leerzeichen raus
 beq.b pars07ex
 subq.l #1, a0                          * zurück auf nicht Leerzeichen
 tst.b (a0)                             * Ende?
 beq parsex                             * Ja!

pars08:                                 * 1. Adresswert
 cmp.b #'#', (a0)
 bne.s pars10                           * keine Adresswert
 addq.l #1, a0
 bsr wert
 cmp.l #-1, d0
 bne.s pars08a                          * kein Fehler
 move.l #28, errnum(a4)
 bra parserr
pars08a:
 bset.l #pfadr1, d6                     * Adresswert1 Flag setzen
 move.l d0, padr1(a1)                   * Adresswert1 speichern
pars08ex:
 cmp.b #' ', (a0)+                      * Leerzeichen raus
 beq.b pars08ex
 subq.l #1, a0                          * zurück auf nicht Leerzeichen
 tst.b (a0)                             * Ende?
 beq parsex                             * Ja!

pars10:                                 * Ziel Laufwerk
 cmp.b #':', 1(a0)                      * ":" als 2.Zeichen
 bne.b pars10a                          * nö, kein JADOS
 bset.l #pfzlw, d6                      * Ziel-Laufwerks Flag setzen
 move.b 0(a0), pzlw(a1)                 * JADOS Laufwerk
 move.b #'J', pztyp(a1)                 * Typ JADOS
 addq.l #2, a0                          * Zeichen nach Laufwerk
 tst.b (a0)                             * Ende?
 beq parsex                             * Ja!
 bra pars10ex

pars10a:
 cmp.b #':', 3(a0)                      * ":" als 4. Zeichen ?
 bne.b pars10b                          * nö
 bset.l #pfzlw, d6                      * Ziel-Laufwerks Flag setzen
 move.b #'M', pztyp(a1)                 * Typ MS
 move.b (a0)+, pzlw(a1)
 move.b (a0)+, pzlw+1(a1)
 move.b (a0)+, pzlw+2(a1)
 addq.l #1, a0                          * nach :
 tst.b (a0)                             * Ende?
 beq parsex                             * Ja!
 bra.b pars10ex

pars10b:
 cmp.b #':', 4(a0)                      * ":" als 5. Zeichen ?
 bne.b pars10c                          * nö
 bset.l #pfzlw, d6                      * Ziel-Laufwerks Flag setzen
 move.b #'M', pztyp(a1)                 * Typ MS
 move.b (a0)+, pzlw(a1)
 move.b (a0)+, pzlw+1(a1)
 move.b (a0)+, pzlw+2(a1)
 move.b (a0)+, pzlw+3(a1)
 addq.l #1, a0                          * nach :
 tst.b (a0)                             * Ende?
 beq parsex                             * Ja!
 bra.b pars10ex

pars10c:
 cmp.b #':', 5(a0)                      * ":" als 6. Zeichen ?
 bne.b pars11                           * nö, kein Laufwerk
 bset.l #pfzlw, d6                      * Ziel-Laufwerks Flag setzen
 move.b #'M', pztyp(a1)                 * Typ MS
 move.b (a0)+, pzlw(a1)
 move.b (a0)+, pzlw+1(a1)
 move.b (a0)+, pzlw+2(a1)
 move.b (a0)+, pzlw+3(a1)
 move.b (a0)+, pzlw+4(a1)
 addq.l #1, a0                          * nach :
 tst.b (a0)                             * Ende?
 beq parsex

pars10ex:
 cmp.b #' ', (a0)+                      * Leerzeichen raus
 beq.b pars10ex
 subq.l #1, a0                          * wieder auf nicht Leerzeichen

pars11:                                 * frei für Pfad

pars12:                                 * Ziel-Dateiname
 cmp.b #'.', (a0)                       * "." zum Anfang?
 beq parsex                             * geht nicht!
 movea.l a1, a2
 adda.l #pzdatn, a2                     * a2 auf Ziel Dateiname
 move #8-1, d3                          * maximal 8 Zeichen
 bset.l #pfzdatn, d6                    * Ziel-Dateiname Flag setzen
pars12a:
 move.b (a0)+, d0
 beq.b parsex                           * String durch
 cmp.b #'.', d0
 beq.b pars13                           * Ziel-Dateiname durch
 move.b d0, (a2)+                       * Zeichen speichern
 dbra d3, pars12a
 tst.b (a0)
 beq parsex                             * Ende!
 cmp.b #'.', (a0)
 bne.b pars12b
 addq.l #1, a0
 bra.b pars13
pars12b:
 cmp.b #' ', (a0)                       * Leerzeichen?
 beq.b parsex                           * Ja, dann keine Extension!

pars13:                                 * Ziel-Dateiextension
 movea.l a1, a2
 adda.l #pzdate, a2                     * a2 auf Ziel-Dateiextension
 move #3-1, d3                          * max. 3 Zeichen
 bset.l #pfzdate, d6                    * Ziel-Dateiextension Flag setzen
pars13a:
 move.b (a0)+, d0
 beq parsex                             * Ende String
 cmp.b #' ', d0                         * Leerzeichen?
 beq.b parsex                           * Ja! Dann Ende
 move.b d0, (a2)+                       * Zeichen speichern
 dbra d3, pars13a

pars14:                                 * 2. Adresswert
 cmp.b #'#', (a0)
 bne.s parsex                           * keine Adresswert
 addq.l #1, a0
 bsr wert
 cmp.l #-1, d0
 bne.s pars14a                          * kein Fehler
 move.l #28, errnum(a4)
 bra parserr
pars14a:
 bset.l #pfadr2, d6                     * Adresswert2 Flag setzen
 move.l d0, padr2(a1)                   * Adresswert2 speichern
 
                                        * Was danach kommt? Wen interessierts?
parsex:
 clr.l d0
 move.l d6, pflag(a1)                   * Parser Flag sichern
 movem.l (a7)+, d1-d7/a0-a2
 rts

parserr:
 bsr error
 move.l #-1, d0
 bsr parsclr
 movem.l (a7)+, d1-d7/a0-a2
 rts
 
parsclr:                                * Parserspeicher löschen
 movem.l d3/a1, -(a7)
 lea parsdat(pc), a1
 move #64-1, d3
parsclr1:                               * Parser Daten löschen
 clr.b (a1)+
 dbra d3, parsclr1
 movem.l (a7)+, d3/a1
 rts

mdiska:                         * Zeigt die vorhandenen FS-Typ Laufwerke
 movem.l d0/d1/d3/d6/a0/a1, -(a7)
 tst.l hdbtfild(a4)                     * ein Laufwerk vorhanden?
 beq mdaex                              * nö
 clr d1
 bsr parser
 moveq.l #1, d0
 bsr option
 bne mdaex

mda00a:
 lea parsdat(pc), a0
 move.l pflag(a0), d3
 btst.l #pfqlw, d3
 beq.b mda00                            * keine LW Parameter
 cmp.b #'M', pqtyp(a0)                  * MS?
 bne.b mda00                            * nö
 bsr hdpars
 tst.l d0
 bne mdaerr
 cmp aktlw(a4), d1
 beq.b mda00                            * ist aktuelles LW
 move d1, aktlw(a4)
 bsr LoadLW                             * ansonsten neu laden
mda00:                                  * Laufwerks Liste
 move.l hdbtfild(a4), d6
 move #32-1, d3                         * auf alle 32 Laufwerke testen
 clr.l d0                               * Nummer des gefundenen LWs
mda01:
 asr.l #1, d6
 bcc.b mda02
 bsr mdiskb                             * Ausgabe
mda02:
 addq #1, d0                            * sonst nächstes LW
 dbra d3, mda01
 lea txtcrlf(pc), a0
 bsr writetxt
 lea txtaktlw(pc), a0
 bsr writetxt
 bra.b mdaex
mdaerr:
 lea txtnv(pc), a0
 bsr writetxt
mdaex:
 movem.l (a7)+, d0/d1/d3/d6/a0/a1
 rts


mdiskb:
 move.l d0, -(a7)
 lea hdtab(pc), a0                      * Laufwerk-Tabelle
 mulu #6, d0                            * 6 Byte pro Eintrag
 adda.l d0, a0
 bsr writetxt
 move.l (a7)+, d0
 bsr komma
 rts


komma:
 cmp aktlw(a4), d0
 bne.b komma02
 lea txtstern(pc), a0
 bsr writetxt
komma02:
 lea txtkomma(pc), a0
 bsr writetxt
komma01:
 rts


hdpars:                         * sucht in der hdtab nach passendem LW
 lea hdtab(pc), a1                      * a1 zeigt auf die HD-Tabelle
 adda.l #pqlw, a0                       * a0 zeigt auf Quell-Laufwerk
 clr d1                                 * d1 ist Laufwerkszähler
 move #32-1, d3
hdp02:
 move.l (a0), d0                        * Langwort Vergleich
 cmp.l (a1), d0
 beq.b hdp04                            * da stimmts
hdp03:                                  * sonst weiter
 addq.l #6, a1                          * nächster Eintrag
 addq #1, d1                            * LW Zähler
 dbra d3, hdp02
 bra.b hdperr                           * Laufwerk nicht vorhanden
hdp04:
 move.b 4(a0), d0
 cmp.b 4(a1), d0
 beq.b hdp05                            * mögliches Laufwerk gefunden
 bra.b hdp03                            * weiter gehts
hdp05:
 move.l hdbtfild(a4), d6
 btst.l d1, d6                          * Laufwerk wirklich da?
 beq.b hdperr                           * nö :-(
 clr.l d0
 bra.b hdpex
hdperr:
 move.l #-1, d0
hdpex:
 rts


mdira:                          * gibt das akt. DIR von aktlw aus
 movem.l d0-d7/a1-a2, -(a7)
 tst.l hdbtfild(a4)                     * ein LW vorhanden?
 beq mdiraer                            * nö
 bsr parser                             * Parameter holen (JADOS)
 moveq.l #2, d0
 bsr option
 tst.l d0
 bne mdiraer
 clr.l d4                               * Dateienzähler
 clr.l d5                               * Grössenzähler
 clr.l d6                               * DIRzähler
 clr.l d7                               * Anzahl der Zeilen
 bsr dirkopf
 bsr FindFrst                           * 1. Eintrag
 tst.l d0                               * Fehler?
 bne mdiraer                            * Ja
 cmp.l #-1, ffpos(a4)                   * was Gefunden?
 beq.b mdira10                          * nein
 addq.l #1, d7                          * Anzahl der Zeilen
 lea dirbuff(pc), a1
 adda.l ffpos(a4), a1                   * a1 auf Datei
 btst.b #4, DIRAttr(a1)
 beq.b mdira00
 addq.l #1, d6                          * Anzahl der DIRs
 bra.b mdira00a
mdira00:
 addq.l #1, d4                          * Anzahl der Dateien
mdira00a:
 bsr mdirausg                           * Ausgeben
mdira01:
 bsr FindNext                           * nächster Eintrag
 tst.l d0                               * Fehler?
 bne.b mdiraer                          * Ja
 cmp.l #-1, ffpos(a4)                   * was gefunden?
 beq.b mdira10                          * nein
 addq.l #1, d7                          * Anzahl der Zeilen
 lea dirbuff(pc), a1
 adda.l ffpos(a4), a1                   * a1 auf Datei
 btst.b #4, DIRAttr(a1)
 beq.b mdira05
 addq.l #1, d6                          * Anzahl der DIRs
 bra.b mdira06
mdira05:
 addq.l #1, d4                          * Anzahl der Dateien
mdira06:
 bsr mdirausg                           * Ausgabe
 cmp #19, d7                            * Ende der Seite?
 bne.b mdira01                          * nein, weiter
 bsr nextside                           * sonst neue Seite
 tst d0                                 * Abbruch?
 bmi.b mdira10                          * ja!
 clr.l d7                               * Zeilenzähler auf 0
 bra.b mdira01                          * nächsten suchen
mdira10:
 bsr dirfuss
 clr.l d0
 bra.b mdiraex
mdiraer:
 bsr error
 move.l #-1, d0
mdiraex:
 movem.l (a7)+, d0-d7/a1-a2
 rts


mdirausg:
 movem.l d1-d3/a0-a2, -(a7)
 move #8-1, d2
 movea.l a1, a2
mdaus02:
 move.b (a2)+, d0                       * Datei Name
 bsr co2
 dbra d2, mdaus02
 move.b #' ', d0                        * "Space"
 bsr co2
 move #3-1, d2
mdaus03:
 move.b (a2)+, d0                       * Datei Erweiterung
 bsr co2
 dbra d2, mdaus03
 move.b #' ', d0
 bsr co2
 bsr co2                                * 2 Spaces ausgeben
 move.b (a2), d1
 btst.b #4, d1                          * DIR Attribut
 beq.b mdaus04
 lea txtdirat(pc), a0                   * Text: <DIR>
 bsr writetxt
 lea txt15spc(pc), a0                   * 15 Spaces
 bsr writetxt
 bra.b mdaus06
mdaus04:
 move.b #' ', d0
 bsr co2                                * Space
 move.b #'R', d0
 btst.b #0, d1                          * R = Schreibgeschützt
 bne.b mdaus04a
 move.b #' ', d0
mdaus04a:
 bsr co2
 move.b #'H', d0
 btst.b #1, d1                          * H = Versteckt
 bne.b mdaus04b
 move.b #' ', d0
mdaus04b:
 bsr co2
 move.b #'S', d0
 btst.b #2, d1                          * S = System
 bne.b mdaus04c
 move.b #' ', d0
mdaus04c:
 bsr co2
 move.b #'A', d0
 btst.b #5, d1                          * A = Archiv
 bne.b mdaus04d
 move.b #' ', d0
mdaus04d:
 bsr co2
 move.b #' ', d0
 bsr co2
mdaus05:
 move #' ', d0
 bsr co2
 movea.l a1, a2
 move.l DIRSize(a2), d0                 * Dateigrösse in Byte
 bsr LBHLW
 add.l d0, d5                           * Gesamt Grösse
 bsr print8d                            * Ausgabe
mdaus06:
 movea.l a1, a2
 move.b #' ', d0
 bsr co2
 bsr co2
 move.l DIRLCh(a2), d0          * Datum/Zeit der letzten änderung LBHLW!
 bsr LBHLW
 move.l d0, d1                          * sichern
 swap d0
 and.l #$1f, d0                         * 5 Bit = Tag
 bsr print2d
 move.b #'.', d0
 bsr co2
 move.l d1, d0
 swap d0
 asr #5, d0
 and.l #$f, d0                          * 4 Bit = Monat
 bsr print2d0
 move.b #'.', d0
 bsr co2
 move.l d1, d0
 rol.l #7, d0
 and.l #$7f, d0                         * 7 Bit = Jahr
 add #1980, d0                          * ab 1980
 bsr print4d
 move.b #' ', d0
 bsr co2
 bsr co2
 move d1, d0
 rol #5, d0
 and #$1f, d0                           * 5 Bit = Stunde
 bsr print2d
 move.b #':', d0
 bsr co2
 move d1, d0
 asr #5, d0
 and #$3f, d0                           * 6 Bit = Minuten
 bsr print2d0
 move.b #':', d0
 bsr co2
 move d1, d0
 and #$1f, d0                           * 5 Bit = Sekunden
 bsr print2d0
 lea txtcrlf(pc), a0                    * nächste Zeile
 bsr writetxt
mdausex:
 movem.l (a7)+, d1-d3/a0-a2
 rts


dirkopf:
 bsr cls
 lea txtlw(pc), a0
 bsr writetxt
 move aktlw(a4), d0
 lea hdtab(pc), a0                      * Laufwerk-Tabelle
 mulu #6, d0                            * 6 Byte pro Eintrag
 adda.l d0, a0
 bsr writetxt
 lea txtcrlf(pc), a0
 bsr writetxt
 lea txtverz(pc), a0
 bsr writetxt
 lea NoAD(a6), a0
 bsr writetxt
 lea txtcrlf(pc), a0
 bsr writetxt
 bsr writetxt                           * eine Leerzeile
 rts


dirfuss:
 lea txtcrlf(pc), a0
 bsr writetxt                           * Eine Leerzeile
 move.l d4, d0
 bsr print8d                            * Anzahl der Dateien
 move.b #' ', d0
 bsr co2
 lea txtdatei(pc), a0
 bsr writetxte
 move.b #' ', d0
 bsr co2
 bsr co2
 move.l d5, d0
 bsr print8d                            * Grösse aller Dateien
 move.b #' ', d0
 bsr co2
 lea txtbyte(pc), a0
 bsr writetxt
 lea txtcrlf(pc), a0
 bsr writetxt                           * Eine Leerzeile
 move.l d6, d0
 bsr print8d                            * Anzahl der DIRs
 move.b #' ', d0
 bsr co2
 lea txtdir(pc), a0
 bsr writetxte
 rts


nextside:
 movem.l a0, -(a7)
 clr d7
 lea txtweit(pc), a0
 bsr writetxt
 bsr key
 cmp.b #$03, d0                         * CTRL-C
 bne.b nxtsd01
 move #-1, d0
 bra.b nxtsdex
nxtsd01:
 lea txtcrlf(pc), a0
 bsr writetxt
 bsr writetxt
 lea txtverz(pc), a0
 bsr writetxt
 lea NoAD(a6), a0
 bsr writetxt
 move.b #' ', d0
 bsr co2
 lea txtforts(pc), a0
 bsr writetxt
 lea txtcrlf(pc), a0
 bsr writetxt
 clr.l d0
nxtsdex:
 movem.l (a7)+, a0
 rts



mcda:                                   * ändert das akt. Verzeichniss
 movem.l d0/a0, -(a7)
 tst.l hdbtfild(a4)                     * LW vorhanden?
 beq.b mcdaex                           * nö
 bsr parser
 moveq.l #3, d0                         * Befehlsnummer
 bsr option                             * 'H' und 'Q' möglich
 tst.l d0
 bne.b mcdaex                           * nach Hilfe nicht weiter
mcda01:
 lea parsdat(pc), a0
 move.l pflag(a0), d0
 btst.l #pfqdatn, d0
 beq.b mcdaerr
 bsr chdir
 cmp #F_OK, d0
 beq.b mcdaex
mcdaerr:
 move.l #-1, d0
 bsr error
 bra.b mcdaex1
mcdaex:
 tst.b quiet(a4)                        * Ausgabe unterdrücken?
 bne.b mcdaex1                          * ja
 lea txtcrlf(pc), a0                    * CRLF vorweg
 bsr writetxt
 lea NoAD(a6), a0                       * DIR-Name
 bsr writetxt
 lea txtakt(pc), a0
 bsr writetxt
 lea txtverz(pc), a0
 bsr writetxt
mcdaex1:
 movem.l (a7)+, d0/a0
 rts


mmda:                                   * erstellt ein neues Verzeichnis
 movem.l d0/a0, -(a7)
 tst.l hdbtfild(a4)                     * LW vorhanden?
 beq.b mmdaex                           * nö
 bsr parser
 moveq.l #6, d0                         * Befehlsnummer
 bsr option                             * 'H', 'Q' und 'K' möglich
 tst.l d0
 bne.b mmdaex
mmda02:
 lea parsdat(pc), a0
 move.l pflag(a0), d0
 btst.l #pfqdatn, d0
 bne.b mmda03
 move.l #-1, d0                         * kein Dateiname
 move.l #15, errnum(a4)
 bra.b mmdaerr
mmda03:
 bsr mkdir
 tst.l d0
 beq.b mmdaex
mmdaerr:
 bsr error
mmdaex:
 movem.l (a7)+, d0/a0
 rts


mloada:                                 * Lädt eine Datei in den Speicher
                                        * a0=Dateiname, a1=Ladeadresse
 movem.l d1-d2/a0-a1, -(a7)
 tst.l hdbtfild(a4)                     * LW vorhanden?
 beq mldaex1                            * nö
 bsr parser
 moveq.l #5, d0
 bsr option
 tst.l d0
 bne mldaex1
mlda00a:
 lea parsdat(pc), a0
 move.l pflag(a0), d0
 btst.l #pfqdatn, d0
 bne.b mlda01
 move.l #15, errnum(a4)
 bra.b mldaerr1                         * kein Dateiname!
mlda01:
 bsr FFFD                               * FindFreeFileDiscriptor
 tst.l d0
 bmi.b mldaerr1                         * kein freier Dateihändel
 move.l d0, d2                          * sichern
 bsr MFN                                * MakeFileName
 move d2, d0                            * Dateihändel zurück
 bsr FindName                           * Datei suchen
 cmp.l #FULL_MAT, d0                    * gefunden?
 beq.b mlda02                           * jo
 move.l #16, errnum(a4)
 bra.b mldaerr
mlda02:
 move.l d2, d0                          * Dateihändel zurück
 bsr FileDsct                           * a0=Adresse des Dateihändels
 move.l a1, FileAdr(a0)                 * Speicheradresse setzen
 move.l d2, d0                          * Vorsichtshalber
 bsr fload                              * Datei in Speicher laden
 tst.l d0
 bne.b mldaerr
 tst.b quiet(a4)                        * Ausgabe unterdrücken?
 bne.b mlda10                           * ja
 lea txtcrlf(pc), a0                    * CRLF vorweg
 bsr writetxt
 move.l d2, d0
 bsr NameOut
 lea txtload(pc), a0
 bsr writetxt
mlda10:
 clr.l d0                               * alles OK
 bra.b mldaex
mldaerr:
 move.l #-1, d0                         * Fehler
 bsr error
 bra.b mldaex
mldaerr1:
 move.l #-1, d0
 bsr error
 bra.b mldaex1

mldaex:

*** FileID wieder freigeben muss später durch fclose erfolgen
 move.l d0, -(a7)
 move d2, d0
 bsr FileDsct
 clr.b FileFlag(a0)
 move.l (a7)+, d0
***

mldaex1:
 movem.l (a7)+, d1-d2/a0-a1
 rts



mcopya:                         * Kopiert Dateien von/nach Jados
 movem.l d1-d3/a0-a3, -(a7)
 moveq.l #-1, d1                        * keine FileID
 tst.l hdbtfild(a4)                     * LW vorhanden?
 beq mcpaex1                            * nö
 bsr parser
 moveq.l #4, d0
 bsr option
 tst.l d0
 bne mcpaex1
mcpa01:
 lea parsdat(pc), a3
 move.l pflag(a3), d0
 btst.l #pfqdatn, d0
 bne.b mcpa01a
 move.l #15, errnum(a4)                 * kein Dateiname
 bra mcpaerr
mcpa01a:
 btst.l #pfqlw, d0
 beq mcpa10                             * keine Laufwerksbezeichnung

 cmp.b #'J', pqtyp(a3)                  * JADOS?
 bne mcpa10                             * nö

 bsr JMDL                               * JadosMakeDirList
 tst.l d0
 bmi mcpaerr                            * Fehler in DIR-Liste
 move.l d0, d3                          * Anzahl der DIR-Einträge
 beq mcpaex                             * keine Dateien - Ende!
 subq.l #1, d3                          * als Zähler
 clr.l d2                               * DIR-Nummer
mcpa02:
 moveq.l #-1, d1                        * keine FileID
 bsr jclrfcb                            * FCB löschen
 move.l d2, d0                          * DIR Nummer
 bsr JMFN                               * Dateiname/Ext. in FCB
 clr.l d0
 move.b pqlw(a3), d0                    * Laufwerksbuchstabe
 bsr jconvlw                            * nach binär
 cmp.l #-1, d0
 beq mcpaerr                            * Fehler
 lea jfcb(pc), a1
 move d0, JLW(a1)                       * Laufwerk im FCB setzen
 bsr jusradr                            * Adresse des Userbereichs laden
 movea.l a0, a2                         * sichern
 bsr jfload                             * Datei laden
 cmp.l #-1, d0
 beq mcpaerr                            * Datei konnte nicht geladen werden
 bsr jtom                               * Jados-FCB -> Mtools-FileDsct
 cmp.l #-1, d0
 beq mcpaerr                            * Schwerer Fehler
 cmp.l #-2, d0
 beq.b mcpa05                           * nicht überschreiben
 cmp.l #-3, d0                          * Abbruch?
 beq mcpaex                             * ja!
mcpa03:
 move.l d0, d1                          * FileID sichern
 bsr FileDsct                           * FileDiscriptor in a0
 movea.l a0, a1                         * sichern
 move.l a2, FileAdr(a1)
 move.l d1, d0                          * FileID zurück!!!
 tst.b convflag(a4)                     * Konvertieren?
 beq.b mcpa03a                          * nein
 bsr NKCtoIBM
 tst.l d0
 bmi mcpaerr                            * Fehler beim Konvertieren
mcpa03a:
 move.l d1, d0                          * FileID zurück
 bsr fsave                              * Datei speichern
 cmp.l #-1, d0                          * Speichern OK?
 beq mcpaerr                            * nö
 move.l d1, d0                          * FileID zurück
 bsr UFE                                * UpdateFileEntry
 cmp.l #-1, d0
 beq mcpaerr
 tst.b quiet(a4)                        * mit Ausgabe?
 bne.b mcpa04                           * nö
 lea txtcrlf(pc), a0                    * CRLF vorweg
 bsr writetxt
 move.l d1, d0                          * FileID zurück
 bsr NameOut                            * Name ausgeben
 lea txtcopy(pc), a0
 bsr writetxt
mcpa04:
 clr.b FileFlag(a1)                     * FileID schliessen
mcpa05:
 addq.l #1, d2                          * nächste Datei
 subq.l #1, d3
 bpl mcpa02                             * dbra geht nur bis Wort!!!
 clr.b JNAFlag(a4)                      * nicht mehr überschreiben
 clr.l d0
 bra mcpaex1                            * geht ohne FileID schliessen

mcpa10:
 btst.l #pfzlw, d0                      * Ziel-Laufwerk vorhanden?
 beq mcpaerr                            * nö
 cmp.b #'J', pztyp(a3)                  * Ziel = Jados?
 beq.b mcpa11                           * jo
 move.l #24, errnum(a4)                 * ungültiges Laufwerk
 bra mcpaerr
mcpa11:
 move.l #-1, d1                         * keine FileID
 bsr FFFD                               * FindFreeFileDiscriptor
 tst.l d0
 bmi mcpaerr                            * Fehler
 move.l d0, d1                          * FileID sichern
 bsr FileDsct                           * Filediscriptor in a0
 movea.l a0, a2                         * sichern
 bsr FindFrst
 tst.l d0
 bmi mcpaerr
 cmp.l #-1, ffpos(a4)
 bne.b mcpa12
 move.l #16, errnum(a4)                 * keine Datei da
 bra mcpaerr
mcpa12:
 move.l d1, d0                          * FileID zurück
 bsr FFD
 btst.b #4, FileAttr(a2)                * DIR?
 bne mcpa14                             * Ja
 bsr mtoj                               * FCB anlegen
 clr.l d0
 move.b pzlw(a3), d0
 bsr jconvlw                            * JADOS Lw
 tst.b d0
 bmi mcpaerr                            * kein gültiges Laufwerk
 lea jfcb(pc), a0
 move d0, JLW(a0)                       * Laufwerk setzen
 bsr jusradr                            * User Speicher holen
 move.l a0, FileAdr(a2)                 * in FileDsct speichern
 movea.l a0, a1                         * und sichern

 cmp.b #2, JNAFlag(a4)
 beq.b mcpa13                           * Alles überschreiben
 movem.l d1-d3, -(a7)
 bsr jfinfo
 movem.l (a7)+, d1-d3
 tst.b d0
 bmi.b mcpa13                           * Datei nicht vorhanden
 tst.b quiet(a4)
 bne.b mcpa14                           * nächste Datei
 lea txtcrlf(pc), a0
 bsr writetxt
 move.l d1, d0
 bsr NameOut
 lea txtueber(pc), a0
 bsr JNA
 tst.l d0                               * Abbruch?
 bmi.b mcpaex                           * ja
 cmp.b #2, JNAFlag(a4)                  * Alle überschreiben
 beq.b mcpa13
 tst.b JNAFlag(a4)                      * Nicht übeschreiben
 beq.b mcpa14                           * nächste Datei
 clr.b JNAFlag(a4)
mcpa13:
 move.l d1, d0                          * FileID zurück
 bsr fload                              * Datei laden
 tst d0                                 * OK?
 bmi.b mcpaerr                          * nö
 tst.b convflag(a4)                     * konvertieren?
 beq.b mcpa13a                          * nö
 move.l d1, d0                          * FileID zurück
 bsr IBMtoNKC
 tst.l d0
 bmi.b mcpaerr                          * Fehler beim konvertieren
mcpa13a:
 movea.l a1, a0                         * Speicheradresse nach a0
 bsr jfsave                             * und speichern
 tst.b d0                               * OK?
 bne.b mcpaerr                          * Nein
 tst.b quiet(a4)                        * mit Ausgabe?
 bne.b mcpa14                           * nö
 lea txtcrlf(pc), a0                    * CRLF vorweg
 bsr writetxt
 move d1, d0                            * FileID zurück
 bsr NameOut                            * Name ausgeben
 lea txtcopy(pc), a0
 bsr writetxt
mcpa14:
 bsr FindNext
 tst.l d0
 bmi.b mcpaerr
 cmp.l #-1, ffpos(a4)
 beq.b mcpaex
 bra mcpa12

mcpaerr:
 moveq.l #-1, d0
 bsr error
mcpaex:
 tst.l d1
 bmi.b mcpaex1                          * keine FileID!!!
 exg d0, d1
 bsr FileDsct
 clr.b FileFlag(a0)                     * FileID schliessen
 exg d0, d1
mcpaex1:
 movem.l (a7)+, d1-d3/a0-a3
 rts


mdela:
 movem.l d0/a3, -(a7)
 tst.l hdbtfild(a4)
 beq.b mdelaex
 bsr parser
 moveq.l #7, d0
 bsr option
 tst.l d0
 bne.b mdelaex
mdela02:
 bsr remove
 tst.l d0
 beq.b mdelaex
mdelaer:
 bsr error
mdelaex:
 movem.l (a7)+, d0/a3
 rts


mforma:
 movem.l d0/a0, -(a7)           * Formatiert das akt. Laufwerk
 tst.l hdbtfild(a4)
 beq mfrmaex                            * kein LW da
 bsr parser
 moveq.l #8, d0
 bsr option
 tst.l d0
 bne mfrmaex
 tst.b JNAFlag(a4)
 bne.b mfrma01                          * loslegen
 tst.b quiet(a4)
 bne.b mfrmaex
 bsr cls
 lea txtlw(pc), a0
 bsr writetxt
 move aktlw(a4), d0
 lea hdtab(pc), a0                      * Laufwerk-Tabelle
 mulu #6, d0                            * 6 Byte pro Eintrag
 adda.l d0, a0
 bsr writetxt
 lea txtform(pc), a0
 bsr JN
 tst.l d0
 bmi.b mfrmaex                          * Abbruch mit CTRL-C
 tst.b JNAFlag(a4)
 beq.b mfrmaex                          * nicht formatieren
mfrma01:
 bsr QForm
 tst.l d0
 bmi.b mfrmaer
 tst.l quiet(a4)
 bne.b mfrmaex
 lea txtcrlf(pc), a0
 bsr writetxt
 lea txtlw(pc), a0
 bsr writetxt
 move aktlw(a4), d0
 lea hdtab(pc), a0                      * Laufwerk-Tabelle
 mulu #6, d0                            * 6 Byte pro Eintrag
 adda.l d0, a0
 bsr writetxt
 lea txtform1(pc), a0
 bsr writetxt
 bra.b mfrmaex
mfrmaer:
 bsr error
mfrmaex:
 movem.l (a7)+, d0/a0
 rts



hilfe:
 movem.l d0/a0, -(a7)
 bsr cls
 asl.l #2, d0
 lea hilfetab(pc), a0
 adda.l 0(a0, d0.w), a0
 bsr writetxt
 movem.l (a7)+, d0/a0
 rts


error:
 movem.l d0/a0, -(a7)
 cmp.b #2, quiet(a4)
 beq.b errex                            * keine Fehlerausgabe
 lea txtcrlf(pc), a0
 bsr writetxt
 move.l errnum(a4), d0
 cmp.l #erranz, d0
 blt.s err01
 move.l #27, d0                         * undefinierter Fehler
err01:
 asl.l #2, d0
 lea errtab(pc), a0
 adda.l 0(a0, d0.w), a0
 bsr writetxt
errex:
 movem.l (a7)+, d0/a0
 rts


option:                         * Optionen einstellen
                                * d0=Nummer des Befehls
 movem.l d1-d2/a0, -(a7)
 move.l d0, d2                          * Befehlsnummer sichern
 bmi opterr                             * Ungültige Befehlsnummer
 cmp.l #trapanz, d2
 bge opterr                             * Ungültige Befehlsnummer
 clr.b quiet(a4)
 clr.b JNAFlag(a4)
 clr.b convflag(a4)
 lea parsdat(pc), a0
 move.l pflag(a0), d1
 btst.l #pfopt, d1
 bne.b opt00
 clr.l d0
 bra.b optex                            * keine Option
opt00:
 move.l popt(a0), d1                    * angegebene Optionen
 lea opttab(pc), a0
 asl.l #2, d2                           * Befehlsnummer als Offset
 move.l 0(a0, d2.w), d2                 * mögliche Befehlsoption
 not.l d2
 and.l d1, d2
 bne.b opterr                           * ungültige Option

 btst.l #$08, d1                        * H: Hilfe
 beq.b opt01
 bsr hilfe
 move.l #-1, d0
 bra.b optex                            * keine weitere Befehlsausführung
opt01:
 btst.l #$17, d1                        * Q: Quiet - Ausgabe unterdrücken
 beq.b opt02
 move.b #1, quiet(a4)
 clr.l d0
opt02:
 btst.l #$01, d1                        * A: Alle
 beq.b opt03
 move.b #2, JNAFlag(a4)                 * Alle überschreiben/löschen...
 clr.l d0
opt03:
 btst.l #$11, d1                        * K: Keinerlei Ausgabe
 beq.b opt04
 move.b #2, quiet(a4)                   * keine Ausgabe (auch keine Fehler)
 clr.l d0
opt04:
 btst.l #$03, d1                        * C: Kovertieren
 beq.b opt05
 move.b #-1, convflag(a4)
 clr.l d0
opt05:
 nop
 bra.b optex                            * weiter mit Befehl

opterr:
 move.l #17, errnum(a4)                 * Falsche Option
 bsr error
 move.l #-1, d0                         * keine weitere Befehlsausführung
optex:
 movem.l (a7)+, d1-d2/a0
 rts


NKCtoIBM:                       * konvertiert NKC Textdateien nach IBM
 movem.l d1-d5/a0-a3/a5, -(a7)          * FileID in d0
 bsr FileDsct
 movea.l FileAdr(a0), a3                * RAM Adresse der Datei
 movea.l a3, a2                         * sichern
 move.l FileSize(a0), d3                * Dateigrösse (von JADOS)
 move.l d3, d2                          * sichern
 lea nkctab(pc), a1
 lea ibmtab(pc), a5
 sub.l #1024, d3                        * letzten Sektor raus
 bmi.b NtI02                            * Datei < 1024 Byte
 subq.l #1, d3                          * als Zähler
 bmi.b NtI02                            * Datei = 1024 Byte
NtI01:
* tst.b (a3)+                            * ne Null?
* beq NtIerr                             * Ja, dann kein Text!!!
* subq.l #1, d3
* bpl.b NtI01                            * dbra geht nur bis Wort!!!
 movea.l a2, a3                         * Dateistart zurück
NtI02:
 clr.l d1                               * als Bytezähler
 move.l d2, d3                          * Länge zurück
NtI03:
 move.b (a3), d0                        * Zeichen einlesen
 beq.b NtI20                            * Ende erreicht
 bmi.b NtI05                            * Umlaut
NtI04:                                  * Regulär
 addq.l #1, d1
 addq.l #1, a3
 bra.b NtI03                            * Nächstes Zeichen
NtI05:
 clr.l d4
NtI05a:
 move.b 0(a1, d4.w), d5                 * NKC Umlaut
 beq.b NtI05b                           * Tabelle durch
 cmp.b d5, d0                           *
 bne.b NtI05c                           * ist es nicht
 move.b 0(a5, d4.w), d0                 * IBM Umlaut laden
 bra.b NtI10
NtI05b:
 move.b #' ', d0                        * Space laden
 bra.b NtI10
NtI05c:
 addq #1, d4                            * nächster Umlaut
 bra.b NtI05a
NtI10:
 move.b d0, (a3)                        * abspeichern
 bra.b NtI04                            * und weiter
NtI20:
 move.l d1, FileSize(a0)                * neue Länge speichern
 clr.l d0
 bra.b NtIex
NtIerr:
 move.l #-1, d0
 move.l #26, errnum(a4)
NtIex:
 movem.l (a7)+, d1-d5/a0-a3/a5
 rts


IBMtoNKC:                       * konvertiert IBM Textdateien nach NKC
 movem.l d1-d5/a0-a3/a5, -(a7)          * FileID in d0
 bsr FileDsct
 movea.l FileAdr(a0), a3                * RAM Adresse der Datei
 movea.l a3, a2                         * sichern
 move.l FileSize(a0), d3                * Dateigrösse
 move.l d3, d2                          * sichern
 lea nkctab(pc), a5
 lea ibmtab(pc), a1
 subq.l #1, d3                          * als Zähler
ItN01:
 tst.b (a3)+                            * ne Null?
 beq ItNerr                             * Ja, dann kein Text!!!
 subq.l #1, d3
 bpl.b ItN01                            * dbra geht nur bis Wort!!!
 clr.b (a3)                             * Ende setzten
 movea.l a2, a3                         * Dateistart zurück
ItN02:
 clr.l d1                               * als Bytezähler
 clr.l d3                               * als Zeichen / Zeile
ItN03:
 move.b (a3), d0                        * Zeichen einlesen
 bmi.b NtI05                            * Umlaut
 cmp.b #$09, d0                         * HTAB
 bne ItN03a
 bsr TABtoSP                            * durch Space ersetzen
 bra.b ItN04
ItN03a:
 cmp.b #$0a, d0                         * LF?
 bne.b ItN04                            * nö
 moveq.l #-1, d3                        * sonst Zeichen/Zeile auf 0 ;-)
ItN04:                                  * Regulär
 addq.l #1, d3                          * nächstes Zeichen in Zeile
 addq.l #1, d1
 addq.l #1, a3
 cmp.l d2, d1                           * Ende?
 bge.b ItN20
 cmp.l #79, d3                          * Zeilenumbruch nötig?
 ble.b ItN04a                           * nein
 cmp.b #$0a, 0(a3)                      * nächstes Zeichen ein LF?
 bne.s ItN04b                           * Nein, weiter
 clr.l d3
 addq.l #1, a3
 bra.s ItN03
ItN04b:
 cmp.b #$0a, 1(a3)                      * übernächstes Zeichen LF?
 bne.s ItN04c                           * nein dann neuer Umbruch
 addq.l #2, a3
 clr.l d3
 bra.s ItN03
ItN04c:
 bsr umbruch
 clr.l d3
ItN04a:
 bra.b ItN03                            * Nächstes Zeichen
ItN05:
 clr.l d4
ItN05a:
 move.b 0(a1, d4.w), d5                 * IBM Umlaut
 beq.b ItN05b                           * Tabelle durch
 cmp.b d5, d0                           *
 bne.b ItN05c                           * ist es nicht
 move.b 0(a5, d4.w), d0                 * NKC Umlaut laden
 bra.b ItN10
ItN05b:
 move.b #' ', d0                        * ansonsten Space laden
 bra.b ItN10
ItN05c:
 addq #1, d4                            * nächster Umlaut
 bra.b ItN05a
ItN10:
 move.b d0, (a3)                        * abspeichern
 bra.b ItN04                            * und weiter
ItN20:
 adda.l d1, a2                          * a2 auf Ende der Datei
* addq.l #1, d1
 move.l d1, FileSize(a0)                * neue Länge speichern
 lea jfcb(pc), a0
 move.l d1, d0
 lsr.l #8, d0                           * /256
 lsr.l #2, d0                           * /4 -> /1024 (Sektorgrösse)
 and.l #$3ff, d1
 tst d1                                 * noch ein Teilsektor?
 beq.b ItN20a                           * nö
 addq.l #1, d0                          * Ansonsten 1 Sektor mehr
 move #1024, d2
 sub d1, d2                             * 1024-Restdaten
 subq #1, d2                            * -1 da Zähler
ItN201:
 clr.b (a2)+
 dbra d2, ItN201                        * Restsektor mit 00 füllen
ItN20a:
 move d0, JDatL(a0)                     * Grösse in Sektoren
 clr.l d0
 bra.b ItNex
ItNerr:
 move.l #-1, d0
 move.l #26, errnum(a4)
ItNex:
 movem.l (a7)+, d1-d5/a0-a3/a5
 rts


umbruch:                        * Zeilenumbruch einfügen
 movem.l d1-d2/a0, -(a7)
 movea.l a3, a0                         * aktuelle Position
 sub.l d1, d2                           * Länge - akt. Position = Rest
 move.l d2, d1                          * nach d1
 move.l #2, d0                          * um 2 verschieben
 bsr mover
 move.b #$0d, 0(a0)
 move.b #$0a, 1(a0)
 movem.l (a7)+, d1-d2/a0
 addq.l #2, d2                          * Text um 2 Byte länger
 rts


TABtoSP:                        * einen Tabulator in Spaces umwandeln
 movem.l d0-d1/d3/a0, -(a7)
 move.l d3, d0                          * akt. Zeichenposition in Zeile
 and.l #$7, d0                          * mod 8
 move.l #8, d3
 sub.l d0, d3
 move.l d3, d0
TtS01:
 subq.l #1, d0
 movea.l a3, a0                         * aktuelle Position
 move.l d2, -(a7)                       * d2 retten
 sub.l d1, d2                           * Länge - akt. Position = Rest
 move.l d2, d1                          * nach d1
 move.l (a7)+, d2                       * d2 zurück
 bsr mover
 move.l d0, d1
TtS02:
 move.b #' ', (a0)+                     * mit Space füllen
 dbra d1, TtS02
 add.l d0, d2                           * neue Textlänge
 movem.l (a7)+, d0-d1/d3/a0
 rts


mover:                          * Verschiebt um d0.w Bytes nach hinten
 movem.l d1/a0, -(a7)           * d1.l = Länge, a0 = Start
 adda.l d1, a0                          * a0 Auf Ende
mvrlp01:
 move.b (a0), 0(a0, d0.w)
 subq.l #1, a0
 subq.l #1, d1
 bpl.b mvrlp01                          * dbra geht nur bis Wort!!!
 movem.l (a7)+, d1/a0
 rts



***** Texte *****

ds 0

txtinit:
 dc.b 'MTOOLS V 0.8F sind initialisiert', 0

txtcrlf:
 dc.b $0d, $0a, 0

txtmaster:
 dc.b 'Master Laufwerk - ', 0

txtslave:
 dc.b 'Slave Laufwerk - ', 0

txtnv:
 dc.b 'Laufwerk nicht verfügbar', 0

txtcyl:
 dc.b 'Zylinder: ', 0

txtsec:
 dc.b 'Sektoren: ', 0

txthd:
 dc.b 'Köpfe: ', 0

txtpart:
 dc.b 'Partitionen:', 0

txtnr:
 dc.b 'Nr', 0

txtstart:
 dc.b 'Start-', 0

txt1start:
 dc.b 'sektor', 0

txtgroess:
 dc.b 'Anzahl', 0

txt1groess:
 dc.b 'Sektoren', 0

txtMB:
 dc.b 'Grösse in', 0

txt1MB:
 dc.b 'MiB', 0

txttyp:
 dc.b 'Partitionstyp', 0

txtkomma:
 dc.b ', ', 0

txtstern:
 dc.b ' *', 0

txtaktlw:
 dc.b '* = aktives Laufwerk', 0

txtweit:
 dc.b 'Weiter mit beliebiger Taste . . .', 0

txtforts:
 dc.b 'wird fortgesetzt', 0

txtlw:
 dc.b 'Laufwerk ', 0

txtverz:
 dc.b 'Verzeichnis ', 0

txterst:
 dc.b 'erstellt', 0

txtdirat:
 dc.b '<DIR> ', 0

txtdatei:
 dc.b 'Datei(en) ', 0

txtdir:
 dc.b 'Verzeichnis(se) ', 0

txtbyte:
 dc.b 'Byte ', 0

txt15spc:
 dc.b '               ', 0

txtroot:
 dc.b '/', 0

txtjn:
 dc.b ' (Ja/Nein) ', 0

txtjna:
 dc.b ' (Ja/Nein/Alle) ', 0

txtueber:
 dc.b 'überschreiben?', 0

txtcopy:
 dc.b 'kopiert', 0

txtdel:
 dc.b 'gelöscht', 0

txtloe:
 dc.b 'löschen?', 0

txtload:
 dc.b 'ins RAM geladen', 0

txtakt:
 dc.b ' ist aktuelles ', 0

txtform:
 dc.b ' formatieren?', 0

txtform1:
 dc.b ' ist formatiert!', 0


***** Fehler Texte *****

terr1:
 dc.b 'kein Laufwerk vorhanden', 0

terr2:
 dc.b 'keine FAT16 Partition verfügbar', 0

terr3:
 dc.b 'Laufwerk nicht ready', 0

terr4:
 dc.b 'Daten sind nicht bereit', 0

terr5:
 dc.b 'Sektor kann nicht gelesen werden', 0

terr6:
 dc.b 'Sektor kann nicht geschrieben werden', 0

terr7:
 dc.b 'Disk ist voll', 0

terr8:
 dc.b 'kein freier Cluster', 0

terr9:
 dc.b 'kein freier Datei-Händel', 0

terr10:
 dc.b 'DIR kann nicht gelöscht werden', 0

terr11:
 dc.b 'Verzeichnis nicht vorhanden', 0

terr12:
 dc.b 'Verzeichnis ist voll', 0

terr13:
 dc.b 'Verzeichnis schon vorhanden', 0

terr14:
 dc.b 'JADOS Directory Fehler', 0

terr15:
 dc.b 'kein Dateiname angegeben', 0

terr16:
 dc.b 'Datei nicht vorhanden', 0

terr17:
 dc.b 'falsche Option', 0

terr18:
 dc.b 'keine Laufwerk angegeben', 0

terr19:
 dc.b 'Userspeicher ist voll', 0

terr20:
 dc.b 'JADOS Laufwerk nicht erreichbar', 0

terr21:
 dc.b 'JADOS Laufwerk ist voll', 0

terr22:
 dc.b 'JADOS Verzeichnis ist voll', 0

terr23:
 dc.b 'kein gültiges JADOS Laufwerk', 0

terr24:
 dc.b 'ungültige Laufwerks-Angabe', 0

terr25:
 dc.b 'ungültige Cluster Nummer', 0
 
terr26:
 dc.b 'Fehler beim konvertieren', 0
 
terr27:
 dc.b 'undefinierter Fehler', 0
 
terr28:
 dc.b 'Fehler im Parser bei Adressberechnung', 0

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
dc.b $0F,'ext. Partition (LBA, mehr als 1024 Zyl.)',0
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
dc.b $65,'Novell                                  ',0
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
dc.b $DB,'Concurrent DOS, CP/M, CTOS              ',0
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
        dc.b 'FD0', 0, 0, 0
fd1:
        dc.b 'FD1', 0, 0, 0
hda1:
        dc.b 'HDA1', 0, 0
hda2:
        dc.b 'HDA2', 0, 0
hda3:
        dc.b 'HDA3', 0, 0
hda4:
        dc.b 'HDA4', 0, 0
hda5:
        dc.b 'HDA5', 0, 0
hda6:
        dc.b 'HDA6', 0, 0
hda7:
        dc.b 'HDA7', 0, 0
hda8:
        dc.b 'HDA8', 0, 0
hda9:
        dc.b 'HDA9', 0, 0
hda10:
        dc.b 'HDA10', 0
hda11:
        dc.b 'HDA11', 0
hda12:
        dc.b 'HDA12', 0
hda13:
        dc.b 'HDA13', 0
hda14:
        dc.b 'HDA14', 0
hda15:
        dc.b 'HDA15', 0
hdb1:
        dc.b 'HDB1', 0, 0
hdb2:
        dc.b 'HDB2', 0, 0
hdb3:
        dc.b 'HDB3', 0, 0
hdb4:
        dc.b 'HDB4', 0, 0
hdb5:
        dc.b 'HDB5', 0, 0
hdb6:
        dc.b 'HDB6', 0, 0
hdb7:
        dc.b 'HDB7', 0, 0
hdb8:
        dc.b 'HDB8', 0, 0
hdb9:
        dc.b 'HDB9', 0, 0
hdb10:
        dc.b 'HDB10', 0
hdb11:
        dc.b 'HDB11', 0
hdb12:
        dc.b 'HDB12', 0
hdb13:
        dc.b 'HDB13', 0
hdb14:
        dc.b 'HDB14', 0
hdb15:
        dc.b 'HDB15', 0

ds 0

***** Hilfe Texte *****

hmdisk:
 dc.b 'Syntax: MDISK              ->  Listet verfügbare Laufwerke auf',13,10
 dc.b '        MDISK lw:          ->  Macht lw: zum aktiven Laufwerk',13,10,0
 ds 0

hmdir:
 dc.b 'Syntax: MDIR               ->  Liefert das Inhaltsverzeichnis',13,10
 dc.b '                               des aktiven Laufwerks',13,10
 dc.b '        MDIR name.ext      ->  Gibt ein eingeschränktes',13,10
 dc.b '                               Inhaltsverzeichnis aus',13,10
 dc.b '                               Wilscards ( *, ? ) sind möglich',13,10,0
 ds 0

hmcd:
 dc.b 'Syntax: MCD name           ->  Wechselt in das Unterverzeichnis',13,10
 dc.b '                               "name"',13,10
 dc.b '        MCD ..             ->  Wechsel in das übergeordnete',13,10
 dc.b '                               Verzeichnis',13,10
 dc.b '        MCD /              ->  Wechselt in das Root-Verzeichnis',13,10,0
 ds 0

hmcopy:
 dc.b 'Syntax: MCOPY lw:name.ext  ->  kopiert von JADOS nach FAT16',13,10
 dc.b '                               Wildcards ( *, ? ) sind möglich',13,10
 dc.b '        MCOPY name.ext lw: ->  kopiert von FAT16 nach JADOS',13,10
 dc.b '                               Wildcards ( *, ? ) sind möglich',13,10,0
 ds 0

hmload:
 dc.b 'Syntax: MLOAD name.ext     ->  Lädt die Datei "name.ext"',13,10
 dc.b '                               in den JADOS USER-Bereich',13,10,0
 ds 0

hmmd:
 dc.b 'Syntax: MMD name           ->  Erstellt das Unterverzeichnis',13,10
 dc.b '                               "name"',13,10,0
 ds 0

hmdel:
 dc.b 'Syntax: MDEL name.ext      ->  Löscht die Datei "name.ext"',13,10
 dc.b '                               Wildcards ( *, ? ) sind möglich',13,10,0
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

trapanz equ (trapend-traptab)/4         * Anzahl der Trap #10 Einträge


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
 dc.l   %00000000000000100000100100000000  * mcd     #3 H, Q, K
 dc.l   %00000000000000100000100100001010  * mcopy   #4 H, Q, A, K, C
 dc.l   %00000000000000100000100100000000  * mload   #5 H, Q, K
 dc.l   %00000000000000100000100100000010  * mmd     #6 H, Q, A, K
 dc.l   %00000000000000100000100100000010  * mdel    #7 H, Q, A, K
 dc.l   %00000000000000100000100100000010  * mformat #8 H, Q, A, K
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
 dc.l   terr9-errtab                    * kein freier Datei-Händel      9
 dc.l   terr10-errtab                   * DIR nicht löschbar            10
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
 dc.l   terr23-errtab                   * JADOS LW ungültig             23
 dc.l   terr24-errtab                   * ungültiges LW                 24
 dc.l   terr25-errtab                   * ungültiger Cluster            25
 dc.l   terr26-errtab                   * konvertierungs Fehler         26
 dc.l   terr27-errtab                   * undefinierter Fehler          27
 dc.l   terr28-errtab                   * fehlerhafte Adressberechnung  28
errend:

erranz  equ (errend-errtab)/4           * Anzahl der Fehler Einträge


nkctab:
 dc.b $db, $dc, $dd, $fb, $fc, $fd, $fe, 0
 ds 0

ibmtab:
 dc.b $c4, $d6, $dc, $e4, $f6, $fc, $df, 0
 ds 0


***** Diskparameter Master/Slave *****

numCyl          equ     0
numHead         equ     2
numSec          equ     3
Diskname        equ     4

typ1            equ     46              * FS Typ der Partition
typ2            equ     48              * Wort Grösse (Byte reicht auch)
typ3            equ     50
typ4            equ     52

starts1         equ     54              * Startsektor der Partition
starts2         equ     58              * Langwort
starts3         equ     62
starts4         equ     66

groesse1        equ     70              * Grösse der PART in Sektoren
groesse2        equ     74              * Langwort
groesse3        equ     78
groesse4        equ     82

NoAD            equ     86              * Name des akt. DIRs


** Boot-Parameter-Block

BPS             equ     0+128   * Bytes pro Sektor immer 512!!!        OFF=0x0B
SPC             equ     2+128   * Sektoren pro Cluster                 OFF=0x0D
RSC             equ     4+128   * Anzahl der reservierten Sektoren     OFF=0x0E
numFATs         equ     6+128   * Anzahl der FATs                      OFF=0x10
REC             equ     8+128   * Anzahl der Einträge im Root-Verz.    OFF=0x11
TotSec16        equ    10+128   * Gesamtzahl Sektoren 16 Bit           OFF=0x13
FATSz           equ    12+128   * Größe der FATs                       OFF=0x16
TotSec32        equ    14+128   * Gesamtzahl Sektoren 32 Bit           OFF=0x20

FATFrst         equ    18+128   * erster FAT Sektor
RootFrst        equ    22+128   * erster Root-DIR Sektor
DataFrst        equ    26+128   * erster Daten Sektor
TotSec          equ    30+128   * Sektoren gesamt
DataSec         equ    34+128   * Datensektoren gesamt
FATCurr         equ    38+128   * aktueller FAT-Sektor
eoClusCh        equ    42+128   * Endekennzeichen für Clusterchain
BPC             equ    46+128   * Bytes pro Cluster
lastSec         equ    50+128   * letzter Sektor des LWs
lastClus        equ    54+128   * letzter benutzbare Cluster
CntClust        equ    58+128   * Anzahl der Cluster

RtDrSec         equ    62+128   * Anzahl der Root-DIR Sektoren
FrstDIRC        equ    66+128   * Erster DIR Cluster


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
FDOff           equ      128            * Offset für File Discriptoren

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

***** DIR Einträge *****

DIRName         equ     $0              * Dateiname
DIRExt          equ     $8              * Dateierweiterung
DIRAttr         equ     $b              * Attribute
DIREZt          equ     $d              * Erstellungs Zeit 10tel Sek.
DIRLDt          equ     $e              * Datum letzter Zugriff (unbenutzt)
DIR1CH          equ     $14             * 1. Cluster high Word (FAT32)
DIRLCh          equ     $16             * Zeit letzte änderung
DIR1CL          equ     $1a             * Erster Cluster der Datei (low Word)
DIRSize         equ     $1c             * Grösse der Datei in Byte

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
JDatL           equ     26              * Dateilänge in Sektoren (1024 Byte)
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

slavflag        equ     0               * $ff = kein Slave vorhanden
msbyte          equ     2               * Master = $a0, Slave = $b0
hdbtfild        equ     4               * Bitfeld für LWs mit pa
aktlw           equ     8               * Nummer des aktiven
                                        * #0=FD0, #2=HDA1, #17=HDB1
FATStat         equ     10              * FAT Status Byte
JNAFlag         equ     12              * überschreiben? Byte
                                        * 0=nein, 1=ja, 2=alle
quiet           equ     14              * Ausgabe unterdrücken? Byte
                                        * 0=nein, 1=nur noch Fehler,
                                        * 2=alle unterdrücken
errnum          equ     16              * Fehlernummer Langwort
trace           equ     20              * Fehlersuche Langwort
ffpos           equ     24              * FindFile Fileposition
                                        * -1=nichts gefunden LW
ffsec           equ     28              * FindFile Sektor
ffclus          equ     32              * FindFile Cluster
ffsecc          equ     36              * FindFile Sektor-Count
convflag        equ     40              * Konvertierungs Flag Byte
                                        * 0 = nicht Konvertieren


***** VARIABLEN *****
VarStart:
ds 0
allgm:          ds.b 64                 * Allgemeine Variablen
parsdat:        ds.b 64                 * Parser Daten
master:         ds.b 256                * Masterdisk Parameter + BPB
slave:          ds.b 256                * Slavedisk Parameter + BPB
fatbuff:        ds.b 512                * FAT Puffer 1 Sektor
dirbuff:        ds.b 512                * DIR Puffer 1 Sektor
buffer:         ds.b 512                * Puffer für allgm. Verwendung
jfcb:           ds.b 48                 * JADOS FileControlBlock
jdirbuf:        ds.b 4096               * JADOS DIR Buffer
filebuff:       ds.b FDOff*maxofile     * File Buffer
VarEnd:

end
