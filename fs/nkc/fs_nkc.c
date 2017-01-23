#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <fs.h>
#include <debug.h>
#include <ioctl.h>
#include <ff.h> // FILINFO and DIR...
#include "fs_nkc.h"



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
 *   private variables   
 *******************************************************************************/
 
#ifndef USE_JADOS
extern struct fstabentry *fstab; 		/* global filesystem table -> fs/fs.c */
extern struct blk_driver *blk_driverlist; 	/* global pointer to list of block device drivers -> driver/drivers.c */
#endif

static UINT current_jados_drive;





/*******************************************************************************
 *   private functions   
 *******************************************************************************/

#ifdef USE_JADOS
static DRESULT read_sector(struct jdfileinfo *pfi)
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
	
	switch( jd_readrec(pfi->pfcb) ) {
	
		case 0: 
			fsnkc_dbg(" >>>>>>>>>>>>>>\n");
			result = RES_OK;
			break; 	    // no error
		case 1: pfi->eof = 1; 
			fsnkc_lldbgwait("...read_sector(EOF)\n");
			result = RES_EOF;
			return 1; // EOF
		case 99: 
		        result = RES_NOMEM;
			break; 	    // end of user space (JADOS)
		default: 		    // error reading device
		  result = RES_PARERR;
		break;
	}
	
	pfi->pfcb->pbuffer = pbuffer;	// restore sector buffer address
	pfi->clsec++;			// increment current logical sector
	pfi->crpos=0;			// reset current logical sector position

	fsnkc_lldbgwait("...read_sector\n");
	return result;
}

static DRESULT write_sector(struct jdfileinfo *pfi)
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
	
	switch( jd_writerec(pfi->pfcb) ) // write sector
	{
		case 0:  
			fsnkc_dbg(" <<<<<<<<<<<<<<<<<\n");
			result = RES_OK;
			break; 	// no error
		case 5:  
			fsnkc_lldbgwait("...write_sector(disk full)\n");
			result = RES_DISKFULL;
			return 0; 	// disk full
		case 0xff: 
			fsnkc_dbg(" media access error\n");
			result = RES_ERROR;
			break; 	// media access error	
		default:		
			result = RES_PARERR;
			fsnkc_dbg(" other error\n"); 		// general errror
			break;	
	}
	
	pfi->pfcb->pbuffer = pbuffer;	// restore sector buffer address
	pfi->clsec++;			// increment current logical sector
	//pfi->pfcb->length += 1;	// this done jados internal
	pfi->crpos=0;			// reset current logical sector position
	memset(pbuffer,0,BUFFER_SIZE);	// clear buffer

	fsnkc_lldbgwait("...write_sector\n");
	return result;
}

#else
static
struct blk_driver* get_phy_driver(UINT pdrv)
/* pdrv == physical drive number ( 0 = RAMDISK, 1...4 = Diskette, 5...30 = Festplatten A..Z) */
{
  struct fstabentry *pcur;
  struct blk_driver* drv = NULL;
  char lw;
  
  pcur = fstab;	
  
  while(pcur)
  {
  	if(pcur->pdrv == pdrv)
  	{ // found device 
  	  drv = pcur->pblkdrv;
	  break;
  	}  	
  	pcur = pcur->next;
  }		

  return drv; 
}




// 1) search 'JADOS' block driver
// 2) call ioctrl JADOS_READ_REC 
static DRESULT read_sector(struct jdfileinfo *pfi)
{
  
  struct blk_driver* blk_drv;
  DRESULT res = RES_PARERR;
  
  
  if(!pfi) return res;
  if(!pfi->pfcb) return res;
    
  blk_drv = get_phy_driver(pfi->pfcb->lw);
  
  if(blk_drv) {
	  if(blk_drv->blk_oper) {
	    if(blk_drv->blk_oper->ioctl) {
	        res = blk_drv->blk_oper->ioctl(NULL,NKC_IOCTL_READ_REC,&pfi);
	    }
	  }
	}	
	
  return res;
}

/*
			 UCHAR nkc_writerec(struct fcb *FCB)
			 returns 	   0 - if successful
			 		   5 - disk full
			 		0xFF - access error 
*/

// 1) search block driver
// 2) call ioctrl JADOS_WRITE_REC
static DRESULT write_sector(struct jdfileinfo *pfi)
{
  struct blk_driver* blk_drv;
  DRESULT res = RES_PARERR;
  
  
  if(!pfi) return res;
  if(!pfi->pfcb) return res;
  
  blk_drv = get_phy_driver(pfi->pfcb->lw);
  
  if(blk_drv) {
	  if(blk_drv->blk_oper) {
	    if(blk_drv->blk_oper->ioctl) {
	        res = blk_drv->blk_oper->ioctl(NULL,NKC_IOCTL_WRITE_REC,&pfi);
	    }
	  }
	}	
	
  return res;
}


