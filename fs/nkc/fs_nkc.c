#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <fs.h>
#include <debug.h>
#include <ioctl.h>
#include <ff.h> // FILINFO and DIR...
#include "fs_nkc.h"

#include "../../nkc/llnkc.h"


const struct file_operations nkc_file_operations =
{
  nkcfs_open,
  nkcfs_close,
  nkcfs_read,
  nkcfs_write,
  nkcfs_seek,
  nkcfs_ioctl,
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
	
	fsnkc_dbg("read_sector...\n");
	
	if(pfi->eof) 
	{
		fsnkc_lldbgwait("...read_sector(1)\n");
		return 1;			// already at end of file
	}
	
	pbuffer = pfi->pfcb->pbuffer; 		// save sector buffer address
	result = nkc_readrec(pfi->pfcb);	// read sector
	
	switch(result)
	{
		case 0: 
			fsnkc_dbg(" >>>>>>>>>>>>>>\n");
			break; 	    // no error
		case 1: pfi->eof = 1; 
			fsnkc_lldbgwait("...read_sector(EOF)\n");
			return 1; // EOF
		case 99: break; 	    // end of user space (JADOS)
		default: 		    // error reading device
		break;
	}
	
	pfi->pfcb->pbuffer = pbuffer;	// restore sector buffer address
	pfi->clsec++;			// increment current logical sector
	pfi->crpos=0;			// reset current logical sector position
	
	fsnkc_lldbgwait("...read_sector\n");
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
	
	fsnkc_dbg("write_sector...\n");
	
	
	if(pfi->pfcb->mode != 0xE5 || (pfi->crpos == 0)) 
	{
		fsnkc_dbg("...buffer empty or file read only, no need to save\n"); 
		fsnkc_lldbgwait("...write_sector\n");
	}
		    	
	pbuffer = pfi->pfcb->pbuffer; 		// save sector buffer address
	result = nkc_writerec(pfi->pfcb);	// write sector
	
	switch(result)
	{
		case 0:  
			fsnkc_dbg(" <<<<<<<<<<<<<<<<<\n");			
			break; 	// no error
		case 5:  
			fsnkc_lldbgwait("...write_sector(disk full)\n");
			return 0; 	// disk full
		case 0xff: 
			fsnkc_dbg(" media access error\n");
			break; 	// media access error	
		default:		
			fsnkc_dbg(" other error\n"); 		// general errror
			break;	
	}
	
	pfi->pfcb->pbuffer = pbuffer;	// restore sector buffer address
	pfi->clsec++;			// increment current logical sector
	//pfi->pfcb->length += 1;	// this done internal by jados
	pfi->crpos=0;			// reset current logical sector position
	memset(pbuffer,0,BUFFER_SIZE);	// clear buffer
	
	fsnkc_lldbgwait("...write_sector\n");
	return result;
}


/*
 * The f_opendir() function opens an exsisting directory and creates the directory object for subsequent calls.
 */
FRESULT nkcfs_opendir (
  DIR* dp,           /* [OUT] Pointer to the directory object structure */
  const TCHAR* path  /* [IN] Directory name */
){
  fsnkc_lldbg("fs_nkc.c: f_opendir not yet implemented...\n");
}

/*
 * The f_closedir() function closes an open directory object. After the function succeeded, the directory object is no longer valid and it can be discarded.
 */
FRESULT nkcfs_closedir (
  DIR* dp     /* [IN] Pointer to the directory object */
){
  fsnkc_lldbg("fs_nkc.c: f_opendir not yet implemented...\n");
}

/*
 * The f_readdir() function reads directory items, file and directory, in sequence. All items in the directory can be read by calling f_readdir() function repeatedly.
 * When all directory items have been read and no item to read, a null string is returned into the fname[] without any error
 * When a null pointer is given to the fno, the read index of the directory object is rewinded.
 * 
 * Available fileinformation in a JADOS environment:
 * 
 */
FRESULT nkcfs_readdir (
  DIR* dp,      /* [IN] Directory object */
  FILINFO* fno  /* [OUT] File information structure */
){
  
  fsnkc_lldbg("fs_nkc.c: f_opendir not yet implemented...\n");
}

/*******************************************************************************
 *   public functions   
 *******************************************************************************/
