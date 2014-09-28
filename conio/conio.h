/*  
    conio.h

    taken from turbo c 3.1, modified for NKC use
*/

#ifndef __CONIO_H
#define __CONIO_H

#define _NOCURSOR      0
#define _SOLIDCURSOR   1
#define _NORMALCURSOR  2

struct text_info {
    unsigned char winleft;      /* defines a textwindow */
    unsigned char wintop;
    unsigned char winright;
    unsigned char winbottom;
    unsigned char attribute;    /* current textmode attribute */
    unsigned char normattr;     /* text mode attribute before the application was started */
    unsigned char currmode;     /* current video mode (BW40..C80) */
    unsigned char screenheight; /* sceen heigth in rows */
    unsigned char screenwidth;  /* screen width in columns */
    unsigned char curx;         /* current cursor position */
    unsigned char cury;
};

enum text_modes { LASTMODE=-1, BW40=0, C40, BW80, C80, MONO=7, C4350=64 };

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


void clreol( void );            /* clear top end of line, deletes all characters starting from next cursor position */
void clrscr( void );            /* clears the screen */
void gotoxy( int __x, int __y );/* puts the text mode cursor to column __x, row __y m*/
int  wherex( void );            /* returns current cursor x coordinate (column) */
int  wherey( void );            /* returns current cursor y coordinate (row)   */
int  getch( void );             /* returns a character from console           */
int  getche( void );            /* get character echo, gets a character from console and returns is immediatly to the screen */
int  kbhit( void );             /* returns a non-zero integer if a key is in the keyboard buffer */
int  putch( int __c );          /* output one character, unbuffered */


void  delline( void );          /* deletes the line where the curser resides and moves all subsequent lines one up */
int   gettext( int __left, int __top, 
               int __right, int __bottom,
               void *__destin); /* copies text in a rectangle to __destin */
void  gettextinfo (struct text_info *__r ); /* get information about current textmode */
void  highvideo( void ); /* use "high intensity" for subsequent text output */
void  insline( void );  /* insert a line under cursor and move all subsequent lines one down, the last line is cleared */
void  lowvideo( void ); /* use "low intensity" for subsequent text output */
int   movetext( int __left, int __top,
                int __right, int __bottom,
                int __destleft, int __desttop ); /* move text windows to __destleft,__desttop */
void  normvideo( void );        /* set intensity to what it was at program start */
int   puttext( int __left, int __top,
               int __right, int __bottom,
               void *__source ); /* copies text fromm __source to a rectengular region */
void  textattr( int __newattr ); /* sets fore and background color (combines textcolor and textbackground) */
void  textbackground( int __newcolor ); /* sets text background color  */
void  textcolor( int __newcolor ); /* sets text foreground color */
void  textmode( int __newmode ); /* sets text mode of graphics adapter (LASTMODE,BW40,C40,BW80,C80,MONO) */
void  window( int __left, int __top, int __right, int __bottom); /* defines a region of thr screen as a text window
                                                                    if a window is set, all other commands with coordinates
                                                                    are relative to this region */


void  _setcursortype( int __cur_t ); /* sets the cursor type (NOCURSOR,SOLIDCURSOR,NORMALCURSOR) */
char * cgets( char *__str ); /* cgets reads a string of characters from the console and stores the string (and the string length) 
                                in the location pointed to by str. cgets reads as long as a sign to mark the combination 
                                carriage return / line feed (CR / LF) occurs or the maximum number of characters has been read. 
                                When reading cgets the CR / LF combination is replaced by the combination of characters 
                                \ 0 (null terminator) before the string is stored.
                                Assign str[0] before calling cgets to the maximum length of the string to be read.
                                After completion of the read operation st is assigned[1] the actual number of characters read.
                                The reading begins with the character at position str[2] and ends with the null terminator.
                                Consequently, at least str str[0] in length plus 2 bytes
                                return value: a pointer to str[2] */
int    cprintf( const char *__format, ... ); /* prints formatted output to the screen 
                                                To contrast to fprintf and printf, not translated cprintf line character 
                                                (\ n) in the combination of characters carriage return / line feed (\ r \ n). 
                                                Tab character (specified with t \) are not expanded to spaces.*/
int    cputs( const char *__str ); /* cputs is the null-terminated string from str in the current text window. 
                                      The newline character is not here appended to the string. */
int    cscanf( const char *__format, ... ); /* cscanf reads directly from the console of a series of input fields one character at. */
char * getpass( const char *__prompt ); /*  reads a password from the system console, after the user is prompted for a password to a 
                                            null-terminated string and display the password has been disabled */
int    ungetch( int __ch ); /* Pushes a character back into the keyboard buffer.
                               Successful execution ungetch returns the character ch.
                               If an error occurs, the function returns EOF  */




#endif  /* __CONIO_H */
