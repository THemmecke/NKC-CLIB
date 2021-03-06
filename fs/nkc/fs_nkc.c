#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>       /* time_t, struct tm, difftime, time, mktime */
#include <errno.h>
#include <fs.h>
#include <debug.h>
#include <ioctl.h>


#include "../fat/ff.h" /* using some struct from FAT fileystem ... */
#include "fs_nkc.h"
#include "../../nkc/llnkc.h"




const struct file_operations nkc_file_operations =
{
  nkcfs_open,
  nkcfs_close,
  nkcfs_read,
  nkcfs_write,
  nkcfs_seek,
  nkcfs_ioctl,
  nkcfs_remove,
  nkcfs_getpos,

 /* Directory operations */

  nkcfs_opendir,
  nkcfs_closedir,
  nkcfs_readdir,

 /* Path operations */
  NULL,
  NULL,
  nkcfs_rename
};



/*******************************************************************************
 *   private variables
 *******************************************************************************/


extern struct fstabentry *fstab; 			/* global filesystem table -> fs/fs.c */
static struct jdhd *pJDHDtable;				/* JADOS harddisk table */
extern struct blk_driver *blk_driverlist; 	/* global pointer to list of block device drivers -> driver/drivers.c */

char current_jados_drive[10];

static struct fpinfo FPInfo;



/*******************************************************************************
 *   private functions
 *******************************************************************************/

/*
	returns the next partition relative track of the file
*/
static  UINT get_next_track(struct jdfcb *pfcb){

	FATentry *FAT;
	int index;


	fsnkc_dbg("fs_nkc.c|set_next_track ...\n");

	FAT = pfcb->pfs->pFAT;
	index = pfcb->curtrack;

	fsnkc_dbg("fs_nkc.c|get_next_track (FAT[%d] = [0x%04x|0x%04x]) ...\n",index,FAT[index].ancestor,FAT[index].successor);

    return FAT[index].successor;
}

/*
	allocates a new track for the file
*/
static  int alloc_new_track(struct jdfcb *pfcb){

	FATentry *FAT;
	int fat_index,dir_index,sub_index;
	DRESULT dres;
	struct _dev dev;
	JDFS *pJDFs;
	struct fstabentry* pfstab;
	struct jddir *pdir;

	fsnkc_dbg("fs_nkc.c|alloc_new_track ...\n");

	FAT = pfcb->pfs->pFAT;
	fat_index = FAT_BASE;
	pfstab  = pfcb->pfs->pfstab;	/* pointer to file related fstab entry */
	dev.pdrv = pfstab->pdrv; 			/* physical drive number 				*/

	pJDFs = (JDFS *)pfstab->pfs;		/* pointer to JADOS file system object  */

	while( FAT[fat_index].successor != 0xE5E5 && fat_index < FAT_ENTRIES ) {
		fat_index++;
	}

	if(fat_index < FAT_ENTRIES){
		/* we found a free track */
		fsnkc_dbg("alloc_new_track| found: FAT(%d)=[0x%04x|0x%04x]\n",fat_index,FAT[fat_index].ancestor,FAT[fat_index].successor);

		FAT[fat_index].ancestor = pfcb->curtrack;
		FAT[fat_index].successor = 0xFFFF;
		FAT[pfcb->curtrack].successor = fat_index;

		pfcb->curtrack = pfcb->lasttrack = fat_index;
		pfcb->curcluster = pfcb->endcluster = 0;

		return FR_OK;
	}

	return FR_DISKFULL;
}

/* revert alloc_new_track */
static  int de_alloc_new_track(struct jdfcb *pfcb){

	FATentry *FAT;
	int fat_index,dir_index,sub_index;
	DRESULT dres;
	struct _dev dev;
	JDFS *pJDFs;
	struct fstabentry* pfstab;
	struct jddir *pdir;

	fsnkc_dbg("fs_nkc.c|de_alloc_new_track ...\n");

	FAT = pfcb->pfs->pFAT;
	fat_index = FAT_BASE;
	pfstab  = pfcb->pfs->pfstab;	/* pointer to file related fstab entry */
	dev.pdrv = pfstab->pdrv; 			/* physical drive number 				*/

	pJDFs = (JDFS *)pfstab->pfs;		/* pointer to JADOS file system object  */


	/* we found a free track */
	fsnkc_dbg("alloc_new_track| found: FAT(%d)=[0x%04x|0x%04x]\n",fat_index,FAT[fat_index].ancestor,FAT[fat_index].successor);
	
	fat_index = pfcb->curtrack;
	pfcb->curtrack = FAT[fat_index].ancestor;
	FAT[fat_index].ancestor = 0xE5E5;
	FAT[fat_index].successor = 0xE5E5;

	fat_index = pfcb->curtrack;
	pfcb->lasttrack = pfcb->curtrack;
	FAT[fat_index].successor = 0xFFFF;

	return FR_OK;
}


/*
	update directory information
*/
static int update_dir(struct jdfcb *pfcb){
	DRESULT dres;
	struct jddir *pdir;
	JDFS *pJDFs;
	int index,sub_index, start_sec, dir_index;
	struct _dev dev;
	struct fstabentry* pfstab;
	time_t timer;
	struct tm *py2k;

	/* update directory: we can only write whole clusters */

	index = pfcb->starttrack;
	pfstab  = pfcb->pfs->pfstab;		/* pointer to file related fstab entry */
	pJDFs = (JDFS *)pfstab->pfs;		/* pointer to JADOS file system object  */
	dev.pdrv = pfstab->pdrv; 			/* physical drive number 				*/

	/* DIR structure is stored in file system structure and written back to media at file close ... */

	dir_index = pfcb->dir_index;	
	pdir = pfcb->pfs->pDIR;
	
	/* update date and time */
  	time(&timer);  					/* get current time; same as: timer = time(NULL)  */
  	py2k = localtime(&timer);		/* get pointer to struct tm */

	// 4bytes = bytes=[00][year][month][day] BCD coded
	pfcb->date = 0;
	pfcb->date += nkc_bin2bcd(py2k->tm_year-100) << 16;
	pfcb->date += nkc_bin2bcd(py2k->tm_mon+1) << 8;
	pfcb->date += nkc_bin2bcd(py2k->tm_mday);

	fsnkc_dbg("update_dir: dir-index=%d\n", dir_index);

	fsnkc_dbg("             filename   : '%s'\n",pfcb->filename );
	fsnkc_dbg("             fileext    : '%s'\n",pfcb->fileext );
	fsnkc_dbg("             starttrack : %d\n",index );
	fsnkc_dbg("             endcluster : %d\n",pfcb->endcluster );
	fsnkc_dbg("             endbyte    : %d\n",pfcb->endbyte );
	fsnkc_dbg("             date       : %d\n",pfcb->date );
	fsnkc_dbg("             length     : %d\n",pfcb->length );

    memcpy(&pdir[dir_index],pfcb,sizeof(struct jddir));
	pdir[dir_index].id = 0x0000; /* mark entry as valid */

	return FR_OK;
}

/*
	alloc_new_file

	allocates new directory and FAT entry on disk

	possible return values:
		FR_NOT_ENOUGH_CORE
	 	FR_DISK_ERR
	 	FR_DISKFULL
	 	FR_OK
*/
static  int alloc_new_file(struct jdfcb *pfcb){

	FATentry *FAT;
	int fat_index, dir_index, sector, res;
	DRESULT dres;
	struct _dev dev;
	JDFS *pJDFs;
	struct fstabentry* pfstab;
	struct _file fil;
	DIR dir;
	struct jddir *pdir;
	

	fsnkc_dbg("fs_nkc.c|alloc_new_file ...\n");

	FAT = pfcb->pfs->pFAT;
	fat_index = FAT_BASE;
	pfstab  = pfcb->pfs->pfstab;		/* pointer to file related fstab entry */
	dev.pdrv = pfstab->pdrv; 			/* physical drive number 				*/

	pJDFs = (JDFS *)pfstab->pfs;		/* pointer to JADOS file system object  */

	/* search free FAT entry */
	fat_index = 1; /* index 0 = FAT/DIR cluster !! */
	while( FAT[fat_index].successor != 0xE5E5 && fat_index < FAT_ENTRIES ) {
		fat_index++;
	}

	if(fat_index < FAT_ENTRIES){
		/* we found a free track */
		fsnkc_dbg("alloc_new_file| found: FAT(%d)=[0x%04x|0x%04x]\n",fat_index,FAT[fat_index].ancestor,FAT[fat_index].successor);

		/* search free DIR entry */
		pfcb->dirsec = 0;
		pfcb->dirbyte = 0;

		fil.p_fstab = pfstab;
		res = nkcfs_opendir(&fil, NULL, &dir);
		pdir = dir.dir;
		while(!pdir[dir.index].id && dir.index < NUM_JD_DIR_ENTRIES) dir.index++; /* DIR_ENTRIES_PC (32) per cluster */

		if(dir.index < NUM_JD_DIR_ENTRIES){
			/* we found a free directory entry */		    

			pfcb->dirsec = ((dir.index)*sizeof(struct jddir))/CLUSTERSIZE  + JADOS_CLUSTER_OFFSET + FAT_SIZE ; /* 1st Cluster = 1 in JADOS ! => 1st DIR Cluster = 2 */
			pfcb->dirbyte = ((dir.index)*sizeof(struct jddir)) % CLUSTERSIZE;

			/* calculate sector where this entry is stored on medium */
			sector = (pfcb->dirsec-JADOS_CLUSTER_OFFSET) * pJDFs->pjdhd->spc + pfcb->dirbyte / (pJDFs->pjdhd->csize/pJDFs->pjdhd->spc);

			fsnkc_dbg("alloc_new_file| found: DIR(%d), dir-sec = %d(%d), dirbyte = %d\n",dir.index,pfcb->dirsec,sector,pfcb->dirbyte);
			
			nkcfs_closedir(&fil, &dir);

			/* update FAT on media */
			FAT[fat_index].ancestor = 0xFFFF;	/* no ancestor  */
			FAT[fat_index].successor = 0xFFFF;	/* no successor */
		
			pfcb->dir_index = dir.index;
			pfcb->starttrack = pfcb->curtrack = pfcb->lasttrack = fat_index;
			pfcb->curcluster = pfcb->endcluster = pfcb->endbyte = pfcb->length = pfcb->crpos = 0;
			pfcb->length = 1; /* file length in cluster, minimium file length is 1 cluster */
			pfcb->eof = 1;	/* we are currently at end of file */
			pfcb->mode = 0xE5;

			/* update directory ------------------ */
			return update_dir(pfcb);
	    }
		
		nkcfs_closedir(&fil, &dir);
	}

	return FR_DISKFULL;
}


