#ifndef __INCLUDE_FS_H
#define __INCLUDE_FS_H

#include <errno.h>
#include "../fs/fat/ffconf.h"
#include <drivers.h>


#define ENDIAN(val)  (((val & 0xFF000000) >> 24) + ((val & 0x00FF0000) >> 8) + ((val & 0x0000FF00) << 8) + ((val & 0x000000FF) << 24))
#define WORDSWAP(val)  (((val & 0xFFFF0000) >> 16) + ((val & 0x0000FFFF) << 16))
#define BYTESWAP(val)  (((val & 0xFF00) >> 8) + ((val & 0x00FF) << 8))
#define LOWORD(val) (val & 0x0000FFFF)
#define HIWORD(val) ((val & 0xFFFF0000) >> 16)
/*
  partition table entry
*/
struct ptable
{                     /* 16 bytes */
  UCHAR bootable;     /*  1     */
  UINT  start_chs:24; /*  3 CHS   */
  UCHAR type;         /*  1     */
  UINT  end_chs:24;   /*  3 CHS   */ 
  UINT  start_sector; /*  4 LBA   */
  UINT  num_sector;   /*  4 LBA   */
};

/*
  
  structure of master boot record
*/
struct mbr {
  UCHAR       bootloader[440];  /* 0x0000     */
  UINT        drivesig;         /* 0x01B8 (440) */
  USHORT      reserved01;       /* 0x01BC (444) */
  struct      ptable pt[4];     /* 0x01BE (446) */
  USHORT      signature;        /* 0x01FE (510) */
};

#define MBR_Table     446 /* MBR: Partition table offset (2) */
#define SZ_PTE        16  /* MBR: Size of a partition table entry */



/* ********************************************************************************************************************************************************* 
  VBR - Volume Boot Records
         present on any partiton
         the MBR is a special VBR
*/

/*
 BIOS parameter block DOS 2.0 (13 bytes)
*/ 
struct BPB_DOS20 {
                    /* sector offset */
  USHORT  BytsPerSec;   /* 0x00b: 16bits, always 512 bytes      - Bytes per Sector            */
  UCHAR   SecPerClus;   /* 0x00d:  8bits, 1,2,4,8,16,32,64,128  - Secors per Cluster          */
  USHORT  RsvdSecCnt;   /* 0x00e: 16bits, Usually 0x20          - Number of Reserved Sectors  */
  UCHAR   NumFATs;      /* 0x010:  8bits, Number of FATs        - Always 2                    */
  USHORT  RootEntries;  /* 0x011: Maximum number of FAT12 or FAT16 root directory entries. 0 for FAT32, 
                                  where the root directory is stored in ordinary data clusters; see offset 0x02C in FAT32 EBPBs.*/
  USHORT  NumOfSectors; /* 0x013: Total logical sectors (if zero, use 4 byte value at offset 0x020) */
  UCHAR   MediaDescr;   /* 0x015: -> bpb_media_types[] */
  USHORT  SecPerFat;    /* 0x016: Logical sectors per File Allocation Table for FAT12/FAT16. 
                                  FAT32 sets this to 0 and uses the 32-bit value at offset 0x024 instead. */
}__attribute__ ((packed));  

/*
 BIOS parameter block DOS 3.0 (19 bytes)
*/ 
struct BPB_DOS30 {
                    /* sector offset */
  USHORT  BytsPerSec;   /* 0x00b: 16bits, always 512 bytes      - Bytes per Sector            */
  UCHAR   SecPerClus;   /* 0x00d:  8bits, 1,2,4,8,16,32,64,128  - Secors per Cluster          */
  USHORT  RsvdSecCnt;   /* 0x00e: 16bits, Usually 0x20          - Number of Reserved Sectors  */
  UCHAR   NumFATs;      /* 0x010:  8bits, Number of FATs        - Always 2                    */
  USHORT  RootEntries;  /* 0x011: Maximum number of FAT12 or FAT16 root directory entries. 0 for FAT32, 
                                  where the root directory is stored in ordinary data clusters; see offset 0x02C in FAT32 EBPBs.*/
  USHORT  NumOfSectors; /* 0x013: Total logical sectors (if zero, use 4 byte value at offset 0x020) */
  UCHAR   MediaDescr;   /* 0x015: -> bpb_media_types[] */
  USHORT  SecPerFat;    /* 0x016: Logical sectors per File Allocation Table for FAT12/FAT16. 
                                  FAT32 sets this to 0 and uses the 32-bit value at offset 0x024 instead. */

