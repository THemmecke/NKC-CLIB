#ifndef __NKC_H
#define __NKC_H

/* 2 (68000), 4 (68020) */
#ifdef M68000
#define cpu 2
#endif

#ifdef M68020 
#define cpu  4
#endif


/* TRAP-NUMMERN DES GP TRAP #1 (V7.0) */

#define _SCHREITE    1   
#define _DREHE       2   
#define _HEBE        3   
#define _SENKE       4   
#define _FIGURXY     5   
#define _WRITELF     6   
#define _SET         7   
#define _MOVETO      8   
#define _DRAWTO      9   
#define _WRITE       10  
#define _READ        11  
#define _CI          12  
#define _CSTS        13  
#define _RI          14  
#define _PO          15  
#define _CLR         16  
#define _CLPG        17  
#define _WAIT        18  
#define _SCHR16TEL   19  
#define _CLRSCREEN   20  
#define _CO          21  
#define _LO          22  
#define _SIN         23  
#define _COS         24  
#define _SIZE        25  
#define _CMD         26  
#define _NEWPAGE     27  
#define _SYNC        28  
#define _WERT        29  
#define _ZUWEIS      30  
#define _CIINIT2     31  
#define _CI2         32  
#define _CO2         33  
#define _SETFLIP     34  
#define _DELAY       35  
#define _FIRSTTIME   36  
#define _SETPEN      37  
#define _ERAPEN      38  
#define _GRAPOFF     39  
#define _CMDPRINT    40  
#define _PRINT2X     41  
#define _PRINT4X     42  
#define _PRINT6X     43  
#define _PRINT8X     44  
#define _PRINT8B     45  
#define _PRINT4D     46  
#define _HIDE        47  
#define _SHOW        48  
#define _CRT         49  
#define _LST         50  
#define _USR         51  
#define _NIL         52  
#define _SETERR      53  
#define _GETERR      54  
#define _SETPASS     55  
#define _EDIT        56  
#define _FIGUR       57  
#define _SETFIG      58  
#define _GETRAM      59  
#define _AUTOFLIP    60  
#define _CURSEIN     61  
#define _CURSAUS     62  
#define _CHAR        63  
#define _PROGZGE     64  
#define _ASSEMBLE    65  
#define _GETSTX      66  
#define _PUTSTX      67  
#define _GETORG      68  
#define _PUTORG      69  
#define _PRINT8D     70  
#define _PRINTV8D    71  
#define _MULS32      72  
#define _DIVS32      73  
#define _FLINIT      74  
#define _FLOPPY      75  
#define _GETFLOP     76  
#define _SETXOR      77  
#define _GETXOR      78  
#define _SETCOLOR    79  
#define _GETCOLOR    80  
#define _CURON       81  
#define _CUROFF      82  
#define _ADJ360      83  
#define _PRTSYM      84  
#define _SYMCLR      85  
#define _GETSYM      86  
#define _GETNEXT     87  
#define _PUTNEXT     88  
#define _GETBASIS    89  
#define _GETVAR      90  
#define _SETA5       91  
#define _AUFXY       92  
#define _KORXY       93  
#define _AUFK        94  
#define _GETK        95  
#define _RND         96  
#define _GETVERS     97  
#define _GETSN       98  
#define _CRLF        99  
#define _GETLINE     100 
#define _GETCURXY    101 
#define _SETCURXY    102 
#define _GETXY       103 
#define _SI          104 
#define _SO          105 
#define _SISTS       106 
#define _SOSTS       107 
#define _SIINIT      108 
#define _GETAD8      109 
#define _GETAD10     110 
#define _SETDA       111 
#define _SPEAK       112 
#define _SPEAK1      113 
#define _SOUND       114 
#define _GETUHR      115 
#define _SETUHR      116 
#define _LSTS        117 
#define _RELAN       118 
#define _RELAUS      119 
#define _ASSERR      120 
#define _PRINTFP0    121 
#define _GETFLOAT    122 
#define _READAUS     123 
#define _GRUND       124 
#define _HARDCOPY    125 
#define _GRAFIK      126 
#define _GDPVERS     127 
#define _SER         128 
#define _CO2SER      129 
#define _CLUTINIT    130 
#define _CLUT        131 
#define _RELAIS      132 
#define _RELAISIN    133 
#define _SETDA12     134 
#define _GETAD12     135 
#define _DISASS      136 
#define _SUCHBIBO    137 
#define _SI2         138 
#define _SYSTEM      139 
#define _UHRPRINT    140 
#define _HARDDISK    141 
#define _HARDTEST    142 
/*#define _            143 
#define _            144   */
#define _PRTFP0      145 
#define _FPUWERT     146 
#define _SETFPX      147 
#define _SETFPY      148 
#define _SETFPZ      149 
#define _SETSER      150 
#define _GETSER      151 
#define _SETS2I      152 
#define _GETS2I      153 
#define _IDETEST     154 
#define _IDEDISK     155 
#define _SRDISK      156 
#define _SETF2S      157 
#define _GETF2S      158 
#define _GETSRD      159 
#define _SETSYS      160 
#define _GETSYS      161 
#define _PATCH       162 
/* SD-Card */
#define _SDTEST      163
#define _SDDISK      164
/* misc */
#define _SETCHAR     165
#define _SETTRANS    166
#define _GETTRANS    167


