#include "gdp.h"



/*
 * 
 *  FONT definitions
 * 
 * 
 * 
 */


static
unsigned char chtbl0[ANZTAB] = {0xdb,0xdc,0xdd,0xfb,0xfc,0xfd,0xfe,0x81,0x82}; // Sonderzeichen
static
unsigned char chtbl1[ANZTAB] = {0x5b,0x5c,0x5d,0x7b,0x7c,0x7d,0x7e,0x01,0x02}; // Sonderzeichen für Umcodierung
static
unsigned char chtbl2[ANZTAB][5] = {  {0x7d,0x0a,0x09,0x0a,0x7d},       // Ä
				     {0x3d,0x42,0x42,0x42,0x3d},       // Ö
				     {0x7d,0x40,0x40,0x40,0x7d},       // Ü
				     {0x71,0x54,0x54,0x78,0x41},       // ä
				     {0x00,0x39,0x44,0x44,0x39},       // ö
				     {0x3d,0x40,0x40,0x7d,0x40},       // ü
				     {0x00,0x7f,0x01,0x4d,0x32},       // ß
				     {0x00,0x7f,0x3e,0x1c,0x08},
				     {0x08,0x1c,0x3e,0x7f,0x00} }; // Bitcode Sonderzeichen
/* Erklärung der Bitcodetabelle:

   chtbl2 enthälz die Bitcodes für Sonderzeichen als doppelt indizierte Liste.
   Index 0 gibt an, um welches Sonderzeichen es sich handelt. 
   Index 1 gibt den Bitcode für die 5 Spalten eines 8x5 grossen Zeichens an.

    Beispiel Ä:
    0x7d 0x0a 0x09 0x0a 0x7d
    1    0    0    0    1
    1    0    0    0    1
    1    0    0    0    1
    1    0    0    0    1
    1    1    1    1    1
    1    0    0    0    1
    0    1    0    1    0
    1    0    0    0    1

   Das Bitmuster der 1en stellt ein auf dem Kopf stehendes Ä dar.


   Die GDP-FPGA hat einen eingebauten 2ten Zeichensatz, der die Sonderzeichen bereits enthält.
   Es kann bei der GDP-FPGA ein User-Zeichensatz nachgeladen werden.

   Das ist auch notwendig, da die implementierten Zeichensätze zu nichts kompatibel sind
*/
				     
				     
#define NUM_EXT_CHARS 20
static
unsigned char DOS_EXTENSIONS[NUM_EXT_CHARS][5] = { 
				    {0x00,0x00,0x00,0x00,0x00},		/* 32 unknown char */	
				    {0x3d,0x40,0x40,0x7d,0x40},		/* 33 (129) - ü   */
				    {0x71,0x54,0x54,0x78,0x41},		/* 34 (132) - ä  */
				    {0x7d,0x0a,0x09,0x0a,0x7d},		/* 35 (142) - Ä  */
				    {0x00,0x39,0x44,0x44,0x39},		/* 36 148 - ö	*/
				    {0x3d,0x42,0x42,0x42,0x3d},		/* 37 153 - Ö	*/
				    {0x7d,0x40,0x40,0x40,0x7d},		/* 38 154 - Ü	*/
				    {0x06,0x09,0x09,0x06,0x00},		/* 39 167 - °	*/
				    {0x00,0x7f,0x01,0x4d,0x32},		/* 40 225 - ß	*/
				    {0xfc,0x20,0x20,0x20,0x1c},		/* 41 230 - µ	*/
				    {0x1A,0xa5,0xa5,0xa5,0x58},		/* 42 245 - §	*/
				    {0x24,0x7e,0xa5,0xa5,0xa5},		/* 43 254 - €   */
				    {0x00,0x00,0x00,0x00,0x00},		/* 44 */
				    {0x00,0x00,0x00,0x00,0x00},		/* 45 */
				    {0x00,0x00,0x00,0x00,0x00},		/* 46 */
				    {0x00,0x00,0x00,0x00,0x00},		/* 47 */
				    {0x00,0x00,0x00,0x00,0x00},		/* 48 */
				    {0x00,0x00,0x00,0x00,0x00},		/* 49 */
				    {0x00,0x00,0x00,0x00,0x00},		/* 50 */
				    {0x00,0x00,0x00,0x00,0x00} };	/* 51 */
				   
// vom extended character 128 abziehen, dann passt die Tabelle
static
unsigned char DOS2NKCMAP [128] = { 32, 33, 32, 32, 34, 32, 32, 32, 32, 32, /* 128-137 */
				   32, 32, 32, 32, 35, 32, 32, 32, 32, 32, /* 138-147 */
				   36, 32, 32, 32, 32, 37, 38, 32, 32, 32, /* 148-157 */
				   32, 32, 32, 32, 32, 32, 32, 32, 32, 39, /* 158-167 */
				   32, 32, 32, 32, 32, 32, 32, 32, 32, 32, /* 168-177 */
				   32, 32, 32, 32, 32, 32, 32, 32, 32, 32, /* 178-187 */
				   32, 32, 32, 32, 32, 32, 32, 32, 32, 32, /* 188-197 */
				   32, 32, 32, 32, 32, 32, 32, 32, 32, 32, /* 198-207 */
				   32, 32, 32, 32, 32, 32, 32, 32, 32, 32, /* 208-217 */
				   32, 32, 32, 32, 32, 32, 32, 40, 32, 32, /* 218-227 */
				   32, 32, 41, 32, 32, 32, 32, 32, 32, 32, /* 228-237 */
				   32, 32, 32, 32, 32, 32, 32, 42, 32, 32, /* 238-247 */
				   39, 32, 32, 32, 32, 32, 43, 32 };       /* 248-255 */
				   
				   
// flags
static unsigned char gdp_char_direction;		// direction of textoutput (8=vertical, 0=horizontal)
static unsigned char gdp_char_tilted;			// type of character output(4=tilted, 0=normal)
static unsigned char gdp_char_scalex;			// character scaling 0..16 (0=16)
static unsigned char gdp_char_scaley;
static unsigned char gdp_page;				// view- and write-page
static unsigned char gdp_cursor_x;			// position of text cursor (origin is top-left
static unsigned char gdp_cursor_y;
static unsigned int  gdp_xpos;				// position of graphics cursor (origin is bottom-left !!)
static unsigned int  gdp_ypos;
static unsigned char gdp_fgcolor;			// foreground color
static unsigned char gdp_bkcolor;			// backgroud color
static unsigned char gdp_scrollreg;			// copy of scroll register
static unsigned char gdp_mode;				// GDP mode text 80x25, 40x25 or graphics 512x256
static unsigned char gdp_transparent;			// 0=transparent mode off, 1=transparent mode on (GDP-FPGA)
static unsigned char gdp_max_cx;			// current maximum text cursor position
static unsigned char gdp_max_cy;
static unsigned int  gdp_max_gx;			// current maximum graphic cursor position
static unsigned int  gdp_max_gy;
static unsigned char gdp_hwscroll_on;			// flag: hardware scroll on(1)/off(0)




