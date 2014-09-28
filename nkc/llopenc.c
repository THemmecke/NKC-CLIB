#include <stdio.h>
#include <stdlib.h>

#define NULL 0
#define BUFFER_SIZE 1024
#define SECSIZE 1024


//#define NKC_DEBUG

#include "../nkc/llnkc.h"

UINT jfwrite(int fd, void *buf, int size);
UINT jfread(int fd, void *buf, int size);



UINT read_sector(struct jdfileinfo *pfi)
{
	UCHAR *pbuffer;
	UCHAR result;
	
	#ifdef NKC_DEBUG
	nkc_write("read_sector...\n");
	#endif
	
	if(pfi->eof) 
	{
		#ifdef NKC_DEBUG
		nkc_write("...read_sector(1)\n"); nkc_getchar();
		#endif
		return 1;			// already at end of file
	}
	
	pbuffer = pfi->pfcb->pbuffer; 		// save sector buffer address
	result = nkc_readrec(pfi->pfcb);	// read sector
	
	switch(result)
	{
		case 0: 
			#ifdef NKC_DEBUG
			nkc_write(" >>>>>>>>>>>>>>\n");
			#endif 
			break; 	    // no error
		case 1: pfi->eof = 1; 
			#ifdef NKC_DEBUG
			nkc_write("...read_sector(EOF)\n"); nkc_getchar();
			#endif
			return 1; // EOF
		case 99: break; 	    // end of user space (JADOS)
		default: 		    // error reading device
		break;
	}
	
	pfi->pfcb->pbuffer = pbuffer;	// restore sector buffer address
	pfi->clsec++;			// increment current logical sector
	pfi->crpos=0;			// reset current logical sector position
	
	#ifdef NKC_DEBUG
	nkc_write("...read_sector\n"); nkc_getchar();
	#endif
	return result;
}

/*
			 UCHAR nkc_writerec(struct fcb *FCB)
			 returns 	   0 - if successful
			 		   5 - disk full
			 		0xFF - access error 
*/
UINT write_sector(struct jdfileinfo *pfi)
{
	UCHAR *pbuffer;
	UCHAR result;
	#ifdef NKC_DEBUG
	nkc_write("write_sector...\n");
	#endif
	
	
	if(pfi->pfcb->mode != 0xE5 || (pfi->crpos == 0)) 
	{
		#ifdef NKC_DEBUG 
		nkc_write("...buffer empty or file read only, no need to save\n"); 
		nkc_write("...write_sector\n"); nkc_getchar();
		#endif
	}
		    	
	pbuffer = pfi->pfcb->pbuffer; 		// save sector buffer address
	result = nkc_writerec(pfi->pfcb);	// write sector
	
	switch(result)
	{
		case 0:  
			#ifdef NKC_DEBUG
			nkc_write(" <<<<<<<<<<<<<<<<<\n");
			#endif 
			break; 	// no error
		case 5:  
			#ifdef NKC_DEBUG 
			nkc_write("...write_sector(disk full)\n"); nkc_getchar();
			#endif
			return 0; 	// disk full
		case 0xff: 
			#ifdef NKC_DEBUG
			nkc_write(" media access error\n");
			#endif
			break; 	// media access error	
		default:			
			#ifdef NKC_DEBUG 
			nkc_write(" other error\n"); 		// general errror
			#endif
			break;	
	}
	
	pfi->pfcb->pbuffer = pbuffer;	// restore sector buffer address
	pfi->clsec++;			// increment current logical sector
	//pfi->pfcb->length += 1;	// this done internal by jados
	pfi->crpos=0;			// reset current logical sector position
	memset(pbuffer,0,BUFFER_SIZE);	// clear buffer
	
	#ifdef NKC_DEBUG 
	nkc_write("...write_sector\n"); nkc_getchar();
	#endif
	return result;
}


