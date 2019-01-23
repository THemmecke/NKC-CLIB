#ifndef __SHELL_H
#define __SHELL_H

// type definitions

#define MAX_CHAR 300
#define MAX_HISTORY 10

struct CMD
{
  char *name;
  int (*func) (char *);
  unsigned help_id;
};

struct CMDHLP
{
    unsigned help_id;
    char* text;   
    char* syntax; 
};

struct SHELL_ENV
{
  char Line[MAX_CHAR];			/* Console input/output buffer */
  char com[MAX_CHAR];				/* command */
  char args[MAX_CHAR];				/* command argumennts */
  char HistoryBuffer[MAX_HISTORY+1][MAX_CHAR]; /* History Buffer */
  char histOLDEST;                         /* Oldest entry */
  char histNEWEST;			    /* Last/Newest entry */
  char histLEVEL;			    
  unsigned char insmode;			/* comand line insert mode on/off */
};



enum RESULT_TYPE {
  RES_CHAR = 1,
  RES_UCHAR,
  RES_SHORT,
  RES_USHORT,
  RES_INT,
  RES_UINT
};

union RESULT
{
  /* 8 bit result types */
  char _char;
  unsigned char _uchar;
  /* 16 bit result types */
  short _short;
  unsigned short _ushort;
  /* 32 bit result types */
  int _int;
  unsigned int _uint;
};


struct LINE_ENV
{
  char Line[MAX_CHAR];      /* Console input/output buffer */       
  unsigned char insmode;      /* comand line insert mode on/off */
  /*----*/
  char char_result;

};


char *ltrimcl(const char *str);
int is_fnchar(const int c);

void displayCmdHlp(struct CMDHLP *phlptxt, unsigned id);
void getcommand(void (*prompt) (void), struct SHELL_ENV *penv, unsigned char single);     /* input line editor */
void shell(void (*prompt) (void), struct SHELL_ENV *penv, struct CMD *pCommands, struct CMDHLP *phlptxt, unsigned char sinigle);

int showcmds(struct CMDHLP *phlptxt);

static void execute(char *first, char *rest); /* for executing external commands ... */

unsigned char               /* return 1 for successfull */
getline(struct LINE_ENV *penv,   /* line editor einvironment */
        unsigned char rtype,     /* expected result type as defined in enum RESULT_TYPE */ 
        union RESULT res,      /* result */
        unsigned char single);   /* only single character input ? (1) */

void start_progress(void);
void do_progress(void);

#endif
