    
/****************************************************************************
 * Included Files
 ****************************************************************************/
 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <ioctl.h>

#include "fs.h"

#ifdef CONFIG_FS_NKC
#include "nkc/fs_nkc.h"
#endif

#ifdef DEBUG_FS
#include "../nkc/llnkc.h"
#endif

#define NUM_FILE_HANDLES 255
#define NUM_OPENFILES 255

#define DRIVE_NAME_LENGTH 5
#define PATH_NAME_LENGTH 255

static struct _file *filelist[NUM_OPENFILES]; 			/* list of files files */

static unsigned char HPOOL[NUM_FILE_HANDLES];		/* handle pool, handles 0...9 are reserved !! */

static struct driver *driverlist = NULL;						/* pointer to file system driver */

char	cdrive[DRIVE_NAME_LENGTH];	// current drive name, i.e. where the program was started ; A:,B:, HDA1: etc
char 	cpath[PATH_NAME_LENGTH];	// current path name; for jados this is empty or '/'


/****************************************************************************
 * Private Functions
 ****************************************************************************/
 
void split_filename(char *name, char* drive, char* path, char* filename, char* ext)
{
        char* p;
        char* pstr;
        int n;

		
        drive[0] = 0;
        path[0] = 0;
        filename[0] = 0;
        ext[0] = 0;
        

        pstr = name;

        n= strchr(pstr,':') - pstr;
        if(n>0){
        strncpy(drive,pstr,n);
        drive[n] = 0;        
        pstr+=n+1;
        }

        n=strrchr(pstr,'/') - pstr;
        if(n>=0){
        n++;
        strncpy(path,pstr,n);
        path[n]=0;       
        pstr+=n;
        }

        n=strchr(pstr,'.') - pstr;
        if(n>0) {
        strncpy(filename,pstr,n);
        filename[n]=0;        
        pstr+=n+1;
        }

        strncpy(ext,pstr,strlen(pstr));
        ext[strlen(pstr)]=0;        

}

 
int alloc_handle(void)
{
	int h;
	
	#ifdef CONFIG_DEBUG_FS
	nkc_write("fs.c: [ alloc handle...\n");
	#endif
	
	for(h=10; h<255; h++)
	{
		if( HPOOL[h] == 0)
		{
			HPOOL[h] = 0xff;
			#ifdef CONFIG_DEBUG_FS
			nkc_write("fs.c: ...alloc_handle(1) ]\n");
			#endif
			return h;
		}
		
	}
	
	#ifdef CONFIG_DEBUG_FS
	nkc_write("fs.c: ...alloc_handle(2) ]\n");
	#endif
}

void free_handle(int fd)
{	
	#ifdef CONFIG_DEBUG_FS
	nkc_write("fs.c: free handle\n");
	#endif
	HPOOL[fd] = 0;	
}



struct driver* get_driver(char *name)
/* name == LW, i.e A,B,C...Z, HDA1, HDA2, USB1 etc. */
{
	struct driver *pdriver;
	char drive_name[10],*p;
	
	#ifdef CONFIG_DEBUG_FS
	nkc_write("fs.c: [ get_driver...\n"); 
	nkc_write("fs.c:  for "); nkc_write(name); nkc_write("\n");
	nkc_getchar();
	#endif
	
	if(!name) 
	{ 	 
		/*
		 * no drive specified, use the current drive
		 */
		#ifdef CONFIG_DEBUG_FS
		nkc_write("fs.c:  no drive specified(1), take cdrive ...\n"); 
		nkc_write("fs.c:  cdrive = "); nkc_write(cdrive); nkc_write("\n"); nkc_getchar();
		#endif 
		strcpy(drive_name,cdrive);									
	}else
	{	
		strcpy(drive_name,name); /* copy drive name */			
		strcpy(cdrive,drive_name);  /* update current drive */		
	}
	
	#ifdef CONFIG_DEBUG_FS
	nkc_write("fs.c: drive_name = "); nkc_write(drive_name); nkc_getchar(); nkc_write("\n");
	#endif
	
	
	// initialize pdriver with driver list
	pdriver = driverlist;
	
	#ifdef CONFIG_DEBUG_FS
	nkc_write("fs.c: searching for driver in driverlist\n");nkc_getchar();
	#endif
	while(pdriver)
	{
		#ifdef CONFIG_DEBUG_FS
		nkc_write("fs.c:  next in list = "); nkc_write(pdriver->pdrive); nkc_getchar(); nkc_write("\n");
		#endif
		
		if(!strcmp(drive_name,pdriver->pdrive) )
		{
			#ifdef CONFIG_DEBUG_FS
			nkc_write("fs.c:  name:  "); nkc_write(pdriver->pname); nkc_write("\n");
			nkc_write("fs.c:  drive: "); nkc_write(pdriver->pdrive); nkc_write("\n");
			nkc_write("fs.c:  foper: 0x"); nkc_write_hex8((int)pdriver->f_oper); nkc_write("\n");
			nkc_write("fs.c:  open: 0x"); nkc_write_hex8((int)pdriver->f_oper->open); nkc_write("\n");
			nkc_write("fs.c: ....get_driver(SUCCESS) ]\n"); nkc_getchar();
			#endif
			return pdriver;
		}
		pdriver = pdriver->next;
	}
	
	#ifdef CONFIG_DEBUG_FS
	nkc_write("fs.c: ....get_driver(FAIL) ]\n"); nkc_getchar();
	#endif
	return NULL; /* no driver found */
}


