#ifndef __GDP_H
#define __GDP_H

#define GDP_64   0
#define GDP_64HS 0
#define GDP_FPGA 1

#define u8 unsigned char

#ifdef M68008
#define GDP_BASE   (*(volatile u8 *)  0xffffff70)
#define GDP_STATUS (*(volatile u8 *)  0xffffff70)
#define GDP_CMD    (*(volatile u8 *)  0xffffff70)
#define GDP_CTRL1  (*(volatile u8 *)  0xffffff71)
#define GDP_CTRL2  (*(volatile u8 *)  0xffffff72)
#define GDP_CSIZE  (*(volatile u8 *)  0xffffff73)
#define GDP_RES1   (*(volatile u8 *)  0xffffff74)
#define GDP_DELTAX (*(volatile u8 *)  0xffffff75)
#define GDP_RES2   (*(volatile u8 *)  0xffffff76)
#define GDP_DELTAY (*(volatile u8 *)  0xffffff77)
#define GDP_X_MSB  (*(volatile u8 *)  0xffffff78)
#define GDP_X_LSB  (*(volatile u8 *)  0xffffff79)
#define GDP_Y_MSB  (*(volatile u8 *)  0xffffff7A)
#define GDP_Y_LSB  (*(volatile u8 *)  0xffffff7B)
#define GDP_XLP    (*(volatile u8 *)  0xffffff7C)
#define GDP_YLP    (*(volatile u8 *)  0xffffff7D)
#define GDP_RES3   (*(volatile u8 *)  0xffffff7E)
#define GDP_RES4   (*(volatile u8 *)  0xffffff7F)

#define GDP_PAGE   (*(volatile u8 *)  0xffffff60)
#define GDP_SCROLL (*(volatile u8 *)  0xffffff61)

#define GDP_CPORT_FG  (*(volatile u8 *)  0xffffffA0)
#define GDP_CPORT_BK  (*(volatile u8 *)  0xffffffA1)

#define GDP_CLUT_A       (*(volatile u8 *)  0xffffffa4)
#define GDP_CLUT_H       (*(volatile u8 *)  0xffffffa5)
#define GDP_CLUT_L       (*(volatile u8 *)  0xffffffa6)

#elif defined M68000
#define GDP_BASE   (*(volatile u8 *)  0xfffffee0)
#define GDP_STATUS (*(volatile u8 *)  0xfffffee0)
#define GDP_CMD    (*(volatile u8 *)  0xfffffee0)
#define GDP_CTRL1  (*(volatile u8 *)  0xfffffee2)
#define GDP_CTRL2  (*(volatile u8 *)  0xfffffee4)
#define GDP_CSIZE  (*(volatile u8 *)  0xfffffee6)
#define GDP_RES1   (*(volatile u8 *)  0xfffffee8)
#define GDP_DELTAX (*(volatile u8 *)  0xfffffeea)
#define GDP_RES2   (*(volatile u8 *)  0xfffffeec)
#define GDP_DELTAY (*(volatile u8 *)  0xfffffeee)
#define GDP_X_MSB  (*(volatile u8 *)  0xfffffef0)
#define GDP_X_LSB  (*(volatile u8 *)  0xfffffef2)
#define GDP_Y_MSB  (*(volatile u8 *)  0xfffffef4)
#define GDP_Y_LSB  (*(volatile u8 *)  0xfffffef6)
#define GDP_XLP    (*(volatile u8 *)  0xfffffef8)
#define GDP_YLP    (*(volatile u8 *)  0xfffffefa)
#define GDP_RES3   (*(volatile u8 *)  0xfffffefc)
#define GDP_RES4   (*(volatile u8 *)  0xfffffefe)

#define GDP_PAGE   (*(volatile u8 *)  0xfffffec0)
#define GDP_SCROLL (*(volatile u8 *)  0xfffffec2)

#define GDP_CPORT_FG  (*(volatile u8 *)  0xffffff40)
#define GDP_CPORT_BK  (*(volatile u8 *)  0xffffff42)

#define cluta       (*(volatile u8 *)  0xffffff48)
#define cluth       (*(volatile u8 *)  0xffffff4a)
#define clutl       (*(volatile u8 *)  0xffffff4c)

