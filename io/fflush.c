#include <stdio.h>
#include <time.h>
#include <memory.h>
#include <libp.h>
#include <debug.h>

extern FILE *_pstreams[_NFILE_];
extern char *_filenames[_NFILE_];
extern int maxfiles;

static int oneflush(FILE *stream)
{
	char * crlf = "\n";
	int rv = 0;
	
	clio_lldbg("oneflush...\n");	
	
	if (stream->token == FILTOK) {
		
		if (stream->buffer)
			if (stream->flags & _F_OUT) {
				
				rv = _ll_write(stream->fd,stream->buffer,stream->level);
				if (!rv) {
					
					stream->flags |= _F_ERR;
					rv = EOF;
					
					clio_lldbg("EOF\n");
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
		
		clio_lldbg("...oneflush\n");
		return rv;			
	}
	else {
		clio_lldbg("...oneflush(EOF)\n");
		return EOF;
	}
}
int fflush(FILE *stream)
{
	int rv, res;
	
	clio_lldbg("fflush...\n");
	
	if (stream)	
	{
		res = oneflush(stream);
		clio_lldbg("...fflush\n");
		return(res);
	}
	else {
		int i;
		for (i=0; i < maxfiles; i++)
			rv |= oneflush(_pstreams[i]);
	}
	
	clio_lldbg("...fflush(1)\n");
	return rv;
}
