#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <libp.h>


//#define NKC_DEBUG

#ifdef NKC_DEBUG
#include "../nkc/llnkc.h"
#endif

extern int _abterm;

FILE *_pstreams[_NFILE_];
char *_filenames[_NFILE_];
int maxfiles;

/*
#pragma startup fileinit 120
#pragma rundown closeall 10
*/


void fileinit(void)
{
	_ll_init_std(); // nkc/llopen.S (serup standard file streams stdin, stdout, stderr)
	
	#ifdef CONFIG_FS
	_ll_init_fs();  // fs/fs.c (setup filesystems: file descriptors, fat, jadosfs...)
			//  ->> nkcfs_init_fs();
			//  ->> fatfs_init_fs();
	#endif
}

void closeall(void)
{
	int i;
	
	// there are no ressources allocated, all stderr,stdout and stderr is static memory
	
	if (!_abterm)
		for (i=maxfiles-1; i >=0; i--) {			
			fclose(_pstreams[i]);
		}		
}
int _basefclose(FILE *stream,int release)
{
	int rv,i;
	
	#ifdef NKC_DEBUG
	nkc_write("_basefclose...\n");
	#endif
	
	if (stream->token == FILTOK && maxfiles) 
	{
		
		int tempflag = stream->istemp;
		char *fname;				
		
		if (stream->flags & _F_OUT) 
		 	fflush(stream);
		
		stream->token = (short)-1;
		if (maxfiles > 1) 
		{
			for (i=0; i < maxfiles; i++)
				if (_pstreams[i] == stream) 
				{
					fname = _filenames[i];
					_pstreams[i] = _pstreams[maxfiles-1];
					_filenames[i] = _filenames[maxfiles-1];
				}
			maxfiles--;
		}
		rv = _ll_close(stream->fd);
		if (tempflag && fname)
			rv &= remove(fname);
		if (fname)
		{
			
			free(fname);
		}
		if (stream->flags & _F_BUF)
		{
			
			free(stream->buffer);
		}
		if (release)
		{			
			free(stream);
		}
		
		if (!rv)
		{	
			#ifdef NKC_DEBUG 
			nkc_write("..._basefclose\n"); nkc_getchar();
			#endif
			return 0;
		}
		else {
			#ifdef NKC_DEBUG 
			nkc_write("..._basefclose(EOF1)\n"); nkc_getchar();
			#endif			
			return EOF;
		}
	}
	else 
	{	
		#ifdef NKC_DEBUG 
		nkc_write("..._basefclose(EOF2)\n"); nkc_getchar();
		#endif
		return EOF;
	}
	
	#ifdef NKC_DEBUG 
	nkc_write("..._basefclose(1)\n"); nkc_getchar();
	#endif
}
int fclose(FILE *stream)
{
	return _basefclose(stream,1);
}