static int     nkcfs_ioctl(char *name, int cmd, unsigned long arg){
//  long p1,p2;
//  WORD w;
//  DWORD dw;
  char cdrive[2];
  FRESULT res; 
//  char tmp[10];
//  struct _deviceinfo di;
  
  fsnkc_dbg("fs_nkc.c: [ nkcfs_ioctl ...\n");  

  switch(cmd){
  
    // ****************************** get current working directory ****************************** 
    case FS_IOCTL_GETCWD:    
      fsnkc_dbg("fs_nkc.c: - FS_IOCTL_GETCWD -\n"); 
      cdrive[1] = 0;      
      if(_DRIVE >= 0 && _DRIVE <= 4) /* is it a ramdisk(0) or floppy drive(1..4) ? */
		{
			cdrive[0] = _DRIVE + '0';
		}
		
		if(_DRIVE >= 5 && _DRIVE <= 30) /* is it a hard disk drive (5..30) ? */
		{
			cdrive[0] = _DRIVE - 5 + 'A';
		}
		
      strcpy((char*)((struct ioctl_get_cwd*)(arg))->cdrv,cdrive);
      strcpy((char*)((struct ioctl_get_cwd*)(arg))->cpath,"/");     /* there is nothing like a subdirectory in JADOS/NKC FS */
      res = FR_OK;
      
    // ****************************** change physical drive ****************************** 
    case  FS_IOCTL_CHDRIVE:
      fsnkc_dbg("fs_nkc.c: - FS_IOCTL_CHDRIVE -\n");            
      if((*(char*)arg) >= '0' && (*(char*)arg) <= '4'){ /* is it a ramdisk(0) or floppy drive(1..4) ? */
	_DRIVE = (*(char*)arg) - '0';
      }      
      if((*(char*)arg) >= 'A' && (*(char*)arg) <= 'Z'){ /* is it a hard disk drive (5..30) ? */	
	_DRIVE = (*(char*)arg) + 5 - 'A';
      }                  
      res = 0;
      break;
    // ****************************** open directory **************************************  
    case FS_IOCTL_OPEN_DIR:
			      res = nkcfs_opendir(((struct ioctl_opendir*)arg)->dp,   // OUT: DIR structure
					          ((struct ioctl_opendir*)arg)->path);// IN : Path, i.e. drive
			      break;
      
     // ****************************** read directory ******************************
    case FS_IOCTL_READ_DIR:
			      res = nkcfs_readdir(((struct ioctl_readdir*)arg)->dp,   // IN : DIR structure
					          ((struct ioctl_readdir*)arg)->fno); // OUT: file information structure
			      break;
    // ****************************** close directory ******************************
    case FS_IOCTL_CLOSE_DIR:	
			      res = nkcfs_closedir((DIR*)arg);			      // IN: DIR structure      
			      break;  
			      
			      
    // ****************************** directory function call to JADOS ******************************
    //struct ioctl_nkc_dir {
    //  BYTE  attrib;			// IN: bitmapped file attribute: 1=file length; 2=date; 4=r/w attribute
    //  BYTE  *ppattern;	        // IN: pointer to file pattern (? and * and drive info are also allowed)
    //  BYTE  cols;			// IN: number of colums for output
    //  UINT  size;			// IN: size of output buffer pbuf (256x14 Bytes max.)
    //  void* pbuf;			// OUT: output buffer
    //};
    //NKC_IOCTL_DIR
    case NKC_IOCTL_DIR:  
      fsnkc_dbg("fs_nkc.c: - NKC_IOCTL_DIR -\n"); 
      res = _nkc_directory( ((struct ioctl_nkc_dir*)arg)->pbuf,
			    ((struct ioctl_nkc_dir*)arg)->ppattern,
			    ((struct ioctl_nkc_dir*)arg)->attrib,
			    ((struct ioctl_nkc_dir*)arg)->cols,
			    ((struct ioctl_nkc_dir*)arg)->size);
      break;
    default: res = 0;
  }

  
  fsnkc_dbg("fs_nkc.c: ... nkcfs_ioctl ]\n");

  return res;
}


