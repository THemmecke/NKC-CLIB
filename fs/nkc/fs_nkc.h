#ifndef __FS_NKC_H
#define __FS_NKC_H
/*
 
 JADOS filesystem module
 
 Harddisk:
 ---------
 
 
 
 
 1 cluster = 1024 bytes, clusters per sector = 2 with a 512 bytes per sector device
 1 track = 10 clusters/blocks = 10240 bytes
 1 partition = 256 track =  256 x 10 x 1024 bytes = 2560 cluster x 1024 bytes = 2621440 bytes = 2560KB ~2.5MB 

 1 disk = Bootblock + 26 partitions = (100 + 26 x 256 x 10) clusters = (100 + 26 x 256 x 10) x 2 512byte-sectors = 665800 512byte-Sectors (z.B. 1024 - 666824)

 
 Harddisk:
   cluster 0 - 99: bootloader and extensions
                    4E 71  NOP
                    60 08  BRA *+8
                    4B 4A  KJ		<-- = label JADOS
                    38 36  86
                    33 2E  3.		<-- = Version 3.50
                    35 30  50		
                    60 00  BRA ...
                    01 5E 
    cluster 100 - 2659: 1st Partition
    cluster 2660 - 5219: 2nd Partition
	:
	:
	
	
  partition:
      cluster 0   = FAT (track table) => 1024 / 4 = 256 tracks (files miminum allocated space is 1 track !)
      cluster 1-9 = directory => 9x1024 / 32 = 288 max. files (theoretical value, FAT clips this to 255 files (if every file < 1 track) )
      32 dir entries per cluster
      => 2550 cluster free
      
	
  FAT:
   256 entrys for every track in the partition
   4 bytes per entry:
   00 01 = ancestor track
           0xE5E5 free track
           0xFFFF no ancestor
           0x0...0x255 ancestor track 
   02 03 = successor track
	   0xE5E5 free track
           0xFFFF no successor
           0x0...0x255 successor track 
           
  index of first FAT entry: 4 (HardDisk) => first entry is at offset 4 (FAT index 1), entry at offset 0 is FAT/DIR	

  directory:
  
   byte			contains		meaning
   00-01		identifier		0xE5E5 = free entry
								0xFFFF = deleted entry
								0x0000 = valid entry
   02-09                		filename              
   10-11                		reserved		= 0x00
   12-14		filetype		filename extension
   15			reserved		= 0x00
   16-17		start track		1st track of file = index into FAT to find following tracks
   18-19		last cluster	last cluster of last track (1-indexed)
   20-21		last byte		number of last byte in last sector (0, not used)
   22-25		date			0x00 + YMD in BCD
   26-27		filesize		length in clusters
   28			mode/attribute	0xE5 = read/write
								0xE4 0 read only
   29-31		reserverd
   
   
   
  file control block (FCB):
  
  byte			contains		meaning
  00-01			drive			0     = RAMDISK
								01-04 = disk 1 to 4
								05-30 = disk partitions
  02-09			filename		
  10-11			reserved		= 0x00
  12-14			type			filename extension
  15			reserved		= 0x00
  16-17			start track
  18-19			last track
  20-21			last byte
  22-25			date
  26-27			filesize
  28			mode/attribute
  29-31			reserved
  32-33			dir cluster		cluster (partition relative) of file entry, Note: it seems JADOS starts cluster counting with 1 here !! => DIR_CLUSTER_OFFSET
  34-35			dir byte		start byte in cluster
  36-37			filestatus		0 = closed
								1 = open, no dir update (read mode)
								2 = open, with dir update (rad/write mode)
  38-39			current track
  40-41			current cluster
  42-43			last track
  44-47			current buffer ptr	current memory transfer address
 
 
 */ 

#include <types.h>

#include "../nkc/llnkc.h"