int jd_open(char *name, int flags)
/*
 * open an existing file, return handle
  name = [LW:]filename.ext
  flags = 0(read), 1(write), 2(read/write) 
 *************************************************************************/
{
	UCHAR result;
	struct jdfcb *pfcb;
	struct jdfileinfo *pfi,*pcfi,*plfi;
	UCHAR *pbuffer;
	
	
	#ifdef NKC_DEBUG
	nkc_write("jd_open...\n");
	#endif
	//return NULL;
	
	
	
	
	
	
	/*
		allocate all buffers
	*/
	pfcb = (struct jdfcb *)malloc(sizeof(struct jdfcb));	
	pfi = (struct jdfileinfo *)malloc(sizeof(struct jdfileinfo));
	pbuffer = (unsigned char*)malloc(BUFFER_SIZE);
	
	#ifdef NKC_DEBUG 
	nkc_write("pfcb=0x"); nkc_write_hex8((int)pfcb);
	nkc_write(" pfi=0x"); nkc_write_hex8((int)pfi);
	nkc_write(" &(pfi->fd)=0x"); nkc_write_hex8((int)(&(pfi->fd)));
	nkc_write(" pbuffer=0x"); nkc_write_hex8((int)pbuffer);
	nkc_write("\n");
	#endif
	
		
	result = nkc_fillfcb(pfcb,name);	
	/*
		result	Bedeutung
		0	FCB angelegt
		0xff	name ist kein Dateiname	
	*/
	
	
	pfcb->pbuffer = pbuffer;	
		
	/*
		OK, try to open the file
	*/
	
	result = nkc_open(pfcb);
	/*
		result	Bedeutung
		0	Datei geöffnet
		0xff	Datei nicht vorhanden
	*/
	
	
	if(result == 0xff)
	{
		#ifdef NKC_DEBUG
		nkc_write("- file not found error -");
		#endif
		free(pfi);
		free(pfcb);
		free(pbuffer);
		free_handle(fd);
		
		#ifdef NKC_DEBUG 
		nkc_write("...jd_open(3)\n"); nkc_getchar();
		#endif
		return NULL;
	}
	
	pfcb->pbuffer = pbuffer;
	if(flags == 0)	pfcb->mode = 0xE4; 		// filemode is readonly
	pfi->next = NULL;
	pfi->fd = fd;
	pfi->pos = 0;
	pfi->crpos = 0;
	pfi->clsec = 0; // will be 1 after 1st read !
	pfi->pfcb = pfcb;
	pfi->eof = 0;	
	
	
	
	read_sector(pfi);
	
	#ifdef NKC_DEBUG 
	nkc_write("flags=0x"); nkc_write_hex8(pfi->pfcb->mode); nkc_write(" fd=0x"); nkc_write_hex8(fd);nkc_write("\n");
	nkc_write("..._ll_open\n"); nkc_getchar();
	#endif
	return fd;
	
}