static int nkcfs_open(struct _file *filp)
{
	UCHAR result;
	struct jdfcb *pfcb;
	struct jdfileinfo *pfi;
	UCHAR *pbuffer;
	
	fsnkc_lldbgwait("nkcfs_open...\n");
	
	fsnkc_dbg("fname= %s\n",filp->pname);
	fsnkc_dbg("oflags= 0x%x",filp->f_oflags);
	fsnkc_lldbgwait("\n");
	
	
	/*
		allocate all buffers
	*/
	pfcb = (struct jdfcb *)malloc(sizeof(struct jdfcb));	
	pfi = (struct jdfileinfo *)malloc(sizeof(struct jdfileinfo));
	pbuffer = (unsigned char*)malloc(BUFFER_SIZE);
	
	fsnkc_dbg(" pfcb=0x%x",(int)pfcb);
	fsnkc_dbg(" pfi=0x%x",(int)pfi);	
	fsnkc_dbg(" pbuffer=0x%x",(int)pbuffer);
	fsnkc_lldbgwait("\n");
	
		
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
				fsnkc_dbg("- success -\n");
				break;						
		case 5:		// DISK FULL (create)
				fsnkc_dbg("- disk full -\n");
				break;				
		case 6:  	// DIRECTORY FULL (create)
				fsnkc_dbg("- directory full -\n");
				break;						
		case 7:		// ACCESS ERROR (create)
				fsnkc_dbg("- access error -\n");
				break;						
		case 0xff:	// FILE NOT FOUND
				fsnkc_dbg("- file not found error -\n");
				break;				
		default:
				fsnkc_dbg("- unspecified error -\n");
				break;				

		
	}	
	
	if(result != 0)
	{		
		free(pfi);
		free(pfcb);
		free(pbuffer);
				
		fsnkc_lldbgwait("...nkcfs_open(3)\n");
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
	
	fsnkc_dbg("flags=0x%x",pfi->pfcb->mode);
	fsnkc_lldbgwait("...nkcfs_open\n");
	
	filp->private = (void*)pfi;
	
	return EZERO;
}




static int nkcfs_close(struct _file *filp)
{
	UCHAR result;	
	struct jdfileinfo *pfi;
	
	fsnkc_dbg("nkcfs_close...\n");
	
	pfi = (struct jdfileinfo*)filp->private;
		    
	/* flush current sector, if mode = write */
	if(pfi->pfcb->mode == 0xE5 && (pfi->crpos > 0)) 
   	{
	  fsnkc_dbg(" crpos = %d\n",pfi->crpos);
   	  write_sector(pfi);
    }
	
	/* flush current sector, if mode = write */
	if(pfi->pfcb->mode == 0xE5 && (pfi->crpos > 0)) 
	{
		fsnkc_dbg(" crpos = %d\n",pfi->crpos);
		write_sector(pfi);
	}

	    	
	/* close file on media */  		    			    	
	nkc_close(pfi->pfcb);
    	
    /* free buffers and handles*/
	free(pfi->pfcb->pbuffer);
	free(pfi->pfcb);
	free(pfi);
			    	
	fsnkc_lldbgwait("...nkcfs_close\n");
	
	return EZERO;
}

static int nkcfs_read(struct _file *filp, char *buffer, int buflen)
{
    struct jdfileinfo *pfi;
	UCHAR *pbuf;	// pointer to sector buffer
	UINT count = buflen;	// number of bytes to read
	UINT bp;		// buffer pointer
	UINT res;		// a result
		
	fsnkc_dbg("nkcfs_read...\n buflen: 0x%x\n",buflen);

	
	pfi = (struct jdfileinfo *)filp->private; 

	if(pfi->eof) 
	{
		fsnkc_lldbgwait("...nkcfs_read(1)\n");
		return EZERO;		    		
	}

	pbuf = pfi->pfcb->pbuffer;	// fetch buffer address
	
	fsnkc_dbg(" pbuf = 0x%x   ",(int)pbuf);
	fsnkc_dbg(" buf  = 0x%x \n",(int)buffer);
	
	bp = 0;
				        	
	while(count)
	{
		
		// copy bytes from current buffer
		for(;pfi->crpos < SECSIZE && count > 0; pfi->crpos++,pfi->pos++,count--,bp++)
		{
			((UCHAR*)buffer)[bp] = pbuf[pfi->crpos];
		}
				
		fsnkc_dbg("\n");
				
		// read next sector
		if(count)
		{				
			if (pfi->clsec == pfi->pfcb->length) 
			{
				fsnkc_lldbgwait("...nkcfs_read(EOF)\n");
				return EZERO;  // EOF (we just copied the last sector)
			}
					
			res = read_sector(pfi);			       // read next sector
					
			switch(res)
			{
				case 0: 
					fsnkc_dbg("ok\n");
					break;				// no error
				case 1:  
					fsnkc_dbg("EOF\n");
				    return bp; 			// EOF, we return EOF = 0 on next call
				case 99:
					fsnkc_dbg("JADOS EOUS\n");
					fsnkc_lldbgwait("...nkcfs_read(2)\n");
					return 0; 			// end of user space (JADOS)
				default: 
					fsnkc_dbg("unknown\n");
					fsnkc_lldbgwait("...jfread(3)\n");
					return 0;			// error reading device
			}				
		}
			
	}		
			
	fsnkc_lldbgwait("...nkcfs_read\n");
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
	
	
	fsnkc_dbg("nkcfs_write...\n");

	pfi = (struct jdfileinfo *)filp->private; 	// get fileinfo
	
	pbuf = pfi->pfcb->pbuffer;					// fetch buffer address						
			
	bp = NULL;
							        	
	while(count)
	{
		// copy bytes to actual buffer
		for(;pfi->crpos < SECSIZE && count > 0; pfi->crpos++,pfi->pos++,count--,bp++)
		{
			pbuf[pfi->crpos] = ((unsigned char*)buffer)[bp];		
				
			fsnkc_dbg("- copied buffer -\n");										
		}				
				
		// write next sector
		if(count)
		{
			res = write_sector(pfi);	// write current sector to disk an proceed to next sector
					
			switch(res)
			{
				case 0: 
					fsnkc_dbg("- sector written -\n");
				 	break; 	// no error
				case 5: 
					fsnkc_lldbgwait("...nkcfs_write(disk full)\n");
					return ENOSPC; 	// No Space left on device
				case 0xff: 
					fsnkc_lldbgwait("...nkcfs_write(media access error)\n");
					return EACCES; 	// media access error						
				
			}
		}
		
		fsnkc_lldbgwait("...nkcfs_write\n");
			
		    
	}  
	
	return EZERO; 

}