/****************************************************************************
 * Global Functions
 ****************************************************************************/



/****************************************************************************
 * Name: ioctrl
 *
 * Description:
 *   Do ioctrl on a device.
 *
 * Parameters:
 *   	name	- name of drive (A,B...,HDA1, HDA2....)
 *	cmd	- command as defined in ioctl.h
 *	arg	- command argument (a pointer)
 *
 * Return:
 *		EZERO - success   
 *
 ****************************************************************************/
static int ioctl(char *name, int cmd, unsigned long arg) // do ioctl on device "name"
{
  struct driver *pdriver;
  
  struct ioctl_get_cwd *parg_cwd;  
  struct ioctl_opendir *parg_opendir;
  struct ioctl_readdir *parg_readdir;
  struct ioctl_getfree *parg_getfree;
  
  #ifdef CONFIG_DEBUG_FS
  nkc_write("fs.c: [ ioctl ...\n"); 
  #endif
	
  
  
  switch(cmd) 
  {  
    case FS_IOCTL_GETCWD: // get currennt working directory and path: arg = pointer to struct ioctl_get_cwd arg
      parg_cwd = (struct ioctl_get_cwd*)arg;
      break;
    case FAT_IOCTL_CD: // can be any filesystem, so check which driver to call ...
      break;
    case FAT_IOCTL_OPEN_DIR: // can be any filesystem, so check which driver to call ...
      parg_opendir = (struct ioctl_opendir*)arg;
      break;  
    case FAT_IOCTL_READ_DIR: // can be any filesystem, so check which driver to call ...
      parg_readdir = (struct ioctl_readdir*)arg;
      break;
    case FAT_IOCTL_CLOSE_DIR: // can be any filesystem, so check which driver to call ...      
      break;  
    case FAT_IOCTL_GET_FREE:
      parg_getfree = (struct ioctl_getfree*)arg;
      break;
      
      
    default:		  			// leave it to the driver ...
      if(name == NULL) return 1;
      pdriver = get_driver(name);  		// is any driver registered for a device with this name ?
      if(pdriver == NULL) return 1;
      pdriver->f_oper->ioctl(NULL,cmd,arg);	// is ioctl valid ? -> call it
  }
  
  #ifdef CONFIG_DEBUG_FS
  nkc_write("fs.c: ... ioctl ]\n"); 
  #endif
  
  return 0;
}

/****************************************************************************
 * Name: register_driver
 *
 * Description:
 *   Register a file system.
 *
 * Parameters:
 *   	pdrive		- name of drive (A,B...,HDA1, HDA2....)
 *		pname		- name of filesystem (NKC,FAT32...)
 *		f_open		- pointer to file operations
 *
 * Return:
 *		EZERO - success   
 *
 ****************************************************************************/
