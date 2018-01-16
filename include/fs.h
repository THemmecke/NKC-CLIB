#ifndef __INCLUDE_FS_H
#define __INCLUDE_FS_H

#include <errno.h>
#include "../fs/fat/ffconf.h"
#include <drivers.h>


/*
	This is the _file structure used by the fs subsystem.
	It differs from FILE structure in the CLIB (it is used inside the CLIB itself).
*/
struct _file
{
  int                 f_oflags; 	 /* Open mode flags */
  int             		f_pos;    	 /* File position */
  struct fstabentry		*p_fstab;	   /* pointer to related fstab entry */
  int				          fd;		       /* file handle */
  struct _file 			  *next;		   /* pointer to next file in list */	
  char				        *pname;      /* filename with LW,path,name and extension  (fullpath) */
  void         			  *private;    /* file private data -> for example: pointer to jados fileinfo or fcb (if not using JADOS calls) */

};

struct file_operations
{
 
  int     (*open)(struct _file *filp);
  int     (*close)(struct _file *filp);
  int     (*read)(struct _file *filp, char *buffer, int buflen);
  int     (*write)(struct _file *filp, const char *buffer, int buflen);
  int     (*seek)(struct _file *filp, int offset, int whence);
  int     (*ioctl)(struct _file *filp, int cmd, unsigned long arg);
  int     (*remove)(struct _file *filp);
  int     (*getpos)(struct _file *filp);


 /* Directory operations */
 /*        "struct fs_dirent_s" from Nuttx chanched to "void" (maybe we will not need that structure here...) */

  int     (*opendir)(struct _file *filp, const char *relpath, void *dir);
  int     (*closedir)(struct _file *filp, void *dir);
  int     (*readdir)(struct _file *filp, void *dir);
    
 
 /* Path operations */
  int     (*mkdir)(struct _file *filp, const char *relpath);
  int     (*rmdir)(struct _file *filp, const char *relpath);
  int     (*rename)(struct _file *filp, const char *oldrelpath, const char *newrelpath);

};



struct fs_driver
{
	char 				            *pname;		/* name of filesystem (FAT,FAT32,NKC...) */
	struct file_operations 	*f_oper;	/* file operations */
	struct fs_driver		    *next;		/* pointer to next driver in driverlist */
};

struct fs_driver* get_driver(char *name);


/* file system table entry */

#define FS_READ  1
#define FS_WRITE 2
#define FS_RW	 3


typedef enum {
  FS_TYPE_FAT = 1,
  FS_TYPE_JADOS  
} FSTYPE;

/* used in filesystem structures (e.g. in ff.h, FATFS) as first entry to recognize filesystem type */
typedef struct {
        FSTYPE	fs_id;	
} FS;


struct fstabentry
{
  char* devname;			/* devicename A, B ,HDA0 , HDB1... */   
  int pdrv;				/* physical drive number */  
  struct fs_driver	*pfsdrv;	/* pointer to file system driver */
  struct blk_driver 	*pblkdrv;	/* pointer to block device driver */ 
  int 			partition;	/* partition number (0...3) */
  void			*pfs;		/* pointer to the file system FATFS for example, type can be retreived from pfsdrv->pname */
  unsigned char options;		/* mount options */
  struct fstabentry* next;		/* pointer to next fstab entry */
};

struct fstabentry* get_fstabentry(char* devicename);

FRESULT add_fstabentry(char *devicename, char* fsname, unsigned char options);
FRESULT remove_fstabentry(char* devicename);

FRESULT mountfs(char *devicename, char* fsname, unsigned char options);
FRESULT umountfs(char *devicename);

int dn2part(char* devicename);
int dn2pdrv(char* devicename);

/* fs_registerdriver.c ******************************************************/

int register_fs_driver( char *pname, 				/* name of the filesystem, e.g. JADOSFS for NKC or FAT32 for IDE    */
		     const struct file_operations  *f_oper) ;   /* pointer to the file_operations structure to handle this fs       */
                           
/* fs_unregisterdriver.c ****************************************************/

int un_register_fs_driver(char *pdrive);


// void split_filename(char *name, char* drive, char* path, char* filename, char* ext, char* fullname, char* filepath, char* fullpath, char* dfdrv,  char* dfpath);



/*
 * device naming convention:
 * [DeviceID][DeviceNo][Partition]:
 * Device 	   DeviceID
 *
 * SD/MMC	      sd
 * IDE/GIDE	    hd
 *
 *
 * DeviceNo: a,b,c,d....
 *
 * Partition: 0,1,2,3.....
 * 
 */

#define _MAX_DRIVE_NAME	10
#define _MAX_DEVICE_ID	10
#define _MAX_PATH	255
#define _MAX_FILENAME	255
#define _MAX_FILEEXT	10

#define _STRLEN(s) (unsigned int)(strrchr(s,0)-s)
  
// file/path information  
struct fpinfo		
{
  char* psz_driveName;  // drive name (hda0,sdb1  ...)
  char* psz_deviceID;	// physical drive type (hd=GIDE, sd=SDCARD)
  char  c_deviceNO;	// a,b,c,d.... is the device number ( ex. hda=first  GIDE device )
  BYTE  n_partition;	// 0,1,2,3.... is the partition number (ex. hda0=first partition on first GIDE drive)
  
  char* psz_path;	// path to directory where the file resists
  char* psz_filename;	// filename
  char  c_separator;	// filename<->fileext separator character (if any) - can be the empty string or '.'
  char* psz_fileext;	// filename extension
  
  char* psz_cdrive;	// current drive, use if no drive information is given
  char* psz_cpath;	// current path, use if no path information is given
};

/* check given filepath and fill filepath structure, returns CFP_OK if fp points to a valid (i.e. a complete) filepath 
   it's the callers responibility to allocate enough memory for the fpinfo struct
*/
unsigned char checkfp(char* fp, struct fpinfo *pfpinfo);

/* error codes:
 *	EINVDRV		no valid drive information
 *	ENOPATH		no valid path information
 *	ENOFILE		no valid filename information
 *	EZERO		all information valid (we do not need all information in all commands, CD doesn't need filename information...) 
 */





/* ************************************************************************ */

void _ll_init_fs(void);  			// initialize filesystems (nkc/llopenc.c)
int _ll_open(char *name, int flags);             // open a file (nkc/llopenc.c)             
int _ll_creat(char *name, int flags);		// create a file (nkc/llopenc.c)
void _ll_close(int fd);				// close a file (nkc/llopenc.c)

int __ll_read(int fd, void *buf, int size);	// (nkc/llstd.S)
int _ll_write(int fd, void *buf, int size);     // (nkc/llstd.S)
int _ll_flags(int flags);			// (nkc/llopen.S)
void _ll_seek(int fd, int pos, int origin);	// seek to pos (nkc/llopenc.c)

int _ll_getpos(int fd);				// get current fileposition (nkc/llopenc.c)
int _ll_rename(char *old , char *new);		// (nkc/llstd.S)
int _ll_remove(char *name);			// (nkc/llstd.S)


#endif
