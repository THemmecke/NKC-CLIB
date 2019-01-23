#include <stdlib.h>
#include <ioctl.h>
#include <errno.h>

#include <fs.h>
#include <drivers.h>
#include "sys.h"

#include "helper.h"


/* master boot record of the drive */
static struct mbr *pMBR, *pVBR;
/* block driver */
static struct blk_driver *driver;
/* drive geometry */
static struct geometry geo;
/* physical drive */
static struct _dev devp;

static const char progress[] = { '|','/','-','\\' };


/* DEBUG STARTS*/
static const char *
partition_type(unsigned char type)
{
	int i;  

	for (i = 0; fs_sys_types[i]; i++) /* fs_sys_types -> fs.h */
		if ((unsigned char)fs_sys_types[i][0] == type)
			return fs_sys_types[i] + 1;

	return "Unknown";
}

/* DEBUG ENDS */

// "sys <drive> <loader> <os> - install bootloader 'loader' on 'device' to load os 'os'
/*
 * drive naming convention:
 * [DeviceID][DeviceNo][Partition][xn]:
 * Device 	   DeviceID[2]
 *
 * SD/MMC	    sd
 * IDE/GIDE	    hd
 *
 *
 * DeviceNo: a,b,c,d....[1]
 *
 * Partition: 0,1,2,3.....[1]
 *
 * E(x)tended Partiion: 0,1,2....[2]
 * 
 */