/* read next JADOS cluster of file

	return values:
		FR_NO_FILESYSTEM:		null pointer assignment or invalid value in pfcb structure
		FR_INVALID_PARAMETER:	block device read operation failed
		FR_EOF:					file is at end
		FR_OK:					no error
*/
static DRESULT nkcfs_read_cluster(struct jdfcb *pfcb){

	DRESULT dres;
	struct _dev dev;
	JDFS *pJDFs;
	struct jdhd *pJDHd;
	struct fstabentry* pfstab;
	UCHAR *pbuffer;
	UINT start_sector, num_sectors, next_track;

	fsnkc_dbg("fs_nkc.c: nkcfs_read_cluster: ...\n");


	if(!pfcb)
	{
	  fsnkc_dbg("fs_nkc.c: nkcfs_read_cluster: error NULL pointer (pfcb) !\n");
	  return FR_NO_FILESYSTEM;
	}

	pfstab  = pfcb->pfs->pfstab;	/* pointer to file related fstab entry */
	pbuffer = pfcb->pbuffer;		/* pointer to file related cluster buffer */


	if(!pfstab)
	{
	  fsnkc_dbg("fs_nkc.c: nkcfs_read_cluster: error NULL pointer (pfstab) !\n");
	  return FR_NO_FILESYSTEM;
	}

	if(!pbuffer)
	{
	  fsnkc_dbg("fs_nkc.c: nkcfs_read_cluster: error NULL pointer (pbuffer) !\n");
	  return FR_NO_FILESYSTEM;
	}

	pJDFs = (JDFS *)pfstab->pfs;		/* pointer to JADOS file system object  */
	dev.pdrv = pfstab->pdrv; 			/* physical drive number 				*/

    if(!pJDFs)
	{
	  fsnkc_dbg("fs_nkc.c: nkcfs_read_cluster: error NULL pointer (pJDFs) !\n");
	  return FR_NO_FILESYSTEM;
	}

	pJDHd = pJDFs->pjdhd;				/* pointer to JADOS disc descriptor */

	if(!pJDHd)
	{
	  fsnkc_dbg("fs_nkc.c: nkcfs_read_cluster: error NULL pointer (pJDHd) !\n");
	  return FR_NO_FILESYSTEM;
	}


	// ----------------------------------------------------------------------------------------------------
	if(pfcb->eof) return FR_EOF;

	if(pfcb->curcluster == 9){
		/* proceed to next track */
		if(pfcb->curtrack == pfcb->lasttrack) {
			/* we are at eof ! */
			pfcb->eof = 1;
			return FR_EOF;
		}

		next_track = get_next_track(pfcb);

		if(next_track == 0xE5E5 ||		/* next track is free track */
		   next_track == 0xFFFF   ){	/* no next track            */
			/* we are at eof ! */
			pfcb->lasttrack  = pfcb->curtrack;
			pfcb->endcluster = pfcb->curcluster;
			pfcb->eof = 1;
			return FR_EOF;
		}

		pfcb->curtrack = next_track;
		pfcb->curcluster = 0;
		pfcb->crcluster++;
		pfcb->crpos = 0;	// reset current relative cluster position to 0

	}else{
		/* proceed to next cluster */
		if(pfcb->curtrack == pfcb->lasttrack && pfcb->curcluster == pfcb->endcluster){
			/* we are at eof ! */
			pfcb->eof = 1;
			return FR_EOF;
		}

		pfcb->curcluster++; // increment current track relative cluster
		pfcb->crcluster++;	// increment current file relative cluster
		pfcb->crpos = 0;	// reset current relative cluster position to 0

	}

	start_sector =    FCLUSTER + pfcb->pfs->id * PART_SIZE 	/* partition start cluster 		*/	                
					+ pfcb->curtrack * TRACK_SIZE		/* current track start cluster	*/
					+ pfcb->curcluster;					/* current cluster in track  	*/

	fsnkc_dbg("fs_nkc.c: nkcfs_read_cluster: cluster/sector=%d/%d  \n     curtrack: %d, curcluster: %d\n", start_sector, start_sector * pfcb->pfs->pjdhd->spc,pfcb->curtrack,pfcb->curcluster);

	dres = pfstab->pblkdrv->blk_oper->read( &dev,
											pfcb->pbuffer,
											pfcb->pfs->pjdhd->xoffset		/* start of extended partition */
											+ start_sector * pfcb->pfs->pjdhd->spc,		/* von cluster in sector umrechnen ! */
											pfcb->pfs->pjdhd->spc); 	                /* read complete cluster == sectors per cluster */

	if(dres != RES_OK){
		/* error handling */
		fsnkc_dbg("fs_nkc.c: nkcfs_read_cluster: error DRESULT=%d  !\n", dres);
		return FR_INVALID_PARAMETER;
	}

	return FR_OK;
}


/* write JADOS cluster */
static DRESULT nkcfs_write_cluster(struct jdfcb *pfcb){
	DRESULT dres;
	struct _dev dev;
	JDFS *pJDFs;
	struct jdhd *pJDHd;
	struct fstabentry* pfstab;
	UCHAR *pbuffer;
	UINT start_cluster, num_sectors, next_track;

	fsnkc_dbg("fs_nkc.c: nkcfs_write_cluster: ...\n");


	if(!pfcb)
	{
	  fsnkc_dbg("fs_nkc.c: nkcfs_write_cluster: error NULL pointer (pfcb) !\n");
	  return FR_NO_FILESYSTEM;
	}

	pfstab  = pfcb->pfs->pfstab;	/* pointer to file related fstab entry */
	pbuffer = pfcb->pbuffer;		/* pointer to file related cluster buffer */


	if(!pfstab)
	{
	  fsnkc_dbg("fs_nkc.c: nkcfs_write_cluster: error NULL pointer (pfstab) !\n");
	  return FR_NO_FILESYSTEM;
	}

	if(!pbuffer)
	{
	  fsnkc_dbg("fs_nkc.c: nkcfs_write_cluster: error NULL pointer (pbuffer) !\n");
	  return FR_NO_FILESYSTEM;
	}

	pJDFs = (JDFS *)pfstab->pfs;		/* pointer to JADOS file system object  */
	dev.pdrv = pfstab->pdrv; 			/* physical drive number 				*/

    if(!pJDFs)
	{
	  fsnkc_dbg("fs_nkc.c: nkcfs_write_cluster: error NULL pointer (pJDFs) !\n");
	  return FR_NO_FILESYSTEM;
	}

	pJDHd = pJDFs->pjdhd;				/* pointer to JADOS disc descriptor */

	if(!pJDHd)
	{
	  fsnkc_dbg("fs_nkc.c: nkcfs_write_cluster: error NULL pointer (pJDHd) !\n");
	  return FR_NO_FILESYSTEM;
	}

	// ----------------------------------------------------------------------------------------------------

	if(pfcb->curcluster == 10){

		fsnkc_dbg("fs_nkc.c: nkcfs_write_cluster: proceed to next track...\n");
		/* proceed to next track */
		next_track = get_next_track(pfcb);

		if(	next_track == 0xE5E5 ||		/* next track is free track */
		   	next_track == 0xFFFF   ){	/* no next track            */

		    fsnkc_dbg("fs_nkc.c: nkcfs_write_cluster: allocate new track ...\n");
		 	/* we are at current eof, check for a free cluster ! */
			if(alloc_new_track(pfcb) == FR_DISKFULL){
				/* no more free track available */
				fsnkc_dbg("fs_nkc.c: nkcfs_write_cluster: no more free track available !\n");
				pfcb->eof = 1;
				return FR_DISKFULL;
			}else{
				/* file has grown */
				pfcb->endcluster = 0;				/* last cluster of last track */
		        pfcb->eof = 1;
			}		
		}else{
			pfcb->curtrack = next_track;		/* current track 		*/		
		}
			
		pfcb->curcluster = 0;				/* current track realive cluster */
		pfcb->crpos = 0;					/* current cluster relative position */
		pfcb->crcluster++;					/* current file realtive cluster */
	}

	// ----------------------------------------------------------------------------------------------------	

	start_cluster =  FCLUSTER + pfcb->pfs->id * PART_SIZE 	/* partition start cluster 		*/	                
					+ pfcb->curtrack * TRACK_SIZE		/* current track start cluster	*/
					+ pfcb->curcluster;					/* current cluster in track  	*/

	fsnkc_dbg("fs_nkc.c: nkcfs_write_cluster: cluster/sector=%d/%d  \n     curtrack: %d, curcluster: %d\n", start_cluster, start_cluster * pfcb->pfs->pjdhd->spc,pfcb->curtrack,pfcb->curcluster);


	start_cluster = start_cluster * pfcb->pfs->pjdhd->spc; /* von cluster in sector umrechnen ! */				

	if(pfcb->pfs->pjdhd->nsectors < start_cluster) {
		de_alloc_new_track(pfcb);
		return FR_INVALID_PARAMETER;
	}

	dres = pfstab->pblkdrv->blk_oper->write( &dev,
											pfcb->pbuffer,
											pfcb->pfs->pjdhd->xoffset	      /* start of extended partition */
											+ start_cluster,								
											pfcb->pfs->pjdhd->spc); 	                /* write complete cluster == sectors per cluster */

	if(dres != RES_OK){
		/* error handling */
		fsnkc_dbg("fs_nkc.c: nkcfs_write_cluster: error DRESULT=%d  !\n", dres);
		return FR_INVALID_PARAMETER;
	}

	return FR_OK;
}

void alloc_new_cluster(struct jdfcb *pfcb){
	fsnkc_dbg("fs_nkc.c: alloc_new_cluster ...\n");
	/* proceed to next cluster */
	pfcb->curcluster++;					/* current track realive cluster */
	pfcb->crcluster++;					/* current file realtive cluster */	
	pfcb->crpos = 0;					/* current cluster relative position */

	if(pfcb->curtrack == pfcb->lasttrack &&
		pfcb->curcluster > pfcb->endcluster){
		pfcb->endcluster = pfcb->curcluster; /* adjust endcluster */
		pfcb->length++;						 /* adjust length in clusters */					
	}
	return FR_OK;
}


