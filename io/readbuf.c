#include <stdio.h>
#include <time.h>
#include <libp.h>


//#define NKC_DEBUG

#ifdef NKC_DEBUG
#include "../nkc/llnkc.h"
#endif

int _readbuf(FILE *stream)
{	
	#ifdef NKC_DEBUG
	nkc_write("_readbuf...\n");
	#endif
	if (!(stream->flags & _F_IN) || !stream->level)  // stream is NOT incoming or buffer empty
	{
		if (stream->flags & _F_OUT) // file is outgoing
		{			
			if (fflush(stream))
			{
				#ifdef NKC_DEBUG
				nkc_write("..._readbuf(1)\n"); nkc_getchar();
				#endif
				return EOF;
			}
		}
		
		stream->flags &= ~_F_OUT;  	// clear "outgoing" flag
		if (!(stream->flags & _F_IN)) 	// stream is NOT incoming
		{
			stream->level = 0;		// reset buffer fill level
			stream->curp = stream->buffer;	// reset curp to start of buffer
			stream->hold = 0;		// reset ungetchar
		}
		
		stream->flags |= _F_IN;		// set stream to incoming
		if (!stream->level) 		// buffer is empty
		{
			stream->curp = stream->buffer; // reset curp to start of buffer
			if (stream->flags & _F_LBUF)   // if stream is "line-buffered" ...
			{
				while (stream->level < stream->bsize) // ... fill buffer
				{					
					#ifdef NKC_DEBUG
					nkc_write("#");
					#endif
					int sz = _ll_read(stream->fd,stream->curp,1);	// -> nkc/llstd.S	
										
															
					if (!sz)		// if no characters could be read, we can break
						break;
						
					stream->level++;	// increment fill level
					
					if ((*stream->curp == '\n') || (*stream->curp == '\r'))
						break;		// break on newline or linefeed
						
					
					if( (*stream->curp == 0) && !(stream->flags & _F_BIN)) // JADOS EOF for ASCII files
					{
					/*
						while (stream->level < stream->bsize) // ... fill rest of buffer with NULL
						{ 
						  *(stream->curp++) = 0;				
						  stream->level++;	// increment fill level
						}
					*/	
						#ifdef NKC_DEBUG
						nkc_write(" JADOS EOF\n");
						#endif
						stream->flags |= _F_EOF;
						stream->curp = stream->buffer;	// reset current active pointer to start of buffer
						#ifdef NKC_DEBUG
						nkc_write("..._readbuf(2)\n"); nkc_getchar();
						#endif
						return EOF;
						break;				//break on 0 if ASCII file (JADOS EOF)
					}
					
						
					stream->curp++;				// increment curp
				}
				stream->curp = stream->buffer;	// reset current active pointer to start of buffer
			}						
			else 
			{	// stream is not buffered, so ask OS to fill buffer direct with bsize characters:
				#ifdef NKC_DEBUG
				nkc_write("before call to _ll_read:\n");
				nkc_write(" fd=0x"); nkc_write_hex8(stream->fd);
				nkc_write(" buf=0x"); nkc_write_hex8((int)stream->buffer);
				nkc_write(" size=0x"); nkc_write_hex8(stream->bsize);
				nkc_write("\n");
				#endif			
				stream->level = _ll_read(stream->fd,stream->buffer,stream->bsize);  // -> nkc/llstd.S
			}	
		}
	}
	
	if (stream->level == 0) // if fill level is 0 we have reached the end of the file
	{	
		#ifdef NKC_DEBUG
		nkc_write("..._readbuf(EOF)\n"); nkc_getchar();
		#endif
		stream->flags |= _F_EOF;
		return EOF;
	}
	
	#ifdef NKC_DEBUG
	nkc_write("..._readbuf\n"); //nkc_getchar();
	#endif
	return 0;
}
