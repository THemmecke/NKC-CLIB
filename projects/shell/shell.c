#include <stdio.h>
#include <string.h>
 

#include "shell.h"
#include "cmd.h"


// global variables
static char Line[300];			/* Console input/output buffer */
char com[300];
char args[300];
char CurrDirPath[300];
char TestString[] = "MTOOLS.TXT MT.TXT\0";

void shell()
{
  struct CMD *cmdptr;
  char *ptr,*cp;
  int res;
     
  sprintf(CurrDirPath,"/");
 
  // initialize and mount drive 0 
  cmd_dinit("0");    
  cmd_fmount("0 1");
  
 
  for(;;)
  {
  
     printf("%s>",CurrDirPath);
     gets(Line);   
     
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
      /*
        printf(" give cmd_chdrive(%s)= a try ...\n",com);

        res = cmd_chdrive(com);

        printf(" it returned %d !\n",res);
        if(res == -1)
        */
                printf("%s: command not found\n",com);
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

