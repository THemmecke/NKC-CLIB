#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>
#include <libp.h>
#include <debug.h>


int scanf(const char *format, ...)
{
	char buf[512];
	
	clio_lldbg("scanf...\n");



	if (!gets(buf))
		return 0;
	return _scanf(buf,format,((char *)&format+sizeof(char *)));
}