FRESULT nkcfs_mount(unsigned char  mount, 		/* 1=> mount, 0=> unmount */
		    struct fstabentry *pfstab		/* pointer to fstabentry with info of drive to be mounted/unmounted */
)
{
  JDFS *pJDFs;
  FATentry *pFAT;
  struct jddir *pDIR;
  struct jdhd *pJDHd, *pJDHd_last;
  UCHAR* pboot;
  DRESULT dres;
  struct _dev dev;

  struct geometry geo;
  unsigned char i,xfs;
  UINT ssector, count, offset,size;

  struct mbr *pMBR;


  if(!mount)  { // unmount volume
    fsnkc_dbg("nkcfs_mount: un-mount logical drive %s:\n", pfstab->devname);
    free(pfstab->pfs);
    return FR_OK;

  }else { /* --------------------------- mount volume ------------------------------------ */


    fsnkc_dbg("nkcfs_mount: try mount logical drive %s:\n", pfstab->devname);

    fsnkc_dbg("  phydrv  = %d\n",pfstab->pdrv);
    fsnkc_dbg("  fsdrv   = 0x%x\n",pfstab->pfsdrv);
    fsnkc_dbg("  blkdrv  = 0x%x\n",pfstab->pblkdrv);
    fsnkc_dbg("  part    = %d\n",pfstab->partition);
    fsnkc_dbg("  extended= %d\n",pfstab->extended);
    fsnkc_dbg("  extpart = %d\n",pfstab->extpart);

    // read in partition table and check, if extpart exists and fetch partiton start offset
    // use other methods with offset
    dev.pdrv = pfstab->pdrv;

    dres = pfstab->pblkdrv->blk_oper->open(&dev);

    if(dres != RES_OK){
		fsnkc_dbg(" nkcfs_mount: error %d in call to blk-ioctl ...\n",dres);
		return dres + DRESULT_OFFSET;
	}

	fsnkc_dbg("  sizeof(PT)  = %d Bytes\n",sizeof(struct ptable));
	fsnkc_dbg("  sizeof(MBR) = %d Bytes\n",sizeof(struct mbr));

    pMBR = malloc(512);

    dres = pfstab->pblkdrv->blk_oper->read( &dev, pMBR,0,1);		/* MBR size  in sectors */

    if(dres != RES_OK){
		fsnkc_dbg(" nkcfs_mount: error %d reading MBR ...\n",dres);		
		free(pMBR);
		return dres + DRESULT_OFFSET;
	}

	/*
		Disk /dev/sdb: 1.9 GiB, 2048901120 bytes, 4001760 sectors
		Units: sectors of 1 * 512 = 512 bytes
		Sector size (logical/physical): 512 bytes / 512 bytes
		I/O size (minimum/optimal): 512 bytes / 512 bytes
		Disklabel type: dos
		Disk identifier: 0x00000000
		
		Device     Boot  Start     End Sectors  Size Id Type
		/dev/sdb1         2048  206847  204800  100M  6 FAT16
		/dev/sdb2       206848 4001759 3794912  1.8G  c W95 FAT32 (LBA)

		P1: 00 							H    Ch   S       Cl
		    20 21 00 				00100000 00 100001 00000000 => C:0 H:32 S:33
		    06 
		    D3 13 0C 				11010011 00 010011 00001100 => C:12 H:211 S:19
		    00 08 00 00 2048		little-endian !!
		    00 20 03 00 204800		little-endian !!
		P2: 00 
		    D3 14 0C 
		    0C 
		    1F 3F F8 
		    00 28 03 00 206848
		    E0 E7 39 00 3794912

	*/
	fsnkc_dbg("  MBR:\n");
	fsnkc_dbg("   signature  : %04x\n"                  ,pMBR->signature);
	fsnkc_dbg("   drivesig   : %04x\n\n"                ,pMBR->drivesig);

	fsnkc_dbg("   P0:bootable: %02x\n"                  ,pMBR->pt[0].bootable);
	fsnkc_dbg("   P0:startchs: %03x (H:%d|S:%d|C:%d)\n" ,pMBR->pt[0].start_chs, 
														(pMBR->pt[0].start_chs & 0xFF0000) >> 16, /* Heads */
														(pMBR->pt[0].start_chs & 0x003F00) >> 8,  /* Sectors */
													    (pMBR->pt[0].start_chs & 0x006000 >> 6) + pMBR->pt[0].start_chs & 0x0000FF); /* Cylinder */
	fsnkc_dbg("   P0:endchs  : %03x (H:%d|S:%d|C:%d)\n" ,pMBR->pt[0].end_chs, 
														(pMBR->pt[0].end_chs & 0xFF0000) >> 16, 
														(pMBR->pt[0].end_chs & 0x003F00) >> 8,
													    (pMBR->pt[0].end_chs & 0x006000 >> 6) + pMBR->pt[0].end_chs & 0x0000FF);
	fsnkc_dbg("   P0:startsec: %04x (%u)\n"             ,pMBR->pt[0].start_sector, ENDIAN(pMBR->pt[0].start_sector)); /* start-sector */
	fsnkc_dbg("   P0:numsec  : %04x (%u)\n"             ,pMBR->pt[0].num_sector, ENDIAN(pMBR->pt[0].num_sector)); /* number of secors */
	fsnkc_dbg("   P0:type    : %02x\n\n"                ,pMBR->pt[0].type);

	fsnkc_dbg("   P1:bootable: %02x\n"                  ,pMBR->pt[1].bootable);
	fsnkc_dbg("   P1:startchs: %03x (H:%d|S:%d|C:%d)\n" ,pMBR->pt[1].start_chs, 
														(pMBR->pt[1].start_chs & 0xFF0000) >> 16, 
														(pMBR->pt[1].start_chs & 0x003F00) >> 8,
													    (pMBR->pt[1].start_chs & 0x006000 >> 6) + pMBR->pt[1].start_chs & 0x0000FF);
	fsnkc_dbg("   P1:endchs  : %03x (H:%d|S:%d|C:%d)\n" ,pMBR->pt[1].end_chs, 
														(pMBR->pt[1].end_chs & 0xFF0000) >> 16, 
														(pMBR->pt[1].end_chs & 0x003F00) >> 8,
													    (pMBR->pt[1].end_chs & 0x006000 >> 6) + pMBR->pt[1].end_chs & 0x0000FF);
	fsnkc_dbg("   P1:startsec: %04x (%u)\n"             ,pMBR->pt[1].start_sector,ENDIAN(pMBR->pt[1].start_sector));
	fsnkc_dbg("   P1:numsec  : %04x (%u)\n"             ,pMBR->pt[1].num_sector,ENDIAN(pMBR->pt[1].num_sector));
	fsnkc_dbg("   P1:type    : %02x\n\n"                ,pMBR->pt[1].type);

	fsnkc_dbg("   P2:bootable: %02x\n"                  ,pMBR->pt[2].bootable);
	fsnkc_dbg("   P2:startchs: %03x (H:%d|S:%d|C:%d)\n" ,pMBR->pt[2].start_chs, 
														(pMBR->pt[2].start_chs & 0xFF0000) >> 16, 
														(pMBR->pt[2].start_chs & 0x003F00) >> 8,
													    (pMBR->pt[2].start_chs & 0x006000 >> 6) + pMBR->pt[2].start_chs & 0x0000FF);
	fsnkc_dbg("   P2:endchs  : %03x (H:%d|S:%d|C:%d)\n" ,pMBR->pt[2].end_chs, 
														(pMBR->pt[2].end_chs & 0xFF0000) >> 16, 
														(pMBR->pt[2].end_chs & 0x003F00) >> 8,
													    (pMBR->pt[2].end_chs & 0x006000 >> 6) + pMBR->pt[2].end_chs & 0x0000FF);
	fsnkc_dbg("   P2:startsec: %04x (%u)\n"             ,pMBR->pt[2].start_sector,ENDIAN(pMBR->pt[2].start_sector));
	fsnkc_dbg("   P2:numsec  : %04x (%u)\n"             ,pMBR->pt[2].num_sector,ENDIAN(pMBR->pt[2].num_sector));
	fsnkc_dbg("   P2:type    : %02x\n\n"                ,pMBR->pt[2].type);

	fsnkc_dbg("   P3:bootable: %02x\n"                  ,pMBR->pt[3].bootable);
	fsnkc_dbg("   P3:startchs: %03x (H:%d|S:%d|C:%d)\n" ,pMBR->pt[3].start_chs, 
														(pMBR->pt[3].start_chs & 0xFF0000) >> 16, 
														(pMBR->pt[3].start_chs & 0x003F00) >> 8,
													    (pMBR->pt[3].start_chs & 0x006000 >> 6) + pMBR->pt[3].start_chs & 0x0000FF);
	fsnkc_dbg("   P3:endchs  : %03x (H:%d|S:%d|C:%d)\n" ,pMBR->pt[3].end_chs, 
														(pMBR->pt[3].end_chs & 0xFF0000) >> 16, 
														(pMBR->pt[3].end_chs & 0x003F00) >> 8,
													    (pMBR->pt[3].end_chs & 0x006000 >> 6) + pMBR->pt[3].end_chs & 0x0000FF);
	fsnkc_dbg("   P3:startsec: %04x (%u)\n"             ,pMBR->pt[3].start_sector,ENDIAN(pMBR->pt[3].start_sector));
	fsnkc_dbg("   P3:numsec  : %04x (%u)\n"             ,pMBR->pt[3].num_sector,ENDIAN(pMBR->pt[3].num_sector));
	fsnkc_dbg("   P3:type    : %02x\n\n"                ,pMBR->pt[3].type);


    if(pMBR->signature == 0x55aa) {	/* DOS flag ? */
	    fsnkc_dbg("   valid MBR ...\n");
    	offset = ENDIAN(pMBR->pt[pfstab->partition].start_sector); /* offset to start of jados 'hard disk' */
    	size = ENDIAN(pMBR->pt[pfstab->partition].num_sector);     /* size of partition and all jados disks inside */
        xfs = 1;
    }else{
    	fsnkc_dbg("   not a valid MBR ...\n");
 		offset = 0;
		size = 0;
        xfs = 0;
    }

	free(pMBR);

    // allocate memory for JDFS structure and store pointer in fstab
    pJDFs = (JDFS*)malloc(sizeof(JDFS));
    if(!pJDFs) { // errorhandling
		fsnkc_dbg("nkcxfs_mount error: no memory for pJDFs\n");
		return FR_NOT_ENOUGH_CORE;
    }

    memset(pJDFs,0,sizeof(JDFS)); // reset all values....

    fsnkc_dbg("nkcfs_mount: memory for JDFS object alocated (0x%x)\n",pJDFs);

    pJDFs->pfstab = pfstab;				// add fstabentry to JDFs struct

    // search for harddisk descriptor ...
    
    fsnkc_dbg("nkcfs_mount: search entry in hd table ...\n"); 
	pJDHd = pJDHd_last = pJDHDtable;
    /* walk through table ... */
	while(pJDHd) {
		if(!strncmp( pJDHd->name, pfstab->devname, 3) )  break;
		pJDHd_last = pJDHd;
		pJDHd = pJDHd->pnext;	   
	}


    // if no descriptor available -> create one, init drive and read in drive info  ...
    if(!pJDHd) { /* --------------------------- initialize drive information START ------------------------------------ */
        dres = pfstab->pblkdrv->blk_oper->ioctl(&dev, FS_IOCTL_DISK_INIT, 0);

        if(dres != RES_OK){
			fsnkc_dbg(" nkcfs_mount: error %d in call to blk-ioctl ...\n",dres);
			free(pJDFs);
			return dres + DRESULT_OFFSET;
		}

        fsnkc_dbg("nkcfs_mount: no hd descriptor available, read in drive info and create one\n");

		switch(dres){
		  case RES_OK: break;
		  default:
		    fsnkc_dbg("nkcfs_mount error DRESULT(%d) initializing disk (%d)\n", dres,dev.pdrv);
		    return dres + DRESULT_OFFSET;
		}

		// allocate memory for JADOS harddisk descriptor
		pJDHd = (struct jdhd*)malloc(sizeof(struct jdhd));
		if(!pJDHd) { // errorhandling
		    fsnkc_dbg("nkcfs_mount error: no memory for pJDHd\n");
		    free(pJDFs);
		    return FR_NOT_ENOUGH_CORE;
		}
		memset(pJDHd,0,sizeof(struct jdhd)); // reset all values....


		// allocate memory for bootblock
		pboot = (void*)malloc(BBSIZE*CLUSTERSIZE);
		if(!pboot) { // errorhandling
		  fsnkc_dbg("nkcfs_mount error: no memory for pboot\n");
		    free(pJDFs);
		    free(pJDHd);
		    return FR_NOT_ENOUGH_CORE;
		}

		// check valid partitions
		fsnkc_dbg(" nkcfs_mount: check partitions ...\n");
		dres = pfstab->pblkdrv->blk_oper->geometry(&dev, &geo);

		if(dres != RES_OK){
			fsnkc_dbg(" nkcfs_mount: error %d in call to geometry ...\n",dres);
			free(pJDFs);
		    free(pJDHd);
			return dres + DRESULT_OFFSET;
		}

		pJDHd->csize = CLUSTERSIZE ;					/* JADOS uses 1024 bytes per 'sector' */
		pJDHd->spc = CLUSTERSIZE / geo.sectorsize; 	/* sectors per cluster = 2 for a device with 512 bytes sector size */
		pJDHd->nsectors = geo.nsectors;
		pJDHd->xoffset = offset;  
		pJDHd->xsize = size;
		pJDHd->xfs = xfs;		

		fsnkc_dbg(" nkcfs_mount: pJDHd->spc      = %d\n",pJDHd->spc);
		fsnkc_dbg("              pJDHd->csize    = %d\n",pJDHd->csize);
		fsnkc_dbg("              pJDHd->nsectors = %d\n",pJDHd->nsectors);

		// read in bootblock ...
		fsnkc_dbg("nkcfs_mount: read bootblock of %s\n",pfstab->pblkdrv->pdrive);
		dres = pfstab->pblkdrv->blk_oper->read( &dev, pboot, pJDHd->xoffset, BBSIZE * pJDHd->spc);

		switch(dres){
		  case RES_OK: break;
		  default:
		    fsnkc_dbg("nkcfs_mount error DRESULT(%d) reading bootblock\n", dres);
		    free(pJDFs);
		    free(pJDHd);
		    free(pboot);
		    return dres + DRESULT_OFFSET;
		}

		fsnkc_dbg(" bootblock:\n");
		fsnkc_dbg("   %02X %02X %02X %02X %02X %02X %02X %02X : %02X %02X %02X %02X %02X %02X %02X %02X ....\n",
			  pboot[0],pboot[1],pboot[2],pboot[3],pboot[4],pboot[5],pboot[6],pboot[7],pboot[8],pboot[9],pboot[10],pboot[11],pboot[12],pboot[13],pboot[14],pboot[15]);

		// check jados label
		fsnkc_dbg(" nkcfs_mount: check JADOS disk label ...\n");
		if(pboot[4] != 0x4B || pboot[5] != 0x4A || pboot[6] != 0x38 || pboot[7] != 0x36 ||
		   pboot[8] != 0x33 || pboot[9] != 0x2E || pboot[10]!= 0x35 || pboot[11]!= 0x30) // .i.e. 'KJ863.50'
		{
		    fsnkc_dbg("nkcfs_mount error: not a JADOS harddisk !\n");
		    free(pJDFs);
		    free(pJDHd);
		    free(pboot);
		    return FR_NO_FILESYSTEM;
		}
		fsnkc_dbg(" nkcfs_mount: found JADOS disk label ...\n");

		// check if bootable
		fsnkc_dbg(" nkcfs_mount: check if bootable: ");
		if(pboot[0] != 0x4E || pboot[1] != 0x71 || pboot[2] != 0x60) // i.e. NOP BRA ...
		{
		  fsnkc_dbg("      no\n");
		}else{
		  pJDHd->bootflag = 1;
		  fsnkc_dbg("      yes\n");
		}

		// walk through the disk ....
		fsnkc_dbg(" nkcfs_mount: valid partitions are: \n"); 
		dres = RES_OK;
		i=0;
		ssector = FCLUSTER * pJDHd->spc + pJDHd->xoffset; /* 1st sector of JADOS xHD */

		do{
					  
		    fsnkc_dbg(" check if partition %d startig at sector %d is valid (maxsector = %d)...\n ",i,ssector,pJDHd->nsectors);
		    dres = pfstab->pblkdrv->blk_oper->read(&dev, pboot, ssector, 1); // we use pboot as tmp buffer

		    if(dres != RES_OK){		  
			    fsnkc_dbg("nkcfs_mount error %d blk-read (1)\n", dres);
			    free(pJDFs);
			    free(pJDHd);
			    free(pboot);
			    return dres + DRESULT_OFFSET;
		    }

		    if(pboot[0] == 0xE5 && pboot[1] == 0xE5 && pboot[2] == 0xE5 && pboot[3] == 0xE5)
		    {
		      pJDHd->pvalid[i] = 1;
		      fsnkc_dbg(" -----> YES \n");
		    }else{
		      fsnkc_dbg(" -----> NO\n")
		    }

			i++;
			// calc next sector, check in while for validity
			ssector = (FCLUSTER + i*PART_SIZE) * pJDHd->spc + pJDHd->xoffset; /* 1st sector of i-th partition JADOS xHD */

		} while(i < MAX_PARTITIONS && ssector < pJDHd->nsectors && dres == RES_OK);
		

		// initialize new descriptor
		pJDHd->pnext = NULL;
		strncpy(pJDHd->name,pfstab->devname,3);
		(pJDHd->name)[3] = 0;

		pJDHd_last = pJDHd; // add descriptor to table

		free(pboot);
    } /* --------------------------- initialize drive information END ------------------------------------ */

    
    if( (xfs == 1) && (pJDHd->pvalid[pfstab->extpart]) )  // extended partiton
    {
      fsnkc_dbg(" nkcfs_mount: partition %d/%d is a valid jados volume ...\n",pfstab->partition, pfstab->extpart);
    }else if( (xfs == 0) && (pJDHd->pvalid[pfstab->partition]) ){
      fsnkc_dbg(" nkcfs_mount: partition %d is a valid jados volume ...\n",pfstab->partition);
    } else{
      fsnkc_dbg(" nkcfs_mount: error, partition %d/%d is not valid ...\n",pfstab->partition, pfstab->extpart);
      free(pJDFs);
      return FR_NO_FILESYSTEM;
    }

    pJDFs->pjdhd = pJDHd; 				/* add JADOS harddisk descriptor */

    if(xfs == 1)
    	pJDFs->id = pfstab->extpart;		/* add extended partition number          */
    else pJDFs->id = pfstab->partition;		/* add partition number          */	

    /* --------------------------- read/store FAT of exteded JADOS volume ------------------------------------ */

    fsnkc_dbg(" nkcfs_mount: read FAT ...\n");
    pFAT = (FATentry*)malloc(NUM_JD_FAT_ENTRIES * sizeof(FATentry));

    if(!pFAT) { // errorhandling
		    fsnkc_dbg("nkcfs_mount error: no memory for pFAT\n");
		    free(pJDFs);
		    return FR_NOT_ENOUGH_CORE;
		}

	dres = pfstab->pblkdrv->blk_oper->read( &dev, pFAT,
		                                        pJDHd->xoffset +                                /* start of extended partition */
												(FCLUSTER + pJDFs->id * PART_SIZE) * pJDHd->spc, /* start sector */
												FAT_SIZE * pJDHd->spc); 			/* number of sectors = FAT size in clusters * sectors per cluster */

	if(dres != RES_OK){		  
	    fsnkc_dbg("nkcfs_mount error %d blk-read (2)\n", dres);
		free(pJDFs);
		free(pFAT);
	    return dres + DRESULT_OFFSET;
	}

	pJDFs->pFAT = pFAT;		/* add FAT */

	/* --------------------------- read/store DIR ------------------------------------ */

    fsnkc_dbg(" nkcfs_mount: read DIR ...\n");
    pDIR = (struct jddir*)malloc(NUM_JD_DIR_ENTRIES * sizeof(struct jddir));

    if(!pDIR) { // errorhandling
		    fsnkc_dbg("nkcfs_mount error: no memory for pDIR\n");
		    free(pJDFs);
		    free(pFAT);
		    return FR_NOT_ENOUGH_CORE;
		}

	dres = pfstab->pblkdrv->blk_oper->read( &dev, pDIR,
		                            pJDHd->xoffset 									/* start of extended partition */
  								+	FCLUSTER * pJDHd->spc    						/* start of first partition */
						      	+	pJDFs->id * PART_SIZE * pJDHd->spc     			/* partitions start sector  */
  								+   FAT_SIZE * pJDHd->spc,							/* DIRs start sector     	*/
								
  									DIR_SIZE * pJDHd->spc);							/* DIR size  in sectors */

	if(dres != RES_OK){		  
	    fsnkc_dbg("nkcfs_mount error %d blk-read (2)\n", dres);
	    free(pDIR);
		free(pJDFs);
		free(pFAT);
	    return dres + DRESULT_OFFSET;
	}

	pJDFs->pDIR = pDIR;		/* add DIR */

	/* DEBUG: dump directory */
	#ifdef CONFIG_DEBUG_FS_NKC_
	unsigned int ii,d,y,m;
	struct jddir *pdir;
	char tmp[10];

	pdir = pDIR;
	for(ii=0; ii<NUM_JD_DIR_ENTRIES;ii++){
		printf(" ii:%d\n", ii);
		printf(" id:0x%04x\n", pdir[ii].id);
		strncpy(tmp,pdir[ii].filename,8); tmp[8]=0;
		printf(" filename: %s\n", tmp);
		printf(" res01: 0x%04x\n", pdir[ii].reserved01);
		strncpy(tmp,pdir[ii].fileext,3); tmp[3]=0;
		printf(" fileexet: %s\n", tmp);
		printf(" res02: 0x%02x\n", pdir[ii].reserved02);
		printf(" starttrack: %d\n", pdir[ii].starttrack);
		printf(" endcluster: %d\n", pdir[ii].endcluster);
		printf(" endbyte: 0x%04x\n", pdir[ii].endbyte);
		d = ((pdir[ii].date & 0x0000000F))       + (((pdir[ii].date & 0x000000F0) >> 4) *10);  /* day */
    	m = ((pdir[ii].date & 0x00000F00) >> 8)  + (((pdir[ii].date & 0x0000F000) >> 12) *10); /* month */
  		y = ((pdir[ii].date & 0x000F0000) >> 16) + (((pdir[ii].date & 0x00F00000) >> 20) *10); /* year */
		printf(" date: %02d.%02d.%02d\n", d, m, y);
		printf(" length: %d\n", pdir[ii].length);
		printf(" mode: 0x%02x\n", pdir[ii].mode);
		printf(" res03: 0x%04x\n", pdir[ii].reserved03);
		printf(" res04: 0x02x\n", pdir[ii].reserved04);
		getchar();
	}
	#endif

    pfstab->pfs = pJDFs;								/* return pointer to JADOS file system in fstab entry */
    ((JDFS*)pfstab->pfs)->fs_id = FS_TYPE_JADOS;		/* idetify this filesystem (id's defined in fs.h) */

    fsnkc_dbg(" nkcfs_mount: set fs_id to %d (%d) ...\n",((JDFS*)pfstab->pfs)->fs_id, ((FS*)pfstab->pfs)->fs_id);

    return FR_OK;
  } // ------ mount volume  -------
}


