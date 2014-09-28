#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>
#include <libp.h>

//#define NKC_DEBUG

#ifdef NKC_DEBUG
#include "../nkc/llnkc.h"
#endif

extern FILE *_pstreams[_NFILE_];
extern char *_filenames[_NFILE_];
extern int maxfiles;

FILE *_basefopen(const char *name, const char *mode,FILE *stream)
{
	int flags = 0,append = 0, update = 0, id = 0,i;
	FILE *file;
	char *buf, *fname;	
	
	#ifdef NKC_DEBUG
	nkc_write("_basefopen...\n");
	#endif
	if (maxfiles == _NFILE_)
	{
		#ifdef NKC_DEBUG
		nkc_write("...._basefopen(1)\n");
		#endif
		return 0;
	}
				
	for (i=0; i < strlen(mode); i++) {
		switch (mode[i]) {
			case 'r':
				flags |= _F_READ;
				break;
			case 'w':
				flags |= _F_WRIT;
				break;
			case 'a':
				flags |= _F_WRIT;
				append = 1;
				break;
			case '+':
				update = 1;
				break;
			case 'b':
				flags |= _F_BIN;
				break;
			case 't':
				flags &= ~_F_BIN;
			default:
				#ifdef NKC_DEBUG	
				nkc_write("..._basefopen(2)\n");nkc_getchar();	
				#endif
				return 0;
		}
	}
	
	
	if (!(flags & (_F_READ | _F_WRIT)))
	{
		#ifdef NKC_DEBUG	
		nkc_write("..._basefopen(3)\n");nkc_getchar();	
		#endif
		return 0;
	}
	
	
	fname = malloc(strlen(name)+1);
	
	if (!fname) 
	{
		#ifdef NKC_DEBUG	
		nkc_write("..._basefopen(4)\n");nkc_getchar();	
		#endif
		return 0;
	}
	
	
	strcpy(fname,name);
	
	if (stream)
		file = stream;
	else
		if ((file = malloc(sizeof(FILE))) == 0) {
			free(fname);
			#ifdef NKC_DEBUG	
			nkc_write("..._basefopen(5)\n");nkc_getchar();	
			#endif
			return 0;
		}
		else
			memset(file,0,sizeof(FILE));	
			
	file->flags = 0;
	buf= malloc(BUFSIZ);	
	#ifdef NKC_DEBUG	
	nkc_write(" buf=0x"); nkc_write_hex8((int)buf); nkc_write("\n"); 	
	#endif
	if (!buf) 
	{
		free(fname);
		free(file);
		#ifdef NKC_DEBUG	
		nkc_write("..._basefopen(6)\n");nkc_getchar();	
		#endif
		return 0;
	}
	
	
	switch (flags & (_F_READ | _F_WRIT)) {
		case 0:
			goto nofile;
		case _F_READ:
			if (update)
				flags |= _F_WRIT;
	 		id = _ll_open(name,	_ll_flags(flags));
			break;
		case _F_WRIT:
			if (update)
				flags |= _F_READ;
			id = _ll_creat(name,_ll_flags(flags));
			break;
		case _F_READ | _F_WRIT:
			#ifdef NKC_DEBUG	
			nkc_write("..._basefopen(7)\n");nkc_getchar();	
			#endif
			return 0;
	}
	if (id == 0)
		goto nofile;
		
	
	file->token = FILTOK;
	file->level = 0;
	file->fd = (char) id;
	file->flags |= flags;
	file->istemp = 0;
	file->hold = 0;
	if (flags & _F_BIN)
		setvbuf(file,buf,_IOFBF,BUFSIZ);
	else
		setvbuf(file,buf,_IOLBF,BUFSIZ);
	flags |= _F_BUF;
	if (append) {
		if (fseek(file,0,SEEK_END)) {
nofile:
			free(fname);
			free(file->buffer);
			free(file);
			#ifdef NKC_DEBUG	
			nkc_write("..._basefopen(8)\n");nkc_getchar();	
			#endif
			return 0;
		}
	}
	_filenames[maxfiles] = fname;
	_pstreams[maxfiles++] = file;
	
	#ifdef NKC_DEBUG
	nkc_write(" fopen: fname="); nkc_write(fname); nkc_write(" flags=0x"); nkc_write_hex8(file->flags);
	nkc_write(" token=0x"); nkc_write_hex8(file->token); nkc_write("\n"); 
	nkc_write(" fd=0x"); nkc_write_hex8(file->fd); nkc_write("\n"); 
	nkc_write(" buf=0x"); nkc_write_hex8((int)file->buffer); nkc_write("\n"); 
	nkc_write(" bufsize=0x"); nkc_write_hex8((int)file->bsize); nkc_write("\n");
	nkc_write("..._basefopen\n");	nkc_getchar();
	#endif	
	return file;
}
FILE *fopen(const char *name, const char *mode)
{
	return _basefopen(name,mode,0);
}