static DRESULT call_blk_ioctl(struct jdfcb *pfcb, int cmd, unsigned long arg)  
{
  struct blk_driver* blk_drv;
  DRESULT res = RES_PARERR; 
  
  if(!pfcb) return res;
  
  blk_drv = get_phy_driver(pfcb->lw);
  
  if(blk_drv) {
	  if(blk_drv->blk_oper) {
	    if(blk_drv->blk_oper->ioctl) {
	        res = blk_drv->blk_oper->ioctl(NULL,cmd,arg);
	    }
	  }
	}	
	
  return res;
}

#endif



/*******************************************************************************
 *   public functions   
 *******************************************************************************/



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
static int nkcfs_ioctl(struct _file *filp, int cmd, unsigned long arg){
//  long p1,p2;
//  WORD w;
//  DWORD dw;
  char cdrive[2];
  FRESULT res; 
//  char tmp[10];
//  struct _deviceinfo di;
  
  fsnkc_dbg("fs_nkc.c: [ nkcfs_ioctl (cmd = %d)...\n",cmd);   

  switch(cmd){
  
    // ****************************** get current working directory ****************************** 
    case FS_IOCTL_GETCWD:    
      fsnkc_dbg("fs_nkc.c: - FS_IOCTL_GETCWD -\n"); 
      
#ifdef USE_JADOS
      current_jados_drive = jd_get_drive(); // call jados
#endif
      cdrive[1] = 0;      
      if(current_jados_drive >= 0 && current_jados_drive <= 4) /* is it a ramdisk(0) or floppy drive(1..4) ? */
		{
			cdrive[0] = current_jados_drive + '0';
		}
		
		if(current_jados_drive >= 5 && current_jados_drive <= 30) /* is it a hard disk drive (5..30) ? */
		{
			cdrive[0] = current_jados_drive - 5 + 'A';
		}
		
      strcpy((char*)((struct ioctl_get_cwd*)(arg))->cdrive,cdrive);
      strcpy((char*)((struct ioctl_get_cwd*)(arg))->cpath,"/");     /* there is nothing like a subdirectory in JADOS/NKC FS */
      res = FR_OK;
      break;
    // ****************************** change physical drive ****************************** 
    case  FS_IOCTL_CHDRIVE: 
      // *filp=NULL, cmd=FS_IOCTL_CHDRIVE, arg = (struct fstabentry*)pfstab 
      fsnkc_dbg(" fs_nkc.c: FS_IOCTL_CHDRIVE: %s", ((struct fstabentry*)arg)->devname);
      fsnkc_lldbgwait("(KEY)\n");
      
      if((*(char*)((struct fstabentry*)arg)->devname) >= '0' && (*(char*)((struct fstabentry*)arg)->devname) <= '4'){ /* is it a ramdisk(0) or floppy drive(1..4) ? */
	current_jados_drive = (*(char*)((struct fstabentry*)arg)->devname) - '0';
      }      
      if((*(char*)((struct fstabentry*)arg)->devname) >= 'A' && (*(char*)((struct fstabentry*)arg)->devname) <= 'Z'){ /* is it a hard disk drive (5..30) ? */	
	current_jados_drive = (*(char*)((struct fstabentry*)arg)->devname) + 5 - 'A';
      }            
#ifdef USE_JADOS
      jd_set_drive(current_jados_drive); // call jados
#endif
      res = FR_OK;
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
			      
    // ****************************** mount ******************************			      
    case FS_IOCTL_MOUNT:
      //name = NULL, cmd = FS_IOCTL_MOUNT, arg = pfstab
      // this is called after an entry was inserted into fstab in fs.c. We have to translate volume name to physical drive number here,
      // so 'get_phy_driver' can fetch the correct block driver in subsequent file operations.
      
      fsnkc_dbg("fs_nkc.c: - FS_IOCTL_MOUNT -\n"); 
      
      if(!arg){
	res = FR_INVALID_PARAMETER;
	fsnkc_lldbgwait("fs_nkc: error: invalid parameter arg=NULL !\n");
	break;
      }
	
      fsnkc_dbg("fs_nkc.c: convert drive %s to ",(((struct fstabentry*)arg)->devname) );
	
      if( (*((struct fstabentry*)arg)->devname) >= '0' && (*((struct fstabentry*)arg)->devname) <= '4' ){ /* is it a ramdisk(0) or floppy drive(1..4) ? */
	((struct fstabentry*)arg)->pdrv = (*((struct fstabentry*)arg)->devname) - '0';	
	fsnkc_dbg("fs_nkc: phydrv(1) %d\n",((struct fstabentry*)arg)->pdrv); 
      }      
      else if( (*((struct fstabentry*)arg)->devname) >= 'A' && (*((struct fstabentry*)arg)->devname) <= 'Z' ){ /* is it a hard disk drive (5..30) ? */	
	((struct fstabentry*)arg)->pdrv = (*((struct fstabentry*)arg)->devname) + 5 - 'A';
	fsnkc_dbg("fs_nkc: phydrv(2) %d \n",((struct fstabentry*)arg)->pdrv); 
      }
      else fsnkc_dbg("fs_nkc: ...ERROR\n"); 
      res = FR_OK;
      
      break;			      
    // ****************************** directory function call to JADOS ******************************
   
    case NKC_IOCTL_DIR:  
      // *filp = NULL, cmd=NKC_IOCTL_DIR, arg = ptr to struct ioctl_nkc_dir)
      fsnkc_dbg("fs_nkc.c: - NKC_IOCTL_DIR -\n"); 

      
      if(!arg){
	fsnkc_lldbgwait("fs_nkc.c: arg = NULL\n");
	res = FR_INVALID_PARAMETER;
	break;
      }
      
#ifdef USE_JADOS
      res = jd_directory( (void*)((struct ioctl_nkc_dir*)arg)->pbuf,
			       (void*)((struct ioctl_nkc_dir*)arg)->ppattern,
			       (BYTE)((struct ioctl_nkc_dir*)arg)->attrib,
			       (WORD)((struct ioctl_nkc_dir*)arg)->cols,
			       (WORD)((struct ioctl_nkc_dir*)arg)->size);  

#else      
      res = ((struct ioctl_nkc_dir*)arg)->pfstab->pblkdrv->blk_oper->ioctl(NULL,cmd,arg);            
#endif
      
      break;
      
    default: res = FR_OK;
  }

  
  fsnkc_dbg("fs_nkc.c: ... nkcfs_ioctl ]\n");

  if(res < FRESULT_OFFSET)
    return res + FRESULT_OFFSET;
   else return res;
}


