/*  conio.h
*/

#ifndef __CONIO_H
#define __CONIO_H

#define _NOCURSOR      0
#define _SOLIDCURSOR   1
#define _NORMALCURSOR  2

struct text_info {
    unsigned char winleft;
    unsigned char wintop;
    unsigned char winright;
    unsigned char winbottom;
    unsigned char attribute;
    unsigned char normattr;
    unsigned char currmode;
    unsigned char screenheight;
    unsigned char screenwidth;
    unsigned char curx;
    unsigned char cury;
};


/*
// gdp modes
#define GDP_MODE_TEXT_80x25  0
#define GDP_MODE_TEXT_40x25  1
#define GDP_MODE_TEXT_85x28      2
#define GDP_MODE_GRAPH_512x256   3

=>  C/BW40 == Black&White 40x24
    C/BW80 == Black&White 80x25
    C/BW85 == Black&White 85x28
    MONO

*/
enum text_modes { LASTMODE=-1, BW40=0, C40, BW80, C80, MONO=7, C4350=64 };

/*
#define GDP_COLOR_BLACK     0
#define GDP_COLOR_WHITE     1
#define GDP_COLOR_YELLOW    2
#define GDP_COLOR_GREEN     3
#define GDP_COLOR_RED       4
#define GDP_COLOR_BLUE      5
#define GDP_COLOR_VIOLETT   6
#define GDP_COLOR_CYAN      7
#define GDP_COLOR_DARKGREY  8
#define GDP_COLOR_LIGHTGREY 9
#define GDP_COLOR_DARKYELLOW    10
#define GDP_COLOR_DARKGREEN 11
#define GDP_COLOR_DARKRED   12
#define GDP_COLOR_DARKBLUE  13
#define GDP_COLOR_DARKVIOLETT   14
#define GDP_COLOR_DARKCYAN  15
*/
enum COLORS {
    BLACK,          /* dark colors */
    BLUE,
    GREEN,
    CYAN,
    RED,
    MAGENTA,
    BROWN,
    LIGHTGRAY,
    DARKGRAY,       /* light colors */
    LIGHTBLUE,
    LIGHTGREEN,
    LIGHTCYAN,
    LIGHTRED,
    LIGHTMAGENTA,
    YELLOW,
    WHITE
};

#define BLINK       128 /* blink bit */


void clreol( void );
void clrscr( void );
void gotoxy( int __x, int __y );
int  wherex( void );
int  wherey( void );
int  getch( void );
int  getche( void );
int  kbhit( void );
int  putch( int __c );


void  delline( void );
int   gettext( int __left, int __top,
               int __right, int __bottom,
               void *__destin);
void  gettextinfo (struct text_info *__r );
void  highvideo( void );
void  insline( void );
void  lowvideo( void );
int   movetext( int __left, int __top,
                int __right, int __bottom,
                int __destleft, int __desttop );
void  normvideo( void );
int   puttext( int __left, int __top,
               int __right, int __bottom,
               void *__source );
void  textattr( int __newattr );
void  textbackground( int __newcolor );
void  textcolor( int __newcolor );
void  textmode( int __newmode );
void  window( int __left, int __top, int __right, int __bottom);

void  _setcursortype( int __cur_t );
char * cgets( char *__str );
int    cprintf( const char *__format, ... );
int    cputs( const char *__str );
int    cscanf( const char *__format, ... );
char * getpass( const char *__prompt );
int    ungetch( int __ch );


#endif  /* __CONIO_H */
