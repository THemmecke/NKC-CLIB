#include <conio.h>
#include "../nkc/llnkc.h"
 

/*
	FIX: make all functions text window defined by window
*/


/*
	Aufbau Bildschirm:

	Auflösung einer Seite:  

		(x)256 x (y)512 Bildpunkte = 131072 Bildpunkte

		1Byte speichert 8 Bildpunkte (Monochrom-Mode)
		1 Seite benötigt damit 16KByte (16483Bytes), 4 Seiten 64KByte

		1Byte speichert 2 Bildpunkte (Farb-Version)
		1 Pixel besteht dabei aus 4 Bit die ein Index in die CLUT sind, damit können 16 (2^4) aus 512 (2^9) Farben gleichzeitig dargestellt werden.
		(Die CLUT besteht aus 16 9Bit Einträgen)
		1 Seite benötigt damit 64KByte, 4 Seiten 256KByte

		In der Farbversion mit 68020 ist also (Base == 0x70.0000*cpu): 
			Page 0  == 1C00000 .... 1C0FFFF
			Page 1  == 1C10000 .... 1C1FFFF
			Page 2  == 1C20000 .... 1C2FFFF
			Page 3  == 1C30000 .... 1C3FFFF
					== 1Cp0000 .... 1CpFFFF
					== 1C00000 + p<<16

			Zeile 0 == 1C00000 .... 1C000FF
			Zeile 1 == 1C00100 .... 1C001FF
			Zeile n == 1C0nn00 .... 1C0nnFF (mit nn = 0x00...0xFF )
			        == 1C00000 + nn<<8

			Pixel k == 1C00000 + k/2  => es wird immer auf 2 Pixel gleichzeitig zugegriffen !!

			pixel (x,y) == 1Cp0000 + y<<8 + x/2

			Speicher f. Fenster mit ObenLinks(x1,y1), UntenRechts(x2,y2):

			pixel (x1,y1) == 1Cp0000 + y1<<8 + x1/2
			pixel (x2,y2) == 1Cp0000 + y2<<8 + x2/2


Standardbelegung der CLUT

Farbnummer 				Name 			Wert 			Entsprechender
dez hex 	NKC 		I-Net 	hex 	binär 			HTML-Code
										R 	G 	B
0 	$0 	Schwarz 	    black 	$0000 000 	000 	000 	#000000
1 	$1 	Weiß 		    white 	$01FF 111 	111 	111 	#FFFFFF
2 	$2 	Gelb 		    yellow 	$01F8 111 	111 	000 	#FFFF00
3 	$3 	Grün 		    lime 	$0038 000 	111 	000 	#00FF00
4 	$4 	Rot 		    red 	$01C0 111 	000 	000 	#FF0000
5 	$5 	Blau 		    blue 	$0007 000 	000 	111 	#0000FF
6 	$6 	Violett 	    fuchsia	$01C7 111 	000 	111 	#FF00FF
7 	$7 	Zyan 		    aqua 	$003F 000 	111 	111 	#00FFFF
8 	$8 	Dunkelgrau	    gray 	$0092 010 	010 	010 	#404040
9 	$9 	Hellgrau 	    silver 	$0124 100 	100 	100 	#808080
10 	$A 	Dunkelgelb	    olive 	$00D8 011 	011 	000 	#606000
11 	$B 	Dunkelgrün	    green 	$0018 000 	011 	000 	#006000
12 	$C 	Dunkelrot		maroon 	$00C0 011 	000 	000 	#600000
13 	$D 	Dunkelblau		navy 	$0003 000 	000 	011 	#000060
14 	$E 	Violett dunkel 	purple 	$00C3 011 	000 	011 	#600060
15 	$F 	Zyan dunkel 	teal 	$001B 000 	011 	011 	#006060

*/
/*

	- Alle funktionen arbeiten relativ zum gesetzten Textfenster (-> window)
	- Start des Bildschirmspeichers: 

*/	

