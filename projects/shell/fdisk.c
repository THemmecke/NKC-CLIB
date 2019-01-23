#include <stdlib.h>
#include <ioctl.h>
#include <errno.h>

#include <fs.h>
#include <drivers.h>

#include "../../fs/nkc/fs_nkc.h"

#include "helper.h"
#include "shell.h"
#include "fdisk.h"
#include "sys.h"

extern char keyci(void); /* -> nkc/llmisc.S */
/*-----------------------------------------------------------------------*/
/* private function prototypes                                           */
static int cmd_shcmds(void);

static int cmd_p(char* args);
static int cmd_d(char* args);
static int cmd_a(char* args);
static int cmd_f(char* args);
static int cmd_s(char* args);
static int cmd_l(char* args);
static int cmd_w(char* args);
static int cmd_q(char* args);
static int cmd_t(char* args);
static int cmd_b(char* args);
static int cmd_i(char* args);


/*-----------------------------------------------------------------------*/
/* constant definitions                                                  */

#define TEXT_CMDHELP_P          1
#define TEXT_CMDHELP_D          2
#define TEXT_CMDHELP_A          3
#define TEXT_CMDHELP_F          4
#define TEXT_CMDHELP_L          5
#define TEXT_CMDHELP_W          6
#define TEXT_CMDHELP_Q          7
#define TEXT_CMDHELP_S          8
#define TEXT_CMDHELP_T          9
#define TEXT_CMDHELP_B          10
#define TEXT_CMDHELP_I          11
#define TEXT_CMDHELP_QUESTION   12

/*-----------------------------------------------------------------------*/
/* help text definitions                                                 */

static struct CMDHLP hlptxt[] =
{
	{TEXT_CMDHELP_P,        "p: print the partition table\n",""},          
	{TEXT_CMDHELP_D,        "d: delete a partition\n",""},
	{TEXT_CMDHELP_A,        "a: add a partition\n",""},
	{TEXT_CMDHELP_S,        "s: list free unpartitioned space\n",""},                        
	{TEXT_CMDHELP_L,        "l: list known partition types\n",""},
	{TEXT_CMDHELP_F,        "f: format a partition\n",""},
	{TEXT_CMDHELP_T,        "t: toggle a bootable flag\n",""},
	{TEXT_CMDHELP_B,        "b: initialize mbr to be DOS compatible\n",""},
	{TEXT_CMDHELP_I,        "i: change the disk identifier\n",""},
	{TEXT_CMDHELP_W,        "w: write table to disk and exit\n",""},
	{TEXT_CMDHELP_Q,        "q: quit without saving\n",""},
	{TEXT_CMDHELP_QUESTION, "m: this screen\n",""},        
	{0,                     "",""}
};

/*-----------------------------------------------------------------------*/
/* list of available commands in fdisk                                   */

static struct CMD internalCommands[] =
{
	{"p"        , cmd_p         , TEXT_CMDHELP_P},
	{"d"        , cmd_d         , TEXT_CMDHELP_D},
	{"a"        , cmd_a         , TEXT_CMDHELP_A},
	{"f"        , cmd_f         , TEXT_CMDHELP_F},
	{"s"        , cmd_s         , TEXT_CMDHELP_S},
	{"l"        , cmd_l         , TEXT_CMDHELP_L},
	{"t"        , cmd_t         , TEXT_CMDHELP_T},	
	{"i"        , cmd_i         , TEXT_CMDHELP_I},
	{"b"        , cmd_b         , TEXT_CMDHELP_B},
	{"w"        , cmd_w         , TEXT_CMDHELP_W},
	{"q"        , cmd_q         , TEXT_CMDHELP_Q},
	{"m"        , cmd_shcmds    , TEXT_CMDHELP_QUESTION},
	{"?"        , cmd_shcmds    , TEXT_CMDHELP_QUESTION},
	
	{0,0,0}
};


/*-----------------------------------------------------------------------*/
/* sub shell environment                                                 */

static struct SHELL_ENV cmd_env;
static struct LINE_ENV line_env;
static union RESULT line_env_res;

/* drive in question */
static char drive[4];

/* master boot record of the drive */
static struct mbr *pMBR;
/* block driver */
static struct blk_driver *driver;
/* drive geometry */
static struct geometry geo;
/* physical drive */
static struct _dev devp;

/* unsaved changes ? */
static struct task* tasklist;

/* input buffer */
static char inbuffer[255];


static const char progress[] = { '|','/','-','\\' };

/* ********************************************************************** */
/* Constants and tables for handling FAT file systems                     */

static const char *const fat_types[] = {
	"\x06" "FAT16",
	"\x0c" "FAT32",
	NULL
};

struct DSKSZTOSECPERCLUS {
	UINT  DiskSize;       /* disk size in sectors of 512 bytes */
	UCHAR   SecPerClusVal;  /* sectors pr cluster value */
};

/*
*This is the table for FAT16 drives. NOTE that this table includes
* entries for disk sizes larger than 512 MB even though typically
* only the entries for disks < 512 MB in size are used.
* The way this table is accessed is to look for the first entry
* in the table for which the disk size is less than or equal
* to the DiskSize field in that table entry.  For this table to
* work properly BPB_RsvdSecCnt must be 1, BPB_NumFATs
* must be 2, and BPB_RootEntCnt must be 512. Any of these values
* being different may require the first table entries DiskSize value
* to be changed otherwise the cluster count may be to low for FAT16.
*/
static struct DSKSZTOSECPERCLUS DskTableFAT16 [] = {
	{        8400,   0}, /* disks up to  4.1 MB, the 0 value for SecPerClusVal trips an error */
	{       32680,   2}, /* disks up to   16 MB,  1k cluster */
	{      262144,   4}, /* disks up to 128 MB,  2k cluster */
	{      524288,   8}, /* disks up to 256 MB,  4k cluster */
	{     1048576,  16}, /* disks up to 512 MB,  8k cluster */
	/* The entries after this point are not used unless FAT16 is forced */
	{     2097152,  32}, /* disks up to     1 GB, 16k cluster */
	{     4194304,  64}, /* disks up to     2 GB, 32k cluster */
	{  0xFFFFFFFF,   0}  /* any disk greater than 2GB, 0 value for SecPerClusVal trips an error */
};

/*
* This is the table for FAT32 drives. NOTE that this table includes
* entries for disk sizes smaller than 512 MB even though typically
* only the entries for disks >= 512 MB in size are used.
* The way this table is accessed is to look for the first entry
* in the table for which the disk size is less than or equal
* to the DiskSize field in that table entry. For this table to
* work properly BPB_RsvdSecCnt must be 32, and BPB_NumFATs
* must be 2. Any of these values being different may require the first
* table entries DiskSize value to be changed otherwise the cluster count
* may be to low for FAT32.
*/
static struct DSKSZTOSECPERCLUS DskTableFAT32 [] = {
	{      66600,  0},  /* disks up to 32.5 MB, the 0 value for SecPerClusVal trips an error */
	{     532480,  1},  /* disks up to 260 MB,  .5k cluster */
	{   16777216,  8},  /* disks up to     8 GB,    4k cluster */
	{   33554432, 16},  /* disks up to   16 GB,    8k cluster */
	{   67108864, 32},  /* disks up to   32 GB,  16k cluster */
	{ 0xFFFFFFFF, 64}   /* disks greater than 32GB, 32k cluster */
	    
};


/*-----------------------------------------------------------------------*/
/* Private functions                                                     */
static const char *
partition_type(unsigned char type)
{
	int i;  

	for (i = 0; fs_sys_types[i]; i++) /* fs_sys_types -> fs.h */
		if ((unsigned char)fs_sys_types[i][0] == type)
			return fs_sys_types[i] + 1;

	return "Unknown";
}

static const char *
fat_type(unsigned char type)
{
	int i;  

	for (i = 0; fat_types[i]; i++)
		if ((unsigned char)fat_types[i][0] == type)
			return fat_types[i] + 1;

	return "Unknown";
}

static const UCHAR 
SecPerClusFAT16(UINT disksize) /* disksize in sectors */
{
	int i;  

	for (i = 0; DskTableFAT16[i].DiskSize != 0xFFFFFFFF; i++)
		if (DskTableFAT16[i].DiskSize < disksize)
			continue;
		else return DskTableFAT16[i].SecPerClusVal;

	return 0;
}

static const UCHAR 
SecPerClusFAT32(UINT disksize) /* disksize in sectors */
{
	int i;  
	
	for (i = 0; DskTableFAT32[i].DiskSize != 0xFFFFFFFF; i++){
		if (DskTableFAT32[i].DiskSize < disksize)
			continue;
		else return DskTableFAT32[i].SecPerClusVal;
	}

	return 64;
}

static const char *
disklabel_type(unsigned short type)
{
	int i;  

	for (i = 0; fs_disklabel_types[i]; i++)
		if (  ((unsigned char)fs_disklabel_types[i][0] == (type & 0xFF00) >> 8) &&
					((unsigned char)fs_disklabel_types[i][1] == (type & 0x00FF)) )
			return fs_disklabel_types[i] + 2;    

	return "Unknown";
}

static int cmd_shcmds(void){
	showcmds(hlptxt);
}


