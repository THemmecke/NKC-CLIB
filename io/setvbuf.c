#include <stdio.h>
#include <stdlib.h>


//#define NKC_DEBUG

#ifdef NKC_DEBUG
#include "../nkc/llnkc.h"
#endif

int setvbuf(FILE *stream, char *buf, int mode, size_t size)
{

	#ifdef NKC_DEBUG
	nkc_write("setvbuf...\n");
	#endif
	if (stream->token != FILTOK)
	{
		#ifdef NKC_DEBUG
		nkc_write("...setvbuf(1)\n");
		#endif
		return 1;
	}
	switch (mode) 
	{
		case _IOFBF:
		case _IOLBF:
		case _IONBF:
			break;
		default:
			#ifdef NKC_DEBUG
			nkc_write("...setvbuf(2)\n");
			#endif
			return 1;
	}
	if (fflush(stream))
	{
		#ifdef NKC_DEBUG
		nkc_write("...setvbuf(3)\n");
		#endif
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
			#ifdef NKC_DEBUG
			nkc_write("...setvbuf(4)\n");
			#endif
			return 1;
	}
	
	#ifdef NKC_DEBUG
	nkc_write("...setvbuf\n");
	#endif
	return 0;
	
}