int register_driver(char *pdrive, char *pname, const struct file_operations  *f_oper)
{
	struct driver *pdriver, *ptail;
	
	
	#ifdef CONFIG_DEBUG_FS
	nkc_write("fs.c: [ register_driver...\n");
	nkc_write(" name:  "); nkc_write(pname); nkc_write("\n");
	nkc_write(" drive: "); nkc_write(pdrive); nkc_write("\n");
	nkc_write(" foper: 0x"); nkc_write_hex8((int)f_oper); nkc_write("\n");
	nkc_write(" open: 0x"); nkc_write_hex8((int)f_oper->open); nkc_write("\n");
	#endif
	
	/*
		allocate all buffers
	*/		
	pdriver = (struct driver *)malloc(sizeof(struct driver));
	pdriver->pdrive = (char*)malloc(strlen(pdrive) + 1);
	pdriver->pname = (char*)malloc(strlen(pname) + 1);
	
	strcpy(pdriver->pdrive, pdrive);
	strcpy(pdriver->pname, pname);
	pdriver->f_oper = f_oper;
	pdriver->next = NULL;
			
		
	if(driverlist == NULL)
		driverlist = pdriver;
	else
	{
		ptail = driverlist;
		while(ptail->next) ptail = ptail->next;
		ptail->next = pdriver;
	}			
	
	#ifdef CONFIG_DEBUG_FS
	nkc_write(" name:  "); nkc_write(pdriver->pname); nkc_write("\n");
	nkc_write(" drive: "); nkc_write(pdriver->pdrive); nkc_write("\n");
	nkc_write(" foper: 0x"); nkc_write_hex8((int)pdriver->f_oper); nkc_write("\n");
	nkc_write(" open: 0x"); nkc_write_hex8((int)pdriver->f_oper->open); nkc_write("\n");
	nkc_write("....register_driver ]\n"); nkc_getchar();
	#endif
	
	return EZERO;
}


/****************************************************************************
 * Name: un_register_driver
 *
 * Description:
 *   Un-Register a file system.
 *
 * Parameters:
 *   	pdrive		- name of drive (A,B...,HDA1, HDA2....)
 *
 * Return:
 *		EZERO - success   
 *
 ****************************************************************************/
int un_register_driver(char *pdrive)
{
	struct driver *pcur, *plast;
			
	pcur = plast = driverlist;
	
	while(pcur)
	{
		if(!strcmp(pcur->pdrive,pdrive)) 		
		{ // found drive
			if(pcur = plast) 
				driverlist = NULL;
			else
			{
				plast->next = pcur->next;
			}	
			
			free(pcur->pname);
			free(pcur->pdrive);
			free(pcur);
			
			return EINVDRV; /* Invalid drive specified  */
		}
	}		
		
	return EZERO;	
}

/****************************************************************************
 * Name: _ll_init_fs
 *
 * Description:
 *   Initailize file systems.
 *
 * Parameters:
 *   
 *
 * Return:
 *   
 *
 ****************************************************************************/
void _ll_init_fs(void)  			// initialize filesystems (nkc/llopenc.c)
{
 	int ii;	
 
 	#ifdef CONFIG_DEBUG_FS
	nkc_write("fs.c: [ _ll_init_fs...\n"); nkc_getchar();
	#endif
	
 	for(ii=0; ii<NUM_FILE_HANDLES;ii++)
 	  HPOOL[ii] = 0;
 	  
  	for(ii=0; ii<NUM_OPENFILES;ii++)
 	  filelist[ii] = NULL;  
 	  
 	driverlist = NULL;
 	
 	  
 	/* for now we assume the program was started from a jados drive
 	 * and so the cdrive is a JADOS drive
 	 */
 	  
 	if(_DRIVE >= 0 && _DRIVE <= 4) /* is it a ramdisk(0) or floppy drive(1..4) ? */
		{
			cdrive[0] = _DRIVE + '0';			
		}
		
		if(_DRIVE >= 5 && _DRIVE <= 30) /* is it a hard disk drive (5..30) ? */
		{
			cdrive[0] = _DRIVE - 5 + 'A';
		}
				
				
	cdrive[1] = 0;	// current drive name, i.e. where the program was started : A,B, HDA1 etc
	cpath[0] = 0;	// current path name; for jados this is empty or '/'
 
 	#ifdef CONFIG_DEBUG_FS
 	nkc_write("fs.c:  cdrive = "); nkc_write(cdrive); nkc_write("\n"); nkc_getchar();
	#endif
	
 	#ifdef CONFIG_FS_NKC
 	// initialize NKC/JADOS FileSystem
 	nkcfs_init_fs();
 	#endif 
 	 
  	#ifdef CONFIG_FS_FAT
 	// initialize FAT FileSystem
 	fatfs_init_fs();
 	#endif 

	#ifdef CONFIG_DEBUG_FS
	nkc_write("fs.c: ..._ll_init_fs ]\n"); nkc_getchar();
	#endif
}