/*
	dump jados partitions between sector first and sector last on device
*/
static int dump_jd_partitions(UINT first, UINT last)
{
	UINT ssector, count, i, size;
	DRESULT dres;
	struct jdhd *pJDHd;
	UCHAR* pboot;


		// allocate memory for bootblock
		pboot = (void*)malloc(BBSIZE*CLUSTERSIZE);
		if(!pboot) { // errorhandling
				printf("fdisk: no memory for pboot\n");
				//free(pJDFs);
				free(pJDHd);
				return FR_NOT_ENOUGH_CORE;
		}
		// allocate memory for JADOS harddisk descriptor
		pJDHd = (struct jdhd*)malloc(sizeof(struct jdhd));
		if(!pJDHd) { // errorhandling
				printf("fdisk: no memory for pJDHd\n");
				//free(pJDFs);
				return FR_NOT_ENOUGH_CORE;
		}
		memset(pJDHd,0,sizeof(struct jdhd)); // reset all values....

		pJDHd->csize = CLUSTERSIZE ;          /* JADOS uses 1024 bytes per 'sector' */
		pJDHd->spc = CLUSTERSIZE / geo.sectorsize;  /* sectors per cluster = 2 for a device with 512 bytes sector size */
		pJDHd->nsectors = last - first + 1;
 
		// read in bootblock ...
		dres = driver->blk_oper->read( &devp, pboot, first, BBSIZE * pJDHd->spc);

		// check jados label
		printf("disk label: '%c%c%c%c%c%c%c%c', start sector = %d\n",pboot[4],pboot[5],pboot[6],pboot[7],pboot[8],pboot[9],pboot[10],pboot[11],first);
		if( pboot[0] != 0x4E || pboot[1] != 0x71 || pboot[2] != 0x60 || pboot[3] != 0x08 ||
				pboot[4] != 0x4B || pboot[5] != 0x4A || pboot[6] != 0x38 || pboot[7] != 0x36 )  // NOP BRA *+8 'KJ86'
		{
				printf("fdisk: not a JADOS harddisk or bootblock has no valid bootloader !\n");
				//free(pJDFs);
				free(pJDHd);
				free(pboot);
				return 0;
		}

		// walk through the disk ....
		printf("valid jados volumes:\n"); 
		dres = RES_OK;
		i=0;
		ssector = first + FCLUSTER * pJDHd->spc; /* 1st sector of 1st JADOS disk */

		if(ssector > last){
			printf("fdisk: not enough space on volume %u !\n",i);
			//free(pJDFs);
			free(pJDHd);
			free(pboot);
			return 0;
		}

		do{
						
				//fsnkc_dbg(" check if partition %d startig at sector %d is valid (maxsector = %d)...\n ",i,ssector,pJDHd->nsectors);
				dres = driver->blk_oper->read(&devp, pboot, ssector, 1); // we use pboot as tmp buffer

				if(dres != RES_OK){     
					printf("fdisk error %d blk-read (1)\n", dres);
					//free(pJDFs);
					free(pJDHd);
					free(pboot);
					return dres + DRESULT_OFFSET;
				}

				if(pboot[0] == 0xE5 && pboot[1] == 0xE5 && pboot[2] == 0xE5 && pboot[3] == 0xE5)
				{
					pJDHd->pvalid[i] = 1;

					size = pJDHd->nsectors - ssector;
					if(size > PART_SIZE*pJDHd->spc) size = PART_SIZE*pJDHd->spc; 
					printf("%c ",i+'A');
					//printf("%c at sec %d (%d secs, %d clus, %.2fMB ) (nssec: %d)\n",i+'A',ssector,size,size/pJDHd->spc,(size/pJDHd->spc)/1024.0, 
					//																															first + (FCLUSTER + (i+1)*PART_SIZE) * pJDHd->spc);
				}

				i++;
				// calc next sector, check in while for validity
				ssector = first + (FCLUSTER + i*PART_SIZE) * pJDHd->spc;

		} while(i < MAX_PARTITIONS && ssector < last && dres == RES_OK);

		printf("\nhint: to delete a JADOS HD (not in a partion) delete partition 0\n");

		printf("\n");
		//free(pJDFs);
		free(pJDHd);
		free(pboot);
}
/*
	print the partition table
*/
static int cmd_p(char* args)
{	
	int res;
	int i;
	unsigned char *p;
	UINT size;
	
	if (geo.nsectors > 0x7FFFFF){
		size = geo.nsectors >> 10; // /1024
		size = size * geo.sectorsize;
	} else{
		size = (geo.nsectors * geo.sectorsize) >> 10;// /1024;
	}
	// print general disk information  %12llu
	printf("Disk %s: %s, %12llu bytes\n", drive, geo.model, (LONGLONG)geo.nsectors * geo.sectorsize);
	//printf("Disk %s: %s, %u MB\n", drive, geo.model, size/1024);
	printf("%d heads, %d sectors/track, %d cylinders (=> %ld sectors)\n",geo.heads, geo.sptrack, geo.cylinders, geo.heads*geo.sptrack*geo.cylinders);
	printf("total logical/lba sectors: %ld/%ld\n",geo.nsectors,geo.lba_sectors);
	printf("Sector size (logical/unformatted) %u bytes / %u bytes\n", geo.sectorsize, geo.raw_sectorsize); // logical = 512, unformatted > 512 
	printf("Disklabel type: 0x%04x - %s\n",pMBR->signature,disklabel_type(pMBR->signature)); // 55AA (dos)
	printf("Disk identifier: 0x%08x\n\n",ENDIAN(pMBR->drivesig)); 
	// print partition table
	//if(pMBR->signature == 0x55aa){
		printf("%-6s  %-4s %10s %10s %10s %10s %-2s %-4s\n","Device","Boot","Start","End","Sectors","Size(MB)","Id","Type");
		// print information of the 4 partition table entries
		for(i=0; i<4; i++){
			if (pMBR->pt[i].num_sector) {

				if (ENDIAN(pMBR->pt[i].num_sector) > 0x7FFFFF){
					size = ENDIAN(pMBR->pt[i].num_sector) >> 10; // /1024
					size = size * geo.sectorsize;
				} else{
					size = (ENDIAN(pMBR->pt[i].num_sector) * geo.sectorsize) >> 10;// /1024;
				}

				printf("%s%d    %02x   %10u %10u %10u %10u %02x %s\n", drive,i, pMBR->pt[i].bootable, 
					                   ENDIAN(pMBR->pt[i].start_sector), 
					                   ENDIAN(pMBR->pt[i].start_sector) + ENDIAN(pMBR->pt[i].num_sector) - 1, 
					                   ENDIAN(pMBR->pt[i].num_sector), size/1024, 
					                   pMBR->pt[i].type, partition_type(pMBR->pt[i].type));
			}
		}
	//}
	
	// print information of JADOS partitions
	for(i=0; i<4; i++){
		if (pMBR->pt[i].type == 0xB0){
			printf("\nJADOS disk in partition %d:\n",i);
		  dump_jd_partitions(ENDIAN(pMBR->pt[i].start_sector),ENDIAN(pMBR->pt[i].start_sector) + ENDIAN(pMBR->pt[i].num_sector) - 1);
	  }
	}

	p = (unsigned char*)pMBR;
	// check jados label
		if( p[0] == 0x4E && p[1] == 0x71 &&    // NOP
				p[2] == 0x60 && p[3] == 0x08 &&    // BRA *+8
				p[4] == 0x4B && p[5] == 0x4a &&    // 'KJ'
				p[6] == 0x38 && p[7] == 0x36)     {// '86'
		printf("\nJADOS (v%c%c%c%c) hard disk ...\n",p[8],p[9],p[10],p[11]);
		dump_jd_partitions(0,geo.nsectors);
	}
	
	return 0;
}



/* 
	toggle a bootable flag
*/
static int cmd_t(char* args)
{
	int i_in;
	char c_in[2];

	c_in[1] = 0;
	printf("partition: "); 
	//c_in = getch(); // FIXME getch() does not work reliable !
	c_in[0] = keyci();
	i_in = atoi(c_in);
	printf("%d\n",i_in);

	if(pMBR->pt[i_in].bootable > 0) pMBR->pt[i_in].bootable = 1;
	else pMBR->pt[i_in].bootable = 0;

	task_add(T_WRITE_MBR, 0, 0, 0);
}

/* 
	delete a partition
*/
static int cmd_d(char* args)
{
	int i_in;
	char c_in[2];

	c_in[1] = 0;
	printf("partition to delete: "); 
	//c_in = getch(); // FIXME getch() does not work reliable !
	c_in[0] = keyci();
	i_in = atoi(c_in);
	printf("%d\n",i_in);

	if(i_in >= 0 && i_in < 4 && pMBR->pt[i_in].num_sector){
		
		printf("\n%s%d    %02x   %8ld   %8ld   %8ld  %8ld  %02x %s\n", 
			drive,i_in, pMBR->pt[i_in].bootable, 
			ENDIAN(pMBR->pt[i_in].start_sector),
			ENDIAN(pMBR->pt[i_in].start_sector) + ENDIAN(pMBR->pt[i_in].num_sector) - 1, 
			ENDIAN(pMBR->pt[i_in].num_sector), 
			geo.sectorsize*ENDIAN(pMBR->pt[i_in].num_sector)/1024/1024, 
			pMBR->pt[i_in].type, 
			partition_type(pMBR->pt[i_in].type));

		printf(" delete ? [y/N]:"); c_in[0] = keyci();
		if(c_in[0] == 'Y' || c_in[0] == 'y'){

			pMBR->pt[i_in].bootable = 0; 
			pMBR->pt[i_in].start_sector = 0;
			pMBR->pt[i_in].num_sector = 0;
			pMBR->pt[i_in].type= 0;
			pMBR->pt[i_in].start_chs = 0;
			pMBR->pt[i_in].end_chs = 0;
	 
			printf(" partition %d deleted...\n",i_in);
			task_add(T_WRITE_MBR, 0, 0, 0);
			return 0;
		}
		printf("\n");
	}else{
		printf("invalid partition %d \n", i_in);
		return 0;
	}

	return 0;
}

// FIXME:
static unsigned int check_fat_type(){

}


#if 1
#define	SZ_DIR		32				/* Size of a directory entry */
#define N_ROOTDIR	512				/* Number of root directory entries for FAT12/16 */
#define N_FATS		2				/* Number of FAT copies (1 or 2) */

/* FAT sub-type boundaries */
#define MIN_FAT16	4086U	/* Minimum number of clusters for FAT16 */
#define	MIN_FAT32	65526U	/* Minimum number of clusters for FAT32 */

#define FS_FAT12  0x01
#define FS_FAT16a 0x04 		/* FAT16   (volume size <  65536sec/32MB) */
#define FS_FAT16  0x06
#define FS_FAT32  0x0c


#define	FSI_LeadSig			0	/* FSI: Leading signature (4) */
#define	FSI_StrucSig		484	/* FSI: Structure signature (4) */
#define	FSI_Free_Count		488	/* FSI: Number of free clusters (4) */
#define	FSI_Nxt_Free		492	/* FSI: Last allocated cluster (4) */
#define BS_55AA				510	/* Boot sector signature (2) */