/*******************************************************************************
 *   public functions
 *******************************************************************************/


/* open directory of given volume */
static int     nkcfs_opendir(struct _file *filp, const char *relpath, DIR *dir) {
  FRESULT res;
  DRESULT dres;
  struct _dev dev;
  struct fstabentry* pfstab;
  struct jddir *pdir;
  JDFS *pJDFs;
  struct jdhd *pJDHd;


  fsnkc_dbg("fs_nkc.c: [ nkcfs_opendir '%s' ...\n",relpath);
  if(dir == NULL)  {
  	fsnkc_dbg(" ... dir==NULL - nkcfs_opendir]\n");
  	return FR_INVALID_PARAMETER;
  }

  pfstab = filp->p_fstab;
  if(pfstab == NULL){
  	fsnkc_dbg(" ... pfstab==NULL - nkcfs_opendir]\n"); 
  	return FR_INVALID_DRIVE;
  }

  fsnkc_dbg("fs_nkc.c: nkcfs_opendir: pfstab = 0x%0x ...\n",pfstab);

  pJDFs = (JDFS *)pfstab->pfs;
  pJDHd = pJDFs->pjdhd;

  memset(dir,0, sizeof(DIR) ); 		/* initialize fields */
  dir->fs = (FATFS*)pfstab->pfs;        /* typecast to use one single structure 'FATFS' systemwide */
  dir->dir = (BYTE*)pJDFs->pDIR;
  dir->index = 0;


  fsnkc_dbg(" .... nkcfs_opendir]\n");
  return FR_OK;

}


/* return FR_OK or FR_EOF if DIR at EOF */
static int     nkcfs_readdir(struct _file *filp, DIR *dir,FILINFO* finfo) {
  struct jddir *pdir;
  char *pch;
  int y,m,d;

  fsnkc_dbg("fs_nkc.c: [ nkcfs_readdir ...\n");
  if(dir == NULL) { 
  	fsnkc_dbg("fs_nkc.c: (dir == NULL) nkcfs_readdir ]\n");
  	return FR_INVALID_PARAMETER;
  }
  if(finfo == NULL) { 
  	fsnkc_dbg("fs_nkc.c: (finfo == NULL) nkcfs_readdir ]\n");
  	return FR_INVALID_PARAMETER;
  }

  pdir = dir->dir;

  fsnkc_dbg("fs_nkc.c: nkcfs_readdir: indx=%d\n",dir->index);

  while(pdir[dir->index].id && dir->index < NUM_JD_DIR_ENTRIES) dir->index++;

  if(dir->index < NUM_JD_DIR_ENTRIES) { /* valid entry found */
    /* fill FILINFO */
    d = ((pdir[dir->index].date & 0x0000000F))       + (((pdir[dir->index].date & 0x000000F0) >> 4) *10);  /* day */
    m = ((pdir[dir->index].date & 0x00000F00) >> 8)  + (((pdir[dir->index].date & 0x0000F000) >> 12) *10); /* month */
  	y = ((pdir[dir->index].date & 0x000F0000) >> 16) + (((pdir[dir->index].date & 0x00F00000) >> 20) *10); /* year */
    /* */
  	fsnkc_dbg("  index:  %d ...\n", dir->index);
    fsnkc_dbg("  filename:  '%s.%s' ...\n", pdir[dir->index].filename,pdir[dir->index].fileext);
    fsnkc_dbg("  length:    %d ...\n", pdir[dir->index].length*1024);
    fsnkc_dbg("  date:      %02d.%02d.%02d ...\n", d, m, y);  	/* day, month, year */

    /* change size and date format to FAT info format, which is used in upper layers... (see also FAT file system) */
    //	15-9 	Year (0 = 1980, 119 = 2099 supported under DOS/Windows, theoretically up to 127 = 2107)
	//	8-5 	Month (1–12)
	//	4-0 	Day (1–31)
    finfo->fsize = pdir[dir->index].length*1024;
    // FIXME: we should not add 2000 if RTC supports y2k, but hey ... 
    finfo->fdate  = ((y + 2000) - 1980) << 9; 	/* year */
    finfo->fdate += m << 5; 					/* month */
    finfo->fdate +=  d;  						/* day */

    finfo->ftime = 0;							/* we have no time information in JADOS */

    /* filename */
    if( strlen(pdir[dir->index].filename) <= 8){
      strcpy(finfo->fname,pdir[dir->index].filename);
      if(pch = strchr(finfo->fname,0x20) ) *pch = 0; /* remove trailing spaces */ 
    }
    else strncpy(finfo->fname,pdir[dir->index].filename,8);

    /* delimiter */
    strcat(finfo->fname,".");
    
    /* file extension */
    if( strlen(pdir[dir->index].fileext <=3) ){
      strcat(finfo->fname,pdir[dir->index].fileext);
      if(pch = strchr(finfo->fname,0x20) ) *pch = 0; /* remove trailing spaces */
    }
    else strncat(finfo->fname,pdir[dir->index].fileext,3);


    switch(pdir[dir->index].mode){
      case 0xE4: finfo->fattrib = AM_RDO; break;
      case 0xE5: finfo->fattrib = 0; break;
      default: finfo->fattrib = 0; break;
    }
    dir->index++;
    fsnkc_dbg("fs_nkc.c: ... nkcfs_readdir (OK) ]\n");
    return FR_OK;
  } else { 
  	fsnkc_dbg("fs_nkc.c: ... nkcfs_readdir (EOD/EOF) ]\n");
  	return FR_EOF; /* end of directory reached, no more valid entry */
  }

}

/* close directory *dir (filp is not used) */
static int     nkcfs_closedir(struct _file *filp, DIR *dir) {
  fsnkc_dbg("fs_nkc.c: [ nkcfs_closedir ...\n");
  if(dir == NULL) return FR_INVALID_PARAMETER;
  fsnkc_dbg("fs_nkc.c: free DIR structure ...\n");
#if 0  
  free(dir->dir); /* FIXME: ??? free allocated memory for directory structure */
#endif
  fsnkc_dbg("fs_nkc.c: nkcfs_closedir ...]\n");
}