/****************************************************************************
 * Name: _ll_open
 *
 * Description:
 *   Open a file.
 *
 * Parameters:
 *   
 *
 * Return:
 *   filedescriptor or ZERO if no success
 *
 ****************************************************************************/
int _ll_open(char *name, int flags)             // open a file (nkc/llopenc.c) 
/*
 * open an existing file, return handle
  name = [LW:][path]filename.ext
  flags = 0(read), 1(write), 2(read/write) 
 *************************************************************************/            
{
  
  
  
	struct _file *pfile,*pcf,*plf;	
	struct driver *pdriver;
	char drive[5],path[255],filename[20], ext[10], fname[30], fullname[320], *pname;
   	int fd,res,i;
   	UINT indx = NUM_FILE_HANDLES;
   	
   	#ifdef CONFIG_DEBUG_FS
	nkc_write("fs.c: [ _ll_open...\n"); nkc_getchar();
	#endif
	
	/*
		initialize string variables
	*/
	drive[0] = 0; path[0] = 0; filename[0] = 0; ext[0] = 0; fname[0] = 0; fullname[0] = 0;
	
	split_filename(name, drive, path, filename, ext); // analyze filename
	
	strcat(fname,filename); // build filename of the form filename.ext
    strcat(fname,".");
    strcat(fname,ext);    
    
	#ifdef CONFIG_DEBUG_FS
	nkc_write("fs.c:  name = "); nkc_write(name); nkc_write("\n");
	nkc_write("fs.c:  path = "); nkc_write(path); nkc_write("\n");
	nkc_write("fs.c:  filename = "); nkc_write(filename); nkc_write("\n");
	nkc_write("fs.c:  ext = "); nkc_write(ext); nkc_write("\n");
	nkc_write("fs.c:  fname = "); nkc_write(fname); nkc_write("\n");
	nkc_getchar();
	#endif

	
	if( !strcmp(drive,cdrive) )
	{
		strcpy(cdrive,drive);  /* update current drive */
	}
	
	if( !strlen(drive) )
	{
		strcpy(drive,cdrive);  /* if no drive specified use global current drive */
	}
	
	
	strcat(fullname,drive); // build fullname of the form filename.ext
    strcat(fullname,":");
    strcat(fullname,path);
    strcat(fullname,filename);
    strcat(fullname,".");
    strcat(fullname,ext);


   	/*
   		get driver for this drive (search for the drive used..)
   	*/

	
	#ifdef CONFIG_DEBUG_FS
	nkc_write("fs.c: drive is: "); nkc_write(drive); nkc_write("\n");
	nkc_write("fs.c: fullname= "); nkc_write(fullname); nkc_write("\n"); 
	nkc_getchar();
	#endif
	
   	pdriver = get_driver(drive);
   	
   	if(pdriver == NULL) 
   	{
   		#ifdef CONFIG_DEBUG_FS
   		nkc_write("fs.c:  no driver found !\n fs.c: ...._ll_open ]\n"); nkc_getchar();
   		#endif
   		return 0; /* no driver registered */
   	}
   	
   	/*
   		check if file is already open
   	*/
	for(i = 0; i<NUM_FILE_HANDLES;i++)
	{
	   pfile = filelist[i];
	   
	   if(pfile)
	   {
	   	    	    
		if( !strcmp(pfile->pname,fullname) )
		{
			if(flags & _F_CREATE)
	    	{	
	    		#ifdef CONFIG_DEBUG_FS
	    		nkc_write("fs.c:  cannot create already open file...\n");
	    		nkc_write("pfile->pname= "); nkc_write(pfile->pname); nkc_write("\n");
	    		nkc_write("fullname= "); nkc_write(fullname); nkc_write(" ]\n");
	    		nkc_getchar();
	    		#endif
	    		return 0;
	    	} 
		
			/* this file is already open, we can open it read only */
			flags &= ~_F_WRIT;
			flags |=  _F_READ;
			#ifdef CONFIG_DEBUG_FS
			nkc_write("fs.c: file is already open -> set WRONLY\n"); nkc_getchar();
			#endif
		}		
	   } 
	}
	
	
   	
			
	/*
		Try to allocate file hanlde
	*/		
   	fd = alloc_handle();
   	
   	if(fd == 255) /* no more free handle ! */
	{	
		nkc_write("fs.c:  no more free file handles in _ll_open\n");
		free_handle(fd);		
		return 0;
	}
	
	/*
		allocate all buffers
	*/
	pfile = (struct _file *)malloc(sizeof(struct _file));
	pname = (char*)malloc(strlen(fullname)+1);
	
	if( !pfile || !pname)
	{
		nkc_write(" error malloc in _ll_open\n");
		free(pfile);
		free(pname);
		free_handle(fd);
		return 0;
	}
	
	/*
		fill _file structure ...
	*/
	
	if(	!strcpy(pname,fullname) )
	{
		nkc_write(" error strcpy in _ll_open\n");
		free(pfile);
		free(pname);
		free_handle(fd);
		return 0;
	}
	
	
	pfile->pname = pname;
	pfile->fd = fd;
	pfile->f_pos = 0;
	pfile->f_oflags = flags;
	
	/* hier fs abhängige file operations einhängen (laut Registrierung) */
	pfile->f_oper = pdriver->f_oper;

	
	#ifdef CONFIG_DEBUG_FS		
	nkc_write("fs.c:  foper: 0x"); nkc_write_hex8((int)pfile->f_oper); nkc_write("\n");
	nkc_write("fs.c:  open: 0x"); nkc_write_hex8((int)pfile->f_oper->open); nkc_write("\n");
	nkc_write("fs.c: call pfile->f_oper->open ...\n"); nkc_getchar();
	#endif
	res = pfile->f_oper->open(pfile);
	
	if(res != EZERO)
	{
		free(pfile);
		free(pname);
		free_handle(fd);
		return 0;
	}

	
	filelist[fd] = pfile;
		
	#ifdef CONFIG_DEBUG_FS
	nkc_write("fs.c: ..._ll_open ]\n"); nkc_getchar();
	#endif	
	
	return fd;	
}