int cmd_sys(char* args)
{
	FRESULT res;
	struct ioctl_disk_rw ioctl_args_disk_rw;
	char drive[11];
	char os[21];
	char loader[21];
	char option[11];
	char is_continuous, is_testrun;
	BYTE *ploader, partition, i;
	FILE *pf1;
	char fullpath[_MAX_PATH];
	UINT s1, start_sec, nsec;
	struct blk_driver *driver;
	UINT size;
	UINT ldr_offset, ldr_size;
	BYTE disk_type; /* (0=SCSI, 1=IDE, 2=SD) */
	char c_in;

	struct slist *list,*next;
  	struct ioctl_get_slist ioctl_args_get_slist;

	
	while (*args == ' ') args++;

	// drive where to put bootloader
	if (!xatos(&args, drive,10)) {
		printf(" bad device argument.\n");
		return 0; 
	}

	if(strlen(drive) < 3){
		// we need at least [DeviceID][DeviceNo] !
		printf(" bad device argument.\n");
		return 0; 
	}
	
	// path to bootloader
	if (!xatos(&args, loader,20)) {
		printf(" bad loader argument.\n");
		return 0; 
	}

	// 'os' the bootloader should load and execute
	// this file has to reside in the root directory of drive and must be contignious
	if (!xatos(&args, os,20)) {
		printf(" bad os argument.\n");
		return 0; 
	}

	// option
	option[0] = 0;
	if (!xatos(&args, option,10)) {
	}

	// check possible options
	is_testrun = 0;
	if( !strcmp("test",option) ){
		is_testrun = 1;
	}


	printf("OS: %s LOADER: %s on %s, is_test = %d...\n",os,loader,drive,is_testrun);

	// check if 'drive' is registered in block device list
	/* get pointer to all block drivers */
	res = ioctl(NULL,FS_IOCTL_GETBLKDEV,&driver);

	while(driver)
	{   
			if( !strncmp(driver->pdrive, drive,2) ) // check DeviceID
			{
				break;
			}      
						
			driver = driver->next;
	}


	if(driver){
		// physical drive number
	    devp.pdrv = drive[2] - 'a'; // get DeviceNo

		driver->blk_oper->open(&devp);
		driver->blk_oper->geometry(&devp, &geo);

		pMBR = malloc(512);

		if(!pMBR){
			printf("error allocation memory for pMBR\n");
			free(geo.model);
			return 0;
		}

		// load sector 0 (MBR) of 'device' to buffer 
		driver->blk_oper->read( &devp, pMBR,0,1);    /* read MBR */
	}else{
		printf("driver for %s not registered !\n",drive);
		return 0;
	}

	// check for partition number, if none given, put bootloader to MBR
	partition = 255;
	if(strlen(drive) > 3){
		// put bootloader into partition 
		partition = drive[3] - '0';
	}

	// DEBUG print partition table
	#if 1
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
	#endif

	/* if loader should be written to a partition, load vbr */
	ldr_offset = 0;
	ldr_size = 440;
	pVBR = 0;
	if(partition < 255){

		switch(pMBR->pt[partition].type){
			case 0x06: // FAT16
				ldr_offset = 0x03e;
				ldr_size = 448;
				printf("FAT16 partition: bootcode(max. 448) at 0x03e\n");
				break;
			case 0x0c: // FAT32
				ldr_offset = 0x05a;
				ldr_size = 420;
				printf("FAT16 partition: bootcode(max. 420) at 0x05a\n");
				break;	
			default:
				printf("unsupported partition type (%d) => %s\n", pMBR->pt[partition].type, partition_type(pMBR->pt[partition].type));
				free(pMBR);
				free(geo.model);			
				return 0;
		}

		pVBR = malloc(512);

		if(!pVBR){
			printf("error allocation memory for pVBR\n");
			free(pMBR);
			free(geo.model);			
			return 0;
		}

		// load partitions start sector (VBR) to buffer 
		driver->blk_oper->read( &devp, pVBR, ENDIAN(pMBR->pt[partition].start_sector),1);    /* read VBR */

	}
	// check if 'loader' exists at specified location 
	checkargs(loader, fullpath, NULL);
	printf("open loader '%s' ...\n",fullpath);
	pf1 = fopen(fullpath,"rb");

	if (pf1==NULL) {
      printf("error opening loader '%s' !\n",fullpath);
      return 0;
    }

    ploader = malloc(512);
    if(!ploader){
			printf("error allocation memory for ploader\n");
			// free allocated memory
			free(pMBR);
			free(geo.model);
			return 0;
		}

	// check size of 'loader' - should be < 440 bytes (partition table starts at 0x01B8)
	// maximum code size depends on partition type:
	// MBR 			440 bytes starting at 0x000
	// VBR(FAT16)	448 bytes starting at 0x03e
	// VBR(FAT32)	420 bytes starting at 0x05a
	s1 = fread(ploader, 1, 512, pf1); // attempt read 512 Bytes
	if(s1>ldr_size){ 
		printf("loader size exceeds boot loader space (420 bytes) !!!!\n");
		// we  do not exit here ...  maybe we should ?
	} else {
		printf("%d bytes boot loader read from file\n",s1);
	}
	fclose(pf1); // close file

	// check if 'os' exists in root directory of 'device' and if it's contignious, at which sector it starts and the size in (512Bytes)sectors
	checkargs(os, fullpath, NULL);
	printf("check '%s' parameters...\n",fullpath);
  	ioctl_args_get_slist.filename = fullpath;
  	ioctl_args_get_slist.list = NULL;

    // checkargs above has stored drive information in FPInfo1, so we use it ... FIXME: dieses Hilfskonstrukt muss verbessert werden
  	if(strlen(FPInfo1.psz_driveName))
  		ioctl(FPInfo1.psz_driveName,FS_IOCTL_GET_SLIST,&ioctl_args_get_slist);
  	else
  		ioctl(FPInfo1.psz_cdrive,FS_IOCTL_GET_SLIST,&ioctl_args_get_slist);

  	if(ioctl_args_get_slist.list == NULL){
    	printf(" hat nicht geklappt...\n");
    	// free allocated memory
    	free(ploader);
    	free(pVBR);
    	free(pMBR);
		free(geo.model);
    	return 0;
  	}

  	list = ioctl_args_get_slist.list;
  	nsec = 0;
  	start_sec = list->s;

  	is_continuous = 1;
  	while(list != NULL){
  		nsec++;  			
    	next = list->next;    	
    	if( (next != NULL) && (list->s + 1 != next->s) ){
    		printf("gap between sector %d and %d !\n", list->s, next->s);
    		is_continuous = 0;
    	}
    	free(list);
    	list = next;
  	}
  	
  	//printf("\n");
  	if(nsec==0){
  		printf("os %s not suitable\n",os);
  	}else{
  		if(is_continuous)
  			printf("os starts at sector %d and spans %u sectors\n",start_sec, nsec);
  		else
  			printf("os starts at sector %d but is not continuous at one or more sectors on disk ....\n",start_sec);  		
  	}

	if(partition < 255) {
		// merge 'loader' to VBR
		// FAT16 -> pVBR + 0x03e
		// FAT32 -> pVBR + 0x05a
		memcpy(pVBR+ldr_offset,ploader,ldr_size);

		// set os info 
		((MBRINFO*)pVBR)->disk = driver->type; 	/* 0x08: disk type (0=SCSI, 1=IDE, 2=SD) */
		((MBRINFO*)pVBR)->drive = devp.pdrv+1;	/* 0x09: physical drive numberf (1=1st drive) */
		((MBRINFO*)pVBR)->partition = 0;		/* 0x0A: FIXME: partition (0=1st partition, 0xff=no partition table)  */
		((MBRINFO*)pVBR)->sector = start_sec;	/* 0x0B: start sector of OS.SYS */
		((MBRINFO*)pVBR)->nsector = nsec;		/* 0x0F: size in sectors of OS.SYS */
		((MBRINFO*)pVBR)->target = 0x1000;		/* 0x10: FIXME: target address for OS.SYS */
		size = strlen(os);
		if(size > 12) size = 12;
		memcpy(((MBRINFO*)pVBR)->name,os,size);


		// write back partitions boot sector		
		printf("writing loader to VBR[%d] at sector %u\n",partition,ENDIAN(pMBR->pt[partition].start_sector));
		if(!is_testrun){
			printf("Are you shure ? [y/N]: "); c_in = getchar();
			if(c_in != 'Y' && c_in != 'y'){          
					printf("nothing written ...\n");
			} else{
				printf("writing ...");
		  		driver->blk_oper->write( &devp, pVBR,ENDIAN(pMBR->pt[partition].start_sector),1);    /* write VBR */
		  		printf("\n");
			}
		}
		else printf("(test mode)\n");	
	}else{
		// merge 'loader' to MBR
		memcpy(pMBR,ploader,440);		

		// set os info 
		((MBRINFO*)pMBR)->disk = driver->type;	/* 0x08: disk type (0=SCSI, 1=IDE, 2=SD) */
		((MBRINFO*)pMBR)->drive = devp.pdrv+1;	/* 0x09: physical drive numberf (1=1st drive) */
		((MBRINFO*)pMBR)->partition = 0;		/* 0x0A: FIXME: partition (0=1st partition, 0xff=no partition table) */
		((MBRINFO*)pMBR)->sector = start_sec;	/* 0x0B: start sector of OS.SYS */
		((MBRINFO*)pMBR)->nsector = nsec;		/* 0x0F: size in sectors of OS.SYS */
		((MBRINFO*)pMBR)->target = 0x1000;		/* 0x10: FIXME: target address for OS.SYS */
		size = strlen(os);
		if(size > 12) size = 12;
		memcpy(((MBRINFO*)pMBR)->name,os,size);
		// write back partitions boot sector
		printf("writing loader to MBR at sector 0\n");
		if(!is_testrun){
			printf("Are you shure ? [y/N]: "); c_in = getchar();
			if(c_in != 'Y' && c_in != 'y'){          
					printf("nothing written ...\n");
			} else{
				printf("writing ...");
		  		driver->blk_oper->write( &devp, pMBR,0,1);    /* write MBR */
		  		printf("\n");
			}		  
		}
		else printf("(test mode)\n");
	}

  	// free allocated memory
  	free(ploader);
  	free(pVBR);
  	free(pMBR);
	free(geo.model);

	return 0;

}