/* return number of free clusters */
static int nkcfs_getfree(struct fstabentry* pfstab,DWORD *nclst) {

  DRESULT dres;
  FATentry JDFAT[256];
  int ii,n;
  struct _dev dev;
  JDFS *pJDFs;
  struct jdhd *pJDHd;

  fsnkc_dbg("fs_nkc.c: nkcfs_getfree: ...\n");

  if(!pfstab)
  {
    fsnkc_dbg("fs_nkc.c: nkcfs_getfree: error NULL pointer !\n");
    return FR_NO_FILESYSTEM;
  }

  pJDFs = (JDFS *)pfstab->pfs;
  pJDHd = pJDFs->pjdhd;

  dev.pdrv = pfstab->pdrv;
  /* read directory to buffer , i.e partitions sector 0 (0-1 with 512 bytes sector size) */
  dres = pfstab->pblkdrv->blk_oper->read( &dev, JDFAT,
  	                                            pJDHd->xoffset +                                 /* start of extended partition */
												(FCLUSTER + pJDFs->id * PART_SIZE) * pJDHd->spc, /* start sector */
												FAT_SIZE * pJDHd->spc); 			/* number of sectors = FAT size in clusters * sectors per cluster */
  /* count free FAT entries */
  n=0;
  for(ii=0; ii < FAT_ENTRIES; ii++)
  {
    if(JDFAT[ii].ancestor == FAT_FREE_MASK) n++;
  }

  *nclst = n;

  fsnkc_dbg("fs_nkc.c: nkcfs_getfree: free clusters = %d (total 256)\n", *nclst);

  return FR_OK;
}





/*******************************************************************************
 *   public functions
 *******************************************************************************/
static int nkcfs_ioctl(struct fstabentry* pfstab, int cmd, unsigned long arg){

  char cdrive[2];
  FRESULT res;
  struct _file File;

  struct slist *pslist;

  fsnkc_dbg("fs_nkc.c: [ nkcfs_ioctl (cmd = %d)...\n",cmd);

  switch(cmd){

    // ****************************** get current working directory ******************************
    case FS_IOCTL_GETCWD:
      fsnkc_dbg("fs_nkc.c: - FS_IOCTL_GETCWD -\n");

      strcpy((char*)((struct ioctl_get_cwd*)(arg))->cdrive,current_jados_drive); // return current jados drive
      strcpy((char*)((struct ioctl_get_cwd*)(arg))->cpath,"/");     /* there is nothing like a subdirectory in JADOS/NKC FS */
      res = FR_OK;
      break;
    // ****************************** change physical drive ******************************
    case  FS_IOCTL_CHDRIVE:
      // *filp=NULL, cmd=FS_IOCTL_CHDRIVE, arg = (struct fstabentry*)pfstab
      fsnkc_dbg(" fs_nkc.c: FS_IOCTL_CHDRIVE: %s", ((struct fstabentry*)arg)->devname);
      fsnkc_lldbgwait("(KEY)\n");

      strcpy(current_jados_drive,((struct fstabentry*)arg)->devname); // set selected drive as current drive

      res = FR_OK;
      break;
    // ****************************** open directory **************************************
    case FS_IOCTL_OPEN_DIR:
			      fsnkc_dbg(" FS_IOCTL_OPEN_DIR(1):   path = 0x%0x (%s)\n",((struct ioctl_opendir*)arg)->path,((struct ioctl_opendir*)arg)->path);
			      File.p_fstab = pfstab;
			      res = nkcfs_opendir(&File,((struct ioctl_opendir*)arg)->path,
						       ((struct ioctl_opendir*)arg)->dp);
			      fsnkc_dbg(" FS_IOCTL_OPEN_DIR(2):   path = 0x%0x\n",((struct ioctl_opendir*)arg)->path);
			      break;
     // ****************************** read directory ******************************
    case FS_IOCTL_READ_DIR:
			      fsnkc_dbg(" fs_nkc.c| FS_IOCTL_READ_DIR: (%s)\n",(char*)arg);
			      res = nkcfs_readdir(NULL,((struct ioctl_readdir*)arg)->dp,
						       ((struct ioctl_readdir*)arg)->fno);
			      break;
    // ****************************** close directory ******************************
    case FS_IOCTL_CLOSE_DIR:
			      fsnkc_dbg(" fs_nkc.c| FS_IOCTL_CLOSE_DIR: (0x%0x)\n",(DIR*)arg);
			      res = nkcfs_closedir(NULL,(DIR*)arg);
			      break;
    // ****************************** get free  ******************************
    case FS_IOCTL_GET_FREE:
			      fsnkc_dbg(" fs_nkc.c|FS_IOCTL_GET_FREE : drive = %s, FS = %s\n", pfstab->devname, pfstab->pfsdrv->pname);
			      if(pfstab)
			      {
					res = nkcfs_getfree(pfstab, ((struct ioctl_getfree*)arg)->nclst);
			      }

			      *((struct ioctl_getfree*)arg)->ppfs = (FS*)pfstab->pfs;

			      fsnkc_dbg(" fs_nkc.c|FS_IOCTL_GET_FREE : fs_id = %d \n", ((FS*)pfstab->pfs)->fs_id);
			      break;
    // ****************************** mount ******************************
    case FS_IOCTL_MOUNT:
      //name = NULL, cmd = FS_IOCTL_MOUNT, arg = pfstab
      // this is called after an entry was inserted into fstab in fs.c. We have to translate volume name to physical drive number here,
      // so 'get_phy_driver' can fetch the correct block driver in subsequent file operations.

      fsnkc_dbg("fs_nkc.c: - FS_IOCTL_MOUNT -\n");

      if(!arg){
		res = FR_INVALID_PARAMETER;
		fsnkc_lldbgwait("fs_nkc: error: invalid parameter arg=NULL !\n");
		break;
      }

      res = nkcfs_mount(1, ((struct fstabentry*)arg));

      break;

    // ****************************** un-mount ******************************
    case FS_IOCTL_UMOUNT:
      //name = NULL, cmd = FS_IOCTL_MOUNT, arg = pfstab
      // this is called after an entry was inserted into fstab in fs.c. We have to translate volume name to physical drive number here,
      // so 'get_phy_driver' can fetch the correct block driver in subsequent file operations.

      fsnkc_dbg("fs_nkc.c: - FS_IOCTL_UMOUNT -\n");

      if(!arg){
		res = FR_INVALID_PARAMETER;
		fsnkc_lldbgwait("fs_nkc: error: invalid parameter arg=NULL !\n");
		break;
      }

      res = nkcfs_mount(0, ((struct fstabentry*)arg));

      break;

    // ****************************** get list of sectors the file occupies on disk ******************************
    case FS_IOCTL_GET_SLIST:
        fsnkc_dbg("fs_nkc.c: - FS_IOCTL_GET_SLIST -\n");
        File.p_fstab = pfstab;
        File.pname = ((struct ioctl_get_slist*)arg)->filename;

        pslist = nkcfs_get_slist(&File);
        fsnkc_dbg("fs_nkc.c: nkcfs_get_slist returned 0x%08x\n", pslist);

        ((struct ioctl_get_slist*)arg)->list = pslist;

        res = EZERO;

    	break;



    default: res = FR_OK;
  }

  fsnkc_dbg("fs_nkc.c: ... nkcfs_ioctl(%d) ]\n", res);

  return res;
}

/*
	searches for file given in filp->pname in pdir
	if the file is found, its dir contentents are copied to pjddir
*/
static  int find_file(struct _file *filp, DIR *pdir,struct jddir *pjddir)
{
	int res,n;
	char tmp[255];
	struct jddir *p;
	FILINFO Finfo;

	fsnkc_dbg("fs_nkc.c|find_file: ....\n");

   	if(pdir == NULL) return FR_INVALID_PARAMETER;
	if(filp == NULL) return FR_INVALID_PARAMETER;
	if(pjddir == NULL) return FR_INVALID_PARAMETER;

	// FIXME: already done in higher layer ?!
 	if( checkfp(filp->pname, &FPInfo) != EZERO ) {
 	  fsnkc_dbg("fs_nkc.c|find_file: ... ENOFILE (2) ]\n");
 	  return EINVAL;
 	}

 	// build filename ...
 	//sprintf(tmp,"%-8s%c%-3s",FPInfo.psz_filename, FPInfo.c_separator, FPInfo.psz_fileext);
 	sprintf(tmp,"%s%c%s",FPInfo.psz_filename, FPInfo.c_separator, FPInfo.psz_fileext);

 	sprintf(pjddir->filename,"%-8s",FPInfo.psz_filename); /* if the file is not found the caller can create a new fcb */
 	sprintf(pjddir->fileext,"%-3s",FPInfo.psz_fileext);

 	fsnkc_dbg("fs_nkc.c|find_file: search for %s\n",tmp); 	

 	res = nkcfs_opendir(filp, NULL, pdir);

 	/*  cycle throug dir, check if file exists
 	 */
 	for(;;) {

 	   	res = nkcfs_readdir(filp, pdir, &Finfo);

     	switch(res){
     	    case FR_OK: /* OK */
     	    	break;
     	    case FR_EOF: /* End Of Directory reached and file not found */
     	    default: /* unknown return code */

     	    	nkcfs_closedir(filp, pdir);

     	    	fsnkc_dbg("fs_nkc.c|find_file: not found: %s.%s\n",FPInfo.psz_filename,FPInfo.psz_fileext);

     	    	return ENOFILE;     	    	
     	 }

 	    fsnkc_dbg("fs_nkc.c|find_file: entry: %s\n",Finfo.fname);

 	    if(!strcmp(Finfo.fname, tmp)) {
	        /* found file .... */
		    fsnkc_dbg("fs_nkc.c|find_file: file found ...\n");
		      res = EZERO;

		      p = pdir->dir;				/* pointer to start of JADOS directory */

		      memcpy(pjddir, &p[pdir->index-1], sizeof(struct jddir)); /* copy file info */

		      break; /* terminate for(;;) */
 	   }
	    //	 until file found or dir ends(file not found) 	   
 	}

 	nkcfs_closedir(filp, pdir);

 	fsnkc_dbg("fs_nkc.c|find_file: res = %d\n",res);
 	return res;
}


