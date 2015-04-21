#include <stdio.h>
#include <string.h>
#include <ioctl.h>

#include "cmd.h"
#include "shell.h"

/*
#include "integer.h"
#include "diskio.h"
#include "gide.h"
*/
#include <fs.h>
#include <ff.h>


//#define MBR_Table			446	/* MBR: Partition table offset (2) */
//#define	SZ_PTE				16	/* MBR: Size of a partition table entry */
//#define BS_55AA				510	/* Boot sector signature (2) */

// const definitions

#define LINES_PER_PAGE                  15

#define TEXT_CMDHELP_CD                 1
#define TEXT_CMDHELP_COPY               2
#define TEXT_CMDHELP_DEL                3
#define TEXT_CMDHELP_DIR                4
#define TEXT_CMDHELP_MD                 5
#define TEXT_CMDHELP_REN                6
#define TEXT_CMDHELP_RD                 7
#define TEXT_CMDHELP_QUESTION           8
#define TEXT_CMDHELP_QUIT               9
#define TEXT_CMDHELP_DI                 10
#define TEXT_CMDHELP_DD                 11
#define TEXT_CMDHELP_DS                 12
#define TEXT_CMDHELP_DP                 13        
#define TEXT_CMDHELP_BD                 14
#define TEXT_CMDHELP_BE                 15
#define TEXT_CMDHELP_BR                 16
#define TEXT_CMDHELP_BW                 17
#define TEXT_CMDHELP_BF                 18
#define TEXT_CMDHELP_FMOUNT             19
#define TEXT_CMDHELP_FSTATUS            20
#define TEXT_CMDHELP_LSTATUS            21
#define TEXT_CMDHELP_FOPEN              22
#define TEXT_CMDHELP_FCLOSE             23
#define TEXT_CMDHELP_FSEEK              24
#define TEXT_CMDHELP_FDUMP              25
#define TEXT_CMDHELP_FREAD              26
#define TEXT_CMDHELP_FWRITE             27
#define TEXT_CMDHELP_FTRUNK             28
#define TEXT_CMDHELP_VLABEL             29
#define TEXT_CMDHELP_MKFS               30
#define TEXT_CMDHELP_PWD                31
#define TEXT_CMDHELP_CHMOD              32
#define TEXT_CMDHELP_MKPTABLE           33
#define TEXT_CMDHELP_FUMOUNT            34
#define TEXT_CMDHELP_PTABLE             35