static int mkfs_fat(unsigned int partition, unsigned int type){

	struct VBR_FAT16 *pvbr16;
	struct VBR_EXT_FAT32 *pvbr32;
	UINT RootDirSectors,TmpVal1,TmpVal2,FATSz,BPB_FATSz16,BPB_FATSz32,BPB_NumFATs,BPB_BytsPerSec,DiskSize;
	UCHAR BPB_SecPerClus;
	USHORT BPB_RootEntCnt,BPB_ResvdSecCnt;
	UINT DataSec,CountofClusters;
	DRESULT res = RES_PARERR;
	BYTE *buffer;

	DWORD b_vol,    /* volume start sector */ 
	      b_fat,    /* FAT start sector */
	      b_dir, 	/* DIR start sector */
	      b_data,	/* DATA start sector */
	      DeviceBlockSize,i,n,md,wsect;
	DWORD n_vol,	/* volume size in sectors == DiskSize */ 
	      n_rsv,    /* reserved bytes => BPB_ResvdSecCnt */
	      n_fat,    /* FAT size */
	      n_dir;	/* DIR size */

	

	printf(" writing partition table to mbr...\n");
	res = driver->blk_oper->write( &devp, pMBR,0,1);

	printf(" writing vbr (size= %d bytes) to partition %d at sector %d ...\n", sizeof(struct VBR_EXT_FAT32), partition , ENDIAN(pMBR->pt[partition].start_sector));
	
	BPB_NumFATs = N_FATS;
	BPB_BytsPerSec = 512;
	DiskSize = ENDIAN(pMBR->pt[partition].num_sector);

	switch(type){
		case 0x01: // FAT12
		case 0x04: // FAT16a    /* (volume size <  65536sec/32MB) */
		case 0x06: // FAT16     /* (volume size >= 65536sec/32MB) */
		    pvbr16 = malloc(sizeof(struct VBR_FAT16));
		    if(pvbr16 == NULL){
		    	printf("mkfs_fat: memory allocation error pvbr16\n");
		    	return 0;
		    }
		    /* pre calculate FAT16 values */		  
		    BPB_SecPerClus = SecPerClusFAT16(DiskSize);
		    BPB_RootEntCnt = 512; /* always 512 on FAT16 */
		    BPB_ResvdSecCnt= 0x01;
		    /* calculate number of sectors per FAT12/16 */
		    RootDirSectors = ((32 * BPB_RootEntCnt) + (BPB_BytsPerSec-1))/BPB_BytsPerSec;
			TmpVal1 = DiskSize - (BPB_ResvdSecCnt + RootDirSectors);
			TmpVal2 = (256 * BPB_SecPerClus) + BPB_NumFATs;
			FATSz = (TmpVal1 + (TmpVal2 - 1)) / TmpVal2;
			BPB_FATSz16 = LOWORD(FATSz);

			//--
			b_vol = ENDIAN(pMBR->pt[partition].start_sector);	/* Volume start sector */
			n_vol = DiskSize;									/* Volume size */
			n_rsv = BPB_ResvdSecCnt;
			n_fat = (CountofClusters * 2) + 4;  /* FAT12: n_fat = (CountofClusters * 3 + 1) / 2 + 3 */
			n_fat = (n_fat + BPB_BytsPerSec - 1) / BPB_BytsPerSec;
			n_dir = (DWORD)N_ROOTDIR * SZ_DIR / BPB_BytsPerSec; /* DIR size in sectors */

			b_fat = b_vol + n_rsv;				/* FAT area start sector = volume start sector + reserved bytes*/
			b_dir = b_fat + n_fat * N_FATS;		/* Directory area start sector */
	        b_data = b_dir + n_dir;				/* Data area start sector */

	        //if (n_vol < b_data + BPB_SecPerClus - b_vol) return FR_MKFS_ABORTED;	/* Too small volume */

	        /* Align data start sector to erase block boundary (for flash memory media) */
			res = driver->blk_oper->ioctl(&devp,GET_BLOCK_SIZE,&DeviceBlockSize);
			if (res != RES_OK || !DeviceBlockSize || DeviceBlockSize > 32768) DeviceBlockSize = 1;
			DeviceBlockSize = (b_data + DeviceBlockSize - 1) & ~(DeviceBlockSize - 1);	/* Next nearest erase block from current data start */
			DeviceBlockSize = (DeviceBlockSize - b_data) / N_FATS;										
			n_fat += DeviceBlockSize; /* FAT12/16: Expand FAT size */
			BPB_FATSz16 += DeviceBlockSize;
			printf("n_fat=%d, BPB_FATSz16=%d\n",n_fat,BPB_FATSz16);
			//--

			printf("FAT16:\nRootDirSectors=%u, DiskSize=%u, BPB_RootEntCnt=%u, BPB_BytsPerSec=%u, BPB_ResvdSecCnt=%u, BPB_SecPerClus=%u, BPB_NumFATs=%u\nTmpVal1=%u, TmpVal2=%u, FATSz=%u\n\n",
																									RootDirSectors,DiskSize,BPB_RootEntCnt,BPB_BytsPerSec, BPB_ResvdSecCnt, BPB_SecPerClus,BPB_NumFATs,
																									TmpVal1, TmpVal2, FATSz);
						
			//memset(pvbr16->JUMP2BOOTSTRAP,0,3);
			pvbr16->JUMP2BOOTSTRAP[0] = 0xEB; /* set dummy jump at start of sector */
			pvbr16->JUMP2BOOTSTRAP[1] = 0xFE;
			pvbr16->JUMP2BOOTSTRAP[2] = 0x90;
			memcpy(pvbr16->OEM_name,"MSDOS5.0",8);
			pvbr16->Sig = 0x55aa;
			pvbr16->bpb.BytsPerSec = BYTESWAP(BPB_BytsPerSec);
			pvbr16->bpb.SecPerClus = BPB_SecPerClus;
			pvbr16->bpb.RsvdSecCnt = BYTESWAP(BPB_ResvdSecCnt);
			pvbr16->bpb.NumFATs = BPB_NumFATs;
			pvbr16->bpb.RootEntries = BYTESWAP(BPB_RootEntCnt); /* always 512 on FAT16 */
			pvbr16->bpb.TotSec16 = BYTESWAP(DiskSize);
			pvbr16->bpb.MediaDescr = 0xf8; /* Hard Disk */
			pvbr16->bpb.FATSz16 = BYTESWAP(BPB_FATSz16); 
			pvbr16->bpb.SecPerTrack = 0;
			pvbr16->bpb.HeadsPerCyl = 0;
			pvbr16->bpb.HiddenSec = 0;
			pvbr16->bpb.TotSec32 = 0; /* => use TotSec16 */
			pvbr16->bpb.drive_number = 0x80;
			pvbr16->bpb.reserved = 0;
			pvbr16->bpb.extBootSig = 0x29;
			memcpy(pvbr16->bpb.VolID,"1234",4);
			memcpy(pvbr16->bpb.VolLabel,"NO NAME    ",11);
			memcpy(pvbr16->bpb.Type,"FAT16   ",8);


			// check FAT type:
			DataSec = DiskSize - (BPB_ResvdSecCnt + (BPB_NumFATs * BPB_FATSz16) + RootDirSectors);
			CountofClusters = DataSec / BPB_SecPerClus;
			printf("%u data sectors in %u clusters\n",DataSec,CountofClusters);

			if(CountofClusters < MIN_FAT16 && n_vol < 0x10000) {
				printf("Volume is FAT12 (0x01), restarting...\n");
				type = 0x01;
				free(pvbr16);
				return mkfs_fat(partition, 0x01);
			} else if(CountofClusters < MIN_FAT32) {
				if(n_vol < 0x10000){
			    	printf("Volume is FAT16 (size < 65536 sec/32MB), updating MBR...\n");
			    	type = 0x04;
			    	pMBR->pt[partition].type = type;
			    	res = driver->blk_oper->write( &devp, pMBR,0,1);
			    } else{
			    	printf("Volume is FAT16 (size >= 65536 sec/32MB), updating MBR...\n");
			    	type = 0x06;			    	
			    	pMBR->pt[partition].type = type;
			    	res = driver->blk_oper->write( &devp, pMBR,0,1);
			    }
			} else {
			    printf("Volume is FAT32, restarting ....\n");
			    type = 0x0c;
			    free(pvbr16);
			    return mkfs_fat(partition, 0x0c);			    
			}
			
			// write VBR to disk
			res = driver->blk_oper->write( &devp, pvbr16,ENDIAN(pMBR->pt[partition].start_sector),1);

			md = pvbr16->bpb.MediaDescr;

			free(pvbr16);
			break;

		case 0x0c: // Win95 FAT32 (LBA) 
		    pvbr32 = malloc(sizeof(struct VBR_EXT_FAT32));
		    if(pvbr32 == NULL){
		    	printf("mkfs_fat: memory allocation error pvbr32\n");
		    	return 0;
		    }
		    /* pre calculate FAT32 values */
		    BPB_SecPerClus = SecPerClusFAT32(DiskSize);
		    BPB_RootEntCnt = 0; /* always 0 on FAT32 */
		    BPB_ResvdSecCnt= 0x20;
		    /* calculate number of sectors per FAT32 */		    
		    RootDirSectors = 0; //((32 * BPB_RootEntCnt) + (BPB_BytsPerSec - 1))/BPB_BytsPerSec;
			TmpVal1 = DiskSize - (BPB_ResvdSecCnt + RootDirSectors);
			TmpVal2 = (256 * BPB_SecPerClus) + BPB_NumFATs;
			TmpVal2 = TmpVal2 / 2;
			FATSz = (TmpVal1 + (TmpVal2 - 1)) / TmpVal2;
			BPB_FATSz16 = 0;
			BPB_FATSz32 = FATSz;

			//--
			b_vol = ENDIAN(pMBR->pt[partition].start_sector);	/* Volume start sector */
			n_vol = DiskSize;									/* Volume size */
			n_rsv = BPB_ResvdSecCnt;
			n_fat = ((CountofClusters * 4) + 8 + BPB_BytsPerSec - 1) / BPB_BytsPerSec;
			n_dir = 0;

			b_fat = b_vol + n_rsv;				/* FAT area start sector = volume start sector + reserved bytes*/
			b_dir = b_fat + n_fat * N_FATS;		/* Directory area start sector */
	        b_data = b_dir + n_dir;				/* Data area start sector */

	        //if (n_vol < b_data + BPB_SecPerClus - b_vol) return FR_MKFS_ABORTED;	/* Too small volume */

	        res = driver->blk_oper->ioctl(&devp,GET_BLOCK_SIZE,&DeviceBlockSize);
			if (res != RES_OK || !DeviceBlockSize || DeviceBlockSize > 32768) DeviceBlockSize = 1;
			DeviceBlockSize = (b_data + DeviceBlockSize - 1) & ~(DeviceBlockSize - 1);	/* Next nearest erase block from current data start */
			DeviceBlockSize = (DeviceBlockSize - b_data) / N_FATS;					
			n_rsv += DeviceBlockSize; /* FAT32: Move FAT offset */
			b_fat += DeviceBlockSize;
			BPB_ResvdSecCnt += DeviceBlockSize;
			BPB_FATSz16 += DeviceBlockSize;
			BPB_FATSz32 += DeviceBlockSize;
			printf("n_fat=%d, BPB_FATSz16=%d, BPB_FATSz32=%d\n",n_fat,BPB_FATSz16,BPB_FATSz32);

			printf("FAT32:\nRootDirSectors=%u, DiskSize=%u, BPB_RootEntCnt=%u, BPB_BytsPerSec=%u, BPB_ResvdSecCnt=%u, BPB_SecPerClus=%u, BPB_NumFATs=%u\nTmpVal1=%u, TmpVal2=%u, FATSz=%u\n\n",
																									RootDirSectors,DiskSize,BPB_RootEntCnt,BPB_BytsPerSec, BPB_ResvdSecCnt, BPB_SecPerClus,BPB_NumFATs,
																									TmpVal1, TmpVal2, FATSz);
			//(memset(pvbr32->JUMP2BOOTSTRAP,0,3);
			pvbr32->JUMP2BOOTSTRAP[0] = 0xEB; /* set dummy jump at start of sector */
			pvbr32->JUMP2BOOTSTRAP[1] = 0xFE;
			pvbr32->JUMP2BOOTSTRAP[2] = 0x90;
			memcpy(pvbr32->OEM_name,"MSDOS5.0",8);      
			pvbr32->Sig = 0x55aa;
			pvbr32->bpb.BytsPerSec = BYTESWAP(BPB_BytsPerSec);
			pvbr32->bpb.SecPerClus = BPB_SecPerClus;
			pvbr32->bpb.RsvdSecCnt = BYTESWAP(BPB_ResvdSecCnt);
			pvbr32->bpb.NumFATs = BPB_NumFATs;
			pvbr32->bpb.RootEntries = BPB_RootEntCnt; /* must be 0 in FAT32 */
			pvbr32->bpb.TotSec16 = 0; /* => use TotSec32 */
			pvbr32->bpb.MediaDescr = 0xf8; /* Hard Disk */
			pvbr32->bpb.FATSz16 = BYTESWAP(BPB_FATSz16);
			pvbr32->bpb.SecPerTrack = 0;
			pvbr32->bpb.HeadsPerCyl = 0;
			pvbr32->bpb.HiddenSec = 0;
			pvbr32->bpb.TotSec32 = pMBR->pt[partition].num_sector;
			pvbr32->bpb.FATSz32 = ENDIAN(BPB_FATSz32); 
			pvbr32->bpb.ExtFlags = 0; /* FIXME: need to be set ? */
			pvbr32->bpb.FSVersion = 0;
			pvbr32->bpb.RootClus = 2;
			pvbr32->bpb.FSInfoSec = 1;
			pvbr32->bpb.BackupBootSec = 6;
			memset(pvbr32->bpb.reserved,0,12);
			pvbr32->bpb.Cf_0x024 = 0x80;
			pvbr32->bpb.Cf_0x025 = 0;
			pvbr32->bpb.Cf_0x026 = 0x29;
			memcpy(pvbr32->bpb.Cf_0x027,"1234",4);
			memcpy(pvbr32->bpb.Cf_0x02B,"NO NAME    ",11);
			memcpy(pvbr32->bpb.Cf_0x036,"FAT32   ",8);

			// check FAT type:
			DataSec = DiskSize - (BPB_ResvdSecCnt + (BPB_NumFATs * BPB_FATSz32) + RootDirSectors);
			CountofClusters = DataSec / BPB_SecPerClus;
			printf("%u data sectors in %u clusters\n",DataSec,CountofClusters);
			if(CountofClusters < 4085) {
				printf("Volume is FAT12, restarting ...\n");
				free(pvbr32);
				return mkfs_fat(partition, 0x01);;
			} else if(CountofClusters < 65525) {
			    printf("Volume is FAT16, restarting\n");
			    free(pvbr32);
			    return mkfs_fat(partition, 0x06);
			} else {
			    printf("Volume is FAT32\n");			    
			}

			// write VBR to disk
			driver->blk_oper->write( &devp, pvbr32,ENDIAN(pMBR->pt[partition].start_sector),1);

			md = pvbr32->bpb.MediaDescr;
			
			free(pvbr32);
			break;

		default:
			printf(" FAT type 0x%02x not supperted !\n",type);
			return 0; 
	}


	/* -----------------------------  Initialize FAT area --------------------------------------- */
	buffer = malloc(BPB_BytsPerSec);
    if(buffer == NULL){
    	printf("mkfs_fat: memory allocation error buffer\n");
    	return 0;
    }

	printf(" Initialize FAT area...\n");
	wsect = b_fat;
	for (i = 0; i < N_FATS; i++) {				/* Initialize each FAT copy */
		memset(buffer, 0, BPB_BytsPerSec);		/* 1st sector of the FAT  */
		n = md;									/* Media descriptor byte */
		if (type != FS_FAT32) {
			n |= (type == FS_FAT12) ? 0x00FFFF00 : 0xFFFFFF00;
			*(DWORD*)(buffer+0) = (DWORD)n;				/* Reserve cluster #0-1 (FAT12/16) */
		} else {
			n |= 0xFFFFFF00;
			*(DWORD*)(buffer+0) = n;				/* Reserve cluster #0-1 (FAT32) */
			*(DWORD*)(buffer+4) = 0xFFFFFFFF;
			*(DWORD*)(buffer+8) = 0x0FFFFFFF;	/* Reserve cluster #2 for root directory */
		}

		res = driver->blk_oper->write( &devp, buffer, wsect++,1);
		if (res) {
			free(buffer);
			return FR_DISK_ERR;
		}
			
		memset(buffer, 0, BPB_BytsPerSec);			/* Fill following FAT entries with zero */
				
		printf(" loop through (%d) FAT entries: ",n_fat);
		
		start_progress();
		for (n = 1; n < n_fat; n++) {		/* This loop may take a time on FAT32 volume due to many single sector writes */
			do_progress();
			
			res = driver->blk_oper->write( &devp, buffer, wsect++,1);
			if (res) {
				free(buffer);
				return FR_DISK_ERR;
			}
		}		
	}
	printf("\n");

	/* -------------------------- Initialize root directory ---------------------------------- */

	i = (type == FS_FAT32) ? BPB_SecPerClus : (UINT)n_dir;  // n_dir = DIR size in sectors
	do {
		res = driver->blk_oper->write( &devp, buffer, wsect++,1);
		if (res) {
			free(buffer);
			return FR_DISK_ERR;
		}
	} while (--i);
	
    #if 0	/* Erase data area if needed */
	{
		DWORD eb[2];

		eb[0] = wsect; eb[1] = wsect + (CountofClusters - ((type == FS_FAT32) ? 1 : 0)) * au - 1;
		res = blk_drv->blk_oper->ioctl(&devp,CTRL_ERASE_SECTOR,eb);
	}
	#endif

	/* Create FSINFO if needed */
	if (type == FS_FAT32) {
		*(DWORD*)(buffer+FSI_LeadSig) = 0x41615252;
		*(DWORD*)(buffer+FSI_StrucSig) = 0x61417272;
		*(DWORD*)(buffer+FSI_Free_Count) = CountofClusters - 1;	/* Number of free clusters */
		*(DWORD*)(buffer+FSI_Nxt_Free) = 2;				/* Last allocated cluster# */
		*(DWORD*)(buffer+BS_55AA) = 0xAA55;

		res = driver->blk_oper->write( &devp, buffer, b_vol + 1,1); /* Write original (VBR+1) */
		res = driver->blk_oper->write( &devp, buffer, b_vol + 7,1); /* Write backup (VBR+7) */  
	}

	res = driver->blk_oper->ioctl(&devp,CTRL_SYNC,0);

	free(buffer);
	/* ------------------------------------------------------------------------------------------- */
				
	return 0;
}
	
	
#else
static int mkfs_fat(unsigned int partition, unsigned int type){

	struct VBR_FAT16 *pvbr16;
	struct VBR_EXT_FAT32 *pvbr32;
	UINT RootDirSectors,TmpVal1,TmpVal2,FATSz,BPB_FATSz16,BPB_FATSz32,BPB_NumFATs,BPB_BytsPerSec,DiskSize;
	UCHAR BPB_SecPerClus;
	USHORT BPB_RootEntCnt,BPB_ResvdSecCnt;
	UINT DataSec,CountofClusters;

	printf(" writing partition table to mbr...\n");
	driver->blk_oper->write( &devp, pMBR,0,1);

	printf(" writing vbr (size= %d bytes) to partition %d at sector %d ...\n", sizeof(struct VBR_EXT_FAT32), partition , ENDIAN(pMBR->pt[partition].start_sector));
	
	BPB_NumFATs = 2;
	BPB_BytsPerSec = 512;
	DiskSize = ENDIAN(pMBR->pt[partition].num_sector);


	switch(type){
		case 0x06: // FAT16
		    pvbr16 = malloc(sizeof(struct VBR_FAT16));
		    if(pvbr16 == NULL){
		    	printf("mkfs_fat: memory allocation error pvbr16\n");
		    	return 0;
		    }
		    /* pre calculate FAT16 values */		  
		    BPB_SecPerClus = SecPerClusFAT16(DiskSize);
		    BPB_RootEntCnt = 512; /* always 512 on FAT16 */
		    BPB_ResvdSecCnt= 0x01;
		    /* calculate number of sectors per FAT12/16 */
		    RootDirSectors = ((32 * BPB_RootEntCnt) + (BPB_BytsPerSec-1))/BPB_BytsPerSec;
			TmpVal1 = DiskSize - (BPB_ResvdSecCnt + RootDirSectors);
			TmpVal2 = (256 * BPB_SecPerClus) + BPB_NumFATs;
			FATSz = (TmpVal1 + (TmpVal2 - 1)) / TmpVal2;
			BPB_FATSz16 = LOWORD(FATSz);

			printf("FAT16:\nRootDirSectors=%u, DiskSize=%u, BPB_RootEntCnt=%u, BPB_BytsPerSec=%u, BPB_ResvdSecCnt=%u, BPB_SecPerClus=%u, BPB_NumFATs=%u\nTmpVal1=%u, TmpVal2=%u, FATSz=%u\n\n",
																									RootDirSectors,DiskSize,BPB_RootEntCnt,BPB_BytsPerSec, BPB_ResvdSecCnt, BPB_SecPerClus,BPB_NumFATs,
																									TmpVal1, TmpVal2, FATSz);
						
			//memset(pvbr16->JUMP2BOOTSTRAP,0,3);
			pvbr16->JUMP2BOOTSTRAP[0] = 0xEB; /* set dummy jump at start of sector */
			pvbr16->JUMP2BOOTSTRAP[1] = 0xFE;
			pvbr16->JUMP2BOOTSTRAP[2] = 0x90;
			memcpy(pvbr16->OEM_name,"MSDOS5.0",8);
			pvbr16->Sig = 0x55aa;
			pvbr16->bpb.BytsPerSec = BYTESWAP(BPB_BytsPerSec);
			pvbr16->bpb.SecPerClus = BPB_SecPerClus;
			pvbr16->bpb.RsvdSecCnt = BYTESWAP(BPB_ResvdSecCnt);
			pvbr16->bpb.NumFATs = BPB_NumFATs;
			pvbr16->bpb.RootEntries = BYTESWAP(BPB_RootEntCnt); /* always 512 on FAT16 */
			pvbr16->bpb.TotSec16 = BYTESWAP(DiskSize);
			pvbr16->bpb.MediaDescr = 0xf8; /* Hard Disk */
			pvbr16->bpb.FATSz16 = BYTESWAP(BPB_FATSz16); 
			pvbr16->bpb.SecPerTrack = 0;
			pvbr16->bpb.HeadsPerCyl = 0;
			pvbr16->bpb.HiddenSec = 0;
			pvbr16->bpb.TotSec32 = 0; /* => use TotSec16 */
			pvbr16->bpb.drive_number = 0x80;
			pvbr16->bpb.reserved = 0;
			pvbr16->bpb.extBootSig = 0x29;
			memcpy(pvbr16->bpb.VolID,"1234",4);
			memcpy(pvbr16->bpb.VolLabel,"NO NAME    ",11);
			memcpy(pvbr16->bpb.Type,"FAT16   ",8);



			// check FAT type:
			DataSec = DiskSize - (BPB_ResvdSecCnt + (BPB_NumFATs * BPB_FATSz16) + RootDirSectors);
			CountofClusters = DataSec / BPB_SecPerClus;
			printf("%u data sectors in %u clusters\n",DataSec,CountofClusters);
			if(CountofClusters < 4085) {
				printf("Volume is FAT12\n");
			} else if(CountofClusters < 65525) {
			    printf("Volume is FAT16\n");
			} else {
			    printf("Volume is FAT32\n");			    
			}

			// write VBR to disk
			//FIXME: driver->blk_oper->write( &devp, pvbr16,ENDIAN(pMBR->pt[partition].start_sector),1);
			free(pvbr16);
			break;

		case 0x0c: // Win95 FAT32 (LBA) 
		    pvbr32 = malloc(sizeof(struct VBR_EXT_FAT32));
		    if(pvbr32 == NULL){
		    	printf("mkfs_fat: memory allocation error pvbr32\n");
		    	return 0;
		    }
		    /* pre calculate FAT32 values */
		    BPB_SecPerClus = SecPerClusFAT32(DiskSize);
		    BPB_RootEntCnt = 0; /* always 0 on FAT32 */
		    BPB_ResvdSecCnt= 0x20;
		    /* calculate number of sectors per FAT32 */		    
		    RootDirSectors = 0; //((32 * BPB_RootEntCnt) + (BPB_BytsPerSec - 1))/BPB_BytsPerSec;
			TmpVal1 = DiskSize - (BPB_ResvdSecCnt + RootDirSectors);
			TmpVal2 = (256 * BPB_SecPerClus) + BPB_NumFATs;
			TmpVal2 = TmpVal2 / 2;
			FATSz = (TmpVal1 + (TmpVal2 - 1)) / TmpVal2;
			BPB_FATSz16 = 0;
			BPB_FATSz32 = FATSz;

			printf("FAT32:\nRootDirSectors=%u, DiskSize=%u, BPB_RootEntCnt=%u, BPB_BytsPerSec=%u, BPB_ResvdSecCnt=%u, BPB_SecPerClus=%u, BPB_NumFATs=%u\nTmpVal1=%u, TmpVal2=%u, FATSz=%u\n\n",
																									RootDirSectors,DiskSize,BPB_RootEntCnt,BPB_BytsPerSec, BPB_ResvdSecCnt, BPB_SecPerClus,BPB_NumFATs,
																									TmpVal1, TmpVal2, FATSz);
			//(memset(pvbr32->JUMP2BOOTSTRAP,0,3);
			pvbr32->JUMP2BOOTSTRAP[0] = 0xEB; /* set dummy jump at start of sector */
			pvbr32->JUMP2BOOTSTRAP[1] = 0xFE;
			pvbr32->JUMP2BOOTSTRAP[2] = 0x90;
			memcpy(pvbr32->OEM_name,"MSDOS5.0",8);      
			pvbr32->Sig = 0x55aa;
			pvbr32->bpb.BytsPerSec = BYTESWAP(BPB_BytsPerSec);
			pvbr32->bpb.SecPerClus = BPB_SecPerClus;
			pvbr32->bpb.RsvdSecCnt = BYTESWAP(BPB_ResvdSecCnt);
			pvbr32->bpb.NumFATs = BPB_NumFATs;
			pvbr32->bpb.RootEntries = BPB_RootEntCnt; /* must be 0 in FAT32 */
			pvbr32->bpb.TotSec16 = 0; /* => use TotSec32 */
			pvbr32->bpb.MediaDescr = 0xf8; /* Hard Disk */
			pvbr32->bpb.FATSz16 = BYTESWAP(BPB_FATSz16);
			pvbr32->bpb.SecPerTrack = 0;
			pvbr32->bpb.HeadsPerCyl = 0;
			pvbr32->bpb.HiddenSec = 0;
			pvbr32->bpb.TotSec32 = pMBR->pt[partition].num_sector;
			pvbr32->bpb.FATSz32 = ENDIAN(BPB_FATSz32); 
			pvbr32->bpb.ExtFlags = 0; /* FIXME: need to be set ? */
			pvbr32->bpb.FSVersion = 0;
			pvbr32->bpb.RootClus = 2;
			pvbr32->bpb.FSInfoSec = 1;
			pvbr32->bpb.BackupBootSec = 6;
			memset(pvbr32->bpb.reserved,0,12);
			pvbr32->bpb.Cf_0x024 = 0x80;
			pvbr32->bpb.Cf_0x025 = 0;
			pvbr32->bpb.Cf_0x026 = 0x29;
			memcpy(pvbr32->bpb.Cf_0x027,"1234",4);
			memcpy(pvbr32->bpb.Cf_0x02B,"NO NAME    ",11);
			memcpy(pvbr32->bpb.Cf_0x036,"FAT32   ",8);

			// check FAT type:
			DataSec = DiskSize - (BPB_ResvdSecCnt + (BPB_NumFATs * BPB_FATSz32) + RootDirSectors);
			CountofClusters = DataSec / BPB_SecPerClus;
			printf("%u data sectors in %u clusters\n",DataSec,CountofClusters);
			if(CountofClusters < 4085) {
				printf("Volume is FAT12\n");
			} else if(CountofClusters < 65525) {
			    printf("Volume is FAT16\n");
			} else {
			    printf("Volume is FAT32\n");			    
			}

			// write VBR to disk
			//FIXME: driver->blk_oper->write( &devp, pvbr32,ENDIAN(pMBR->pt[partition].start_sector),1);
			free(pvbr32);
			break;

		default:
			printf(" FAT type 0x%02x not supperted !\n",type);
			return 0; 
	}

	printf("exit fdisk, 'mount %s%d FAT 0' and format partition %d with 'mkfs %s%d %s 0 %d'\n",drive,partition,partition,drive,partition,fat_type(type),BPB_SecPerClus);

	return 0;
}
#endif


