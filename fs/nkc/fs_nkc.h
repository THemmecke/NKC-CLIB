#ifndef __JDFS_H
#define __JDFS_H

#define NULL 0
#define UCHAR unsigned char 
#define UINT unsigned int

#define BUFFER_SIZE 1024
#define SECSIZE 1024
	
/* FCB */

struct jdfcb {
	unsigned short 	lw;		/* 00..01 */
	char 		filename[8];	/* 02..09 */
	unsigned short 	reserverd01;	/* 10..11 */
	char 		fileext[3];	/* 12..14 */
	unsigned char 	reserved02;	/* 15 	  */
	unsigned short 	starttrack;	/* 16..17 */ // Nummer des ersten Track
	unsigned short 	endsec;		/* 18..19 */ // Nummer des letzten Sektors im letzten Track (Track-relativ ! 10 sectors/track bei HD und 5 sec/track bei FD))
	unsigned short 	endbyte;	/* 20..21 */ // immer 0
	unsigned int	date;		/* 22..25 */
	unsigned short 	length;		/* 26..27 */ // L..nge in Sektoren
	unsigned char 	mode;		/* 28     */ // 0xE4 read only, 0xE5 read/write (wird von Jados nicht korrekt gesetzt (immer E5)!!)
	unsigned short 	reserved03;	/* 29..30 */
	unsigned char   reserved04;	/* 31     */
	unsigned short  dirsec;		/* 32..33 */
	unsigned short  dirbyte;	/* 34..35 */
	unsigned short  status;		/* 36..37 */
	unsigned short  curtrack;	/* 38..39 */ // aktueller Track (Track-Relativ !)
	unsigned short  cursec;		/* 40..41 */ // aktueller Sector innerhalb des Tracks
	unsigned short  lasttrack;	/* 42..43 */ // letzter Track
	unsigned char   *pbuffer;	/* 44..47 */	
} __attribute__ ((packed));				/* otherwise datafields would be aligned ... */

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

extern unsigned char _DRIVE; // drive where this program was started (startup/startXX.S)

/*  -------------------------- JADOS FUNKTIONEN ------------------------------- */ 	
/*
 UCHAR jd_fillfcb(struct jdfcb *FCB,char *name)
 returns 0 if successful
*/	
UCHAR jd_fillfcb(struct jdfcb *FCB,char *name);

/*
 UCHAR jd_open(struct jdfcb *FCB)
 returns 0 if successful
*/	
UCHAR jd_open(struct jdfcb *FCB);
	
/*
 UCHAR jd_create(struct jdfcb *FCB)
 returns 0 if successful
*/	
UCHAR jd_create(struct jdfcb *FCB);
/*
 void jd_close(struct jdfcb *FCB)
*/	
void jd_close(struct jdfcb *FCB);
	
/*
 UCHAR jd_erase(struct jdfcb *FCB)
 
 result	Bedeutung
		0	Datei gelöscht
		2	Datei nicht vorhanden
		0xff	Fehler beim Zugriff auf den Massenspeicher
		
		Achtung: falls die Datei schon existiert, wird sie lediglich geöffnet !
*/	
UCHAR jd_erase(struct jdfcb *FCB);

/*
 UCHAR jd_readrec(struct jdfcb *FCB)
 returns 	   0 - if successful
 		   1 - EOF
 		  99 - end of memory
 		0xFF - access error 
*/
UCHAR jd_readrec(struct jdfcb *FCB);
 	
/*
 UCHAR jd_writerec(struct jdfcb *FCB)
 returns 	   0 - if successful
 		   5 - disk full
 		0xFF - access error 
*/	
 UCHAR jd_writerec(struct jdfcb *FCB);
 
/*
 UCHAR jd_setrec(struct jdfcb *FCB, int sector)
 returns 	   0 - if successful
 		   1 - EOF
 		0xFF - access error 
*/	
UCHAR jd_setrec(struct jdfcb *FCB, int sector);

/*
 void jd_setdta(struct jdfcb *FCB, void* buffer)
*/	
void jd_setdta(struct jdfcb *FCB, void* buffer);
/*
void jd_showsp()
*/
void jd_showsp();



/*********************/


/* Private Prototypes */
int _nkc_remove(char *name);
int _nkc_rename(const char *oldrelpath, const char *newrelpath);
int _nkc_get_drive();
void _nkc_set_drive(int drive);
void _nkc_split_path(char *name, struct pathinfo* ppi);


UINT read_sector(struct jdfileinfo *pfi);
UINT write_sector(struct jdfileinfo *pfi);

/* Public Prototypes */

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