#define BUFFER_SIZE 	1024
/* JADOS Cluster Size */
#define CLUSTERSIZE 	1024
/* Size in Clusters of Boot Block */
#define BBSIZE      	100
/* 1st cluster of 1st partition */
#define FCLUSTER 		100
/* max. number of jados partitions on a jados drive */
#define MAX_PARTITIONS 	26
/* size of one track in clusters */
#define TRACK_SIZE		10
/* partions size in clusters incl. FAT & DIR */
#define PART_SIZE		2560
/* FAT size in clusters */
#define FAT_SIZE     	1
/* 1st FAT index */
#define FAT_BASE     	1
/* DIR size in clusters */
#define DIR_SIZE		9
/* size of boot record */
#define MBR_SIZE		100
/* number of FAT entries */
#define FAT_ENTRIES     256
/* number of DIR entries per cluster (1024) */
#define DIR_ENTRIES_PC   32
/* free FAT entry mask */
#define FAT_FREE_MASK   0xE5E5
/* offset for jados cluster counting */
#define JADOS_CLUSTER_OFFSET 1


/* JADOS harddisk descriptor */

struct jdhd {		
	char    name[4];		/* disk name (i.e. sda, sdb, hda,hdb etc. ) */
	WORD	spc;			/* sectors per cluster, for JADOS (clustersize 1024) this is 2 for a device with a sector size of 512 (taken from device-driver!) */
	WORD    csize;			/* cluster size, usualy 1024 bytes/cluster in a JADOS file system */
	UINT    nsectors;		/* number of (native) sectors on the device (usualy number of 512(ssize) byte sectors) */
	BYTE 	pvalid[26];		/* valid partitions (0...25) */
	BYTE    bootflag;		/* 1=harddisk has valid booloader */	
	BYTE 	xfs;			/* 1= is JADOSXFS, 0= JADOSFS */
	WORD	xoffset;		/* offset of first cluster if JADOSXFS */
	WORD	xsize;			/* size of jados hard disk in JADOSXFS */
	struct jdhd *pnext;		/* pointer to next harddisk descriptor */
};

/* JADOS FAT entry */

#define NUM_JD_FAT_ENTRIES 256
typedef struct {	
	WORD    ancestor;		/* 0xE5E5 free track, 0xFFFF no ancestor, 0x0...0x255 ancestor track  */ 
	WORD	successor;		/* 0xE5E5 free track, 0xFFFF no successor 0x0...0x255 successor track */
} FATentry;

/* File system object structure (JADOSFS) */

typedef struct {
	FSTYPE 				fs_id;		/* id to identify filesystem type in void pointers, defined in fs.h */
	struct fstabentry 	*pfstab;	/* pointer to fstab */		
	struct jdhd    		*pjdhd;		/* pointer to harddisk descriptor */
	BYTE     			id;			/* partition number (0..25) */
	FATentry 			*pFAT;		/* pointer to partition FAT */
	struct jddir 		*pDIR;		/* pointer to partition DIR */
} JDFS;



/* dir entry */
#define NUM_JD_DIR_ENTRIES 288
struct jddir {
	unsigned short 	id;				/* 00..01 */ // 0xE5E5: free entry, 0xFFFF: deleted entry, 0x0: valid entry
	char 			filename[8];	/* 02..09 */
	unsigned short 	reserved01;		/* 10..11 */  // should be 00 00
	char 			fileext[3];		/* 12..14 */  
	unsigned char 	reserved02;		/* 15 	  */  // should be 00
	unsigned short 	starttrack;		/* 16..17 */ // number of first track (relative to volume)
	unsigned short 	endcluster;		/* 18..19 */ // number of last cluster in last track  (track relative ! 10 cluster/track with HD and 5 cluster/track with FD))
	unsigned short 	endbyte;		/* 20..21 */ // always 0
	unsigned int	date;			/* 22..25 */
	unsigned short 	length;			/* 26..27 */ // filelength in clusters 
	unsigned char 	mode;			/* 28     */ // 0xE4 read only, 0xE5 read/write (not used correctly in current JADOS (always 0xE5)!!)
	unsigned short 	reserved03;		/* 29..30 */ // should be E5 E5
	unsigned char   reserved04;     /* 31     */ // should be E5
} __attribute__ ((packed));			/* otherwise datafields would be aligned ... */