#define MIN_PART_SIZE 200
static int mkfs_jdxfs(unsigned int partition, unsigned int first, unsigned int last){
	unsigned int sectors, clusters, rclusters, njdparts,p, cur_sector, cur_cluster, bytes_read,PBOOT_SIZE,i,j;
	DRESULT dres;
	struct jdhd *pJDHd;
	UCHAR* pboot;
	FILE *pf;
	UCHAR xpos,ypos;

	sectors = last - first + 1;
	clusters = sectors / (CLUSTERSIZE / geo.sectorsize);
	njdparts = (clusters-BBSIZE)/PART_SIZE;
	rclusters = clusters - njdparts*PART_SIZE - BBSIZE; // rest clusters

	if(njdparts > MAX_PARTITIONS) njdparts = MAX_PARTITIONS;

	if (clusters < PART_SIZE + BBSIZE){
		printf("- not enough space (%d cluster available) for a JADOS HD file system.\n",clusters);
		printf("            at least we need %d clusters:\n", PART_SIZE + BBSIZE);
		printf("              %d clusters for bootblock\n",BBSIZE);
		printf("              %d clusters for partition\n",PART_SIZE);
		return 0;
	}

	printf("initializing bootable JADOS filesystem in partition %d\nusing %d %.2f MB JADOS partitions", 
		partition, njdparts, PART_SIZE/1024.0);

	if(rclusters > MIN_PART_SIZE){
		printf(" and one %.2f MB JADOS partition\n", rclusters/1024.0 );
	}else printf("\n");

	// allocate memory for bootblock
	PBOOT_SIZE = BBSIZE*CLUSTERSIZE;
	pboot = (void*)malloc(PBOOT_SIZE);
	if(!pboot) { // errorhandling
			printf("- no memory for pboot\n");
			return FR_NOT_ENOUGH_CORE;
	}
	

	// allocate memory for JADOS harddisk descriptor
	pJDHd = (struct jdhd*)malloc(sizeof(struct jdhd));
	if(!pJDHd) { // errorhandling
		printf("- no memory for pJDHd\n");
		free(pboot);
		return FR_NOT_ENOUGH_CORE;
	}
	memset(pJDHd,0,sizeof(struct jdhd)); // reset all values....
	pJDHd->csize = CLUSTERSIZE ;          /* JADOS uses 1024 bytes per 'sector' */
	pJDHd->spc = CLUSTERSIZE / geo.sectorsize;  /* sectors per cluster = 2 for a device with 512 bytes sector size */
	pJDHd->nsectors = last - first + 1;

	// initialize bootblock
	// write urlader.68k to bootblock (this should be done by some external program like 'sys' or 'putboot')
	pf = fopen("hda0:urlader.68k","rb");
	if(pf == NULL){
		printf("- cannot open file hda0:urlader.68k\n");
		free(pboot);
		return FR_NOT_ENOUGH_CORE;
	}
	memset(pboot,0x00, PBOOT_SIZE); // initialize buffer.... 

	printf("- opened hda0:urlader.68k, reading to buffer...\n");
	bytes_read = fread(pboot,PBOOT_SIZE,1,pf);
	//printf("mkfs_jdxfs: initializing bootblock: src= 0x08x, ssec = %d, nsec = %d ....\n",pboot,first,BBSIZE*pJDHd->spc);
	printf("- initializing bootblock ....\n");

	dres = driver->blk_oper->write( &devp, pboot, first, BBSIZE*pJDHd->spc);    /* write bootblock */ 
	
	// initialize partitions
	memset(pboot,0xE5, PBOOT_SIZE); // initialize buffer....
	printf("- initializing partitions ");
	for(p=0; p<njdparts;p++){		
		gp_getxy(&xpos,&ypos);
		cur_sector =  first + (BBSIZE + p*PART_SIZE)*pJDHd->spc;
		// cluster 0 = FAT
		// cluster 1-9 = DIRECTORY
		// cluster 10 - 2559 = FREE SPACE (2550 clusters)
		i = PART_SIZE * pJDHd->spc;
		j = 0;
		while(i>BBSIZE*pJDHd->spc){
			gp_setxy(xpos,ypos);
			gp_putchar(progress[j % 4]);
			dres = driver->blk_oper->write( &devp,  pboot, cur_sector + j*BBSIZE*pJDHd->spc, BBSIZE*pJDHd->spc);    /* initialize partition */
			i = i - BBSIZE*pJDHd->spc;
			j++;
		}
		gp_setxy(xpos,ypos);
		gp_putchar(progress[j % 4]);
		dres = driver->blk_oper->write( &devp,  pboot, cur_sector + j*BBSIZE*pJDHd->spc, i); 
		gp_setxy(xpos,ypos);
		printf(".");
	}

	//printf("\nmkfs_jdxfs: current sector: %d\n",cur_sector + j*BBSIZE*pJDHd->spc + i);

	if(rclusters > MIN_PART_SIZE){
		// the last partition does not have the full size, FAT has to be adjusted accordingly
		printf("\n- initializing last partition with %d clusters (%d sectors) ",rclusters,rclusters*pJDHd->spc);
		
		cur_sector =  first + (BBSIZE + njdparts*PART_SIZE)*pJDHd->spc; /* calculate first sector of last partition */
		// cluster 0 = FAT
		// cluster 1-9 = DIRECTORY
		// cluster 10 - 2559 = FREE SPACE (2550 clusters)
		i = rclusters * pJDHd->spc; /* calculate number of sectors left in partition */
		j = 0;
		gp_getxy(&xpos,&ypos);
		while(i>BBSIZE*pJDHd->spc){			
			gp_setxy(xpos,ypos);
			gp_putchar(progress[j % 4]);
			//printf("mkfs_jdxfs: writing sector %d (num=%d), i=%d\n",cur_sector + j*BBSIZE*pJDHd->spc,BBSIZE*pJDHd->spc,i);
			dres = driver->blk_oper->write( &devp,  pboot, cur_sector + j*BBSIZE*pJDHd->spc, BBSIZE*pJDHd->spc);    /* initialize partition */

			if(dres != RES_OK){
				printf("- error %d writing to disk...\n", dres);
				free(pJDHd);
				free(pboot);
				fclose(pf);
				return 0;
			}

			if(i > BBSIZE*pJDHd->spc) /* prevent wrapping around ! */
				i = i - BBSIZE*pJDHd->spc;
			j++;
		}

		gp_setxy(xpos,ypos);
		gp_putchar(progress[j % 4]);
		//printf("\nmkfs_jdxfs: writing sector %d (restnum=%d)\n",cur_sector + j*BBSIZE*pJDHd->spc,i);
		dres = driver->blk_oper->write( &devp,  pboot, cur_sector + j*BBSIZE*pJDHd->spc, i); 
		// adjust FAT, use pboot buffer
		memset(pboot,0xE5, (rclusters+1)*4);
		memset(pboot+(rclusters+1)*4,0xFF, PBOOT_SIZE - (rclusters+1)*4);
		driver->blk_oper->write( &devp,  pboot, cur_sector, FAT_SIZE);
		gp_setxy(xpos,ypos);
		printf(".");
	}
	printf("\n");

	printf("urlader.68k has been installed into bootsector.\nManually copy JADOS.SYS to first partition to boot into JADOS...\n");

	free(pJDHd);
	free(pboot);
	fclose(pf);
}