static int nkcfs_open(struct _file *filp)
{
	FRESULT result;
	DRESULT dresult;
	struct jdfcb *pfcb;
	struct jdfileinfo *pfi;
	UCHAR *pbuffer;
	char *pfilename,*pc1,*pc2;
	
	fsnkc_lldbgwait("nkcfs_open...\n");
	
	fsnkc_dbg("fname= %s\n",filp->pname);
	fsnkc_dbg("oflags= 0x%x",filp->f_oflags);
	fsnkc_lldbgwait("\n");
	
	// remove path information from filename...
	pc1 = filp->pname;
	pc2 = pfilename = (char*)malloc(strlen(pc1));
	*pc2=0;
	while(*pc1){
	  if(*pc1 != '/'){*pc2++ = toupper(*pc1);}
	  pc1++;	  
	}
	*pc2=0;
	
	
	printf(" nkcfs_open(%s)\n",pfilename);
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

		
#ifdef USE_JADOS
	 /*
		result	Bedeutung
		0	FCB angelegt
		0xff	name ist kein Dateiname	
	*/
	if(jd_fillfcb(pfcb,pfilename))
	{
		gp_write(" error fillfcb: not a filename\n");
		free(pfcb);
		free(pfi);
		free(pbuffer);
		free(pfilename);
		return FR_INVALID_NAME;
	}
#else
	// call NKC_IOCTL_FILLFCB (geht noch nicht, dieser Call muss von hier gemacht werden)	
	//UINT call_blk_ioctl(struct jdfcb *pfcb, NKC_IOCTL_FILLFCB, unsigned long arg)
#endif
	
	pfcb->pbuffer = pbuffer;	
		
	if(filp->f_oflags & _F_CREATE)
	{
		/*
			OK, try to create the file
		*/
#ifdef USE_JADOS
		 /*
		result	Bedeutung
		0	Datei gel..scht
		2	Datei nicht vorhanden
		0xff	Fehler beim Zugriff auf den Massenspeicher
		*/
		switch( jd_erase(pfcb) ) { 	// first we try to erase the file if it exists 
		  case 0: result = FR_OK; break;
		  case 2: result = FR_INVALID_NAME; break;
		  case 0xFF: result = FR_DISK_ERR; break;
		  default: result = FR_INVALID_PARAMETER;
		}
#else		
		//result = call_blk_ioctl(pfcb, NKC_IOCTL_ERASE, NULL); // OK
#endif
		

#ifdef USE_JADOS
                /*
		result	Bedeutung
		0	Datei angelegt
		5	Massenspeicher voll
		6	Inhaltsverzeichnis voll
		0xff	Fehler beim Zugriff auf den Massenspeicher
		
		Achtung: falls die Datei schon existiert, wird sie lediglich ge..ffnet !
		*/
		switch( jd_create(pfcb) ) {	// create new file 
		  case 0: result = FR_OK; break;
		  case 5: result = FR_DISKFULL; break;
		  case 6: result = FR_DIRFULL; break;
		  case 0xff: result = FR_DISK_ERR; break;
		  default: result = FR_INVALID_PARAMETER; 
		}
#else
		//result = call_blk_ioctl(pfcb, NKC_IOCTL_CREATE, NULL); // OK
#endif				

	}else
	{
		/*
			OK, try to open the file
		*/
#ifdef USE_JADOS
                /*
			result	Bedeutung
			0	Datei geöffnet
			0xff	Datei nicht vorhanden
		*/
		switch( jd_open(pfcb) ) {
		  case 0: result = FR_OK; break;
		  case 0xFF: result = FR_NO_FILE; break;
		  default: result = FR_INVALID_PARAMETER;
		}
#else
		//result = call_blk_ioctl(pfcb, NKC_IOCTL_OPEN, NULL); // OK
#endif		
				
	}
	
#ifdef CONFIG_DEBUG_FS_NKC	
	switch(result)
	{
		case FR_OK: 		// SUCCESS
				fsnkc_dbg("- success -\n");
				break;						
		case FR_DISKFULL:		// DISK FULL (create)
				fsnkc_dbg("- disk full -\n");
				break;				
		case FR_DIRFULL:  	// DIRECTORY FULL (create)
				fsnkc_dbg("- directory full -\n");
				break;						
		case FR_DISK_ERR:		// ACCESS ERROR (create)
				fsnkc_dbg("- access error -\n");
				break;						
		case FR_NO_FILE:	// FILE NOT FOUND
				fsnkc_dbg("- file not found error -\n");
				break;				
		default:
				fsnkc_dbg("- unspecified error -\n");
				break;						
	}	
#endif	
	
	if(result != FR_OK)
	{		
		free(pfi);
		free(pfcb);
		free(pbuffer);
		free(pfilename);		
		fsnkc_lldbgwait("...nkcfs_open(3)\n");
		if(result < FRESULT_OFFSET)
		  return result + FRESULT_OFFSET;
		else return result;
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
		dresult = read_sector(pfi);
	}
	
	fsnkc_dbg("flags=0x%x",pfi->pfcb->mode);
	fsnkc_lldbgwait("...nkcfs_open\n");
	
	filp->private = (void*)pfi;
	
	free(pfilename);
	
	if(dresult < FRESULT_OFFSET && dresult != RES_OK)
	  return dresult + DRESULT_OFFSET;
	else return dresult;
}