#ifdef USE_JADOS
/* JADOS 3.4 TRAPS (TRAP #6) */

#define __getleng 	0
#define __getname 	1
#define __getstadd 	2
#define __lese		3
#define __loadtext	4
#define __motoroff	5
#define __response	6
#define __schreibe	7
#define __strgcomp	8
#define __tload		9
#define __tsave		10
#define __uppercas	11
#define __wrblank	12
#define __wrint		13
#define __close		14
#define __copyfile	15
#define __create	16
#define __erase		17
#define __fillfcb	18
#define __open		19
#define __readrec	20
#define __rename	21
#define __setdta	22
#define __writerec	23
#define __getversi	24
#define __getparm	25
#define __hardcopy	26
#define __bell		27
#define __beep		28
#define __errnoise	29
#define __sound		30
#define __inport	31
#define __outport	32
#define __movelbin	33
#define __moveltxt	34
#define __moverbin	35
#define __wrtcmd	36
#define __gtretcod	37
#define __stretcod	38
#define __moveline	39
#define __wraddr	40
#define __ci		41
#define __getparm1	42
#define __getparm2	43
#define __fileload	44
#define __filesave	45
#define __getparm3	46
#define __getparm4	47
#define __loadpart	48
#define __savepart	49
#define __catalog	50
#define __floppy	51
#define __drivecod	52
#define __getdrive	53
#define __setdrive	54
#define __gttraptb	55
#define __blockread	56
#define __blockwrit	57
#define __getladdr	58
#define __skipchar	59
#define __delete	60
#define __insert	61
#define __ramtop	62
#define __getuhr	65
#define __setufr	66
#define __date		67
#define __time		68
#define __datim		69
#define __setdatim	70
#define __fileinfo	71
#define __diskinfo	72
#define __wrlint	73
#define __directory	74
#define __table		75
#define __respinfo	76
#define __lineedit	77
#define __getcpu	78
#define __getclock	79
#define __getgrund	80
#define __getsound	81
#define __getdisks	82
#define __chmod		83
#define __gtcmdtab	84
#define __getdpath	85
#define __clrovert	86
#define __setovwrt	87
#define __asctonum	88
#define __numtoasc	89
#define __gethdisk	90
#define __loadauto	91
#define __cmdexec	92
#define __setrec	93
#endif


/* ----------------------------------------------------------------------------- (G)IDE ------------------------------------------------------------------------------------------------------------- */