void gdp_testscroll( void )
{
  unsigned char sizex, sizey,n;
  unsigned int maxx;


  unsigned long flags;

  sizex = gdp_char_scalex*6;
  sizey = gdp_char_scaley*9;
  maxx  = 511 - sizex;

  //printk(" Start testloop :\n");

  
  
  gdp_gotoxy(0,16); gdp_print_line(" Set 1:  ");
  gdp_print_line("!\"§$\%&/\\}{()=?1234567890abcdefghijklmnopqrstuvwxyzÄÖÜ°@<>|,;.:-_#+*€");

  //save_flags(flags); cli();
  GDP_WAIT_READY;
  SET_BIT(4,GDP_CTRL2);	// select user char set
  //restore_flags(flags);

  gdp_gotoxy(0,19); gdp_print_line(" Set 2:  ");
  gdp_print_line("!\"§$\%&/\\}{()=?1234567890abcdefghijklmnopqrstuvwxyzÄÖÜ°@<>|,;.:-_#+*€");
  
  
  

    
}

void gdp_init( void )
{
  unsigned char c;

  gdp_set_textmode(GDP_MODE_TEXT_80x25);
  gdp_hwscroll_on = 0;
  gdp_clear_viewpage();
  gdp_gotoxy(0,0);
  
  gdp_setcolor(GDP_COLOR_RED, GDP_COLOR_BLACK); gdp_put_char('N');
  gdp_setcolor(GDP_COLOR_GREEN, GDP_COLOR_BLACK); gdp_put_char('K');
  gdp_setcolor(GDP_COLOR_BLUE, GDP_COLOR_BLACK); gdp_put_char('C');
  gdp_setcolor(GDP_COLOR_WHITE, GDP_COLOR_BLACK); 


  gdp_print_line(" GDP Driver Version 0.1 beta (C) 2009 Torsten Hemmecke");
  
  gdp_set_exfont((unsigned char *)DOS_EXTENSIONS);
  
  gdp_delay(100);
  
 
  gdp_gotoxy(0,1); gdp_setcolor(GDP_COLOR_BLACK, GDP_COLOR_WHITE);  gdp_print_line(" Black on White "); 
  gdp_gotoxy(0,2); gdp_setcolor(GDP_COLOR_GREEN, GDP_COLOR_YELLOW); gdp_print_line(" Green on Yellow");
  gdp_gotoxy(0,3); gdp_setcolor(GDP_COLOR_GREEN, GDP_COLOR_BLACK); gdp_print_line(" Green ");
  gdp_gotoxy(0,4); gdp_setcolor(GDP_COLOR_RED, GDP_COLOR_BLACK); gdp_print_line(" Red ");
  gdp_gotoxy(0,5); gdp_setcolor(GDP_COLOR_BLUE, GDP_COLOR_RED); gdp_print_line(" Blue on Red");
  gdp_gotoxy(0,6); gdp_setcolor(GDP_COLOR_VIOLETT, GDP_COLOR_BLACK); gdp_print_line(" Violett ");
  gdp_gotoxy(0,7); gdp_setcolor(GDP_COLOR_CYAN, GDP_COLOR_BLACK); gdp_print_line(" Cyan ");
  gdp_gotoxy(0,8); gdp_setcolor(GDP_COLOR_DARKGREY, GDP_COLOR_BLACK); gdp_print_line(" Dark Grey ");
  gdp_gotoxy(0,9); gdp_setcolor(GDP_COLOR_LIGHTGREY, GDP_COLOR_BLACK); gdp_print_line(" Light Grey ");
  gdp_gotoxy(0,10); gdp_setcolor(GDP_COLOR_DARKYELLOW, GDP_COLOR_BLACK); gdp_print_line(" Dark Yellow ");
  gdp_gotoxy(0,11); gdp_setcolor(GDP_COLOR_DARKGREEN, GDP_COLOR_BLACK); gdp_print_line(" Dark Green ");
  gdp_gotoxy(0,12); gdp_setcolor(GDP_COLOR_DARKRED, GDP_COLOR_BLACK); gdp_print_line(" Dark Red ");
  gdp_gotoxy(0,13); gdp_setcolor(GDP_COLOR_DARKBLUE, GDP_COLOR_BLACK); gdp_print_line(" Dark Blue ");
  gdp_gotoxy(0,14); gdp_setcolor(GDP_COLOR_DARKVIOLETT, GDP_COLOR_BLACK); gdp_print_line(" Dark Violett ");
  gdp_gotoxy(0,15); gdp_setcolor(GDP_COLOR_DARKCYAN, GDP_COLOR_BLACK); gdp_print_line(" Dark Cyan ");

  gdp_setcolor(GDP_COLOR_WHITE, GDP_COLOR_BLACK);
  
  //while(1);
 //gdp_testscroll();
   
  
}


unsigned char gdp_set_exchar(unsigned char c, unsigned char *pbitcode)
{
 
  unsigned char save_ctrl2;
  unsigned char save_xmsb;
  unsigned char save_xlsb;
  unsigned char cnt;
  unsigned long flags;
  unsigned int cc;

  if(!GDP_FPGA) return 0;					// only with GDP-FPGA  
  //printk(" set exchar\n");
  cc = c - 128;			// index starting with space
  
  //save_flags(flags); cli();

  GDP_WAIT_READY;		// wait fpr gdp to be ready
  
  save_ctrl2 = GDP_CTRL2;	// save registers
  save_xmsb  = GDP_X_MSB;
  save_xlsb  = GDP_X_LSB;
  
  SET_BIT(4,GDP_CTRL2);		// select user character set
  SET_BIT(5,GDP_CTRL2);		// set transparent mode
  
  cc *= 5;
  GDP_X_LSB = LOW_BYTE(cc);
  GDP_X_MSB = HIGH_BYTE(cc);


  for(cnt=5; cnt > 0; cnt--){
    GDP_RES3 = *pbitcode++;
  }
 
  GDP_CTRL2 = save_ctrl2;	// restore registers
  GDP_X_MSB = save_xmsb;
  GDP_X_LSB = save_xlsb;
  
  //restore_flags(flags);

  return 1;
}

