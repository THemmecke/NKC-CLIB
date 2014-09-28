#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>
#include <libp.h>

//#define NKC_DEBUG

#ifdef NKC_DEBUG
#include "../nkc/llnkc.h"
#endif

size_t fread(void *buf, size_t size, size_t count, FILE *stream)
{
	int rv;
	int len = count * size,i;
	char *lbuf = buf;
	
	#ifdef NKC_DEBUG
	nkc_write("fread...\n");
	#endif
	
	if (stream->token != FILTOK)
	{
		#ifdef NKC_DEBUG
		nkc_write("...fread(1)\n"); nkc_getchar();	
		#endif
		return 0;
	}
	
	
	if (!(stream->flags & _F_READ)) {
		stream->flags |= _F_ERR;
		#ifdef NKC_DEBUG
		nkc_write("...fread(2)\n"); nkc_getchar();	
		#endif
		return 0;
	}
	
	#ifdef NKC_DEBUG	
	nkc_write(" +");
	#endif	
	for (i=0; i < len; i++) {
		#ifdef NKC_DEBUG
		nkc_write("+");
		#endif
		rv = _basegetc(stream);
		if (rv == EOF)
		{
			//TH: JADOS EOF handling (see also _basegetc in putget.c)
			//if (!(stream->flags & _F_BIN)) *lbuf++ = 0;
			#ifdef NKC_DEBUG
			nkc_write("...fread(EOF)\n"); nkc_getchar();	
			#endif
			return i / size;
		}
		*lbuf++ = (char) rv;
	}
	#ifdef NKC_DEBUG
	nkc_write("...fread\n"); nkc_getchar();	
	#endif
	return count;
}
