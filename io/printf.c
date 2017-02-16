#include <stdio.h>
#include "../nkc/llnkc.h"

int printf(const char *format, ...)
{	
	return vfprintf(stdout,format,((char *)&format+sizeof(char *)));
}

void perror(const char *__s)
{
	gp_write(__s);
}