/*
	open a file given in filp
*/
static int nkcfs_open(struct _file *filp)
{
   long mode;
   unsigned char omode,iread;
   struct jdfcb *pfcb;
   DIR dir;					/* Directory object 		*/
   struct jddir jdir;		/* JADOS Directory entry 	*/
   FRESULT res;
   UINT start_sector;
   DRESULT dres;
   struct _dev dev;
   char tmp[10];



   fsnkc_dbg("fs_nkc.c: [ nkcfs_open ....\n");

   fsnkc_dbg("    name = '%s', mode=0x%x\n",filp->pname,filp->f_oflags);

   if(filp == NULL) {
    fsnkc_dbg("fs_nkc.c: ... nkcfs_open ENOFILE ]\n");
    return ENOFILE;
   }

   /* translate stdio.h mode flag to definition of ff.h (Chungs FAT-FS) ...  */
   mode = 0;	/* file open mode 				 */
   omode = 0;	/* file open mode  (JADOS style) */
   iread = 0;   /* read first sector ?           */
   if(filp->f_oflags & _F_READ) mode |= FA_READ; // _F_READ = 1, FA_READ = _F_READ
   if(filp->f_oflags & _F_WRIT) mode |= FA_WRITE; // F_WRIT = 2, FA_WRITE = 2 (i.e = _F_WRIT)
   if(filp->f_oflags & _F_CREATE) mode |= FA_CREATE_NEW; // _F_CREATE = 0x800, FA_CREATE_NEW = 4

   fsnkc_dbg("fs_nkc.c|nkcfs_open: mode = 0x%x\n",mode);
   							// es wird von "oben" immer "create new" uebergeben, wenn eine Datei zum Schreiben geoeffnet werden soll
   							// das fuehrt richtigerweise zu einem Fehler => FIXME: check upper layer !

   res = find_file(filp,&dir,&jdir); /* fetch file information */

   switch (res) {
     case EINVAL:
       fsnkc_dbg("fs_nkc.c:|nkcfs_open: EINVAL(1) ]\n");
       return EINVAL;
     case ENOFILE: // file not found (create new file ?)
        if(mode & FA_READ) { // nonexist. file cannot be opened for read operations
        	fsnkc_dbg("fs_nkc.c: ... nonexist. file cannot be opened for read operations ]\n");
       		return ENOFILE;
     	}
     	if((mode & FA_CREATE_NEW) ||(mode & FA_WRITE)) { 						// create new file
     		fsnkc_dbg("fs_nkc.c: ... create new file ...\n");
     		omode = 0xE5;     	

     		/* allocate FCB structure */
			pfcb = (struct jdfcb *)malloc(sizeof(struct jdfcb));
			if(pfcb == NULL) {
			  fsnkc_dbg("fs_nkc.c|nkcfs_open: ... ENOMEM(1) ]\n");
			  return ENOMEM;
     		}

     		/* ---------------------------------------- fill FCB structure (new file) ----------------------------- */
     		fsnkc_dbg("|nkcfs_open: fill fcb:\n");
     		/*------ standard ----- */
     		pfcb->lw = filp->p_fstab->partition + 5; 		/* = partition number + 5 for harddisk partitions  */

     		//strcpy(pfcb->filename,jdir.filename);
     		//strcpy(pfcb->fileext,jdir.fileext);
     		sprintf(pfcb->filename,"%-8s",jdir.filename); /* make shure 8 characters are used in FCB for backward compatibility with JADOS 3.5 */
     		sprintf(pfcb->fileext,"%-3s",jdir.fileext);    /* make shure 3 characters are used in FCB for backward compatibility with JADOS 3.5 */

     		fsnkc_dbg("    filename : '%s'\n",pfcb->filename);
     		fsnkc_dbg("    fileext  : '%s'\n",pfcb->fileext);

			pfcb->date = 0; /* FIXME */ 

			pfcb->length = 1; /* minimum file length */
			pfcb->endcluster = 0;		
			pfcb->endbyte = 0;
			pfcb->mode = 0xE5;

			pfcb->status = 1; /* 1=opened ! */
			/* allocate a transfer buffer of size min sectorsize */
			pfcb->pbuffer = malloc(BUFFER_SIZE);
			/*------ non standard ----- */
			pfcb->pos = 0;
			pfcb->crpos = 0;
			pfcb->crcluster = 0;
			pfcb->omode = omode;
			pfcb->eof = 0;
			/* ---- reserved fields ------*/
			pfcb->reserved01 = 0x00;
			pfcb->reserved02 = 0x00;
			pfcb->reserved03 = 0xE5E5;
			pfcb->reserved04 = 0xE5;

			/* pointer to related JADOS filesystem struct (type JDFS) */
			pfcb->pfs = (JDFS*)filp->p_fstab->pfs;

			res = alloc_new_file(pfcb); /* allocate space for file in FAT and DIR */

 			switch(res){
 				case FR_OK:
 					fsnkc_dbg("fs_nkc.c|alloc_new_file => OK ]\n");
 					break;
 				case FR_DISK_ERR:
 					fsnkc_dbg("fs_nkc.c|nkcfs_open: disk error ]\n");
 					free(pfcb->pbuffer);
				  	return EIO;
 					break;
 				case FR_DISKFULL:
 					fsnkc_dbg("fs_nkc.c|nkcfs_open: disk full ]\n");
 					free(pfcb->pbuffer);
				  	return ENOSPC;
 					break;
 				case FR_NOT_ENOUGH_CORE:
	 				fsnkc_dbg("fs_nkc.c|nkcfs_open: error opening file, not enough memory ]\n");
	 				free(pfcb->pbuffer);
				  	return ENOMEM;
				  	break;
				default:
					fsnkc_dbg("fs_nkc.c|nkcfs_open: unknown error opening file ]\n");
					free(pfcb->pbuffer);
				  	return EFAULT;
 			}

     	}
     	break;

     case EZERO: // file found on disk
       if((mode & FA_CREATE_NEW) ) { // cannot create new file, file already exists
       		fsnkc_dbg("fs_nkc.c: ... cannot create new file, file already exists ]\n");
       		return EEXIST;
     	}else {																	// open existing file
     		
     		if(mode & FA_READ) {     			
     			omode = 0xE4;
     		} else {
     			omode = 0xE5;
     		}
     		fsnkc_dbg("fs_nkc.c: ... opening file: omode = 0x%x\n",omode);
     		iread= 1;

     		if(omode > jdir.mode){
     		  fsnkc_dbg("fs_nkc.c: error, file is write protected !\n");
     		  return 	;
     		}
		    /* allocate FCB structure */
			pfcb = (struct jdfcb *)malloc(sizeof(struct jdfcb));
			if(pfcb == NULL) {
			  fsnkc_dbg("fs_nkc.c: ... nkcfs_open ENOMEM ]\n");
			  return ENOMEM;
			}
			fsnkc_dbg("fs_nkc.c: pfcb = 0x%x\n",pfcb);

			/* ---------------------------------------- fill FCB structure (existing file) ----------------------------- */
			pfcb->lw = filp->p_fstab->partition + 5; 		/* = partition number + 5 for harddisk partitions  */
			//strncpy(pfcb->filename,jdir.filename,8);		/* filename  										*/
			//strncpy(pfcb->fileext,jdir.fileext,3);			/* fileext 											*/
			sprintf(pfcb->filename,"%-8s",jdir.filename); /* make shure 8 characters are used in FCB for backward compatibility with JADOS 3.5 */
     		sprintf(pfcb->fileext,"%-3s",jdir.fileext);    /* make shure 3 characters are used in FCB for backward compatibility with JADOS 3.5 */
			pfcb->starttrack = jdir.starttrack;
			pfcb->endcluster = jdir.endcluster - JADOS_CLUSTER_OFFSET;
			pfcb->endbyte = jdir.endbyte;
			pfcb->date = jdir.date;
			pfcb->length = jdir.length;
			pfcb->mode = jdir.mode;
			pfcb->dirsec = ((dir.index-1)*sizeof(struct jddir))/CLUSTERSIZE + FAT_SIZE  + JADOS_CLUSTER_OFFSET ; /* 1st Cluster = 1 in JADOS ! => 1st DIR Cluster = 2 */
			pfcb->dirbyte = ((dir.index-1)*sizeof(struct jddir)) % CLUSTERSIZE;
			pfcb->status = 1; /* 1=opened ! */
			pfcb->curtrack = jdir.starttrack; /* current track */
			pfcb->curcluster = 0; /* current cluster in current track (track relative) */
			pfcb->lasttrack = 0; /* FIXME: '0' is wrong but doesn't matter here. Can be retreived cycling through FAT */
			/* allocate a transfer buffer of size min sectorsize */
			pfcb->pbuffer = malloc(BUFFER_SIZE);
			/*------ non standard ----- */
			pfcb->dir_index = dir.index-1;
			pfcb->pos = 0;
			pfcb->crpos = 0;
			pfcb->crcluster = 0;
			pfcb->omode = omode;
			pfcb->eof = 0;
			/* ---- reserved fields ------*/
			pfcb->reserved01 = 0x00;
			pfcb->reserved02 = 0x00;
			pfcb->reserved03 = 0xE5E5;
			pfcb->reserved04 = 0xE5;
			/* pointer to related JADOS filesystem struct (type JDFS) */
			pfcb->pfs = (JDFS*)filp->p_fstab->pfs;

		}
		break;

    default:
      fsnkc_dbg("fs_nkc.c: find_file returned unknown error code (%d) ]\n",res);
      return res;
	}


    filp->private = (void*)pfcb;

    if(iread){
	   fsnkc_dbg("fs_nkc.c|nkcfs_open: load first cluster to buffer ....\n");

	   dev.pdrv = pfcb->pfs->pfstab->pdrv; 			/* physical drive number 				*/
	   start_sector =     FCLUSTER + pfcb->pfs->id * PART_SIZE 	/* partition start cluster 		*/		                
						+ pfcb->curtrack * TRACK_SIZE		/* current track start cluster	*/
						+ pfcb->curcluster;					/* current cluster in track  	*/

		dres = pfcb->pfs->pfstab->pblkdrv->blk_oper->read( &dev,
												pfcb->pbuffer,
												pfcb->pfs->pjdhd->xoffset          /* start of extended partition */
												+ start_sector * pfcb->pfs->pjdhd->spc,		/* von cluster in sector umrechnen ! */
												pfcb->pfs->pjdhd->spc); 	                /* read complete cluster == sectors per cluster */

		/* positions in fcb need not be updated yet - they are updated by read/write operations from upper layers */												


	}


	fsnkc_dbg("fs_nkc.c: JADOS fcb:\n");
	fsnkc_dbg("             lw          : %d\n",pfcb->lw);
	fsnkc_dbg("             filename    : '%s'\n",pfcb->filename);
	fsnkc_dbg("             fileext     : '%s'\n",pfcb->fileext);
	fsnkc_dbg("             starttrack  : %d (=FAT index)\n",pfcb->starttrack);
	fsnkc_dbg("             endcluster  : %d\n",pfcb->endcluster);
	fsnkc_dbg("             endbyte     : %d\n",pfcb->endbyte);
	fsnkc_dbg("             date        : %d\n",pfcb->date);
	fsnkc_dbg("             length      : %d\n",pfcb->length);
	fsnkc_dbg("             mode        : 0x%02x\n",pfcb->mode);
	fsnkc_dbg("             dirsec      : %d (%d / %d) + %d + %d\n",pfcb->dirsec, (dir.index-1)*sizeof(struct jddir), CLUSTERSIZE, FAT_SIZE, JADOS_CLUSTER_OFFSET );
	fsnkc_dbg("             dirbyte     : %d\n",pfcb->dirbyte);
	fsnkc_dbg("             status      : %d\n",pfcb->status);
	fsnkc_dbg("             curtrack    : %d\n",pfcb->curtrack);
	fsnkc_dbg("             curcluster  : %d\n",pfcb->curcluster);
	fsnkc_dbg("             lasttrack   : %d\n",pfcb->lasttrack);
	fsnkc_dbg("             pbuffer     : 0x%08x\n",pfcb->pbuffer);
	fsnkc_dbg("             -------------\n");
	fsnkc_dbg("             dir-index   : %d\n",pfcb->dir_index);
	fsnkc_dbg("             pos         : %d\n",pfcb->pos);
	fsnkc_dbg("             crpos       : %d\n",pfcb->crpos);
	fsnkc_dbg("             crcluster   : %d\n",pfcb->crcluster);
	fsnkc_dbg("             eof         : %d\n",pfcb->eof);
	fsnkc_dbg("             JDFS        : 0x%08x\n",pfcb->pfs);

	fsnkc_dbg("... nkcfs_open ]\n");

	if(res < FRESULT_OFFSET && res != FR_OK)
	 return res + FRESULT_OFFSET;
	else return res;
}




/*
	close the file given in filp
	write back FAT and DIR if file was open for writing
*/
static int nkcfs_close(struct _file *filp)
{
	FRESULT result;
	DRESULT dresult;
	struct jdfcb *pfcb;
	struct jddir *pdir;
    struct fstabentry* pfstab;
    struct _dev dev;
    FATentry *pFAT;
    JDFS *pJDFs;
    struct jdhd *pJDHd;
    int dir_index, dir_cluster, sector;

	fsnkc_dbg("nkcfs_close...\n");


	dresult = RES_PARERR;
	//pfi = (struct jdfileinfo*)filp->private;
	pfcb = (struct jdfcb*)filp->private;

	fsnkc_dbg("nkcfs_close: file = %s.%s\n",pfcb->filename,pfcb->fileext);

	pfcb->endcluster += JADOS_CLUSTER_OFFSET;

    fsnkc_dbg(" nkcfs_close: pos        =%d\n",pfcb->pos);
    fsnkc_dbg(" nkcfs_close: crcluster  =%d\n",pfcb->crcluster);
	fsnkc_dbg(" nkcfs_close: crpos      =%d\n",pfcb->crpos);
	fsnkc_dbg(" nkcfs_close: curtrack   =%d\n",pfcb->curtrack);
	fsnkc_dbg(" nkcfs_close: curcluster =%d\n",pfcb->curcluster);
	fsnkc_dbg(" nkcfs_close: endcluster =%d\n",pfcb->endcluster);
	fsnkc_dbg(" nkcfs_close: lasttrack  =%d\n",pfcb->lasttrack);
	fsnkc_dbg(" nkcfs_close: length     =%d\n",pfcb->length);
	fsnkc_dbg(" nkcfs_close: eof        =%d\n",pfcb->eof);

	/* flush current sector, if mode = write and current cluster relative position is > 0*/

	if(pfcb->omode == 0xE5)
   	{

   	  	/* check if we have to adjust endcluster and file length */
		if(pfcb->crpos == 0){		/* current cluster relative position */
   			fsnkc_dbg(" nkcfs_close: no flush needed (crpos=0) .... \n");			
		}else{

	  		fsnkc_dbg(" nkcfs_close: flush current cluster (crpos=%d) .... \n",pfcb->crpos);
   	  		dresult = nkcfs_write_cluster(pfcb);   	  			   	 
   	  	}   	  
 			
 		fsnkc_dbg(" length = %d, endcluster=%d\n",pfcb->length,pfcb->endcluster);
		
		fsnkc_dbg(" nkcfs_close: update directory .... \n");
   		dresult = update_dir(pfcb);

   	  	/* write back FAT/DIR to media */
   	  	pfstab  = pfcb->pfs->pfstab;		/* pointer to file related fstab entry */
	  	dev.pdrv = pfstab->pdrv; 			/* physical drive number 				*/
   	  	pFAT = pfcb->pfs->pFAT;				/* pointer to volumes FAT */
   	  	pdir = pfcb->pfs->pDIR;				/* pointer to volumes DIR */
   	  	pJDFs = (JDFS *)pfstab->pfs;		/* pointer to JADOS file system object  */
   	  	pJDHd = pJDFs->pjdhd;				/* pointer to JADOS disc descriptor */

   	  	/* update FAT on media  */
	  	fsnkc_dbg("nkcfs_close| update FAT on media ... \n");
	  	dresult = pfstab->pblkdrv->blk_oper->write( &dev,pFAT,
	  											pJDHd->xoffset +                                /* start of extended partition */
												(FCLUSTER + pJDFs->id * PART_SIZE) * pJDFs->pjdhd->spc, /* start sector */
												FAT_SIZE * pJDFs->pjdhd->spc); 			/* number of sectors = FAT size in clusters * sectors per cluster */

	  	/* update DIR on media */
	  	fsnkc_dbg("nkcfs_close| update DIR on media ... \n");

	    /* write back complete DIR */
	  	dresult = pfstab->pblkdrv->blk_oper->write( &dev, pdir,
	  								pJDHd->xoffset
  								+	(
  									FCLUSTER     						/* start of first partition */
						      	+	pJDFs->id * PART_SIZE     			/* partitions start sector  */
  								+   FAT_SIZE							/* DIRs start sector     	*/
  								    )  * pJDHd->spc,			
  								
  									DIR_SIZE * pJDHd->spc);				/* DIR size in native sectors */

    } else {
      	fsnkc_dbg(" nkcfs_close: r/o no flush... \n");	

      	dresult = 0;
    }

    /* free buffers and handles*/
	free(pfcb->pbuffer);
	free(pfcb);

	fsnkc_dbg("nkcfs_close: last dresult = %d\n", dresult);
	fsnkc_lldbgwait("...nkcfs_close\n");

	if(dresult < FRESULT_OFFSET && dresult != RES_OK)
	  return dresult + DRESULT_OFFSET;
	else return dresult;
}


