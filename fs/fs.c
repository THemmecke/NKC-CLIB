    
/****************************************************************************
 * Included Files
 ****************************************************************************/
 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <ioctl.h>
#include <debug.h>

#include "fs.h"

#ifdef CONFIG_FS_NKC
#include "nkc/fs_nkc.h"
#endif

#define NUM_FILE_HANDLES 255
#define NUM_OPENFILES 255

#define DRIVE_NAME_LENGTH 5
#define PATH_NAME_LENGTH 255

static struct _file *filelist[NUM_OPENFILES]; 			/* list of open files */

static unsigned char HPOOL[NUM_FILE_HANDLES];		/* handle pool, handles 0...9 are reserved !! */

static struct driver *driverlist = NULL;	/* pointer to file system driver */

static char	cdrive[DRIVE_NAME_LENGTH];	// current drive name, i.e. where the program was started ; A:,B:, HDA1: etc
static char 	cpath[PATH_NAME_LENGTH];	// current path name; for jados this is empty or '/'



/****************************************************************************
 * Private Functions
 ****************************************************************************/

 
int alloc_handle(void)
{
	int h;
	
	fs_lldbg("fs.c: [ alloc handle...\n");
	
	for(h=10; h<255; h++)
	{
		if( HPOOL[h] == 0)
		{
			HPOOL[h] = 0xff;
			fs_lldbg("fs.c: ...alloc_handle(1) ]\n");
			return h;
		}
		
	}
	
	fs_lldbg("fs.c: ...alloc_handle(2) ]\n");
}

void free_handle(int fd)
{	
	fs_lldbg("fs.c: free handle\n");
	HPOOL[fd] = 0;	
}


struct driver* get_driver(char *name)
/* name == LW, i.e A,B,C...Z, HDA1, HDA2, USB1 etc. */
{
	struct driver *pdriver;
	char drive_name[10],*p;
	int i;
	
	fs_lldbg("fs.c: [ get_driver..."); 
	fs_lldbgwait("\n"); 
	
	if(!name) 
	{ 	 
		/*
		 * no drive specified, use the current drive
		 */
		fs_lldbg("fs.c:  no drive specified(1), take cdrive ...\n"); 
		fs_lldbgwait("fs.c:  cdrive = ");
		strcpy(drive_name,cdrive);
	}else
	{	
		strcpy(drive_name,name); /* copy drive name */			
		//strcpy(cdrive,drive_name);  /* update current drive */		
	}
	
	i=0;
	while(drive_name[i]){ drive_name[i] = toupper(drive_name[i]); i++;}
	
	fs_dbg("fs.c: drive_name = %s",drive_name);
	fs_lldbgwait("\n");
	
	
	// initialize pdriver with driver list
	pdriver = driverlist;
	
	fs_lldbgwait("fs.c: searching for driver in driverlist\n");
	
	while(pdriver)
	{	
		fs_dbg("fs.c:  next in list = %s",pdriver->pdrive);
		fs_lldbgwait("\n");
		
		if(!strcmp(drive_name,pdriver->pdrive) )
		{
			fs_dbg("fs.c:  name:  %s\n",pdriver->pname);
			fs_dbg("fs.c:  drive: %s\n",pdriver->pdrive);
			fs_dbg("fs.c:  foper: 0x%x\n",pdriver->f_oper);
			fs_dbg("fs.c:  open: 0x%x\n",pdriver->f_oper->open);
			fs_lldbgwait("fs.c: ....get_driver(SUCCESS) ]\n");
			return pdriver;
		}
		pdriver = pdriver->next;
	}
	
	fs_lldbgwait("fs.c: ....get_driver(FAIL) ]\n");
	return NULL; /* no driver found */
}


/****************************************************************************
 * Global Functions
 ****************************************************************************/

#define DRV_LENGTH   	10
#define PATH_LENGTH 	255
#define FILENAME_LENGTH 100
#define EXT_LENGTH 	10
#define FPATH_LENGTH 	255
#define FULLNAME_LENGTH 255
#define FULLPATH_LENGTH 255