int _ll_creat(char *name, int flags)
 /* create new file, if file exists it will be truncated to zero legth
 *************************************************************************/
{
	UCHAR result;
	struct jdfcb *pfcb;
	struct jdfileinfo *pfi,*pcfi,*plfi;
	UCHAR *pbuffer;
	int fd;
	UINT indx = NUM_FILE_HANDLES;
	
	#ifdef NKC_DEBUG
	nkc_write("_ll_creat...\n");
	#endif
	/*
		Try to allocate file hanlde
	*/
	
	fd = alloc_handle();
	if(fd == 255) /* no more free handle ! */
	{
		free_handle(fd);
		#ifdef NKC_DEBUG 
		nkc_write("..._ll_creat(1)\n"); nkc_getchar();
		#endif	
		return NULL;
	}
	
	/*
		allocate all buffers
	*/
	pfcb = (struct jdfcb *)malloc(sizeof(struct jdfcb));	
	pfi = (struct jdfileinfo *)malloc(sizeof(struct jdfileinfo));
	pbuffer = (unsigned char*)malloc(BUFFER_SIZE);
	memset(pbuffer,0,BUFFER_SIZE);	// clear buffer
	
	#ifdef NKC_DEBUG 
	nkc_write("pfcb=0x"); nkc_write_hex8((int)pfcb);
	nkc_write(" pfi=0x"); nkc_write_hex8((int)pfi);
	nkc_write(" &(pfi->fd)=0x"); nkc_write_hex8((int)(&(pfi->fd)));
	nkc_write(" pbuffer=0x"); nkc_write_hex8((int)pbuffer);
	nkc_write("\n");
	#endif
	
	result = nkc_fillfcb(pfcb,name);	
	/*
		result	Bedeutung
		0	FCB angelegt
		0xff	name ist kein Dateiname	
	*/
	pfcb->pbuffer = pbuffer;
	
	/*
		file already open ? (walk OPENFILES)			
	*/
	plfi = pcfi = OPENFILES;
	
	while(pcfi != NULL && indx)
	{
		if( strcmp(pcfi->pfcb->filename, pfcb->filename) == 0 &&
		    strcmp(pcfi->pfcb->fileext  ,pfcb->fileext ) ==0      )
		    {
		    	/* file already open, return handle ? */		    
		    	free(pfi);
		    	free(pfcb);
		    	free(pbuffer);
		    	free_handle(fd);
		    	
		    	#ifdef NKC_DEBUG 
			nkc_write("..._ll_creat(2)\n"); nkc_getchar();
			#endif
		    	return plfi->fd;
		    }
		    
		    indx--;
		    plfi = pcfi;
		    pcfi = pcfi->next;
	}
	
	/*
		OK, try to create the file
	*/
	
	result = nkc_erase(pfcb); 	// first we try to erase the file if it exists
	/*
		result	Bedeutung
		0	Datei gelöscht
		2	Datei nicht vorhanden
		0xff	Fehler beim Zugriff auf den Massenspeicher
		
		Achtung: falls die Datei schon existiert, wird sie lediglich geöffnet !
	*/
		
	result = nkc_create(pfcb);	// create new file
	/*
		result	Bedeutung
		0	Datei angelegt
		5	Massenspeicher voll
		6	Inhaltsverzeichnis voll
		0xff	Fehler beim Zugriff auf den Massenspeicher
		
		Achtung: falls die Datei schon existiert, wird sie lediglich geöffnet !
	*/
	if(result != 0)
	{
		printf(" error %d creating file\n",result);
		free(pfi);
		free(pfcb);
		free(pbuffer);
		free_handle(fd);
		#ifdef NKC_DEBUG 
		nkc_write("..._ll_creat(3)\n"); nkc_getchar();
		#endif
		return NULL;
	}
		
	pfcb->pbuffer = pbuffer;
	pfi->next = NULL;
	pfi->fd = fd;
	pfi->pos = 0;		// absolute file position
	pfi->crpos =0;		// relative sector buffer position
	pfi->clsec = 1;		// current logical sector
	pfi->pfcb = pfcb;
	pfi->eof = 0;	
	
	if(OPENFILES == NULL)
		OPENFILES = pfi;
	else	plfi->next = pfi;
	
	#ifdef NKC_DEBUG 
	nkc_write("flags=0x"); nkc_write_hex8(pfi->pfcb->mode); nkc_write(" fd=0x"); nkc_write_hex8(fd);nkc_write("\n");
	nkc_write("..._ll_creat\n"); nkc_getchar();
	#endif
	return fd;
}

	
void nkc_print_fcb(struct jdfcb *pfcb);
	