// Help text ... 
struct CMDHLP hlptxt[] =
{
{TEXT_CMDHELP_CHMOD,
                        "ATTRIB: Change file/dir attribute\n",
                        "attrib <attr> <mask> <name>\n"\
                        "chmod  <attr> <mask> <name>\n"\
                        "  NewATTR = (attr & mask) | (OldATTR & ~mask)\n"\
                        "  attrib/mask:\n"\
                        "    read only  0x01    1\n"\
                        "    hidden     0x02    2\n"\
                        "    system     0x03    2\n"\
                        "    directory  0x10   16\n"\
                        "    archive    0x20   32\n"\
                        "  example:\n"\
                        "    set attribute 'HIDDEN':   chmod 32 32 file.ext\n"\
                        "    clear attribute 'HIDDEN': chmod  0 32 file.ext\n"},
{TEXT_CMDHELP_CD,
                        "CD: change current directory\n",
                        "cd <dir>\n"\
                        "  cd         show current directory\n"\
                        "  cd ..      one level up\n"\
                        "  cd [dir]   change to dir\n"},
{TEXT_CMDHELP_COPY,             
                        "COPY: copy file(s) or directory(s)\n",
                        "copy <file1> <file2>\n"},
{TEXT_CMDHELP_DEL,              
                        "DEL: delete a file\n",
                        "del <filename>\n"},
{TEXT_CMDHELP_DIR,              
                        "DIR: list directory contents\n",
                        "dir [<dir>]\n"},
{TEXT_CMDHELP_MD,               
                        "MD: make a directory\n",
                        "md <dirname>\n"\
                        "mkdir <dirname>\n"},
{TEXT_CMDHELP_REN,              
                        "REN: rename a file/directory\n",
                        "ren <oldname> <newname>\n"},
{TEXT_CMDHELP_RD,               
                        "RD: remake/delete a directory\n",
                        "rd [-R] <dirname>\n"},

                        
{TEXT_CMDHELP_DI,
	    "DINIT <d#>: initialize a disk\n",
            "dinit <disc number>\n"\
            "  first disk is #0\n"},
{TEXT_CMDHELP_DD,
	    "DDUMP [<d#> <sec#>]: dump sector\n",
            "ddump [<d#> <sec#>]\n"\
            "  dump sector sec# of disc d#\n"\
            "  first disc is #0\n"},
{TEXT_CMDHELP_DS,
	    "DSTATUS <d#>: display disc status\n",
            "dstatus <disc number>\n"},
{TEXT_CMDHELP_DP,
            "DPART <d#> <p1 size> ...: partition a phys. disc\n",
            "dpart <disc number>\n"},
{TEXT_CMDHELP_BD,
	    "BDUMP <ofs>: dump working buffer\n",
            "bdump <buffer offset>\n"},
{TEXT_CMDHELP_BE,
	    "BEDIT <ofs> [<data>]: edit working buffer\n",
            "bedit <ofs> [<data>]\n"},
{TEXT_CMDHELP_BR,
	    "BREAD <d#> <sec#> <cnt>: read disk to working buffer\n",
            "bread <d#> <sec#> <cnt>\n"},
{TEXT_CMDHELP_BW,
	    "BWRITE <d#> <sec#> <cnt>: write working buffer to disk\n",
            "bwrite <d#> <sec#> <cnt>\n"},
{TEXT_CMDHELP_BF,
	    "BFILL <val>: fill working buffer\n",
            "bfill <val>\n"},
{TEXT_CMDHELP_FMOUNT,
	    "FMOUNT <d#> [<1|0>]: initialize volume (1=mount immediately, 0=mount later)\n",
            "fmount <d#> [<1|0>]\n"\
            "   d# = drive number 0....n\n"\
            "   option: 1=mount immediately, 0=mount later\n"},
{TEXT_CMDHELP_FUMOUNT,
	    "FUMOUNT <d#> : unmount volume\n",
            "fumount <d#> \n"\
            "   d# = drive number 0....n\n"},            
{TEXT_CMDHELP_FSTATUS,
  	    "FSTATUS <d#>: show volume status\n",
            "fstatus <disc number>\n"},
{TEXT_CMDHELP_LSTATUS,
	    "LSTATUS [<path>]: show logical drive status\n",
            "lstatus [<path>]\n"},            
{TEXT_CMDHELP_FOPEN,
	    "FOPEN <mode> <file>: open a file\n",
            "fopen <mode> <file>\n"\
            " mode:\n"\
            "    open existing  0x00   0\n"\
            "    read           0x01   1\n"\
            "    write          0x02   2\n"\
            "    create new     0x04   4\n"\
            "    create always  0x08   8\n"\
            "    open always    0x10  16\n"},
{TEXT_CMDHELP_FCLOSE,
	    "FCLOSE : close the file\n",
            "fclose\n"},
{TEXT_CMDHELP_FSEEK,
	    "FSEEK [mode] <ofs>: move filepointer\n",
            "fseek [mode] <ofs>\n"},
{TEXT_CMDHELP_FDUMP,
	    "FDUMP <len>: dump the file\n",
            "fdump <len>\n"},
{TEXT_CMDHELP_FREAD,
	    "FREAD <len>: read the file\n",
            "fread <len>\n"},
{TEXT_CMDHELP_FWRITE,
	    "FWRITE <len> <val>: write to the file\n",
            "fwrite <len> <val>\n"},
{TEXT_CMDHELP_FTRUNK,
	    "FTRUNK : trunkate the file at current position\n",
            "ftrunk\n"},
{TEXT_CMDHELP_VLABEL,
	    "VLABEL <name>: set volume label\n",
            "vlabel <name>\n"},
{TEXT_CMDHELP_MKFS,
	    "MKFS <ld#> <rule> <cluster size>: create a file system\n",
            "mkfs <ld#> <rule> <cluster size>\n"\
            "  example:\n"\
            "      mkfs 0 0 1024\n"\
            "      mkfs 0 1 1024\n"},
{TEXT_CMDHELP_MKPTABLE,
	    "MKPTABLE <pd#> <size1> <size2> <size3> <size4> - Create partition table \n",
            "mlptable <pd#> <size1> <size2> <size3> <size4>\n"},  
{TEXT_CMDHELP_PTABLE,
	    "PTABLE <pd#>  - show partition table of physical drive pd# \n",
            "ptable <pd#>\n"},                      
{TEXT_CMDHELP_PWD,
	    "PWD: print working directory\n",
            "pwd\n"},           
{TEXT_CMDHELP_QUIT,             
                        "QUIT: quit/exit program\n",
                        "quit\n"},                 
        
        {0,"",""}
};


