#ifndef __LLNKC_N
#define __LLNKC_H

#include <types.h>

/*    --------- AUFRUFE IN's GRUNDPROGRAMM ----------  */
void nkc_clrscr(void); 	
void nkc_write(const char* message);
void nkc_write_hex2(unsigned char val);  	  
void nkc_write_hex8(unsigned int val);
void nkc_write_dec_dw(unsigned int val);
char nkc_getchar(void);
void nkc_putchar(char c);
void nkc_getxy(unsigned char *x, unsigned char *y);
void nkc_setxy(unsigned char x, unsigned char y);
void nkc_curoff(void);
void nkc_curon(void);
unsigned char nkc_kbhit(void);

void nkc_setflip(unsigned char flip2pages, unsigned char flip4pages);
void nkc_setpage(unsigned char writepage, unsigned char viewpage);

void nkc_read(unsigned char x, unsigned char y, char* buffer);


/* -------- AUFRUFE NACH JADOS --------------------------------*/

/* FCB */

struct jdfcb {
	unsigned short 	lw;		/* 00..01 */
	char 		filename[8];	/* 02..09 */
	unsigned short 	reserverd01;	/* 10..11 */
	char 		fileext[3];	/* 12..14 */
	unsigned char 	reserved02;	/* 15 	  */
	unsigned short 	starttrack;	/* 16..17 */ // Nummer des ersten Track
	unsigned short 	endsec;		/* 18..19 */ // Nummer des letzten Sektors im letzten Track (Track-relativ ! 10 sectors/track bei HD und 5 sec/track bei FD))
	unsigned short 	endbyte;	/* 20..21 */ // immer 0
	unsigned int	date;		/* 22..25 */
	unsigned short 	length;		/* 26..27 */ // Laenge in Sektoren
	unsigned char 	mode;		/* 28     */ // 0xE4 read only, 0xE5 read/write (wird von Jados nicht korrekt gesetzt (immer E5)!!)
	unsigned short 	reserved03;	/* 29..30 */
	unsigned char   reserved04;	/* 31     */
	unsigned short  dirsec;		/* 32..33 */
	unsigned short  dirbyte;	/* 34..35 */
	unsigned short  status;		/* 36..37 */
	unsigned short  curtrack;	/* 38..39 */ // aktueller Track (Track-Relativ !)
	unsigned short  cursec;		/* 40..41 */ // aktueller Sector innerhalb des Tracks
	unsigned short  lasttrack;	/* 42..43 */ // letzter Track
	unsigned char   *pbuffer;	/* 44..47 */	
} __attribute__ ((packed));				/* otherwise datafields would be aligned ... */

UCHAR _nkc_fillfcb(struct jdfcb *FCB,char *name);
UCHAR _nkc_open(struct jdfcb *FCB);
UCHAR _nkc_create(struct jdfcb *FCB);
void _nkc_close(struct jdfcb *FCB);
UCHAR _nkc_erase(struct jdfcb *FCB);
UCHAR _nkc_readrec(struct jdfcb *FCB);
UCHAR _nkc_writerec(struct jdfcb *FCB);
UCHAR _nkc_setrec(struct jdfcb *FCB, int sector);
void _nkc_setdta(struct jdfcb *FCB, void* buffer);
int _nkc_remove(char *name);
int _nkc_rename(char *old , char *new);
int _nkc_get_drive();
void _nkc_set_drive(int drive);
BYTE _nkc_directory(void* pbuf, void* ppattern, BYTE attrib, WORD columns, WORD size);
BYTE _nkc_directory_test(void* pbuf, void* ppattern, BYTE attrib, WORD columns, WORD size);
void* _nkc_get_ramtop(void);
void* _nkc_get_laddr(void);
void* _nkc_get_gp(void);

/*  -------------------------- VERSCH. HILFS FUNKTIONEN ------------------------------- */ 	

void cli();
void sti();

/*
 unsigned char nkc_bcd2bin(unsigned char val)
*/	 
unsigned char nkc_bcd2bin(unsigned char val);
/*
 unsigned char nkc_bin2bcd(unsigned char val)
*/	
unsigned char nkc_bin2bcd(unsigned char val);
/*
 unsigned char nkc_cmos_read(unsigned char index)
*/	
unsigned char nkc_cmos_read(unsigned char index);

#endif	