/*
	A3	/A3	A2	A1	A0															10 (GIDE BASE)
	C1	C0					register								variable	address
	1	0	0	0	0		data i/o								idedat		18
	1	0	0	0	1		error									ideerr		19
	1	0	0	1	0		sector count							        idescnt		1A
	1	0	0	1	1		start sector	LBA[0..7]						idesnum		1B
	1	0	1	0	0		cylinder low byte LBA[8..15]						ideclo		1C
	1	0	1	0	1		cylinder high byte LBA[16.23]						idechi		1D
	1	0	1	1	0		head and device	LBA[24..27]						idesdh		1E
	1	0	1	1	1		command/status							        idecmd		1F
	0	1	1	1	0		2nd status/interrupt/reset				                idesir		16 
	0	1	1	1	1		active status of the IDE device			                        idestat		17 
	
	
-	head and device register (idesdh)
	========================
	A write register that sets the master/slave selection and the head number.

	bits 3..0: head number [0..15]
	bit  4   : master/slave select: 0=master,1=slave
	bits 7..5: fixed at 101B. This is in fact the bytes/sector
           coding. In old (MFM) controllers you could specify if
           you wanted 128,256,512 or 1024 bytes/sector. In the
           IDE world only 512 bytes/sector is supported. This bit
           pattern is a relic from the MFM controllers age. The
           bit 6 of this pattern could in fact be used to access
           a disk in LBA modus.

-	Status register (idecmd)
	===============
	Both the primary and secondary status register use the same bit coding. The register is a read register.

	bit 0 : error bit. If this bit is set then an error has
   	        occurred while executing the latest command. The error
           	status itself is to be found in the error register.
	bit 1 : index pulse. Each revolution of the disk this bit is
           pulsed to '1' once. I have never looked at this bit, I
           do not even know if that really happens.
	bit 2    : ECC bit. if this bit is set then an ECC correction on
           the data was executed. I ignore this bit.
	bit 3    : DRQ bit. If this bit is set then the disk either wants
           data (disk write) or has data for you (disk read).
	bit 4    : SKC bit. Indicates that a seek has been executed with
           success. I ignore this bit.
	bit 5    : WFT bit. indicates a write error has happened. I do
           not know what to do with this bit here and now. I've
           never seen it go active.
	bit 6    : RDY bit. indicates that the disk has finished its
           power-up. Wait for this bit to be active before doing
           anything (execpt reset) with the disk. I once ignored
           this bit and was rewarded with a completely unusable
           disk.
	bit 7    : BSY bit. This bit is set when the disk is doing
           something for you. You have to wait for this bit to
           clear before you can start giving orders to the disk.


-	interrupt and reset register (idesir)
	============================
	This register has only two bits that do something (that I know of). It is a write register.
        bit 0           : = 0
	bit 1    : IRQ enable. If this bit is '0' the disk will give and
           IRQ when it has finished executing a command. When it
           is '1' the disk will not generate interrupts.
	bit 2    : RESET bit. If you pulse this bit to '1' the disk will
           execute a software reset. The bit is normally '0'. I
           do not use it because I have full software control of
           the hardware /RESET line.

-	Active status register
	======================
	This is a read register. I have -up till now- ignored this register. I have only one IDE device (a 	disk) on my contraption.

	bit 0    : master active. If this bit is set then the master IDE
           device is active.
	bit 1    : slave active. If this bit is set then the slave IDE
           device is active.
	bits 5..2: complement of the currently active disk head.
	bit 6    : write bit. This bit is set when the device is writing.
	bit 7    : in a PC environment this bit indicates if a floppy is
           present in the floppy drive. Here it has no meaning.

-	error register
	==============
	The error register indicates what went wrong when a command execution results in an error. The fact that an error has occurred is indicated in the status register, the explanation is given in the error register. This is a read register.

	bit 0    : AMNF bit. Indicates that an address mark was not
           found. What this means I not sure of. I have never
           seen this happen.
	bit 1    : TK0NF bit. When this bit is set the drive was not able
           to find track 0 of the device. I think you will have
           to throw away the disk if this happens.
	bit 2    : ABRT bit. This bit is set when you have given an
           indecent command to the disk. Mostly wrong parameters
           (wrong head number etc..) cause the disk to respond
           with error flag in the status bit set and the ABRT bit
           set. I have gotten this error a lot when I tried to
           run the disk with interrupts. Something MUST have been
           wrong with my interface program. I have not (yet)
           found what.
	bit 3    : MCR bit. indicated that a media change was requested.
           What that means I do not know. I've ignored this bit
           till now.
	bit 4    : IDNF bit. Means that a sector ID was not found. I have
           never seen this happen, I guess it means that you've
           requested a sector that is not there.
	bit 5    : MC bit. Indicates that the media has been changed. I
           ignore this bit.
	bit 6    : UNC bit. Indicates that an uncorrectable data error
           happened. Some read or write errors could provoke
           this. I have never seen it happen.
	bit 7    : reserved.


*/

#define 	idebase  0xffffff10*cpu


#define 	idedor  0xffffff16*cpu
/* data register */
#define 	idedat  0xffffff18*cpu
/* error regsiter */
#define 	ideerr  0xffffff19*cpu
/* sector count register */
#define 	idescnt 0xffffff1A*cpu
/* sector number register */
#define 	idesnum 0xffffff1B*cpu
/* cluster low register */
#define 	ideclo  0xffffff1C*cpu
/* cluster high regsiter */
#define 	idechi  0xffffff1D*cpu
/* head/device regsiter */
#define 	idesdh  0xffffff1E*cpu
/* command register */
#define 	idecmd  0xffffff1F*cpu
/* isecond status / interrupt / reset register */
#define 	idesir	0xffffff16*cpu
/* active status register */
#define 	idestat	0xffffff17*cpu