// list of available commands ...
struct CMD internalCommands[] =
{
  {"DINIT"      , cmd_dinit     , TEXT_CMDHELP_DI},  
  {"DDUMP"      , cmd_ddump     , TEXT_CMDHELP_DD},
  {"DSTATUS"    , cmd_dstatus   , TEXT_CMDHELP_DS},
  {"DPART"      , cmd_dpart     , TEXT_CMDHELP_DP},
  {"BDUMP"      , cmd_bdump     , TEXT_CMDHELP_BD},
  {"BEDIT"      , cmd_bedit     , TEXT_CMDHELP_BE},
  {"BREAD"      , cmd_bread     , TEXT_CMDHELP_BR},
  {"BWRITE"     , cmd_bwrite    , TEXT_CMDHELP_BW},
  {"BFILL"      , cmd_bfill     , TEXT_CMDHELP_BF}, 
  {"FMOUNT"     , cmd_fmount    , TEXT_CMDHELP_FMOUNT},
  {"FUMOUNT"    , cmd_fumount   , TEXT_CMDHELP_FUMOUNT},
  {"FSTATUS"    , cmd_fstatus   , TEXT_CMDHELP_FSTATUS},
  {"LSTATUS"    , cmd_lstatus   , TEXT_CMDHELP_LSTATUS},
  {"FOPEN"      , cmd_fopen     , TEXT_CMDHELP_FOPEN},
  {"FCLOSE"     , cmd_fclose    , TEXT_CMDHELP_FCLOSE},
  {"FSEEK"      , cmd_fseek     , TEXT_CMDHELP_FSEEK},
  {"FDUMP"      , cmd_fdump     , TEXT_CMDHELP_FDUMP},
  {"FREAD"      , cmd_fread     , TEXT_CMDHELP_FREAD},
  {"FWRITE"     , cmd_fwrite    , TEXT_CMDHELP_FWRITE},
  {"FTRUNK"     , cmd_ftrunk    , TEXT_CMDHELP_FTRUNK},
  {"VLABEL"     , cmd_vlabel    , TEXT_CMDHELP_VLABEL},
  {"MKFS"       , cmd_mkfs      , TEXT_CMDHELP_MKFS},        
  {"PWD"        , cmd_pwd       , TEXT_CMDHELP_PWD},  
  {"CHMOD"      , cmd_chmod     , TEXT_CMDHELP_CHMOD},
  {"ATTRIB"     , cmd_chmod     , TEXT_CMDHELP_CHMOD},
  {"CD"         , cmd_chdir     , TEXT_CMDHELP_CD},  
  {"CHDIR"      , cmd_chdir     , TEXT_CMDHELP_CD},
  {"COPY"       , cmd_copy      , TEXT_CMDHELP_COPY },
  {"CP"         , cmd_copy      , TEXT_CMDHELP_COPY },
  {"DEL"        , cmd_del       , TEXT_CMDHELP_DEL},
  {"DIR"        , cmd_dir       , TEXT_CMDHELP_DIR},
  {"LS"         , cmd_dir       , TEXT_CMDHELP_DIR},
  {"MD"         , cmd_mkdir     , TEXT_CMDHELP_MD},
  {"MKDIR"      , cmd_mkdir     , TEXT_CMDHELP_MD},
  {"MKPTABLE"   , cmd_mkptable  , TEXT_CMDHELP_MKPTABLE},
  {"PTABLE"     , cmd_ptable    , TEXT_CMDHELP_PTABLE},  
  {"REN"        , cmd_rename    , TEXT_CMDHELP_REN},
  {"RENAME"     , cmd_rename    , TEXT_CMDHELP_REN},
  {"RMDIR"      , cmd_rmdir     , TEXT_CMDHELP_RD},
  {"QUIT"       , cmd_quit      , TEXT_CMDHELP_QUIT},
  {"Q"          , cmd_quit      , TEXT_CMDHELP_QUIT},  
  {"EXIT"       , cmd_quit      , TEXT_CMDHELP_QUIT},
  {"?"          , showcmds      , TEXT_CMDHELP_QUESTION},
  
  {0,0,0}
};





/*---------------------------------------------------------*/
/* Work Area                                               */
/*---------------------------------------------------------*/
// see main.c
extern FATFS FatFs[_VOLUMES];		/* File system object for logical drive */
extern FILINFO Finfo;

extern LONGLONG AccSize;			/* Work register for scan_files() */
extern WORD AccFiles, AccDirs;
extern BYTE Buff[262144];			/* Working buffer */

extern char Line[300];			/* Console input/output buffer */
extern char CurrDirPath[300];

extern PARTITION VolToPart[];	/* Volume - Partition resolution table */
// ---
FILE* file[2];			/* File objects */


/*---------------------------------------------------------*/
/* Helper Functions                                        */
/*---------------------------------------------------------*/
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
// implementation of commands ...


// ****************** high level filesystem (fat) commands.... *************************************


// calls via ioctl (start) -------
int cmd_pwd    (char * args){
   FRESULT res;
   struct ioctl_get_cwd arg;
   
   arg.buffer = CurrDirPath;
   arg.size = 256;
   res = ioctl(NULL,FS_IOCTL_GETCWD,&arg); // no device name needed
   
   
   //res = f_getcwd(CurrDirPath, 256);
   if (res) {
	put_rc(res);
   } else {	
	nkc_write(CurrDirPath);
	printf("\n");
   }
          
   return res;
} 

FRESULT f_chmod (
	const TCHAR* path,	/* Pointer to the file path */
	BYTE value,			/* Attribute bits */
	BYTE mask			/* Attribute mask to change */
)

int cmd_chmod(char* args) {
   /* fa <atrr> <mask> <name> - Change file/dir attribute */
   long p1,p2;
   struct ioctl_chmod arg;
   
   if (!xatoi(&args, &p1) || !xatoi(&args, &p2)) return 0;
   while (*args == ' ') args++;
   
   arg.value = (BYTE)p1;
   arg.mask  = (BYTE)p2,
   
   res = ioctl(args,FAT_IOCTL_CHMOD,&arg);
   
   //put_rc(f_chmod(args, (BYTE)p1, (BYTE)p2));
   put_rc(res);
   
   return 0;
}