/****************************************************************************
 * Name: _ll_creat
 *
 * Description:
 *   Create a new file.
 *
 * Parameters:
 *  name 	= pointer to file with driver and path information
 *	flags 	= file open flags 
 *
 * Return:
 *   filedescriptor or ZERO if no success
 *
 ****************************************************************************/

int _ll_creat(char *name, int flags)		// create a file (nkc/llopenc.c)
{
  
 return  _ll_open(name, flags | _F_CREATE);
			
}



/****************************************************************************
 * Name: _ll_close
 *
 * Description:
 *   Close a file.
 *
 * Parameters:
 *   
 *
 * Return:
 *   
 *
 ****************************************************************************/
void _ll_close(int fd)				// close a file (nkc/llopenc.c)
{
	struct _file *pfile;	
	char *pname;
   	int res;
   	UINT indx = NUM_FILE_HANDLES;
   	
   	#ifdef CONFIG_DEBUG_FS
	nkc_write("fs.c: [ _ll_close....\n"); nkc_getchar();
	#endif	
	
   	pfile = filelist[fd];
   	if(!pfile) return;
   	
	#ifdef CONFIG_DEBUG_FS
	nkc_write("fs.c: call pfile->f_oper->close\n");
	#endif	
	
	res = pfile->f_oper->close(pfile);
	
	if(res != EZERO)
	{
		nkc_write("fs.c:  error f_ops-close() in _ll_lose\n");
	}
   	
   	pname = pfile->pname;
   	   	
   	free(pfile);
   	free(pname);
   	filelist[fd] = NULL;
   	free_handle(fd);
	
	#ifdef CONFIG_DEBUG_FS
	nkc_write("fs.c: .... _ll_close ]\n"); nkc_getchar();
	#endif	
}


/****************************************************************************
 * Name: _ll_read
 *
 * Description:
 *   Read size bytes from file to buffer.
 *
 * Parameters:
 *   
 *
 * Return:
 *   
 *
 ****************************************************************************/
