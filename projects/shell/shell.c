#include <stdio.h>
#include <string.h>
#include <types.h>
#include <ff.h>
#include <ioctl.h>
#include <errno.h>
#include <debug.h>

#include <gide.h>
 

#include "shell.h"
#include "cmd.h"


/*---------------------------------------------------------*/
/* Work Area                                               */
/*---------------------------------------------------------*/


// global variables



static char Line[MAX_CHAR];			/* Console input/output buffer */
char com[MAX_CHAR];				/* command */
char args[MAX_CHAR];				/* command argumennts */
char CurrDirPath[MAX_CHAR];			/* current directory path */
char CurrDrive[MAX_CHAR];			/* current drive */
BYTE CurrFATDrive=0;

unsigned char insmode = 0;			/* comand line insert mode on/off */

void getcommand(char* command);			/* input line editor */



void shell()
{
  struct CMD *cmdptr;
  char *ptr,*cp;
  int res;     
  
  /*
  dbg("DEGUG %s\n","mit printf");
  lldbg("DEBUG mit lldbg\n");
  lldbgwait("DEBUG mit lldbgwait\n");
  dbg("und nochmal ....\n");
  dbg("DEGUG %s\n","mit printf");
  lldbg("DEBUG mit lldbg\n");
  lldbgwait("DEBUG mit lldbgwait\n");
*/
  
  
  sprintf(CurrDirPath,"/");
    
  ioctl(NULL,FS_IOCTL_GETDRV,CurrDrive);
 
  for(;;)
  {
   
     getcommand(Line);
     
     ptr = ltrimcl(Line); // skip leading spaces
      
     cp = com; 
     while(*ptr && is_fnchar(*ptr))
      *cp++ = toupper(*ptr++);
    
     *cp = '\0'; // terminate first word
           
     cp = args;       
     while(*ptr)
      *cp++ = *ptr++;
     
     *cp = '\0'; // terminat argument string
             
     
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
    int linecnt = 0;

    printf(" Available commands:\n\n");

    for (hlpptr = hlptxt
        ; hlpptr->help_id != 0
        ; hlpptr++)
        if(hlpptr->help_id)
        {
         printf(hlpptr->text);
         linecnt++;
         
         if(!(linecnt % 10)) getchar();
        }
        
    printf("\n");
        
    return 0;
}

void getcommand(char* Line){
    char c,cc;
    unsigned char i,x,y,cpos,cmax,cr;
    
    
    //printf("%s%s> ",FAT_DRIVE_NAMES[CurrFATDrive],CurrDirPath); 
    printf("%s:%s> ",CurrDrive,CurrDirPath);
      
    cpos = cmax = 0;
    cr=0;
    c=0;
    
    Line[cpos] = c;
    
    do{
    c = nkc_getchar();
    
      switch(c) {
	  case 0x05:	// Arrow Up
	    break;
	  case 0x18:	// Arrow Down
	    break;
	  case 0x13:	// Arrow Left
	    if(!cpos) break;
	    nkc_getxy(&x,&y);
	    cpos--; x--;
	    nkc_setxy(x,y);
	    break;
	  case 0x04:	// Arrow Right	
	    if(cpos >= MAX_CHAR || cpos >= cmax) break;
	    nkc_getxy(&x,&y);
	    cpos++; x++;
	    nkc_setxy(x,y);
	    break;	  
	  case 0x01:	// Ctrtl-A POS1
	    nkc_getxy(&x,&y);
	    nkc_setxy(x-cpos,y);
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
	    nkc_getxy(&x,&y);
	    nkc_setxy(x+cmax-cpos,y);
	    //nkc_putchar(0x0D);
	    //nkc_putchar(0x0A);
	    printf("\n");
	    cr = 1;
	    break;
	  case 0x7F:	// BSPACE
	    if(!cpos) break;
	    
	    nkc_getxy(&x,&y);
	    cpos--; x--; cmax--;
	    
	    for(i=0; i< cmax-cpos;i++){
	      nkc_setxy(x+i,y);
	      nkc_putchar(Line[cpos+i+1]);
	      Line[cpos+i] = Line[cpos+i+1];
	    }
	    nkc_setxy(x+i,y);
	    nkc_putchar(' ');
	    nkc_setxy(x,y);
	      
	    break;
	  case 0x07:	// Del
	    if(cpos == cmax) break;
	    
	    nkc_getxy(&x,&y);
	    cmax--;
	    
	    for(i=0; i< cmax-cpos;i++){
	      nkc_setxy(x+i,y);
	      nkc_putchar(Line[cpos+i+1]);
	      Line[cpos+i] = Line[cpos+i+1];
	    }
	    nkc_setxy(x+i,y);
	    nkc_putchar(' ');
	    nkc_setxy(x,y);
	    
	    break;
	  case 0x16:	// Insert  
	    insmode = !insmode;
	    // Cursor-Shape ändern ...
	    break;
	  
	  default:	// other character  
	    if(!insmode || cpos == cmax){
	      Line[cpos] = c;
	      nkc_putchar(c); // echo char	    
	      cpos++;
	      if(cpos > cmax) cmax = cpos;
	    } else {				// insert mode...
	      nkc_getxy(&x,&y);
	      
	      for(i=0; i<= cmax-cpos;i++){
		cc = Line[cpos+i];		
		nkc_putchar(' ');		
		nkc_setxy(x+i,y);
		Line[cpos+i] = c;
		nkc_putchar(c);
		c = cc;
	      }	
	      nkc_setxy(x+1,y);	      
	      cpos++; cmax++;	      
	    }
	    break;
      }
    
    
    }while(!cr);   
}
