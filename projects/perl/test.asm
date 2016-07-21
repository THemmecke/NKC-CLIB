clr.b FileAttr(a1)                     * Attribute = 0

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







bsr label1
bra label2
jsr label3
beq label4
beq.s label5
moveq.l #-1,d0
lea txt15spc(pc),a0 

cmp.b #'-',d0                  * '-' = Adresse-1
cmp.b #'-',d0


txtstern:
 dc.b ' *',0
 
  dc.b '                               Wilscards ( *,? ) sind müglich',13,10,0
  
  
**** DIR Eintrûge *****

DIRName         equ     $0              * Dateiname
DIRExt          equ     $8              * Dateierweiterung
DIRAttr         equ     $b              * Attribute
DIREZt          equ     $d              * Erstellungs Zeit 10tel Sek.
DIRLDt          equ     $e              * Datum letzter Zugriff (unbenutzt)
DIR1CH          equ     $14             * 1. Cluster high Word (FAT32)
DIRLCh          equ     $16             * Zeit letzte ûnderung
DIR1CL          equ     $1a             * Erster Cluster der Datei (low Word)
DIRSize         equ     $1c             * Grüsse der Datei in Byte


* KONSTANTEN

cpu     equ     4		* 1=68008, 2=68000, 4=68020
bank    equ     $ffffffc9*cpu   * Bankenregister

gpziel  equ $3C0000 
gpziel	equ	$3C0000	* fuer 68020 (4MB Vollausbau in NKC - 128K GP + 128KRAM hinter GP)
*gpziel	equ $....		* bei Verwendung der RAM Erweiterung und entsprechendem GP

bbziel   equ     $30000       * Zielbereich (RAM-Start) )für BBOOT Code (muss im RAM liegen)
							* RAM beginnt bei $20000 (>128KB)
				
gpstart equ     $200         * Startadresse des GP im EPROM (Offset $200 im EPROM)
gpsize  equ     $FFFE		* Laenge des GP in Worten(16Bit) = (128KB)


* Konstanten f. Seriell:
serbase         equ $FFFFFFF0*cpu	* Kommentar
control         equ $FFFFFFF3*cpu       * Kommentar 2
command         equ $FFFFFFF2*cpu 
status          equ $FFFFFFF1*cpu 
transmit        equ $FFFFFFF0*cpu 
receive         equ $FFFFFFF0*cpu 


*****

      ORG $0              	  * code fuer $0 erzeugen (EPROM)
      
      DC.L $11FFE              * dummy stack
      dc.l $11FFE              * dummy stack
      DC.L start                  * reset vector
  