unsigned char gdp_set_exfont(unsigned char *pbitcode)
{
  unsigned char save_ctrl2;
  unsigned char save_xmsb;
  unsigned char save_xlsb;
  unsigned char cnt,cnt2;
  unsigned long flags;
  unsigned int cc;

  if(!GDP_FPGA) return 0;	// only with GDP-FPGA  
  //printk("gdp_set_exfont...\n");
  //save_flags(flags); cli();

  GDP_WAIT_READY;		// wait fpr gdp to be ready
  
  save_ctrl2 = GDP_CTRL2;	// save registers
  save_xmsb  = GDP_X_MSB;
  save_xlsb  = GDP_X_LSB;
  
  SET_BIT(4,GDP_CTRL2);		// select user character set
  SET_BIT(5,GDP_CTRL2);		// set transparent mode
  
  cc = 0;
  
  GDP_X_LSB = LOW_BYTE(cc);
  GDP_X_MSB = HIGH_BYTE(cc);

  //for(cnt2=128;cnt2 > 0; cnt2--) // for all charaters do
  for(cnt2=NUM_EXT_CHARS;cnt2 > 0; cnt2--) // for all charaters do
  for(cnt=5; cnt > 0; cnt--){
    GDP_RES3 = *pbitcode++;
  }
 
  GDP_CTRL2 = save_ctrl2;	// restore registers
  GDP_X_MSB = save_xmsb;
  GDP_X_LSB = save_xlsb;
  
  //restore_flags(flags);

  return 1;
}


void gdp_set_textmode(unsigned char mode)
{
  unsigned long flags;

    //save_flags(flags); cli();

    GDP_WAIT_READY;
    GDP_CMD = 0x07; // clear screen and reset all registers to 0, set czise to 0x11 (minimize)
    GDP_WAIT_READY;
    GDP_CTRL1 = GDP_CTRL1_PEN_DOWN | GDP_CTRL1_PEN | GDP_CTRL1_CYCLIC;	// use write pen and cyclic memory (needed fpr correct hard scrolling !)

    switch(mode){      
      case GDP_MODE_TEXT_40x25:
		      gdp_char_scalex = 2;		// set scale to 1:2
		      gdp_char_scaley = 1;	
		      GDP_WAIT_READY;
		      GDP_CSIZE = GDP_SET_SCALE(gdp_char_scalex, gdp_char_scaley);
		      gdp_char_direction = 0;	// set char output to horizointal 
		      gdp_char_tilted = 0;		// normal characters
		      gdp_scrollreg = 0;
		      gdp_transparent = 0;		// disable transparent mode
		      GDP_SCROLL = gdp_scrollreg;
		      gdp_mode = GDP_MODE_TEXT_40x25;
		      gdp_max_cx = 39;
		      gdp_max_cy = 24;
		      gdp_max_gx = 511;
		      gdp_max_gy = 255;
		      gdp_bkcolor = GDP_COLOR_BLACK;
		      gdp_fgcolor = GDP_COLOR_WHITE;
		      break;
      case GDP_MODE_TEXT_85x28:
		      gdp_char_scalex = 1;		// set scale to 1:2
		      gdp_char_scaley = 1;			      
		      gdp_char_direction = 0;	// set char output to horizointal 
		      gdp_char_tilted = 0;		// normal characters
		      gdp_scrollreg = 0;
		      gdp_transparent = 0;		// disable transparent mode
		      GDP_SCROLL = gdp_scrollreg;
		      gdp_mode = GDP_MODE_TEXT_85x28;
		      gdp_max_cx = 84;
		      gdp_max_cy = 27;
		      gdp_max_gx = 511;
		      gdp_max_gy = 255;
		      gdp_bkcolor = GDP_COLOR_BLACK;
		      gdp_fgcolor = GDP_COLOR_WHITE;
		      break;
      case GDP_MODE_TEXT_80x25:
	    default:
		      gdp_char_scalex = 1;		// set scale to 1:1
		      gdp_char_scaley = 1;	
		      //GDP_SET_SCALE(gdp_char_scalex, gdp_char_scaley);
		      gdp_char_direction = 0;	// set char output to horizointal 
		      gdp_char_tilted = 0;		// normal characters		      
		      gdp_scrollreg = 0;
		      gdp_transparent = 0;		// disable transparent mode
		      GDP_SCROLL = gdp_scrollreg;
		      gdp_mode = GDP_MODE_TEXT_80x25;
		      gdp_max_cx = 79;
		      gdp_max_cy = 24;
		      gdp_max_gx = 511;
		      gdp_max_gy = 255;
		      gdp_bkcolor = GDP_COLOR_BLACK;
		      gdp_fgcolor = GDP_COLOR_WHITE;
		     
    }

      
    GDP_WAIT_READY; // wait for gdp to be ready for new command 
    GDP_CTRL2 &= ~GDP_CHAR_USER;	// select rom character set

    GDP_WAIT_READY; // wait for gdp to be ready for new command
    GDP_CPORT_FG = GDP_COLOR_WHITE;
    GDP_CPORT_BK = GDP_COLOR_BLACK;

    //restore_flags(flags);

    gdp_set_page(0,0,0);	// set page 0, xor-mode = OFF
    gdp_gotoxy(0,0);		// initialize text cursor to top left
}

void gdp_setcolor(unsigned char fgcolor, unsigned char bkcolor)
{
/* GDPFPGA intern sind Vorder- und Hintergrundfarbe jeweils 4 Bit
 * und werden in einem 8-bit Register verwaltet.
 * Die Standard Farbwerte können gdp.h entnommen werden
 * über die CLUT können andere Werte geladen werden
 */

  unsigned long flags;

  gdp_fgcolor = fgcolor;
  gdp_bkcolor = bkcolor;
  
  //save_flags(flags); cli();

  GDP_WAIT_READY; // wait for gdp to be ready for new command

  GDP_CPORT_FG = fgcolor;
  GDP_CPORT_BK = bkcolor;

  //restore_flags(flags);
  
}