#elif defined M68020
#define GDP_BASE   (*(volatile u8 *)  0xfffffdc0)
#define GDP_STATUS (*(volatile u8 *)  0xfffffdc0)
#define GDP_CMD    (*(volatile u8 *)  0xfffffdc0)
#define GDP_CTRL1  (*(volatile u8 *)  0xfffffdc4)
#define GDP_CTRL2  (*(volatile u8 *)  0xfffffdc8)
#define GDP_CSIZE  (*(volatile u8 *)  0xfffffdcc)
#define GDP_RES1   (*(volatile u8 *)  0xfffffdd0)
#define GDP_DELTAX (*(volatile u8 *)  0xfffffdd4)
#define GDP_RES2   (*(volatile u8 *)  0xfffffdd8)
#define GDP_DELTAY (*(volatile u8 *)  0xfffffddc)
#define GDP_X_MSB  (*(volatile u8 *)  0xfffffde0)
#define GDP_X_LSB  (*(volatile u8 *)  0xfffffde4)
#define GDP_Y_MSB  (*(volatile u8 *)  0xfffffde8)
#define GDP_Y_LSB  (*(volatile u8 *)  0xfffffdec)
#define GDP_XLP    (*(volatile u8 *)  0xfffffdf0)
#define GDP_YLP    (*(volatile u8 *)  0xfffffdf4)
#define GDP_RES3   (*(volatile u8 *)  0xfffffdf8)
#define GDP_RES4   (*(volatile u8 *)  0xfffffdfc)

#define GDP_PAGE   (*(volatile u8 *)  0xfffffd80)
#define GDP_SCROLL (*(volatile u8 *)  0xfffffd84)

#define GDP_CPORT_FG  (*(volatile u8 *)  0xfffffe80)
#define GDP_CPORT_BK  (*(volatile u8 *)  0xfffffe84)

#define cluta       (*(volatile u8 *)  0xfffffe90)	
#define cluth       (*(volatile u8 *)  0xfffffe94)
#define clutl       (*(volatile u8 *)  0xfffffe98)
#else
#error "gdp.h: no cpu type given"
#endif


// CMD
#define GDP_CMD_WRITER		0x00
#define GDP_CMD_ERASER		0x01
#define GDP_CMD_PENDOWN		0x02
#define GDP_CMD_PENUP		0x03
#define GDP_CMD_CLRSCR_1	0x04
#define GDP_CMD_CLRXY		0x05
#define GDP_CMD_CLRSCR_2	0x06
#define GDP_CMD_CLRSCR_3	0x07
#define GDP_CMD_LP_ON_1		0x08
#define GDP_CMD_LP_ON_2		0x09
#define GDP_CMD_5x8		0x0a
#define GDP_CMD_4x4		0x0b
#define GDP_CMD_INVERS		0x0c
#define GDP_CMD_RESETX		0x0d
#define GDP_CMD_RESETY		0x0e
#define GDP_CMD_DMA		0x0f

// STATUS
#define GDP_STATUS_LP_SEQ_END   0x01
#define GDP_STATUS_VERT_BLNK    0x02
#define GDP_STATUS_READY 	0x04
#define GDP_STATUS_LP_OUT	0x08
#define GDP_STATUS_LP_SEQ_IRQ	0x10
#define GDP_STATUS_VB_IRQ	0x20
#define GDP_STATUS_RDY_CMD_IRQ	0x40
#define GDP_STATUS_IRQ		0x80

//CTRL1
#define GDP_CTRL1_PEN_DOWN	0x01
#define GDP_CTRL1_PEN		0x02
#define GDP_CTRL1_HS		0x04
#define GDP_CTRL1_CYCLIC	0x08
#define GDP_CTRL1_EOL_IRQ	0x10
#define GDP_CTRL1_VB_IRQ	0x20
#define GDP_CTRL1_READY_IRQ	0x40
#define GDP_CTRL1_RESERVERD	0x80

//CTRL2
#define GDP_LINE_CONTINUOUS	0x00
#define GDP_LINE_DOTTED		0x01
#define GDP_LINE_DASHED		0x02
#define GDP_LINE_DOT_DASHED	0x03
#define GDP_CHAR_TILTED		0x04
#define GDP_CHAR_VERTICAL	0x08
#define GDP_CHAR_USER		0x10
#define GDP_CTRL2_TRANSPARENT	0x20
#define GDP_CTRL2_HW_CURSOR	0x40	

//CSIZE
#define GDP_GET_PSCALE(csize)	((csize >> 4) & 0x0f)			
#define GDP_GET_QSCALE(csize)	(csize & 0x0f)
#define GDP_SET_SCALE(p,q)	(p << 4) + q

#define TEXT_SIZE_X 	80
#define TEXT_SIZE_Y 	25
#define GDP_MAX_X	511
#define GDP_MAX_Y	255

// colors

