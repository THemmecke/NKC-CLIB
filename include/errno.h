/*  errno.h

    Defines the system error variable errno and the error
    numbers set by system calls. Errors which exist in Unix(tm)
    but not MSDOS have value -1.

*/

#ifndef __ERRNO_H
#define __ERRNO_H

#include <types.h>

/* ***************************** Dos Error Codes ********************************* */

#define ERROR    -1

#define EZERO       0      /* Error 0   (no error)     */
#define EINVFNC     1      /* Invalid function number  */
#define ENOFILE     2      /* File not found           */
#define ENOPATH     3      /* Path not found           */
#define EMFILE      4      /* Too many open files      */
#define EACCES      5      /* Permission denied        */
#define EBADF       6      /* Bad file number          */
#define ECONTR      7      /* Memory blocks destroyed  */
#define ENOMEM      8      /* Not enough core          */
#define EINVMEM     9      /* Invalid memory block address */
#define EINVENV    10      /* Invalid environment      */
#define EINVFMT    11      /* Invalid format           */
#define EINVACC    12      /* Invalid access code      */
#define EINVDAT    13      /* Invalid data             */
#define EFAULT     14      /* Unknown error            */
#define EINVDRV    15      /* Invalid drive specified  */
#define ECURDIR    16      /* Attempt to remove CurDir */
#define ENOTSAM    17      /* Not same device          */
#define ENMFILE    18      /* No more files            */
#define EINVAL     19      /* Invalid argument         */
#define E2BIG      20      /* Arg list too long        */
#define ENOEXEC    21      /* Exec format error        */
#define EXDEV      22      /* Cross-device link        */
#define ENFILE     23      /* Too many open files      */
#define ECHILD     24      /* No child process         */
#define ENOTTY     25      /* UNIX - not MSDOS         */
#define ETXTBSY    26      /* UNIX - not MSDOS         */
#define EFBIG      27      /* UNIX - not MSDOS         */
#define ENOSPC     28      /* No space left on device  */
#define ESPIPE     29      /* Illegal seek             */
#define EROFS      30      /* Read-only file system    */
#define EMLINK     31      /* UNIX - not MSDOS         */
#define EPIPE      32      /* Broken pipe              */
#define EDOM       33      /* Math argument            */
#define ERANGE     34      /* Result too large         */
#define EEXIST     35      /* File already exists      */
#define EDEADLOCK  36    /* Locking violation        */
#define EPERM      37      /* Operation not permitted  */
#define ESRCH      38      /* UNIX - not MSDOS         */
#define EINTR      39      /* Interrupted function call */
#define EIO        40      /* Input/output error       */
#define ENXIO      41      /* No such device or address */
#define EAGAIN     42      /* Resource temporarily unavailable */
#define ENOTBLK    43      /* UNIX - not MSDOS         */
#define EBUSY      44      /* Resource busy            */
#define ENOTDIR    45      /* UNIX - not MSDOS         */
#define EISDIR     46      /* UNIX - not MSDOS         */
#define EUCLEAN    47      /* UNIX - not MSDOS         */

/* extensions ... */
#define ENAMETOOLONG 48 /* Filename too long        */
#define ENODRV      49	/* no driver 		    */



#define FRESULT_OFFSET 	100
#define DRESULT_OFFSET 	200
#define DSTATUS_OFFSET 	300



int * __getErrno(void);
extern  char *  __get_sys_errlist(void);
extern  int     __get_sys_nerr(void);
extern int errno;

#define errno (*__getErrno())

#define _sys_errlist  __get_sys_errlist()
#define _sys_nerr     __get_sys_nerr()

/* ***************************** File function return codes ********************************* */

/* FRESULT = File function return codes from file systems */

typedef enum {
	FR_OK = 0,			/* (0) Succeeded */
	FR_DISK_ERR,			/* (1)  A hard error occurred in the low level disk I/O layer */
	FR_INT_ERR,			/* (2)  Assertion failed */
	FR_NOT_READY,			/* (3)  The physical drive cannot work */
	FR_NO_FILE,			/* (4)  Could not find the file */
	FR_NO_PATH,			/* (5)  Could not find the path */
	FR_INVALID_NAME,		/* (6)  The path name format is invalid */
	FR_DENIED,			/* (7)  Access denied due to prohibited access or directory full */
	FR_EXIST,			/* (8)  Access denied due to file already exists */
	FR_INVALID_OBJECT,		/* (9)  The file/directory object is invalid */
	FR_WRITE_PROTECTED,		/* (10) The physical drive is write protected */
	FR_INVALID_DRIVE,		/* (11) The logical drive number is invalid */
	FR_NOT_ENABLED,			/* (12) The volume has no work area */
	FR_NO_FILESYSTEM,		/* (13) There is no valid FAT volume */
	FR_MKFS_ABORTED,		/* (14) The f_mkfs() aborted due to any parameter error */
	FR_TIMEOUT,			/* (15) Could not get a grant to access the volume within defined period */
	FR_LOCKED,			/* (16) The operation is rejected according to the file sharing policy */
	FR_NOT_ENOUGH_CORE,		/* (17) LFN working buffer could not be allocated */
	FR_TOO_MANY_OPEN_FILES,		/* (18) Number of open files > _FS_SHARE */
	FR_INVALID_PARAMETER,		/* (19) Given parameter is invalid */	
	FR_NO_DRIVER,			/* (20) no driver */
	FR_EOF,				/* (21) end of file reached */
	FR_DISKFULL,			/* (22) disk is full */
	FR_DIRFULL			/* (23) directory full */
} FRESULT;


/* ***************************** disk i/o function return codes ********************************* */


/* Results of Disk Functions -> drivers/... */
typedef enum {
	RES_OK = 0,		/* 0: Successful */
	RES_ERROR,		/* 1: R/W Error */
	RES_WRPRT,		/* 2: Write Protected */
	RES_NOTRDY,		/* 3: Not Ready */
	RES_PARERR,		/* 4: Invalid Parameter */	
	RES_EOF,		/* 5: end of file reached */
	RES_NOMEM,		/* 6: not enough memory */
	RES_DISKFULL		/* 7: disk full */
} DRESULT;

/* ***************************** disk i/o status return codes ********************************* */
/* Status of Disk Functions -> drivers/... */
typedef BYTE	DSTATUS;

/* Disk Status Bits (DSTATUS) */

#define STA_OK			0x00
#define STA_NOINIT		0x01	/* Drive not initialized */
#define STA_NODISK		0x02	/* No medium in the drive */
#define STA_PROTECT		0x04	/* Write protected */




#endif