static char drive[DRV_LENGTH], path[PATH_LENGTH],filename[FILENAME_LENGTH], ext[EXT_LENGTH], filepath[FPATH_LENGTH], fullname[FULLNAME_LENGTH],fullpath[FULLPATH_LENGTH];

void split_filename(char *name, 		// IN:  D:/path/filename.ext
		    char* drive, 		// OUT: D,HDA0 etc.
		    char* path, 		// OUT: /dir/dir/
		    char* filename, 		// OUT: filename of filename.ext
		    char* ext, 			// OUT: ext of filename.ext
		    char* fullname, 		// OUT: filename.ext		    
		    char* filepath,		// OUT: /dir/dir/filename.ext
		    char* fullpath,		// OUT: C:/path/filename.ext
		    
		    char* dfdrv,		// IN: defaultdrive to use, if not specified in path
		    char* dfpath)		// IN: default path to use, if not specified in path
{
        char* p;
        char* pstr;
        unsigned int n;
	char tmp[255];
	
        drive[0] = 0;
        path[0] = 0;
        filename[0] = 0;
        ext[0] = 0;
	fullname[0] = 0;
	filepath[0] = 0;
	fullpath[0] = 0;
	
        pstr = name;

	// ======================== DRIVE ====================================================================
	// look if there is a drive information	
	p = strchr(pstr,':');        
        if(p){ // yes: copy drive
	  n=(unsigned int)(p-pstr); 
	  if(n){
	    strncpy(drive,pstr,n);
	    drive[n] = 0;        
	    pstr+=n+1;
	  }else{ // typo like ":/..." => use default drive
	    drive[0]=0;
	    strcpy(drive,dfdrv);	  
	    pstr++; // skip ':'	
	  }
        }else
	{ // no: use default drive
	  drive[0]=0;
	  strcpy(drive,dfdrv);	  
	}		
		
	n=0;			// use uppercase drive letters only
	while(drive[n]){
	  drive[n] = toupper(drive[n]); n++;
	}	
	// ======================== PATH ====================================================================	
	// look for the last occurence of a '/' delimiter
	p=strrchr(pstr,'/');        
        if(p){
	  n=(unsigned int)(p-pstr);
	  n++;
	  strncpy(path,pstr,n);
	  path[n]=0;       
	  pstr+=n;
        }          
          
        switch(path[0])
	{
	  case 0: // no path given, use current dir path if drive != dfdrv    
	    if(!strcmp(drive,dfdrv))
	      strcpy(path,dfpath);
	    break;
	  case '/': // absolute path given, use just this        
	    break;
	  default: // relative path given, prepend current path   if drive != dfdrv
	    if(!strcmp(drive,dfdrv)){
	      strcpy(tmp,path);
	      strcpy(path,dfpath);
	      if(path[strlen(path)-1] != '/') strcat(path,"/"); // make shure path ends with '/'
	      strcat(path,tmp);
	    }
	    break;
	}         
        
        if(path[strlen(path)-1] != '/') strcat(path,"/"); // make shure path ends with '/'
        
        if(*pstr == '.')  { // special file handling ('.' and '..')	  
	  strcat(path,"."); pstr++;	
	  if(*pstr == '.') {
	    strcat(path,"."); pstr++;
	  }
	  strcat(path,"/"); // terminate path
	}
        
        // ======================== FILENAME.EXT ====================================================================
	// store fullname (filename.ext), rest (if any) has to be a filename.ext
        strcpy(fullname,pstr);         
	
	 // store filepath (filepath = path + fullname)
	strcpy(filepath,path);	
	strcat(filepath,fullname);
	
	
        // look for filename delimiter and try to split filename and extension
	p=strchr(pstr,'.');
        if(p) { 
	  n=(unsigned int)(p-pstr);		  
	  strncpy(filename,pstr,n);
	  filename[n]=0;        
	  pstr+=n+1;		      
	  // rest has to be fileextension
	  strcpy(ext,pstr);  	  			
	}
	else{	  
	  strcpy(filename, pstr);
	}
	
	strcpy(fullpath,drive);
	strcat(fullpath,":");
	strcat(fullpath,filepath);
}