static int nkcfs_close(struct _file *filp)
{
	FRESULT result;	
	DRESULT dresult = RES_PARERR;
	struct jdfileinfo *pfi;
	
	fsnkc_dbg("nkcfs_close...\n");
	
	pfi = (struct jdfileinfo*)filp->private;
		    
	/* flush current sector, if mode = write */
	if(pfi->pfcb->mode == 0xE5 && (pfi->crpos > 0)) 
   	{
	  fsnkc_dbg(" crpos = %d\n",pfi->crpos);
   	  dresult = write_sector(pfi);
    }
	
	/* flush current sector, if mode = write */
	if(pfi->pfcb->mode == 0xE5 && (pfi->crpos > 0)) 
	{
		fsnkc_dbg(" crpos = %d\n",pfi->crpos);
		dresult = write_sector(pfi);
	}

	    	
	/* close file on media */ 
#ifdef USE_JADOS
	jd_close(pfi->pfcb); 
#else
	//result =  call_blk_ioctl(pfi->pfcb, NKC_IOCTL_CLOSE, NULL); // OK
#endif	
    	
    /* free buffers and handles*/
	free(pfi->pfcb->pbuffer);
	free(pfi->pfcb);
	free(pfi);
			    	
	fsnkc_lldbgwait("...nkcfs_close\n");
	
	if(dresult < FRESULT_OFFSET && dresult != RES_OK)
	  return dresult + DRESULT_OFFSET;
	else return dresult;
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
	DRESULT res;		// a result
	
	
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
#ifdef CONFIG_DEBUG_FS_NKC					
			switch(res)
			{
				case RES_OK: 
					fsnkc_dbg("- sector written -\n");
				 	break; 	// no error
				case RES_DISKFULL: 
					fsnkc_lldbgwait("...nkcfs_write(disk full)\n");
					return ENOSPC; 	// No Space left on device
				case RES_ERROR: 
					fsnkc_lldbgwait("...nkcfs_write(media access error)\n");
					return EACCES; 	// media access error						
				
			}
#endif			
		}
		
		fsnkc_lldbgwait("...nkcfs_write\n");
			
		    
	}  
	
	if(res < FRESULT_OFFSET && res != RES_OK)
	  return res + DRESULT_OFFSET;
	else return res; 

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
#ifdef USE_JADOS
		res = jd_setrec(pfi->pfcb, (int)divresult.quot); // set new record ... 
