#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include "../fs.h"
#include "fs_nkc.h"

#include "../../nkc/llnkc.h"

//#define NKC_DEBUG


const struct file_operations nkc_file_operations =
{
  nkcfs_open,
  nkcfs_close,
  nkcfs_read,
  nkcfs_write,
  nkcfs_seek,
  NULL, /* ioctrl */
  nkcfs_remove,
  nkcfs_getpos,

 /* Directory operations */

  NULL,
  NULL,
  NULL,
   
 /* Path operations */
  NULL,
  NULL,
  nkcfs_rename 
};


/*******************************************************************************
 *   private functions   
 *******************************************************************************/
 
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


/*******************************************************************************
 *   public functions   
 *******************************************************************************/

static int nkcfs_open(struct _file *filp)
{
	UCHAR result;
	struct jdfcb *pfcb;
	struct jdfileinfo *pfi;
	UCHAR *pbuffer;
	
	
	#ifdef NKC_DEBUG
	nkc_write("nkcfs_open...\n"); nkc_getchar();
	#endif
	
	#ifdef NKC_DEBUG
	nkc_write("fname= "); nkc_write(filp->pname); nkc_write("\n"); 
	nkc_write("oflags= "); nkc_write_hex8(filp->f_oflags); nkc_write("\n"); 
	nkc_getchar();
	#endif
	
	
	/*
		allocate all buffers
	*/
	pfcb = (struct jdfcb *)malloc(sizeof(struct jdfcb));	
	pfi = (struct jdfileinfo *)malloc(sizeof(struct jdfileinfo));
	pbuffer = (unsigned char*)malloc(BUFFER_SIZE);
	
	#ifdef NKC_DEBUG 
	nkc_write(" pfcb=0x"); nkc_write_hex8((int)pfcb);
	nkc_write(" pfi=0x"); nkc_write_hex8((int)pfi);	
	nkc_write(" pbuffer=0x"); nkc_write_hex8((int)pbuffer);
	nkc_write("\n"); nkc_getchar();
	#endif
	
		
	result = nkc_fillfcb(pfcb,filp->pname);	
	/*
		result	Bedeutung
		0	FCB angelegt
		0xff	name ist kein Dateiname	
	*/
	if(result)
	{
		nkc_write(" error fillfcb: not a filename\n");
		free(pfcb);
		free(pfi);
		free(pbuffer);
		return ENOFILE;
	}
	
	pfcb->pbuffer = pbuffer;	
		
	if(filp->f_oflags & _F_CREATE)
	{
		/*
			OK, try to create the file
		*/
		result = nkc_erase(pfcb); 	// first we try to erase the file if it exists
		/*
		result	Bedeutung
		0	Datei gel..scht
		2	Datei nicht vorhanden
		0xff	Fehler beim Zugriff auf den Massenspeicher
				
		*/
		
		result = nkc_create(pfcb);	// create new file
		/*
		result	Bedeutung
		0	Datei angelegt
		5	Massenspeicher voll
		6	Inhaltsverzeichnis voll
		0xff	Fehler beim Zugriff auf den Massenspeicher
		
		Achtung: falls die Datei schon existiert, wird sie lediglich ge..ffnet !
		*/
		if(result == 0xff) result = 7;

	}else
	{
		/*
			OK, try to open the file
		*/
		result = nkc_open(pfcb);
		/*
			result	Bedeutung
			0	Datei geöffnet
			0xff	Datei nicht vorhanden
		*/
	}
	
	
	switch(result)
	{
		case 0: 		// SUCCESS
				#ifdef NKC_DEBUG
				nkc_write("- success -\n");
				#endif
				break;						
		case 5:		// DISK FULL (create)
				#ifdef NKC_DEBUG
				nkc_write("- disk full -\n");
				#endif
				break;				
		case 6:  	// DIRECTORY FULL (create)
				#ifdef NKC_DEBUG
				nkc_write("- directory full -\n");
				#endif
				break;						
		case 7:		// ACCESS ERROR (create)
				#ifdef NKC_DEBUG
				nkc_write("- access error -\n");
				#endif
				break;						
		case 0xff:	// FILE NOT FOUND
				#ifdef NKC_DEBUG
				nkc_write("- file not found error -\n");
				#endif
				break;				
		default:
				#ifdef NKC_DEBUG
				nkc_write("- unspecified error -\n");
				#endif
				break;				

		
	}	
	
	if(result != 0)
	{		
		free(pfi);
		free(pfcb);
		free(pbuffer);
				
		#ifdef NKC_DEBUG 
		nkc_write("...nkcfs_open(3)\n"); nkc_getchar();
		#endif
		return ENOFILE;
	}
	
	pfcb->pbuffer = pbuffer;
	if( (filp->f_oflags & _F_READ) && !(filp->f_oflags & _F_WRIT))	pfcb->mode = 0xE4; 		// filemode is readonly
	else pfcb->mode = 0xE5;
	pfi->pos = 0;
	pfi->crpos = 0;
	pfi->clsec = 0; // will be 1 after 1st read !
	pfi->pfcb = pfcb;
	pfi->eof = 0;	
	
	if(!(filp->f_oflags & _F_CREATE))
	{
		read_sector(pfi);
	}
	
	#ifdef NKC_DEBUG 
	nkc_write("flags=0x"); nkc_write_hex8(pfi->pfcb->mode); nkc_write("\n");
	nkc_write("...nkcfs_open\n"); nkc_getchar();
	#endif
	
	filp->private = (void*)pfi;
	
	return EZERO;
}




