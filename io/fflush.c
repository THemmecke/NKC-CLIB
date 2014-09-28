#include <stdio.h>
#include <time.h>
#include <memory.h>
#include <libp.h>

//#define NKC_DEBUG

#ifdef NKC_DEBUG
#include "../nkc/llnkc.h"
#endif

extern FILE *_pstreams[_NFILE_];
extern char *_filenames[_NFILE_];
extern int maxfiles;

static int oneflush(FILE *stream)
{
	char * crlf = "\n";
	int rv = 0;
	
	#ifdef NKC_DEBUG
	nkc_write("oneflush...\n");
	#endif
	
	if (stream->token == FILTOK) {
		
		if (stream->buffer)
			if (stream->flags & _F_OUT) {
				
				rv = _ll_write(stream->fd,stream->buffer,stream->level);
				if (!rv) {
					
					stream->flags |= _F_ERR;
					rv = EOF;
					#ifdef NKC_DEBUG
					nkc_write("EOF\n");
					#endif
				}
				else rv = 0;
				stream->level = 0;
			}
			else if (stream->flags & _F_READ) {
				
				memset(stream->buffer,0,stream->bsize);
				stream->level = 0;
			}
		
		stream->hold = 0;
		stream->curp = stream->buffer;
		if (stream->flags & _F_IN) 
		{
			
			_ll_seek(stream->fd,_ll_getpos(stream->fd)-stream->level,SEEK_SET);
		}
		stream->flags &= ~(_F_IN | _F_OUT);
		
		#ifdef NKC_DEBUG
		nkc_write("...oneflush\n");
		#endif
		return rv;			
	}
	else {
		#ifdef NKC_DEBUG
		nkc_write("...oneflush(EOF)\n");
		#endif
		return EOF;
	}
}
int fflush(FILE *stream)
{
	int rv, res;
	
	#ifdef NKC_DEBUG
	nkc_write("fflush...\n");
	#endif
	
	if (stream)	
	{
		res = oneflush(stream);
		#ifdef NKC_DEBUG
		nkc_write("...fflush\n");
		#endif
		return(res);
	}
	else {
		int i;
		for (i=0; i < maxfiles; i++)
			rv |= oneflush(_pstreams[i]);
	}
	
	#ifdef NKC_DEBUG
	nkc_write("...fflush(1)\n");
	#endif
	return rv;
}