  USHORT  SecPerTrack;   /* 0x018: Physical sectors per track for disks with INT 13h CHS geometry */
  USHORT  HeadsPerCyl;   /* 0x01A: Number of heads for disks with INT 13h CHS geometry */
  USHORT  HiddenSec;     /* 0x01C: Count of hidden sectors preceding the partition that contains this FAT volume */
}__attribute__ ((packed));  

/*
 BIOS parameter block DOS 3.2 (21 bytes)
*/ 
struct BPB_DOS32 {
                    /* sector offset */
  USHORT  BytsPerSec;   /* 0x00b: 16bits, always 512 bytes      - Bytes per Sector            */
  UCHAR   SecPerClus;   /* 0x00d:  8bits, 1,2,4,8,16,32,64,128  - Secors per Cluster          */
  USHORT  RsvdSecCnt;   /* 0x00e: 16bits, Usually 0x20          - Number of Reserved Sectors  */
  UCHAR   NumFATs;      /* 0x010:  8bits, Number of FATs        - Always 2                    */
  USHORT  RootEntries;  /* 0x011: Maximum number of FAT12 or FAT16 root directory entries. 0 for FAT32, 
                                  where the root directory is stored in ordinary data clusters; see offset 0x02C in FAT32 EBPBs.*/
  USHORT  NumOfSectors; /* 0x013: Total logical sectors (if zero, use 4 byte value at offset 0x020) */
  UCHAR   MediaDescr;   /* 0x015: -> bpb_media_types[] */
  USHORT  SecPerFat;    /* 0x016: Logical sectors per File Allocation Table for FAT12/FAT16. 
                                  FAT32 sets this to 0 and uses the 32-bit value at offset 0x024 instead. */

  USHORT  SecPerTrack;  /* 0x018: Physical sectors per track for disks with INT 13h CHS geometry */
  USHORT  HeadsPerCyl;  /* 0x01A: Number of heads for disks with INT 13h CHS geometry */
  USHORT  HiddenSec;    /* 0x01C: Count of hidden sectors preceding the partition that contains this FAT volume */  
  USHORT  BigNumSec;    /* 0x01E: Total logical sectors including hidden sectors. This DOS 3.2 entry is incompatible 
                                  with a similar entry at offset 0x020 in BPBs since DOS 3.31.
                                  It must not be used if the logical sectors entry at offset 0x013 is zero.*/
}__attribute__ ((packed));  

/*
 BIOS parameter block DOS 3.31 (25 bytes)
*/ 
struct BPB_DOS331 {
                  /* sector offset */
  USHORT  BytsPerSec;   /* 0x00b: 16bits, always 512 bytes      - Bytes per Sector            */
  UCHAR   SecPerClus;   /* 0x00d:  8bits, 1,2,4,8,16,32,64,128  - Secors per Cluster          */
  USHORT  RsvdSecCnt;   /* 0x00e: 16bits, Usually 0x20          - Number of Reserved Sectors  */
  UCHAR   NumFATs;      /* 0x010:  8bits, Number of FATs        - Always 2                    */
  USHORT  RootEntries;  /* 0x011: Maximum number of FAT12 or FAT16 root directory entries. 0 for FAT32, 
                                  where the root directory is stored in ordinary data clusters; see offset 0x02C in FAT32 EBPBs.*/
  USHORT  NumOfSectors; /* 0x013: Total logical sectors (if zero, use 4 byte value at offset 0x020) */
  UCHAR   MediaDescr;   /* 0x015: -> bpb_media_types[] */
  USHORT  SecPerFat;    /* 0x016: Logical sectors per File Allocation Table for FAT12/FAT16. 
                                  FAT32 sets this to 0 and uses the 32-bit value at offset 0x024 instead. */

  USHORT  SecPerTrack;  /* 0x018: Physical sectors per track for disks with INT 13h CHS geometry */
  USHORT  HeadsPerCyl;  /* 0x01A: Number of heads for disks with INT 13h CHS geometry */
  UINT    HiddenSec;    /* 0x01C: Count of hidden sectors preceding the partition that contains this FAT volume */  
  UINT    BigNumSec;    /* 0x020: Total logical sectors (if greater than 65535; otherwise, see offset 0x013). */
}__attribute__ ((packed));  