void gdp_clear_viewpage( void )
{
  unsigned long flags;
  
  //save_flags(flags); cli();

  GDP_WAIT_READY; // wait for gdp to be ready for new command

  GDP_CMD = 0x06;

  //restore_flags(flags);
}

void gdp_clear_page(unsigned char which)
{
  unsigned long flags;
  unsigned char page;
  
  //save_flags(flags); cli();

  page = (gdp_page & ~0xC0) & (which << 6);   // save to global flag

  GDP_WAIT_READY; // wait for gdp to be ready for new command

  GDP_PAGE = page;	// select page
  GDP_CMD = 0x06;	// erase page

  //restore_flags(flags);
  
}

void gdp_clear_all( void )
{
  unsigned long flags;
  unsigned char page,ii;
  
  //save_flags(flags); cli();
  
  for (ii=0; ii<4; ii++){
    page = (gdp_page & ~0xC0) & (ii << 6);   // save to global flag

    GDP_WAIT_READY; // wait for gdp to be ready for new command

    GDP_PAGE = page;	// select page
    GDP_CMD = 0x06;	// erase page
  }

  gdp_scrollreg = 0;			// reset scroll register
  GDP_SCROLL = gdp_scrollreg;

  //restore_flags(flags);
  
}

unsigned char gdp_movetoxy(unsigned int x, unsigned int y)
// moves the graphic cursor to the specified position
{
  unsigned long flags;

  //printk("movetoxy(%d,%d)\n",x,y);

  /* Dieser Vergleich scheint problematisch zu sein ...ergibt falsche Ergebnisse.
  if(x > gdp_max_gx) return 0; // pixel outside region ?
  if(y > gdp_max_gy) return 0;
  */
  

  //save_flags(flags); cli();

  GDP_WAIT_READY; // wait for gdp to be ready for new command
  
  GDP_X_MSB = HIGH_BYTE(x);

  GDP_X_LSB = LOW_BYTE(x);

  GDP_Y_MSB = HIGH_BYTE(y);

  GDP_Y_LSB = LOW_BYTE(y);

  gdp_xpos = x;			// save values
  gdp_ypos = y;

  //restore_flags(flags);

  return 1;
}

void gdp_drawtoxy(unsigned int x, unsigned int y)
{
  int dx, dy, dx_, dy_;
  unsigned char cmd;
  unsigned long flags;

  cmd = 0x11;

  gdp_getxy();

  //save_flags(flags); cli();


  dx = x - gdp_xpos;
  dy = y - gdp_ypos;

  if(dy < 0){
    dy = -dy;
    SET_BIT(2,cmd);
  }

  if(dx < 0){
    dx = -dx;
    SET_BIT(1,cmd);
  }
  
  while( (dx > 255) || (dy > 255) ){    	// delta registers are only 8bits ...
      dx_ = dx; dy_ = dy;
	
      while( (dx_ > 255) || (dy_ > 255) ){
	dx_ = dx_ >> 2;				
        dy_ = dy_ >> 2;	
      }

      GDP_WAIT_READY;
      GDP_DELTAX = dx_;
      GDP_DELTAY = dy_;
      GDP_WAIT_READY;
      GDP_CMD = cmd;
      dx -= dx_;
      dy -= dy_;
  }

  GDP_WAIT_READY;
  GDP_DELTAX = dx;
  GDP_DELTAY = dy;
  GDP_WAIT_READY;
  GDP_CMD = cmd;
	
  //restore_flags(flags);
  
}


void gdp_setpnt(unsigned char x, unsigned char y)
// to do: should be replaced by a faster version !
{
  gdp_movetoxy(x,y);
  gdp_drawtoxy(x,y); // mit GDP_CMD = 0x80 schneller (schnelle Vektorgrafik !!)
}

unsigned char gdp_gotoxy(unsigned char x, unsigned char y)
// moves the text cursor to specified position, home position is top-left
{
  unsigned int curx;
  unsigned char cury,scroll;

  scroll = 0;
  scroll -= gdp_scrollreg;
  
  
  switch(gdp_mode){
      case GDP_MODE_TEXT_85x28:
	    if( (x > 84) || (y > 27) ) return 0;	// x = 0..84, y = 0..27
	    break;
      case GDP_MODE_TEXT_80x25: 
	    if( (x > 79) || (y > 24) ) return 0;	// x = 0..79, y = 0..24
	    break;
      case GDP_MODE_TEXT_40x25:
	    if( (x > 39) || (y > 24) ) return 0;	// x = 0..39, y = 0..24
	    break;
      case GDP_MODE_GRAPH_512x256:
	    return 0;					// no real cursor in graphics mode, application has to take care....
	    break;
  }


  //printk("gotoxy( %d, %d )....\n",x,y);
  if( gdp_char_scalex == 0 ){ 		// calc values
	gdp_char_scalex = 16;
	curx = x*(16*6);		
  }
  else{ 
	curx = x*(gdp_char_scalex*6);
  }

  if( gdp_char_scaley == 0 ){ 		// calc values
	gdp_char_scaley = 16;
	cury = gdp_max_gy - ((y+1)*(16*9) - 16) - scroll;
  }
  else{ 
	//cury = ((y+1)*(gdp_char_scaley*9) - gdp_char_scaley);	
	cury = gdp_max_gy - ((y+1)*(gdp_char_scaley*9) - gdp_char_scaley) - scroll;
  }

  gdp_movetoxy( curx , cury  );	// graphic origin ist bottom-left !! take care of scroll register !

  gdp_cursor_x = x;			// save values
  gdp_cursor_y = y;
  
  return 1;
}


void gdp_getxy( void )
{
   unsigned long flags;

  //save_flags(flags); cli();
  GDP_WAIT_READY; // wait for gdp to be ready for new command

  gdp_xpos = (GDP_X_MSB << 8) + GDP_X_LSB; // MSB(4) LSB(8)
  gdp_ypos = (GDP_Y_MSB << 8) + GDP_Y_LSB; // MSB(4) LSB(8)

  //restore_flags(flags);
  
}

