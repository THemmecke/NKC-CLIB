#include <stdio.h>
#include <string.h>
#include <types.h>
#include <ff.h>
#include <ioctl.h>
#include <errno.h>
#include <debug.h>

#include <gide.h>
#include <fs.h> 

#include "shell.h"
#include "cmd.h"


/*---------------------------------------------------------*/
/* Work Area                                               */
/*---------------------------------------------------------*/

extern char   _start;
extern char   __BUILD_DATE;
extern char   __BUILD_NUMBER;

// global variables



static char Line[MAX_CHAR];			/* Console input/output buffer */
char com[MAX_CHAR];				/* command */
char args[MAX_CHAR];				/* command argumennts */
//char CurrDirPath[MAX_CHAR];			/* current directory path */
//char CurrDrive[MAX_CHAR];			/* current drive */
//BYTE CurrFATDrive=0;
struct fpinfo FPInfo;


char HistoryBuffer[MAX_HISTORY+1][MAX_CHAR]; /* History Buffer */
char histOLDEST = 0;                         /* Oldest entry */
char histNEWEST = 0;			    /* Last/Newest entry */
char histLEVEL = 0;			    

unsigned char insmode = 0;			/* comand line insert mode on/off */

void getcommand(char* command);			/* input line editor */



void shell()
{
  struct CMD *cmdptr;
  char *ptr,*cp;
  int res,ii;     
  
 
  /* allocate memeory ... */ 
  FPInfo.psz_driveName 	= (char*)malloc(_MAX_DRIVE_NAME);
  FPInfo.psz_deviceID  	= (char*)malloc(_MAX_DEVICE_ID);
  FPInfo.psz_path  	= (char*)malloc(_MAX_PATH);
  FPInfo.psz_filename  	= (char*)malloc(_MAX_FILENAME);
  FPInfo.psz_fileext  	= (char*)malloc(_MAX_FILEEXT);
  FPInfo.psz_cdrive  	= (char*)malloc(_MAX_DRIVE_NAME);
  FPInfo.psz_cpath  	= (char*)malloc(_MAX_PATH);
  
   if( !FPInfo.psz_driveName || !FPInfo.psz_deviceID || !FPInfo.psz_path || !FPInfo.psz_filename ||
      !FPInfo.psz_fileext || !FPInfo.psz_fileext || !FPInfo.psz_cpath )
  {
    printf(" error allocating memory for FPInfo....\n");
    exit(1);
  }
  
  // clear history
  for(ii=0; ii<MAX_HISTORY; ii++){
    HistoryBuffer[ii][0] = 0;
  }
  
  // set current drive and path
  //sprintf(FPInfo.psz_cdrive,"Q");
  sprintf(FPInfo.psz_cpath,"/");
  
  init_cmd();
      
  ioctl(NULL,FS_IOCTL_GETDRV,FPInfo.psz_cdrive);
  
  
  printf("\n\n Test-Shell v %d.%d\n\n"
         "   To access any drive, you have to mount it first.\n"
	 "   Use the following commands:\n"
	 "      fs    - to show available file systems\n"
	 "      dev   - to show available devices\n"
	 "      mount - to mount a device and associate it with a file system\n"
	 "      ?     - for help on all commands\n\n",
	 (unsigned long) &__BUILD_DATE - (unsigned long) &_start,
	 (unsigned long) &__BUILD_NUMBER - (unsigned long) &_start);
 
  for(;;)
  {
   
     getcommand(Line);
     
     ptr = ltrimcl(Line); // skip leading spaces
      
     cp = com; 
     while(*ptr && is_fnchar(*ptr))
      *cp++ = *ptr++;//toupper(*ptr++);
    
     *cp = '\0'; // terminate first word
           
     cp = args;       
     while(*ptr)
      *cp++ = *ptr++;
     
     *cp = '\0'; // terminate argument string
             
     
     /* Scan internal command table */
     
     //printf("scan internal commands...\n"); getchar();
    
     //printf("compare %s against %s...\n",com,cmdptr->name); getchar();
     for (cmdptr = internalCommands
        ; cmdptr->name && strcmp(com, cmdptr->name) != 0
        ; cmdptr++){
                //printf("compare %s against %s...\n",com,cmdptr->name); getchar();
        }

     
     if(cmdptr->name)
     { // command found                         
        //printf("found...(%s)\n",cmdptr->name); getchar();
        if(memcmp(ltrimcl(args), "/?", 2) == 0)  {
          displayCmdHlp(cmdptr->help_id);
        } else {       
         //printf("invoke...\n"); getchar();
         if(cmdptr->func(args)) break; 
        }                
     } else { // command not found
        // is it a 'change drive' command ?                     
       //printf(" checking for drive in '%s' - last char is %c\n",com, com[strlen(com)-1]);
       
       res = EINVAL;
       if(com[strlen(com)-1] == ':') {
	 com[strlen(com)-1] = 0;
	 printf(" change drive %s\n",com);
	 res = cmd_chdrive(com);
       }
       
       cp = com;
       while (*cp == ' ') cp++; // check if something meaningful was entered anyway....
       if(*cp == 0) res = FR_OK;
	                
       if (res != FR_OK) printf("%s: command not found\n",com);
     }
  }
  
  exit_cmd();
     
}