void jd_close(int fd)
/* close file
 *************************************************************************/
{
	UCHAR result;
	struct jdfcb *pfcb;
	struct jdfileinfo *pcfi,*plfi,*pnfi;
	UCHAR *pbuffer;
	UINT indx = NUM_FILE_HANDLES;
	
	#ifdef NKC_DEBUG
	nkc_write("jd_close...\n");
	nkc_write("fd="); nkc_write_dec_dw(fd); nkc_write("\n");
	#endif
	/* walk OPENFILES */
	
	if(fd<10) return;
	
	plfi = pcfi = OPENFILES;
	while(pcfi != NULL && indx)
	{
		if( pcfi->fd == fd)
		    {
		    	/* found file hanlde */
		    	#ifdef NKC_DEBUG
			nkc_write("found\n");
			#endif
		    	/* flush current sector, if mode = write */
		    	if(pcfi->pfcb->mode == 0xE5 && (pcfi->crpos > 0)) 
		    	{
		    	  #ifdef NKC_DEBUG
			  nkc_write(" crpos = 0x"); nkc_write_dec_dw(pcfi->crpos); nkc_write(" !\n");
			  #endif
		    	  write_sector(pcfi);
		    	}
		    	
		    	/* close file on media */  
		    	
		    	
		    	nkc_close(pcfi->pfcb);
		    	
		    	/* unlink current file info */   
		    	if(plfi == pcfi) // it's the first handle
		    	{
		    		if(plfi->next == NULL)
		    		{
		    		  #ifdef NKC_DEBUG
				  nkc_write("freed last filehandle\n");
				  #endif
		    		  OPENFILES = NULL;  /* this was the last file open */
		    		}else
		    		{
		    			#ifdef NKC_DEBUG
				  	nkc_write("freed first filehandle\n");
				  	#endif
		    			OPENFILES = plfi->next;
		    		}
		    		
		    	}
		    	else  	
		    	{
		    		#ifdef NKC_DEBUG
				nkc_write("freed filehandle\n");
				#endif
		    		plfi->next = pcfi->next;
		    	}
		    	
		    	/* free buffers and handles*/
		    	free(pcfi->pfcb->pbuffer);
		    	free(pcfi->pfcb);
		    	free(pcfi);
		    	free_handle(fd);
		    	
		    	#ifdef NKC_DEBUG 
			nkc_write("..._ll_close\n"); nkc_getchar();
			#endif
		    	return;
		    }
		    
		    indx--;
		    plfi = pcfi;
		    pcfi = pcfi->next;
	}
	
	#ifdef NKC_DEBUG 
	nkc_write("..._ll_close(1)\n"); nkc_getchar();
	#endif
	//printf("\n");
}

int _ll_getpos(int fd)
 /* in DOS: seek to current position, current position is returned
 *************************************************************************/
{	
	struct jdfileinfo *pfi;
	UINT indx = NUM_FILE_HANDLES;
	
	#ifdef NKC_DEBUG
	nkc_write("_ll_getpos...\n");
	#endif
	
	if(fd<10) return 0;
	
	pfi = OPENFILES;
	while(pfi != NULL && indx)
	{			
		if( pfi->fd == fd)
		    {
		    	/* found file handle */		
		    	#ifdef NKC_DEBUG 
			nkc_write("..._ll_getpos\n"); nkc_getchar();
			#endif        	
		    	return pfi->pos;
		    }
		    		
		    indx--;		    
		    pfi = pfi->next;
	}
	
	#ifdef NKC_DEBUG 
	nkc_write("..._ll_close(1)\n"); nkc_getchar();
	#endif
	return 0; /* didn't find file */
}
	
void nkc_print_fcb(struct jdfcb *pfcb);	

