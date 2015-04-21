/*------------------------------------------------------------------------/
/  The Main Development Bench of FatFs Module
/-------------------------------------------------------------------------/
/
/  Copyright (C) 2013, ChaN, all right reserved.
/
/ * This software is a free software and there is NO WARRANTY.
/ * No restriction on use. You can use, modify and redistribute it for
/   personal, non-profit or commercial products UNDER YOUR RESPONSIBILITY.
/ * Redistributions of source code must retain the above copyright notice.
/
/-------------------------------------------------------------------------*/


#include <string.h>
#include <stdarg.h>
#include <stdio.h>
#include <locale.h>
#include <time.h>
#include "diskio.h"
#include "ff.h"
#include "debug.h"

#include "gide.h"

#include "shell.h"



#if _MULTI_PARTITION	/* Volume - partition resolution table (Example) */
PARTITION VolToPart[] = {
	{0, 1},	/* "0:" <== Disk# 0, 1st partition */
	{0, 2},	/* "1:" <== Disk# 0, 2nd partition */
	{0, 3},	/* "2:" <== Disk# 0, 3rd partition */
	{0, 4}	/* "3:" <== Disk# 0, 4th partition */
//	{3, 1},	/* "3:" <== Disk# 3, 1st partition */
//	{3, 2},	/* "4:" <== Disk# 3, 2nd partition */
//	{3, 3},	/* "5:" <== Disk# 3, 3rd partition */
//	{4, 0},	/* "6:" <== Disk# 4, auto detect */
//	{5, 0}	/* "7:" <== Disk# 5, auto detect */
};
#endif


/*---------------------------------------------------------*/
/* Work Area                                               */
/*---------------------------------------------------------*/


LONGLONG AccSize;			/* Work register for scan_files() */
WORD AccFiles, AccDirs;
FILINFO Finfo;
#if _USE_LFN
char LFName[256];
#endif

char Line[300];			/* Console input/output buffer */
HANDLE hCon, hKey;

FATFS FatFs[_VOLUMES];		/* File system object for logical drive */
BYTE Buff[262144];			/* Working buffer */

#if _USE_FASTSEEK
DWORD SeekTbl[16];			/* Link map table for fast seek feature */
#endif


/*---------------------------------------------------------*/
/* User Provided RTC Function for FatFs module             */
/*---------------------------------------------------------*/
/* This is a real time clock service to be called from     */
/* FatFs module. Any valid time must be returned even if   */
/* the system does not support an RTC.                     */
/* This function is not required in read-only cfg.         */

struct tm *tmnow;

DWORD get_fattime (void)
{
	time_t tnow;

	/* Get local time */
	time(&tnow);
    tmnow = localtime(&tnow);

	/* Pack date and time into a DWORD variable */
	return 	  ((DWORD)(tmnow->tm_year - 1980) << 25)
			| ((DWORD)tmnow->tm_mon << 21)
			| ((DWORD)tmnow->tm_mday << 16)
			| (WORD)(tmnow->tm_hour << 11)
			| (WORD)(tmnow->tm_min << 5)
			| (WORD)(tmnow->tm_sec >> 1);
}



/*--------------------------------------------------------------------------*/
/* Monitor                                                                  */

/*----------------------------------------------*/
/* Get a value of the string                    */
/*----------------------------------------------*/
/*	"123 -5   0x3ff 0b1111 0377  w "
	    ^                           1st call returns 123 and next ptr
	       ^                        2nd call returns -5 and next ptr
                   ^                3rd call returns 1023 and next ptr
                          ^         4th call returns 15 and next ptr
                               ^    5th call returns 255 and next ptr
                                  ^ 6th call fails and returns 0
*/

