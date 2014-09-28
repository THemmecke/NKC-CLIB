#include <stdio.h>
#include "../nkc/llnkc.h"

int puts(const char *string)
{
	
	
	int rv = fputs(string,stdout);
	if (rv == EOF)
		return EOF;
	return fputc('\n',stdout);
}