int cmd_chdir(char *args)
{
   FRESULT res;
   
   while (*args == ' ') args++;
   
   res = ioctl(NULL,FAT_IOCTL_CD,args);
   put_rc(res);
   res = cmd_pwd(NULL);   
   
   //put_rc(f_chdir(args));   
   //res = f_getcwd(CurrDirPath, 256); /* update current drive,path */
   
   return 0;
}




int cmd_dir(char *args)
{
   /* dir [<path>] - Directory listing */
   
   DIR dir;				/* Directory object */
   FATFS *fs;				/* Pointer to file system object */
   FRESULT res;
   UINT s1, s2;
   long p1,p2,line=0;  
   
   struct ioctl_opendir arg_opendir;
   struct ioctl_readdir arg_readdir;
   struct ioctl_getfree arg_getfree;
   
   while (*args == ' ') args++;
   
   arg_opendir.dp = &dir;
   arg_opendir.path = args;
   
   //res = f_opendir(&dir, args);
   res = ioctl(NULL,FAT_IOCTL_OPEN_DIR,&arg_opendir);
   
   if (res) { put_rc(res); return 0; }
   AccSize = s1 = s2 = 0;
   
   printf("Attr.    Date    Time      Size   File-Name\n\n");
   
   for(;;) {
	//res = f_readdir(&dir, &Finfo);
        arg_readdir.dp = &dir;
	arg_readdir.fno = &Finfo;
	res = ioctl(NULL,FAT_IOCTL_READ_DIR,&arg_readdir);
	
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
	if(!(line % LINES_PER_PAGE) && line != 0) {
   	    printf(" ---- KEY ---- "); getchar(); printf("\n");
	}
	line++;
   }
   //f_closedir(&dir);
   res = ioctl(NULL,FAT_IOCTL_CLOSE_DIR,&dir);
   //printf("%4u File(s),%11I64u bytes total\n%4u Dir(s)", s1, AccSize, s2);
   printf("%4u File(s),%11llu bytes total\n%4u Dir(s)", s1, AccSize, s2);     
   
   //if (f_getfree(args, (DWORD*)&p1, &fs) == FR_OK)
     
   arg_getfree.path = args;
   arg_getfree.nclst = (DWORD*)&p1;
   arg_getfree.fatfs = &fs;   
   if(ioctl(NULL,FAT_IOCTL_GET_FREE,&arg_getfree) == FR_OK)
   //printf(",%12I64u bytes free\n", (LONGLONG)p1 * fs->csize * 512);
   printf(",%12llu bytes free\n", (LONGLONG)p1 * fs->csize * 512);
   return 0;
}



int cmd_mkdir(char *args)
{
  
   FRESULT res;
  
   while (*args == ' ') args++;
   //put_rc(f_mkdir(args));   
   res = ioctl(NULL,FAT_IOCTL_MKDIR,&args);
   put_rc(res);
   
   return 0;
}

int cmd_rmdir(char *args)
{
  
   FRESULT res;    
   
  
   printf(" RMDIR called ...\n"
          "    args: %s\n", args);
   
   while (*args == ' ') args++;
   res = ioctl(NULL,FAT_IOCTL_UNLINK,&args);
   put_rc(res);
   
   return res;
}

int cmd_rename(char *args)
{
   char * ptr2;
   FRESULT res; 
   struct ioctl_rename arg_rename;
   
   while (*args == ' ') args++;
   ptr2 = strchr(args, ' ');
   if (!ptr2) return 0;
   *ptr2++ = 0;
   while (*ptr2 == ' ') ptr2++;
   
   //put_rc(f_rename(args, ptr2));
   arg_rename.path_old = args;
   arg_rename.path_new = ptr2;   
   res = ioctl(NULL,FS_IOCTL_RENAME,&arg_rename);
   put_rc(res);
   
   return res;
}

int cmd_del(char *args) {
   /* del <name> - delete a file */
   FRESULT res; 
   while (*args == ' ') args++;
   //put_rc(f_unlink(args));
   res = ioctl(NULL,FS_IOCTL_DEL,&args);
   put_rc(res);
   
   return res;
}
// calls via ioctl (end) -------

// standard clib calls (start) -----