int __ll_read(int fd, void *buf, int size)	// (nkc/llstd.S)
// in llstd.S wird _ll_read augerufen, von da __ll_read falls filesystem involviert
{
	struct _file *pfile;	
   	int res;
   	
	#ifdef CONFIG_DEBUG_FS
	nkc_write("fs.c: [ _ll_read....\n"); nkc_getchar();
	#endif	
	
   	if(fd<10) return; // besser wäre es, die stdio's auch in die filelist aufzunehmen ...
   					  // das wird z.Z. in llstd.S abgehandelt, die Routinen könnte man wie jedes andere FS einhängen
   	
   	
   	pfile = filelist[fd];
   	if(!pfile) return ENOFILE;
   	
   	res = pfile->f_oper->read(pfile,buf,size);

	#ifdef CONFIG_DEBUG_FS
	nkc_write("fs.c: ... _ll_read ]\n"); nkc_getchar();
	#endif
	
	return res;	
}

/****************************************************************************
 * Name: _ll_write
 *
 * Description:
 *   Write size bytes from buffer to file.
 *
 * Parameters:
 *   
 *
 * Return:
 *   
 *
 ****************************************************************************/
int __ll_write(int fd, void *buf, int size)     // (nkc/llstd.S)
// in llstd.S wird _ll_write augerufen, von da __ll_write falls filesystem involviert
{
	struct _file *pfile;	
   	int res;
   	
	#ifdef CONFIG_DEBUG_FS
	nkc_write("fs.c: [ _ll_write...\n"); nkc_getchar();
	#endif
   	
   	pfile = filelist[fd];
   	if(!pfile) return ENOFILE;
   	
   	res = pfile->f_oper->write(pfile,buf,size);

	#ifdef CONFIG_DEBUG_FS
	nkc_write("fs.c: ... _ll_write ]\n"); nkc_getchar();
	#endif
	
	return res;	
}

/****************************************************************************
 * Name: _ll_flags
 *
 * Description:
 *   Return file flags.
 *
 * Parameters:
 *   
 *
 * Return:
 *   
 *
 ****************************************************************************/
int _ll_flags(int flags)			// (nkc/llopen.S)
{
	// do nothing with the flags
}

/****************************************************************************
 * Name: _ll_seek
 *
 * Description:
 *   Seek file position.
 *
 * Parameters:
 *  origin:
 * #define SEEK_CUR    1 - seek from current position
 * #define SEEK_END    2 - seek from end of file
 * #define SEEK_SET    0 - seek from start of file
 *   
 *
 * Return:
 *   
 *
 ****************************************************************************/
void _ll_seek(int fd, int pos, int origin)	// seek to pos (nkc/llopenc.c)
{
	struct _file *pfile;	
   	int res;
	   	
	#ifdef CONFIG_DEBUG_FS
	nkc_write("fs.c: [ _ll_seek...\n"); nkc_getchar();
	#endif
   	
   	pfile = filelist[fd];
   	if(!pfile) return;
   		
   	res = pfile->f_oper->seek(pfile,pos,origin);
	
	#ifdef CONFIG_DEBUG_FS
	nkc_write("fs.c: ... _ll_seek ]\n"); nkc_getchar();
	#endif
	
}

/****************************************************************************
 * Name: _ll_getpos
 *
 * Description:
 *   Get file position.
 *
 * Parameters:
 *   
 *
 * Return:
 *   
 *
 ****************************************************************************/
int _ll_getpos(int fd)				// get current fileposition (nkc/llopenc.c)
{
	struct _file *pfile;	
   	int res;
   	
   	
   	pfile = filelist[fd];
   	if(!pfile) return ENOFILE;
   	
   	res = pfile->f_oper->getpos(pfile);

	return res;	
}

  /****************************************************************************
 * Name: _ll_rename
 *
 * Description:
 *   Rename a file.
 *
 * Parameters:
 *   
 *
 * Return:
 *   
 *
 ****************************************************************************/