/*--------------------------------------------------------------------------

   Private Functions

--------------------------------------------------------------------------*/
//// CGA 640x200 
//#define EVEN_LINES 0xB8000
//#define ODD_LINES 0xBA000
//
//unsigned char *mem[] = {(unsigned char*) EVEN_LINES,
//                        (unsigned char*) ODD_LINES};
//
//static void drv_put_pixel(int x, int y, unsigned int color)
//{
//    unsigned char mask = 0x80 >> (x % 8);
//    int offset = y/2 * 640/8 + x/8;
//    if (color)
//        *(mem[y % 2] + offset) |= mask;
//    else
//        *(mem[y % 2] + offset) &= ~mask;
//}

// define number of pixel per byte
#define PPB 2
// define resolution
#define HPIXELS 256
#define VPIXELS 512

// define video memory layout (redefine with cpu!)
#define PAGE0 0x1C00000
#define PAGE1 0x1C10000
#define PAGE2 0x1C20000
#define PAGE3 0x1C30000

unsigned char *mem[] = {(unsigned char*) PAGE0,
                        (unsigned char*) PAGE1,
		        (unsigned char*) PAGE2,
		        (unsigned char*) PAGE3,
                       };

//static 
void drv_put_pixel(int x, int y, int p, unsigned char color)
{
  
    register unsigned char tmp,mask,col;
    
    col=0;
#if PPB == 8
    mask = 0b10000000 >> (x % 8);
    if(color)
      col  = 0b10000000 >> (x % 8);    
#elif PPB == 4       
    mask = 0b11000000 >> (x % 4);
    if(color)
      col  = (color << 6) >> (x % 4);
#elif PPB == 2   
    mask = 0b11110000 >> ((x % 2)*4);
    if(color)
      col  = (color << 4) >> (x % 2);
#elif PPB == 1   
    mask = 0b11111111;   
    col = color; 
#endif
    
    register int offset = y<<8 * HPIXELS/PPB + x/PPB;

    if(color)
    {
      tmp = *(mem[p] + offset) & ~mask;            
      *(mem[p] + offset) = tmp & col;
    }
    else
    {
      *(mem[p] + offset) &= ~mask;
    }
    
    
}

/*--------------------------------------------------------------------------

   Public Functions

--------------------------------------------------------------------------*/

void clreol( void ){

}

void clrscr( void ){
 	nkc_clrscr();
}

void gotoxy( int __x, int __y ){
	nkc_setxy(__x, __y);
}

int  wherex( void ){
	unsigned char _x,_y;
	nkc_getxy(&_x, &_y);
	return _x;
}

int  wherey( void ){
	unsigned char _x,_y;
	nkc_getxy(&_x, &_y);
	return _y;
}

int  getch( void ){
	return nkc_getchar();
}

int  getche( void ){
	int c = nkc_getchar();
	nkc_putchar(c);
	return c;
}

int  kbhit( void ){
	return nkc_kbhit();
}

int  putch( int __c ){
	nkc_putchar(__c);
}


void  delline( void ){

}

int   gettext( int __left, int __top, int __right, int __bottom, void *__destin){

}

void  gettextinfo (struct text_info *__r ){

}

void  highvideo( void ){

}

void  insline( void ){

}

void  lowvideo( void ){

}

int   movetext( int __left, int __top, int __right, int __bottom, int __destleft, int __desttop ){

}

void  normvideo( void ){

}

int   puttext( int __left, int __top, int __right, int __bottom, void *__source ){

}

void  textattr( int __newattr ){

}

void  textbackground( int __newcolor ){

}

void  textcolor( int __newcolor ){

}

void  textmode( int __newmode ){

}

void  window( int __left, int __top, int __right, int __bottom){

}


void  _setcursortype( int __cur_t ){

	switch (__cur_t){
		case _NOCURSOR: nkc_curoff(); break;
		case _SOLIDCURSOR:
		case _NORMALCURSOR: nkc_curon(); break;
	}

}

char * cgets( char *__str ){

}

int    cprintf( const char *__format, ... ){

}

int    cputs( const char *__str ){

}

int    cscanf( const char *__format, ... ){

}

char * getpass( const char *__prompt ){

}

int    ungetch( int __ch ){

}