/*
 BIOS parameter block extended (51 bytes)
*/ 
struct BPB_EXT {
                  /* sector offset */
  USHORT  BytsPerSec;   /* 0x00b: 16bits, always 512 bytes      - Bytes per Sector            */
  UCHAR   SecPerClus;   /* 0x00d:  8bits, 1,2,4,8,16,32,64,128  - Secors per Cluster          */
  USHORT  RsvdSecCnt;   /* 0x00e: 16bits, Usually 0x01 FAT12/16 - Number of Reserved Sectors  */
  UCHAR   NumFATs;      /* 0x010:  8bits, Number of FATs        - Always 2                    */
  USHORT  RootEntries;  /* 0x011: Maximum number of FAT12 or FAT16 root directory entries (usually 512). 0 for FAT32, 
                                  where the root directory is stored in ordinary data clusters; see offset 0x02C in FAT32 EBPBs.*/
  USHORT  TotSec16;     /* 0x013: Total logical sectors (if zero, use 4 byte value at offset 0x020) */
  UCHAR   MediaDescr;   /* 0x015: -> bpb_media_types[] */
  USHORT  FATSz16;      /* 0x016: Logical sectors per File Allocation Table for FAT12/FAT16. 
                                  FAT32 sets this to 0 and uses the 32-bit value at offset 0x024 instead. */
  USHORT  SecPerTrack;  /* 0x018: Physical sectors per track for disks with INT 13h CHS geometry */
  USHORT  HeadsPerCyl;  /* 0x01A: Number of heads for disks with INT 13h CHS geometry */
  UINT    HiddenSec;    /* 0x01C: Count of hidden sectors preceding the partition that contains this FAT volume */  
  UINT    TotSec32;     /* 0x020: Total logical sectors (if greater than 65535; otherwise, see offset 0x013). */

  UCHAR   drive_number; /* 0x024: Physical drive number (0x00 for (first) removable media, 0x80 for (first) fixed disk as per INT 13h) */
  UCHAR   reserved;     /* 0x025: */
  UCHAR   extBootSig;   /* 0x026: Extended boot signature */
  UCHAR   VolID[4];     /* 0x027: Volume ID (serial number) */
  UCHAR   VolLabel[11]; /* 0x02b: Partition Volume Label, padded with blanks (0x20),e.g. "NO NAME    " */
  UCHAR   Type[8];      /* 0x036: File system type, padded with blanks (0x20), e.g. "FAT12   ", "FAT16    " ... */
}__attribute__ ((packed));  

/*
 BIOS parameter block extended FAT32 (79 bytes)
*/ 
struct BPB_EXT_FAT32 {
                  /* sector offset */
  USHORT  BytsPerSec;   /*   2 0x00b: 16bits, always 512 bytes      - Bytes per Sector            */
  UCHAR   SecPerClus;   /*   1 0x00d:  8bits, 1,2,4,8,16,32,64,128  - Secors per Cluster          */
  USHORT  RsvdSecCnt;   /*   2 0x00e: 16bits, Usually 0x20 on FAT32 - Number of Reserved Sectors  */
  UCHAR   NumFATs;      /*   1 0x010:  8bits, Number of FATs        - Always 2                    */
  USHORT  RootEntries;  /*   2 0x011: Maximum number of FAT12 or FAT16 root directory entries. 0 for FAT32, 
                                  where the root directory is stored in ordinary data clusters; see offset 0x02C in FAT32 EBPBs.*/
  USHORT  TotSec16;     /*   2 0x013: Total logical sectors (if zero, use 4 byte value at offset 0x020) */
  UCHAR   MediaDescr;   /*   1 0x015: -> bpb_media_types[] */
  USHORT  FATSz16;      /*   2 0x016: Logical sectors per File Allocation Table for FAT12/FAT16. 
                                  FAT32 sets this to 0 and uses the 32-bit value at offset 0x024 instead. */
  USHORT  SecPerTrack;  /*   2 0x018: Physical sectors per track for disks with INT 13h CHS geometry */
  USHORT  HeadsPerCyl;  /*   2 0x01A: Number of heads for disks with INT 13h CHS geometry */
  UINT    HiddenSec;    /*   4 0x01C: Count of hidden sectors preceding the partition that contains this FAT volume */  
  UINT    TotSec32;     /*   4 0x020: Total logical sectors (if greater than 65535; otherwise, see offset 0x013). */
  UINT    FATSz32;      /*   4 0x024: 32bits, Sectors Per FAT       - Depends on disk Size        */
  USHORT  ExtFlags;     /*   2 0x028: */
  USHORT  FSVersion;    /*   2 0x02A: Version (defined as 0.0) */
  UINT    RootClus;     /*   4 0x02C: 32bits, Root Directory First Cluster - Usually 0x00000002  */
  USHORT  FSInfoSec;    /*   2 0x030: Logical sector number of FS Information Sector, typically 1, i.e., the second of the three FAT32 boot sectors. */
  USHORT  BackupBootSec;/*   2 0x032: First logical sector number of a copy of the three FAT32 boot sectors, typically 6. */   
  UCHAR   reserved[12]; /*  12 0x034: Usually 0 */ 
  UCHAR   Cf_0x024;     /*   1 0x040: Cf. 0x024 for FAT12/FAT16 (Physical Drive Number) */ 
  UCHAR   Cf_0x025;     /*   1 0x041: Cf. 0x025 for FAT12/FAT16 (Used for various purposes; see FAT12/FAT16) */ 
  UCHAR   Cf_0x026;     /*   1 0x042: Cf. 0x026 for FAT12/FAT16 (Extended boot signature, 0x29) */ 
  UINT    Cf_0x027;     /*   4 0x043: Cf. 0x027 for FAT12/FAT16 (Volume ID) */ 
  UCHAR   Cf_0x02B[11]; /*  11 0x047: Cf. 0x02B for FAT12/FAT16 (Volume Label) */
  UCHAR   Cf_0x036[8];  /*   8 0x052: Cf. 0x036 for FAT12/FAT16 (File system type, padded with blanks (0x20), e.g., "FAT32   "). */
}__attribute__ ((packed));  