void gdp_drawcursor( unsigned char visible )
{
  unsigned long flags;
  
  return; // FIXME
  
//  //save_flags(flags); cli();

  gdp_getxy();		// werte in gdp_xpos,gdp_ypos stimmen nicht immer ...!? --> ToDo: check this !!

  //printk("drawcursor (%d,%d)\n",gdp_xpos,gdp_ypos);	
  //save_flags(flags); cli();

  GDP_WAIT_READY; // wait for gdp to be ready for new command

  if(visible){			// Draw Cursor
	GDP_CMD = GDP_CMD_5x8;				// Draw Block
	GDP_WAIT_READY; 
  }else{			// Erase Cursor
	SET_BIT(0,gdp_page);	// enable xor-mode
	GDP_WAIT_READY; 	// wait for gdp to be ready for new command
	GDP_PAGE = gdp_page;

	//GDP_WAIT_READY;
	//GDP_CMD = GDP_CMD_ERASER;		// select erase

	GDP_WAIT_READY;
	GDP_CMD = GDP_CMD_5x8;	// Draw Block

	CLEAR_BIT(0,gdp_page);  // disable xor-mode
	GDP_WAIT_READY;
	GDP_PAGE = gdp_page;

	//GDP_WAIT_READY;
	//GDP_CMD = GDP_CMD_WRITER;		// select write
	
  }

  GDP_X_MSB = HIGH_BYTE(gdp_xpos);	// restore xpos
  GDP_WAIT_READY;
  GDP_X_LSB = LOW_BYTE(gdp_xpos);

  
  //restore_flags(flags);
}


void gdp_sethwcursor( unsigned char visible )
{
   unsigned long flags;


  if(!GDP_FPGA) return 0;	// only with GDP-FPGA  
  //printk("gdp_set_exfont...\n");
  //save_flags(flags); cli();

  GDP_WAIT_READY;		// wait fpr gdp to be ready
  
  if(visible){
  
    SET_BIT(6,GDP_CTRL2);		// enable hardware cursor
					// disable gp software cursor
  }else{
    CLEAR_BIT(6,GDP_CTRL2);		// disable hardware cursor
					// enable gp software cursor
  }

  
  
  //restore_flags(flags);

}

/* erase num characters starting at sx,sy using eattr */
void gdp_clr(unsigned int sx, unsigned int sy, unsigned int num, unsigned char eattr)
{
  unsigned int cnt;
  
   gdp_gotoxy(sx,sy);
   for(cnt=0; cnt<num; cnt++) gdp_put_char(eattr);
}

/* erase complete line */
void gdp_clreol(unsigned int row, unsigned char eattr)
{
  unsigned long flags;
  unsigned int xpos,ypos,maxx,maxy,dx;
  unsigned char sizey; 	// character size
	//printk(" scroll up...\n");
	
	sizey = gdp_char_scaley*9;

	gdp_gotoxy(0,row);
	
	xpos = gdp_xpos;
	ypos = gdp_ypos;
	maxy = ypos + sizey - gdp_char_scaley;
	dx = 255;					// erase line in two steps (we assume a maximum of 512 bits h resolution !!)
      
        //save_flags(flags); cli();

	GDP_WAIT_READY;						// wait for GDP 	
	GDP_CPORT_FG = GDP_COLOR_BLACK;				// a scrolled line will be erased to black
	GDP_CPORT_BK = GDP_COLOR_BLACK;

	GDP_WAIT_READY;
	GDP_CMD = GDP_CMD_ERASER;		// select erase
      
	while(ypos < maxy){			// works because maxy and ypos is 16bit (this is important if maxy is wrapped around...)
						    // erase line by line
	    GDP_WAIT_READY;
	    GDP_X_MSB = HIGH_BYTE(xpos);
	    GDP_X_LSB = LOW_BYTE(xpos);
	    GDP_Y_LSB = LOW_BYTE(ypos);		// only LSB is needed for 0..255 !!
						  // draw (erase) vertical line of sizey at xpos (ignore dx)
	    GDP_WAIT_READY;
	    GDP_DELTAX = dx;			// need to be done in 2 steps ( 511 > 255)
	    GDP_WAIT_READY;
	    GDP_CMD = 0x10;

	    GDP_WAIT_READY;
	    GDP_DELTAX = dx;
	    GDP_WAIT_READY;
	    GDP_CMD = 0x10;
	
	    ypos++;
	}

	GDP_WAIT_READY;						// wait for GDP 	
	GDP_CPORT_FG = gdp_fgcolor;				// restore fg color
	GDP_CPORT_BK = gdp_bkcolor;				// restore bk color

	gdp_cursor_x = 0;					// move text cursor to start of line
	gdp_cursor_y = row;

	GDP_WAIT_READY;
	GDP_CMD = GDP_CMD_WRITER;		// select writer
  
	//restore_flags(flags);

	gdp_gotoxy(gdp_cursor_x,gdp_cursor_y);      
}

void gdp_scroll_up( void ) // scroll one line up
{
  unsigned long flags;
  unsigned int xpos,ypos,maxx,maxy,dx;
  unsigned char sizey; 	// character size
	//printk(" scroll up...\n");
	
	sizey = gdp_char_scaley*9;

	gdp_gotoxy(0,0);					// erase first line

	xpos = gdp_xpos;
	ypos = gdp_ypos;
	maxy = ypos + sizey - gdp_char_scaley;
	dx = 255;					// erase line in two steps (we assume a maximum of 512 bits h resolution !!)
      
        //save_flags(flags); cli();

	GDP_WAIT_READY;						// wait for GDP 	
	GDP_CPORT_FG = GDP_COLOR_BLACK;				// a scrolled line will be erased to black
	GDP_CPORT_BK = GDP_COLOR_BLACK;

	GDP_WAIT_READY;
	GDP_CMD = GDP_CMD_ERASER;		// select erase
      
	while(ypos < maxy){			// works because maxy and ypos is 16bit (this is important if maxy is wrapped around...)
						    // erase line by line
	    GDP_WAIT_READY;
	    GDP_X_MSB = HIGH_BYTE(xpos);
	    GDP_X_LSB = LOW_BYTE(xpos);
	    GDP_Y_LSB = LOW_BYTE(ypos);		// only LSB is needed for 0..255 !!
						  // draw (erase) vertical line of sizey at xpos (ignore dx)
	    GDP_WAIT_READY;
	    GDP_DELTAX = dx;			// need to be done in 2 steps ( 511 > 255)
	    GDP_WAIT_READY;
	    GDP_CMD = 0x10;

	    GDP_WAIT_READY;
	    GDP_DELTAX = dx;
	    GDP_WAIT_READY;
	    GDP_CMD = 0x10;
	
	    ypos++;
	}

	GDP_WAIT_READY;						// wait for GDP 	
	GDP_CPORT_FG = gdp_fgcolor;				// restore fg color
	GDP_CPORT_BK = gdp_bkcolor;				// restore bk color

	gdp_scrollreg -= sizey;					// scroll 1 line up
	GDP_SCROLL = gdp_scrollreg;

	gdp_cursor_x = 0;					// move text cursor to start of last line
	gdp_cursor_y = gdp_max_cy;

	GDP_WAIT_READY;
	GDP_CMD = GDP_CMD_WRITER;		// select writer
  
	//restore_flags(flags);

	gdp_gotoxy(gdp_cursor_x,gdp_cursor_y);      


}

