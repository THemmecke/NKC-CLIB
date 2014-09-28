#include <stdio.h>
#include <time.h>
#include <libp.h>

long ftell(FILE *stream)
{
	long rv=0;
	if (fgetpos(stream,&rv))
		return -1;
	return rv;
}