/* FCB */
//typedef struct {
struct jdfcb {
	unsigned short 	lw;				/* 00..01 */ // 0=RAMDISK, 1..4=FloppyDisk, 5..30=HardDisk A..Z  -or- partition number (if no JADOS used)
									/* bytes 02..31 correspond to struct jddir */
	char 			filename[8];	/* 02..09 */
	unsigned short 	reserved01;		/* 10..11 */
	char 			fileext[3];		/* 12..14 */
	unsigned char 	reserved02;		/* 15 	  */
	unsigned short 	starttrack;		/* 16..17 */ // number of first track
	unsigned short 	endcluster;		/* 18..19 */ // number of last cluster in last track 1...10 !! (track relative ! 10 cluster/track with HD and 5 sluster/track with FD))
	unsigned short 	endbyte;		/* 20..21 */ // always 0 (last valid byte in last sector, not used)
	unsigned int	date;			/* 22..25 */ // bytes=[00][year][month][day] BCD coded
	unsigned short 	length;			/* 26..27 */ // filelength in clusters
	unsigned char 	mode;			/* 28     */ // 0xE4 read only, 0xE5 read/write (not used correctly in current JADOS (always 0xE5)!!)
	unsigned short 	reserved03;		/* 29..30 */
	unsigned char   reserved04;		/* 31     */
	
	unsigned short  dirsec;			/* 32..33 */ // cluster of dir entry (2..10)
	unsigned short  dirbyte;		/* 34..35 */ // start byte in sector of dir entry (0...1024)
	unsigned short  status;			/* 36..37 */ // 0=closed, 1=opened, no dir update(read), 2=opened with dir update(write)
	unsigned short  curtrack;		/* 38..39 */ // current track (Partition-Relativ !) 0..2559
	unsigned short  curcluster;		/* 40..41 */ // current cluster in current track (track relative) 0..9
	unsigned short  lasttrack;		/* 42..43 */ // last track
	unsigned char   *pbuffer;		/* 44..47 */ // sector buffer for all read/write operations	
	/* ----- extension fields --------------- */
	/* we do not use struct jdfileinfo without using JADOS, instead we add necessary fields here and stay backward compatible ... */
	int dir_index;					/* index into directory */
	int pos;						/* absolute file position 							*/
	int crpos;						/* current relative position in current JADOS cluster 	*/	
	int crcluster;					/* current (file)relative cluster */
	unsigned char omode;			/* open mode: 0xE4=RO, 0xE5=RW */
	unsigned char eof;				/* pos is at end of file 						*/
	JDFS		*pfs;				/* pointer to related file system object  */
} __attribute__ ((packed));			/* otherwise datafields would be aligned ... */
//} FCB __attribute__ ((packed));


struct pathinfo {
	char 	filename[9];
	char 	fileext[4];
	char	drive[2];	
};

#ifdef CONFIG_FS_NKC
extern unsigned char _DRIVE; // drive where this program was started (startup/startXX.S)
#endif


static DRESULT nkcfs_read_cluster(struct jdfcb *pfcb);
static DRESULT nkcfs_write_cluster(struct jdfcb *pfcb);

FRESULT nkcfs_mount(unsigned char  mount, 		/* 1=> mount, 0=> unmount */
		    struct fstabentry *pfstab		/* pointer to fstabentry with info of drive to be mounted/unmounted */
);


/*********************/


/* Private Prototypes */

void alloc_new_cluster(struct jdfcb *pfcb);

//static int nkcfs_opendir(struct _file *filp, const char *relpath, DIR *dir);
//static int nkcfs_closedir(struct _file *filp, DIR *dir);
static int     nkcfs_readdir_( struct fstabentry* pfstab, struct jddir* pdir);
static int     nkcfs_opendir(struct _file *filp, const char *relpath, DIR *dir);
static int     nkcfs_closedir(struct _file *filp, DIR *dir);
static int     nkcfs_readdir(struct _file *filp, DIR *dir,FILINFO* finfo);
static int     nkcfs_getfree(struct fstabentry* pfstab,DWORD *nclst);

/* Public Prototypes */

static int     nkcfs_ioctl(struct fstabentry* pfstab, int cmd, unsigned long arg);
static int     nkcfs_open(struct _file *filp);
static int     nkcfs_close(struct _file *filp);
static int     nkcfs_read(struct _file *filp, char *buffer, int buflen);
static int     nkcfs_write(struct _file *filp, const char *buffer, int buflen);
static int     nkcfs_seek(struct _file *filp, int offset, int whence);
static int     nkcfs_remove(struct _file *filp);
static int     nkcfs_getpos(struct _file *filp);
static int     nkcfs_rename(struct _file *filp, const char *oldrelpath, const char *newrelpath);

void    nkcfs_init_fs(void);



#endif
