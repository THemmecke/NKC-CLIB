.text

#include "test.global"
clr.b FileAttr(%a1)                     /*  Attribute = 0 */

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







jbsr label1
jra label2
jbsr label3
jeq label4
jeq label5
move.l #-1,%d0
lea txt15spc(%pc),%a0 

 cmp.b #/*'-',%d0                  * '-'*/0x2d272c2564302020202020202020202020202020202020202a20272d = Adresse-1
cmp.b #'-',%d0


txtstern:

   .ascii " *"    
   .byte 0


   .ascii "                               Wilscards ( *,? ) sind müglich"
   .byte 13,10,0


 /* *** DIR Eintrûge ***** */

    .equ DIRName        , 0x0              /*  Dateiname */
    .equ DIRExt         , 0x8              /*  Dateierweiterung */
    .equ DIRAttr        , 0xb              /*  Attribute */
    .equ DIREZt         , 0xd              /*  Erstellungs Zeit 10tel Sek. */
    .equ DIRLDt         , 0xe              /*  Datum letzter Zugriff (unbenutzt) */
    .equ DIR1CH         , 0x14             /*  1. Cluster high Word (FAT32) */
    .equ DIRLCh         , 0x16             /*  Zeit letzte ûnderung */
    .equ DIR1CL         , 0x1a             /*  Erster Cluster der Datei (low Word) */
    .equ DIRSize        , 0x1c             /*  Grüsse der Datei in Byte */


 /*  KONSTANTEN */

    .equ cpu    , 4	 /*  1=68008, 2=68000, 4=68020 */
    .equ bank   , 0xffffffc9*cpu   /*  Bankenregister */

    .equ gpziel , 0x3C0000 
    .equ gpziel, 0x3C0000 /*  fuer 68020 (4MB Vollausbau in NKC - 128K GP + 128KRAM hinter GP) */
 /* gpziel	equ $....		* bei Verwendung der RAM Erweiterung und entsprechendem GP */

    .equ bbziel  , 0x30000       /*  Zielbereich (RAM-Start) )für BBOOT Code (muss im RAM liegen) */
						 /*  RAM beginnt bei 0x20000 (>128KB) */

    .equ gpstart, 0x200         /*  Startadresse des GP im EPROM (Offset 0x200 im EPROM) */
    .equ gpsize , 0xFFFE	 /*  Laenge des GP in Worten(16Bit) = (128KB) */


 /*  Konstanten f. Seriell: */
    .equ serbase        , 0xFFFFFFF0*cpu /*  Kommentar */
    .equ control        , 0xFFFFFFF3*cpu       /*  Kommentar 2 */
    .equ command        , 0xFFFFFFF2*cpu 
    .equ status         , 0xFFFFFFF1*cpu 
    .equ transmit       , 0xFFFFFFF0*cpu 
    .equ receive        , 0xFFFFFFF0*cpu 




  .org  0x0              	  /*  code fuer 0x0 erzeugen (EPROM) */

   .long        0x11FFE              /*  dummy stack */
   .long        0x11FFE              /*  dummy stack */
   .long        start                  /*  reset vector */



