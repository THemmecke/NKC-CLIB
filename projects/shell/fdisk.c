#include <stdlib.h>
#include <ioctl.h>
#include <errno.h>

#include <fs.h>
#include <drivers.h>

#include "../../fs/nkc/fs_nkc.h"

#include "shell.h"
#include "fdisk.h"

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
static unsigned char unsaved_changes;

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

	for (i = 0; fs_sys_types[i]; i++)
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

	unsaved_changes = 1;
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
	 
			printf(" partition %d deleted...\n",i_in);
			return 0;
		}
		printf("\n");
	}else{
		printf("invalid partition %d \n", i_in);
		return 0;
	}

	return 0;
}


static unsigned int check_fat_type(){

}

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
			//driver->blk_oper->write( &devp, pvbr16,ENDIAN(pMBR->pt[partition].start_sector),1);
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
			//driver->blk_oper->write( &devp, pvbr32,ENDIAN(pMBR->pt[partition].start_sector),1);
			free(pvbr32);
			break;

		default:
			printf(" FAT type 0x%02x not supperted !\n",type);
			return 0; 
	}

	printf("exit fdisk, 'mount %s%d FAT 0' and format partition %d with 'mkfs %s%d %s 0 %d'\n",drive,partition,partition,drive,partition,fat_type(type),BPB_SecPerClus);

	return 0;
}

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

	printf("first sector: "); scanf("%u",&first);
	printf("last sector : "); scanf("%u",&last);
	printf("type (hex)  : "); scanf("%x",&type);

  if ((last - first) > 0x7FFFFF){
		size = (last - first) >> 10; // /1024
		size = size * geo.sectorsize;
	} else{
		size = ((last - first) * geo.sectorsize) >> 10;// /1024;
	}

	printf("first %ld, last %ld, sectors %u, size(MB) %u, type %02x\n",first,last,last-first+1,size/1024,type);

	// FIXME: check it first and last are possible values

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

			driver->blk_oper->write( &devp, pMBR,0,1);

			mkfs_jdxfs(i_in, first, last);
			driver->blk_oper->read( &devp, pMBR,0,1);    /* re-read MBR */
			unsaved_changes = 0;
			break;

		case 0x06: // FAT16
		case 0x0c: // Win95 FAT32 (LBA) 
			//pMBR->signature = 0x55aa;
			pMBR->pt[i_in].num_sector = ENDIAN(last-first+1);  // number of 512 byte sectors
			pMBR->pt[i_in].bootable = 0;                       // partitions bootable flag
			pMBR->pt[i_in].start_sector = ENDIAN(first);       // start sector
			pMBR->pt[i_in].type = type;                        //
			mkfs_fat(i_in,type);                                                           
			//unsaved_changes = 0;
			unsaved_changes = 1;
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
	format a partition
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
	driver->blk_oper->write( &devp, pMBR,0,1);
	return 0;
}

/*
	change the disk identifier
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


	if(unsaved_changes == 0) {
		printf("nothing has changed...\n");
		return 0;
	}
	printf(" writing changes to mbr ? [y/N]: "); c_in = getchar();
	if(c_in == 'Y' || c_in == 'y'){
			printf(" writing to mbr...\n");
			driver->blk_oper->write( &devp, pMBR,0,1);
			return 1;
	}

	printf(" no changes written !\n");
	return 1;
}


/*
	quit without saving
*/
static int cmd_q(char* args)
{
	if(unsaved_changes == 1)
		printf(" exit without saving changes !\n");
	else printf("exit...\n");
	return 1;
}

/*-----------------------------------------------------------------------*/
/* Main fdisk                                                            */

static void prompt()
{
	printf("Command (m or ? for help): ");
}

int cmd_fdisk(char* args)
{
	FRESULT res;
	struct ioctl_disk_rw ioctl_args;

	unsaved_changes = 0;

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