int xatoi (			/* 0:Failed, 1:Successful */
	char **str,	/* Pointer to pointer to the string */
	long *res		/* Pointer to a valiable to store the value */
)
{
	unsigned long val;
	unsigned char r, s = 0;
	char c;


	*res = 0;
	while ((c = **str) == ' ') (*str)++;	/* Skip leading spaces */

	if (c == '-') {		/* negative? */
		s = 1;
		c = *(++(*str));
	}

	if (c == '0') {
		c = *(++(*str));
		switch (c) {
		case 'x':		/* hexdecimal */
			r = 16; c = *(++(*str));
			break;
		case 'b':		/* binary */
			r = 2; c = *(++(*str));
			break;
		default:
			if (c <= ' ') return 1;	/* single zero */
			if (c < '0' || c > '9') return 0;	/* invalid char */
			r = 8;		/* octal */
		}
	} else {
		if (c < '0' || c > '9') return 0;	/* EOL or invalid char */
		r = 10;			/* decimal */
	}

	val = 0;
	while (c > ' ') {
		if (c >= 'a') c -= 0x20;
		c -= '0';
		if (c >= 17) {
			c -= 7;
			if (c <= 9) return 0;	/* invalid char */
		}
		if (c >= r) return 0;		/* invalid char for current radix */
		val = val * r + c;
		c = *(++(*str));
	}
	if (s) val = 0 - val;			/* apply sign if needed */

	*res = val;
	return 1;
}


/*----------------------------------------------*/
/* Dump a block of byte array                   */

void put_dump (
	const unsigned char* buff,	/* Pointer to the byte array to be dumped */
	unsigned long addr,			/* Heading address value */
	int cnt						/* Number of bytes to be dumped */
)
{
	int i;


	printf("%08lX:", addr);

	for (i = 0; i < cnt; i++)
		printf(" %02X", buff[i]);

	putchar(' ');
	for (i = 0; i < cnt; i++)
		putchar((char)((buff[i] >= ' ' && buff[i] <= '~') ? buff[i] : '.'));

	putchar('\n');
}



FRESULT scan_files (
	char* path		/* Pointer to the path name working buffer */
)
{
	DIR dir;
	FRESULT res;
	int i;
	char *fn;

	#ifdef NKC_DEBUG
	nkc_write(" scan_files...\n");
	#endif
	
	if ((res = f_opendir(&dir, path)) == FR_OK) {
		i = strlen(path);
		while (((res = f_readdir(&dir, &Finfo)) == FR_OK) && Finfo.fname[0]) {
			if (_FS_RPATH && Finfo.fname[0] == '.') continue;
#if _USE_LFN
			fn = *Finfo.lfname ? Finfo.lfname : Finfo.fname;
#else
			fn = Finfo.fname;
#endif
			if (Finfo.fattrib & AM_DIR) {
				AccDirs++;
				*(path+i) = '/'; strcpy(path+i+1, fn);
				res = scan_files(path);
				*(path+i) = '\0';
				if (res != FR_OK) break;
			} else {
//				printf("%s/%s\n", path, fn);
				AccFiles++;
				AccSize += Finfo.fsize;
			}
		}
		f_closedir(&dir);
	}

	return res;
}



void put_rc (FRESULT rc)
{
	const char *p =
		"OK\0DISK_ERR\0INT_ERR\0NOT_READY\0NO_FILE\0NO_PATH\0INVALID_NAME\0"
		"DENIED\0EXIST\0INVALID_OBJECT\0WRITE_PROTECTED\0INVALID_DRIVE\0"
		"NOT_ENABLED\0NO_FILE_SYSTEM\0MKFS_ABORTED\0TIMEOUT\0LOCKED\0"
		"NOT_ENOUGH_CORE\0TOO_MANY_OPEN_FILES\0";
	FRESULT i;

	for (i = 0; i != rc && *p; i++) {
		while(*p++) ;
	}
	printf("rc=%u FR_%s\n", (UINT)rc, p);
}



const char HelpStrPage1[] = {
		"[Disk controls]\n"
		" di <pd#> - Initialize disk\n"
		" dd [<pd#> <sect>] - Dump a secrtor\n"
		" ds <pd#> - Show disk status\n"
		"[Buffer contorls]\n"
		" bd <ofs> - Dump working buffer\n"
		" be <ofs> [<data>] ... - Edit working buffer\n"
		" br <pd#> <sect> <count> - Read disk into working buffer\n"
		" bw <pd#> <sect> <count> - Write working buffer into disk\n"
		" bf <val> - Fill working buffer\n"
		};
