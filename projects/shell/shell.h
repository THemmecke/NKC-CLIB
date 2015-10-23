#ifndef __SHELL_H
#define __SHELL_H

// type definitions

#define MAX_CHAR 300


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

#endif