void _ll_seek(int fd, int pos, int origin)
 /* set file position, fd = file descriptor, pos = offset into file, origin = method
  * pos => 1st position is 0
  * origin = 0 => pos gives absolute offset from start of file
  * origin = 1 => pos gives offset from current file pointer
  * origin = 2 => pos gives offset from EOF
  *************************************************************************/
{
	struct jdfileinfo *pfi;
	div_t divresult;
	UCHAR res;
	int newpos;
	UINT indx = NUM_FILE_HANDLES;
	
	#ifdef NKC_DEBUG
	nkc_write("_ll_seek...");	
	nkc_write(" fd: 0x"); nkc_write_hex8(fd);
	nkc_write(" pos: 0x"); nkc_write_hex8(pos);
	nkc_write(" origin: 0x"); nkc_write_hex8(origin);
	nkc_write("\n");	
	#endif
	
	
	if(fd<10) 
	{
		#ifdef NKC_DEBUG 
		nkc_write("..._ll_seek(1)\n"); nkc_getchar();
		#endif
		return;
	}
	
	
	pfi = OPENFILES;
	while(pfi != NULL && indx)
	{			
		if( pfi->fd == fd)
		    {
		    	/* found file handle -> seek */	
		    	#ifdef NKC_DEBUG		    			    	
		    	//nkc_print_fcb(pfi->pfcb);
		    	#endif
		    	
			switch(origin)
			{
				case 0:	// seek from start of file							
					newpos = pos;
					break;
				case 1: // seek from current file position
					newpos = pos + pfi->pos;					
					break;
				case 2: // seek from end of file										
					newpos = (int)(pfi->pfcb->length*(int)SECSIZE + pos - 1);					
					break;
				default:		
					newpos = pos;			
					break;
			}
			
			divresult = div( newpos , (int)SECSIZE );	
			
			#ifdef NKC_DEBUG
			//nkc_write(" divresult= 0x"); nkc_write_hex8((int)divresult.quot); nkc_write(" newpos= 0x"); nkc_write_hex8(newpos); nkc_write(" SECSIZE= 0x"); nkc_write_hex8(SECSIZE); nkc_write("\n");
			#endif
						
			if(divresult.quot < 0) {
					divresult.quot = 0;
					
					#ifdef NKC_DEBUG
					nkc_write(" error in seek: negativ file offset\n");
					#endif
					
					#ifdef NKC_DEBUG 
					nkc_write("..._ll_seek\n"); nkc_getchar();
					#endif
					return;				// check for negativ fileoffset
					
				}
				
			if(divresult.quot > pfi->pfcb->length) {
					divresult.quot = pfi->pfcb->length - 1;
					pfi->eof = 1;
					#ifdef NKC_DEBUG
					/*
					nkc_write(" error in seek: seek beyond EOF\n");
					nkc_write(" File: "); nkc_write(pfi->pfcb->filename); nkc_write(" pos: 0x"); nkc_write_hex8(pos);nkc_write(" ori: 0x"); nkc_write_hex8(origin); 
					nkc_write(" flegth: 0x"); nkc_write_hex8((int)pfi->pfcb->length); nkc_write("\n");
					*/
					#endif
					
					#ifdef NKC_DEBUG 
					nkc_write("..._ll_seek(2)\n"); nkc_getchar();
					#endif
					return;		// check for seek beyond filend
				}
			
			if(divresult.quot != pfi->pfcb->length) // did we seek into another sector ?
			{
				res = nkc_setrec(pfi->pfcb, (int)divresult.quot); // set new record ...
			
				#ifdef NKC_DEBUG
				//nkc_print_fcb(pfi->pfcb);
				#endif
				
				switch(res)
				{
					case 0: // successful
						res = read_sector(pfi);	// ... and read record to buffer
					
						#ifdef NKC_DEBUG
						//nkc_print_fcb(pfi->pfcb);
						#endif
						
						switch(res)
						{
							case 0: 							
								 break;				// no error
							case 1:  pfi->eof = 1;		/* set eof flag			*/ 
								break;
							case 99:break; 			// end of user space (JADOS)
							default: break;			// error reading device
						}					
						break;
					
					case 1: // EOF
						pfi->eof = 1;	/* set eof flag											*/ 					
						break;	
					
					case 0xFF: // access error
						#ifdef NKC_DEBUG 
						nkc_write("..._ll_seek(3)\n"); nkc_getchar();
						#endif
						return;	
									
					default: 
						 #ifdef NKC_DEBUG
						 nkc_write(" should not be here (0x");
						 nkc_write_hex8(res);					
						 nkc_write(")!\n");
						 #endif
						 break;
				}	
			
			}		       
			
			pfi->pos 	= newpos;		/* file position	    		0....				*/
			pfi->crpos 	= (int)divresult.rem;	/* current relativ position (in sector) 0...SECSIZE-1			*/
			pfi->clsec	= (int)(divresult.quot + 1); 	/* current logical sector   		1...65536			*/
				
			#ifdef NKC_DEBUG	
			/*
			nkc_write(" pos: 0x"); nkc_write_hex8((int)pfi->pos);											
			nkc_write(" crpos: 0x"); nkc_write_hex8((int)pfi->crpos);
			nkc_write(" clsec: 0x"); nkc_write_hex8((int)pfi->clsec);
			nkc_write(" length: 0x"); nkc_write_hex8((int)pfi->pfcb->length);
			nkc_write("\n");
			*/		
			#endif	
			#ifdef NKC_DEBUG 
			nkc_write("..._ll_seek\n"); nkc_getchar();
			#endif
			return;
		    }
		    	
		    indx--;		    
		    pfi = pfi->next;
	}
		
	#ifdef NKC_DEBUG 
	nkc_write("..._ll_seek(4)\n"); nkc_getchar();
	#endif	
	return;

}

