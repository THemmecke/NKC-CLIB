#ifndef __INCLUDE_FS_H
#define __INCLUDE_FS_H

#include "../fs/fat/ffconf.h"

/* flags from stdio.h should be  used  */
/* open flag settings for open() (and related APIs) */

//#define O_RDONLY    (1 << 0)        /* Open for read access (only) */
//#define O_WRONLY    (1 << 1)        /* Open for write access (only) */
//#define O_RDWR      (O_RDOK|O_WROK) /* Open for both read & write access */
//#define O_CREAT     (1 << 2)        /* Create file/sem/mq object */
//#define O_EXCL      (1 << 3)        /* Name must not exist when opened  */
//#define O_APPEND    (1 << 4)        /* Keep contents, append to end */
//#define O_TRUNC     (1 << 5)        /* Delete contents */
//#define O_NONBLOCK  (1 << 6)        /* Don't wait for data */
//#define O_BINARY    (1 << 8)        /* Open the file in binary (untranslated) mode. */
//#define O_TEXT      0               /* Open the file in text (translated) mode. */


//#define _O_MAXBIT   8


/* These are the notifications that can be received from F_NOTIFY (linux) */

//#define DN_ACCESS   0  /* A file was accessed */
//#define DN_MODIFY   1  /* A file was modified */
//#define DN_CREATE   2  /* A file was created */
//#define DN_DELETE   3  /* A file was unlinked */
//#define DN_RENAME   4  /* A file was renamed */
//#define DN_ATTRIB   5  /* Attributes of a file were changed */


/*
	This is the _file structure used by the fs subsystem.
	It differs from FILE structure in the CLIB (it is used inside the CLIB itself).
*/
struct _file
{
  int               			f_oflags; 	/* Open mode flags */
  int             				f_pos;    	/* File position */
  struct file_operations 		*f_oper;  	/* Driver interface -> zeiger auf file_operations ?*/
  
  int							fd;			/* file handle */
  struct _file 					*next;		/* pointer to next file in list */	
  char							*pname;     /* filename with LW,path,name and extension  (fullname) */
  void         					*private;    /* file private data -> for example: pointer to jados fileinfo */

};

struct file_operations
{
 
  int     (*open)(struct _file *filp);
  int     (*close)(struct _file *filp);
  int     (*read)(struct _file *filp, char *buffer, int buflen);
  int     (*write)(struct _file *filp, const char *buffer, int buflen);
  int     (*seek)(struct _file *filp, int offset, int whence);
  int     (*ioctl)(char *name, int cmd, unsigned long arg);
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



struct driver
{
	char 						*pname;		/* name of filesystem (FAT,FAT32,NKC...) */
	char						*pdrive;	/* name of drive, i.e. A, B... ,HDA1, HDA2..., USB1, USB2... */
	struct file_operations 		*f_oper;	/* file operations */
	struct driver				*next;		/* pointer to next driver in driverlist */
};


struct driver* get_driver(char *name);

/* fs_registerdriver.c ******************************************************/

int register_driver(char *pdrive, 						/* drive name, e.g. "A" for a JADOS drive or "HDA1" for a FAT drive */
					char *pname, 						/* name of the filesystem, e.g. JADOSFS for NKC or FAT32 for IDE    */
					const struct file_operations  *f_oper);   /* pointer to the file_operations structure to handle this fs       */
                           
/* fs_unregisterdriver.c ****************************************************/

int un_register_driver(char *pdrive);


void split_filename(char *name, char* drive, char* path, char* filename, char* ext, char* fullname, char* filepath, char* fullpath);
void list_drivers();

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
