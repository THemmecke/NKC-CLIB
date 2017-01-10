#include <stdio.h>
#include <stdlib.h>
#include <debug.h>

int setvbuf(FILE *stream, char *buf, int mode, size_t size)
{

	clio_dbg("setvbuf...\n");
	if (stream->token != FILTOK)
	{
		clio_dbg("...setvbuf(1)\n");
	
		return 1;
	}
	switch (mode) 
	{
		case _IOFBF:
		case _IOLBF:
		case _IONBF:
			break;
		default:
			clio_dbg("...setvbuf(2)\n");
			
			return 1;
	}
	if (fflush(stream))
	{
		clio_dbg("...setvbuf(3)\n");
		
		return 1;
	}
	if (stream->flags & _F_BUF)
		free(stream->buffer);
	stream->flags &= ~(_F_BUF | _F_LBUF);
	stream->buffer = buf;
	stream->bsize = size;
	stream->level = 0;
	switch (mode) {
		case _IOFBF:
			break;
		case _IOLBF:
			stream->flags |= _F_LBUF;
			break;
		case _IONBF:
			stream->buffer = 0;
			stream->bsize = 0;
			break;
		default:
			clio_dbg("...setvbuf(4)\n");
			
			return 1;
	}
	
	clio_dbg("...setvbuf\n");
	
	return 0;
	
}