void gdp_scroll_down( void )
/* läuft noch nicht ! */
{

  unsigned long flags;
  unsigned int xpos,ypos,maxx,maxy,dx;
  unsigned char sizey; 	// character size

	//printk(" gdp_scroll_down\n");	
	
	return; // wird momentan nur von Vi benötigt und macht dort noch Stress 
	
	sizey = gdp_char_scaley*9;

	gdp_gotoxy(0,79);					// erase last line

	xpos = gdp_xpos;
	ypos = gdp_ypos;
	maxy = ypos + sizey - gdp_char_scaley;
	dx = 255;					// erase line in two steps (we assume a maximum of 512 bits h resolution !!)
      
        //save_flags(flags); cli();

	GDP_WAIT_READY;						// wait for GDP 	
	GDP_CPORT_FG = GDP_COLOR_BLACK;				// a scrolled line will be erased to black
	GDP_CPORT_BK = GDP_COLOR_BLACK;

	GDP_WAIT_READY;
	GDP_CMD = GDP_CMD_ERASER;		// select erase
      
	while(ypos < maxy){			// works because maxy and ypos is 16bit (this is important if maxy is wrapped around...)
						    // erase line by line
	    GDP_WAIT_READY;
	    GDP_X_MSB = HIGH_BYTE(xpos);
	    GDP_X_LSB = LOW_BYTE(xpos);
	    GDP_Y_LSB = LOW_BYTE(ypos);		// only LSB is needed for 0..255 !!
						  // draw (erase) vertical line of sizey at xpos (ignore dx)
	    GDP_WAIT_READY;
	    GDP_DELTAX = dx;			// need to be done in 2 steps ( 511 > 255)
	    GDP_WAIT_READY;
	    GDP_CMD = 0x10;

	    GDP_WAIT_READY;
	    GDP_DELTAX = dx;
	    GDP_WAIT_READY;
	    GDP_CMD = 0x10;
	
	    ypos++;
	}

	GDP_WAIT_READY;						// wait for GDP 	
	GDP_CPORT_FG = gdp_fgcolor;				// restore fg color
	GDP_CPORT_BK = gdp_bkcolor;				// restore bk color

	gdp_scrollreg -= sizey;					// scroll 1 line up
	GDP_SCROLL = gdp_scrollreg;

	gdp_cursor_x = 0;					// move text cursor to start of first line
	gdp_cursor_y = 0;

	GDP_WAIT_READY;
	GDP_CMD = GDP_CMD_WRITER;		// select writer
  
	//restore_flags(flags);

	gdp_gotoxy(gdp_cursor_x,gdp_cursor_y);      

}


unsigned char gdp_extended_char(unsigned char* cc)
{
  /*
    checks if extended (8bit ASCII DOS Extension) character set is used 
  */
  

 //if((*cc < 32) || (*cc > 127)) printk(" cc= %d\n",*cc);

  switch (*cc) {
      case 0x15:	*cc = DOS2NKCMAP[245-128]; break;		// § - don't know where this comes from 
	
      default:	if ((*cc < 128) && (*cc > 31)) { return 0; }		// normal ASCII character
		if ((*cc > 127)) *cc = DOS2NKCMAP[*cc-128];		// extended DOS		    		     		
		if (*cc <=31 ) *cc = DOS2NKCMAP[0];		  	// not a printable character		
  }
  
  return 1;
}

void gdp_put_char(unsigned char c)
// to do: store correct x,y position after printing 
{
    unsigned long flags;
    unsigned char dy,sizey;
    unsigned int xpos,ypos;

    unsigned char cc = c;
    
    if(cc==0) return;

  //  printk("c(0x%lx)\n",c);
  //  if(!gdp_gotoxy(gdp_cursor_y++,gdp_cursor_y)) return;		// adjust graphis/text cursor

    sizey = gdp_char_scaley*9;

    // pre-erase position
    gdp_getxy();			// store current cursor position (gdp_xpos, gdp_ypos)

    //save_flags(flags); cli();

    xpos=gdp_xpos-gdp_char_scalex;		// for moving drawing cursor to start of last spacing
    ypos=gdp_ypos;

    GDP_WAIT_READY;
    GDP_CMD = GDP_CMD_ERASER;		// select eraser pen
    GDP_WAIT_READY;
    GDP_CMD = GDP_CMD_PENDOWN;

					// 1st step: erase space between last and current character if cursor position > 0:
    if(gdp_cursor_x > 0){
      dy = sizey-gdp_char_scaley-1;		// deltaY is size of character without vertical spacing
      while(xpos < gdp_xpos){			// erase spacing

	GDP_WAIT_READY;
	GDP_X_MSB = HIGH_BYTE(xpos);
	GDP_X_LSB = LOW_BYTE(xpos);
	GDP_Y_MSB = HIGH_BYTE(ypos);
	GDP_Y_LSB = LOW_BYTE(ypos);
						  // draw (erase) vertical line of sizey at xpos (ignore dx)
	GDP_WAIT_READY;
	GDP_DELTAY = dy;			
	GDP_WAIT_READY;
	GDP_CMD = 0x12;	

	xpos++;      				
      }

      GDP_WAIT_READY;
      GDP_Y_MSB = HIGH_BYTE(gdp_ypos);	// restore cursor position
      GDP_Y_LSB = LOW_BYTE(gdp_ypos);
      GDP_X_MSB = HIGH_BYTE(gdp_xpos);
      GDP_X_LSB = LOW_BYTE(gdp_xpos);
    }

					// 2nd step: erase space of current character
    

    //GDP_CPORT_BK = GDP_COLOR_BLACK;	// set bk color to black
    GDP_WAIT_READY;			
    GDP_CMD = GDP_CMD_5x8;		// erase character

    GDP_WAIT_READY;
    GDP_CMD = GDP_CMD_WRITER;		// select writer
    GDP_WAIT_READY; 
    GDP_X_MSB = HIGH_BYTE(gdp_xpos);	// restore xpos
    GDP_X_LSB = LOW_BYTE(gdp_xpos);

    //GDP_CPORT_BK = gdp_bkcolor;		// restore bk color
    
    // print character
    GDP_WAIT_READY;
   // printk(" printing...\n");
    if(gdp_extended_char(&cc)) {
	//GDP_CTRL2 |= GDP_CHAR_USER;	
	SET_BIT(4,GDP_CTRL2);	// select user char set
	GDP_WAIT_READY;
	GDP_CMD =cc;
	GDP_WAIT_READY;
	CLEAR_BIT(4,GDP_CTRL2);	// select user char set
	//GDP_CTRL2 &= ~GDP_CHAR_USER;
    } else {   
      GDP_CMD =cc; 
    }

    //restore_flags(flags);

    gdp_cursor_x++;
}