/* GIDE commands (_IDEDISK) */

#define _IDEDISK_CMD_READ	1
#define _IDEDISK_CMD_WRITE 	2
#define _IDEDISK_CMD_TEST_UNIT_READY 8
#define _IDEDISK_CMD_READ_CAPACITY 22
#define _IDEDISK_CMD_INQUIRY 24

/* -------------------------------------------------------------------------SPI/SDCARD ------------------------------------------------------------------------------------------------------------- */

/*
			FPGA(LFXP6C)
SD0_DI		SD_MOSI_o	21
SD0_DO		SD_MISO_i	18
SD0_CS 		SD_nCS_o	22
SD0_SCLK	SD_SCK_o 	20

constant SPI_BASE_ADDR_c    : std_logic_vector(7 downto 0) := X"00"; -- r/w 
s_spi_cs <= not nIORQ when wbm_address(7 downto 1) =  SPI_BASE_ADDR_c(7 downto 1) else '0';
=> SPI == 00..01

$FFFFFF00 - SPI-Control-Register
Schreiben
7 6 5 4 3 2 1 0
| | | | | | | |
| | | | | ------- Clockdivider
| | | | | 000 = 40MHz/1  => 40,0MHz
| | | | | 001 = 40MHz/2  => 20,0MHz
| | | | | 011 = 40MHz/7  =>  5,7MHz
| | | | | 111 = 40MHz/16 =>  2,5MHz
| | | | --------- SCK IDLE Level (1=stop clk at high level)
| | | ----------- frei
| --------------- Slave Select
| 01 = Slave 0, 10 = Slave 1
----------------- SPI-Controller enable
Lesen
7 6 5 4 3 2 1 0
| | | | | | | |
| | | | | | | --- IDLE 1 = Controler bereit für Daten
| | | | | | ----- Write Collision 1 = Datenverlust
----------------- frei

$FFFFFF01 - SPI-Daten-Register

---------------------------------------------------

SD-Card Specifications:


Information Registers:

Name 	Width 	Description
CID 	128 	Card identification number; card individual number for identification (See 5.2). Mandatory.
RCA1 	16 		Relative card address; local system address of a card, dynamically suggested by
				the card and approved by the host during initialization (See 5.4). Mandatory.
DSR 	16 		Driver Stage Register; to configure the card’s output drivers (See 5.5). Optional.
CSD 	128 	Card Specific Data; information about the card operation conditions (See 5.3). Mandatory
SCR 	64 		SD Configuration Register; information about the SD Memory Card’s Special Features
				capabilities (See 5.6). Mandatory
OCR 	32 		Operation conditions register (See 5.1). Mandatory.
SSR 	512 	SD Status; information about the card proprietary features (See 4.10.2). Mandatory
CSR 	32 		Card Status; information about the card status (See 4.10.1). Mandatory



*/

#ifndef spibase
#define		spibase	0xffffff00*cpu
#endif
#ifndef spictrl
#define		spictrl 0xffffff00*cpu
#endif
#ifndef spidata
#define		spidata 0xffffff01*cpu
#endif

/*  CS der ersten Hardware SD */
#define		SPIH0_CS 5
/*  CS der zweiten Hardware SD */
#define		SPIH1_CS 6             

/* SD commands */

/* SD commands (TRAP _SDDISK) */

#define _SDDISK_CMD_READ	1
#define _SDDISK_CMD_WRITE 	2
#define _SDDISK_CMD_TEST_UNIT_READY 8
#define _SDDISK_CMD_READ_CAPACITY 22
#define _SDDISK_CMD_INQUIRY 24

//extern char SDTYPE[];	-> sd_block_drv.c

/* ----------------------------------------------------------------------------- RTC 12887 ------------------------------------------------------------------------------------------------------------- */


#define RTC_DS12887_INDEX       0xfffffffa*cpu
#define RTC_DS12887_DATA        0xfffffffb*cpu

/**********************************************************************
 * register summary
 **********************************************************************/
#define RTC_SECONDS		0
#define RTC_SECONDS_ALARM	1
#define RTC_MINUTES		2
#define RTC_MINUTES_ALARM	3
#define RTC_HOURS		4
#define RTC_HOURS_ALARM		5
/* RTC_*_alarm is always true if 2 MSBs are set */
# define RTC_ALARM_DONT_CARE 	0xC0

#define RTC_DAY_OF_WEEK		6
#define RTC_DAY_OF_MONTH	7
#define RTC_MONTH		8
#define RTC_YEAR		9
#define RTC_CENTURY		50

