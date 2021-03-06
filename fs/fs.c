    
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


#define NUM_FILE_HANDLES 255
#define NUM_OPENFILES 255


/* Character code support macros */	
#define IsUpper(c)	(((c)>='A')&&((c)<='Z'))
#define IsLower(c)	(((c)>='a')&&((c)<='z'))
#define IsChar(c)	(IsUpper(c) || IsLower(c))
#define IsDigit(c)	(((c)>='0')&&((c)<='9'))
#define IsAlphaNum(c)   (IsChar(c) || IsDigit(c))

/*******************************************************************************
 *   public variables   
 *******************************************************************************/



/*******************************************************************************
 *   private variables   
 *******************************************************************************/

static struct fpinfo FPInfo;		/* contains psz_cdrive and psz_cpath ! */

static struct _file *filelist[NUM_OPENFILES]; 			/* list of open files */

static unsigned char HPOOL[NUM_FILE_HANDLES];		/* handle pool, handles 0...9 are reserved !! */

static struct fs_driver *driverlist = NULL;		/* pointer to file system driver list */
extern struct blk_driver *blk_driverlist; 	/* pointer to block device driver list */

#ifdef CONFIG_FS_NKC
extern unsigned char _DRIVE; // drive where this program was started (startup/startXX.S)
#endif

struct fstabentry *fstab; /* filesystem table */


#ifdef CONFIG_DEBUG_FS
#define DBGSTR_LEN 200
char dbgstr[DBGSTR_LEN+1];
char dbgstr1[DBGSTR_LEN+1];
#endif

/****************************************************************************
 * Private Functions
 ****************************************************************************/

#define MBR_Table			446	/* MBR: Partition table offset (2) */
#define	SZ_PTE				16	/* MBR: Size of a partition table entry */
#define BS_55AA				510	/* Boot sector signature (2) */



FRESULT fdisk (
	struct blk_driver *blk_drv,     /* block device driver */
	BYTE pdrv,			/* Physical drive number  */	
	const DWORD szt[],		/* Pointer to the size table for each partition */
	void* work			/* Pointer to the working buffer */	
)
{
	UINT i, n, sz_cyl, tot_cyl, b_cyl, e_cyl, p_cyl;
	BYTE s_hd, e_hd, *p, *buf = (BYTE*)work;
	DSTATUS dstat;
	DRESULT dres;
	DWORD sz_disk, sz_part, s_part;

	struct ioctl_disk_rw rw_args;

	fs_lldbg("fs.c: fdisk() ...\n");
      
	dstat = blk_drv->blk_oper->open(&pdrv);
	
	
	if (dstat & STA_NOINIT) return dstat + DSTATUS_OFFSET;
	if (dstat & STA_PROTECT) return dstat + DSTATUS_OFFSET;
	
	if ( dres = blk_drv->blk_oper->ioctl(&pdrv,GET_SECTOR_COUNT,&sz_disk)) {
	  fs_dbg("fs.c: GET_SECTOR_COUNT returned sz_disk = %d, dres = %d ...\n",sz_disk,dres);
	  return dres + DRESULT_OFFSET;
	}

	fs_dbg("fs.c: GET_SECTOR_COUNT returned sz_disk = %d, dres = %d ...\n",sz_disk,dres);
	
	/* Determine CHS in the table regardless of the drive geometry */
	for (n = 16; n < 256 && sz_disk / n / 63 > 1024; n *= 2) ;
	if (n == 256) n--;
	e_hd = n - 1;
	sz_cyl = 63 * n;
	tot_cyl = sz_disk / sz_cyl;

	/* Create partition table */
	memset(buf, 0, _MAX_SS);
	p = buf + MBR_Table; b_cyl = 0;
	for (i = 0; i < 4; i++, p += SZ_PTE) {
		p_cyl = (szt[i] <= 100U) ? (DWORD)tot_cyl * szt[i] / 100 : szt[i] / sz_cyl;
		if (!p_cyl) continue;
		s_part = (DWORD)sz_cyl * b_cyl;
		sz_part = (DWORD)sz_cyl * p_cyl;
		if (i == 0) {	/* Exclude first track of cylinder 0 */
			s_hd = 1;
			s_part += 63; sz_part -= 63;
		} else {
			s_hd = 0;
		}
		e_cyl = b_cyl + p_cyl - 1;
		if (e_cyl >= tot_cyl) return EINVAL;

		/* Set partition table */
		p[1] = s_hd;				/* Start head */
		p[2] = (BYTE)((b_cyl >> 2) + 1);	/* Start sector */
		p[3] = (BYTE)b_cyl;			/* Start cylinder */
		p[4] = 0x06;				/* System type FAT16 (temporary setting) */
		p[5] = e_hd;				/* End head */
		p[6] = (BYTE)((e_cyl >> 2) + 63);	/* End sector */
		p[7] = (BYTE)e_cyl;			/* End cylinder */
		ST_DWORD(p + 8, s_part);		/* Start sector in LBA */
		ST_DWORD(p + 12, sz_part);		/* Partition size */

		/* Next partition */
		b_cyl += p_cyl;
	}
	ST_WORD(p, 0xAA55);
	
	/* Write it to the MBR */
	//return (disk_write(pdrv, buf, 0, 1) || disk_ioctl(pdrv, CTRL_SYNC, 0)) ? FR_DISK_ERR : FR_OK; 
	
	
	rw_args.drv = NULL;
	rw_args.buff  = buf;
	rw_args.sector = 0;
	rw_args.count = 1;
	
	dres = blk_drv->blk_oper->ioctl(&pdrv,FS_IOCTL_DISK_WRITE,&rw_args);
	dres = blk_drv->blk_oper->ioctl(&pdrv,CTRL_SYNC,NULL); 
 
	if(dres < FRESULT_OFFSET && dres != RES_OK)
	  return dres + DRESULT_OFFSET;
	else return dres;
}

 
int alloc_handle(void)
{
	int h;
	
	fs_lldbg("fs.c: [ alloc handle...\n");
	
	for(h=10; h<255; h++)
	{
		if( HPOOL[h] == 0)
		{
			HPOOL[h] = 0xff;
			fs_lldbg("fs.c: ...alloc_handle(SUCESS) ]\n");
			return h;
		}
		
	}
	
	fs_lldbg("fs.c: ...alloc_handle(FAILED) ]\n");
	return 0;
}

void free_handle(int fd)
{	
	fs_lldbg("fs.c: free handle\n");
	HPOOL[fd] = 0;	
}


