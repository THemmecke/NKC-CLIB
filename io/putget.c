#include <stdio.h>
#include <time.h>
#include <libp.h>

//#define NKC_DEBUG

#ifdef NKC_DEBUG
#include "../nkc/llnkc.h"
#endif


int _baseputc(int c, FILE *stream)
{
	unsigned char rv = (unsigned char) c;
	
	#ifdef NKC_DEBUG
	nkc_write("_baseputc...\n");
	#endif			
		
	if (!(stream->flags & _F_BIN) && c == '\n')
	{		
		#ifdef NKC_DEBUG
		nkc_write("\\n detected (1)\n"); nkc_getchar();	
		#endif
		if (_baseputc('\r',stream) == EOF)		// stream is ASCII => insert 0x0d before 0x0a ! (DOS,NKC format)
		{
			#ifdef NKC_DEBUG
			nkc_write("..._baseputc(1)\n"); nkc_getchar();	
			#endif			

			return EOF;
		}
	}
		
		
	if (stream->bsize) {
		if (_writebuf(stream)) { 			// _baseputc is working on a 512 byte buffer (see io)
			stream->flags |= _F_ERR;
			#ifdef NKC_DEBUG
			nkc_write("..._baseputc(2)\n"); nkc_getchar();	
			#endif			
			return EOF;
		}

		stream->flags |= _F_OUT;
		*stream->curp++ = (char)c;
		stream->level++;
		if (c == '\n' && (stream->flags & _F_LBUF))
		{
			#ifdef NKC_DEBUG
			nkc_write("\\n detected (2)\n"); nkc_getchar();	
			#endif
		
			fflush(stream);				// flush buffer after \n
		}
		
		#ifdef NKC_DEBUG
		nkc_write("..._baseputc(3)\n"); nkc_getchar();	
		#endif			
		return c;
	}
	else {	      
		if (_ll_write(stream->fd,&rv,1)) {		// is only used if bsize==0, i.e. no buffer used		
			stream->flags |= _F_ERR;
			#ifdef NKC_DEBUG
			nkc_write("..._baseputc(4)\n"); nkc_getchar();	
			#endif			
			return EOF;
		}
	}
	#ifdef NKC_DEBUG
	nkc_write("..._baseputc\n"); nkc_getchar();	
	#endif			
	return c;
}

int _basegetc(FILE *stream)
{
	unsigned char rv;
	
	#ifdef NKC_DEBUG
	nkc_write("_basegetc...\n");
	#endif
	
	if (stream->bsize) 
	{
		if (_readbuf(stream)) // -> io/readbuf.c
		{
			#ifdef NKC_DEBUG
			nkc_write("..._basegetc(EOF)\n"); nkc_getchar();	
			#endif			
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
				#ifdef NKC_DEBUG
				nkc_write("..._basegetc(2)\n"); nkc_getchar();	
				#endif			
				return('\n');				
			}
			else { 				
				if (*stream->curp == '\n' && stream->flags & _F_SKIPLF) {
					stream->level--;
					stream->curp++;
					stream->flags &= ~_F_SKIPLF;
					#ifdef NKC_DEBUG
					nkc_write("..._basegetc(3)\n"); nkc_getchar();	
					#endif			
					return(_basegetc(stream));
				}								
			}
				
			if(*stream->curp == 0) 			// JADOS EOF for ASCII files
				{		
					#ifdef NKC_DEBUG	
					nkc_write(" - JADOS ASCII EOF - \n"); 		
					nkc_write("..._basegetc(4)\n"); nkc_getchar();	
					#endif
					stream->flags |= _F_EOF;	// set flag
					stream->level--;				
					return EOF; 			// return EOF
				}
		}
		
		
		stream->level--;
		#ifdef NKC_DEBUG
		nkc_write("..._basegetc\n"); //nkc_getchar();	
		#endif
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
			#ifdef NKC_DEBUG
			nkc_write("..._basegetc(5)\n"); nkc_getchar();	
			#endif
			return EOF;
		}
	}
	#ifdef NKC_DEBUG
	nkc_write("..._basegetc(6)\n"); nkc_getchar();	
	#endif
	return(rv);
}
		