/* control registers - Moto names
 */
#define RTC_REG_A		10
#define RTC_REG_B		11
#define RTC_REG_C		12
#define RTC_REG_D		13


#define RTC_ALWAYS_BCD  1


/* ----------------------------------------------------------------------------- TIMER ------------------------------------------------------------------------------------------------------------- */

#define TIMER1_BASE       0xFFFFFFF4*cpu
#define TIMER1_CTRL       0xFFFFFFF4*cpu
#define TIMER1_HI         0xFFFFFFF5*cpu
#define TIMER1_LO         0xFFFFFFF6*cpu	

/* ----------------------------------------------------------------------------- FLOPPY ------------------------------------------------------------------------------------------------------------- */

#define FLO_COMMAND         0xFFFFFFC0*cpu
#define FLO_TRACK           0xFFFFFFC1*cpu
#define FLO_SECTOR          0xFFFFFFC2*cpu
#define FLO_DATA            0xFFFFFFC3*cpu
#define FLO_CTRL            0xFFFFFFC4*cpu

/* ----------------------------------------------------------------------------- SERIAL ------------------------------------------------------------------------------------------------------------- */

/*
 * 
 * control register definition
 * ---------------------------
 * bit
 * 7		stop bits	0=1, 1=2, (1 if wordlength=8 and parity)
 * 6 5		word length	00=8, 01=7, 10=6, 11=5
 * 4		clock source	0=external, 1=internal baud rate generator
 * 3210		baud rate	0000=16x external clock
 * 				0001=50
 * 				0010=75
 * 				0011=109,92 (115200 using GDP-FPGA)
 * 				0100=134,58 (57600 using GDP-FPGA)
 * 				0101=150 (38400 usinf GDP-FPGA)
 * 				0110=300
 * 				0111=600
 * 				1000=1200
 * 				1001=1800
 * 				1010=2400
 * 				1011=3600
 * 				1100=4800
 * 				1101=7200
 * 				1110=9600
 * 				1111=1920
 * 
 * 8N1,9600 => 0001 1110 = 0x1e
 * 8N1, 115200 => 0001 0011 = 0x13
 * 
 * 
 * command register definitions
 * ----------------------------
 * bit
 * 7		parity check cntrl:
 * 		--0 : parity check disabled
 * 		001 : odd parity receiver and transmitter
 * 		011 : even parity receiver and transmitter
 *		101 : mark parity bit transmitted, parity check disabled
 *		111 : space parity bit transmitted, parity check disabled
 * 4		0 = normal mode, 1 = echo mode (bit 2 = bit 3 = 0)
 * 3 2		transmitter controls:
 * 			transmit INT 	/RTS level	transmitter
 * 		00:	 disabled	 high		 off
 * 		01:	 enabled	 low		 on
 * 		10:	 disabled	 low		 on
 * 		11:	 disabled	 low		 transmit brk
 * 1		0 = IRQ enabled from bit 3 of status register, 1 = disable IRQ
 * 0		1 = enable receiver and all interrupts
 * 
 * no parity, receive/transmit enable, disable IRQ, no echo => 0000 1011 = 0x0b
 * 
 * 
 * status register definitions
 * ---------------------------
 * 
 * bit
 * 7		0 = no INT, 1 = INT 
 * 6		0 = DSR low, 1 = DSR high
 * 5		0 = DCD low, 1 = DCD high
 * 4		1 = transmit data register empty
 * 3		1 = receive data register full
 * 2		1 = overrun error
 * 1		1 = framing error
 * 0		1 = parity error
 * 
 */ 

#define NKC_SER1_BASE        0xFFFFFFF0*cpu
#define NKC_SER1_CTRL        0xFFFFFFF3*cpu
#define NKC_SER1_CMD         0xFFFFFFF2*cpu
#define NKC_SER1_STAT        0xFFFFFFF1*cpu
#define NKC_SER1_TX          0xFFFFFFF0*cpu
#define NKC_SER1_RX          0xFFFFFFF0*cpu




/* ----------------------------------------------------------------------------- KEYBOARD ------------------------------------------------------------------------------------------------------------- */

#define NKC_KEY_STATUS	     0xffffff67*cpu
#define NKC_KEY_DATA         0xffffff68*cpu
#define NKC_KEY_DIP          0xffffff69*cpu


/* ----------------------------------------------------------------------------- GDP ------------------------------------------------------------------------------------------------------------- */

/* --> gdplib/nkc_gdplib.h */

#endif