int cmd_copy(char *args)
{
   FRESULT res;
   char *ptr2;
   long p1;
   UINT s1,s2;
        
   while (*args == ' ') args++;
   ptr2 = strchr(args, ' ');
   if (!ptr2) return 0;
   *ptr2++ = 0;
   while (*ptr2 == ' ') ptr2++;
   printf("Opening \"%s\"", args);
   //res = f_open(&file[0], args, FA_OPEN_EXISTING | FA_READ);
   file[0] = fopen(args,"rb");
   
   printf("\n");
   if (file[0]==NULL) {
      //put_rc(res);
      return 0;
   }
   while (*ptr2 == ' ') ptr2++;
   printf("Creating \"%s\"", ptr2);
   //res = f_open(&file[1], ptr2, FA_CREATE_ALWAYS | FA_WRITE);
   file[1] = fopen(ptr2,"wb");
   printf("\n");
   if (file[1]==NULL) {
     //put_rc(res);
     close(file[0]);
     return 0;
   }
   printf("Copying...");
   p1 = 0;
   for (;;) {
     //res = f_read(&file[0], Buff, sizeof Buff, &s1);
     s1 = fread(Buff, 1, sizeof Buff, file][0]); res = RES_OK;
     if (res || s1 == 0) break;   /* error or eof */
     //res = f_write(&file[1], Buff, s1, &s2);
     s2 = fwrite(Buff, 1, s1, file[1]); res = RES_OK;  
     p1 += s2;
     if (res || s2 < s1) break;   /* error or disk full */
   }
   printf("\n");
   if (res) put_rc(res);
   //f_close(&file[0]);
   //f_close(&file[1]);
   fclose(file[0]);
   fclose(file[1]);
   printf("%lu bytes copied.\n", p1);
   return 0;
}

int cmd_fopen  (char * args){
  /* fopen <mode> <file> - Open a file (OK) */
   long p1;
   char* mode;
   
   if (!xatoi(&args, &p1)) return 0;
   while (*args == ' ') args++;
   //put_rc(f_open(&file[0], args, (BYTE)p1));   
   file[0] = fopen(args,p1);
   
   return 0;
} 
int cmd_fclose (char * args){
   //put_rc(f_close(&file[0]));      
   fclose(file[0]);
   return 0;
} 
int cmd_fseek  (char * args){
   /* fe <ofs> - Seek file pointer */
   long p1;
   FRESULT res;
   
   if (!xatoi(&args, &p1)) return 0;
   //res = f_lseek(&file[0], p1);
   res = fseek(file[0],p1,SEEK_CUR); // seek p1 bytes from the current position
   put_rc(res);
   if (res == FR_OK)
   printf("fptr = %lu(0x%lX)\n", file[0].fptr, file[0].fptr);         
   
   return 0;
} 


int cmd_fdump  (char * args){
   long p1;
   UINT cnt;
   DWORD ofs = 0;
   FRESULT res;
   
   if (!xatoi(&args, &p1)) p1 = 128;
   ofs = file[0].fptr;
   while (p1) {
     if ((UINT)p1 >= 16) { cnt = 16; p1 -= 16; }
     else	{ cnt = p1; p1 = 0; }
     //res = f_read(&file[0], Buff, cnt, &cnt);
     cnt = fread(Buff, 1, cnt, file][0]); res = RES_OK;
     if (res != FR_OK) { put_rc(res); return 0; }
     if (!cnt) return 0;
     put_dump(Buff, ofs, cnt);
     ofs += 16;
     if(!(ofs % 160) && ofs != 0) {
	printf(" ---- KEY ---- "); getchar(); printf("\n");
     }
   }
             
   return 0;
} 
int cmd_fread  (char * args){
   long p1,p2;
   UINT s2, cnt;
   FRESULT res;
   
   if (!xatoi(&args, &p1)) return 0;
   p2 =0;
   while (p1) {
    if ((UINT)p1 >= sizeof Buff) {
	cnt = sizeof Buff; p1 -= sizeof Buff;
    } else {
	cnt = p1; p1 = 0;
    }
    //res = f_read(&file[0], Buff, cnt, &s2);
    s2 = fread(Buff, 1, cnt, file][0]); res = RES_OK;
    if (res != FR_OK) { put_rc(res); return 0; }
    p2 += s2;
    if (cnt != s2) return 0;
   }
   printf("%lu bytes read.\n", p2);          
   
   return 0;
} 
int cmd_fwrite (char * args){
   /* fw <len> <val> - write file */
   long p1,p2;
   UINT s2, cnt;
   FRESULT res;
   
   if (!xatoi(&args, &p1) || !xatoi(&args, &p2)) return 0;
   memset(Buff, (BYTE)p2, sizeof Buff);
   p2 = 0;
   while (p1) {
	if ((UINT)p1 >= sizeof Buff) { cnt = sizeof Buff; p1 -= sizeof Buff; }
	else 				  { cnt = p1; p1 = 0; }
	//res = f_write(&file[0], Buff, cnt, &s2);
	s2 = fwrite(Buff, 1, cnt, file[0]); res = RES_OK; 
	if (res != FR_OK) { put_rc(res); return 0; }
	p2 += s2;
	if (cnt != s2) break;
   }
   printf("%lu bytes written.\n", p2);          
   
   return 0;
} 
int cmd_ftrunk (char * args){
   /* fv - Truncate file */
   //put_rc(f_truncate(&file[0]));          
   return 0;
} 

// standard clib calls (end) -----