const char HelpStrPage2[] = {		
		"[File system contorls]\n"
		" fi <ld#> [<mount>] - Force initialized the volume\n"
		" fs [<path>] - Show volume status\n"
		" fl [<path>] - Show a directory\n"
		" fo <mode> <file> - Open a file\n"
		" fc - Close the file\n"
		" fe <ofs> - Move fp in normal seek\n"
		" fE <ofs> - Move fp in fast seek or Create link table\n"
		" fd <len> - Read and dump the file\n"
		" fr <len> - Read the file\n"
		" fw <len> <val> - Write to the file\n"
		" fn <object name> <new name> - Rename an object\n"
		" fu <object name> - Unlink an object\n"
		};
const char HelpStrPage3[] = {		
		" fv - Truncate the file at current fp\n"
		" fk <dir name> - Create a directory\n"
		" fa <atrr> <mask> <object name> - Change object attribute\n"
		" ft <year> <month> <day> <hour> <min> <sec> <object name> - Change timestamp of an object\n"
	};
	
const char HelpStrPage4[] = {		
		" fx <src file> <dst file> - Copy a file\n"
		" fg <path> - Change current directory\n"
		" fj <path> - Change current drive\n"
		" fq - Show current directory path\n"
		" fb <name> - Set volume label\n"
		" fm <ld#> <rule> <cluster size> - Create file system\n"
		" fp <pd#> <p1 size> <p2 size> <p3 size> <p4 size> - Divide physical drive\n"
		"\n"
	};



void get_uni (
	char* buf,
	UINT len
)
{
	UINT i = 0;

	for (;;) {		
		buf[i]=nkc_getchar();
		if (buf[i] == 8) {
			if (i) i--;
			continue;
		}
		if (buf[i] == 13) {
			buf[i] = 0;
			break;
		}
		if ((UINT)buf[i] >= ' ' && i < len - 1) i++;
	}
}


void put_uni (
	char* buf
)
{

	nkc_write(buf);

}




/*-----------------------------------------------------------------------*/
/* Main                                                                  */


