#include <stdio.h>
#include <string.h>
#include <types.h>
#include <ioctl.h>
#include <errno.h>
#include <debug.h>

#include <fs.h> 

#include "../../nkc/llnkc.h"
#include "../../fs/fat/ff.h"
#include "shell.h"

extern char keyci(void); /* -> nkc/llmisc.S */

/*---------------------------------------------------------*/
/* Work Area                                               */
/*---------------------------------------------------------*/
static struct SHELL_ENV *pENV = NULL;
// global variables


void shell(void (*prompt) (void), struct SHELL_ENV *penv, struct CMD *pCommands, struct CMDHLP *phlptxt, unsigned char single)
{
  struct CMD *cmdptr;
  char *ptr,*cp;
  int res;     
 
  pENV = penv;
  
  for(;;)
  {
   
     getcommand(prompt, penv, single);
     
     ptr = ltrimcl(penv->Line); // skip leading spaces
      
     cp = penv->com; 
     while(*ptr && is_fnchar(*ptr))
      *cp++ = *ptr++;//toupper(*ptr++);
    
     *cp = '\0'; // terminate first word
           
     cp = penv->args;       
     while(*ptr)
      *cp++ = *ptr++;
     
     *cp = '\0'; // terminate argument string
             
     
     /* Scan internal command table */
     
     for (cmdptr = pCommands
        ; cmdptr->name && strcmp(penv->com, cmdptr->name) != 0
        ; cmdptr++){
                //printf("compare %s against %s...\n",com,cmdptr->name); getchar();
        }

     
     if(cmdptr->name)
     { // command found                         
        if(memcmp(ltrimcl(penv->args), "/?", 2) == 0)  {
          displayCmdHlp(phlptxt, cmdptr->help_id);
        } else {       
         //printf("invoke...\n"); getchar();
         if(cmdptr->func(penv->args)) break; 
        }                
     } else { // command not found
        // is it a 'change drive' command ?                     
       //printf(" checking for drive in '%s' - last char is %c\n",com, com[strlen(com)-1]);
       
       res = EINVAL;
       if(penv->com[strlen(penv->com)-1] == ':') {
	 penv->com[strlen(penv->com)-1] = 0;
	 printf(" change drive %s\n",penv->com);
	 res = cmd_chdrive(penv->com);
       }
       
       cp =penv->com;
       while (*cp == ' ') cp++; // check if something meaningful was entered anyway....
       if(*cp == 0) res = FR_OK;
	                
       if (res != FR_OK) printf("%s: command not found\n",penv->com);
     }
  }
     
}





#define isargdelim(ch) (isspace(ch) || iscntrl(ch) || strchr(",;=", ch))

char *ltrimcl(const char *str)
{ char c;

  while ((c = *str++) != '\0' && isargdelim(c))
    ;

  return (char *)str - 1;               /* strip const */
}

int is_fnchar(const int c)
{
  return !(c <= ' ' || c == 0x7f || strchr(".\"/\\[]|<>+=;,", c));
}


void displayCmdHlp(struct CMDHLP *phlptxt, unsigned id)
{
    struct CMDHLP *hlpptr;    
     /* Scan help texts */
     for (hlpptr = phlptxt
        ; hlpptr->help_id != id && hlpptr->help_id != 0
        ; hlpptr++);
        
        if(hlpptr->help_id)
         printf(hlpptr->syntax);
}


