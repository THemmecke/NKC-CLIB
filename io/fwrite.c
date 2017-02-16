#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>
#include <libp.h>
#include <debug.h>

size_t fwrite(const void *buf, size_t size, size_t count, FILE *stream)
{
	int len = size * count,i,c;
	
	clio_lldbg("fwrite...\n");


	if (stream->token != FILTOK)
	{
		clio_lldbgwait("...fwrite(1)\n"); 
		return 0;
	}
	if (!(stream->flags & _F_WRIT)) 
	{
		stream->flags |= _F_ERR;	  
		clio_lldbgwait("...fwrite(2)\n"); 
		return 0;
	   
	}
	for (i=0; i < len; i++)
	{
		c = _baseputc(*((unsigned char *)buf++),stream);
		if (c == EOF)
		{
			clio_lldbgwait("...fwrite(3)\n");
			return i / size;
		}
	}
	
	clio_lldbgwait("...fwrite\n"); 
	return count;
}