#define isargdelim(ch) (isspace(ch) || iscntrl(ch) || strchr(",;=", ch))

char *ltrimcl(const char *str)
{ char c;

 // assert(str);

  while ((c = *str++) != '\0' && isargdelim(c))
    ;

  return (char *)str - 1;               /* strip const */
}

int is_fnchar(const int c)
{
  //return !(c <= ' ' || c == 0x7f || strchr(".\"/\\[]:|<>+=;,", c));
  return !(c <= ' ' || c == 0x7f || strchr(".\"/\\[]|<>+=;,", c));
}


void displayCmdHlp(unsigned id)
{
    struct CMDHLP *hlpptr;    
     /* Scan help texts */
     for (hlpptr = hlptxt
        ; hlpptr->help_id != id && hlpptr->help_id != 0
        ; hlpptr++);
        
        if(hlpptr->help_id)
         printf(hlpptr->syntax);
}


int showcmds(char *args)
{
    struct CMDHLP *hlpptr; 
    int linecnt = 0, stop = 0;
    char c;

    printf(" Available commands:\n\n");

    for (hlpptr = hlptxt
        ; hlpptr->help_id != 0 && !stop
        ; hlpptr++)
        if(hlpptr->help_id)
        {
         printf(hlpptr->text);
         linecnt++;
         
         if(!(linecnt % 10)) {
	   c=getchar();
	   if(c=='q' || c== 'Q') stop = 1;
	 }
        }
        
    printf("\n");
        
    return 0;
}