// ***************************** low level disc commands *****************************
int cmd_dinit  (char * args){
// dinit <disc number/device, ie. A:, B: .... hda0: etc.>
   long p1;
   WORD w;
   DWORD dw;
   FRESULT res;   
   
   /*
   if (!xatoi(&args, &p1)) {
    printf(" error in args\n");
    return 0;
   }
   */
   				
   printf(" Initialize drive %d\n",(BYTE)p1);				
   //res = disk_initialize((BYTE)p1);
   res = ioctl(args,FAT_IOCTL_DISK_INIT,NULL);
   printf(" (rc=%d)\n", res);				
   //if (disk_ioctl((BYTE)p1, GET_SECTOR_SIZE, &w) == RES_OK)
   if (ioctl(args, FAT_IOCTL_DISK_GET_SECTOR_SIZE, &w) == RES_OK)
	printf(" Sector size = %u\n", w);
   //if (disk_ioctl((BYTE)p1, GET_SECTOR_COUNT, &dw) == RES_OK)
   if (ioctl(args, FAT_IOCTL_DISK_GET_SECTOR_COUNT, &dw) == RES_OK)
	printf(" Number of sectors = %u\n", dw);
       
   return 0;
}

// Disk Drive Status
int cmd_dstatus(char * args){

   char *ptr;
   int res;
   struct _deviceinfo di;
   
   printf(" Disk Drive Status:\n");  
   
   while (*ptr == ' ') ptr++;

			
   //res = idetifyIDE(1, &di);
   ioctl(args, FAT_IOCTL_GET_DISK_DRIVE_STATUS, &di)
			
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
			        
   return 0;
} 


int cmd_ddump  (char * args){

   long p1,p2;
   BYTE *buf;
   int res;
   WORD w;
   struct ioctl_disk_read ioctl_args;
   DWORD ofs = 0, sect = 0, drv = 0;
   
   /*
   if (!xatoi(&args, &p1)) {
	p1 = drv; p2 = sect;
   } else {
	if (!xatoi(&args, &p2)) return 0;
   }
   res = disk_read((BYTE)p1, Buff, p2, 1);
   */
   ioctl_args.buff = Buff;
   ioctl_args.sector = p2;
   ioctl_args.count = 1;   
   res = ioctl(args, FAT_IOCTL_DISK_READ, &ioctl_args)
   if (res) { printf("rc=%d\n", (WORD)res); return 0; }
   printf("Drive:%u Sector:%lu\n", p1, p2);
   //if (disk_ioctl((BYTE)p1, GET_SECTOR_SIZE, &w) != RES_OK) return 0;
   if (ioctl(args, FAT_IOCTL_DISK_GET_SECTOR_SIZE, &w) != RES_OK) return 0;
   sect = p2 + 1; drv = p1;
   for (buf = Buff, ofs = 0; ofs < w; buf += 16, ofs += 16) {
	put_dump(buf, ofs, 16);
	if(!(ofs % 160) && ofs != 0) {
   	    printf(" ---- KEY ---- "); getchar(); printf("\n");
	}
   }

   return 0;
} 

// ***************************** low level filesystem commands ****************************


int cmd_mkfs   (char * args){
   /* mkfs <ld#> <partition rule> <cluster size> - Create file system */ 
   /* Partitioning rule 0:FDISK, 1:SFD */
   /*  */   
   long p1,p2,p3;
   char *ptr;
   int res;
   struct ioctl_mkfs ioctl_args;
   
   if (!xatoi(&args, &p1) || (UINT)p1 > 9 || !xatoi(&args, &p2) || !xatoi(&args, &p3)) return 0;
   printf("The volume will be formatted. Are you sure? (Y/n)=");
   gets(ptr = Line);
   //get_uni(ptr, 256);
   if (*ptr != 'Y') return 0;
   sprintf(ptr, "%u:", (UINT)p1);
   //put_rc(f_mkfs(ptr, (BYTE)p2, (UINT)p3));  
   ioctl_args.path = ptr;
   ioctl_args.au = p2;
   ioctl_args.sfd = p3;
   res = ioctl(NULL, FAT_IOCTL_MKFS, &ioctl_args);
   put_rc(res);
   return 0;
}


int cmd_dpart  (char * args){
   printf(" not implemented ... mkptable ?\n");          
   return 0;
} 


int cmd_mkptable (char * args) {
   /* fp <pd#> <size1> <size2> <size3> <size4> - Create partition table */
   DWORD pts[4];
   long p1;
   char *ptr;
   struct ioctl_mkptable ioctl_args;
   
   #if _MULTI_PARTITION
   if (!xatoi(&args, &p1)) return 0;
   xatoi(&args, &pts[0]);
   xatoi(&args, &pts[1]);
   xatoi(&args, &pts[2]);
   xatoi(&args, &pts[3]);
   printf("The physical drive %u will be re-partitioned. Are you sure? (Y/n)=", p1);
   gets(ptr = Line);
   if (*ptr != 'Y') return 0;
   //put_rc(f_fdisk((BYTE)p1, pts, Buff));
   ioctl_args.pdrv = p1;
   ioctl_args.szt = pts;
   ioctl_args.work = Buff;
   res = ioctl(NULL, FAT_IOCTL_MKPTABLE, &ioctl_args);
   put_rc(res);
   #else
   printf(" mkptable: multi partition feature not implemented\n");
   #endif
   return 0;
}


