#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <libp.h>


extern char **_env_arr;
char *getenv(const char *varname)
{
	char **q = _env_arr;
	int len = strlen(varname);
	while (*q) {
		if (!strncmp(varname,*q,len))
		return(*q+len+1);
		q++;
	}
	return 0;
}