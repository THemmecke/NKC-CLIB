#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>
#include <libp.h>
#include <debug.h>

size_t fread(void *buf, size_t size, size_t count, FILE *stream)
{
	int rv;
	int len = count * size,i;
	char *lbuf = buf;
	
	clio_lldbg("fread...\n");

	
	if (stream->token != FILTOK)
	{
		clio_lldbgwait("...fread(1)\n"); 
		return 0;
	}
	
	
	if (!(stream->flags & _F_READ)) {
		stream->flags |= _F_ERR;
		clio_lldbgwait("...fread(2)\n"); 
		return 0;
	}
	
	clio_lldbg(" +");
	
	for (i=0; i < len; i++) {
		clio_lldbg("+");
		rv = _basegetc(stream); // !
		if (rv == EOF)
		{
			//TH: JADOS EOF handling (see also _basegetc in putget.c)
			//if (!(stream->flags & _F_BIN)) *lbuf++ = 0;
			clio_lldbgwait("...fread(EOF)\n"); 
			return i / size;
		}
		*lbuf++ = (char) rv;
	}
	clio_lldbgwait("...fread\n");
	return count;
}