/*
  boot sector
  On non-partitioned devices, such as floppy disks, the Boot Sector (VBR) is the first sector (logical sector 0 with physical CHS address 0/0/1 or LBA address 0). 
  For partitioned devices such as hard drives, the first sector is the Master Boot Record defining partitions, while the first sector of partitions formatted 
  with a FAT file system is again the Boot Sector.
*/

struct VBR_FAT16 {
                                  /* offset */
  UCHAR   JUMP2BOOTSTRAP[3];      /* 0x000: (e.g., 0xEB 0xFE 0x90) */
  char    OEM_name[8];            /* 0x003: MSDOS5.0, FreeDOS ... */
  struct BPB_EXT bpb;             /* 0x00b: BIOS parameter block extended (51 bytes) */                              
  UCHAR   CODE[448];              /* 0x05a: boot code (448 bytes) */
  USHORT  Sig;                    /* 0x1fe: 16bits, Signature             - Always 0xAA55 */
}__attribute__ ((packed));  

struct VBR_EXT_FAT32 {
                                  /* offset */
  UCHAR   JUMP2BOOTSTRAP[3];      /*   3 0x000: (e.g., 0xEB 0xFE 0x90) */
  char    OEM_name[8];            /*   8 0x003: MSDOS5.0, FreeDOS ... */
  struct BPB_EXT_FAT32 bpb;       /*  79 0x00b: BIOS parameter block extended FAT32 (79 bytes) */                              
  UCHAR   CODE[420];              /* 420 0x05a: boot code (420 bytes) */
  USHORT  Sig;                    /*   2 0x1fe: 16bits, Signature             - Always 0xAA55 */
}__attribute__ ((packed));  


static const char *const bpb_media_types[] = {
  "\xf0" "Floppy: DS, 80 Tracks, 18/38 sec, 3.5Zoll, 1440KB",
  "\xf8" "Harddisk",
  "\xf0" "Floppy: DS, 80 Tracks, 9/15 sec, 3.5\" 720KB or 5.25\" 1220KB",
  "\xfa" "Floppy: SS, 80 Tracks, 8 sec, 3.5\" or 5.25\", 320KB or RAMDISK",
  "\xfb" "Floppy: DS, 80 Tracks, 8 sec, 3.5\" or 5.25\", 640KB",
  "\xfc" "Floppy: SS, 40 Tracks, 9 sec, 5.25\"180KB",
  "\xfd" "Floppy: SS/DS, 40/77 Tracks, 9/26 sec, 5.25\" 160KB / 8\" 500KB / 5.25\" 360KB",
  "\xfe" "Floppy: SS/DS, 77 Tracks, 26/8 sec, 8\" 250/1200KB",
  "\xff" "Floppy: DS, 40 Tracks, 8 sec, 5.25 Zoll, 320KB",
   NULL
 };
/* DOS partition types */

