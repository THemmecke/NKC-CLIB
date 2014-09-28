#include <stdlib.h>
#include <ctype.h>
#include <string.h>

int _argc;
char **_argv_arr;
char *_cmdline;

/*
#pragma startup argset 19
*/
//static void argset(void)
// for this function should also be visisble to other modules
void argset(void)
{
	char buf[200];
	char *bufp[100];
	int i;
	_argc = 1;
	bufp[0] = "File name unknown";
	
	
	while (*_cmdline) {
		while (isspace(*_cmdline)) _cmdline++;
		if (*_cmdline) {
			int i = 0;
			while (!isspace(*_cmdline) && *_cmdline)
				buf[i++] = *_cmdline++;
			buf[i++] = 0;
			bufp[_argc] = malloc(i);
			strcpy(bufp[_argc++],buf);
		}
	}	
	_argv_arr = malloc(_argc*sizeof(char *));
	memcpy(_argv_arr,bufp,_argc*sizeof(char *));
}
