#ifndef __HELPER_H
#define __HELPER_H

extern struct fpinfo FPInfo; //  working struct for checkfp (check file-path), also stores current drive and path
extern struct fpinfo FPInfo1, FPInfo2; // working buffer(2) for arbitrary use with checkfp and checkargs


// initialization functions

void init_helper(void);
void exit_helper(void); 



int checkargs(char* args, char* fullpath1, char* fullpath2);

int xatos (			/* 0:Failed, 1:Successful */
	char **str,		/* Pointer to pointer to the string */
	char *res,		/* Pointer to a variable to store the sub-string */
	int len			/* max length of sub-string without terminating NULL */
);

int xatoi (			/* 0:Failed, 1:Successful */
	char **str,	/* Pointer to pointer to the string Note: char var[x] => &var cannot be used directly, use pvar = &var instead !*/
	long *res		/* Pointer to a variable to store the value Note: MUST be 32 bits ! */
);

#endif