/****************************************************************************
 * Name: nkcfs_read
 *
 * Description:
 *   Read buflen bytes from file to buffer.
 *
 * Parameters:
 *   
 *
 * Return:
 *      number of bytes read or 
 *     -1 if error
 *
 ****************************************************************************/
static int nkcfs_read(struct _file *filp, char *buffer, int buflen)
{
    struct jdfcb *pfcb;
	UCHAR *pbuf;	// pointer to sector buffer
	UINT count = buflen;	// number of bytes to read
	UINT bp;		// buffer pointer
	UINT res;		// a result

	fsnkc_dbg("nkcfs_read...\n buflen: 0x%x\n",buflen);


	pfcb = (struct jdfcb *)filp->private; 	/* file control block */

	if(pfcb->eof) 								/* current file pointer at eof ? */
	{
		fsnkc_lldbgwait("...nkcfs_read eof (1)\n");
		return EZERO;
	}

	pbuf = pfcb->pbuffer;	// fetch buffer address

	fsnkc_dbg(" fcbbuf = 0x%x   ",(int)pbuf);
	fsnkc_dbg(" buf    = 0x%x \n",(int)buffer);

	bp = 0;

	while(count)
	{

		// copy bytes from current buffer
		for(;pfcb->crpos < CLUSTERSIZE && count > 0; pfcb->crpos++,pfcb->pos++,count--,bp++)
		{
			((UCHAR*)buffer)[bp] = pbuf[pfcb->crpos];
		}

		// read next cluster
		if(count)
		{
			fsnkc_dbg(" read next cluster\n");
			if (pfcb->crcluster+1 == pfcb->length)
			{
				fsnkc_lldbgwait("...nkcfs_read(EOF)\n");
				//pfcb->eof = 1; if we set eof here, the buffer will not be copied to upper layers !
				return EZERO;  // EOF (we just copied the last sector)
			}

			res = nkcfs_read_cluster(pfcb);			       // read next cluster

			switch(res)
			{
				case FR_OK:
					fsnkc_dbg("ok\n");
					break;						// no error
				case FR_EOF:
					fsnkc_dbg("EOF (bp=%d)\n",bp);
					pfcb->eof = 1;				// set eof flag
					count = 0;					// terminate while loop
				    break;						// EOF, we return EOF = 0 on next call
				case FR_NO_FILESYSTEM:
					fsnkc_dbg("FR_NO_FILESYSTEM\n");
					count = 0; 					// terminate while loop
					break;
				case FR_INVALID_PARAMETER:
					fsnkc_dbg("FR_INVALID_PARAMETER\n");
					count = 0; 					// terminate while loop
					break;
				default:
					count = 0; 					// terminate while loop
					fsnkc_dbg("unknown\n");
					fsnkc_lldbgwait("...jfread(3)\n");
					break;			// error reading device
			}
		}

	}

	fsnkc_lldbgwait("...nkcfs_read\n");
	return bp;
}




/****************************************************************************
 * Name: nkcfs_write
 *
 * Description:
 *   Write buflen bytes from buffer to file.
 *
 * Parameters:
 *   
 *
 * Return:
 *      number of bytes written or 
 *     -1 if error
 *
 ****************************************************************************/
static int  nkcfs_write(struct _file *filp, const char *buffer, int buflen)
{
	struct jdfcb *pfcb;
	int crpos;		// current relativ position in sector buffer
	int pos;		// current absolute position in file
	div_t dres;		// result of a DIV
	UCHAR *pbuf;		// pointer to sector buffer
	UINT bp;		// buffer pointer
	int count = buflen;	// number of bytes to write
	DRESULT res;		// a result


	char tbuf[2] = {0,0};
	int ii;


	fsnkc_dbg("nkcfs_write (count=%d)...\n",count);

	pfcb = (struct jdfcb *)filp->private; 	// get fileinfo

	pbuf = pfcb->pbuffer;					// fetch buffer address

	bp = NULL;

	res = RES_OK;	

	while(count)
	{
		
		// write current cluster to disk if buffer full
		if(pfcb->crpos == CLUSTERSIZE)
		{
			fsnkc_dbg("nkcfs_write: write cluster\n");			

			res = nkcfs_write_cluster(pfcb);	// write current cluster to disk an proceed to next cluster			

			switch(res)
			{
				case RES_OK:
					fsnkc_dbg("- sector written -\n");
					alloc_new_cluster(pfcb);
				 	break; 	// no error
				case RES_DISKFULL:
					fsnkc_lldbgwait("...nkcfs_write(disk full)\n");
					count = 0; 		// terminate while loop
					return EZERO;
					return ENOSPC; 	// No Space left on device
				case RES_ERROR:
					fsnkc_lldbgwait("...nkcfs_write(media access error)\n");
					count = 0; 		// terminate while loop
					return EZERO;				
					return EACCES; 	// media access errorhandling

			}			
		}

		// copy bytes to current buffer
		for(;pfcb->crpos < CLUSTERSIZE && count > 0; pfcb->crpos++,pfcb->pos++,count--,bp++)
		{
			pbuf[pfcb->crpos] = ((unsigned char*)buffer)[bp];		
		}		

		fsnkc_dbg("nkcfs_write:- copied buffer - (%d bytes)\n",bp);

	}

	fsnkc_lldbgwait("...nkcfs_write]\n");

	return bp;
}



/* FIXME not tested ! */
static int  nkcfs_seek(struct _file *filp, int offset, int whence)
{
	struct jdfcb *pfcb;
	div_t divresult;
	UCHAR res;
	int newpos;


	fsnkc_dbg("nkcfs_seek...\n");
	fsnkc_dbg(" offset: 0x%x  ",offset);
	fsnkc_dbg(" whence: 0x%x\n",whence);

	pfcb = (struct jdfcb *)filp->private; 	// get fileinfo

	switch(whence)
	{
		case 0:	// seek from start of file
			newpos = offset;
			break;
		case 1: // seek from current file position
			newpos = offset + pfcb->pos;
			break;
		case 2: // seek from end of file
			newpos = (int)(pfcb->length*(int)CLUSTERSIZE + offset - 1);
			break;
		default:
			newpos = offset;
			break;
	}

	divresult = div( newpos , (int)CLUSTERSIZE );

	if(divresult.quot < 0)
	{
		divresult.quot = 0;

		fsnkc_dbg(" error in seek: negativ file offset\n");
		fsnkc_lldbgwait("...nkcfs_seek\n");
		return;				// check for negativ fileoffset

	}

	if(divresult.quot > pfcb->length)
	{
		divresult.quot = pfcb->length - 1;
		pfcb->eof = 1;

		fsnkc_lldbgwait("...nkcfs_seek(2)\n");
		return;		// check for seek beyond filend
	}

	if(divresult.quot != pfcb->length) // did we seek into another sector ?
	{
		switch(res)
		{
			case 0: // successful
				res = nkcfs_read_cluster(pfcb);	// ... and read record to buffer

				switch(res)
				{
					case RES_OK:
						 break;				// no error
					case RES_EOF:  pfcb->eof = 1;		/* set eof flag			*/
						break;
					case RES_NOMEM:break; 			// end of user space (JADOS)
					default: break;			// error reading device
				}
				break;

			case 1: // EOF
				pfcb->eof = 1;	/* set eof flag	 */
				res = RES_EOF;
				break;

			case 0xFF: // access error
				fsnkc_lldbgwait("...nkcfs_seek(3)\n");
				res = RES_ERROR;
				return;

			default:
				 fsnkc_dbg(" should not be here (0x%x)!\n",res);
				 res = RES_ERROR;
				 break;
		}

	} 

	pfcb->pos 	= newpos;							/* absolute file position	    		0....				*/
	pfcb->crpos 	= (int)divresult.rem;			/* current relativ position (in cluster) 0...CLUSTERSIZE-1			*/
	pfcb->crcluster	= (int)(divresult.quot + 1); 	/* current (file)relative cluster   		1...65536			*/

	fsnkc_lldbgwait("...nkcfs_seek\n");

	if(res < FRESULT_OFFSET && res != RES_OK)
	  return res + DRESULT_OFFSET;
	else return res;
}



static int  nkcfs_remove(struct _file *filp)
{

	struct jdfcb *pfcb;
	int res, dir_index;
	struct jddir *pdir;
	struct fstabentry* pfstab;
    struct _dev dev;
    FATentry *FAT;
    JDFS *pJDFs;
    struct jdhd *pJDHd;
	unsigned short index,nexttrack,ii;
	DRESULT dresult = RES_PARERR;

	fsnkc_dbg("fs_nkc.c: nkcfs_remove...\n");

	filp->f_oflags = _F_READ;
	res=nkcfs_open(filp);
	
	fsnkc_dbg("fs_nkc.c: nkcfs_open return-code: %d\n",res);

	switch(res){	
		case FR_OK:		/* file is open now */
		case EEXIST:	/* file exists      */
			break;
		case ENOFILE: 	/* file does not exist */
		case EINVAL:	/* wrong parameter */
		case ENOMEM:	/* not enough memory */
		case EROFS: 	/* file is write protected */						
		default:		/* unknown error */ 
			//fsnkc_dbg("fs_nkc.c: nkcfs_remove: nkcfs_open returned with error %d ...\n",res);	
			return FR_INVALID_PARAMETER;
	}

	/* get all the pointers */
	pfcb = (struct jdfcb *)filp->private; 	

	FAT = pfcb->pfs->pFAT;				/* pointer to volumes FAT */
	pfstab  = pfcb->pfs->pfstab;		/* pointer to file related fstab entry */
	dev.pdrv = pfstab->pdrv; 			/* physical drive number 				*/	
	pJDFs = (JDFS *)pfstab->pfs;		/* pointer to JADOS file system object  */
	pJDHd = pJDFs->pjdhd;				/* pointer to JADOS disc descriptor */

	/* delete FAT entries */
	ii = 0;
	index = pfcb->curtrack;

	fsnkc_dbg("fs_nkc.c: nkcfs_remove: delete FAT entries, starttrack=%u...\n",index);	
	do{		
		nexttrack = FAT[index].successor;
		FAT[index].successor = 0xE5E5;
		FAT[index].ancestor = 0xE5E5;
		index = nexttrack;
		ii++;
	}while(index != 0xFFFF && index != 0xE5E5 && index < FAT_ENTRIES && ii < FAT_ENTRIES);

	if(ii == FAT_ENTRIES){
	 fsnkc_lldbg("fs_nkc.c: nkcfs_remove: error: overrun FAT index\n");
	 /* free buffers and handles*/
	 free(pfcb->pbuffer);
	 free(pfcb);
	 return FR_EOF;
	}
	
	/* delete DIR entry */
	dir_index = pfcb->dir_index;

	fsnkc_dbg("fs_nkc.c: nkcfs_remove: delete DIR entry, dir_index=%u ...\n", dir_index);

	pdir = pfcb->pfs->pDIR;
	pdir[dir_index].id = 0xFFFF; /* mark entry 'deleted' */


	/* write back FAT */
	
	fsnkc_dbg("fs_nkc.c: nkcfs_remove: write back FAT to media ...\n");


	fsnkc_dbg("fs_nkc.c: pfcb     => 0x%08x\n",pfcb);       // ok
	fsnkc_dbg("fs_nkc.c: pfs      => 0x%08x\n",pfcb->pfs);  // nok
	fsnkc_dbg("fs_nkc.c: pfstab   => 0x%08x\n",pfstab);     // nok ...
	fsnkc_dbg("fs_nkc.c: pblkdrv  => 0x%08x\n",pfstab->pblkdrv);
	fsnkc_dbg("fs_nkc.c: blk_oper => 0x%08x\n",pfstab->pblkdrv->blk_oper);
	fsnkc_dbg("fs_nkc.c: write    => 0x%08x\n",pfstab->pblkdrv->blk_oper->write);

	
	dresult = pfstab->pblkdrv->blk_oper->write( &dev, FAT,
												pJDHd->xoffset +                                /* start of extended partition */
												(FCLUSTER + pJDFs->id * PART_SIZE) * pJDFs->pjdhd->spc, /* start sector */
												FAT_SIZE * pJDFs->pjdhd->spc); 			/* number of sectors = FAT size in clusters * sectors per cluster */

		/* FIXME: switch for dresult */

	/* write back DIR */
	fsnkc_dbg("fs_nkc.c: nkcfs_remove: write back DIR to media ...\n");

	/* write back complete DIR */

	dresult = pfstab->pblkdrv->blk_oper->write( &dev, pdir,
											pJDFs->pjdhd->xoffset
										+	(
											FCLUSTER     						/* start of first partition */
								      	+	pJDFs->id * PART_SIZE     	/* partitions start sector  */
										+   FAT_SIZE							/* DIRs start sector     	*/
										    )  * pJDHd->spc,			
										
											DIR_SIZE * pJDHd->spc);				/* DIR size in native sectors */
		/* FIXME: switch for dresult */

	/* free ressources */
	fsnkc_dbg("fs_nkc.c: nkcfs_remove: free ressources ...\n");		

	/* free buffers and handles*/
	free(pfcb->pbuffer);
	free(pfcb);

	return FR_OK;
}