/*
	div_t divresult;
	
	divresult = div(38,5);
	printf(("38 div 5 => %d, remainder %d\n", divresult.quot, divresult.rem);
*/

UINT jfread(int fd, void *buf, int size)
{
	
	struct jdfileinfo *pfi;
	UCHAR *pbuf;	// pointer to sector buffer
	UINT count = size;	// number of bytes to read
	UINT bp;		// buffer pointer
	UINT res;		// a result
	UINT indx = NUM_FILE_HANDLES;
		
	if(fd<10) return;
	
	#ifdef NKC_DEBUG
	nkc_write("jfread...\n");		
	nkc_write(" fd: 0x"); nkc_write_hex8(fd);
	nkc_write(" size: 0x"); nkc_write_hex8(size);
	nkc_write("\n");
	//nkc_write("->");
	#endif
	
	pfi = OPENFILES;
	while(pfi != NULL && indx)
	{
		#ifdef NKC_DEBUG	
		nkc_write("current fd: 0x"); nkc_write_hex8(pfi->fd); nkc_getchar(); nkc_write("\n");
		#endif	
		
		if( pfi->fd == fd)
		    {
		    	#ifdef NKC_DEBUG	
			nkc_write("fd found\n");
			#endif
		    	if(pfi->eof) 
		    	{
		    		#ifdef NKC_DEBUG	
				nkc_write("...jfread(1)\n"); nkc_getchar();
				#endif
		    		return 0;		    		
		    	}

			pbuf = pfi->pfcb->pbuffer;	// fetch buffer address
			#ifdef NKC_DEBUG				
			nkc_write(" pbuf = 0x"); nkc_write_hex8((int)pbuf);
			nkc_write(" buf = 0x"); nkc_write_hex8((int)buf);
			nkc_write("\n");
			//nkc_getchar();			
			#endif
			bp = 0;
				        	
			while(count)
			{
				#ifdef NKC_DEBUG
				if(pfi->fd != fd) 
					{
						nkc_write(" fd changed (1) !!\n"); 
						nkc_write(" crpos = "); nkc_write_dec_dw(pfi->crpos);
						nkc_write(" count = "); nkc_write_dec_dw(count);
						nkc_write(" pos = "); nkc_write_dec_dw(pfi->pos);
						nkc_write(" bp = "); nkc_write_dec_dw(bp);
						nkc_write(" pbuf = 0x"); nkc_write_hex8((int)pbuf);
						nkc_write(" buf = 0x"); nkc_write_hex8((int)buf);
						nkc_write("\n");
						nkc_getchar();
					}
				#endif
				// copy bytes from actual buffer
				for(;pfi->crpos < SECSIZE && count > 0; pfi->crpos++,pfi->pos++,count--,bp++)
				{
					((UCHAR*)buf)[bp] = pbuf[pfi->crpos];
						
					#ifdef NKC_DEBUG	
					nkc_write(",");
					//nkc_write("\n 0x");
					//nkc_write_hex8(count); nkc_write(" = ");	
					//nkc_putchar(pbuf[pfi->crpos]);						
					if(pbuf[pfi->crpos] == 0) 
					{
					 //nkc_write(" - read 0 - ");
					 //nkc_getchar();
					}
					
					if(pfi->fd != fd) 
					{
						nkc_write(" fd changed (2) !!\n"); 
						nkc_write(" crpos="); nkc_write_dec_dw(pfi->crpos);
						nkc_write(" count="); nkc_write_dec_dw(count);
						nkc_write(" pos="); nkc_write_dec_dw(pfi->pos);
						nkc_write(" bp="); nkc_write_dec_dw(bp);
						nkc_write(" pbuf=0x"); nkc_write_hex8((int)pbuf);			// sector buffer
						nkc_write(" buf=0x"); nkc_write_hex8((int)buf);				// CLIB buffer in FILE
						nkc_write(" pfi=0x"); nkc_write_hex8((int)pfi);
						nkc_write(" &(pfi->fd)=0x"); nkc_write_hex8((int)(&(pfi->fd)));
						nkc_write("\n");
						nkc_getchar();
					}
					#endif
				}
				
				#ifdef NKC_DEBUG
				nkc_write("\n");
				#endif
				
				// read next sector
				if(count)
				{	
					#ifdef NKC_DEBUG				
					//nkc_write(" read next sector: ");
					#endif
					if (pfi->clsec == pfi->pfcb->length) 
					{
						#ifdef NKC_DEBUG	
						nkc_write("...jfread(EOF)\n"); nkc_getchar();
						#endif
						return 0;  // EOF (we just copied the last sector)
					}
					
					res = read_sector(pfi);			       // read next sector
					
					switch(res)
					{
						case 0: 
							#ifdef NKC_DEBUG 
							nkc_write("ok\n");							
							#endif
							 break;				// no error
						case 1:  
							#ifdef NKC_DEBUG
							nkc_write("EOF\n");
							#endif
							 return bp; 			// EOF, we return EOF = 0 on next call
						case 99:
							#ifdef NKC_DEBUG 
							nkc_write("JADOS EOUS\n");
							#endif
							#ifdef NKC_DEBUG	
							nkc_write("...jfread(2)\n"); nkc_getchar();
							#endif
							 return 0; 			// end of user space (JADOS)
						default: 
							#ifdef NKC_DEBUG
							nkc_write("unknown\n");
							#endif
							#ifdef NKC_DEBUG	
							nkc_write("...jfread(3)\n"); nkc_getchar();
							#endif
							 return 0;			// error reading device
					}
				}
			}
			
			#ifdef NKC_DEBUG	
			nkc_write("fd: 0x"); nkc_write_hex8(pfi->fd); nkc_getchar(); nkc_write("\n");
			nkc_write("...jfread\n"); nkc_getchar();
			#endif
			return bp;
		    }
		    		    
		    pfi = pfi->next;
		    indx--;
	}
	
	#ifdef NKC_DEBUG	
	nkc_write("...jfread(file not found)\n"); nkc_getchar();
	#endif
	return 0; /* didn't find file */
}

