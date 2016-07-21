#ifndef __SHELL_H
#define __SHELL_H

// type definitions

#define MAX_CHAR 300
#define MAX_HISTORY 10

extern char HistoryBuffer[MAX_HISTORY+1][MAX_CHAR]; /* History Buffer */
extern char histOLDEST;                         /* Oldest entry */
extern char histNEWEST;			    /* Last/Newest entry */
extern char histLEVEL;

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


extern struct CMDHLP hlptxt[];
extern struct CMD internalCommands[];

char *ltrimcl(const char *str);
int is_fnchar(const int c);

void displayCmdHlp(unsigned help_id);

void shell();

int showcmds(char *);

static void execute(char *first, char *rest);

#endif