void gdp_print_line_(unsigned char *pline)
// print a line of zero-terminated text with auto wrap if eol reached
// to do: 	handling of non printable chars (i.e. RC-LF etc.)
//		cursor movement too slow using gdp_gotoxy
//		scolling

{
  unsigned long flags;
  unsigned char sizex, sizey; 	// character size
  unsigned int maxx, maxy;
  unsigned int xpos,ypos,dx;	// graphic cursor position
  unsigned char dy;
  
  sizex = gdp_char_scalex*6;
  sizey = gdp_char_scaley*9;
 
  maxx  = GDP_MAX_X - sizex;

  if(!gdp_gotoxy(gdp_cursor_x,gdp_cursor_y)) return;		// adjust graphis/text cursor

 

  while(*pline){ // eol = NULL

    // pre-erase position
    gdp_getxy();			// store current cursor position

    //save_flags(flags); cli();

    xpos=gdp_xpos-gdp_char_scalex;		// for moving drawing cursor to start of last spacing
    ypos=gdp_ypos;

    GDP_WAIT_READY;
    GDP_CMD = GDP_CMD_ERASER;		// select eraser pen
    GDP_WAIT_READY;
    GDP_CMD = GDP_CMD_PENDOWN;

					// 1st step: erase space between last and current character if cursor position > 0:
    if(gdp_cursor_x > 0){
      dy = sizey-gdp_char_scaley-1;		// deltaY is size of character without vertical spacing
      while(xpos < gdp_xpos){			// erase spacing

	GDP_WAIT_READY;
	GDP_X_MSB = HIGH_BYTE(xpos);
	GDP_X_LSB = LOW_BYTE(xpos);
	GDP_Y_MSB = HIGH_BYTE(ypos);
	GDP_Y_LSB = LOW_BYTE(ypos);
						  // draw (erase) vertical line of sizey at xpos (ignore dx)
	GDP_WAIT_READY;
	GDP_DELTAY = dy;			
	GDP_WAIT_READY;
	GDP_CMD = 0x12;	

	xpos++;      				
      }

      GDP_WAIT_READY;
      GDP_Y_MSB = HIGH_BYTE(gdp_ypos);	// restore cursor position
      GDP_Y_LSB = LOW_BYTE(gdp_ypos);
      GDP_X_MSB = HIGH_BYTE(gdp_xpos);
      GDP_X_LSB = LOW_BYTE(gdp_xpos);

      //restore_flags(flags);
 
    }

					// 2nd step: erase space of current character
  
    //save_flags(flags); cli();
  

    //GDP_CPORT_BK = GDP_COLOR_BLACK;	// set bk color to black
    GDP_WAIT_READY;			
    GDP_CMD = GDP_CMD_5x8;		// erase character

    GDP_WAIT_READY;
    GDP_CMD = GDP_CMD_WRITER;		// select writer
    GDP_WAIT_READY; 
    GDP_X_MSB = HIGH_BYTE(gdp_xpos);	// restore xpos
    GDP_X_LSB = LOW_BYTE(gdp_xpos);

    //GDP_CPORT_BK = gdp_bkcolor;		// restore bk color
    
    // print character
    GDP_WAIT_READY;
    //printk(" printing...\n");
    
    if( (*pline  > 0x1F) &&(*pline < 0x7F) ){	// printable character (7bit ASCII)
    	GDP_CMD =*pline++; 				// print character

	if(gdp_extended_char(pline)) {
	  GDP_CTRL2 |= GDP_CHAR_USER;
	  GDP_WAIT_READY;
	  GDP_CMD =*pline++;
	  GDP_WAIT_READY;
	  GDP_CTRL2 &= ~GDP_CHAR_USER;
	} else {
	  GDP_CMD =*pline++; 
	}


    	gdp_cursor_x ++;				// advance text cursor
    }else if( *pline < 0x20 ){			// Ctrl-character
	switch(*pline){
		case (ASCII_CR):	if(*pline++ == ASCII_LF){ // DOS CR+LF encoding
						*pline++;	    	// simpley advance pointer
						gdp_cursor_x = gdp_max_cx + 1; // move cursor to EOL
					}else{			  // Unix return to SOL
						gdp_cursor_x = 0; 	// move cursor to start of line
					}
					break;
		case (ASCII_LF):	// Unix CR+LF encoding
					gdp_cursor_x = gdp_max_cx + 1;					
					*pline++; 
					break;
		case (ASCII_TAB):	// handle tabulator
					break;
	}
    }else{					// extended 8-bit ASCII
	  gdp_extended_char(pline);
	  GDP_WAIT_READY;
	  GDP_CTRL2 |= GDP_CHAR_USER;
	  GDP_WAIT_READY;
	  GDP_CMD =*pline++;
	  GDP_WAIT_READY;
	  GDP_CTRL2 &= ~GDP_CHAR_USER;
    }

    //restore_flags(flags);

    // check cursor position
    if(gdp_cursor_x > gdp_max_cx){			// cursor is at eol, so try to advance to next line
      gdp_cursor_x = 0;					// move textcursor to start of line
      gdp_cursor_y++;					// advance line
     // printk(" next line...\n");

      if(gdp_cursor_y > gdp_max_cy){				// cursor is at bottom of screen, scoll one line up
	//printk(" scroll up...\n");
	gdp_gotoxy(0,0);					// erase first line

        //save_flags(flags); cli();

	xpos = gdp_xpos;
	ypos = gdp_ypos;
	maxy = ypos + sizey - gdp_char_scaley;
	dx = 255;					// erase line in two steps (we assume a maximum of 512 bits h resolution !!)

	GDP_WAIT_READY;						// wait for GDP 	
	GDP_CPORT_FG = GDP_COLOR_BLACK;				// a scrolled line will be erased to black
	GDP_CPORT_BK = GDP_COLOR_BLACK;

	GDP_WAIT_READY;
	GDP_CMD = GDP_CMD_ERASER;		// select erase
      
	while(ypos < maxy){			// works because maxy and ypos is 16bit (this is important if maxy is wrapped around...)
						    // erase line by line
	    GDP_WAIT_READY;
	    GDP_X_MSB = HIGH_BYTE(xpos);
	    GDP_X_LSB = LOW_BYTE(xpos);
	    GDP_Y_LSB = LOW_BYTE(ypos);		// only LSB is needed for 0..255 !!
						  // draw (erase) vertical line of sizey at xpos (ignore dx)
	    GDP_WAIT_READY;
	    GDP_DELTAX = dx;			// need to be done in 2 steps ( 511 > 255)
	    GDP_WAIT_READY;
	    GDP_CMD = 0x10;

	    GDP_WAIT_READY;
	    GDP_DELTAX = dx;
	    GDP_WAIT_READY;
	    GDP_CMD = 0x10;
	
	    ypos++;
	}

	GDP_WAIT_READY;						// wait for GDP 	
	GDP_CPORT_FG = gdp_fgcolor;				// restore fg color
	GDP_CPORT_BK = gdp_bkcolor;				// restore bk color

	gdp_scrollreg -= sizey;					// scroll 1 line up
	GDP_SCROLL = gdp_scrollreg;

	gdp_cursor_x = 0;					// move text cursor to start of last line
	gdp_cursor_y = gdp_max_cy;

	GDP_WAIT_READY;
	GDP_CMD = GDP_CMD_WRITER;		// select writer

	//restore_flags(flags);
  
      }
  
      gdp_gotoxy(gdp_cursor_x,gdp_cursor_y);      
    }
    
  }

  

  
}