/*
	add a partition

	Since Windows Vista, FDISK creates the first partition on LBA sector 2048 (1M alignment). It may have any CHS coordinates; they do not matter anymore.

	In Windows XP and previous versions, the first partition was created on CHS sector (C=0, H=1, S=1) which usually maps to LBA sector 63 
	(if logical geometry of this disk has 63 sectors per track). Some USB flash drives have logical geometry with 32 virtual sectors per track, 
	so the first partition starts on LBA sector 32 for them. In any case, all of this has nothing to do with actual disk geometry, 
	performance reasons, etc – it's a pure tradition, terminated in Vista/Windows 7.
*/
static int cmd_a(char* args)
{
	unsigned int i_in, first, last, type;
	char c_in;
	UINT size;

	printf("partition to add: "); 
	c_in = getchar();
	i_in = c_in - '0';
	printf("%d\n",i_in);

	if(i_in < 0 || i_in > 3 ){
		printf("invalid partition %d \n", i_in);
		return 0;
	}

	if(pMBR->pt[i_in].num_sector){
		printf("partition %d in use, delete it first.\n", i_in);
		return 0;
	}

	// make a guess on 1st sector:
	switch(i_in){
		case 0: first = 1024;
		        break;
		case 1: if(pMBR->pt[0].num_sector){
					first = ENDIAN(pMBR->pt[0].start_sector) + ENDIAN(pMBR->pt[0].num_sector);
		        }else{
		        	printf("partition 0 is empty, use it first\n");
		        	return 0;
		        }   
		        break;         
		case 2: if(pMBR->pt[1].num_sector){
					first = ENDIAN(pMBR->pt[1].start_sector) + ENDIAN(pMBR->pt[1].num_sector);
		        }else{
		        	printf("partition 1 is empty, use it first\n");
		        	return 0;
		        }     
		        break;   
		case 3: if(pMBR->pt[2].num_sector){
					first = ENDIAN(pMBR->pt[2].start_sector) + ENDIAN(pMBR->pt[2].num_sector);
		        }else{
		        	printf("partition 2 is empty, use it first\n");
		        	return 0;
		        }      
		        break; 
	}

	// guess last sector is last sector of disk
	last = geo.lba_sectors;


	printf("first sector (%d): ",first); //scanf("%u",&first);
    getline( &line_env, RES_UINT, line_env_res, 0);  
    if(line_env.Line[0] != 0) sscanf(line_env.Line,"%u",&first);


	printf("last sector (%d): ",last); //scanf("%u",&last);
	getline( &line_env, RES_UINT, line_env_res, 0); 
	if(line_env.Line[0] != 0) sscanf(line_env.Line,"%u",&last);

	printf("type (hex)  : "); //scanf("%x",&type);
	getline( &line_env, RES_UINT, line_env_res, 0); sscanf(line_env.Line,"%x",&type);

    if ((last - first) > 0x7FFFFF){
		size = (last - first) >> 10; // /1024
		size = size * geo.sectorsize;
	} else{
		size = ((last - first) * geo.sectorsize) >> 10;// /1024;
	}

	printf("first %ld, last %ld, sectors %u, size(MB) %u, type %02x\n",first,last,last-first+1,size/1024,type);

	// FIXME: check if first and last are possible values

	switch(type){
		case 0xb0: // JADOSxFS (i.e. JADOSFS in a partition)
		// for the maximum of 26 jados drives at least (2560*26 + 100)*2=133320 sectors of 512 bytes are needed in a partition
			printf("JADOS filesystem changes will be written immediately !\n");
			printf("Are you shure ? [y/N]: "); c_in = getchar();
			if(c_in != 'Y' && c_in != 'y'){          
					return 0;
			}
			printf("\n");
			printf("writing partition table to mbr...\n");
			
			pMBR->pt[i_in].num_sector = ENDIAN(last-first+1);  // number of 512 byte sectors
			pMBR->pt[i_in].bootable = 0;                       // partitions bootable flag
			pMBR->pt[i_in].start_sector = ENDIAN(first);       // start sector
			pMBR->pt[i_in].type = type;                        //

			task_add(T_WRITE_MBR, 0, 0, 0);
			task_add(T_MKFS_JDXFS, i_in, first, last);

			break;

		case 0x06: // FAT16
		case 0x0c: // Win95 FAT32 (LBA) 
			//pMBR->signature = 0x55aa;
			pMBR->pt[i_in].num_sector = ENDIAN(last-first+1);  // number of 512 byte sectors
			pMBR->pt[i_in].bootable = 0;                       // partitions bootable flag
			pMBR->pt[i_in].start_sector = ENDIAN(first);       // start sector
			pMBR->pt[i_in].type = type;                        //

			task_add(T_WRITE_MBR, 0, 0, 0);
			task_add(T_MKFS_FAT, i_in, type, 0);   
			break;

		default:
			printf("this type is not supported!\n");
	}

	return 0;
}


