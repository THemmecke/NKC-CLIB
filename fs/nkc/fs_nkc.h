#ifndef __JDFS_H
#define __JDFS_H

#include <types.h>

#include "../../nkc/llnkc.h"

#define BUFFER_SIZE 1024
#define SECSIZE 1024
	

struct jdfileinfo {
	struct jdfcb *pfcb;	/* pointer to JADOS File Control Block					*/		
	int pos;		/* file position	    		0....				*/	
	int crpos;		/* current relativ position (in sector) 0...SECSIZE-1			*/
	int clsec;		/* current logical sector   		1...65536			*/
				/* jdfcb.length = length in sectors 					*/
	unsigned char eof;	/* pos is at end of file 						*/
};

struct pathinfo {
	char 	filename[9];
	char 	fileext[4];
	char	drive[2];	
};

#ifdef CONFIG_FS_NKC
extern unsigned char _DRIVE; // drive where this program was started (startup/startXX.S)
#endif

/*  -------------------------- JADOS FUNKTIONEN ------------------------------- 
 * 
 *          Prototypen um JADOS Funktionen später zu ersetzen
 * 
 */ 

/*
 UCHAR jd_fillfcb(struct jdfcb *FCB,char *name)
 returns 0 if successful
*/	
///UCHAR jd_fillfcb(struct jdfcb *FCB,char *name);

/*
 UCHAR jd_open(struct jdfcb *FCB)
 returns 0 if successful
*/	
//UCHAR jd_open(struct jdfcb *FCB);
	
/*
 UCHAR jd_create(struct jdfcb *FCB)
 returns 0 if successful
*/	
//UCHAR jd_create(struct jdfcb *FCB);
/*
 void jd_close(struct jdfcb *FCB)
*/	
//void jd_close(struct jdfcb *FCB);
	
/*
 UCHAR jd_erase(struct jdfcb *FCB)
 
 result	Bedeutung
		0	Datei gelöscht
		2	Datei nicht vorhanden
		0xff	Fehler beim Zugriff auf den Massenspeicher
		
		Achtung: falls die Datei schon existiert, wird sie lediglich geöffnet !
*/	
//UCHAR jd_erase(struct jdfcb *FCB);

/*
 UCHAR jd_readrec(struct jdfcb *FCB)
 returns 	   0 - if successful
 		   1 - EOF
 		  99 - end of memory
 		0xFF - access error 
*/
//UCHAR jd_readrec(struct jdfcb *FCB);
 	
/*
 UCHAR jd_writerec(struct jdfcb *FCB)
 returns 	   0 - if successful
 		   5 - disk full
 		0xFF - access error 
*/	
 //UCHAR jd_writerec(struct jdfcb *FCB);
 
/*
 UCHAR jd_setrec(struct jdfcb *FCB, int sector)
 returns 	   0 - if successful
 		   1 - EOF
 		0xFF - access error 
*/	
//UCHAR jd_setrec(struct jdfcb *FCB, int sector);

/*
 void jd_setdta(struct jdfcb *FCB, void* buffer)
*/	
//void jd_setdta(struct jdfcb *FCB, void* buffer);
/*
void jd_showsp()
*/
//void jd_showsp();



/*********************/


/* Private Prototypes */


static DRESULT read_sector(struct jdfileinfo *pfi);
static DRESULT write_sector(struct jdfileinfo *pfi);


FRESULT nkcfs_opendir (
  DIR* dp,           /* [OUT] Pointer to the directory object structure */
  const TCHAR* path  /* [IN] Directory name */
);

FRESULT nkcfs_closedir (
  DIR* dp     /* [IN] Pointer to the directory object */
);

FRESULT nkcfs_readdir (
  DIR* dp,      /* [IN] Directory object */
  FILINFO* fno  /* [OUT] File information structure */
);


/* Public Prototypes */

static int     nkcfs_ioctl(struct _file *filp, int cmd, unsigned long arg);
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