static int  nkcfs_seek(struct _file *filp, int offset, int whence)
{
	struct jdfileinfo *pfi;
	div_t divresult;
	UCHAR res;
	int newpos;
	
	fsnkc_dbg("nkcfs_seek...\n");		
	fsnkc_dbg(" offset: 0x%x  ",offset);
	fsnkc_dbg(" whence: 0x%x\n",whence);
	
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
						
	if(divresult.quot < 0) 
	{
		divresult.quot = 0;
					
		fsnkc_dbg(" error in seek: negativ file offset\n");
		fsnkc_lldbgwait("...nkcfs_seek\n");
		return;				// check for negativ fileoffset
					
	}
				
	if(divresult.quot > pfi->pfcb->length) 
	{
		divresult.quot = pfi->pfcb->length - 1;
		pfi->eof = 1;
		
		fsnkc_lldbgwait("...nkcfs_seek(2)\n");
		return;		// check for seek beyond filend
	}
			
	if(divresult.quot != pfi->pfcb->length) // did we seek into another sector ?
	{
		res = nkc_setrec(pfi->pfcb, (int)divresult.quot); // set new record ...
			
		switch(res)
		{
			case 0: // successful
				res = read_sector(pfi);	// ... and read record to buffer
			
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
				fsnkc_lldbgwait("...nkcfs_seek(3)\n");
				return;	
									
			default: 
				 fsnkc_dbg(" should not be here (0x%x)!\n",res);
				 break;
		}	
			
	}		       
			
	pfi->pos 	= newpos;		/* file position	    		0....				*/
	pfi->crpos 	= (int)divresult.rem;	/* current relativ position (in sector) 0...SECSIZE-1			*/
	pfi->clsec	= (int)(divresult.quot + 1); 	/* current logical sector   		1...65536			*/
	
	fsnkc_lldbgwait("...nkcfs_seek\n");
	return;
}
		    	

  
static int  nkcfs_remove(struct _file *filp)
{
	int cjddrive,jddrive;
	
	fsnkc_lldbgwait("nkcfs_remove...\n");
	
	_nkc_remove(filp->pname);
}

static int  nkcfs_getpos(struct _file *filp)
{
	struct jdfileinfo *pfi;
	
	fsnkc_dbg("nkcfs_getpos...\n");
	
	pfi = (struct jdfileinfo *)filp->private; 	// get fileinfo
	
	fsnkc_lldbgwait("...nkcfs_getpos\n");
	return pfi->pos;
	
}


static int  nkcfs_rename(struct _file *filp, const char *oldrelpath, const char *newrelpath)
{	
	_nkc_rename(oldrelpath,newrelpath);
}


void nkcfs_init_fs(void)
{
	fsnkc_dbg("nkcfs_init_fs...\n"); 
	
	register_driver("A","JADOSFS",&nkc_file_operations); 
	register_driver("Q","JADOSFS",&nkc_file_operations);	// wir müssen natürlich M einhängen ...
		
	fsnkc_dbg(" Address of open: 0x%x\n",(int)nkcfs_open);
	fsnkc_dbg(" Address of nkc_file_operations: 0x%x\n",(int)&nkc_file_operations);
	fsnkc_dbg(" Address of ...->open: 0x%x\n",(int)nkc_file_operations.open);
	fsnkc_lldbgwait("...nkcfs_init_fs\n");
}