/*
	list free unpartitioned space
*/
static int cmd_s(char* args)
{
	
	unsigned char block,part;
	unsigned int startsec,endsec,size,bytes;
	
	printf("space on device:\n");

	printf("%-5s %10s %10s %10s %15s\n","block","start","end","sectors","size(bytes)");
	
	startsec=0;
	block=0;

	/* cycle through partition table and mark spaces */
	for(part=0; part<4; part++){

		if(pMBR->pt[part].num_sector > 0){
			/* valid partition (size > 0) */
			endsec = ENDIAN(pMBR->pt[part].start_sector)-1;
			if(startsec < endsec){ /* free space */
				printf("%5d %10ld %10ld %10ld %15ld (free)\n",block,startsec,endsec,endsec-startsec+1,(endsec-startsec+1)*geo.sectorsize);
				/* show used space */
				block++;
				printf("%5d %10ld %10ld %10ld %15ld %s%d\n",
							block,
							ENDIAN(pMBR->pt[part].start_sector),
							ENDIAN(pMBR->pt[part].start_sector) + ENDIAN(pMBR->pt[part].num_sector) - 1,
							ENDIAN(pMBR->pt[part].num_sector),ENDIAN(pMBR->pt[part].num_sector)*geo.sectorsize,drive,part);

				startsec = endsec+ENDIAN(pMBR->pt[part].num_sector)+1; /* skip partition */
				block++; /* increment block count */
			} else{
				/* show used space */
				printf("%5d %10ld %10ld %10ld %15ld %s%d\n",
							block,
							ENDIAN(pMBR->pt[part].start_sector),
							ENDIAN(pMBR->pt[part].start_sector) + ENDIAN(pMBR->pt[part].num_sector) - 1,
							ENDIAN(pMBR->pt[part].num_sector),ENDIAN(pMBR->pt[part].num_sector)*geo.sectorsize,drive,part);

				startsec = endsec+ENDIAN(pMBR->pt[part].num_sector)+1; /* skip partition */
				block++; /* increment block count */
			}
		}
	}
	endsec = geo.nsectors-1;
	if(startsec < endsec){ /* free space */
				printf("%5d %10ld %10ld %10ld %15ld (free)\n",block,startsec,endsec,endsec-startsec+1,(endsec-startsec+1)*geo.sectorsize);
	}
	return 0;
}


/*
	list known partition types
*/
static int cmd_l(char* args)
{
	int i,j;
	printf("partition types:\n");

	i = 0;
	while(fs_sys_types[i]){
		for(j=0; j<3; j++){
			if(fs_sys_types[i]) printf("%02x:%-23s",(unsigned char)fs_sys_types[i][0], (char*)(fs_sys_types[i]+1));
			else {
				printf("\n");
				return 0;
			}
			i++;
		}
		printf("\n");
	}
}

/*
	FIXME: format a partition
*/
static int cmd_f(char* args)
{
	char c_in;
	unsigned char i_in;

	printf("partition to initialize: "); 
	c_in = getchar();
	i_in = c_in - '0';
	printf("%d\n",i_in);

	// check if partition exists and what type it is
	if(i_in < 0 || i_in > 3 ){
		printf("invalid partition %d \n", i_in);
		return 0;
	}

	if(pMBR->pt[i_in].num_sector == 0){
		printf("invalid partition %d (is of size zero!)\n", i_in);
		return 0;
	}

	printf("format partition %d type 0x%02x (%s)\n",i_in,pMBR->pt[i_in].type, partition_type(pMBR->pt[i_in].type));
	return 0;
}