UINT jfwrite(int fd, void *buf, int size)
{
	struct jdfileinfo *pfi;
	int crpos;		// current relativ position in sector buffer
	int pos;		// current absolute position in file
	div_t dres;		// result of a DIV
	UCHAR *pbuf;		// pointer to sector buffer
	UINT bp;		// buffer pointer
	int count = size;	// number of bytes to write	
	UCHAR res;		// a result
	UINT indx = NUM_FILE_HANDLES;
	
	char tbuf[2] = {0,0};
	int ii;
	
	if(fd<10) return 0;
	
	#ifdef NKC_DEBUG
	nkc_write("jfwrite...\n");
	#endif
	pfi = OPENFILES;
	while(pfi != NULL && indx)
	{			
		if( pfi->fd == fd)
		    {		    				
			pbuf = pfi->pfcb->pbuffer;	// fetch buffer address						
			
			bp = 0;
							        	
			while(count)
			{
				// copy bytes to actual buffer
				for(;pfi->crpos < SECSIZE && count > 0; pfi->crpos++,pfi->pos++,count--,bp++)
				{
					pbuf[pfi->crpos] = ((unsigned char*)buf)[bp];										
				}				
				
				// write next sector
				if(count)
				{
					res = write_sector(pfi);	// write current sector to disk an proceed to next sector
					
					switch(res)
					{
						case 0:  break; 	// no error
						case 5: 
							#ifdef NKC_DEBUG	
							nkc_write("...jwrite(disk full)\n"); nkc_getchar();
							#endif 
							return 0; 	// disk full
						case 0xff: 
							#ifdef NKC_DEBUG	
							nkc_write("...jwrite(media access error)\n"); nkc_getchar();
							#endif
							return 0; 	// media access error						
					}
				}
			}
			
			#ifdef NKC_DEBUG	
			//nkc_write(" L: 0x"); nkc_write_hex8((int)pfi->pos); nkc_write("\n");	
			#endif
			
			#ifdef NKC_DEBUG	
			nkc_write("...jwrite\n"); nkc_getchar();
			#endif
			return bp;
			
		    }
		    
		    indx--;		    
		    pfi = pfi->next;
	}
	
	#ifdef NKC_DEBUG	
	nkc_write("...jwrite(file not found)\n"); nkc_getchar();
	#endif
	return 0; /* didn't find file */
}


