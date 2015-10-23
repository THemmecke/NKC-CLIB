#ifndef __LLNKC_N
#define __LLNKC_H


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
/*  -------------------------- VERSCH. HILFS FUNKTIONEN ------------------------------- */ 	
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