struct fs_driver* get_driver(char *name)
/* name == FS, i.e. FAT, JADOS etc. */
{
      
	fs_lldbg("fs.c|get_(fs)driver: ...\n"); 
	
	struct fs_driver *pcur, *plast;
	
	if(!name) 
	{ 	 
		/*
		 * no filesystem specified
		 */
		fs_lldbg("fs.c|get_(fs)driver:  error: no filesysten specified ...\n"); 
		return NULL;
	}

    #ifdef CONFIG_DEBUG_FS
    strncpy(dbgstr,name,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;
    #endif
	fs_dbg("fs.c|get_(fs)driver: file system = %s\n",dbgstr);
	
	pcur = plast = driverlist;
        while(pcur)
        {
  	  if(!strcmp(pcur->pname,name))
  	  { // found device 
	    fs_lldbgwait("fs.c|get_(fs)driver: (sucess)...]\n");
  	    return pcur;
  	  }
  	  
  	  pcur = pcur->next;
        }

	fs_lldbgwait("fs.c|get_(fs)driver: (failed)...]\n");
        return NULL;
}


/****************************************************************************
 * Public Functions
 ****************************************************************************/

int dn2pdrv(char* devicename) { /* convert devicename to physical drive number */

   int drive = -1;
   char c;
   /*
    * drivename: aabcc[xn]   aa=hd,sd ... is the device type, b=a,b,c... is the physical drive, cc = 0....n is the logical partition
    *                        xn is an optional extended partition, n = 0...N
    */ 

   #ifdef CONFIG_DEBUG_FS
   strncpy(dbgstr,devicename,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;
   fs_dbg("dn2pdrv: device = '%s'\n",dbgstr);
   #endif

   if(strlen(devicename) > 2) {
     c=devicename[2];
     fs_dbg("dn2pdrv: physical drive letter = '%c'\n",c);
     
     drive = toupper(c) - 'A';
   }
   
   fs_dbg("dn2pdrv: physical drive number => %d\n",drive);
   
   return drive;
 }
 
 int dn2part(char* devicename) { /* convert devicename to partition number, 1st partition = 0 ... */

   int partition = -1;
   char pstring[6];  /* 5 characters + 1 teminating '0' */
   char *c = devicename;
   char *tc = pstring;
   /*
    * drivename: aabcc[xn]   aa=hd,sd ... is the device type, b=a,b,c... is the physical drive, cc = 0....n is the logical partition
    *                        xn is an optional extended partition, n = 0...N
    */  
   
   while( IsChar(*c) ) c++; 		/* skip characters */
   while( IsDigit(*c )) *tc++ = *c++; 	/* copy partition number */
   *tc=0;				/* terminate string */
     
   if(pstring[0])  
     partition = atoi( pstring );		/* convert to integer */
   
   #ifdef CONFIG_DEBUG_FS
   strncpy(dbgstr,devicename,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;
   fs_dbg(" dn2part(%s)=%d\n",dbgstr,partition);
   #endif

   return partition;
 }

int dn2extended(char* devicename) { /* check devicename if extended partition */
   char* p;   
   int r=0;

   p = strchr(devicename,'x'); 	

   if(p) r = 1;
   
   #ifdef CONFIG_DEBUG_FS
   strncpy(dbgstr,devicename,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;
   fs_dbg(" dn2extended(%s)=%d\n",dbgstr,r);
   #endif

   return r;
}

int dn2expart(char* devicename){  /* convert devicename to extended partition */
	char* p;
	char pstring[6];  /* 5 characters + 1 teminating '0' */
	char *tp = pstring;
	int r=-1;

	p = strchr(devicename,'x');

	if(p){
		while( IsChar(*p) ) p++; 		/* skip characters */
		while( IsDigit(*p )) *tp++ = *p++; 	/* copy partition number */
   		*tp=0;				/* terminate string */

   		if(pstring[0])  
        	r = atoi( pstring );		/* convert to integer */
	}

	#ifdef CONFIG_DEBUG_FS
    strncpy(dbgstr,devicename,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;
    fs_dbg(" dn2expart(%s)=%d\n",dbgstr,r);
    #endif

	return r;
}

unsigned char checkfp(char* fp, struct fpinfo *pfpinfo)
{
  char* p;
  char* pstr;
  unsigned int n;
  char tmp[255];
  unsigned char res = 0;
  
  #ifdef CONFIG_DEBUG_FS
  strncpy(dbgstr,fp,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;
  fs_dbg(" fs.c|checkfp: (%s) ...\n",dbgstr);
  #endif
  
  *pfpinfo->psz_driveName = 0;
  *pfpinfo->psz_deviceID = 0;
  pfpinfo->c_deviceNO = 0;
  pfpinfo->n_partition = 0;
  *pfpinfo->psz_path = 0;
  *pfpinfo->psz_filename = 0;
  pfpinfo->c_separator = 0;
  *pfpinfo->psz_fileext = 0;
  pfpinfo->b_extended = 0; 
  pfpinfo->n_extpart = 0; 
  pfpinfo->b_has_wcard = 0;
  *pfpinfo->psz_wcard = 0;
  
  pstr = fp;

  while (*pstr == ' ') pstr++; // skip whitespace
  
  // ======================== DRIVE ====================================================================
  // extract drive information  
  p = strchr(pstr,':');   

  if(p){ // copy drive
    
    n=(unsigned int)(p-pstr);   // length of drive name  
    fs_dbg("   ->  n  = %d\n",n);
    
    if(n==0 || n > _MAX_DRIVE_NAME){
      fs_dbg(" fs.c|checkfp: fail(n > _MAX_DRIVE_NAME)\n");
      return EINVDRV; 
    }
    else
    {
      strncpy(pfpinfo->psz_driveName,pstr,n); // copy drive to psz_driveName      
      (pfpinfo->psz_driveName)[n] = 0;        // terminate string
      fs_dbg("   ->  psz_driveName  = %s\n",pfpinfo->psz_driveName);

      pstr+=n+1; // advance pointer to next char after ':'
      

      // check length of drive name, maybe we could check fstable here and store pfstab pointer
      switch(n){      
        case 1: // jados drive name (0,1,2...A,B,C....)
          fs_dbg(" fs.c|checkfp: got jados/alias drive ...\n");
          strcpy(pfpinfo->psz_deviceID, pfpinfo->psz_driveName); // copy drive to psz_deviceID
          pfpinfo->n_partition = pfpinfo->c_deviceNO = 0; // or: =  pfpinfo->psz_deviceID - (int)'A';
          break;
        case 3: 
          // FIXME: handle floppy disks (fd0, fd1 ....)
          fs_dbg(" fs.c|checkfp: got floppy drive ...\n");
          break;

        default:  // other drive name (hda0,sdb1,sda0x1 ...)
          fs_dbg(" fs.c|checkfp: regular drive ...\n");       
          strncpy(pfpinfo->psz_deviceID, pfpinfo->psz_driveName, 2);  // copy device ID to psz_deviceID (2 letters)
          (pfpinfo->psz_deviceID)[2] = 0;         // terminating NULL

          #ifdef CONFIG_DEBUG_FS
          strncpy(dbgstr,pfpinfo->psz_deviceID,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;   
          fs_dbg("   ->  psz_deviceID  = %s\n",dbgstr);
          #endif
          pfpinfo->c_deviceNO = (pfpinfo->psz_driveName)[2];    // copy device 'number' to c_deviceNO (1 letter) if not floppy
          fs_dbg("   ->  c_deviceNO  = %c\n",pfpinfo->c_deviceNO);

          n=0;
          while( isdigit( (pfpinfo->psz_driveName)[3+n] ) ) {   // n digits
            tmp[n] = (pfpinfo->psz_driveName)[3+n];
            n++;      
          }
          tmp[n] = 0;     
          
          pfpinfo->n_partition = atoi(tmp); // copy partition number (n digits/numbers)
          fs_dbg("   ->  partition %d  \n",pfpinfo->n_partition);

          if((pfpinfo->psz_driveName)[3+n] == 'x'){
            // extended partition       
            n++;
            pfpinfo->b_extended = 1;
            while( isdigit( (pfpinfo->psz_driveName)[3+n] ) ) {   // n digits
                tmp[n] = (pfpinfo->psz_driveName)[3+n];
                n++;      
            }
            tmp[n] = 0;
            pfpinfo->n_extpart = atoi(tmp); // copy extended partition number (n digits/numbers)
            fs_dbg("   ->  extended partition %d  \n",pfpinfo->n_extpart);
          }
          break;
                      
      
      } /* switch(n) */


     }
  }else{ // terminate (no drive information)
      fs_dbg(" fs.c|checkfp: fail(no drive information) (EINDRV)\n");
      res = EINVDRV;
  }   
  
  /* ======================== PATH ==================================================================== */
  /* 
   * FIXME: everthing after the last '/' is considered a filename, but could also be a directory in a FAT file system !!
   *        ==> this has to be checked in the calling function !
  */

  p=strrchr(pstr,'/');   /* look for the last occurence of a '/' delimiter */     
  if(p){
    n=(unsigned int)(p-pstr);
     n++;
    if(n > _MAX_PATH){
       fs_dbg(" fs.c|checkfp: fail(path too long) (ENOPATH)\n");
       return ENOPATH;
    }
    strncpy(pfpinfo->psz_path,pstr,n); /* copy path */
    pstr+=n;                           /* advance pointer */

    if((pfpinfo->psz_path)[n-1] != '/'){ /* path should end with '/' */
      (pfpinfo->psz_path)[n]='/';
      n++;
    }

    (pfpinfo->psz_path)[n]=0;          /* and terminate */    
  }
          
  if(*pstr == '.')  { // special "file" handling ('.' and '..' are path information)
    strcat(pfpinfo->psz_path,".");
    pstr++;
    if(*pstr == '.') {
      strcat(pfpinfo->psz_path,"./");
      pstr++;
    }else{
       strcat(pfpinfo->psz_path,"/");
    }   
  }
  
  // ======================== FILENAME.EXT ==================================================================== 
        
  if(_STRLEN(pstr) > _MAX_FILENAME) {
    fs_dbg(" fs.c|checkfp: fail(filename too long)\n");
    return ENOFILE;
  }
  
  strcpy(pfpinfo->psz_filename,pstr); /* copy filename+extension to psz_filename */
    
  /* look for filename delimiter and try to split filename and extension */
  p=strchr(pfpinfo->psz_filename,'.');
  if(p) { 
    n=(unsigned int)(p-pfpinfo->psz_filename);  
    (pfpinfo->psz_filename)[n] = 0;       /* remove extension from psz_filename */
    pfpinfo->c_separator = '.';           /* store the separator, which is always '.' here */
    pstr+=n+1;                            /* advance pointer */
    /* rest has to be fileextension */
    if(_STRLEN(pstr) > _MAX_FILEEXT) {
      fs_dbg(" fs.c|checkfp: fail(fileextension too long)\n");
      return ENOFILE;
    }
    strcpy(pfpinfo->psz_fileext,pstr);     /* copy file extension to psz_fileext */       
  }

  if((pfpinfo->psz_filename)[0] == 0) {
    fs_dbg(" fs.c|checkfp: fail(no filename given)\n");
    return ENOFILE;
  }   

  // ========================= wildcards ? ===========================================

  if(strchr(pfpinfo->psz_filename,'*') || strchr(pfpinfo->psz_filename,'?') ||
     strchr(pfpinfo->psz_fileext,'*') || strchr(pfpinfo->psz_fileext,'?')      ){
    pfpinfo->b_has_wcard = 1;
    sprintf(pfpinfo->psz_wcard,"%s%c%s",pfpinfo->psz_filename,pfpinfo->c_separator,pfpinfo->psz_fileext);
  }   

  fs_dbg(" fs.c|checkfp: SUCCESS...\n");
  fs_dbg("     psz_driveName = '%s'\n",pfpinfo->psz_driveName);
  fs_dbg("     psz_deviceID  = '%s'\n",pfpinfo->psz_deviceID);
  fs_dbg("     c_deviceNO    = %c\n",pfpinfo->c_deviceNO);
  fs_dbg("     n_partition   = %d\n",pfpinfo->n_partition);
  fs_dbg("     psz_path      = '%s'\n",pfpinfo->psz_path);
  fs_dbg("     psz_filename  = '%s'\n",pfpinfo->psz_filename);
  fs_dbg("     c_separator   = %c\n",pfpinfo->c_separator);
  fs_dbg("     psz_fileext   = '%s'\n",pfpinfo->psz_fileext);
  fs_dbg("     psz_cdrive    = '%s'\n",pfpinfo->psz_cdrive);
  fs_dbg("     psz_cpath     = '%s'\n",pfpinfo->psz_cpath); 
  fs_dbg("     b_has_wcard   = %d\n",pfpinfo->b_has_wcard);
  fs_dbg("     psz_wcard     = '%s'\n",pfpinfo->psz_wcard);
  fs_dbg("... (KEY)\n");
      
  return res;
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
  FRESULT fres;   // FRESULT from underlying file system
  int res;	  // result (from errno.h) to upper layers
  
  char tmp[255];
  char *pc;
  struct fs_driver *pfsdriver;    	// fs driver
  struct blk_driver *blk_drv;   // device driver
  struct fstabentry *pfstab;    // entry in the fstab
  struct _dev physical_drive;	// physical drive
  
  BOOL isJados = FALSE;
  
  struct ioctl_get_cwd arg_get_cwd;  
  struct ioctl_opendir arg_opendir;
  struct ioctl_readdir arg_readdir;
  struct ioctl_getfree arg_getfree;
  struct ioctl_mount_fs arg_mountfs;
  struct _file File;
  

  fs_dbg("fs.c: [ ioctl ...\n"); 

  res = EINVFNC;
  
  
  SWITCH:
  switch(cmd) 
  {  
    case FS_IOCTL_GETFSTAB: // ************************************* return pointer to file system table *************************************
        fs_lldbg(" - FS_IOCTL_GETFSTAB - \n");
		*((struct fstabentry **)arg) = fstab;
		res = EZERO;
		break;
    	case FS_IOCTL_GETFSDRIVER: // ************************************* return pointer to registered file system driver list *************************************
    	    fs_lldbg(" - FS_IOCTL_GETFSDRIVER - \n");
		*((struct fs_driver **)arg) = driverlist;
		res = EZERO;
		break;
    	case FS_IOCTL_GETBLKDEV: // ************************************* return pointer to registered block devices *************************************
    	    fs_lldbg(" - FS_IOCTL_GETBLKDEV - \n");
		*((struct blk_driver **)arg) = blk_driverlist;
		res = EZERO;
		break;	
	
    case FS_IOCTL_MOUNT: // ************************************* mount a drive *************************************  
        // args = (NULL, FS_IOCTL_MOUNT, struct ioctl_mount_fs *)arg))      	
            
        fs_lldbg(" - FS_IOCTL_MOUNT - \n");
      
		if (!arg) { res = EINVDRV; break; }     // no args ? -> exit
    	  
    	#ifdef CONFIG_DEBUG_FS
    	strncpy(dbgstr,((struct ioctl_mount_fs *)arg)->devicename,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;		  
    	fs_dbg("device = %s\n",dbgstr);
    	strncpy(dbgstr,((struct ioctl_mount_fs *)arg)->fsname,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;	
		fs_dbg("fs     = %s\n",dbgstr);
		fs_dbg("options= %d\n",((struct ioctl_mount_fs *)arg)->options);
		#endif
		// mount the fs in fstab and call the filesystems ioctl ...
    	    fres = mountfs( ((struct ioctl_mount_fs *)arg)->devicename, 
				  			((struct ioctl_mount_fs *)arg)->fsname, 
				  			((struct ioctl_mount_fs *)arg)->options    );                 
					
		fs_dbg("fs.c|FS_IOCTL_MOUNT: fres = %d",fres);
		fs_lldbgwait("\n");
		
		switch(fres){
		  // fs already mounted
		  case FR_OK:
		    res = EZERO;	    
		    break;
		    
		  default: res = fres + FRESULT_OFFSET; 
		}		  
        break;
	
    case FS_IOCTL_UMOUNT: // ************************************* unmount a drive *************************************   
    	    // args = (char *name = HDA0:...., FS_IOCTL_MOUNT, NULL)
    	    fs_lldbg("fs.c: - FS_IOCTL_UMOUNT - \n");
    	  
		if (!name) { res = EINVDRV; break; }     // no name ? -> exit
    	  
    	//res=checkfp((char*)name, &FPInfo); // analyze drive name      
    	//if(res == EINVDRV) break;		// no device info ? -> exit              
    	//
    	fres = umountfs((char*)name);
		
		fs_dbg("fs.c:|FS_IOCTL_UMOUNT: umountfs returned %d",fres);
		fs_lldbgwait("\n");
		
		switch(fres){
		  // fs already mounted
		  case FR_OK:
		    res = EZERO;	    
		    break;
		    
		  default: res = fres + FRESULT_OFFSET; 
		}		  
        break;
	
    case FS_IOCTL_GETDRVLIST: // ************************************* get pointer to driverlist *************************************
      	fs_dbg(" - FS_IOCTL_GETDRVLIST - \n");
      	*(struct fs_driver **)(arg) = driverlist;
      	res = EZERO;
      	break;
    case FS_IOCTL_GETDRV: // ************************************* get current drive *************************************
      		fs_lldbgwait(" - FS_IOCTL_GETDRV - \n");
      		strcpy((char*)arg,FPInfo.psz_cdrive);
      		res = EZERO;
      		break;
      
    case FS_IOCTL_CHDRIVE: // ************************************* change current drive *************************************
      // NULL,FS_IOCTL_CHDRIVE,args=drivestring
      fs_lldbgwait(" - FS_IOCTL_CHDRIVE - \n");
      if (!arg) { res = EINVDRV; break; }     // no args ? -> exit
      
      strcpy(tmp,(char*)arg); strcat(tmp,":");
      res=checkfp(tmp, &FPInfo); // analyze drive name      
      if(res == EINVDRV) break;		// no device info ? -> exit
    
    
      // check if a drive is mounted in fstab !
      pfstab = get_fstabentry(FPInfo.psz_driveName);
      
      if(!pfstab) {
		// error drive not mounted...
		res = EINVDRV;
		break;
      	}
      
      pfsdriver = pfstab->pfsdrv;  		// pointer to file system driver
      if(!pfsdriver){ 				// paranoia check: no driver ? -> exit 
		fs_lldbgwait(" error no fs driver ...(KEY) \n");
		res = EINVDRV; 
		break;  
		}	
      
      if(pfsdriver->f_oper->ioctl) {	
		fs_lldbg(" fs.c: calling (fs)drivers ioctl...\n");
	
		fres = pfsdriver->f_oper->ioctl(pfstab,FS_IOCTL_CHDRIVE,pfstab);	// is ioctl valid ? -> call it
		fs_dbg("fc.c:  fres(FS_IOCTL_CHDRIVE) = %d\n",fres);	
	
		if(fres == FR_OK) {
		  // update psz_cdrive and psz_cpath....
		  fs_lldbg(" fs.c: updating current drive/path information\n");
		  strcpy(FPInfo.psz_cdrive, FPInfo.psz_driveName);
		  strcpy(FPInfo.psz_cpath, FPInfo.psz_path);
		  fs_dbg(" cdrive = %s\n cpath = %s\n",FPInfo.psz_cdrive,FPInfo.psz_cpath);
		  fs_lldbgwait("...(KEY)\n");
		}

      }else{
		fs_lldbgwait(" fs.c: ioctl not valid !\n");
		res = fres + FRESULT_OFFSET;
      }      
      
      break;
    case FS_IOCTL_CD: // ************************************* change directory *************************************

      #ifdef CONFIG_DEBUG_FS
      strncpy(dbgstr,(char*)arg,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;	
      fs_dbg(" - FS_IOCTL_CD - (%s)",dbgstr);
      fs_lldbgwait("\n");
      #endif
      if (!arg) { res = EINVDRV;	break;  }    				// we need some args ...
      
      //split_filename((char*)arg, drive, path, filename, ext,fullname, filepath, fullpath, cdrive, cpath); // analyze filename      
      res=checkfp((char*)arg, &FPInfo);
      
      fs_dbg(" using drive %s ; path %s; file: %s%s%s\n", FPInfo.psz_driveName, 
							  FPInfo.psz_path, 
							  FPInfo.psz_filename, // FIXME da funzt noch was nicht: bei "hda0:/foo" müsste foo als filename auftauchen ... !
							  FPInfo.c_separator, 
							  FPInfo.psz_fileext);
      
      switch ( res ) {							// check error code ...	
	case EINVDRV:
	case ENOPATH:
	  break;
	default:
	  res = EZERO;
	}
	
      if(res != EZERO) break;
      
      if(FPInfo.psz_driveName) { 					// paranoya check
		// check if a drive is mounted in fstab !
		pfstab = get_fstabentry(FPInfo.psz_driveName);
      } else {
		  res = EINVDRV;
		  break;
      }
	
      
      if(!pfstab){
		  // error drive not mounted...
		  fs_dbg(" error drive %s not mounted - giving up ",FPInfo.psz_driveName);
		  fs_lldbgwait("...(KEY)\n");
		  res = EINVDRV;
		  break;
      } 
      
      pfsdriver = pfstab->pfsdrv;  		// pointer to file system driver
      
      if(!pfsdriver) { 
		fs_dbg(" no driver found for ID %s - giving up ",FPInfo.psz_deviceID);
		fs_lldbgwait("...(KEY)\n");
		res = ENODRV; break;  	
      }                                         // if no driver, exit...
      
       if(pfsdriver->f_oper->ioctl) {
		fs_lldbg(" calling drivers ioctl...\n"); 
		fres = pfsdriver->f_oper->ioctl(pfstab,FS_IOCTL_CD,(char*)arg);	// is ioctl valid ? -> call it  // FIXME: arg =!= FPInfo.psz_driveName + ":" + FPInfo.psz_path + FPInfo.psz_filename .... o.ä.
		fs_dbg("fs.c|ioctrl: fres = %d\n",fres);
		
		if(fres == FR_OK) {
		  // update psz_cdrive and psz_cpath....
		  fs_lldbg(" fs.c: updating current drive/path information\n");
		  
		  arg_get_cwd.cdrive = FPInfo.psz_cdrive;
		  arg_get_cwd.cpath  = FPInfo.psz_cpath;
		  arg_get_cwd.size   = _MAX_PATH;		// size of path buffer
		  	  	  
		  res = pfsdriver->f_oper->ioctl(NULL,FS_IOCTL_GETCWD, &arg_get_cwd);
		  
		  fs_dbg(" fs.c: cdrive = %s\n cpath = %s\n",FPInfo.psz_cdrive,FPInfo.psz_cpath);
		  fs_lldbgwait("...(KEY)\n");

		}
	
      }else{
		fs_lldbgwait(" ioctl not valid !\n");
		fres = EINVFNC;
      }     
          
      if(fres < FRESULT_OFFSET && fres != FR_OK)
		res = fres + FRESULT_OFFSET;
      else res = fres;
       
      break;        
    case FS_IOCTL_GETCWD: // ************************************* get current working directory and path
      // name=NULL, cmd=FS_IOCTL_GETCWD,arg =>  struct ioctl_get_cwd 
      fs_lldbgwait(" - FS_IOCTL_GETCWD - \n");
           
      if(FPInfo.psz_cdrive) { 					// paranoya check
		  // check if a drive (current drive) is mounted in fstab !
		  pfstab = get_fstabentry(FPInfo.psz_cdrive);
	
      } else {
		  fs_dbg("fs.c|ioctl: error, invalid drive (%s) specified.",FPInfo.psz_cdrive);
		  fs_lldbgwait("...(KEY)\n");
		  res = EINVDRV;
		  break;
      }
      
      if(!pfstab){
		  // error drive not mounted...
		  fs_dbg("fs.c|ioctl: error, drive (%s) not mounted .",FPInfo.psz_cdrive);
		  fs_lldbgwait("...(KEY)\n");
		  res = EINVDRV;
		  break;
      } 
      
      pfsdriver = pfstab->pfsdrv;  		// pointer to file system driver of current drive
      
      if(!pfsdriver) { 
		fs_dbg(" no fs driver found for ID %s - giving up",FPInfo.psz_deviceID);
		fs_lldbgwait("...(KEY)\n");
		res = ENODRV; break;  	
      }                                         // if no driver, exit...
      
      
       if(pfsdriver->f_oper->ioctl) {		// ...otherwise check file systems current drive...
		fs_lldbg(" calling drivers ioctl..."); 
		fs_lldbgwait("...(KEY)\n");
		
		arg_get_cwd.cdrive = FPInfo.psz_cdrive;	
		arg_get_cwd.cpath  = FPInfo.psz_cpath;
		arg_get_cwd.size   = _MAX_PATH;		// size of path buffer
		  
		fres = pfsdriver->f_oper->ioctl(pfstab,FS_IOCTL_GETCWD, &arg_get_cwd);
		
		if(fres == FR_OK) {
		  // update psz_cdrive and psz_cpath....
		  fs_lldbg(" updating current local and callers drive/path information:\n");	  
		  
		  // update local information
		  strcpy(FPInfo.psz_cdrive, arg_get_cwd.cdrive);
		  strcpy(FPInfo.psz_cpath, arg_get_cwd.cpath);
		  
		  // return information to calling process 
	          strcpy((char*)((struct ioctl_get_cwd*)(arg))->cdrive,FPInfo.psz_cdrive);
	          strcpy((char*)((struct ioctl_get_cwd*)(arg))->cpath,FPInfo.psz_cpath);
		  
		  fs_dbg(" cdrive = %s\n cpath = %s\n",FPInfo.psz_cdrive,FPInfo.psz_cpath);
		  fs_lldbgwait("...(KEY)\n");
		  fres = FR_OK;
		} 		
       }
       
       if(fres < FRESULT_OFFSET && fres != FR_OK)
			res = fres + FRESULT_OFFSET;
       else res = fres;
      
      break;
      
    case FS_IOCTL_MKDIR: // ************************************* create a directory ************************************* 
      // char *name = HDA0, int cmd = FS_IOCTL_MKDIR, unsigned long arg = (char*)fullpath
      fs_lldbgwait("fs.c: - FS_IOCTL_MKDIR - \n");      
    case FS_IOCTL_RMDIR: // ************************************* delete a directory ************************************* 
      // char *name = HDA0, int cmd = FS_IOCTL_RMDIR, unsigned long arg = (char*)fullpath
      fs_lldbgwait("fs.c: - FS_IOCTL_RMDIR - \n");
      
      if(!name) { res = EINVDRV; break; }
      if(!arg)  { res = ENOPATH; break; }
            
      pfstab = get_fstabentry(name);
      
      if(!pfstab) { res = EINVDRV; break;  }	// if no fstab entry, exit...
      pfsdriver = pfstab->pfsdrv;  		// pointer to file system driver                      
      if(!pfsdriver) { res = EINVDRV; break;  }	// if no driver, exit...
      
       if(pfsdriver->f_oper->ioctl) {	
		fres = pfsdriver->f_oper->ioctl(pfstab,cmd,arg);	// is ioctl valid ? -> call it
      }else{
		fs_lldbgwait(" ioctl not valid !\n");
      }         
      
      if(fres < FRESULT_OFFSET && fres != FR_OK)
		res = fres + FRESULT_OFFSET;
      else res = fres;
      
      break;
      
    case FS_IOCTL_CHMOD: // ************************************* change file mode *************************************
       // (NULL,FS_IOCTL_CHMOD,arg* = struct ioctl_chmod)
      
      //struct ioctl_chmod {
      //      void* fpath;		/* pointer to file path */
      //      unsigned char value;
      //      unsigned char mask;
      //};
      fs_lldbgwait("fs.c: - FS_IOCTL_CHMOD - \n");
      if (!arg) { res = EINVDRV;	break;  }    				// we need some args ... 
          
     // (struct ioctl_chmod*)arg->value // attribute bits
     // (struct ioctl_chmod*)arg->mask  // attribute mask
     // (struct ioctl_chmod*)arg->fpath // full path to file
      res=checkfp(((struct ioctl_chmod*)arg)->fpath, &FPInfo);  if( res != EZERO) break;
    
      pfstab = get_fstabentry(FPInfo.psz_driveName);
      
      if(!pfstab) { res = EINVDRV; break;  }	// if no fstab entry, exit...
      pfsdriver = pfstab->pfsdrv;  		// pointer to file system driver                      
      if(!pfsdriver) { res = EINVDRV; break;  }	// if no driver, exit...
      
       if(pfsdriver->f_oper->ioctl) {	
		fres = pfsdriver->f_oper->ioctl(pfstab,cmd,arg);	// is ioctl valid ? -> call it
      }else{
		fs_lldbgwait(" ioctl not valid !\n");
      }           
      
      if(fres < FRESULT_OFFSET && fres != FR_OK)
		res = fres + FRESULT_OFFSET;
      else res = fres;
      
      break;
      
    case FS_IOCTL_DEL:
      // ************************************* delete file *************************************
       // (NULL,FS_IOCTL_DEL,arg* = pointer to fullpath)
      fs_lldbgwait("fs.c: - FS_IOCTL_DEL - \n");
      res = _ll_remove(arg);
      fs_dbg("fs.c|FS_IOCTL_DEL: _ll_remove returned code %d",res);            
      fs_lldbgwait("  ....(KEY)\n");
      break;
    case FS_IOCTL_RENAME:
      // ************************************* rename/move file *************************************
    	// (NULL,FS_IOCTL_RENAME,arg* = pointer to struct ioctl_rename)
      fs_lldbgwait("fs.c: - FS_IOCTL_RENAME - \n");
      res = _ll_rename(((struct ioctl_rename*)arg)->path_old,((struct ioctl_rename*)arg)->path_new);
      fs_dbg("fs.c|FS_IOCTL_RENAME: _ll_rename returned code %d",res);            
      fs_lldbgwait("  ....(KEY)\n");
      break;  
    case FS_IOCTL_OPEN_DIR: // ************************************* open dir *************************************

      fs_lldbgwait(" - FS_IOCTL_OPEN_DIR - \n");
      if (!arg){ res = EINVDRV;	break;  }    				// we need some args ... 
      
      //look for drive: 1) in arg.fpath 2) in *name 3) take CurrDrive
      //split_filename((char*)((struct ioctl_opendir *)arg)->path, drive, path, filename, ext, fullname, filepath, fullpath, cdrive, cpath); // analyze filename      
      res=checkfp((char*)((struct ioctl_opendir *)arg)->path, &FPInfo);
      
      switch (res) { // check error codes
		case EINVDRV:
		case ENOPATH:
		  break;	
		default: res = EZERO;  
      }
      
      if( res != EZERO) break;
           
      pfstab = get_fstabentry(FPInfo.psz_driveName);
      fs_dbg("fs.c|FS_IOCTL_OPEN_DIR: pfstab = 0x%0x\n",pfstab);
	
      if(pfstab == NULL) {
		  fs_lldbgwait(":  no entry in fstab found !\n");
		  return 0;
      }
	
      pfsdriver = pfstab->pfsdrv; 	      
      if(!pfsdriver){ res = EINVDRV; break;  }		// if no driver, exit...
      
      if(pfsdriver->f_oper->ioctl) {
		res = pfsdriver->f_oper->ioctl(pfstab,FS_IOCTL_OPEN_DIR,arg);	// is ioctl valid ? -> call it
      }else{
		fs_lldbgwait(" ioctl not valid !\n");
      }            
      break;  
//    case FS_IOCTL_READ_DIR: // ************************************* read dir *************************************
//      fs_lldbgwait(" - FS_IOCTL_READ_DIR - \n");
//      //parg_readdir = (struct ioctl_readdir*)arg;
//      cmd = FAT_IOCTL_READ_DIR;
//      goto SWITCH;
//      break;
//    case FS_IOCTL_CLOSE_DIR: // ************************************* close dir *************************************      
//      fs_lldbgwait(" - FS_IOCTL_CLOSE_DIR - \n");
//      cmd = FAT_IOCTL_CLOSE_DIR;
//      goto SWITCH;
//      break;  
//    case FS_IOCTL_GET_FREE:
//      fs_lldbgwait(" - FS_IOCTL_GET_FREE - \n");
//      //parg_getfree = (struct ioctl_getfree*)arg;
//      break;
      
    // ############################ low level disk functions -> direkt block device driver call  ##################################################
    
//      struct ioctl_mkptable {
//	char *drv;			/* pointer to physical drive name (HDA,HDB,SDA,SDB ....) */
//	const unsigned int *szt;	/* Pointer to the size table for each partitions */
//	void* work;			/* Pointer to the working buffer  ( >= _MAX_SS ) */
//      };
    case FS_IOCTL_MKPTABLE: // currently we let ff.c f_fdisk handle this, but it should be moved to the block driver (it is filesystem independent) FIXME
      // args: char *name<=devicename, int cmd<=FS_IOCTL_MKPTABLE, unsigned long arg <=pointer to struct ioctl_mkptable
      fs_lldbgwait(" - FS_IOCTL_MKPTABLE - \n");
      if (!arg){ res = EINVDRV;	break;  }    				// we need some args ... 
      
      
      blk_drv = get_blk_driver(name);			/* fetch block device driver */
      fs_dbg(" blk_driver->0x%x\n",blk_drv);
      
      if(!blk_drv) { 
		fs_lldbgwait(" no blk driver found !\n");
		res = EINVDRV; 
		break;  
	  }		// if no driver, exit...   
      
      physical_drive.pdrv = dn2pdrv(name);		// get physical drive number from drive table via devicename            
      
      fres = fdisk (
			blk_drv,     						/* block device driver */
			physical_drive.pdrv,					/* Physical drive number  */	
	                (unsigned int*)((struct ioctl_mkptable *)arg)->szt,	/* Pointer to the size table for each partition */
			(void*)((struct ioctl_mkptable *)arg)->work		/* Pointer to the working buffer */
	     );
	
	
      break;  
      
      
    case FS_IOCTL_DISK_READ:
      // low level disk read
      // args: char *name<=drive, int cmd<=FS_IOCTL_DISK_READ, unsigned long arg <=pointer to struct ioctl_disk_rw  
      fs_lldbg(" fs.c:FS_IOCTL_DISK_READ \n");            
      
      if(!arg) { res = EINVAL; break; }			// if no arg, exit...
      
      blk_drv = get_blk_driver(name);			/* fetch block device driver */
      fs_dbg(" blk_driver->0x%x\n",blk_drv);
      
      if(!blk_drv) { 
		fs_lldbgwait(" no blk driver found !\n");
		res = EINVDRV; 
		break;  	// if no driver, exit... 	      		
      }	
      
      physical_drive.pdrv = dn2pdrv(name);		// get physical drive number from drive table via devicename
      
      res = blk_drv->blk_oper->ioctl(&physical_drive,cmd,arg);
			
      break;
      
    case FS_IOCTL_DISK_WRITE:
      // low level disk write
      // args: char *name<=drive, int cmd<=FS_IOCTL_DISK_WRITE, unsigned long arg <=pointer to struct ioctl_disk_rw
      
      fs_lldbg(" fs.c:FS_IOCTL_DISK_WRITE \n");            
      
      if(!arg) { res = EINVAL; break; }			// if no arg, exit...
      
      blk_drv = get_blk_driver(name);			/* fetch block device driver */
      fs_dbg(" blk_driver->0x%x\n",blk_drv);
      
      if(!blk_drv) { 
		fs_lldbgwait(" no blk driver found !\n");
		res = EINVDRV; 
		break;  	// if no driver, exit... 	      		
      }	
      
      physical_drive.pdrv = dn2pdrv(name);		// get physical drive number from drive table via devicename
      
      res = blk_drv->blk_oper->ioctl(&physical_drive,cmd,arg);
      
      break;          
      
    case FS_IOCTL_DISK_INIT: // ************************************* ll disk init *************************************  
      // args: char *name<=devicename, int cmd<=FS_IOCTL_DISK_INIT, unsigned long arg <=NULL
    case FS_IOCTL_DISK_GET_SECTOR_COUNT:
      // args: char *name<=devicename, int cmd<=FS_IOCTL_DISK_GET_SECTOR_COUNT, unsigned long arg <=pointer to DWORD
    case FS_IOCTL_DISK_GET_SECTOR_SIZE:
      // args: char *name<=devicename, int cmd<=FS_IOCTL_DISK_GET_SECTOR_SIZE, unsigned long arg <=pointer to WORD
    case FS_IOCTL_GET_DISK_DRIVE_STATUS:  
      // args: char *name<=devicename, int cmd<=FS_IOCTL_GET_DISK_DRIVE_STATUS, unsigned long arg <=pointer to struct _deviceinfo       
      
      
      fs_lldbgwait(" - FS_IOCTL_DISK_INIT - \n");
      
      if(!name) { 
    		fs_lldbgwait(" error: no name given... \n");
    		res = EINVAL; 
    		break; 
      }			// if no name, exit...
      
      
      // example: name = HDA => block driver name = HD, physical device = A (0)
      
      blk_drv = get_blk_driver(name);
      fs_dbg(" blk_driver->0x%x\n",blk_drv);
      
      if(!blk_drv) { 
		fs_lldbgwait(" no blk driver found !\n");
		res = EINVDRV; 
		break;  }		// if no driver, exit...   
      
      physical_drive.pdrv = dn2pdrv(name);		// get physical drive number from drive table via devicename
      
      res = blk_drv->blk_oper->ioctl(&physical_drive,cmd,arg);
      
      break;
      
//    case NKC_IOCTL_DIR: // ****************************** JADOS directory function call  ******************************
//      // *name = ptr to drive-name, cmd=NKC_IOCTL_DIR, arg = ptr to struct ioctl_nkc_dir)
//      #ifdef CONFIG_DEBUG_FS
//      strncpy(dbgstr,name,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;
//      fs_dbg("fs.c: name = %s, cmd = %d, arg = 0x%x\n",dbgstr,cmd,arg);
//      fs_lldbgwait("fs.c: - NKC_IOCTL_DIR - \n");
//      #endif
//
//      strcpy(tmp,(char*)name); strcat(tmp,":");
//      res=checkfp(tmp, &FPInfo); // analyze drive name   
//     
//      if(res == EINVDRV){
//		fs_lldbgwait("fs.c: error in name ...\n");
//		break;
//      }
//      
//      
//      pfstab = get_fstabentry(FPInfo.psz_driveName);
//	
//      if(pfstab == NULL) {
//	  fs_lldbgwait("fs.c: NKC_IOCTL_DIR:  no entry in fstab found !\n");
//	  return 0;
//      }
//	
//      pfsdriver = pfstab->pfsdrv; 
// 		
//      
//      if(!pfsdriver) {  // if no driver, exit...
//		res = EINVDRV; 
//		fs_lldbgwait(" fs.c: .... no driver found\n");
//		break;  	
//	  }
//      
//       if(pfsdriver->f_oper->ioctl) {	
//		((struct ioctl_nkc_dir*)arg)->pfstab = pfstab;  // add fstab information 
//		res = pfsdriver->f_oper->ioctl(pfstab,cmd,arg);	// is ioctl valid ? -> call it
//	      }else{
//		fs_lldbgwait(" ioctl not valid !\n");
//      }            
//      
//      break;
    
//   case FAT_IOCTL_INFO: // ****************************** FAT INFO  ******************************
//     pfsdriver = get_driver((char*)arg);     // file system driver
//     
//     if(!pfsdriver) return ENODRV;
//     
//     res = pfsdriver->f_oper->ioctl(NULL,FAT_IOCTL_INFO,NULL);
//     break;
    
    default:	
      fs_dbg("fs-ioctl default...\n");
      pfsdriver = NULL;
      if(name == NULL && cmd > 100) { // unspecified FAT_IOCTL
  		  fs_dbg("error, unspecified FAT_IOCTL (name = 0x%0x, cmd = %d...\n",name,cmd);
  		  fs_lldbgwait("");
  		  return FR_INVALID_PARAMETER;	  	 	
      }	else {
    		fs_lldbgwait("look for fs driver in fstab ...\n");
    		if(name == NULL) {
    		  fs_lldbgwait("error, inavalid parameter (name == NULL) ...\n");
    		  return FR_INVALID_PARAMETER;     			
    	  }
  	
		    pfstab = get_fstabentry(name);
	      
  	    if(!pfstab){
  		  // error drive not mounted...
  	      #ifdef CONFIG_DEBUG_FS
  	      strncpy(dbgstr,name,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;
  		  fs_dbg("error, no filesystem found for specified drive (%s)...\n",dbgstr);
  		  #endif
  		  res = EINVDRV;
  		  break;
	    } 
      
    	   pfsdriver = pfstab->pfsdrv;  		// pointer to file system driver
	
      }
      
      if(pfsdriver == NULL) return FR_NO_DRIVER;      
      fs_dbg(" found,calling drivers ioctl at 0x%0lx  (KEY)",pfsdriver->f_oper->ioctl);
      fs_lldbgwait("\n");
      if(pfsdriver->f_oper->ioctl) {
	
		res = pfsdriver->f_oper->ioctl(pfstab,cmd,arg);	// is ioctl valid ? -> call it
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
 *   	
 *		pname		- name of filesystem (NKC,FAT32...)
 *		f_oper		- pointer to file operations
 *
 * Return:
 *		EZERO - success   
 *
 ****************************************************************************/
int register_driver( char *pname, const struct file_operations  *f_oper)
{
	struct fs_driver *pfsdriver, *ptail;
	
	#ifdef CONFIG_DEBUG_FS
    strncpy(dbgstr,pname,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;
	fs_lldbg("fs.c: [ register_driver...\n");
	fs_dbg(" name: %s\n",dbgstr);
	fs_dbg(" foper: 0x%x\n",f_oper);
	fs_dbg(" open: 0x%x\n",f_oper->open);
	#endif

	if(get_driver(pname)){ // error: driver for this filesystem already registered
	  fs_lldbgwait("driver already registered ! \n....register_driver ]\n");
	}
	
	/*
		allocate all buffers
	*/		
	pfsdriver = (struct fs_driver *)malloc(sizeof(struct fs_driver));
	
	if(!pfsdriver){
	  fs_lldbgwait("error allocationg memory for 'struct fs_driver' !\n....register_driver ]\n");
	  return ENOMEM;
	}
	
	pfsdriver->pname = (char *)malloc(strlen(pname)+1);
	
	if(!pfsdriver->pname){
	  fs_lldbgwait("error allocationg memory for 'pfsdriver->pnamer' !\n....register_driver ]\n");
	  free(pfsdriver);
	  return ENOMEM;
	}
	
	
	strcpy(pfsdriver->pname, pname);
	pfsdriver->f_oper = f_oper;
	pfsdriver->next = NULL;
			
		
	if(driverlist == NULL){
		fs_lldbg(" initializing driverlist (1st driver)...\n");
		driverlist = pfsdriver;
	}else{
		fs_lldbg(" adding driver to driverlist ...\n");
		ptail = driverlist;
		while(ptail->next) ptail = ptail->next;
		ptail->next = pfsdriver;
	}			
		
	#ifdef CONFIG_DEBUG_FS
    strncpy(dbgstr,pfsdriver->pname,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;	
	fs_dbg(" name:  %s\n",dbgstr);
	fs_dbg(" foper: 0x%x\n",pfsdriver->f_oper);
	fs_dbg(" open: 0x%x\n",pfsdriver->f_oper->open);
	fs_lldbgwait("....register_driver ]\n");
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
 *   	pdrive		- name of fs (FAT32,JADOS....)
 *
 * Return:
 *		EZERO - success   
 *
 ****************************************************************************/

int un_register_driver(char *pname)
{
  struct fs_driver *pcur, *plast;
  		
  pcur = plast = driverlist;
  
  while(pcur)
  {
  	if(!strcmp(pcur->pname,pname)) 		
  	{ // found drive
  	  if(pcur == driverlist) 
  	  	driverlist = driverlist->next;
  	  else  	  
  	  	plast->next = pcur->next;
  	  	  
  	  free(pcur->pname);
  	  free(pcur);
  	  
  	  return EZERO;
  	}
  	
  	plast = pcur;
  	pcur = pcur->next;
  	
  }		
  	
  	
  return EINVDRV; /* Invalid drive specified  */
}

/****************************************************************************
 * Name: mountfs
 *
 * Description:
 *   mount a file system.
 *
 * Parameters:
 *   	devicename	- name of device (A,B...,HDA1, HDA2....)
 * 		fsname		- name of filesystem
 *		options 	- FS_MOUNT_DELAY, FS_MOUNT_IMMEDIATE
 *
 * Return:
 *		FR_OK - success   
 *
 ****************************************************************************/
FRESULT mountfs(char *devicename, char* fsname, MOUNTOPTS options)
{
    FRESULT fres;
    struct fstabentry* pfstab;
    struct fs_driver *pfsdriver;
    
    fs_dbg("fs.c|mountfs: ...\n");
    
    if(get_fstabentry(devicename)){  // errorhandling: device already mounted !
      fs_dbg("fs.c|mountfs:  %s already mounted !\n",devicename);
      return FR_EXIST; // ignore this error...
    }
    
    fres = add_fstabentry(devicename,fsname,options);
    
    if(fres == FR_OK) {      
		  pfstab = get_fstabentry( devicename );	// get fstabentry
		
		if(!pfstab) {
		  #ifdef CONFIG_DEBUG_FS
	      strncpy(dbgstr,devicename,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;	
		  fs_dbg("fs.c|mountfs: error adding entry for %s in fstab !",dbgstr); 
		  fs_lldbgwait("\n");
		  #endif
		  remove_fstabentry(devicename);
		  return FR_NO_FILESYSTEM;
	}
	
	pfsdriver = pfstab->pfsdrv;
	#ifdef CONFIG_DEBUG_FS
  strncpy(dbgstr,pfstab->devname,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;
	fs_dbg("fs.c|mountfs: calling ioctrl with fstabentry:\n");
	fs_dbg("  devname = %s\n",dbgstr);
	fs_dbg("  phydrv  = %d\n",pfstab->pdrv);
	fs_dbg("  fsdrv   = 0x%x\n",pfstab->pfsdrv);
	fs_dbg("  blkdrv  = 0x%x\n",pfstab->pblkdrv);
	fs_dbg("  part    = %d\n",pfstab->partition);
	fs_dbg("  extended= %d\n",pfstab->extended);
  fs_dbg("  extpart = %d\n",pfstab->extpart);
	fs_dbg("  pFS     = 0x%x\n",pfstab->pfs);	
	fs_dbg("  options = %d",pfstab->options);
	fs_lldbgwait(" (KEY)\n");
	#endif
	fres = pfsdriver->f_oper->ioctl(NULL,FS_IOCTL_MOUNT,pfstab);		// call fs device driver ioctl with fstabentry
	
	
	switch(fres){
	  case FR_OK: break;
	  case FR_NO_FILESYSTEM: 
	    fs_lldbgwait("fs.c|mountfs: FR_NO_FILESYSTEM (13) => use f_mkfs !! \n");
	    remove_fstabentry(devicename);
	    break;
	  default:	
		fs_dbg("fs.c|mountfs: error %d",fres); fs_lldbgwait("\n");
		remove_fstabentry(devicename);
	}    
    }
    
    fs_dbg("fs.c|mountfs: fs_id = %d\n",((FS*)pfstab->pfs)->fs_id);
    return fres;
}


/****************************************************************************
 * Name: umountfs
 *
 * Description:
 *   umount a file system.
 *
 * Parameters:
 *   	devicename	- name of device (A,B...,HDA1, HDA2....)
 *
 * Return:
 *		FR_OK - success   
 *
 ****************************************************************************/
FRESULT umountfs(char *devicename)
{
  struct fstabentry *entry;
  FRESULT fres;
  
  #ifdef CONFIG_DEBUG_FS
  strncpy(dbgstr,devicename,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;
  fs_dbg("fs.c|umountfs device = %s ...\n",dbgstr);
  #endif
  
  if(entry = get_fstabentry(devicename)){     
    
     // call fs device driver ioctl with drivename
     fs_dbg("fs.c|umountfs: found fstabentry, calling fs drivers ioctl ...\n");
     fres = entry->pfsdrv->f_oper->ioctl(NULL,FS_IOCTL_UMOUNT,entry);
     remove_fstabentry(devicename);     
     
     return fres;   
  }
    
  return FR_INVALID_DRIVE; /* Invalid device specified  */
}


/****************************************************************************
 * Name: get_fstabentry
 *
 * Description:
 *   get a file system by device name.
 *
 * Parameters:
 *   	devname - name of device (A,B...,HDA1, HDA2....)
 *
 * Return:
 *		EZERO - success   
 *
 ****************************************************************************/

struct fstabentry* get_fstabentry(char* devname)
{
  struct fstabentry *pcur;
  char* tc;
  int i=0;
  
  #ifdef CONFIG_DEBUG_FS
  strncpy(dbgstr,devname,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;  
  fs_dbg(" fs.c|get_fstabentry: (%s)\n",dbgstr);
  #endif

  pcur = fstab;
  
  /* remove path information from given devname ... */
  tc = malloc(strlen(devname)+1);
  if(!tc) {
    fs_dbg(" fs.c|get_fstabentry: error in malloc !!\n");    
    return NULL;
  }
  
  strcpy(tc,devname);
  while(IsAlphaNum(tc[i])){
    i++;
    if(i > 255){
      fs_dbg(" fs.c|get_fstabentry: error in devname !!\n");
      free(tc);
      return NULL;
    }
  }
  tc[i]=0;
  
  #ifdef CONFIG_DEBUG_FS
  strncpy(dbgstr,tc,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;
  fs_dbg(" fs.c|get_fstabentry: search for '%s'...\n",dbgstr);
  #endif
  
  while(pcur)
  {
  	#ifdef CONFIG_DEBUG_FS
  	strncpy(dbgstr,pcur->devname,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;
    fs_dbg("  current = '%s'\n",dbgstr);
    #endif

  	if(!strcmp(pcur->devname,tc))
  	{ // found device 

  	  #ifdef CONFIG_DEBUG_FS
  	  strncpy(dbgstr,pcur->devname,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;	
	  fs_dbg(" fs.c|get_fstabentry:  (SUCCESS) volume found.\n");
	  
	  fs_dbg("     pfstab  = 0x%x\n",pcur);
	  fs_dbg("     devname = %s\n",dbgstr);
	  strncpy(dbgstr,pcur->pfsdrv->pname,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;
	  fs_dbg("     fsname  = %s\n",dbgstr);
	  fs_dbg("     phydrv  = %d\n",pcur->pdrv);
	  fs_dbg("     (fs)drv = 0x%x, foper = 0x%x, open = 0x%x\n",pcur->pfsdrv,pcur->pfsdrv->f_oper,pcur->pfsdrv->f_oper->open);
	  fs_dbg("     pblkdrv = 0x%x\n",pcur->pblkdrv);
	  fs_dbg("     options = 0x%x\n",pcur->options);
	  fs_dbg("     part    = %d\n",pcur->partition);
	  fs_dbg("     pFS     = 0x%x\n",pcur->pfs);
	  fs_dbg("     next    = 0x%x\n",pcur->next);
	  fs_lldbgwait("           ....(KEY)\n");
	  #endif

	  free(tc);
  	  return pcur;
  	}
  	
  	pcur = pcur->next;
  }		
   
  fs_dbg(" fs.c|get_fstabentry: (FAILED) volume not found\n");  
  free(tc);
  return NULL; /* Invalid device specified  */
}

/****************************************************************************
 * Name: add_fstabentry
 *
 * Description:
 *   add an entry to the file system table.
 *
 * Parameters:
 *   	volume		- name of volume (A,B...,HDA1, HDA2....)
 *      fsname		- name of filesystem (FAT32, JADOS ...)
 * 		options     - mount options (FS_MOUNT_DELAY, FS_M OUNT_IMMEDIATE, ....)
 *
 * Return:
 *		FR_OK - success   
 *
 ****************************************************************************/
FRESULT add_fstabentry(char *volume, char* fsname, MOUNTOPTS options)
{
    struct blk_driver *pblk_drv;
    struct fs_driver *pfs_drv;
    char* pdevname;
    char* pfsname;
    struct fstabentry *pfstab, *ptail;   
    
    #ifdef CONFIG_DEBUG_FS
	  strncpy(dbgstr,volume,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;
	  strncpy(dbgstr1,fsname,DBGSTR_LEN); dbgstr1[DBGSTR_LEN]=0;		
    fs_dbg("add_fstabentry %s - %s ...\n",dbgstr,dbgstr1);
    #endif
    
    pfs_drv = get_driver(fsname);     // file system driver
    pblk_drv = get_blk_driver(volume);// block device driver
    
    if(!pfs_drv) { // errorhandling
      #ifdef CONFIG_DEBUG_FS
  	  strncpy(dbgstr,fsname,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;		
      fs_dbg("error no filesystem driver found for %s ...\n",dbgstr);
      #endif
      return FR_NO_FILE;
    }
    
    if(!pblk_drv) {  // errorhandling
      #ifdef CONFIG_DEBUG_FS
  	  strncpy(dbgstr,volume,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;		
      fs_dbg("error no block device driver driver found for %s ...\n",dbgstr);
      #endif
      return FR_INVALID_DRIVE;
    }
    
    pfstab = (struct fstabentry *)malloc(sizeof(struct fstabentry));
    
    if(!pfstab) { // errorhandling
      fs_dbg("error: no memory for fstabentry\n");
      return FR_NOT_ENOUGH_CORE;
    }
    
    pdevname = (char*)malloc(strlen(volume)+1);
    
    if(!pdevname) { // errorhandling
      fs_dbg("error: no memory for devicename\n");
      free(pfstab);
      return FR_NOT_ENOUGH_CORE;
    }
                
    strcpy(pdevname,volume);
    
    pfstab->devname = pdevname;
    pfstab->pfsdrv = pfs_drv;
    pfstab->pblkdrv = pblk_drv;
    pfstab->options = options;
    pfstab->pdrv = dn2pdrv(volume);
    pfstab->next = NULL;
    pfstab->partition = dn2part(volume);
    pfstab->extended = dn2extended(volume);
    pfstab->extpart = dn2expart(volume);
    pfstab->pfs = NULL;
    pfstab->start_sector = 0;
    
    #ifdef CONFIG_DEBUG_FS
  	strncpy(dbgstr,pfstab->devname,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;	
    fs_dbg("pfstab->volume = %s\n",dbgstr);
    fs_dbg("pfstab->pfsdrv = 0x%x\n",pfstab->pfsdrv);
    fs_dbg("pfstab->pblkdrv = 0x%x\n",pfstab->pblkdrv);
    fs_dbg("pfstab->options = %d\n",pfstab->options);
    fs_dbg("pfstab->pdrv = %d\n",pfstab->pdrv);
    fs_dbg("pfstab->partition = %d\n",pfstab->partition);
    fs_dbg("pfstab->pfs = 0x%x\n",pfstab->pfs);
    #endif
    
    if( (pfstab->pdrv == -1 || pfstab->partition == -1)) {

      fs_dbg("error: invalid drive specified\n");
      free(pfstab);
      return FR_INVALID_DRIVE;
    }
    
    if(fstab == NULL) {
      fs_dbg("1st entry in fstab ....\n");
		fstab = pfstab;
    }else{
  		ptail = fstab;
  		while(ptail->next) ptail = ptail->next;
  		ptail->next = pfstab;
	  }
	
	
    fs_lldbgwait("add_fstabentry: success (KEY)\n");
    return FR_OK;
}

/****************************************************************************
 * Name: remove_fstabentry
 *
 * Description:
 *   remove an entry from the file system table.
 *
 * Parameters:
 *   	devname	- name of device (A,B...,HDA1, HDA2....)
 *
 * Return:
 *		FR_OK - success   
 *
 ****************************************************************************/
FRESULT remove_fstabentry(char* devname)
{
  struct fstabentry *pcur, *plast;
  			
  fs_dbg("remove_fstabentry for %s...\n",devname);
  
  pcur = plast = fstab;
  
  while(pcur)
  {
  	if(!strcmp(pcur->devname,devname))
  	{ // found entry   
  	  fs_dbg(" entry found: removing ...\n");
	  if(pcur == fstab) {
	    fstab = fstab->next;
	  } else {	    
  	    plast->next = pcur->next;  	  	  	  
	  }
	  
  	  free(pcur->devname);
  	  free(pcur);
  	  
  	  return FR_OK;
  	}
  	
  	plast = pcur;
  	pcur = pcur->next;
  }		

  fs_dbg(" entry not found !\n");  
  return FR_INVALID_NAME; /* Invalid device specified  */
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
	
	// allocate some memory ...
	FPInfo.psz_driveName = (char*)malloc(_MAX_DRIVE_NAME); if(FPInfo.psz_driveName == 0) exit(ENOMEM); // exit with fatal error !!
	FPInfo.psz_deviceID = (char*)malloc(_MAX_DEVICE_ID);   if(FPInfo.psz_deviceID == 0) exit(ENOMEM);
	FPInfo.psz_path = (char*)malloc(_MAX_PATH); if(FPInfo.psz_path == 0) exit(ENOMEM); 
	FPInfo.psz_filename = (char*)malloc(_MAX_FILENAME); if(FPInfo.psz_filename ==0 ) exit(ENOMEM);
	FPInfo.psz_fileext = (char*)malloc(_MAX_FILEEXT); if(FPInfo.psz_fileext == 0 ) exit(ENOMEM);
	FPInfo.psz_cdrive = (char*)malloc(_MAX_DRIVE_NAME); if(FPInfo.psz_cdrive == 0 ) exit(ENOMEM);
	FPInfo.psz_cpath = (char*)malloc(_MAX_PATH); if(FPInfo.psz_cpath == 0 ) exit(ENOMEM); 		
    FPInfo.psz_cdrive[0] = '?';					
	FPInfo.psz_cdrive[1] = 0;	// current drive name, i.e. where the program was started : A,B, HDA1 etc
	FPInfo.psz_cpath[0] = 0;	// current path name; for jados this is empty or '/'
	FPInfo.psz_wcard = (char*)malloc(_MAX_PATH); if(FPInfo.psz_wcard == 0 ) exit(ENOMEM);
	FPInfo.b_has_wcard = 0;
  	
 	fs_dbg("fs.c:  FPInfo.psz_cdrive = %s",FPInfo.psz_cdrive); 
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
int _ll_open(char *name, int flags)             
/*
 * open an existing file, return handle
  name = [LW:][path]filename.ext
  flags = 0(read), 1(write), 2(read/write) - (translated by _ll_flags)
        + _F_CREATE (0x0800) if called through _ll_creat
 *************************************************************************/            
{
	struct _file *pfile,*pcf,*plf;	
	struct fs_driver *pfsdriver;	
	struct fstabentry* pfstabentry;
   	int fd,res,i;
	char* pname;	
	char tmp[255];
   	UINT indx = NUM_FILE_HANDLES;
   	
   	#ifdef CONFIG_DEBUG_FS
  	strncpy(dbgstr,name,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;	
	fs_dbg("fs.c: _ll_open: name=%s, flags=0x%x",dbgstr,flags); fs_lldbgwait("\n");
	#endif
	
	/*
		initialize string variables
	*/	
	
	res=checkfp(name, &FPInfo);
    
    #ifdef CONFIG_DEBUG_FS
  	strncpy(dbgstr,name,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;
	fs_dbg("fs.c: _ll_open:  name = %s\n",dbgstr);
	fs_dbg("fs.c: _ll_open:  drive is: %s\n",FPInfo.psz_driveName);
	fs_dbg("fs.c: _ll_open:  path = %s\n",FPInfo.psz_path);
	fs_dbg("fs.c: _ll_open:  filename = %s%c%s\n",FPInfo.psz_filename,FPInfo.c_separator,FPInfo.psz_fileext);	
	fs_lldbgwait("\n");	
	#endif

	if(res != EZERO) {
	  #ifdef CONFIG_DEBUG_FS
  	  strncpy(dbgstr,name,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;	
	  fs_dbg("fs.c: _ll_open:  error in filename %s\n",dbgstr);
	  #endif
	  return res;
	}
	
   	/*
   		get fs driver for this drive (search for the drive used..)
   	*/
	
	pfstabentry = get_fstabentry(FPInfo.psz_driveName);
	
	if(pfstabentry == NULL) {
	  fs_lldbgwait("fs.c: _ll_open:  no entry in fstab found !\n fs.c: ...._ll_open ]\n");
	  return 0;
	}
	
   	/*
   		check if file is already open
   	*/
	
	// build fullpath ...
	tmp[0] = 0;
	strcat(tmp,FPInfo.psz_driveName);
	strcat(tmp,":");
	strcat(tmp,FPInfo.psz_path);
	strcat(tmp,FPInfo.psz_filename);
	strncat(tmp,&FPInfo.c_separator,1);
	strcat(tmp,FPInfo.psz_fileext);
	
	for(i = 0; i<NUM_FILE_HANDLES;i++)
	{
	   pfile = filelist[i];
	   
	   if(pfile)
	   {
	   	    	    
		if( !strcmp(pfile->pname,tmp) )
		{

			if(flags & _F_CREATE)
	    	{		    		
	    		fs_dbg("fs.c: _ll_open:  cannot create already open file...\n");
	    		fs_dbg("pfile->pname= %s\n",pfile->pname);
	    		fs_dbg("fullpath= %s",tmp);
	    		fs_lldbgwait("\n");	    		
	    		return 0;
	    	} 
		
			/* this file is already open, we can open it read only */
			flags &= ~_F_WRIT;
			flags |=  _F_READ;
			fs_lldbgwait("fs.c: _ll_open: file is already open -> set RDONLY\n");
		}		
	   } 
	}
		
	/*
		Try to allocate file hanlde
	*/		
   	fd = alloc_handle();
   	
   	if(fd == 255) /* no more free handle ! */
	{	
		gp_write("fs.c: _ll_open:  no more free file handles in _ll_open\n");
		free_handle(fd);		
		return 0;
	}
	
	/*
		allocate all buffers
	*/
	pfile = (struct _file *)malloc(sizeof(struct _file));
	pname = (char*)malloc(strlen(tmp)+1);
	
	if( !pfile || !pname)
	{
		gp_write(" error malloc in fs.c: _ll_open\n");
		free(pfile);
		free(pname);
		free_handle(fd);
		return 0;
	}
	
	/*
		fill _file structure ...
	*/
	
	if(	!strcpy(pname,tmp) )
	{
		gp_write(" error strcpy in fs.c: _ll_open\n");
		free(pfile);
		free(pname);
		free_handle(fd);
		return 0;
	}
	
	
	pfile->pname = pname;
	pfile->fd = fd;
	pfile->f_pos = 0;
	pfile->f_oflags = flags;

	pfile->p_fstab = pfstabentry;

	
	fs_dbg("fs.c: _ll_open:  foper: 0x%x\n",pfile->p_fstab->pfsdrv->f_oper);
	fs_dbg("fs.c: _ll_open:  open: 0x%x\n",pfile->p_fstab->pfsdrv->f_oper->open);
	fs_lldbgwait("fs.c: _ll_open:  call pfile->f_oper->open ...\n");
	
	res = pfile->p_fstab->pfsdrv->f_oper->open(pfile);
	
	fs_dbg("fs.c: _ll_open:  pfile->f_oper->open(pfile) returned %d\n",res);
	
	if(res != EZERO)
	{
		free(pfile);
		free(pname);
		free_handle(fd);
		fs_lldbgwait("fs.c: ..._ll_open FAILED ]\n");
		return 0;
	}

	filelist[fd] = pfile;
	
	fs_dbg("fs.c: _ll_open:  foper: 0x%x\n",pfile->p_fstab->pfsdrv->f_oper);
	fs_dbg("fs.c: _ll_open:  open: 0x%x\n",pfile->p_fstab->pfsdrv->f_oper->open);
	
	fs_lldbgwait("fs.c: ..._ll_open SUCCESS]\n");
	
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
  #ifdef CONFIG_DEBUG_FS
  strncpy(dbgstr,name,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;	
  fs_dbg("fs.c: _ll_open: name=%s, flags=0x%x",dbgstr,flags); fs_lldbgwait("\n");	
  fs_dbg("fs.c: _ll_creat (%s)...\n",dbgstr);
  #endif
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
   	
	fs_lldbgwait("fs.c: [ _ll_close....\n");
	
   	pfile = filelist[fd];
   	if(!pfile) return;
   	
	fs_lldbg("fs.c: call pfile->f_oper->close\n");
	
	res = pfile->p_fstab->pfsdrv->f_oper->close(pfile);
	
	if(res != EZERO)
	{
		gp_write("fs.c:  error [ ");
		gp_write_dec_dw(res);
		gp_write(" ] f_ops->close() in _ll_lose\n");
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
 *      number of bytes read or 
 *     -1 if error
 *
 ****************************************************************************/
int __ll_read(int fd, void *buf, int size)	
{
	struct _file *pfile;	
   	int res;
   	
	fs_lldbgwait("fs.c: [ _ll_read....\n");
	
   	if(fd<10) return; // FIXME: besser wäre es, die stdio's auch in die filelist aufzunehmen ...
   					  // das wird z.Z. in llstd.S abgehandelt, die Routinen könnte man wie jedes andere FS einhängen
   	
   	pfile = filelist[fd];
   	if(!pfile) return ENOFILE;
   	
   	res = pfile->p_fstab->pfsdrv->f_oper->read(pfile,buf,size);

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
 *   number of written bytes or 
 *   -1 if error
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
   	
   	res = pfile->p_fstab->pfsdrv->f_oper->write(pfile,buf,size);

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
   		
   	res = pfile->p_fstab->pfsdrv->f_oper->seek(pfile,pos,origin);
	
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
   	
   	res = pfile->p_fstab->pfsdrv->f_oper->getpos(pfile);

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
	struct fs_driver *pfsdriver;
   	int fd,res,i;
   	char *pname;
	struct fstabentry*  pfstab;
	struct fpinfo FPInfoOld;
	
    #ifdef CONFIG_DEBUG_FS
  	strncpy(dbgstr,old,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;
  	strncpy(dbgstr1,new,DBGSTR_LEN); dbgstr1[DBGSTR_LEN]=0;
	fs_dbg("fs.c|_ll_rename: %s -> %s\n",dbgstr,dbgstr1);
	#endif
	
	// allocate some memory ...
    FPInfoOld.psz_driveName = (char*)malloc(_MAX_DRIVE_NAME);  if(FPInfoOld.psz_driveName == 0) exit(1); // exit with fatal error !!
    FPInfoOld.psz_deviceID = (char*)malloc(_MAX_DRIVE_NAME);   if(FPInfoOld.psz_deviceID == 0) exit(1);
    FPInfoOld.psz_path = (char*)malloc(_MAX_PATH);       if(FPInfoOld.psz_path == 0) exit(1); 
    FPInfoOld.psz_filename = (char*)malloc(_MAX_FILENAME);   if(FPInfoOld.psz_filename ==0 ) exit(1);
    FPInfoOld.psz_fileext = (char*)malloc(_MAX_FILEEXT);    if(FPInfoOld.psz_fileext == 0 ) exit(1);
    FPInfoOld.psz_cdrive = (char*)malloc(_MAX_DRIVE_NAME);     if(FPInfoOld.psz_cdrive == 0 ) exit(1);
    FPInfoOld.psz_cpath = (char*)malloc(_MAX_PATH);      if(FPInfoOld.psz_cpath == 0 ) exit(1);
    FPInfoOld.psz_wcard = (char*)malloc(_MAX_PATH);      if(FPInfoOld.psz_wcard == 0 ) exit(1);
    strcpy(FPInfoOld.psz_cdrive,FPInfo.psz_cdrive);
    strcpy(FPInfoOld.psz_cpath,FPInfo.psz_cpath);
   
	res=checkfp(old, &FPInfoOld);
	
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
			res = EACCES;
			goto __LL_RENAME_END;
			return EACCES; /* Permission denied        */
		}		
	   } 
	}
 	/*
   		get driver for this drive
   	*/
   	
	pfstab = get_fstabentry(FPInfo.psz_driveName);
	
	if(pfstab == NULL) {
	  fs_lldbgwait(":  no entry in fstab found !\n");
	  res = 0;
	  goto __LL_RENAME_END;
	  return 0;
	}
	
	pfsdriver = pfstab->pfsdrv; 
	
   	
   	if(pfsdriver == NULL) { /* no driver registered */
	  res = ENODRV;
	  goto __LL_RENAME_END;
	  return ENODRV; 
	}
			
	/*
		Try to allocate file hanlde
	*/		
   	fd = alloc_handle();
   	
   	if(fd == 255) /* no more free handle ! */
	{	
		gp_write(" no more free file handles in _ll_rename\n");
		free_handle(fd);
		res = EMFILE;
		goto __LL_RENAME_END;		
		return EMFILE;
	}
	
	/*
		allocate all buffers
	*/
	pfile = (struct _file *)malloc(sizeof(struct _file));
	pname = (char*)malloc(strlen(old)+1);
	
	if( !pfile || !pname)
	{
		gp_write(" error malloc in _ll_rename\n");
		free(pfile);
		free(pname);
		free_handle(fd);
		res = ENOMEM;
		goto __LL_RENAME_END;
		return ENOMEM;
	}
	

	/*
		fill _file structure ...
	*/
	
	// FIXME: muss das Kopieren sein ?
	if(	!strcpy(pname,old) )
	{
		gp_write(" error strcpy in _ll_rename\n");
		free(pfile);
		free(pname);
		free_handle(fd);
		res = ERROR;
		goto __LL_RENAME_END;
		return ERROR;
	}
	
	
	pfile->pname = pname;
	pfile->fd = fd;
	pfile->f_pos = 0;
	pfile->f_oflags = 0;
	
	/* hier fs abhängige file operations einhängen (laut Registrierung) */
	pfile->p_fstab = pfstab;

	res = pfile->p_fstab->pfsdrv->f_oper->rename(pfile,old,new);
	
	if(res != EZERO)
	{
		gp_write(" error renaming file\n");
	}

	
	free(pname);
	free(pfile);
	free_handle(fd);
	
__LL_RENAME_END:
	free( FPInfoOld.psz_driveName);
    free( FPInfoOld.psz_deviceID);
    free( FPInfoOld.psz_path);
    free( FPInfoOld.psz_filename);
    free( FPInfoOld.psz_fileext);
    free( FPInfoOld.psz_cdrive);
    free( FPInfoOld.psz_cpath);
    free( FPInfoOld.psz_wcard);
		
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
{
	struct _file *pfile;	
	struct fs_driver *pfsdriver;
   	int fd,res,i;
   	char *pname;
	struct fstabentry*  pfstab;
	FRESULT fres;
	
	#ifdef CONFIG_DEBUG_FS
  	strncpy(dbgstr,name,DBGSTR_LEN); dbgstr[DBGSTR_LEN]=0;
	fs_dbg("fs.c|_ll_remove: %s\n",dbgstr);
	#endif
    
    res=checkfp(name, &FPInfo);  if( res != EZERO) return res; // wird benötigt wg. get_fstabentry ...
          
   	   	
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
   		get driver for this device
   	*/

	pfstab = get_fstabentry(FPInfo.psz_driveName);
	
	if(pfstab == NULL) {
	  fs_lldbgwait("fs.c|_ll_remove:  no entry in fstab found !\n");
	  return 0;
	}
	
	pfsdriver = pfstab->pfsdrv; 
   	
   	if(pfsdriver == NULL){   /* no driver registered */
	  fs_lldbgwait("fs.c|_ll_remove:  no fs driver found !\n");
	  return ENODRV; 
	}
			
	/*
		Try to allocate file hanlde
	*/		
   	fd = alloc_handle();
   	
   	if(fd == 255) /* no more free handle ! */
	{	
		gp_write("fs.c|_ll_remove:  no more free file handles\n");
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
		gp_write("fs.c|_ll_remove: error malloc\n");
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
		gp_write("fs.c|_ll_remove: error strcpy\n");
		free(pfile);
		free(pname);
		free_handle(fd);
		return ERROR;
	}
	
	
	pfile->pname = pname;
	pfile->fd = fd;
	pfile->f_pos = 0;
	pfile->f_oflags = 0;
	pfile->p_fstab = pfstab;
	
	pfile->p_fstab->pfsdrv = pfsdriver;
	
	fres = pfile->p_fstab->pfsdrv->f_oper->remove(pfile);
	
	if(fres != FR_OK)
	{
		gp_write(" error removing file\n");
	}
	
	switch(fres) {
	  case FR_DISK_ERR:	res = EIO; break;
	  case FR_NO_FILE:  	res = ENOFILE; break;
	  case FR_NO_PATH:	res = ENOPATH; break;
	  case FR_INVALID_NAME: res = EINVFMT; break;
	  default: res = fres;
        }

	
	free(pname);
	free(pfile);
	free_handle(fd);
		
	return res;	
}