void gdp_print_line(unsigned char *pline)


{
  unsigned long flags;
  unsigned char sizex, sizey; 	// character size
  unsigned int maxx, maxy;
  unsigned int xpos,ypos,dx;	// graphic cursor position
  unsigned char dy;
  

 

  while(*pline){ 
    
    if( (*pline  > 0x1F) &&(*pline < 0x7F) ){						// printable character (7bit ASCII)
      gdp_put_char(*pline++);			// put char
      gdp_cursor_x ++;				// advance text cursor
	  
						// check cursor position
      if(gdp_cursor_x > gdp_max_cx){		// cursor is at eol, so try to advance to next line
        gdp_cursor_x = 0;			// move textcursor to start of line
        gdp_cursor_y++;				// advance line
      }
	  
      if(gdp_cursor_y > gdp_max_cy){		// cursor is at bottom of screen, scoll one line up
      }
      
    }else if( *pline < 0x20 ){								// Ctrl-character
        switch(*pline){
		case (ASCII_CR):	
		  if(*pline++ == ASCII_LF){        	// DOS CR+LF encoding
		    *pline++;					// simply advance pointer
		    gdp_cursor_x = gdp_max_cx + 1; 		// move cursor to EOL
		  }else{			  		// Unix return to SOL
		    gdp_cursor_x = 0; 				// move cursor to start of line
		  }
		  break;
		case (ASCII_LF):			// Unix CR+LF encoding					
		  break;
		case (ASCII_TAB):			// handle tabulator
		  break;
	}
    }else{										// extended 8-bit ASCII  
    }
    
  } // while
  
}


void gdp_set_page(unsigned char writepage, unsigned char viewpage, unsigned char xormode)
{
  unsigned long flags;

  gdp_page = (writepage << 6) + (viewpage << 4) + xormode;   // save to global flag
 
  //save_flags(flags); cli();
  GDP_WAIT_READY; // wait for gdp to be ready for new command
  
  GDP_PAGE = gdp_page;	
				// dodo: fix display error 
  if(GDP_FPGA){				// set transparent mode (only GDP-FPGA)
    GDP_WAIT_READY; 			// wait for gdp to be ready for new command
    if(gdp_transparent){
      SET_BIT(5,GDP_CTRL2);
    }else{
      CLEAR_BIT(5,GDP_CTRL2);
    }
  }

  //restore_flags(flags);

}

void gdp_set_textscale(unsigned char scalex, unsigned char scaley)
{
  unsigned long flags;
  
  if(scalex > 16) return; 	// check values
  if(scaley > 16) return;
  
  gdp_char_scalex = scalex; 	// save values
  gdp_char_scaley = scaley;

  if(scalex == 16) scalex = 0;	// adjust values
  if(scaley == 16) scaley = 0;

  //save_flags(flags); cli();
    
  GDP_WAIT_READY;
  
  GDP_CSIZE = GDP_SET_SCALE(scalex,scaley);

  //restore_flags(flags);
  
}

void gdp_set_texttype(unsigned char type, unsigned char dir)
{
   unsigned long flags;

   gdp_char_direction = dir; 		// save text-type to global flags
   gdp_char_tilted = type;

   //save_flags(flags); cli();
    
   GDP_WAIT_READY;
   GDP_CTRL2 &= type + dir;

   //restore_flags(flags);
}

unsigned char gdp_get_syncstate( void )
{
  unsigned long flags;
  unsigned char syncstate;

  //save_flags(flags); cli();
 
  syncstate = (GDP_STATUS & GDP_STATUS_VERT_BLNK) >> 1;

  //restore_flags(flags);


  return syncstate;
}

void gdp_delay(unsigned long msec)
{
  // Verzögerungsschleife mit Quarzgenauigkeit, da der GDP64 als Zeitbasis
  // verwendet wird.
  unsigned long delay;
  unsigned long flags;

  if(msec == 0) return;

  if(GDP_FPGA) {
    delay = msec * 6;
  }else{
    delay = msec * 5;
  }

  //save_flags(flags); cli();

  while(delay){
    while(!(GDP_STATUS & GDP_STATUS_VERT_BLNK));
    delay--;
  }
  
  //restore_flags(flags);

}

void gdp_send_cmd(unsigned char cmd)
{
  unsigned long flags;

 //save_flags(flags); cli();

 GDP_WAIT_READY; // wait for gdp to be ready for new command
 GDP_CMD = cmd;

 //restore_flags(flags);
}


				   