void dump_partition(struct partition *part, int partition_number)
{
        printf("Partition %d\n", partition_number + 1);
        printf("   boot_flag = %02X", part->boot_flag);
        printf("   sys_type = %02X\n", part->sys_type);
        
        printf("   chs_begin: head = %d, cyl/sec = %d\n",part->chs_begin_head,part->chs_begin_cyl);                
        printf("   chs_end: head = %d, cyl/sec = %d\n",part->chs_end_head,part->chs_end_cyl);

        printf("   start_sector = %d",endian(part->start_sector));
        printf("   nr_sector = %d\n",endian(part->nr_sector));

}

/*

Disk /dev/sdb: 2048 MB, 2048901120 bytes
64 heads, 63 sectors/track, 992 cylinders, total 4001760 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1              63        8063        4000+   4  FAT16 <32M




Disk /dev/sdb: 2048 MB, 2048901120 bytes
256 heads, 63 sectors/track, 248 cylinders, total 4001760 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1   *          66     4001759     2000847    6  FAT16

Partition /dev/sdb1
boot_flag = 80
chs_begin = ff ff ff 
sys_type = 06                   => 6 (Id, FAT16)
chs_end = ff ff ff 
start_sector = 42 00 00 00      => 66 (Start)
nr_sector = 9e 0f 3d 00         => 4001694 (+66-1= 1001759, End)

*/


int cmd_ptable(char * args) {
  BYTE *p;
  UINT i;
  struct ioctl_disk_read ioctl_args;
  
  while (*args == ' ') args++;  
		   
   ioctl_args.buff = Buff;
   ioctl_args.sector = 0;
   ioctl_args.count = 1;   
   res = ioctl(args, FAT_IOCTL_DISK_READ, &ioctl_args);
   
   //if (disk_read(0,Buff,0,1)) {     // read sector 0 of physical drive 0 (MBR)
   if(res) {
         printf(" disc error\n");
         return 0;
        }

        p = Buff + MBR_Table;
        
        printf(" The 4 Main Partinions: \n\n");
        
        for (i = 0; i < 4; i++, p += SZ_PTE) {
                dump_partition(p, i);
        }
        
        return 0;
}

int cmd_fmount (char * args){
   /* fmount <ld#> [<0|1>] - Force initialized the logical drive (1=mount now, 0=mount later)*/
   long p1,p2;
   FRESULT res;
   char *tmp[10];
   struct ioctl_get_cwd arg;
   
   
   if (!xatoi(&args, &p1) || (UINT)p1 > 9){
     printf(" error in args.\n");
     return 0;
   }   
   
   if (!xatoi(&args, &p2)) p2 = 0;
   sprintf(tmp, "%d:", p1);
   
   //put_rc(f_mount(&FatFs[p1], tmp, (BYTE)p2));
   
   
   res = ioctl(args, FAT_IOCTL_MOUNT, p1);
   put_rc(res);
   
   //res = f_getcwd(CurrDirPath, 256); /* update current drive,path */
   
   arg.buffer = CurrDirPath;
   arg.size = 256;
   res = ioctl(NULL,FAT_IOCTL_GETCWD,&arg); // no device name needed
   	      
   return 0;
} 

int cmd_fumount (char * args){
   /* fmount <ld#>  - unmount drive ld#*/
   long p1;
   FRESULT res;
   char *tmp[10];
   struct ioctl_get_cwd arg;
   
   if (!xatoi(&args, &p1) || (UINT)p1 > 9){
     printf(" error in args.\n");
     return 0;
   }
   sprintf(tmp, "%d:", p1);
   //put_rc(f_mount(NULL, tmp, 0));
   
   res = ioctl(args, FAT_IOCTL_UMOUNT, tmp);
   put_rc(res);
   
   //res = f_getcwd(CurrDirPath, 256); /* update current drive,path */
   
   arg.buffer = CurrDirPath;
   arg.size = 256;
   res = ioctl(NULL,FAT_IOCTL_GETCWD,&arg); // no device name needed
   	      
   return 0;
} 
// File System Status
int cmd_fstatus(char * args){

   long p1;
   FATFS fs;
   struct ioctl_getfatfs arg;
   
   printf(" File System Status:\n");
   
   if (!xatoi(&args, &p1)) {
    printf(" error in args\n");
    return 0;
   }
								
   arg.ld = p1;
   arg.pfs = &fs;
   res = ioctl(NULL,FAT_IOCTL_GET_FATFS,&arg);
   
   if (!fs.fs_type) { printf("Not mounted.\n"); return 0; }
   printf("FAT type = %u\nBytes/Cluster = %lu\n"
	  "Root DIR entries = %u\nNumber of clusters = %lu\n"
	  "FAT start (lba) = %lu\nDIR start (lba,clustor) = %lu\nData start (lba) = %lu\n\n",
		 (BYTE)fs.fs_type,
		 (DWORD)fs.csize * 512,
		 fs.n_rootdir, (DWORD)fs.n_fatent - 2,
		 fs.fatbase, fs.dirbase, fs.database );
				          
   return 0;
}