static int nkcfs_close(struct _file *filp)
{
	UCHAR result;	
	struct jdfileinfo *pfi;
	
	
	#ifdef NKC_DEBUG
	nkc_write("nkcfs_close...\n");	
	#endif
	
	pfi = (struct jdfileinfo*)filp->private;
		    
	/* flush current sector, if mode = write */
	if(pfi->pfcb->mode == 0xE5 && (pfi->crpos > 0)) 
   	{
   	  #ifdef NKC_DEBUG
	  nkc_write(" crpos = 0x"); nkc_write_dec_dw(pfi->crpos); nkc_write("\n");
	  #endif
   	  write_sector(pfi);
    }
	
	/* flush current sector, if mode = write */
	if(pfi->pfcb->mode == 0xE5 && (pfi->crpos > 0)) 
	{
		#ifdef NKC_DEBUG
		nkc_write(" crpos = 0x"); nkc_write_dec_dw(pfi->crpos); nkc_write(" !\n");
		#endif
		write_sector(pfi);
	}

	    	
	/* close file on media */  		    			    	
	nkc_close(pfi->pfcb);
    	
    /* free buffers and handles*/
	free(pfi->pfcb->pbuffer);
	free(pfi->pfcb);
	free(pfi);
			    	
	#ifdef NKC_DEBUG 
	nkc_write("...nkcfs_close\n"); nkc_getchar();
	#endif
	
	return EZERO;
}