#else
	  
		//args.arg1 = pfi->pfcb;
		//args.arg2 = divresult.quot;
		//res = call_blk_ioctl(pfi->pfcb, NKC_IOCTL_SETREC, &args); // OK
#endif			
		switch(res)
		{
			case 0: // successful
				res = read_sector(pfi);	// ... and read record to buffer
			      
				switch(res)
				{
					case RES_OK: 							
						 break;				// no error
					case RES_EOF:  pfi->eof = 1;		/* set eof flag			*/ 
						break;
					case RES_NOMEM:break; 			// end of user space (JADOS)
					default: break;			// error reading device
				}					
				break;
				
			case 1: // EOF
				pfi->eof = 1;	/* set eof flag	 */ 					
				res = RES_EOF;
				break;	
				
			case 0xFF: // access error
				fsnkc_lldbgwait("...nkcfs_seek(3)\n");
				res = RES_ERROR;
				return;	
									
			default: 
				 fsnkc_dbg(" should not be here (0x%x)!\n",res);
				 res = RES_ERROR;
				 break;
		}	
			
	}		       
			
	pfi->pos 	= newpos;		/* file position	    		0....				*/
	pfi->crpos 	= (int)divresult.rem;	/* current relativ position (in sector) 0...SECSIZE-1			*/
	pfi->clsec	= (int)(divresult.quot + 1); 	/* current logical sector   		1...65536			*/
	
	fsnkc_lldbgwait("...nkcfs_seek\n");
		
	if(res < FRESULT_OFFSET && res != RES_OK)
	  return res + DRESULT_OFFSET;
	else return res;
}
		    	

  
static int  nkcfs_remove(struct _file *filp)
{
	int cjddrive,jddrive;
	char *pfilename,*pc1,*pc2;
	struct ioctl_nkc_blk args;
	//{
	//  unsigned long arg1;		// arguments
	//  unsigned long arg2;	        // fsnkc_lldbgwait("nkcfs_remove...\n");
	//  unsigned long arg3;
	//  // remove path information from filename...
	//};
	pc1 = filp->pname;
	pc2 = pfilename = (char*)malloc(strlen(pc1));
	*pc2=0;
	if(!pfilename){
	  printf(" error, out of memory (nkcfs_remove)\n");
	  return 1;
	}
	while(*pc1){
	  if(*pc1 != '/'){*pc2++ = toupper(*pc1);}
	  pc1++;	  
	}
	*pc2=0;
#ifdef USE_JADOS
	jd_remove(pfilename); 
#else
	//args.arg1 = filp->private->pfi->pfcb:
	//args.arg2 = pfilename;
	//call_blk_ioctl(pfi->pfcb, NKC_IOCTL_REMOVE, &args); 
#endif	
	free(pfilename);
	
	return FR_OK;
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
#ifdef USE_JADOS
	jd_rename(oldrelpath,newrelpath);
#else
	//UINT call_blk_ioctl(pfi->pfcb, NKC_IOCTL_REMOVE, arg) 
#endif	
	return FR_DENIED;
}


void nkcfs_init_fs(void)
{
	fsnkc_dbg("nkcfs_init_fs...\n"); 
	
	current_jados_drive = _DRIVE;
			
	register_driver("JADOSFS",&nkc_file_operations); 	// general driver for a JADOS filesystem
	
	
	fsnkc_dbg(" Address of open: 0x%x\n",(int)nkcfs_open);
	fsnkc_dbg(" Address of nkc_file_operations: 0x%x\n",(int)&nkc_file_operations);
	fsnkc_dbg(" Address of ...->open: 0x%x\n",(int)nkc_file_operations.open);
	fsnkc_lldbgwait("...nkcfs_init_fs\n");
}