int main (int argc, char *argv[])
{
	char *ptr, *ptr2, pool[50];
	long p1, p2, p3;
	BYTE *buf;
	UINT s1, s2, cnt;
	WORD w;
	DWORD dw, ofs = 0, sect = 0, drv = 0;
	static const BYTE ft[] = {0, 12, 16, 32};
	FRESULT res;
	FATFS *fs;				/* Pointer to file system object */
	DIR dir;				/* Directory object */
	FIL file[2];			/* File objects */
	
	struct _deviceinfo di;

/*
  dw = 0x11223344;
  w = 0x1122;
  
  printf(" LD_DWORD: dw = 0x%x, 0x%x (big endian)\n", dw, LD_DWORD(&dw));
  printf(" LD_WORD: w = 0x%x, 0x%x (big endian)\n", w, LD_WORD(&w));
  
  ST_WORD(&w,0x1020);
  ST_DWORD(&dw,0x10203040);
  
  printf(" LD_DWORD: dw = 0x%x, 0x%x (big endian)\n", dw, LD_DWORD(&dw));
  printf(" LD_WORD: w = 0x%x, 0x%x (big endian)\n", w, LD_WORD(&w));

	getchar();
*/	
	printf("FatFs module test monitor (%s, CP:%u/%s)\n\n",
			_USE_LFN ? "LFN" : "SFN",
			_CODE_PAGE,
			_LFN_UNICODE ? "Unicode" : "ANSI");

	init_ff();
	
#if _MULTI_PARTITION
	printf("\nMultiple partition feature is enabled. Each logical drive is tied to the patition as follows:\n");
	for (cnt = 0; cnt < sizeof VolToPart / sizeof (PARTITION); cnt++) {
		const char *pn[] = {"auto detect", "1st partition", "2nd partition", "3rd partition", "4th partition"};

		printf("\"%u:\" <== Disk# %u, %s\n", cnt, VolToPart[cnt].pd, pn[VolToPart[cnt].pt]);
	}
	printf("\n");	
#else
	printf("\nMultiple partition feature is disabled.\nEach logical drive is tied to the same physical drive number.\n\n");
#endif

#if _USE_LFN
	Finfo.lfname = LFName;
	Finfo.lfsize = sizeof LFName;
#endif

       
        shell(); // call the shell ....
        
        return 0;
        
        
        
        // original program .........
        
	for (;;) {
		printf(">");
		gets(ptr = Line);
		//get_uni(Line, sizeof Line / sizeof Line[0]);
		//ptr = Line;

		switch (*ptr++) {	/* Branch by primary command character */

		case 'q' :	/* Exit program */
			return 0;

		case '?':		/* Show usage */
			printf(HelpStrPage1); printf(" ----- KEY -----"); getchar(); printf("\n");			
			printf(HelpStrPage2); printf(" ----- KEY -----"); getchar(); printf("\n");			
			printf(HelpStrPage3); printf(" ----- KEY -----"); getchar(); printf("\n");
			printf(HelpStrPage4);			
			break;

		case 'T' :
			while (*ptr == ' ') ptr++;

			/* Quick test space (OK) */
			
			res = idetifyIDE(1, &di);
			
			printf(" Model       : %s\n",di.modelnum);
			printf(" Serial      : %d\n",di.serial);
			printf("   Cylinders      : %u\n",di.cylinders);
			printf("   Cylinders (CL) : %u\n",di.ccylinder);
			printf("   Heads          : %u\n",di.heads);
			printf("   Heads (CL)     : %u\n",di.cheads);
			printf("   Sectors/Card   : %lu\n",di.spcard);
			printf("   Sectors (CL)   : %lu\n",di.ccinsect);
			printf("   LBA-Sectors    : %lu\n",di.lbasec);
			printf("   Tracks         : %u\n",di.csptrack);
			printf("   Sec/Track      : %u\n",di.sptrack);
			printf("   Sec/Track (CL) : %u\n",di.csptrack);
			printf("   Bytes/Track    : %u\n",di.bptrack);
			printf("   Bytes/Sector   : %u\n",di.bpsec);
			printf("   Capabilities   : 0x%0X\n",di.cap);
		
			printf("\n     Result = %d\n",res);
			break;

		case 'd' :	/* Disk I/O command */
			switch (*ptr++) {	/* Branch by secondary command character */
			case 'd' :	/* dd [<pd#> <sect>] - Dump a secrtor (OK)*/
				if (!xatoi(&ptr, &p1)) {
					p1 = drv; p2 = sect;
				} else {
					if (!xatoi(&ptr, &p2)) break;
				}
				res = disk_read((BYTE)p1, Buff, p2, 1);
				if (res) { printf("rc=%d\n", (WORD)res); break; }
				printf("Drive:%u Sector:%lu\n", p1, p2);
				if (disk_ioctl((BYTE)p1, GET_SECTOR_SIZE, &w) != RES_OK) break;
				sect = p2 + 1; drv = p1;
				for (buf = Buff, ofs = 0; ofs < w; buf += 16, ofs += 16)
				{
					put_dump(buf, ofs, 16);
					if(!(ofs % 160) && ofs != 0)
					{
						printf(" ---- KEY ---- "); getchar(); printf("\n");
					}
				}
				break;

			case 'i' :	/* di <pd#> - Initialize physical drive (OK)*/
				if (!xatoi(&ptr, &p1)) break;
				
				printf(" Initialize drive %d\n",(BYTE)p1); getchar();
				
				res = disk_initialize((BYTE)p1);
				printf("rc=%d\n", res); getchar();
				
				if (disk_ioctl((BYTE)p1, GET_SECTOR_SIZE, &w) == RES_OK)
					printf("Sector size = %u\n", w);
				if (disk_ioctl((BYTE)p1, GET_SECTOR_COUNT, &dw) == RES_OK)
					printf("Number of sectors = %u\n", dw);
					
				//getchar();	
				break;
			case 's' :	/* ds <pd#> - Show disk status (OK) */
				if (!xatoi(&ptr, &p1)) break;
					
				
				if (!FatFs[p1].fs_type) { printf("Not mounted.\n"); break; }
				printf("FAT type = %u\nBytes/Cluster = %lu\n"
						"Root DIR entries = %u\nNumber of clusters = %lu\n"
						"FAT start (lba) = %lu\nDIR start (lba,clustor) = %lu\nData start (lba) = %lu\n\n",
						(BYTE)FatFs[p1].fs_type,
						(DWORD)FatFs[p1].csize * 512,
						FatFs[p1].n_rootdir, (DWORD)FatFs[p1].n_fatent - 2,
						FatFs[p1].fatbase, FatFs[p1].dirbase, FatFs[p1].database
				);
				break;
	
			}
			break;

		case 'b' :	/* Buffer control command */
			switch (*ptr++) {	/* Branch by secondary command character */
			case 'd' :	/* bd <ofs> - Dump Buff[]  (OK)  */
				if (!xatoi(&ptr, &p1)) break;
				for (buf = &Buff[p1], ofs = p1, cnt = 32; cnt; cnt--, buf += 16, ofs += 16)
				{
					put_dump(buf, ofs, 16);
					if(!(ofs % 160) && ofs != 0)
					{
						printf(" ---- KEY ---- "); getchar(); printf("\n");
					}
				}
				break;

			case 'e' :	/* be <ofs> [<data>] ... - Edit Buff[] (OK) */
				if (!xatoi(&ptr, &p1)) break;
				if (xatoi(&ptr, &p2)) {
					do {
						Buff[p1++] = (BYTE)p2;
					} while (xatoi(&ptr, &p2));
					break;
				}
				for (;;) {
					printf("%04X %02X-", (WORD)(p1), (WORD)Buff[p1]);
					gets(ptr = Line);
//					get_uni(Line, sizeof Line / sizeof Line[0]);
//					ptr = Line;
					if (*ptr == '.') break;
					if (*ptr < ' ') { p1++; continue; }
					if (xatoi(&ptr, &p2))
						Buff[p1++] = (BYTE)p2;
					else
						printf("???\n");
				}
				break;

			case 'r' :	/* br <pd#> <sector> <count> - Read disk into Buff[] (OK) */
				if (!xatoi(&ptr, &p1) || !xatoi(&ptr, &p2) || !xatoi(&ptr, &p3)) break;
				printf("rc=%u\n", disk_read((BYTE)p1, Buff, p2, (BYTE)p3));
				break;

			case 'w' :	/* bw <pd#> <sect> <count> - Write Buff[] into disk (OK) */
				if (!xatoi(&ptr, &p1) || !xatoi(&ptr, &p2) || !xatoi(&ptr, &p3)) break;
				printf("rc=%u\n", disk_write((BYTE)p1, Buff, p2, (BYTE)p3));
				break;

			case 'f' :	/* bf <n> - Fill Buff[] (OK) */
				if (!xatoi(&ptr, &p1)) break;
				memset(Buff, (BYTE)p1, sizeof Buff);
				break;

			}
			break;

		case 'f' :	/* FatFs test command */
			switch (*ptr++) {	/* Branch by secondary command character */

			case 'i' :	/* fi <ld#> [<mount>] - Force initialized the logical drive (OK) */
				if (!xatoi(&ptr, &p1) || (UINT)p1 > 9) break;
				if (!xatoi(&ptr, &p2)) p2 = 0;
				sprintf(ptr, "%d:", p1);
				put_rc(f_mount(&FatFs[p1], ptr, (BYTE)p2));
				break;

			case 's' :	/* fs [<path>] - Show logical drive status (OK) */
				while (*ptr == ' ') ptr++;
				ptr2 = ptr;
#if _FS_READONLY
				res = f_opendir(&dir, ptr);
				if (res) {
					fs = dir.fs;
					f_closedir(&dir);
				}
#else
				res = f_getfree(ptr, (DWORD*)&p1, &fs);
#endif
				if (res) { put_rc(res); break; }
				printf("FAT type = FAT%u\nNumber of FATs = %u\n", ft[fs->fs_type & 3], fs->n_fats);
				printf("Cluster size = %u sectors, %lu bytes\n",
#if _MAX_SS != 512
					fs->csize, (DWORD)fs->csize * fs->ssize);
#else
					fs->csize, (DWORD)fs->csize * 512);
#endif
				if (fs->fs_type != FS_FAT32) printf("Root DIR entries = %u\n", fs->n_rootdir);
				printf("Sectors/FAT = %lu\nNumber of clusters = %lu\nVolume start sector = %lu\nFAT start sector = %lu\nRoot DIR start %s = %lu\nData start sector = %lu\n\n",
					fs->fsize, fs->n_fatent - 2, fs->volbase, fs->fatbase, fs->fs_type == FS_FAT32 ? "cluster" : "sector", fs->dirbase, fs->database);
#if _USE_LABEL
				res = f_getlabel(ptr2, pool, &dw);
				if (res) { put_rc(res); break; }
				printf(pool[0] ? "Volume name is %s\n" : "No volume label\n", pool);
				printf("Volume S/N is %04X-%04X\n", dw >> 16, dw & 0xFFFF);
#endif
				printf("...");
				AccSize = AccFiles = AccDirs = 0;
				res = scan_files(ptr);
				if (res) { put_rc(res); break; }
				p2 = (fs->n_fatent - 2) * fs->csize;
				p3 = p1 * fs->csize;
#if _MAX_SS != 512
				p2 *= fs->ssize / 512;
				p3 *= fs->ssize / 512;
#endif
				p2 /= 2;
				p3 /= 2;
				//printf("\r%u files, %I64u bytes.\n%u folders.\n%lu KiB total disk space.\n",
			    printf("\r%u files, %llu bytes.\n%u folders.\n%lu KiB total disk space.\n",
						AccFiles, AccSize, AccDirs, p2);
#if !FS_READONLY
				printf("%lu KiB available.\n", p3);
#endif
				break;

			case 'l' :	/* fl [<path>] - Directory listing (OK) */
				while (*ptr == ' ') ptr++;
				res = f_opendir(&dir, ptr);
				if (res) { put_rc(res); break; }
				AccSize = s1 = s2 = 0;
				for(;;) {
					res = f_readdir(&dir, &Finfo);
					if ((res != FR_OK) || !Finfo.fname[0]) break;
					if (Finfo.fattrib & AM_DIR) {
						s2++;
					} else {
						s1++; AccSize += Finfo.fsize;
					}
					printf("%c%c%c%c%c %u/%02u/%02u %02u:%02u %9lu  %s",
							(Finfo.fattrib & AM_DIR) ? 'D' : '-',
							(Finfo.fattrib & AM_RDO) ? 'R' : '-',
							(Finfo.fattrib & AM_HID) ? 'H' : '-',
							(Finfo.fattrib & AM_SYS) ? 'S' : '-',
							(Finfo.fattrib & AM_ARC) ? 'A' : '-',
							(Finfo.fdate >> 9) + 1980, (Finfo.fdate >> 5) & 15, Finfo.fdate & 31,
							(Finfo.ftime >> 11), (Finfo.ftime >> 5) & 63, Finfo.fsize, Finfo.fname);
#if _USE_LFN
					for (p2 = strlen(Finfo.fname); p2 < 12; p2++) printf(" ");
					printf("  "); 
					put_uni(LFName);
#endif
					printf("\n");
				}
				f_closedir(&dir);
				//printf("%4u File(s),%11I64u bytes total\n%4u Dir(s)", s1, AccSize, s2);
				printf("%4u File(s),%11llu bytes total\n%4u Dir(s)", s1, AccSize, s2);
				if (f_getfree(ptr, (DWORD*)&p1, &fs) == FR_OK)
					//printf(",%12I64u bytes free\n", (LONGLONG)p1 * fs->csize * 512);
					printf(",%12llu bytes free\n", (LONGLONG)p1 * fs->csize * 512);
				break;

			case 'o' :	/* fo <mode> <file> - Open a file (OK) */
				if (!xatoi(&ptr, &p1)) break;
				while (*ptr == ' ') ptr++;
				put_rc(f_open(&file[0], ptr, (BYTE)p1));
				break;

			case 'c' :	/* fc - Close a file (OK) */
				put_rc(f_close(&file[0]));
				break;

			case 'r' :	/* fr <len> - read file (OK) */
				if (!xatoi(&ptr, &p1)) break;
				p2 =0;
				while (p1) {
					if ((UINT)p1 >= sizeof Buff) {
						cnt = sizeof Buff; p1 -= sizeof Buff;
					} else {
						cnt = p1; p1 = 0;
					}
					res = f_read(&file[0], Buff, cnt, &s2);
					if (res != FR_OK) { put_rc(res); break; }
					p2 += s2;
					if (cnt != s2) break;
				}
				printf("%lu bytes read.\n", p2);
				break;

			case 'd' :	/* fd <len> - read and dump file from current fp (OK) */
				if (!xatoi(&ptr, &p1)) p1 = 128;
				ofs = file[0].fptr;
				while (p1) {
					if ((UINT)p1 >= 16) { cnt = 16; p1 -= 16; }
					else 				{ cnt = p1; p1 = 0; }
					res = f_read(&file[0], Buff, cnt, &cnt);
					if (res != FR_OK) { put_rc(res); break; }
					if (!cnt) break;
					put_dump(Buff, ofs, cnt);
					ofs += 16;
					if(!(ofs % 160) && ofs != 0)
					{
						printf(" ---- KEY ---- "); getchar(); printf("\n");
					}
				}
				break;

			case 'e' :	/* fe <ofs> - Seek file pointer */
				if (!xatoi(&ptr, &p1)) break;
				res = f_lseek(&file[0], p1);
				put_rc(res);
				if (res == FR_OK)
					printf("fptr = %lu(0x%lX)\n", file[0].fptr, file[0].fptr);
				break;
#if _USE_FASTSEEK
			case 'E' :	/* fE - Enable fast seek and initialize cluster link map table */
				file[0].cltbl = SeekTbl;			/* Enable fast seek (set address of buffer) */
				SeekTbl[0] = sizeof SeekTbl / sizeof SeekTbl[0];	/* Buffer size */
				res = f_lseek(&file[0], CREATE_LINKMAP);	/* Create link map table */
				put_rc(res);
				if (res == FR_OK) {
					printf("%u clusters, ", (file[0].fsize + 1) );
					printf((SeekTbl[0] > 4) ? "fragmented in %d.\n" : "contiguous.\n", SeekTbl[0] / 2 - 1);
					printf("%u items used.\n", SeekTbl[0]);

				}
				if (res == FR_NOT_ENOUGH_CORE) {
					printf("%u items required to create the link map table.\n", SeekTbl[0]);
				}
				break;
#endif	/* _USE_FASTSEEK */
#if _FS_RPATH >= 1
			case 'g' :	/* fg <path> - Change current directory (OK) */
				while (*ptr == ' ') ptr++;
				put_rc(f_chdir(ptr));
				break;
#if _VOLUMES >= 2
			case 'j' :	/* fj <path> - Change current drive */
				while (*ptr == ' ') ptr++;
				put_rc(f_chdrive(ptr));
				break;
#endif
#if _FS_RPATH >= 2
			case 'q' :	/* fq - Show current dir path (OK) */
				res = f_getcwd(Line, 256);
				if (res) {
					put_rc(res);
				} else {
					//WriteConsole(hCon, Line, strlen(Line), &p1, NULL);
					nkc_write(Line);
					printf("\n");
				}
				break;
#endif
#endif
#if !_FS_READONLY
			case 'w' :	/* fw <len> <val> - write file (OK) */
				if (!xatoi(&ptr, &p1) || !xatoi(&ptr, &p2)) break;
				memset(Buff, (BYTE)p2, sizeof Buff);
				p2 = 0;
				while (p1) {
					if ((UINT)p1 >= sizeof Buff) { cnt = sizeof Buff; p1 -= sizeof Buff; }
					else 				  { cnt = p1; p1 = 0; }
					res = f_write(&file[0], Buff, cnt, &s2);
					if (res != FR_OK) { put_rc(res); break; }
					p2 += s2;
					if (cnt != s2) break;
				}
				printf("%lu bytes written.\n", p2);
				break;

			case 'v' :	/* fv - Truncate file (OK) */
				put_rc(f_truncate(&file[0]));
				break;

			case 'n' :	/* fn <name> <new_name> - Change file/dir name (OK) */
				while (*ptr == ' ') ptr++;
				ptr2 = strchr(ptr, ' ');
				if (!ptr2) break;
				*ptr2++ = 0;
				while (*ptr2 == ' ') ptr2++;
				put_rc(f_rename(ptr, ptr2));
				break;

			case 'u' :	/* fu <name> - Unlink a file/dir - delete (OK) */
				while (*ptr == ' ') ptr++;
				put_rc(f_unlink(ptr));
				break;

			case 'k' :	/* fk <name> - Create a directory (OK) */
				while (*ptr == ' ') ptr++;
				put_rc(f_mkdir(ptr));
				break;

			case 'a' :	/* fa <atrr> <mask> <name> - Change file/dir attribute (OK) */
				if (!xatoi(&ptr, &p1) || !xatoi(&ptr, &p2)) break;
				while (*ptr == ' ') ptr++;
				put_rc(f_chmod(ptr, (BYTE)p1, (BYTE)p2));
				break;

			case 't' :	/* ft <year> <month> <day> <hour> <min> <sec> <name> - Change timestamp of a file/dir */
				if (!xatoi(&ptr, &p1) || !xatoi(&ptr, &p2) || !xatoi(&ptr, &p3)) break;
				Finfo.fdate = (WORD)(((p1 - 1980) << 9) | ((p2 & 15) << 5) | (p3 & 31));
				if (!xatoi(&ptr, &p1) || !xatoi(&ptr, &p2) || !xatoi(&ptr, &p3)) break;
				Finfo.ftime = (WORD)(((p1 & 31) << 11) | ((p2 & 63) << 5) | ((p3 >> 1) & 31));
				while (_USE_LFN && *ptr == ' ') ptr++;
				put_rc(f_utime(ptr, &Finfo));
				break;

			case 'x' : /* fx <src_name> <dst_name> - Copy a file (OK) */
				while (*ptr == ' ') ptr++;
				ptr2 = strchr(ptr, ' ');
				if (!ptr2) break;
				*ptr2++ = 0;
				while (*ptr2 == ' ') ptr2++;
				printf("Opening \"%s\"", ptr);
				res = f_open(&file[0], ptr, FA_OPEN_EXISTING | FA_READ);
				printf("\n");
				if (res) {
					put_rc(res);
					break;
				}
				while (*ptr2 == ' ') ptr2++;
				printf("Creating \"%s\"", ptr2);
				res = f_open(&file[1], ptr2, FA_CREATE_ALWAYS | FA_WRITE);
				printf("\n");
				if (res) {
					put_rc(res);
					f_close(&file[0]);
					break;
				}
				printf("Copying...");
				p1 = 0;
				for (;;) {
					res = f_read(&file[0], Buff, sizeof Buff, &s1);
					if (res || s1 == 0) break;   /* error or eof */
					res = f_write(&file[1], Buff, s1, &s2);
					p1 += s2;
					if (res || s2 < s1) break;   /* error or disk full */
				}
				printf("\n");
				if (res) put_rc(res);
				f_close(&file[0]);
				f_close(&file[1]);
				printf("%lu bytes copied.\n", p1);
				break;
#if _USE_LABEL
			case 'b' :	/* fb <name> - Set volume label (OK) */
				while (*ptr == ' ') ptr++;
				put_rc(f_setlabel(ptr));
				break;
#endif	/* USE_LABEL */
#if _USE_MKFS
			case 'm' :	/* fm <ld#> <partition rule> <cluster size> - Create file system (OK) */
				if (!xatoi(&ptr, &p1) || (UINT)p1 > 9 || !xatoi(&ptr, &p2) || !xatoi(&ptr, &p3)) break;
				printf("The volume will be formatted. Are you sure? (Y/n)=");
				gets(ptr = Line);
				//get_uni(ptr, 256);
				if (*ptr != 'Y') break;
				sprintf(ptr, "%u:", (UINT)p1);
				put_rc(f_mkfs(ptr, (BYTE)p2, (UINT)p3));
				break;
#if _MULTI_PARTITION
			case 'p' :	/* fp <pd#> <size1> <size2> <size3> <size4> - Create partition table (OK) */
				{
					DWORD pts[4];

					if (!xatoi(&ptr, &p1)) break;
					xatoi(&ptr, &pts[0]);
					xatoi(&ptr, &pts[1]);
					xatoi(&ptr, &pts[2]);
					xatoi(&ptr, &pts[3]);
					printf("The physical drive %u will be re-partitioned. Are you sure? (Y/n)=", p1);
					_fgetts(ptr, 256, stdin);
					if (*ptr != 'Y') break;
					put_rc(f_fdisk((BYTE)p1, pts, Buff));
				}
				break;
#endif	/* _MULTI_PARTITION */
#endif	/* _USE_MKFS */
#endif	/* !_FS_READONLY */
			}
			break;

		}
	}

}


