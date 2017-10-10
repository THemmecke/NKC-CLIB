#include <stdio.h>
#include <time.h>
#include <libp.h>
#include <debug.h>


int _baseputc(int c, FILE *stream)
{
	unsigned char rv = (unsigned char) c;
	
	clio_lldbg("_baseputc...\n");
		
	if (!(stream->flags & _F_BIN) && c == '\n') // stream is ASCII and \n detected
	{		
		clio_lldbgwait("\\n detected (1)\n"); 
		
		if (_baseputc('\r',stream) == EOF)		// stream is ASCII => insert 0x0d before 0x0a ! (DOS,NKC format)
		{
			clio_lldbgwait("..._baseputc(1)\n");

			return EOF;
		}
	}
		
		
	if (stream->bsize) {
		if (_writebuf(stream)) { 			// _baseputc is working on a 512 byte buffer (see io)
			stream->flags |= _F_ERR;
			
			clio_lldbgwait("..._baseputc(2)\n");
			
			return EOF;
		}

		stream->flags |= _F_OUT;
		*stream->curp++ = (char)c;
		stream->level++;
		if (c == '\n' && (stream->flags & _F_LBUF))
		{
			clio_lldbgwait("\\n detected (2)\n");
		
			fflush(stream);				// flush buffer after \n
		}
		
		clio_lldbgwait("..._baseputc(3)\n"); 
		return c;
	}
	else {	      
		if (_ll_write(stream->fd,&rv,1)) {		// is only used if bsize==0, i.e. no buffer used		
			stream->flags |= _F_ERR;
			clio_lldbgwait("..._baseputc(4)\n"); 
			return EOF;
		}
	}
	clio_lldbgwait("..._baseputc\n"); 
	return c;
}

int _basegetc(FILE *stream)
{
	unsigned char rv;
	
	clio_lldbg("_basegetc...\n");
	
	if (stream->bsize) 
	{
		if (_readbuf(stream)) // -> io/readbuf.c
		{
			clio_lldbgwait("..._basegetc(EOF)\n");
			return EOF;
		}
		/* TH: CR/LF handling funktioniert so nicht unter JADOS => Dateien immer binär öffnen */
		if (!(stream->flags & _F_BIN))          // if this file os NOT binary ...
		{
			if (*stream->curp == '\r') 
			{
				stream->flags |= _F_SKIPLF;
				stream->level--;
				stream->curp++;
				clio_lldbgwait("..._basegetc(2)\n"); 
				return('\n');				
			}
			else { 				
				if (*stream->curp == '\n' && stream->flags & _F_SKIPLF) {
					stream->level--;
					stream->curp++;
					stream->flags &= ~_F_SKIPLF;
					clio_lldbgwait("..._basegetc(3)\n");
					return(_basegetc(stream));
				}								
			}
				
			if(*stream->curp == 0) 			// JADOS EOF for ASCII files
				{		
					clio_lldbg(" - JADOS ASCII EOF - \n"); 		
					clio_lldbgwait("..._basegetc(4)\n"); 
					stream->flags |= _F_EOF;	// set flag
					stream->level--;				
					return EOF; 			// return EOF
				}
		}
		
		
		stream->level--;
		clio_lldbg("..._basegetc\n"); //!
		return(*stream->curp++);
	}
	else if (stream->hold) 
	{
		rv = stream->hold;
		stream->hold = 0;
	}
	else 
	{
	        // hier erfolgt der Aufruf der low-level routinen --> /nkc/llstd.S
		if (!_ll_read(stream->fd,&rv,1)) 
		{
			stream->flags |= _F_EOF;
			clio_lldbgwait("..._basegetc(5)\n");
			return EOF;
		}
	}
	clio_lldbgwait("..._basegetc(6)\n"); 
	return(rv);
}
		
