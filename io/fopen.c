#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>
#include <libp.h>
#include <debug.h>


extern FILE *_pstreams[_NFILE_];
extern char *_filenames[_NFILE_];
extern int maxfiles;

FILE *_basefopen(const char *name, const char *mode,FILE *stream)
{
	int flags = 0,append = 0, update = 0, id = 0,i;
	FILE *file;
	char *buf, *fname;	
	

	clio_dbg("_basefopen...\n");

	if (maxfiles == _NFILE_)
	{
		clio_dbg("...._basefopen(1)\n");
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
				clio_lldbgwait("..._basefopen(2)\n");
				return 0;
		}
	}
	
	clio_dbg(" mode=%s ==> flags=0x%x\n",mode,flags);
	
	if (!(flags & (_F_READ | _F_WRIT)))
	{	
		clio_lldbgwait("..._basefopen(3)\n");
		return 0;
	}
	
	
	fname = malloc(strlen(name)+1);
	
	if (!fname) 
	{	
		clio_lldbgwait("..._basefopen(4)\n");
		return 0;
	}
	
	
	strcpy(fname,name);
	
	if (stream)
		file = stream;
	else
		if ((file = malloc(sizeof(FILE))) == 0) {
			free(fname);	
			clio_lldbgwait("..._basefopen(5)\n");
			return 0;
		}
		else
			memset(file,0,sizeof(FILE));	
			
	file->flags = 0;
	buf= malloc(BUFSIZ);	
	
	clio_dbg(" buf=0x%x\n",(int)buf);
	
	if (!buf) 
	{
		free(fname);
		free(file);	
		clio_lldbgwait("..._basefopen(6)\n");
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
			clio_lldbgwait("..._basefopen(7)\n");
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
			clio_lldbgwait("..._basefopen(8)\n");
			return 0;
		}
	}
	_filenames[maxfiles] = fname;
	_pstreams[maxfiles++] = file;
	
	clio_dbg(" fopen: fname=%s flags=0x%x token=0x%x\n",fname,file->flags,file->token);
	clio_dbg(" fd=0x%x\n",file->fd);
	clio_dbg(" buf=0x%x\n",(int)file->buffer);
	clio_dbg(" bufsize=0x%x\n",(int)file->bsize);
	clio_lldbgwait("..._basefopen\n");
	return file;
}
FILE *fopen(const char *name, const char *mode)
{
	return _basefopen(name,mode,0);
}