// Logical Drive Status
int cmd_lstatus(char * args){
  struct ioctl_opendir arg_opendir;
  struct ioctl_readdir arg_readdir;
  struct ioctl_getfree arg_getfree;
  char * ptr2;
  DWORD dw;
  FRESULT res;
  char pool[50];
  long p1,p2,p3;
  FATFS *fs;				/* Pointer to file system object */
  static const BYTE ft[] = {0, 12, 16, 32};
  
  while (*args == ' ') args++;
  ptr2 = args;
#if _FS_READONLY
  //res = f_opendir(&dir, ptr);  
  arg_opendir.dp = &dir;
  arg_opendir.path = ptr;     
  res = ioctl(NULL,FAT_IOCTL_OPEN_DIR,&arg_opendir);
  
  if (res) {
     fs = dir.fs;
     //f_closedir(&dir);
     res = ioctl(NULL,FAT_IOCTL_CLOSE_DIR,&dir);
  }
#else
  //res = f_getfree(args, (DWORD*)&p1, &fs);        
  arg_getfree.path = args;
  arg_getfree.nclst = (DWORD*)&p1;
  arg_getfree.fatfs = &fs;   
  res = ioctl(NULL,FAT_IOCTL_GET_FREE,&arg_getfree);
     
#endif
  if (res) { put_rc(res); return 0; }
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
  if (res) { put_rc(res); return 0; }
  printf(pool[0] ? "Volume name is %s\n" : "No volume label\n", pool);
  printf("Volume S/N is %04X-%04X\n", dw >> 16, dw & 0xFFFF);
#endif
  printf("...");
  AccSize = AccFiles = AccDirs = 0;
  res = scan_files(args);
  if (res) { put_rc(res); return 0; }
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

  return 0;
}

int cmd_vlabel (char * args){
   /* flabel <name> - Set volume label */
   while (*args == ' ') args++;
   put_rc(f_setlabel(args));         
   return 0;
} 

// ******************** buffer commands ***********************
int cmd_bdump  (char * args){
   long p1;
   BYTE *buf;
   UINT cnt;
   DWORD ofs = 0;
   
   if (!xatoi(&args, &p1)) return 0;
   for (buf = &Buff[p1], ofs = p1, cnt = 32; cnt; cnt--, buf += 16, ofs += 16) {
	put_dump(buf, ofs, 16);
	if(!(ofs % 160) && ofs != 0) {
		printf(" ---- KEY ---- "); getchar(); printf("\n");
	}
   }         
   return 0;
}
 
int cmd_bedit  (char * args){
   /* be <ofs> [<data>] ... - Edit Buff[] */
   long p1,p2;
   char* ptr;
   
   if (!xatoi(&args, &p1)) return 0;
   
   if (xatoi(&args, &p2)) {
	do {
	 Buff[p1++] = (BYTE)p2;
	} while (xatoi(&args, &p2));
	return 0;
   }
   
   for (;;) {
	printf("%04X %02X-", (WORD)(p1), (WORD)Buff[p1]);
	gets(ptr = Line);
//	get_uni(Line, sizeof Line / sizeof Line[0]);
//	ptr = Line;
	if (*ptr == '.') return 0;
	if (*ptr < ' ') { p1++; continue; }
	if (xatoi(&ptr, &p2))
		Buff[p1++] = (BYTE)p2;
	else
		printf("???\n");
   }
             
   return 0;
} 

int cmd_bread  (char * args){
   /* br <pd#> <sector> <count> - Read disk into Buff[] */
   long p1,p2,p3;
   
   if (!xatoi(&args, &p1) || !xatoi(&args, &p2) || !xatoi(&args, &p3)) return 0;
   printf("rc=%u\n", disk_read((BYTE)p1, Buff, p2, (BYTE)p3));          
   return 0;
} 
int cmd_bwrite (char * args){
   /* bw <pd#> <sect> <count> - Write Buff[] into disk */
   long p1,p2,p3;
   
   if (!xatoi(&args, &p1) || !xatoi(&args, &p2) || !xatoi(&args, &p3)) return 0;
   printf("rc=%u\n", disk_write((BYTE)p1, Buff, p2, (BYTE)p3));          
   return 0;
} 
int cmd_bfill  (char * args){
   /* bf <n> - Fill Buff[] */
   long p1;
   
   if (!xatoi(&args, &p1)) return 0;
   memset(Buff, (BYTE)p1, sizeof Buff);
   return 0;
} 


int cmd_chdrive(char * args){
/* fj <path> - Change current drive */
   FRESULT res;
   
   while (*args == ' ') args++;
   //put_rc(f_chdrive(args));
   res = f_chdrive(args);
   
   if(res == 0) return 1;
   
   return 0;
}




// not implemented:
/* fE - Enable fast seek and initialize cluster link map table */
/* ft <year> <month> <day> <hour> <min> <sec> <name> - Change timestamp of a file/dir */


int cmd_quit(char *args)
{
   printf(" QUIT called ...\n"
          "    args: %s\n", args);
   
   return 1;
}

