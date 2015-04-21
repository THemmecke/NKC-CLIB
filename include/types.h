

#ifndef _TYPES
#define _TYPES

/*-------------------------------------------*/
/* Integer type definitions for FatFs module */
/*-------------------------------------------*/


/* These types must be 16-bit, 32-bit or larger integer */
typedef int				INT;
typedef unsigned int	UINT;

/* These types must be 8-bit integer */
typedef char			CHAR;
typedef unsigned char	UCHAR;
typedef unsigned char	BYTE;

/* These types must be 16-bit integer */
typedef short			SHORT;
typedef unsigned short	USHORT;
typedef unsigned short	WORD;
typedef unsigned short	WCHAR;

/* These types must be 32-bit integer */
typedef long			LONG;
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
/*	
typedef union _LARGE_INTEGER {
  struct {
    DWORD LowPart;
    LONG  HighPart;
  };
  struct {
    DWORD LowPart;
    LONG  HighPart;
  } u;
  LONGLONG QuadPart;
} LARGE_INTEGER, *PLARGE_INTEGER;
	
*/
#endif

/* other definitions */

typedef struct _PARTITION_INFORMATION {
  LARGE_INTEGER StartingOffset;
  LARGE_INTEGER PartitionLength;
  DWORD         HiddenSectors;
  DWORD         PartitionNumber;
  BYTE          PartitionType;
  BOOLEAN       BootIndicator;
  BOOLEAN       RecognizedPartition;
  BOOLEAN       RewritePartition;
} PARTITION_INFORMATION, *PPARTITION_INFORMATION;

typedef enum _MEDIA_TYPE { 
  Unknown         = 0x00,
  F5_1Pt2_512     = 0x01,
  F3_1Pt44_512    = 0x02,
  F3_2Pt88_512    = 0x03,
  F3_20Pt8_512    = 0x04,
  F3_720_512      = 0x05,
  F5_360_512      = 0x06,
  F5_320_512      = 0x07,
  F5_320_1024     = 0x08,
  F5_180_512      = 0x09,
  F5_160_512      = 0x0a,
  RemovableMedia  = 0x0b,
  FixedMedia      = 0x0c,
  F3_120M_512     = 0x0d,
  F3_640_512      = 0x0e,
  F5_640_512      = 0x0f,
  F5_720_512      = 0x10,
  F3_1Pt2_512     = 0x11,
  F3_1Pt23_1024   = 0x12,
  F5_1Pt23_1024   = 0x13,
  F3_128Mb_512    = 0x14,
  F3_230Mb_512    = 0x15,
  F8_256_128      = 0x16,
  F3_200Mb_512    = 0x17,
  F3_240M_512     = 0x18,
  F3_32M_512      = 0x19
} MEDIA_TYPE;

typedef struct _DISK_GEOMETRY {
  LARGE_INTEGER Cylinders;
  MEDIA_TYPE    MediaType;
  DWORD         TracksPerCylinder;
  DWORD         SectorsPerTrack;
  DWORD         BytesPerSector;
} DISK_GEOMETRY;



#endif