/*
	initialize the MBR to be DOS/Win compatible
*/
static int cmd_b(char* args){


	pMBR->bootloader[0]   = 0xEB; 	/* BS_jmpBoot: set dummy jump at start of MBR */
	pMBR->bootloader[1]   = 0xFE;
	pMBR->bootloader[2]   = 0x90;
	pMBR->bootloader[3]   = 'M';    /* BS_OEMName */
	pMBR->bootloader[4]   = 'S';
	pMBR->bootloader[5]   = 'W';
	pMBR->bootloader[6]   = 'I';
	pMBR->bootloader[7]   = 'N';
	pMBR->bootloader[8]   = '4';
	pMBR->bootloader[9]   = '.';
	pMBR->bootloader[10]  = '1';
	pMBR->bootloader[11]  = 0;    /* BPB_BytsPerSec: 512 for max. compatibility, can also bee 1024,2048 or 4096 see M$ documentation */
	pMBR->bootloader[12]  = 512;
	pMBR->bootloader[13]  = 2;    /* BPB_SecPerClus: must be a power of 2 > 0 (1,2,4,8,16,32,64,128) 
									 				 The value should never be used that results in a “bytes per cluster” value 
									 				 (BPB_BytsPerSec * BPB_SecPerClus) greater than 32K (32 * 1024). 
								  */
	pMBR->signature       = 0x55aa;	/* set DOS flag */

	printf(" writing to mbr...\n");
	task_add(T_WRITE_MBR, 0, 0, 0);
	return 0;
}

/*
	FIXME: change the disk identifier
*/
static int cmd_i(char* args){
	return 0;
}

/*
	write table to disk and exit
*/
static int cmd_w(char* args)
{
	char c_in;
	struct task *ptask;

	ptask = tasklist;

	if(!ptask) {
		printf("nothing has changed...\n");
		return 0;
	}		


	printf(" write back changes ? [y/N]: "); c_in = getchar();
	if(c_in == 'Y' || c_in == 'y'){
		printf("\n");

		while(ptask){

			switch(ptask->type){
				case T_WRITE_MBR:
					printf("write mbr ...\n");
					driver->blk_oper->write( &devp, pMBR,0,1);
					break;
				case T_MKFS_JDXFS:
					printf("create (extended) JADOS file system ...\n");
					mkfs_jdxfs(ptask->p1, ptask->p2, ptask->p3);
					break;
				case T_MKFS_FAT:
					printf("create FAT file system ...\n");
					mkfs_fat(ptask->p1,ptask->p2);
					break;
				default:
					printf("unknown task (%d), skipping...\n",ptask->type);
			}
			ptask = ptask->next;		
		}

		task_clear_all();
		return 1;
	}


	task_clear_all();
	printf(" no changes written !\n");
	return 1;
}


/*
	quit without saving
*/
static int cmd_q(char* args)
{
	if(tasklist){
		printf(" exit without saving changes !\n");
		task_clear_all();
	}
	else printf("exit...\n");
	return 1;
}

/*-----------------------------------------------------------------------*/
/* Main fdisk                                                            */

void task_clear_all()
{
	struct task *ptask, *ptail;

	ptail = ptask = tasklist;		
			
	while(ptask){
		ptail = ptask->next;
		free(ptask);
		ptask = ptail;
	}
}

struct task *task_get(T_TYPE t)
{
	struct task *ptask;

	ptask = tasklist;		

	while(ptask){
		if(ptask->type == t) return ptask;
		ptask = ptask->next;		
	}

	return NULL;
}

int task_add(T_TYPE t, UINT p1, UINT p2, UINT p3)
{
	struct task *ptask, *ptail;

	/* we only need to write the MBR once */
	if(t == T_WRITE_MBR){
		if(task_get(t)) return;
	}

	/*
		allocate all buffers
	*/		
	ptask = (struct task *)malloc(sizeof(struct task));

	ptask->type = t;
	ptask->p1 = p1;
	ptask->p2 = p2;
	ptask->p3 = p3;
	ptask->next = NULL;

	if(tasklist == NULL)
		tasklist = ptask;
	else
	{
		ptail = tasklist;				
		while(ptail->next){

			ptail = ptail->next;
		}
		ptail->next = ptask;
	}		
}

static void prompt()
{
	printf("Command (m or ? for help): ");
}

int cmd_fdisk(char* args)
{
	FRESULT res;
	struct ioctl_disk_rw ioctl_args;

//	unsaved_changes = 0;
	tasklist = NULL;

	while (*args == ' ') args++;

	if (!xatos(&args, drive,3)) {
		printf(" bad argument.\n");
		return 0; 
	}


	/* get pointer to all block drivers */
	res = ioctl(NULL,FS_IOCTL_GETBLKDEV,&driver);

	while(driver)
	{   
			if( !strncmp(driver->pdrive, drive,2) )
			{
				break;
			}      
						
			driver = driver->next;
	}

	devp.pdrv = drive[2] - 'a';

	if(driver){
		driver->blk_oper->open(&devp);
		driver->blk_oper->geometry(&devp, &geo);

		pMBR = malloc(512);

		if(!pMBR){
			printf("error allocation memory for pMBR\n");			
			free(geo.model);
			return 0;
		}

		driver->blk_oper->read( &devp, pMBR,0,1);    /* read MBR */

		printf("fdisk utility v1.0\n disk %s, (physical drive %d)\n\n", drive,devp.pdrv);

		shell(prompt, &cmd_env, internalCommands, hlptxt, 1); // call the shell (single command option)....

		free(geo.model);
		return 0;
	}

	printf("driver for %s not found...\n",drive);
	return 0;

}


#if 0
/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
#include "../../fs/fat/ffconf.h"

#define N_ROOTDIR	512		/* Number of root directory entries for FAT12/16 */
#define N_FATS		1		/* Number of FAT copies (1 or 2) */

static const char progress[] = { '|','/','-','\\' };