int _ll_rename(char *old , char *new)		// (nkc/llstd.S)  
// _ll_rename in llstd.S ist die JADOS Version....
{
	struct _file *pfile;	
	struct driver *pdriver;
   	int fd,res,i;
   	char *pname;
   	   	
	/*
   		check if file is already open
   	*/
	for(i = 0; i<NUM_FILE_HANDLES;i++)
	{
	   pfile = filelist[i];
	   
	   if(pfile)
	   {
		if( !strcmp(pfile->pname,old) )
		{ /* this file is already open, close it before renaming it ! */
			return EACCES; /* Permission denied        */
		}		
	   } 
	}
 	/*
   		get driver for this drive
   	*/
   	pdriver = get_driver(old);
   	
   	if(pdriver = NULL) return ENODRV; /* no driver registered */
			
	/*
		Try to allocate file hanlde
	*/		
   	fd = alloc_handle();
   	
   	if(fd == 255) /* no more free handle ! */
	{	
		nkc_write(" no more free file handles in _ll_rename\n");
		free_handle(fd);		
		return EMFILE;
	}
	
	/*
		allocate all buffers
	*/
	pfile = (struct _file *)malloc(sizeof(struct _file));
	pname = (char*)malloc(strlen(old)+1);
	
	if( !pfile || !pname)
	{
		nkc_write(" error malloc in _ll_rename\n");
		free(pfile);
		free(pname);
		free_handle(fd);
		return ENOMEM;
	}
	
	/*
		fill _file structure ...
	*/
	
	if(	!strcpy(pname,old) )
	{
		nkc_write(" error strcpy in _ll_rename\n");
		free(pfile);
		free(pname);
		free_handle(fd);
		return ERROR;
	}
	
	
	pfile->pname = pname;
	pfile->fd = fd;
	pfile->f_pos = 0;
	pfile->f_oflags = 0;
	
	/* hier fs abhängige file operations einhängen (laut Registrierung) */
	pfile->f_oper = pdriver->f_oper;
	
	res = pfile->f_oper->rename(pfile,old,new);
	
	if(res != EZERO)
	{
		nkc_write(" error renaming file\n");
	}

	
	free(pname);
	free(pfile);
	free_handle(fd);
		
	return res;	
}

/****************************************************************************
 * Name: _ll_remove
 *
 * Description:
 *   Remove a file.
 *
 * Parameters:
 *   
 *
 * Return:
 *   
 *
 ****************************************************************************/
int _ll_remove(char *name)			// (nkc/llstd.S)
// _ll_rename in llstd.S ist die JADOS Version....
{
	struct _file *pfile;	
	struct driver *pdriver;
   	int fd,res,i;
   	char *pname;
   	   	
	/*
   		check if file is already open
   	*/
	for(i = 0; i<NUM_FILE_HANDLES;i++)
	{
	   pfile = filelist[i];
	   
	   if(pfile)
	   {
		if( !strcmp(pfile->pname,name) )
		{ /* this file is already open, close it before renaming it ! */
			return EACCES; /* Permission denied        */
		}		
	   } 
	}
 	/*
   		get driver for this drive
   	*/
   	pdriver = get_driver(name);
   	
   	if(pdriver = NULL) return ENODRV; /* no driver registered */
			
	/*
		Try to allocate file hanlde
	*/		
   	fd = alloc_handle();
   	
   	if(fd == 255) /* no more free handle ! */
	{	
		nkc_write(" no more free file handles in _ll_rename\n");
		free_handle(fd);		
		return EMFILE;
	}
	
	/*
		allocate all buffers
	*/
	pfile = (struct _file *)malloc(sizeof(struct _file));
	pname = (char*)malloc(strlen(name)+1);
	
	if( !pfile || !pname)
	{
		nkc_write(" error malloc in _ll_rename\n");
		free(pfile);
		free(pname);
		free_handle(fd);
		return ENOMEM;
	}
	
	/*
		fill _file structure ...
	*/
	
	if(	!strcpy(pname,name) )
	{
		nkc_write(" error strcpy in _ll_rename\n");
		free(pfile);
		free(pname);
		free_handle(fd);
		return ERROR;
	}
	
	
	pfile->pname = pname;
	pfile->fd = fd;
	pfile->f_pos = 0;
	pfile->f_oflags = 0;
	
	/* hier fs abhängige file operations einhängen (laut Registrierung) */
	pfile->f_oper = pdriver->f_oper;
	
	res = pfile->f_oper->remove(pfile);
	
	if(res != EZERO)
	{
		nkc_write(" error renaming file\n");
	}

	
	free(pname);
	free(pfile);
	free_handle(fd);
		
	return res;	
}