static int  nkcfs_getpos(struct _file *filp)
{
	struct jdfcb *pfcb;

	fsnkc_dbg("nkcfs_getpos...\n");

	pfcb = (struct jdfcb *)filp->private; 	// get fileinfo

	fsnkc_lldbgwait("...nkcfs_getpos\n");
	return pfcb->pos;

}


static int  nkcfs_rename(struct _file *filp, const char *oldrelpath, const char *newrelpath)
{

	struct _file *nfilp;
	DIR *pdir;
	struct jdfcb *pfcb;
	int res, dir_index;
	struct jddir *pjddir;
	struct jddir *pnjddir;
	struct fstabentry* pfstab;
    struct _dev dev;
    FATentry *FAT;
    JDFS *pJDFs;
    struct jdhd *pJDHd;
	unsigned short index,nexttrack,ii;
	DRESULT dresult = RES_PARERR;

	fsnkc_dbg("fs_nkc.c: nkcfs_rename...\n");

    /* ------------------- check old file ---------------------------------------- */
	res=nkcfs_open(filp);
	
	fsnkc_dbg("fs_nkc.c: nkcfs_open return-code: %d\n",res);

	switch(res){	
		case FR_OK:		/* file is open now */
		case EEXIST:	/* file exists      */
			break;
		case ENOFILE: 	/* file does not exist */
		case EINVAL:	/* wrong parameter */
		case ENOMEM:	/* not enough memory */
		case EROFS: 	/* file is write protected */						
		default:		/* unknown error */ 
			//fsnkc_dbg("fs_nkc.c: nkcfs_remove: nkcfs_open returned with error %d ...\n",res);	
			return FR_INVALID_PARAMETER;
	}

	/* get all the pointers */
	pfcb = (struct jdfcb *)filp->private; 	

	FAT = pfcb->pfs->pFAT;				/* pointer to volumes FAT */
	pfstab  = pfcb->pfs->pfstab;		/* pointer to file related fstab entry */
	dev.pdrv = pfstab->pdrv; 			/* physical drive number 				*/	
	pJDFs = (JDFS *)pfstab->pfs;		/* pointer to JADOS file system object  */
	pJDHd = pJDFs->pjdhd;				/* pointer to JADOS disc descriptor */
	
	dir_index = pfcb->dir_index;
	pjddir = pfcb->pfs->pDIR;


	/* ----------------------------- check if file with new name already exists ---------------------------------- */

	/*
		allocate all buffers
	*/
	nfilp = (struct _file *)malloc(sizeof(struct _file));
	pdir = (DIR *)malloc(sizeof(DIR));
	pnjddir = (struct jddir *)malloc(sizeof(struct jddir));
	
	if(!nfilp || !pdir || !pnjddir){
		/* free buffers and handles*/
		free(nfilp);
		free(pdir);
		free(pnjddir);
		free(pfcb->pbuffer);
		free(pfcb);
		return ENOMEM;
	}


	
	nfilp->p_fstab = pfstab; 
	nfilp->pname = newrelpath;
	nfilp->fd = 0;
	nfilp->f_pos = 0;
	nfilp->f_oflags = 0;
	
	if( find_file(nfilp,pdir,pnjddir) != ENOFILE){
		/* error file already exists or other error */
	
		/* free buffers and handles*/
		free(nfilp);
		free(pdir);
		free(pnjddir);
		free(pfcb->pbuffer);
		free(pfcb);
		return EEXIST;
	}

	/* ------------------------------ change entry -------------------------------- */
	fsnkc_dbg("fs_nkc.c: nkcfs_rename: change DIR entry, dir_index=%u ...\n", dir_index);

	fsnkc_dbg("fs_nkc.c: nkcfs_rename: oldname: <%s>.<%s>  newname: <%s>.<%s>\n", pjddir[dir_index].filename,pjddir[dir_index].fileext,
																				  pnjddir->filename,pnjddir->fileext	);

	pjddir[dir_index].id = 0x00;
	memcpy(pjddir[dir_index].filename,pnjddir->filename,8);
    memcpy(pjddir[dir_index].fileext,pnjddir->fileext,3);

	/* free buffers and handles*/
	free(nfilp);
	free(pdir);
	free(pnjddir);
	free(pfcb->pbuffer);
	free(pfcb);

	//return FR_OK;

	/* write back DIR */
	fsnkc_dbg("fs_nkc.c: nkcfs_rename: write back DIR to media ...\n");

	/* write back complete DIR */

	dresult = pfstab->pblkdrv->blk_oper->write( &dev, pjddir,
											pJDHd->xoffset
										+	(
											FCLUSTER     						/* start of first partition */
								      	+	pJDFs->id * PART_SIZE     			/* partitions start sector  */
										+   FAT_SIZE							/* DIRs start sector     	*/
										    )  * pJDHd->spc,			
										
											DIR_SIZE * pJDHd->spc);				/* DIR size in native sectors */
		/* FIXME: switch for dresult */

	/* free ressources */
	fsnkc_dbg("fs_nkc.c: nkcfs_rename: free ressources ...\n");		

	/* free buffers and handles*/
	free(nfilp);
	free(pdir);
	free(pnjddir);
	free(pfcb->pbuffer);
	free(pfcb);

	return FR_OK;
}


void nkcfs_init_fs(void)
{
	fsnkc_dbg("nkcfs_init_fs...\n");

	register_driver("JDFS",&nkc_file_operations); 	// general driver for a JADOS filesystem
	
	pJDHDtable = NULL;

	// allocate some memory ...
	FPInfo.psz_driveName = (char*)malloc(_MAX_DRIVE_NAME); if(FPInfo.psz_driveName == 0) exit(ENOMEM); // exit with fatal error !!
	FPInfo.psz_deviceID = (char*)malloc(_MAX_DEVICE_ID);   if(FPInfo.psz_deviceID == 0) exit(ENOMEM);
	FPInfo.psz_path = (char*)malloc(_MAX_PATH); if(FPInfo.psz_path == 0) exit(ENOMEM);
	FPInfo.psz_filename = (char*)malloc(_MAX_FILENAME); if(FPInfo.psz_filename ==0 ) exit(ENOMEM);
	FPInfo.psz_fileext = (char*)malloc(_MAX_FILEEXT); if(FPInfo.psz_fileext == 0 ) exit(ENOMEM);
	FPInfo.psz_cdrive = (char*)malloc(_MAX_DRIVE_NAME); if(FPInfo.psz_cdrive == 0 ) exit(ENOMEM);
	FPInfo.psz_cpath = (char*)malloc(_MAX_PATH); if(FPInfo.psz_cpath == 0 ) exit(ENOMEM);

	fsnkc_dbg(" Address of open: 0x%x\n",(int)nkcfs_open);
	fsnkc_dbg(" Address of nkc_file_operations: 0x%x\n",(int)&nkc_file_operations);
	fsnkc_dbg(" Address of ...->open: 0x%x\n",(int)nkc_file_operations.open);
	fsnkc_lldbgwait("...nkcfs_init_fs\n");

}


// returns EZERO if successful, ENOMEM otherwise
static int add_sectors_to_list(struct slist **p, unsigned int start, unsigned int n){
	struct slist *next, *list;
	unsigned int sec;
	unsigned int nn;

	fsnkc_dbg(" add_sectors_to_list: p->0x%08x, slist->0x%08x, start=%d, n=%d\n",p,*p,start,n);

	if(start == 0) return EINVDAT;
	if(n < 1) return EINVDAT;

	list = *p;
	sec = start;
	nn = n;

	if(list==NULL){
		fsnkc_dbg(" add_sectors_to_list: 1st element -> start list\n");
		list=malloc(sizeof(struct slist));
		if(list==NULL) return ENOMEM;
		fsnkc_dbg(" add_sectors_to_list: memory for struct slist allocated\n");
		list->s = sec;
		list->next=NULL;
		sec++;
		nn--;
		*p = list;
	}else{
		while(list->next) list=list->next;
	}
	/* list now point's to last element of p */

	/* add rest to list */
	for(; nn>0;nn--,sec++){
		fsnkc_dbg(" add_sectors_to_list: add %d, remain %d\n",sec,nn);
		next=malloc(sizeof(struct slist));
		if(next==NULL) return ENOMEM;
		next->s = sec;
		next->next = NULL;
		list->next = next;
		list = next;
	}

	fsnkc_dbg(" add_sectors_to_list: ready !\n");

	return EZERO;
}

static struct slist* nkcfs_get_slist(struct _file *filp) {
	FRESULT res;
	unsigned short track,length;
	FATentry *FAT;
	DIR dir;					/* Directory object 		*/
	struct jddir jdir;			/* JADOS Directory entry 	*/
	struct slist *pslist=NULL; 	/* sector list */
	
	fsnkc_dbg(" nkcfs_get_slist: (%s) (0x%08x)\n",filp->pname,filp->p_fstab);

	res = find_file(filp,&dir,&jdir); /* fetch file information */

	if(res != EZERO){ // file not found on disk
	 fsnkc_dbg(" nkcfs_get_slist:  file not found\n");
	 return NULL;
	}	  

	fsnkc_dbg(" nkcfs_get_slist: ok, file found - now analyzing\n");
	// file starts at jdir.starttrack  10 culsters per track, 1 cluster = 1024 Bytes = 2 sectors => 1 track = 20 sectors
	// last cluster in last track (-> FAT) ist jddir.endcluster
	// file length is jddir.length in clusters

	fsnkc_dbg(" nkcfs_get_slist: starttrack = %d, endcluster = %d, length = %d\n",jdir.starttrack,jdir.endcluster,jdir.length);

	// follow FAT entries
	FAT = ((JDFS*)filp->p_fstab->pfs)->pFAT;
	length = jdir.length; 
	track = jdir.starttrack;  

	while(track != 0xFFFF && track != 0xE5E5){
	    // => append 10 clusters = 20 sectors to sector list
	    fsnkc_dbg(" nkcfs_get_slist: current track = %d\n",track);

	    if(length >= TRACK_SIZE){
	    	// add full track
	    	fsnkc_dbg(" nkcfs_get_slist: add full track (length = %d) ...\n",length);
	    	if(add_sectors_to_list(&pslist, track * TRACK_SIZE * CLUSTERSIZE/512, TRACK_SIZE * CLUSTERSIZE/512) != EZERO){
	    	// free aready allocated memory and return error
	    	}
	    	length -= TRACK_SIZE;
	    }else{
	    	// this is probably the last track
	    	fsnkc_dbg(" nkcfs_get_slist: add last tracks (length = %d) ...\n",length);
	    	// we could doublecheck this: FAT[track].successor should be 0xFFFF od 0xE5E5
		    if(add_sectors_to_list(&pslist, track * TRACK_SIZE * CLUSTERSIZE/512, length * CLUSTERSIZE/512) != EZERO){
		    	// free aready allocated memory and return error
		    }
		    length = 0;
		}
	    	
		track = FAT[track].successor;		
	}


	fsnkc_dbg(" nkcfs_get_slist: ok, returning list at 0x%08x\n",pslist);
	return pslist;
}