static int mkfs_fat (	
    BYTE partition,		/* partition */
	BYTE sfd,			/* Partitioning rule 0:FDISK(use partition table), 1:SFD(no partition table, use whole volume) */
	UINT au				/* Allocation unit [bytes] */
)
{
	static const WORD vst[] = { 1024,   512,  256,  128,   64,    32,   16,    8,    4,    2,   0};
	static const WORD cst[] = {32768, 16384, 8192, 4096, 2048, 16384, 8192, 4096, 2048, 1024, 512};

	//struct fstabentry *pfstabentry;

	BYTE fmt, md, sys, *tbl, pdrv, part, xpos,ypos;
	DWORD n_clst, vs, n, wsect;
	UINT i;
	DWORD b_vol,    /* volume start sector */ 
	      b_fat, 
	      b_dir, 
	      b_data;	/* LBA */
	DWORD n_vol,	/* volume size in sectors */ 
	      n_rsv, 
	      n_fat, 
	      n_dir;	/* Size */
	//FATFS *fs;
	WORD	ssize;			/* Bytes per sector (512, 1024, 2048 or 4096) */
	DSTATUS stat = STA_OK;
	DRESULT res = RES_PARERR;

	//ff_dbg("f_mkfs: path = %s, sfd = %d, au = %d   -- ",path,sfd,au);
	ff_lldbgwait("KEY...\n");
	
	/* Check mounted drive and clear work area */

	//if(pfstabentry = get_fstabentry(path)){ 
	//  fs = (FATFS*)pfstabentry->pfs; /* Get pointer to the file system object */
	//}else{
	//  return FR_INVALID_DRIVE;
	//}
	/* this only works, if we are able to mount the partition which implies an already created VBR... */
	/* instead we can create a temporary fstabentry ... */

	//FRESULT f_mount (
	//FATFS* fs,			/* Pointer to the file system object (NULL:unmount)*/
	//const TCHAR* path,		/* Logical drive number to be mounted/unmounted */
	//BYTE opt			/* 0:Do not mount (delayed mount), 1:Mount immediately */

	//fs = malloc(sizeof(FATFS)); /* allocate memory for FATFS object */
	//f_mount(fs,path,1);			/* mount the drive and initialize the fs object */
	

	//get_ldnumber(&path);			/* adjust path information (remove drive info) */
		
	if (sfd > 1) return FR_INVALID_PARAMETER;
	if (au & (au - 1)) return FR_INVALID_PARAMETER;
		
	//ff_dbg(" parameters seem ok ...\n");
	
	fs->fs_type = 0;
	
	pdrv = devp.pdrv;			/* Physical drive */
	part = partition+1;			/* Partition 1-indexed here !*/

	//ff_dbg("f_mkfs: pdrv = %d, part = %d\n",pdrv,part);

	/* initiatlize disk and get disk status */
	//stat = disk_initialize(fs->pfstab);
	res = blk_drv->blk_oper->open(&devp);
	if(res != RES_OK){
		printf("error initializing disk ...\n");
			return FR_NOT_READY;
	}
	res = blk_drv->blk_oper->ioctl(&devp,GET_DISK_STATUS,&stat);

	switch(res) {
	  case RES_OK: 		stat = STA_OK;			break;
	  case RES_ERROR:	stat = STA_NOINIT;      break;
	  case RES_WRPRT:	stat = STA_PROTECT;     break;
	  case RES_NOTRDY:	stat = STA_NODISK;      break;
	  case RES_PARERR:	stat = STA_NOINIT;      break;
	}
	
	//ff_dbg(" disk status = %d\n",stat);
	
	if (stat & STA_NOINIT) return FR_NOT_READY;
	if (stat & STA_PROTECT) return FR_WRITE_PROTECTED;
#if _MAX_SS != _MIN_SS		/* Get disk sector size */
	//ff_dbg(" get sector size ...\n");
	res = blk_drv->blk_oper->ioctl(&devp,GET_SECTOR_SIZE,&ssize);
	if (res != RES_OK || ssize > _MAX_SS || ssize < _MIN_SS) 
		return FR_DISK_ERR;
		
	//ff_dbg(" ok.\n");	
#endif
	
	/* Get partition information from partition table in the MBR */
	//ff_dbg(" Get partition information from partition table in the MBR...\n");
	//if (disk_read(fs->pfstab, fs->win, 0, 1)) return FR_DISK_ERR;  /* MBR haben wir schon gelesen ... */
	//if (LD_WORD(fs->win+BS_55AA) != 0xAA55) return FR_MKFS_ABORTED;

	//if (pMBR->signature != 0xAA55) return FR_MKFS_ABORTED; // maybe yes ...
	
	//tbl = &fs->win[MBR_Table + (part - 1) * SZ_PTE];

	if (pMBR->pt[partition].type) return FR_MKFS_ABORTED;	/* No partition? */
	b_vol = ENDIAN(pMBR->pt[partition].start_sector);	/* Volume start sector */
	n_vol = ENDIAN(pMBR->pt[partition].num_sector);	/* Volume size */		
	
	//ff_dbg("f_mkfs: start sector = %d, size = %d\n",b_vol,n_vol);

	if (!au) {				/* AU auto selection */
		vs = n_vol / (2000 / (ssize / 512));
		for (i = 0; vs < vst[i]; i++) ;
		au = cst[i];
	}
	au /= ssize;		/* Number of sectors per cluster */
	if (au == 0) au = 1;
	if (au > 128) au = 128;	
	//ff_dbg(" found au = %d\n",au);
	/* Pre-compute number of clusters and FAT sub-type */
	n_clst = n_vol / au;
	fmt = FS_FAT12;
	if (n_clst >= MIN_FAT16) fmt = FS_FAT16;
	if (n_clst >= MIN_FAT32) fmt = FS_FAT32;

	/* Determine offset and size of FAT structure */
	if (fmt == FS_FAT32) {
		n_fat = ((n_clst * 4) + 8 + ssize - 1) / ssize;
		n_rsv = 32;
		n_dir = 0;
	} else {
		n_fat = (fmt == FS_FAT12) ? (n_clst * 3 + 1) / 2 + 3 : (n_clst * 2) + 4;
		n_fat = (n_fat + ssize - 1) / ssize;
		n_rsv = 1;
		n_dir = (DWORD)N_ROOTDIR * SZ_DIR / ssize;
	}

	b_fat = b_vol + n_rsv;				/* FAT area start sector = volume start sector + reserved bytes*/
	b_dir = b_fat + n_fat * N_FATS;		/* Directory area start sector */
	b_data = b_dir + n_dir;				/* Data area start sector */
	if (n_vol < b_data + au - b_vol) return FR_MKFS_ABORTED;	/* Too small volume */

	/* Align data start sector to erase block boundary (for flash memory media) */
	res = blk_drv->blk_oper->ioctl(&devp,GET_BLOCK_SIZE,&n);
	if (res != RES_OK || !n || n > 32768) n = 1;
	n = (b_data + n - 1) & ~(n - 1);	/* Next nearest erase block from current data start */
	n = (n - b_data) / N_FATS;
	if (fmt == FS_FAT32) {		/* FAT32: Move FAT offset */
		n_rsv += n;
		b_fat += n;
	} else {					/* FAT12/16: Expand FAT size */
		n_fat += n;
	}

	/* Determine number of clusters and final check of validity of the FAT sub-type */
	n_clst = (n_vol - n_rsv - n_fat * N_FATS - n_dir) / au;
	if (   (fmt == FS_FAT16 && n_clst < MIN_FAT16)
		|| (fmt == FS_FAT32 && n_clst < MIN_FAT32))
		return FR_MKFS_ABORTED;

	/* Determine system ID in the partition table */
	
	//ff_dbg(" determined system ID in partition table: ");
	if (fmt == FS_FAT32) {
		sys = 0x0C;		/* FAT32X */
		//ff_dbg("FAT32X (0x%02x)\n",sys);
	} else {
		if (fmt == FS_FAT12 && n_vol < 0x10000) {
			sys = 0x01;	/* FAT12(<65536) */
			//ff_dbg("FAT12 (0x%02x)\n",sys);
		} else {
			sys = (n_vol < 0x10000) ? 0x04 : 0x06;	/* FAT16(<65536) : FAT12/16(>=65536) */
			//ff_dbg("FAT12/16 (0x%02x)\n",sys);
		}
	}


	/* Update system ID in the partition table */
	//ff_dbg(" Update system ID in the partition table...\n");
	//tbl = &fs->win[MBR_Table + (part - 1) * SZ_PTE];
	//tbl[4] = sys;
	pMBR->pt[partition].type = sys;
	res = driver->blk_oper->write( &devp, pMBR,0,1); /* Write it to the MBR */ 
	if (res)	
		return FR_DISK_ERR;
	md = 0xF8;
	
	//ff_dbg(" ok.\n");
	
	/* Create BPB in the VBR -------------------------------------- */
	//ff_dbg(" Create BPB in the VBR...\n");
	tbl = fs->win;							/* Clear sector */
	mem_set(tbl, 0, SS(fs));
	mem_cpy(tbl, "\xEB\xFE\x90" "MSDOS5.0", 11);/* Boot jump code, OEM name */
	i = SS(fs);								/* Sector size */
	ST_WORD(tbl+BPB_BytsPerSec, i);
	tbl[BPB_SecPerClus] = (BYTE)au;			/* Sectors per cluster */
	ST_WORD(tbl+BPB_RsvdSecCnt, n_rsv);		/* Reserved sectors */
	tbl[BPB_NumFATs] = N_FATS;				/* Number of FATs */
	i = (fmt == FS_FAT32) ? 0 : N_ROOTDIR;	/* Number of root directory entries */
	ST_WORD(tbl+BPB_RootEntCnt, i);
	if (n_vol < 0x10000) {					/* Number of total sectors */
		ST_WORD(tbl+BPB_TotSec16, n_vol);
	} else {
		ST_DWORD(tbl+BPB_TotSec32, n_vol);
	}
	tbl[BPB_Media] = md;					/* Media descriptor */
	ST_WORD(tbl+BPB_SecPerTrk, 63);			/* Number of sectors per track */
	ST_WORD(tbl+BPB_NumHeads, 255);			/* Number of heads */
	ST_DWORD(tbl+BPB_HiddSec, b_vol);		/* Hidden sectors */
	n = get_fattime();						/* Use current time as VSN */

	if (fmt == FS_FAT32) {
		ST_DWORD(tbl+BS_VolID32, n);		/* VSN */
		ST_DWORD(tbl+BPB_FATSz32, n_fat);	/* Number of sectors per FAT */
		ST_DWORD(tbl+BPB_RootClus, 2);		/* Root directory start cluster (2) */
		ST_WORD(tbl+BPB_FSInfo, 1);			/* FSINFO record offset (VBR+1) */
		ST_WORD(tbl+BPB_BkBootSec, 6);		/* Backup boot record offset (VBR+6) */
		tbl[BS_DrvNum32] = 0x80;			/* Drive number */
		tbl[BS_BootSig32] = 0x29;			/* Extended boot signature */
		mem_cpy(tbl+BS_VolLab32, "NO NAME    " "FAT32   ", 19);	/* Volume label, FAT signature */
	} else {
		ST_DWORD(tbl+BS_VolID, n);			/* VSN */
		ST_WORD(tbl+BPB_FATSz16, n_fat);	/* Number of sectors per FAT */
		tbl[BS_DrvNum] = 0x80;				/* Drive number */
		tbl[BS_BootSig] = 0x29;				/* Extended boot signature */
		mem_cpy(tbl+BS_VolLab, "NO NAME    " "FAT     ", 19);	/* Volume label, FAT signature */
	}
	ST_WORD(tbl+BS_55AA, 0xAA55);			/* Signature (Offset is fixed here regardless of sector size) */
	if (disk_write(fs->pfstab, tbl, b_vol, 1))	/* Write it to the VBR sector */ 
		return FR_DISK_ERR;
	if (fmt == FS_FAT32)					/* Write backup VBR if needed (VBR+6) */
		disk_write(fs->pfstab, tbl, b_vol + 6, 1); 

	//ff_dbg(" ok.\n");
	
	/* -----------------------------  Initialize FAT area --------------------------------------- */
	//ff_dbg(" Initialize FAT area...\n");
	wsect = b_fat;
	for (i = 0; i < N_FATS; i++) {		/* Initialize each FAT copy */
		mem_set(tbl, 0, SS(fs));			/* 1st sector of the FAT  */
		n = md;								/* Media descriptor byte */
		if (fmt != FS_FAT32) {
			n |= (fmt == FS_FAT12) ? 0x00FFFF00 : 0xFFFFFF00;
			ST_DWORD(tbl+0, n);				/* Reserve cluster #0-1 (FAT12/16) */
		} else {
			n |= 0xFFFFFF00;
			ST_DWORD(tbl+0, n);				/* Reserve cluster #0-1 (FAT32) */
			ST_DWORD(tbl+4, 0xFFFFFFFF);
			ST_DWORD(tbl+8, 0x0FFFFFFF);	/* Reserve cluster #2 for root directory */
		}
		//ff_dbg(" write 1st sector of FAT...");
		if (disk_write(fs->pfstab, tbl, wsect++, 1))	
			return FR_DISK_ERR;
		//ff_dbg(" ok\n");
			
		mem_set(tbl, 0, SS(fs));			/* Fill following FAT entries with zero */
				
		printf(" loop through (%d) FAT entries: ",n_fat);
		gp_getxy(&xpos,&ypos);
		
		for (n = 1; n < n_fat; n++) {		/* This loop may take a time on FAT32 volume due to many single sector writes */
			gp_setxy(xpos,ypos);
			gp_putchar(progress[n % 4]);
			
			if (disk_write(fs->pfstab, tbl, wsect++, 1)) 
				return FR_DISK_ERR;
		}		
	}
	printf("\n");
	//ff_dbg("ok.\n");
	
	/* -------------------------- Initialize root directory ---------------------------------- */
	//ff_dbg(" Initialize root directory...\n");
	i = (fmt == FS_FAT32) ? au : (UINT)n_dir;
	do {
		if (disk_write(fs->pfstab, tbl, wsect++, 1)) 
			return FR_DISK_ERR;
	} while (--i);
	//ff_dbg(" ok\n");
	
#if _USE_ERASE	/* Erase data area if needed */
	{
		DWORD eb[2];

		eb[0] = wsect; eb[1] = wsect + (n_clst - ((fmt == FS_FAT32) ? 1 : 0)) * au - 1;
		disk_ioctl(fs->pfstab, CTRL_ERASE_SECTOR, eb);
	}
#endif

	/* Create FSINFO if needed */
	if (fmt == FS_FAT32) {
		ST_DWORD(tbl+FSI_LeadSig, 0x41615252);
		ST_DWORD(tbl+FSI_StrucSig, 0x61417272);
		ST_DWORD(tbl+FSI_Free_Count, n_clst - 1);	/* Number of free clusters */
		ST_DWORD(tbl+FSI_Nxt_Free, 2);				/* Last allocated cluster# */
		ST_WORD(tbl+BS_55AA, 0xAA55);
		disk_write(fs->pfstab, tbl, b_vol + 1, 1);	/* Write original (VBR+1) */ 
		disk_write(fs->pfstab, tbl, b_vol + 7, 1);	/* Write backup (VBR+7) */  
	}

	return (disk_ioctl(fs->pfstab, CTRL_SYNC, 0) == RES_OK) ? FR_OK : FR_DISK_ERR;
}
#endif