static const char *const fs_sys_types[] = {
  "\x00" "Empty",
  "\x01" "FAT12",
  "\x04" "FAT16 <32M",
  "\x05" "Extended",         /* DOS 3.3+ extended partition */
  "\x06" "FAT16",            /* DOS 16-bit >=32M */
  "\x07" "HPFS/NTFS",        /* OS/2 IFS, eg, HPFS or NTFS or QNX */
  "\x0a" "OS/2 Boot Manager",/* OS/2 Boot Manager */
  "\x0b" "Win95 FAT32",
  "\x0c" "Win95 FAT32 (LBA)",/* LBA really is 'Extended Int 13h' */
  "\x0e" "Win95 FAT16 (LBA)",
  "\x0f" "Win95 Ext'd (LBA)",
  "\x11" "Hidden FAT12",
  "\x12" "Compaq diagnostics",
  "\x14" "Hidden FAT16 <32M",
  "\x16" "Hidden FAT16",
  "\x17" "Hidden HPFS/NTFS",
  "\x1b" "Hidden Win95 FAT32",
  "\x1c" "Hidden W95 FAT32 (LBA)",
  "\x1e" "Hidden W95 FAT16 (LBA)",
  "\x3c" "Part.Magic recovery",
  "\x41" "PPC PReP Boot",
  "\x42" "SFS",
  "\x63" "GNU HURD or SysV", /* GNU HURD or Mach or Sys V/386 (such as ISC UNIX) */
  "\x80" "Old Minix",        /* Minix 1.4a and earlier */
  "\x81" "Minix / old Linux",/* Minix 1.4b and later */
  "\x82" "Linux swap",       /* also Solaris */
  "\x83" "Linux",
  "\x84" "OS/2 hidden C: drive",
  "\x85" "Linux extended",
  "\x86" "NTFS volume set",
  "\x87" "NTFS volume set",
  "\x8e" "Linux LVM",
  "\x9f" "BSD/OS",           /* BSDI */
  "\xa0" "Thinkpad hibernation",
  "\xa5" "FreeBSD",          /* various BSD flavours */
  "\xa6" "OpenBSD",
  "\xa8" "Darwin UFS",
  "\xa9" "NetBSD",
  "\xab" "Darwin boot",
  "\xb0" "JDFS",          /* JADOS File System <==== !! */  
  "\xb7" "BSDI fs",
  "\xb8" "BSDI swap",
  "\xbe" "Solaris boot",
  "\xeb" "BeOS fs",
  "\xee" "EFI GPT",                    /* Intel EFI GUID Partition Table */
  "\xef" "EFI (FAT-12/16/32)",         /* Intel EFI System Partition */
  "\xf0" "Linux/PA-RISC boot",         /* Linux/PA-RISC boot loader */
  "\xf2" "DOS secondary",              /* DOS 3.3+ secondary */
  "\xfd" "Linux raid autodetect",      /* New (2.2.x) raid partition with
            autodetect using persistent
            superblock */
  NULL
};


static const char *const fs_disklabel_types[] = {
  "\x55" "\xaa" "dos",
  NULL
};


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

typedef enum {
  FS_MOUNT_DELAY = 0,
  FS_MOUNT_IMMEDIATE  
} MOUNTOPTS;

/* used in filesystem structures (e.g. in ff.h, FATFS) as first entry to recognize filesystem type */
typedef struct {
        FSTYPE	fs_id;	
} FS;


struct fstabentry
{
  char*   devname;			/* devicename hda0 , hdb1, sda0, hda0x1 ... */   
  int     pdrv;				/* physical drive number */  
  struct  fs_driver	*pfsdrv;	/* pointer to file system driver */
  struct  blk_driver 	*pblkdrv;	/* pointer to block device driver */ 
  int 		partition;	/* (MBR) partition number (0...3) */
  BYTE    extended; /* 1=extended partition, 0=normal partition */
  BYTE    extpart; /* extended partition number 0,1,2,3.... */
  void		*pfs;		/* pointer to the file system FATFS for example, type can be retreived from pfsdrv->pname */
  MOUNTOPTS options;		/* mount options */
  struct fstabentry* next;		/* pointer to next fstab entry */
};

struct fstabentry* get_fstabentry(char* devicename);

FRESULT add_fstabentry(char *devicename, char* fsname, MOUNTOPTS options);
FRESULT remove_fstabentry(char* devicename);

FRESULT mountfs(char *devicename, char* fsname, MOUNTOPTS options);
FRESULT umountfs(char *devicename);

int dn2part(char* devicename);
int dn2pdrv(char* devicename);

/* fs_registerdriver.c ******************************************************/

int register_fs_driver( char *pname, 				/* name of the filesystem, e.g. JADOSFS for NKC or FAT32 for IDE    */
		     const struct file_operations  *f_oper) ;   /* pointer to the file_operations structure to handle this fs       */
                           
/* fs_unregisterdriver.c ****************************************************/

int un_register_fs_driver(char *pdrive);


/*
 * device naming convention:
 * [DeviceID][DeviceNo][Partition][xn]:
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
 * E(x)tended Partiion: 0,1,2....
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
  BYTE  b_extended; // 1=extended partition, 0=normal partition
  BYTE  n_extpart; // extended partition number 0,1,2,3....
  
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
