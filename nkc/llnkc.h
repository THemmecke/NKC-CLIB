#ifndef __LLNKC_N
#define __LLNKC_H

#include <types.h>

/* ******************************************* native routines ******************************************* */
	
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


void nkc_init_ser1(unsigned char control, unsigned char command);
char nkc_ser1_getchar(void);
void nkc_ser1_putchar(char c);
void nkc_ser1_write(char *str);

/* ******************************************* calls to GRUNDPROGRAMM  (TRAP #1) ******************************************* */

void gp_ser1_write_dec_dw(unsigned int val); 
void gp_ser1_write_hex8(unsigned int val);

void gp_clrscr(void); 	
void gp_write(const char* message);
void gp_write_hex2(unsigned char val);  	  
void gp_write_hex8(unsigned int val);
void gp_write_dec_dw(unsigned int val);
char gp_getchar(void);
void gp_putchar(char c);
void gp_getxy(unsigned char *x, unsigned char *y);
void gp_setxy(unsigned char x, unsigned char y);
void gp_curoff(void);
void gp_curon(void);
unsigned char gp_kbhit(void);

void gp_setflip(unsigned char flip2pages, unsigned char flip4pages);
void gp_setpage(unsigned char writepage, unsigned char viewpage);

void gp_read(unsigned char x, unsigned char y, char* buffer);

#ifdef USE_JADOS
/* ******************************************* call to JADOS (TRAP #6) ******************************************* */

/* FCB */

struct jdfcb {
	unsigned short 	lw;		/* 00..01 */
	char 		filename[8];	/* 02..09 */
	unsigned short 	reserverd01;	/* 10..11 */
	char 		fileext[3];	/* 12..14 */
	unsigned char 	reserved02;	/* 15 	  */
	unsigned short 	starttrack;	/* 16..17 */ // number of first track
	unsigned short 	endsec;		/* 18..19 */ // number of last sector in last track  (track relative ! 10 sectors/track with HD and 5 sec/track with FD))
	unsigned short 	endbyte;	/* 20..21 */ // always 0
	unsigned int	date;		/* 22..25 */
	unsigned short 	length;		/* 26..27 */ // filelength in sectors
	unsigned char 	mode;		/* 28     */ // 0xE4 read only, 0xE5 read/write (not used correctly in current JADOS (always 0xE5)!!)
	unsigned short 	reserved03;	/* 29..30 */
	unsigned char   reserved04;	/* 31     */
	unsigned short  dirsec;		/* 32..33 */
	unsigned short  dirbyte;	/* 34..35 */
	unsigned short  status;		/* 36..37 */
	unsigned short  curtrack;	/* 38..39 */ // current track (Track-Relativ !)
	unsigned short  cursec;		/* 40..41 */ // current sector in current track (track relative)
	unsigned short  lasttrack;	/* 42..43 */ // last track
	unsigned char   *pbuffer;	/* 44..47 */	
} __attribute__ ((packed));				/* otherwise datafields would be aligned ... */


UCHAR jd_fillfcb(struct jdfcb *FCB,char *name);
UCHAR jd_open(struct jdfcb *FCB);
UCHAR jd_create(struct jdfcb *FCB);
void jd_close(struct jdfcb *FCB);
UCHAR jd_erase(struct jdfcb *FCB);
UCHAR jd_readrec(struct jdfcb *FCB);
UCHAR jd_writerec(struct jdfcb *FCB);
UCHAR jd_setrec(struct jdfcb *FCB, int sector);
void jd_setdta(struct jdfcb *FCB, void* buffer);
int jd_remove(char *name);
int jd_rename(char *old , char *new);
int jd_get_drive();
void jd_set_drive(int drive);
BYTE jd_directory(void* pbuf, void* ppattern, BYTE attrib, WORD columns, WORD size);
BYTE jd_directory_test(void* pbuf, void* ppattern, BYTE attrib, WORD columns, WORD size);
void* jd_get_ramtop(void);
void* jd_get_laddr(void);
void* jd_get_gp(void);
#endif


#endif	