// initialize pdriver with driver list

void list_drivers(){
  
  struct driver *pdriver;
  
  pdriver = driverlist;
  
  printf(" registered drives/drivers:\n\n");
  
  while(pdriver)
  {		
      printf(" name:  %s  -- ",pdriver->pname);
      printf(" drive: %s\n",pdriver->pdrive);
      
      pdriver = pdriver->next;
  }
}
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
//static 
int ioctl(char *name, int cmd, unsigned long arg) // do ioctl on device "name"
{
  FRESULT res; 
  char tmp[255];
  char *pc;
  struct driver *pdriver;
  
  struct ioctl_get_cwd arg_get_cwd;  
  struct ioctl_opendir arg_opendir;
  struct ioctl_readdir arg_readdir;
  struct ioctl_getfree arg_getfree;
  

  fs_dbg("fs.c: [ ioctl ...\n"); 

  res = EINVFNC;
  
  switch(cmd) 
  {  
    case FS_IOCTL_GETDRV: // ************************************* get current drive *************************************
      fs_lldbgwait(" - FS_IOCTL_GETDRV - \n");
      strcpy((char*)arg,cdrive);
      res = FR_OK;
      break;
      
    case FS_IOCTL_CHDRIVE: // ************************************* change current drive *************************************
      fs_lldbgwait(" - FS_IOCTL_CHDRIVE - \n");
      if (!arg){ res = ENODEV; break; }      
      pdriver = get_driver((char*)arg); // check if there is a driver registered with that name....      
      if(!pdriver){ res = EINVDRV; break;  }
      
      if(pdriver->f_oper->ioctl){	
	fs_lldbg(" calling drivers ioctl...\n");
	res = pdriver->f_oper->ioctl(name,cmd,arg);	// is ioctl valid ? -> call it
	fs_dbg(" res = %d\n",res);
	
	// get dir/drive ...
	fs_lldbg(" updating current drive/path information\n");
	arg_get_cwd.cpath = &cpath;
	arg_get_cwd.cdrv = &cdrive;
	arg_get_cwd.size = PATH_NAME_LENGTH;
	res = pdriver->f_oper->ioctl(name,FS_IOCTL_GETCWD,&arg_get_cwd);		
	fs_dbg(" res = %d\n",res);
      }else{
	fs_lldbgwait(" ioctl not valid !\n");
      }      
      
      break;
    case FS_IOCTL_CD: // ************************************* change directory *************************************
      fs_dbg(" - FS_IOCTL_CD - (%s)",(char*)arg);
      fs_lldbgwait("\n");
      if (!arg){ res = ENODEV;	break;  }    				// we need some args ...
      
      split_filename((char*)arg, drive, path, filename, ext,fullname, filepath, fullpath, cdrive, cpath); // analyze filename
      
      if(drive[0]){ 					// is there any drive information in the path ?
	pdriver = get_driver(drive); 			// try fetching the driver
      }else{	
	pdriver = get_driver(cdrive); 			// try current drive
	strcpy(drive,cdrive);
      }            
	
      
      fs_dbg(" using drive %s ; path %s\n",drive,filepath);
      
      if(!pdriver){ 
	fs_dbg(" no driver found for %s - giving up\n",drive);
	res = EINVDRV; break;  }		// if no driver, exit...
      
       if(pdriver->f_oper->ioctl){
	fs_lldbg(" calling drivers ioctl...\n"); 
	res = pdriver->f_oper->ioctl(name,cmd,arg);	// is ioctl valid ? -> call it
	fs_dbg(" res = %d\n",res);
	
	// get dir/drive ...
	fs_lldbg(" updating current drive/path information\n");
	arg_get_cwd.cpath = &cpath;
	arg_get_cwd.cdrv = &cdrive;
	arg_get_cwd.size = PATH_NAME_LENGTH;
	res = pdriver->f_oper->ioctl(name,FS_IOCTL_GETCWD,&arg_get_cwd);
	fs_dbg(" res = %d\n",res);
      }else{
	fs_lldbgwait(" ioctl not valid !\n");
      }     
          
      break;        
    case FS_IOCTL_GETCWD: // ************************************* get currennt working directory and path: arg = pointer to struct ioctl_get_cwd arg
      fs_lldbgwait(" - FS_IOCTL_GETCWD - \n");
      
      pdriver = get_driver(cdrive); 			// try current drive
      if(!pdriver){ 
	fs_dbg(" no driver found for current drive (%s) - giving up\n",cdrive);
	res = EINVDRV; break;  }		// if no driver, exit...
	
      // get dir/drive ...
      fs_lldbg(" updating current drive/path information\n");
      arg_get_cwd.cpath = &cpath;
      arg_get_cwd.cdrv = &cdrive;
      arg_get_cwd.size = PATH_NAME_LENGTH;
      res = pdriver->f_oper->ioctl(name,FS_IOCTL_GETCWD,&arg_get_cwd);
      fs_dbg(" res = %d\n",res);
	
      strcpy((char*)((struct ioctl_get_cwd*)(arg))->cdrv,cdrive);
      strcpy((char*)((struct ioctl_get_cwd*)(arg))->cpath,cpath);
      res = FR_OK;
      break;
      
    case FS_IOCTL_CHMOD: // ************************************* change file mode *************************************
       
      fs_lldbgwait(" - FS_IOCTL_CHMOD - \n");
      if (!arg){ res = ENODEV;	break;  }    				// we need some args ... 
          
      if(!drive[0]){ // there is no drive in the path name argument
	if(!name) { // there is no drive name given in the name argument
	  pdriver = get_driver(cdrive); 		// try current drive (3)
	}else{
	  pdriver = get_driver(name); 			// try given name (2)
	}
      }else{
	pdriver = get_driver(drive); 			// try extracted drive (1)
      }
	               
      if(!pdriver){ res = EINVDRV; break;  }		// if no driver, exit...
      
       if(pdriver->f_oper->ioctl){	
	res = pdriver->f_oper->ioctl(name,cmd,arg);	// is ioctl valid ? -> call it
      }else{
	fs_lldbgwait(" ioctl not valid !\n");
      }            
      break;
      
    
    case FS_IOCTL_OPEN_DIR: // ************************************* open dir *************************************
      fs_lldbgwait(" - FS_IOCTL_OPEN_DIR - \n");
      if (!arg){ res = ENODEV;	break;  }    				// we need some args ... 
      
      //look for drive: 1) in arg.fpath 2) in *name 3) take CurrDrive
      split_filename((char*)((struct ioctl_opendir *)arg)->path, drive, path, filename, ext, fullname, filepath, fullpath, cdrive, cpath); // analyze filename      
      if(!drive[0]){ // there is no drive in the path name argument
	if(!name) { // there is no drive name given in the name argument
	  pdriver = get_driver(cdrive); 		// try current drive (3)
	}else{
	  pdriver = get_driver(name); 			// try given name (2)
	}
      }else{
	pdriver = get_driver(drive); 			// try extracted drive (1)
      }
	               
      if(!pdriver){ res = EINVDRV; break;  }		// if no driver, exit...
      
       if(pdriver->f_oper->ioctl){	
	res = pdriver->f_oper->ioctl(name,cmd,arg);	// is ioctl valid ? -> call it
      }else{
	fs_lldbgwait(" ioctl not valid !\n");
      }            
      break;  
    case FS_IOCTL_READ_DIR: // ************************************* read dir *************************************
      fs_lldbgwait(" - FS_IOCTL_READ_DIR - \n");
      //parg_readdir = (struct ioctl_readdir*)arg;
      break;
    case FS_IOCTL_CLOSE_DIR: // ************************************* close dir *************************************      
      fs_lldbgwait(" - FS_IOCTL_CLOSE_DIR - \n");
      break;  
    case FS_IOCTL_GET_FREE:
      fs_lldbgwait(" - FS_IOCTL_GET_FREE - \n");
      //parg_getfree = (struct ioctl_getfree*)arg;
      break;
    case NKC_IOCTL_DIR: // ****************************** JADOS directory function call  ******************************
      
      pdriver = get_driver(name); 		
      
      if(!pdriver){ res = EINVDRV; break;  }		// if no driver, exit...
      
       if(pdriver->f_oper->ioctl){	
	res = pdriver->f_oper->ioctl(name,cmd,arg);	// is ioctl valid ? -> call it
      }else{
	fs_lldbgwait(" ioctl not valid !\n");
      }            
      
      break;
      
    // ========================== FAT ===========================
      
          
      
    default:	
      fs_dbg("fs-ioctl default...");
      pdriver = NULL;
      if(name == NULL && cmd > 100){ // unspecified FAT_IOCTL
	  fs_lldbgwait("error, unspecified FAT_IOCTL...");
	  return FR_INVALID_PARAMETER;	  	 	
      }	else {
	fs_lldbgwait("look for named driver via get_driver...\n");
	if(name == NULL) return FR_INVALID_PARAMETER;      
	pdriver = get_driver(name);  		// is any driver registered for a device with this name ?	
      }
      
      if(pdriver == NULL) return FR_NO_DRIVER;      
      fs_dbg(" found,calling drivers ioctl at 0x%0lx  (KEY)",pdriver->f_oper->ioctl);
      fs_lldbgwait("\n");
      if(pdriver->f_oper->ioctl){
	
	res = pdriver->f_oper->ioctl(name,cmd,arg);	// is ioctl valid ? -> call it
      }else{
	fs_lldbgwait(" ioctl not valid !\n");
      }
  }
  
  
  return res;
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
	
	
	fs_lldbg("fs.c: [ register_driver...\n");
	fs_dbg(" name:  %s",pname);
	fs_dbg(" drive: %s",pdrive);
	fs_dbg(" foper: 0x%x\n",f_oper);
	fs_dbg(" open: 0x%x\n",f_oper->open);
	
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
	
	fs_dbg(" name:  %s\n",pdriver->pname);
	fs_dbg(" drive: %s\n",pdriver->pdrive);
	fs_dbg(" foper: 0x%x\n",pdriver->f_oper);
	fs_dbg(" open: 0x%x",pdriver->f_oper->open);
	fs_lldbgwait("....register_driver ]\n");
	
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
  
	fs_lldbgwait("fs.c: [ _ll_init_fs...\n");
	
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
  	
 	fs_dbg("fs.c:  cdrive = %s",cdrive); 
	fs_lldbgwait("\n");	
	
 	#ifdef CONFIG_FS_NKC
 	// initialize NKC/JADOS FileSystem
 	nkcfs_init_fs();
 	#endif 
 	 
  	#ifdef CONFIG_FS_FAT
 	// initialize FAT FileSystem
 	fatfs_init_fs();
 	#endif 

	fs_lldbgwait("fs.c: ..._ll_init_fs ]\n");
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
  flags = 0(read), 1(write), 2(read/write) - (translated by _ll_flags)
        + _F_CREATE (0x0800) if called through _ll_creat
 *************************************************************************/            
{
  
  
  
	struct _file *pfile,*pcf,*plf;	
	struct driver *pdriver;	
   	int fd,res,i;
	char* pname;
   	UINT indx = NUM_FILE_HANDLES;
   	
	fs_dbg("_ll_open: name=%s, flags=0x%x",name,flags); fs_lldbgwait("\n");
	
	/*
		initialize string variables
	*/	
	
	split_filename(name, drive, path, filename, ext, fullname, filepath, fullpath, cdrive, cpath); // analyze filename		   
    
	fs_dbg("_ll_open:  name = %s\n",name);
	fs_dbg("_ll_open:  path = %s\n",path);
	fs_dbg("_ll_open:  filename = %s\n",filename);
	fs_dbg("_ll_open:  ext = %s\n",ext);
	fs_dbg("_ll_open:  fpath = %s\n",filepath);				
	fs_dbg("_ll_open:  drive is: %s\n",drive);
	fs_dbg("_ll_open:  fullname= %s\n",fullname);
	fs_dbg("_ll_open:  filepath= %s\n",filepath);
	fs_dbg("_ll_open:  fullpath= %s",fullpath);
	fs_lldbgwait("\n");	

	
   	/*
   		get driver for this drive (search for the drive used..)
   	*/
	
	
   	pdriver = get_driver(drive);
   	
   	if(pdriver == NULL) 
   	{
   		fs_lldbgwait("_ll_open:  no driver found !\n fs.c: ...._ll_open ]\n");   	
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
	   	    	    
		if( !strcmp(pfile->pname,fullpath) )
		{
			if(flags & _F_CREATE)
	    	{	
	    		fs_dbg("_ll_open:  cannot create already open file...\n");
	    		fs_dbg("pfile->pname= %s\n",pfile->pname);
	    		fs_dbg("fullpath= %s",fullpath);
	    		fs_lldbgwait("\n");	    		
	    		return 0;
	    	} 
		
			/* this file is already open, we can open it read only */
			flags &= ~_F_WRIT;
			flags |=  _F_READ;
			fs_lldbgwait("_ll_open: file is already open -> set WRONLY\n");
		}		
	   } 
	}
	
	
   	
			
	/*
		Try to allocate file hanlde
	*/		
   	fd = alloc_handle();
   	
   	if(fd == 255) /* no more free handle ! */
	{	
		nkc_write("_ll_open:  no more free file handles in _ll_open\n");
		free_handle(fd);		
		return 0;
	}
	
	/*
		allocate all buffers
	*/
	pfile = (struct _file *)malloc(sizeof(struct _file));
	pname = (char*)malloc(strlen(fullpath)+1);
	
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

	
	fs_dbg("_ll_open:  foper: 0x%x\n",pfile->f_oper);
	fs_dbg("_ll_open:  open: 0x%x\n",pfile->f_oper->open);
	fs_lldbgwait("_ll_open: call pfile->f_oper->open ...\n");
	
	res = pfile->f_oper->open(pfile);
	
	fs_dbg("_ll_open:  pfile->f_oper->open(pfile) returned %d\n",res);
	
	if(res != EZERO)
	{
		free(pfile);
		free(pname);
		free_handle(fd);
		return 0;
	}

	
	filelist[fd] = pfile;
	
	fs_lldbgwait("fs.c: ..._ll_open ]\n");
	
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
  
  fs_dbg("fs.c: _ll_creat...\n");
  //                               0x0800
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
   	
	fs_lldbgwait("fs.c: [ _ll_close....\n");
	
   	pfile = filelist[fd];
   	if(!pfile) return;
   	
	fs_lldbg("fs.c: call pfile->f_oper->close\n");
	
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
	
	fs_lldbg("fs.c: .... _ll_close ]\n");
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
   	
	fs_lldbgwait("fs.c: [ _ll_read....\n");
	
   	if(fd<10) return; // besser wäre es, die stdio's auch in die filelist aufzunehmen ...
   					  // das wird z.Z. in llstd.S abgehandelt, die Routinen könnte man wie jedes andere FS einhängen
   	
   	
   	pfile = filelist[fd];
   	if(!pfile) return ENOFILE;
   	
   	res = pfile->f_oper->read(pfile,buf,size);

	fs_lldbgwait("fs.c: ... _ll_read ]\n");
	
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
   	
	fs_lldbgwait("fs.c: [ _ll_write...\n");
	
   	pfile = filelist[fd];
   	if(!pfile) return ENOFILE;
   	
   	res = pfile->f_oper->write(pfile,buf,size);

	fs_lldbgwait("fs.c: ... _ll_write ]\n");
	
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
  return flags;
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
	   	
	fs_lldbgwait("fs.c: [ _ll_seek...\n");
   	
   	pfile = filelist[fd];
   	if(!pfile) return;
   		
   	res = pfile->f_oper->seek(pfile,pos,origin);
	
	fs_lldbgwait("fs.c: ... _ll_seek ]\n");
	
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


