

#ifndef _TYPES
#define _TYPES

#include <errno.h>

#ifndef NULL
#define NULL 0
#endif

/* These types must be 16-bit, 32-bit or larger integer */
typedef int		INT;
typedef unsigned int	UINT;

/* These types must be 8-bit integer */
typedef char		CHAR;
typedef unsigned char	UCHAR;
typedef unsigned char	BYTE;

/* These types must be 16-bit integer */
typedef short		SHORT;
typedef unsigned short	USHORT;
typedef unsigned short	WORD;
typedef unsigned short	WCHAR;

/* These types must be 32-bit integer */
typedef long		LONG;
typedef unsigned long	ULONG;
typedef unsigned long	DWORD;


/* These types must be 64-bit integer */
typedef unsigned long long LONGLONG;

typedef enum {FALSE=0, TRUE=1} BOOL,BOOLEAN;

typedef void *PVOID;

typedef PVOID HANDLE;


#ifndef _LARGE_INTEGER_TYPE
#define _LARGE_INTEGER_TYPE
typedef struct _LARGE_INTEGER {
		    DWORD HighPart;
		    DWORD LowPart;
	} LARGE_INTEGER, *PLARGE_INTEGER;
#endif

/* other definitions */

/* File function return codes (FRESULT) -> fs/....*/

typedef enum {
	FR_OK = 0,			/* (0) Succeeded */
	FR_DISK_ERR,			/* (1) A hard error occurred in the low level disk I/O layer */
	FR_INT_ERR,			/* (2) Assertion failed */
	FR_NOT_READY,			/* (3) The physical drive cannot work */
	FR_NO_FILE,			/* (4) Could not find the file */
	FR_NO_PATH,			/* (5) Could not find the path */
	FR_INVALID_NAME,		/* (6) The path name format is invalid */
	FR_DENIED,			/* (7) Access denied due to prohibited access or directory full */
	FR_EXIST,			/* (8) Access denied due to prohibited access */
	FR_INVALID_OBJECT,		/* (9) The file/directory object is invalid */
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
	FR_NO_DRIVER
} FRESULT;


/* translate FRESULT codes (originaly from FAT file system) to system error codes --> fs.c */
extern const int FRES2ERRNO[];

/* Status of Disk Functions -> drivers/... */
typedef BYTE	DSTATUS;

/* Disk Status Bits (DSTATUS) */

#define STA_OK			0x00
#define STA_NOINIT		0x01	/* Drive not initialized */
#define STA_NODISK		0x02	/* No medium in the drive */
#define STA_PROTECT		0x04	/* Write protected */


/* Results of Disk Functions -> drivers/... */
typedef enum {
	RES_OK = 0,		/* 0: Successful */
	RES_ERROR,		/* 1: R/W Error */
	RES_WRPRT,		/* 2: Write Protected */
	RES_NOTRDY,		/* 3: Not Ready */
	RES_PARERR		/* 4: Invalid Parameter */
} DRESULT;

//typedef struct _PARTITION_INFORMATION {
//  LARGE_INTEGER StartingOffset;
//  LARGE_INTEGER PartitionLength;
//  DWORD         HiddenSectors;
//  DWORD         PartitionNumber;
//  BYTE          PartitionType;
//  BOOLEAN       BootIndicator;
//  BOOLEAN       RecognizedPartition;
//  BOOLEAN       RewritePartition;
//} PARTITION_INFORMATION, *PPARTITION_INFORMATION;

//typedef enum _MEDIA_TYPE { 
//  Unknown         = 0x00,
//  F5_1Pt2_512     = 0x01,
//  F3_1Pt44_512    = 0x02,
//  F3_2Pt88_512    = 0x03,
//  F3_20Pt8_512    = 0x04,
//  F3_720_512      = 0x05,
//  F5_360_512      = 0x06,
//  F5_320_512      = 0x07,
//  F5_320_1024     = 0x08,
//  F5_180_512      = 0x09,
//  F5_160_512      = 0x0a,
//  RemovableMedia  = 0x0b,
//  FixedMedia      = 0x0c,
//  F3_120M_512     = 0x0d,
//  F3_640_512      = 0x0e,
//  F5_640_512      = 0x0f,
//  F5_720_512      = 0x10,
//  F3_1Pt2_512     = 0x11,
//  F3_1Pt23_1024   = 0x12,
//  F5_1Pt23_1024   = 0x13,
//  F3_128Mb_512    = 0x14,
//  F3_230Mb_512    = 0x15,
//  F8_256_128      = 0x16,
//  F3_200Mb_512    = 0x17,
//  F3_240M_512     = 0x18,
//  F3_32M_512      = 0x19
//} MEDIA_TYPE;

//typedef struct _DISK_GEOMETRY {
//  LARGE_INTEGER Cylinders;
//  MEDIA_TYPE    MediaType;
//  DWORD         TracksPerCylinder;
//  DWORD         SectorsPerTrack;
//  DWORD         BytesPerSector;
//} DISK_GEOMETRY;



#endif