static int nkcfs_read(struct _file *filp, char *buffer, int buflen)
{
    struct jdfileinfo *pfi;
	UCHAR *pbuf;	// pointer to sector buffer
	UINT count = buflen;	// number of bytes to read
	UINT bp;		// buffer pointer
	UINT res;		// a result

	#ifdef NKC_DEBUG
	nkc_write("nkcfs_read...\n");		
	nkc_write(" buflen: 0x"); nkc_write_hex8(buflen);
	nkc_write("\n");
	//nkc_write("->");
	#endif
	
	
	pfi = (struct jdfileinfo *)filp->private; 

	if(pfi->eof) 
	{
		#ifdef NKC_DEBUG	
		nkc_write("...nkcfs_read(1)\n"); nkc_getchar();
		#endif
		return EZERO;		    		
	}

	pbuf = pfi->pfcb->pbuffer;	// fetch buffer address
	#ifdef NKC_DEBUG				
	nkc_write(" pbuf = 0x"); nkc_write_hex8((int)pbuf);
	nkc_write(" buf = 0x"); nkc_write_hex8((int)buffer);
	nkc_write("\n");
	//nkc_getchar();			
	#endif
	bp = 0;
				        	
	while(count)
	{
		
		// copy bytes from current buffer
		for(;pfi->crpos < SECSIZE && count > 0; pfi->crpos++,pfi->pos++,count--,bp++)
		{
			((UCHAR*)buffer)[bp] = pbuf[pfi->crpos];
						
			#ifdef NKC_DEBUG	
			//nkc_write(",");
			//nkc_write("\n 0x");
			//nkc_write_hex8(count); nkc_write(" = ");	
			//nkc_putchar(pbuf[pfi->crpos]);						
			//if(pbuf[pfi->crpos] == 0) 
			//{
				//nkc_write(" - read 0 - ");
				//nkc_getchar();
			//}
								
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
				nkc_write("...nkcfs_read(EOF)\n"); nkc_getchar();
				#endif
				return EZERO;  // EOF (we just copied the last sector)
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
					nkc_write("...nkcfs_read(2)\n"); nkc_getchar();
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
	nkc_write("...nkcfs_read\n"); nkc_getchar();
	#endif
	return bp;
}
	

static int  nkcfs_write(struct _file *filp, const char *buffer, int buflen)
{
	struct jdfileinfo *pfi;
	int crpos;		// current relativ position in sector buffer
	int pos;		// current absolute position in file
	div_t dres;		// result of a DIV
	UCHAR *pbuf;		// pointer to sector buffer
	UINT bp;		// buffer pointer
	int count = buflen;	// number of bytes to write	
	UCHAR res;		// a result
	
	
	char tbuf[2] = {0,0};
	int ii;
	
	
	#ifdef NKC_DEBUG
	nkc_write("nkcfs_write...\n");
	#endif
	
	pfi = (struct jdfileinfo *)filp->private; 	// get fileinfo
	
	pbuf = pfi->pfcb->pbuffer;					// fetch buffer address						
			
	bp = NULL;
							        	
	while(count)
	{
		// copy bytes to actual buffer
		for(;pfi->crpos < SECSIZE && count > 0; pfi->crpos++,pfi->pos++,count--,bp++)
		{
			pbuf[pfi->crpos] = ((unsigned char*)buffer)[bp];		
			#ifdef NKC_DEBUG	
			nkc_write("- copied buffer -\n");
			#endif								
		}				
				
		// write next sector
		if(count)
		{
			res = write_sector(pfi);	// write current sector to disk an proceed to next sector
					
			switch(res)
			{
				case 0: 
					#ifdef NKC_DEBUG	
					nkc_write("- sector written -\n");
					#endif 
				 	break; 	// no error
				case 5: 
					#ifdef NKC_DEBUG	
					nkc_write("...nkcfs_write(disk full)\n"); nkc_getchar();
					#endif 
					return ENOSPC; 	// No Space left on device
				case 0xff: 
					#ifdef NKC_DEBUG	
					nkc_write("...nkcfs_write(media access error)\n"); nkc_getchar();
					#endif
					return EACCES; 	// media access error						
				
			}
		}
			
		#ifdef NKC_DEBUG	
		//nkc_write(" L: 0x"); nkc_write_hex8((int)pfi->pos); nkc_write("\n");	
		#endif
			
		#ifdef NKC_DEBUG	
		nkc_write("...nkcfs_write\n"); nkc_getchar();
		#endif
			
		    
	}  
	
	return EZERO; 

}

static int  nkcfs_seek(struct _file *filp, int offset, int whence)
{
	struct jdfileinfo *pfi;
	div_t divresult;
	UCHAR res;
	int newpos;
	
	#ifdef NKC_DEBUG
	nkc_write("nkcfs_seek...\n");		
	nkc_write(" offset: 0x"); nkc_write_hex8(offset);
	nkc_write(" whence: 0x"); nkc_write_hex8(whence);
	nkc_write("\n");	
	#endif
	
	
	
	
	
	pfi = (struct jdfileinfo *)filp->private; 	// get fileinfo
	
	switch(whence)
	{
		case 0:	// seek from start of file							
			newpos = offset;
			break;
		case 1: // seek from current file position
			newpos = offset + pfi->pos;					
			break;
		case 2: // seek from end of file										
			newpos = (int)(pfi->pfcb->length*(int)SECSIZE + offset - 1);					
			break;
		default:		
			newpos = offset;			
			break;
	}
			
	divresult = div( newpos , (int)SECSIZE );	
			
	#ifdef NKC_DEBUG
	//nkc_write(" divresult= 0x"); nkc_write_hex8((int)divresult.quot); nkc_write(" newpos= 0x"); nkc_write_hex8(newpos); nkc_write(" SECSIZE= 0x"); nkc_write_hex8(SECSIZE); nkc_write("\n");
	#endif
						
	if(divresult.quot < 0) 
	{
		divresult.quot = 0;
					
		#ifdef NKC_DEBUG
		nkc_write(" error in seek: negativ file offset\n");
		#endif
					
		#ifdef NKC_DEBUG 
		nkc_write("...nkcfs_seek\n"); nkc_getchar();
		#endif
		return;				// check for negativ fileoffset
					
	}
				
	if(divresult.quot > pfi->pfcb->length) 
	{
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
		nkc_write("...nkcfs_seek(2)\n"); nkc_getchar();
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
				nkc_write("...nkcfs_seek(3)\n"); nkc_getchar();
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
	nkc_write("...nkcfs_seek\n"); nkc_getchar();
	#endif
	return;
}
		    	

  
static int  nkcfs_remove(struct _file *filp)
{
	int cjddrive,jddrive;
	
	
	#ifdef NKC_DEBUG
	nkc_write("nkcfs_remove...\n"); nkc_getchar();
	#endif
	
	_nkc_remove(filp->pname);
}

static int  nkcfs_getpos(struct _file *filp)
{
	struct jdfileinfo *pfi;
	
	#ifdef NKC_DEBUG
	nkc_write("nkcfs_getpos...\n");
	#endif
	

	pfi = (struct jdfileinfo *)filp->private; 	// get fileinfo
	
	#ifdef NKC_DEBUG 
	nkc_write("...nkcfs_getpos\n"); nkc_getchar();
	#endif
	
	return pfi->pos;
	
}


static int  nkcfs_rename(struct _file *filp, const char *oldrelpath, const char *newrelpath)
{	
	_nkc_rename(oldrelpath,newrelpath);
}


void nkcfs_init_fs(void)
{
 	#ifdef NKC_DEBUG
	nkc_write("nkcfs_init_fs...\n"); 
	#endif
	
	register_driver("A","JADOSFS",&nkc_file_operations); 
	register_driver("Q","JADOSFS",&nkc_file_operations);	// wir müssen natürlich M einhängen ...
	
	#ifdef NKC_DEBUG	
	nkc_write(" Address of open: 0x"); nkc_write_hex8((int)nkcfs_open); nkc_write("\n");	
	nkc_write(" Address of nkc_file_operations: 0x"); nkc_write_hex8((int)&nkc_file_operations); nkc_write("\n");
	nkc_write(" Address of ...->open: 0x"); nkc_write_hex8((int)nkc_file_operations.open); nkc_write("\n");
	nkc_write("...nkcfs_init_fs\n"); nkc_getchar();
	#endif
}