#define GDP_COLOR_BLACK		0
#define GDP_COLOR_WHITE		1
#define GDP_COLOR_YELLOW	2
#define GDP_COLOR_GREEN		3
#define GDP_COLOR_RED		4
#define GDP_COLOR_BLUE		5
#define GDP_COLOR_VIOLETT	6
#define GDP_COLOR_CYAN		7
#define GDP_COLOR_DARKGREY	8
#define GDP_COLOR_LIGHTGREY	9
#define GDP_COLOR_DARKYELLOW	10
#define GDP_COLOR_DARKGREEN	11
#define GDP_COLOR_DARKRED	12
#define GDP_COLOR_DARKBLUE	13
#define GDP_COLOR_DARKVIOLETT	14
#define GDP_COLOR_DARKCYAN	15

// gdp modes
#define GDP_MODE_TEXT_80x25	 0
#define GDP_MODE_TEXT_40x25	 1
#define GDP_MODE_TEXT_85x28 	 2
#define GDP_MODE_GRAPH_512x256	 3


// ASCII control characters
#define ASCII_SOH	0x01
#define ASCII_TAB	0x09
#define ASCII_CR	0x0D
#define ASCII_LF	0x0A
// Anzahl der Sonderzeichen
#define ANZTAB 9

// Macros

#define GDP_WAIT_READY 		while(!(GDP_STATUS & GDP_STATUS_READY))
#define GDP_WAIT_SYNC		while(!(GDP_STATUS & GDP_STATUS_VERT_BLNK))
#define GDP_SEND_CMD(cmd)	GDP_WAIT_READY; GDP_CMD=cmd;

#define SET_BIT(bit,val)	val |= (1 << bit)
#define TOGGLE_BIT(bit,val)     val ^= ~(1 << bit)
#define TEST_BIT(bit,val)	val & (1 << bit)	
#define CLEAR_BIT(bit,val)	val &= ~(1 << bit)

#define HIGH_BYTE(b)	(unsigned char)((b & 0xff00) >> 8)
#define LOW_BYTE(b)     (unsigned char) (b & 0xff)
#define HIGH_WORD(w)	(unsigned int) ((w & 0xffff0000) >> 16)
#define LOW_WORD(w)	(unsigned int)  (w & 0xffff)
#define BYTE0(l)	(unsigned char) (l & 0x000000ff)
#define BYTE1(l)	(unsigned char)((l & 0x0000ff00) >> 8)
#define BYTE2(l)	(unsigned char)((l & 0x00ff0000) >> 16)
#define BYTE3(l)	(unsigned char)((l & 0xff000000) >> 24)



/* public functions */

void gdp_init( void );							// initialize GDP driver and variables
unsigned char gdp_set_exchar(unsigned char c, unsigned char *pbitcode);	// set user font, specific character
unsigned char gdp_set_exfont( unsigned char *pbitcode); 		// set user font, complete font
void gdp_set_textmode(unsigned char mode);				// set one of the text modes: 80x25, 40x25, 85x28 or graphic mode GRAPH_512x256
void gdp_clear_viewpage( void );					// clear current viewpage
void gdp_clear_page(unsigned char which);				// clear specific page
void gdp_clear_all( void );						// clear all pages
void gdp_clr(unsigned int sx, unsigned int sy, unsigned int num, unsigned char eattr);	// clear num characters with eattr
void gdp_clreol(unsigned int row, unsigned char eattr);			// erase complete line
unsigned char gdp_movetoxy(unsigned int x, unsigned int y);		// moves the graphic cursor to the specified position
void gdp_drawtoxy(unsigned int x, unsigned int y);			// draws a line to the specified position
unsigned char gdp_gotoxy(unsigned char x, unsigned char y);		// moves the text cursor to the specified position
void gdp_put_char(unsigned char c);					// output character c at current position
void gdp_print_line(unsigned char *pline);				// print a line of text
void gdp_set_page(unsigned char writepage, unsigned char viewpage, unsigned char xormode);
void gdp_set_textscale(unsigned char scalex, unsigned char scaley);	// set text scaling
void gdp_set_texttype(unsigned char type, unsigned char dir);		// set text/line type an ddirection
void gdp_send_cmd(unsigned char cmd);     				// sent command to GDP
unsigned char gdp_get_syncstate( void );  				// returns state of sync bit
void gdp_delay(unsigned long msec);					// delay using the gdp timer
void gdp_setcolor(unsigned char fgcolor, unsigned char bkcolor);	// select forground and background colors
void gdp_getxy( void );							// stores current graphic cursor position in gdp_xpos, gdp_ypos
void gdp_scroll_up( void ); 						// scroll one line up
void gdp_drawcursor( unsigned char visible );				// draw a cursor (1) (software cursor, no hardware cursor)
void gdp_sethwcursor( unsigned char visible );				// enable (1) or disable (0) the hardware cursor
unsigned char gdp_extended_char(unsigned char* cc);			// returns 1 if character is an extended (>127) character

#endif