int showcmds(struct CMDHLP *phlptxt)
{
    struct CMDHLP *hlpptr; 
    int linecnt = 0, stop = 0;
    char c;

    printf(" Available commands:\n\n");

    for (hlpptr = phlptxt
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

void getcommand(	void (*prompt) (void), 	/* pointer to a function providing a prompt */
	             	struct SHELL_ENV *penv, /* shell environment */
	             	unsigned char single){	/* only single character input ? (1) */
    char c,cc;
    unsigned char i,x,y,cpos,cmax,cr;
    
    prompt();
      
    cpos = cmax = 0;
    cr=0;
    c=0;
    
    penv->Line[cpos] = c;
    
    do{
      c = keyci();//gp_getchar();
    
      switch(c) {
	  case 0x05:	// UP (go back in history)
	      
	      if(penv->histLEVEL == penv->histNEWEST) { // save current line
		penv->HistoryBuffer[penv->histNEWEST][0] = 0;
		penv->Line[cmax] = 0;	
		strcat(penv->HistoryBuffer[penv->histNEWEST],penv->Line);	      		
	      }
	      
	      if(penv->histLEVEL != penv->histOLDEST) {		
	        penv->histLEVEL--;
	      }
	      if(penv->histLEVEL < 0) penv->histLEVEL = MAX_HISTORY;
	      
					  // delete current Line ....
	      gp_getxy(&x,&y);
	      gp_setxy(x-cpos,y);             	// goto Pos1
	      i = 0;
	      while(i<cpos){		       	// erase all characters
	        gp_setxy(x-cpos+i++,y);
	        gp_putchar(' ');
	      }		
	      gp_setxy(x-cpos,y);             	// goto Pos1		      
	      
	      penv->Line[0] = 0;	      		// print line from history buffer
	      strcat(penv->Line,penv->HistoryBuffer[penv->histLEVEL]);
	      cpos = cmax = strlen(penv->Line);	      
	      printf("%s",penv->Line); 
	      
	      break;
	  case 0x18:	// DOWN (go forth in history)
	      if(penv->histLEVEL != penv->histNEWEST) penv->histLEVEL++;
	      if(penv->histLEVEL > MAX_HISTORY) penv->histLEVEL = 0;
	      
	                                    // delete current Line ....
	      gp_getxy(&x,&y);
	      gp_setxy(x-cpos,y);             	// goto Pos1
	      i = 0;
	      while(i<cpos){		       	// erase all characters
	        gp_setxy(x-cpos+i++,y);
	        gp_putchar(' ');
	      }		
	      gp_setxy(x-cpos,y);             	// goto Pos1		      
	      
	      penv->Line[0] = 0;	      		// print line from history buffer
	      strcat(penv->Line,penv->HistoryBuffer[penv->histLEVEL]);
	      cpos = cmax = strlen(penv->Line);	      
	      printf("%s",penv->Line); 
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
	    penv->Line[cmax]=0;
	    
	    // History Management ----
	
	    // copy current line to buffer
	    penv->HistoryBuffer[penv->histNEWEST][0] = 0;
	    strcat(penv->HistoryBuffer[penv->histNEWEST],penv->Line);
	
	    // Set Buffer Pointer	
	    if(penv->histNEWEST < MAX_HISTORY) {
	      penv->histNEWEST++;
	    } else {
	      penv->histNEWEST = 0;
	    }
	    if(penv->histNEWEST == penv->histOLDEST) { 
	      if(penv->histOLDEST < MAX_HISTORY) {
		penv->histOLDEST++;
	      }else{
		penv->histOLDEST = 0;
	      }
	    }
	    
	    penv->histLEVEL = penv->histNEWEST;
	    
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
	      gp_putchar(penv->Line[cpos+i+1]);
	      penv->Line[cpos+i] = penv->Line[cpos+i+1];
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
	      gp_putchar(penv->Line[cpos+i+1]);
	      penv->Line[cpos+i] = penv->Line[cpos+i+1];
	    }
	    gp_setxy(x+i,y);
	    gp_putchar(' ');
	    gp_setxy(x,y);
	    
	    break;
	  case 0x16:	// Insert  
	    penv->insmode = !penv->insmode;
	    // Cursor-Shape ändern ...
	    break;
	  
	  default:	// other character  
	    if(!penv->insmode || cpos == cmax){
	      penv->Line[cpos] = c;
	      gp_putchar(c); // echo char	    
	      cpos++;
	      if(cpos > cmax) cmax = cpos;
	    } else {				// insert mode...
	      gp_getxy(&x,&y);
	      
	      for(i=0; i<= cmax-cpos;i++){
		cc = penv->Line[cpos+i];		
		gp_putchar(' ');		
		gp_setxy(x+i,y);
		penv->Line[cpos+i] = c;
		gp_putchar(c);
		c = cc;
	      }	
	      gp_setxy(x+1,y);	      
	      cpos++; cmax++;	      
	    }
	    break;
      }
    
    	
    }while(!cr && !single);   

    if(single) printf("\n");
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



unsigned char 							/* return 1 for successfull */
     getline(struct LINE_ENV *penv, 	/* line editor einvironment */
			 unsigned char rtype, 		/* expected result type as defined in enum RESULT_TYPE */	
			 union RESULT res, 			/* result */
	         unsigned char single){ 	/* only single character input ? (1) */
    char c,cc;
    unsigned char i,x,y,cpos,cmax,cr;
    
    //prompt();
      
    cpos = cmax = 0;
    cr=0;
    c=0;
    
    penv->Line[cpos] = c;
    
    do{
      c = keyci();//gp_getchar();
    
      switch(c) {
	//  case 0x05:	// UP (go back in history)
	//      
	//      if(penv->histLEVEL == penv->histNEWEST) { // save current line
	//	penv->HistoryBuffer[penv->histNEWEST][0] = 0;
	//	penv->Line[cmax] = 0;	
	//	strcat(penv->HistoryBuffer[penv->histNEWEST],penv->Line);	      		
	//      }
	//      
	//      if(penv->histLEVEL != penv->histOLDEST) {		
	//        penv->histLEVEL--;
	//      }
	//      if(penv->histLEVEL < 0) penv->histLEVEL = MAX_HISTORY;
	//      
	//				  // delete current Line ....
	//      gp_getxy(&x,&y);
	//      gp_setxy(x-cpos,y);             	// goto Pos1
	//      i = 0;
	//      while(i<cpos){		       	// erase all characters
	//        gp_setxy(x-cpos+i++,y);
	//        gp_putchar(' ');
	//      }		
	//      gp_setxy(x-cpos,y);             	// goto Pos1		      
	//      
	//      penv->Line[0] = 0;	      		// print line from history buffer
	//      strcat(penv->Line,penv->HistoryBuffer[penv->histLEVEL]);
	//      cpos = cmax = strlen(penv->Line);	      
	//      printf("%s",penv->Line); 
	//      
	//      break;
	//  case 0x18:	// DOWN (go forth in history)
	//      if(penv->histLEVEL != penv->histNEWEST) penv->histLEVEL++;
	//      if(penv->histLEVEL > MAX_HISTORY) penv->histLEVEL = 0;
	//      
	//                                    // delete current Line ....
	//      gp_getxy(&x,&y);
	//      gp_setxy(x-cpos,y);             	// goto Pos1
	//      i = 0;
	//      while(i<cpos){		       	// erase all characters
	//        gp_setxy(x-cpos+i++,y);
	//        gp_putchar(' ');
	//      }		
	//      gp_setxy(x-cpos,y);             	// goto Pos1		      
	//      
	//      penv->Line[0] = 0;	      		// print line from history buffer
	//      strcat(penv->Line,penv->HistoryBuffer[penv->histLEVEL]);
	//      cpos = cmax = strlen(penv->Line);	      
	//      printf("%s",penv->Line); 
	//    break;
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
	    penv->Line[cmax]=0;
	    
	//    // History Management ----
	//
	//    // copy current line to buffer
	//    penv->HistoryBuffer[penv->histNEWEST][0] = 0;
	//    strcat(penv->HistoryBuffer[penv->histNEWEST],penv->Line);
	//
	//    // Set Buffer Pointer	
	//    if(penv->histNEWEST < MAX_HISTORY) {
	//      penv->histNEWEST++;
	//    } else {
	//      penv->histNEWEST = 0;
	//    }
	//    if(penv->histNEWEST == penv->histOLDEST) { 
	//      if(penv->histOLDEST < MAX_HISTORY) {
	//	penv->histOLDEST++;
	//      }else{
	//	penv->histOLDEST = 0;
	//      }
	//    }
	//    
	//    penv->histLEVEL = penv->histNEWEST;
	//    
	//    // ------------------------
	    
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
	      gp_putchar(penv->Line[cpos+i+1]);
	      penv->Line[cpos+i] = penv->Line[cpos+i+1];
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
	      gp_putchar(penv->Line[cpos+i+1]);
	      penv->Line[cpos+i] = penv->Line[cpos+i+1];
	    }
	    gp_setxy(x+i,y);
	    gp_putchar(' ');
	    gp_setxy(x,y);
	    
	    break;
	  case 0x16:	// Insert  
	    penv->insmode = !penv->insmode;
	    // Cursor-Shape ändern ...
	    break;
	  
	  default:	// other character  
	    if(!penv->insmode || cpos == cmax){
	      penv->Line[cpos] = c;
	      gp_putchar(c); // echo char	    
	      cpos++;
	      if(cpos > cmax) cmax = cpos;
	    } else {				// insert mode...
	      gp_getxy(&x,&y);
	      
	      for(i=0; i<= cmax-cpos;i++){
		cc = penv->Line[cpos+i];		
		gp_putchar(' ');		
		gp_setxy(x+i,y);
		penv->Line[cpos+i] = c;
		gp_putchar(c);
		c = cc;
	      }	
	      gp_setxy(x+1,y);	      
	      cpos++; cmax++;	      
	    }
	    break;
      }
    
    	
    }while(!cr && !single);   

    if(single) printf("\n");

    return rtype;
}


static const char progress[] = { '|','/','-','\\' };
static progress_cnt;
static BYTE xpos,ypos;
void start_progress(void){
	progress_cnt = 0;
	printf("[");
	gp_getxy(&xpos,&ypos);
	printf("\\]");
}

void do_progress(void){
		gp_setxy(xpos,ypos);
		gp_putchar(progress[progress_cnt % 4]);
	    progress_cnt++;
}