void getcommand(char* Line){
    char c,cc;
    unsigned char i,x,y,cpos,cmax,cr;
    
    
    //printf("%s%s> ",FAT_DRIVE_NAMES[CurrFATDrive],CurrDirPath); 
    printf("%s:%s>",FPInfo.psz_cdrive,FPInfo.psz_cpath);
      
    cpos = cmax = 0;
    cr=0;
    c=0;
    
    Line[cpos] = c;
    
    do{
    c = gp_getchar();
    
      switch(c) {
	  case 0x05:	// UP (go back in history)
	      
	      if(histLEVEL == histNEWEST) { // save current line
		HistoryBuffer[histNEWEST][0] = 0;
		Line[cmax] = 0;	
		strcat(HistoryBuffer[histNEWEST],Line);	      		
	      }
	      
	      if(histLEVEL != histOLDEST) {		
	        histLEVEL--;
	      }
	      if(histLEVEL < 0) histLEVEL = MAX_HISTORY;
	      
					  // delete current Line ....
	      gp_getxy(&x,&y);
	      gp_setxy(x-cpos,y);             	// goto Pos1
	      i = 0;
	      while(i<cpos){		       	// erase all characters
	        gp_setxy(x-cpos+i++,y);
	        gp_putchar(' ');
	      }		
	      gp_setxy(x-cpos,y);             	// goto Pos1		      
	      
	      *Line = 0;	      		// print line from history buffer
	      strcat(Line,HistoryBuffer[histLEVEL]);
	      cpos = cmax = strlen(Line);	      
	      printf("%s",Line); 
	      
	      break;
	  case 0x18:	// DOWN (go forth in history)
	      if(histLEVEL != histNEWEST) histLEVEL++;
	      if(histLEVEL > MAX_HISTORY) histLEVEL = 0;
	      
	                                    // delete current Line ....
	      gp_getxy(&x,&y);
	      gp_setxy(x-cpos,y);             	// goto Pos1
	      i = 0;
	      while(i<cpos){		       	// erase all characters
	        gp_setxy(x-cpos+i++,y);
	        gp_putchar(' ');
	      }		
	      gp_setxy(x-cpos,y);             	// goto Pos1		      
	      
	      *Line = 0;	      		// print line from history buffer
	      strcat(Line,HistoryBuffer[histLEVEL]);
	      cpos = cmax = strlen(Line);	      
	      printf("%s",Line); 
	    break;
	  case 0x13:	// Arrow Left
	      if(!cpos) break;
	      gp_getxy(&x,&y);
	      cpos--; x--;
	      gp_setxy(x,y);
	    break;
	  case 0x04:	// Arrow Right	
	      if(cpos >= MAX_CHAR || cpos >= cmax) break;
	      gp_getxy(&x,&y);
	      cpos++; x++;
	      gp_setxy(x,y);
	    break;	  
	  case 0x01:	// Ctrtl-A POS1
	      gp_getxy(&x,&y);
	      gp_setxy(x-cpos,y);
	      cpos=0;
	    break;
	  //case 0x05:	// Ctrtl-E	(duplicate with Arrow Up) evtl. END ?
	  //  break;
	  
	  case 0x12:	// PgUp
	    break;
	  case 0x03:	// PgDown
	    break;
	    
	  case 0x0D:	// ENTER
	    Line[cmax]=0;
	    
	    // History Management ----
	
	    // copy current line to buffer
	    HistoryBuffer[histNEWEST][0] = 0;
	    strcat(HistoryBuffer[histNEWEST],Line);
	
	    // Set Buffer Pointer	
	    if(histNEWEST < MAX_HISTORY) {
	      histNEWEST++;
	    } else {
	      histNEWEST = 0;
	    }
	    if(histNEWEST == histOLDEST) { 
	      if(histOLDEST < MAX_HISTORY) {
		histOLDEST++;
	      }else{
		histOLDEST = 0;
	      }
	    }
	    
	    histLEVEL = histNEWEST;
	    
	    // ------------------------
	    
	    gp_getxy(&x,&y);
	    gp_setxy(x+cmax-cpos,y);
	    //gp_putchar(0x0D);
	    //gp_putchar(0x0A);
	    printf("\n");
	    cr = 1;	    
	    break;
	  case 0x7F:	// BSPACE
	    if(!cpos) break;
	    
	    gp_getxy(&x,&y);
	    cpos--; x--; cmax--;
	    
	    for(i=0; i< cmax-cpos;i++){
	      gp_setxy(x+i,y);
	      gp_putchar(Line[cpos+i+1]);
	      Line[cpos+i] = Line[cpos+i+1];
	    }
	    gp_setxy(x+i,y);
	    gp_putchar(' ');
	    gp_setxy(x,y);
	      
	    break;
	  case 0x07:	// Del
	    if(cpos == cmax) break;
	    
	    gp_getxy(&x,&y);
	    cmax--;
	    
	    for(i=0; i< cmax-cpos;i++){
	      gp_setxy(x+i,y);
	      gp_putchar(Line[cpos+i+1]);
	      Line[cpos+i] = Line[cpos+i+1];
	    }
	    gp_setxy(x+i,y);
	    gp_putchar(' ');
	    gp_setxy(x,y);
	    
	    break;
	  case 0x16:	// Insert  
	    insmode = !insmode;
	    // Cursor-Shape ändern ...
	    break;
	  
	  default:	// other character  
	    if(!insmode || cpos == cmax){
	      Line[cpos] = c;
	      gp_putchar(c); // echo char	    
	      cpos++;
	      if(cpos > cmax) cmax = cpos;
	    } else {				// insert mode...
	      gp_getxy(&x,&y);
	      
	      for(i=0; i<= cmax-cpos;i++){
		cc = Line[cpos+i];		
		gp_putchar(' ');		
		gp_setxy(x+i,y);
		Line[cpos+i] = c;
		gp_putchar(c);
		c = cc;
	      }	
	      gp_setxy(x+1,y);	      
	      cpos++; cmax++;	      
	    }
	    break;
      }
    
    
    }while(!cr);   
}


static void execute(char *first, char *rest)
{
  /*
   * This command (in first) was not found in the command table
   *
   *
   * first - first word on command line
   * rest  - rest of command line
   *
   */
  
  printf(" execute %s (with parameters %s) ....\n",first,rest);
}