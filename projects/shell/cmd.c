#include <stdio.h>
#include <string.h>
#include <ioctl.h>
#include <errno.h>

#include <fs.h>
#include <ff.h>
#include <diskio.h>
#include <gide.h>

#include "cmd.h"
#include "shell.h"

#include "../../nkc/llnkc.h"


#define MBR_Table			446	/* MBR: Partition table offset (2) */
#define	SZ_PTE				16	/* MBR: Size of a partition table entry */

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
#define TEXT_CMDHELP_BD                 14
#define TEXT_CMDHELP_BE                 15
#define TEXT_CMDHELP_BR                 16
#define TEXT_CMDHELP_BW                 17
#define TEXT_CMDHELP_BF                 18
#define TEXT_CMDHELP_VMOUNT             19
#define TEXT_CMDHELP_VSTATUS            20
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
#define TEXT_CMDHELP_VUMOUNT            34
#define TEXT_CMDHELP_PTABLE             35
#define TEXT_CMDHELP_CLS             	36

#define TEXT_CMDHELP                    37

// Help text ... 
struct CMDHLP hlptxt[] =
{
{TEXT_CMDHELP_CLS,              
                        "CLS: clear screen\n",
                        "cls \n"},
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
			"CD: change current directory/drive\n",
                        "cd <dir>\n"\
                        "  cd         show current directory\n"\
                        "  cd ..      one level up\n"\
                        "  cd [dir]   change to dir\n"\
                        "  cd 1:      change to logical drive 1\n"},
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
                        "MKDIR: make a directory\n",
                        "mkdir <dirname>\n"\
                        "mkdir <dirname>\n"},
{TEXT_CMDHELP_REN,              
                        "REN: rename a file/directory\n",
                        "ren <oldname> <newname>\n"},
{TEXT_CMDHELP_RD,               
                        "RMDIR: remake/delete a directory\n",
                        "rmdir [-R] <dirname>\n"},

                        
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
            "dstatus <disc number>\n"\
            "  first disk is #0\n"},
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
{TEXT_CMDHELP_VMOUNT,
	    "VMOUNT <pd#> <ld#> [<1|0>]: initialize/mount volume (1=mount immediately, 0=mount later)\n",
            "vmount <pd#> <ld#> [<1|0>]\n"\
            "   pd# = physical drive number 0...3\n"\
            "   ld# = logical drive number/partition 0....9\n"\
            "   option: 1=mount immediately, 0=mount later\n"\
	    "   vmount only shows mounted volumes\n"},
{TEXT_CMDHELP_VUMOUNT,
	    "VUMOUNT <pd#> <ld#> : unmount volume\n",
            "vumount <pd#> <ld#> \n"\
            "   pd# = physical drive number 0...3\n"\
            "   ld# = logical drive number/partition 0....n\n"},            
{TEXT_CMDHELP_VSTATUS,
  	    "VSTATUS <d#>: show volume status\n",
            "vstatus <disc number>\n"},
{TEXT_CMDHELP_LSTATUS,
	    "LSTATUS [<path>]: show logical drive status\n",
            "lstatus [<path>]\n"\
            "  path = 0:,1:,A:,B:...for JADOS and HDA0:, HDA1: .. for FAT drives\n"},            
{TEXT_CMDHELP_FOPEN,
	    "FOPEN <file> <mode>: open a file\n",
            "fopen <file> <mode>\n"\
            " mode:\n"\
            "    read           r\n"\
            "    write          w\n"\
            "    append         a\n"\
            "    binary         b\n"\
            "    text/ascii     t\n"\
	    "    update         +\n"},
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
            "mkptable <pd#> <size1> <size2> <size3> <size4>\n"},  
{TEXT_CMDHELP_PTABLE,
	    "PTABLE <pd#>  - show partition table of physical drive pd# \n",
            "ptable <pd#>\n"\
	    "  example:\n"\
	    "     ptable hda\n"},                      
{TEXT_CMDHELP_PWD,
	    "PWD: print working directory\n",
            "pwd\n"},           
{TEXT_CMDHELP_QUIT,             
                        "QUIT: quit/exit program\n",
                        "quit\n"},                 
{TEXT_CMDHELP,
			"type cmd /? for more information on cmd\n",""},        
        {0,"",""}
};


// list of available commands ...
struct CMD internalCommands[] =
{
  {"CLS"        , cmd_cls       , TEXT_CMDHELP_CLS},
  {"DINIT"      , cmd_dinit     , TEXT_CMDHELP_DI},  
  {"DDUMP"      , cmd_ddump     , TEXT_CMDHELP_DD},
  {"DSTATUS"    , cmd_dstatus   , TEXT_CMDHELP_DS},
  {"BDUMP"      , cmd_bdump     , TEXT_CMDHELP_BD},
  {"BEDIT"      , cmd_bedit     , TEXT_CMDHELP_BE},
  {"BREAD"      , cmd_bread     , TEXT_CMDHELP_BR},
  {"BWRITE"     , cmd_bwrite    , TEXT_CMDHELP_BW},
  {"BFILL"      , cmd_bfill     , TEXT_CMDHELP_BF}, 
  {"VMOUNT"     , cmd_vmount    , TEXT_CMDHELP_VMOUNT},
  {"VUMOUNT"    , cmd_vumount   , TEXT_CMDHELP_VUMOUNT},
  {"VSTATUS"    , cmd_vstatus   , TEXT_CMDHELP_VSTATUS},
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

LONGLONG AccSize;			/* Work register for scan_fat_files() */
char drive[5],path[255],filename[20], ext[10], fname[30], fullname[320], filepath[255], fullpath[255], *pname; /* work register for split_filename() -> */

WORD AccFiles, AccDirs;
BYTE Buff[262144];			/* Working buffer */

extern char CurrDirPath[300];		/* shell.c */
extern char CurrDrive[MAX_CHAR];	/* shell.c */
//extern BYTE CurrFATDrive;		/* shell.c */

// ---
FILE* file[2];				/* Pointer to File objects */

static const char* const _FAT_DISK_STRS[] = {_DISK_STRS};  // "HDA","HDB","HDC","HDD"
static const char* const _FAT_VOL_STRS[] = {_VOLUME_STRS};  // "HDA0","HDA1","HDA2","HDA3"

/*---------------------------------------------------------*/
/* Helper Functions                                        */
/*---------------------------------------------------------*/
const char *p_rc_code =
		"OK\0DISK_ERR\0INT_ERR\0NOT_READY\0NO_FILE\0NO_PATH\0INVALID_NAME\0"
		"DENIED\0EXIST\0INVALID_OBJECT\0WRITE_PROTECTED\0INVALID_DRIVE\0"
		"NOT_ENABLED\0NO_FILE_SYSTEM\0MKFS_ABORTED\0TIMEOUT\0LOCKED\0"
		"NOT_ENOUGH_CORE\0TOO_MANY_OPEN_FILES\0INVALID_PARAMETER\0NO_DRIVER\0";
		
const char *p_fat_types =
		"FAT12\0FAT16\0FAT32\0";

char* get_rc_string(FRESULT rc)
{
        FRESULT i;
	char *p = p_rc_code;

	for (i = 0; i != rc && *p; i++) {
		while(*p++) ;
	}
	
	return p;
}

char* get_fattype_string(UCHAR type)
{
        FRESULT i;
	char *p = p_fat_types;

	for (i = 0; i != type && *p; i++) {
		while(*p++) ;
	}
	
	return p;
}

		
void put_rc (FRESULT rc)
{		
	printf("rc=%u FR_%s\n", (UINT)rc, get_rc_string(rc));
}


FRESULT scan_fat_files (	/* used in cmd_lstatus */
	char* ppath		/* Pointer to the path name working buffer */
)
{
	DIR dir;
	FRESULT res;
	FILINFO Finfo;			/* File info object */
	int i;
	char *fn;
	struct ioctl_opendir arg_opendir;
	struct ioctl_readdir arg_readdir;
	
	split_filename(ppath, drive, path, filename, ext, fullname, filepath, fullpath); // analyze args
	
	//printf("scan_fat_files: path[%s] drive[%s] fullpath[%s]\n",ppath,drive,fullpath);
   
	arg_opendir.dp = &dir;
	arg_opendir.path = fullpath;	
	arg_readdir.dp = &dir;
	arg_readdir.fno = &Finfo;
	
	//if ((res = ioctl(CurrDrive,FAT_IOCTL_OPEN_DIR,&arg_opendir)) == FR_OK) {
	if ((res = ioctl(drive,FAT_IOCTL_OPEN_DIR,&arg_opendir)) == FR_OK) {
		i = strlen(fullpath);
		
		while (((res = ioctl(drive,FAT_IOCTL_READ_DIR,&arg_readdir)) == FR_OK) && Finfo.fname[0]) {
			if (_FS_RPATH && Finfo.fname[0] == '.') continue;
#if _USE_LFN
			fn = *Finfo.lfname ? Finfo.lfname : Finfo.fname;
#else
			fn = Finfo.fname;
#endif
			if (Finfo.fattrib & AM_DIR) {
				AccDirs++;
				*(fullpath+i) = '/'; strcpy(fullpath+i+1, fn);
				res = scan_fat_files(fullpath);
				*(fullpath+i) = '\0';
				if (res != FR_OK) break;
			} else {
//				printf("%s/%s\n", ppath, fn);
				AccFiles++;
				AccSize += Finfo.fsize;
			}
		}
		res = ioctl(drive,FAT_IOCTL_CLOSE_DIR,&dir);
	}

	return res;
}

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

// implementation of commands ...


// ****************** high level filesystem (fat) commands.... *************************************

int cmd_cls (void){
  nkc_clrscr();
  return 0;
}

// calls via ioctl (start) -------
int cmd_pwd    (char * args){
   FRESULT res;
   struct ioctl_get_cwd arg;
   
   arg.cpath = CurrDirPath;
   arg.cdrv  = CurrDrive;
   arg.size = 256;
   res = ioctl(NULL,FS_IOCTL_GETCWD,&arg);

   if (res) {
	put_rc(res);
   } else {	
	printf("%s:%s\n",CurrDrive,CurrDirPath);	
   }
          
   return res;
} 


int cmd_chmod(char* args) {
   /* fa <atrr> <mask> <name> - Change file/dir attribute */
   long p1,p2;
   struct ioctl_chmod arg;
   FRESULT res;
   
   if (!xatoi(&args, &p1) || !xatoi(&args, &p2)) return 0;
   while (*args == ' ') args++;
   
   split_filename(args, drive, path, filename, ext, fullname, filepath, fullpath); // analyze args 
   
   arg.value = (BYTE)p1;	/* Attribute bits */
   arg.mask  = (BYTE)p2,	/* Attribute mask to change */
   arg.fpath = fullpath;	/* Pointer to the full file path */
   
   res = ioctl(CurrDrive,FS_IOCTL_CHMOD,&arg);
   
   if(res != RES_OK)   put_rc(res);
   
   return 0;
}


int cmd_chdrive(char * args){
/* Change current drive */
/* JADOS drives = A,B,C.....Z
 * FAT drives = HDA0,HDB1,HDC0 .... 
 */
   FRESULT res;
   struct ioctl_get_cwd arg;
   
   if(!args) return EINVAL;
   
   while (*args == ' ') args++;
  
   res = ioctl(NULL,FS_IOCTL_CHDRIVE,args); 
   ioctl(NULL,FS_IOCTL_GETDRV,CurrDrive);
   
   arg.cpath = CurrDirPath;
   arg.cdrv  = CurrDrive;
   arg.size = 256;
   res = ioctl(NULL,FS_IOCTL_GETCWD,&arg);
   
   if(res != RES_OK) put_rc(res);
         
   return 0;
}

int cmd_chdir(char *args)
{
   FRESULT res;
   struct ioctl_get_cwd arg;
   
   
   
   while (*args == ' ') args++;  
   
   split_filename(args, drive, path, filename, ext, fullname, filepath, fullpath); // analyze args
   
   printf(" cd [%s]\n",filepath);
   
   res = ioctl(CurrDrive,FS_IOCTL_CD,filepath);
   if(res != RES_OK) put_rc(res);   
   
   arg.cpath = CurrDirPath;
   arg.cdrv = CurrDrive;
   arg.size = 256;
  res = ioctl(NULL,FS_IOCTL_GETCWD,&arg); // no device name needed
   
   if(res != RES_OK) put_rc(res);
   
   return 0;
}


int cmd_dir(char *args) // ...
{
  int i;
  FRESULT res;
  
  while (*args == ' ') args++;
  
  split_filename(args, drive, path, filename, ext, fullname, filepath, fullpath); // analyze args 
    
  printf(" dir [%s] ... \n",drive);
  if( !drive[1] ) { // one character drive name -> is it a JADOS drive ?
    if( (drive[0] >= 'A' && drive[0] <= 'Z') ||  // JADOS hard drive
	//(drive[0] >= 'a' && drive[0] <= 'z') ||
        (drive[0] >= '0' && drive[0] <= '3') ){  // JADOS floppy drive
	  res = cmd_dir_nkc(fullpath,drive);
	  if(res) printf(" cmd_dir_nkc returned '%s'\n",get_rc_string(res));
	  return 0;
    }else{  //invalid drive name
	  printf(" invalid drive name (%s)\n",drive);
	  return 0;//EINVAL;
    }
  }else{ // give it to the fat driver
    
    res = cmd_dir_fat(fullpath,drive);
    if(res) printf(" cmd_dir_fat returned '%s'\n",get_rc_string(res));
    return 0;
  }
      
}

int cmd_dir_nkc(char *args, 		// arguments
		char* pd		// drive 
	       ) // NKC/JADOS dir
{
  //printf(" DIR command not implemented for JADOS/NKC file system yet !\n");
  
  FRESULT res;
  struct ioctl_nkc_dir arg;
  char buffer[256*4+1];
  //char pattern = "Q:*.txt"; // FIX: pattern can be overwritten by given args...
  
  arg.attrib = 7; // show all types of files
  arg.cols = 2;   // format output in 2 columns
  arg.size = 256*4; // maximum buffer size for full directory
  arg.pbuf = buffer;
  arg.ppattern = args;
  
  printf(" pattern to jados [%s]\n", args);	
  
  res = ioctl(pd,NKC_IOCTL_DIR,&arg); // fetch directory using JADOS function call

  //          14          7     10	  2+6
  printf("File-Name     Size   Date      Flags File-Name     Size   Date      Flags\n\n");
  
  printf(buffer);
  printf("\n\n JADOS/NKC filesystem     ");
  
  put_rc(res);
  
  return EZERO;
}

int cmd_dir_fat(char *args, char* pd) // FAT dir
{
   /* dir [<path>] - Directory listing */
   
   DIR dir;				/* FAT Directory object */
   FILINFO Finfo;			/* File info object */
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
   
   res = ioctl(pd,FAT_IOCTL_OPEN_DIR,&arg_opendir);
   
   if (res) { put_rc(res); return 0; }
   AccSize = s1 = s2 = 0;
   
   printf("Attr.    Date    Time      Size   File-Name\n\n");
   
   for(;;) {
        arg_readdir.dp = &dir;
	arg_readdir.fno = &Finfo;
	res = ioctl(pd,FAT_IOCTL_READ_DIR,&arg_readdir);
	
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
   res = ioctl(pd,FAT_IOCTL_CLOSE_DIR,&dir);
   printf("%4u File(s),%11llu bytes total\n%4u Dir(s)", s1, AccSize, s2);     
   
   arg_getfree.path = args;
   arg_getfree.nclst = (DWORD*)&p1;
   arg_getfree.ppfatfs = &fs;   
   if(ioctl(pd,FAT_IOCTL_GET_FREE,&arg_getfree) == FR_OK)
   printf(",%12llu bytes free\n", (LONGLONG)p1 * fs->csize * 512);
   
   return 0;
}



int cmd_mkdir(char *args)
{
  
   FRESULT res;
  
   while (*args == ' ') args++;
   res = ioctl(CurrDrive,FAT_IOCTL_MKDIR,args);
   if(res != RES_OK) put_rc(res);
   
   return 0;
}

int cmd_rmdir(char *args)
{
  
   FRESULT res;    
   
  
   printf(" RMDIR called ...\n"
          "    args: %s\n", args);
   
   while (*args == ' ') args++;
   res = ioctl(CurrDrive,FAT_IOCTL_UNLINK,args);
   if(res != RES_OK) put_rc(res);
   
   return 0;
}

int cmd_rename(char *args)
{
   char * ptr2;
   char fullpath2[200];
   FRESULT res; 
   struct ioctl_rename arg_rename;
   
   while (*args == ' ') args++;	// skip whitespace
   ptr2 = strchr(args, ' ');	// look for 2nd argument
   if (!ptr2) return 0;		// not given -> return
   *ptr2++ = 0;			// terminate 1st argumennt and increment pointer to 2nd argument
   while (*ptr2 == ' ') ptr2++; // skip whitespace
   
   split_filename(args, drive, path, filename, ext, fullname, filepath, fullpath); // analyze 1st argument
   split_filename(ptr2, drive, path, filename, ext, fullname, filepath, fullpath2); // analyze 2nd argument
   
   arg_rename.path_old = fullpath;
   arg_rename.path_new = fullpath2;   
   res = ioctl(CurrDrive,FS_IOCTL_RENAME,&arg_rename);
   if(res != RES_OK) put_rc(res);
   
   return 0;
}

int cmd_del(char *args) {
   /* del <name> - delete a file */
   FRESULT res; 
   while (*args == ' ') args++;
   
   split_filename(args, drive, path, filename, ext, fullname, filepath, fullpath); // analyze args
   
   res = ioctl(CurrDrive,FS_IOCTL_DEL,&fullpath);
   if(res) put_rc(res);
   
   return 0;
}
// calls via ioctl (end) -------

// standard clib calls (start) -----

int cmd_copy(char *args)
{
   FRESULT res;
   char *ptr2;
   char drive2[10];
   char fullpath2[255];
   long p1;
   UINT s1,s2;
       
   printf("cmd_copy(%s):\n",args);
   
   while (*args == ' ') args++;	// skip whitespace
   ptr2 = strchr(args, ' ');	// search 2nd parameter
   if (!ptr2) return 0;		// no 2nd par -> return
   *ptr2++ = 0;			// terminate 1st par and increment pointer to next par
   while (*ptr2 == ' ') ptr2++; // skip whitespace
   
   
   split_filename(args, drive, path, filename, ext, fullname, filepath, fullpath); // analyze 1st argumennt
   split_filename(ptr2, drive2, path, filename, ext, fullname, filepath, fullpath2); // analyze 2nd argumennt
   
   printf("Opening \"%s\"\n", fullpath);
   //                                0x00		0x01
   //res = f_open(&file[0], args, FA_OPEN_EXISTING | FA_READ);
   file[0] = fopen(fullpath,"rb");
   
   if (file[0]==NULL) {
      printf("error opening file !\n");
      return 0;
   }
   printf("Creating \"%s\"\n", fullpath2);
   //                                  0x08		0x02
   //res = f_open(&file[1], ptr2, FA_CREATE_ALWAYS | FA_WRITE);
   file[1] = fopen(fullpath2,"wb");
   printf("\n");
   if (file[1]==NULL) {
     fclose(file[0]);
     printf("error creating file !\n");
     return 0;
   }
   printf("Copying...");
   p1 = 0;
   for (;;) {
     //res = f_read(&file[0], Buff, sizeof Buff, &s1);
     s1 = fread(Buff, 1, sizeof Buff, file[0]); 
     if (s1 == 0) {
       //printf("eof !\n");
       break;   /* error or eof */
     }
     //res = f_write(&file[1], Buff, s1, &s2);
     s2 = fwrite(Buff, 1, s1, file[1]); 
     p1 += s2;
     if (s2 < s1) {
       //printf("error or disk full !\n");
       break;   /* error or disk full */
     }
   }
   printf("\n");
   if (res) put_rc(res);
   fclose(file[0]);
   fclose(file[1]);
   printf("%lu bytes copied.\n", p1);
   return 0;
}

int cmd_fopen  (char * args){
  /* fopen <file> <mode> - Open a file (OK) */
   
   char *mode;
   
   
   while (*args == ' ') args++;
   mode = strchr(args, ' ');
   if (!mode) 
   {
     printf("missing mode...\n");
     return 0;
   }
   *mode++ = 0;
   while (*mode == ' ') mode++;
   
   split_filename(args, drive, path, filename, ext, fullname, filepath, fullpath); // analyze 1st argumennt
   
   printf(" fopen %s %s\n",fullpath,mode);
     
   file[0] = fopen(fullpath,mode);
   
   if(file[0]) printf(" file %s opened in mode %s\n",fullpath,mode);
   else printf(" error opening file %s in mode %s\n",fullpath,mode);
   
   return 0;
} 
int cmd_fclose (char * args){    
   fclose(file[0]);
   return 0;
} 
int cmd_fseek  (char * args){
   /* fe <ofs> - Seek file pointer */
   long p1;
   FRESULT res;
   
   if (!xatoi(&args, &p1)) return 0;
   res = fseek(file[0],p1,SEEK_CUR); // seek p1 bytes from the current position
   if(res) put_rc(res);   
   
   return 0;
} 


int cmd_fdump  (char * args){
   long p1;
   UINT cnt;
   DWORD ofs = 0;
   FRESULT res;
   
   if (!xatoi(&args, &p1)) p1 = 128;
   //ofs = file[0].curp - file[0].buffer;
   
   while (p1) {
     if ((UINT)p1 >= 16) { cnt = 16; p1 -= 16; }
     else	{ cnt = p1; p1 = 0; }
     //res = f_read(&file[0], Buff, cnt, &cnt);
     cnt = fread(Buff, 1, cnt, file[0]); res = RES_OK;
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
   struct ioctl_read_write arg;
   
   if (!xatoi(&args, &p1)) return 0;
   p2 =0;
   while (p1) {
    if ((UINT)p1 >= sizeof Buff) {
	cnt = sizeof Buff; p1 -= sizeof Buff;
    } else {
	cnt = p1; p1 = 0;
    }
    //res = f_read(&file[0], Buff, cnt, &s2);
    arg.fp = &file[0];
    arg.pbuf = Buff;
    arg.size = cnt;
    arg.count = &s2;
    res = ioctl(CurrDrive,FAT_IOCTL_READ,&arg);
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
   struct ioctl_read_write arg;
   
   if (!xatoi(&args, &p1) || !xatoi(&args, &p2)) return 0;
   memset(Buff, (BYTE)p2, sizeof Buff);
   p2 = 0;
   while (p1) {
	if ((UINT)p1 >= sizeof Buff) { cnt = sizeof Buff; p1 -= sizeof Buff; }
	else 				  { cnt = p1; p1 = 0; }
	//res = f_write(&file[0], Buff, cnt, &s2);
	arg.fp = &file[0];
	arg.pbuf = Buff;
	arg.size = cnt;
	arg.count = &s2;
	res = ioctl(CurrDrive,FAT_IOCTL_WRITE,&arg); 
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
   
   //printf("dinit ...\n"); getchar();
   
   
   if (!xatoi(&args, &p1)) {
    printf(" error in args\n");
    return 0;
   }
   
   
   				
   //printf(" Initialize drive %d ....",(BYTE)p1); getchar();				
   //res = disk_initialize((BYTE)p1);   
   res = ioctl(CurrDrive,FAT_IOCTL_DISK_INIT,p1);  
   put_rc(res);				
   
   //if (disk_ioctl((BYTE)p1, GET_SECTOR_SIZE, &w) == RES_OK)
   //printf(" get sector size...\n"); getchar();
   if (ioctl(CurrDrive, FAT_IOCTL_DISK_GET_SECTOR_SIZE, &w) == RES_OK)
	printf(" Sector size = %u\n", w);
   //printf(" get sector count...\n"); getchar();
   //if (disk_ioctl((BYTE)p1, GET_SECTOR_COUNT, &dw) == RES_OK)
   if (ioctl(CurrDrive, FAT_IOCTL_DISK_GET_SECTOR_COUNT, &dw) == RES_OK)
	printf(" Number of sectors = %u\n", dw);
       
   return 0;
}

// Disk Drive Status
int cmd_dstatus(char * args){
  
   long p1;
   char *ptr;
   FRESULT res;
   struct _deviceinfo di;
   
   printf("Disk Drive Status:\n");
   printf("==================\n");
   
    if (!xatoi(&args, &p1)) {
    printf(" error in args\n");
    return 0;
   }
   
   res = ioctl(CurrDrive, FAT_IOCTL_GET_DISK_DRIVE_STATUS, &di);  
   
   if(res != RES_OK){
     put_rc(res);
     return 0;
   }
			
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
		
   put_rc(res);
			        
   return 0;
} 


int cmd_ddump  (char * args){

   long p1,p2;
   BYTE *buf;
   int res;
   WORD w;
   struct ioctl_disk_read ioctl_args;
   DWORD ofs = 0, sect = 0, drv = 0; 
   
   
   if (!xatoi(&args, &p1)) {
	p1 = drv; p2 = sect;
   } else {
	if (!xatoi(&args, &p2)) return 0;
   }
   //res = disk_read((BYTE)p1, Buff, p2, 1);
  
   p1 = drv;
   ioctl_args.drv = p1;;
   ioctl_args.buff = Buff;
   ioctl_args.sector = p2;
   ioctl_args.count = 1;   
   res = ioctl(CurrDrive, FAT_IOCTL_DISK_READ, &ioctl_args);
   if (res) { printf("rc=%d\n", (WORD)res); return 0; }
   printf("Drive:%u Sector:%lu\n", p1, p2);
   //if (disk_ioctl((BYTE)p1, GET_SECTOR_SIZE, &w) != RES_OK) return 0;
   if (ioctl(CurrDrive, FAT_IOCTL_DISK_GET_SECTOR_SIZE, &w) != RES_OK) return 0;
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



/*
  
  https://support.microsoft.com/en-us/kb/314878
  
   The FAT file system uses the following cluster sizes. These sizes apply to any operating system that supports FAT:

   Drive size            
   (logical volume)      FAT type   Sectors     Cluster size
   -----------------------------------------------------------------------
       15 MB or less     12-bit       8           4 KB ( 8 x 512Bytes, i.e. 8 sectors... )
       16 MB - 127 MB    16-bit       4           2 KB
      128 MB - 255 MB    16-bit       8           4 KB
      256 MB - 511 MB    16-bit      16           8 KB
      512 MB - 1,023 MB  16-bit      32          16 KB
    1,024 MB - 2,048 MB  16-bit      64          32 KB
    2,048 MB - 4,096 MB  16-bit     128          64 KB
   *4,096 MB - 8,192 MB  16-bit     256         128 KB Windows NT 4.0 only
   *8,192 MB - 16384 MB  16-bit     512         256 KB Windows NT 4.0 only 

   To support FAT partitions that are greater than 4 GB using 128- or 256-KB clusters, the drives must use sectors that are greater than 512 bytes.

Note that on very small FAT partitions, a 12-bit FAT is used instead of a 16-bit FAT. The FAT file system supports only 512-byte sectors, so both the sectors per cluster and the cluster size are fixed. 

*/

int cmd_mkfs   (char * args){
   /* 
     mkfs <ld#> <partition rule> <cluster size> - Create file system in logical drive/partition ld#
   
    Cluster Siz in Bytes.The value must be sector size * n (n is 1 to 128 and power of 2 - 1,2,4,8,16 ...)
    Partitioning rule 0:FDISK (create an FS in a partition), 1:SFD (create only one primary partition starting at the first sector of the PHYSICAL disk 
     */   
   long p1,p2,p3;
   char *ptr;
   int res;
   char tmp[5];
   struct ioctl_mkfs ioctl_args;
   
   if (!xatoi(&args, &p1) || (UINT)p1 > 9 || !xatoi(&args, &p2) || !xatoi(&args, &p3)) return 0;
   printf("The volume will be formatted. Are you sure? (Y/n)=");
   gets(ptr = tmp);
   //get_uni(ptr, 256);
   if (*ptr != 'Y') return 0;
   sprintf(ptr, "%u:", (UINT)p1);
   //put_rc(f_mkfs(ptr, (BYTE)p2, (UINT)p3));  
   ioctl_args.pdrv = ptr;
   ioctl_args.au = p2;
   ioctl_args.sfd = p3;
   res = ioctl(CurrDrive, FAT_IOCTL_MKFS, &ioctl_args);
   put_rc(res);
   return 0;
}




int cmd_mkptable (char * args) {
   /* fp <pd#> <size1> <size2> <size3> <size4> - Create partition table */
   DWORD pts[4];
   long p1;
   char *ptr;
   int res;
   char tmp[10];
   struct ioctl_mkptable ioctl_args;
   
   #if _MULTI_PARTITION
   if (!xatoi(&args, &p1)) return 0;
   xatoi(&args, &pts[0]);
   xatoi(&args, &pts[1]);
   xatoi(&args, &pts[2]);
   xatoi(&args, &pts[3]);
   printf("The physical drive %u will be re-partitioned. Are you sure? (Y/n)=", p1);
   gets(ptr = tmp);
   if (*ptr != 'Y') return 0;
   //put_rc(f_fdisk((BYTE)p1, pts, Buff));
   ioctl_args.drv = p1;
   ioctl_args.szt = pts;
   ioctl_args.work = Buff;
   res = ioctl(CurrDrive, FAT_IOCTL_MKPTABLE, &ioctl_args);
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


int cmd_ptable(char * args) { // args = "HDA", "HDB" etc.
  BYTE *p;
  long p1;
  UINT i;
  struct ioctl_disk_read ioctl_args;
  FRESULT res;
  char* pc;
  
  while (*args == ' ') args++;  
  
  pc=args;
  
  while(*pc){			// convert to uppercase
    *pc = toupper(*pc);
    pc++;
  }
  
  
  for(p1=0; p1<_DISKS; p1++) {
    if(strcmp(args,_FAT_VOL_STRS[p1])) break;
  }
  
  if(p1 == _DISKS) {
    printf("bad argument\n");
    return 0;
  }
  		   
   ioctl_args.buff = Buff;
   ioctl_args.sector = 0;
   ioctl_args.count = 1;   
   res = ioctl(p1, FAT_IOCTL_DISK_READ, &ioctl_args);
   
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

int cmd_vmount (char * args){
   /* fmount <#pd> <ld#> [<0|1>] - Force initialized the logical drive (1=mount now, 0=mount later)*/
   long p1,p2,p3;
   FRESULT res;
   char *tmp[10];
   FATFS *pfs;
   struct ioctl_mount_fatfs mount_args;
   struct ioctl_get_cwd get_cwd_args;
   struct ioctl_getfatfs get_fatfs_args;
   
   
   if(args[0] == 0)  // list mounted partitions ....
   {
     list_drivers();
     
     for(p1=0; p1<4; p1++)
     {
	get_fatfs_args.drv = 0;
	get_fatfs_args.ldrv = p1;
	get_fatfs_args.ppfs = &pfs;
	res = ioctl(_FAT_DISK_STRS[0],FAT_IOCTL_GET_FATFS,&get_fatfs_args);
	
	if(res== RES_OK)
	{
	   printf(" volume s% mounted (%s)\n",_FAT_VOL_STRS[p1],(pfs->fs_type));
	}			
	
     }
     
     return 0;
   }
   
   
   // physical drive -> p1
   if (!xatoi(&args, &p1) || (UINT)p1 > 4){
     printf(" error in args.\n");
     return 0;
   }   
   
   // locical drive/partition -> p2
   if (!xatoi(&args, &p2) || (UINT)p2 > 9){
     printf(" error in args.\n");
     return 0;
   }   
   
   // option -> p3
   if (!xatoi(&args, &p3)) p3 = 0;
   
   mount_args.drv = p1;
   mount_args.ldrv = p2;
   mount_args.opt = p3;
   res = ioctl(_FAT_DISK_STRS[p1], FAT_IOCTL_MOUNT, &mount_args); // use driver for first fat drive "hda"
   put_rc(res);
   
   return 0;
} 

int cmd_vumount (char * args){
   /* fmount <ld#>  - unmount drive ld#*/
   long p1;
   FRESULT res;
   char tmp[10];
   struct ioctl_get_cwd arg;
   
   if (!xatoi(&args, &p1) || (UINT)p1 > 9){
     printf(" error in args.\n");
     return 0;
   }
   //sprintf(tmp, "%d:", p1);
   //put_rc(f_mount(NULL, tmp, 0));
   
   res = ioctl(CurrDrive, FAT_IOCTL_UMOUNT, p1);
   put_rc(res);
   
   //res = f_getcwd(CurrDirPath, 256); /* update current drive,path */
   
   arg.cpath = CurrDirPath;
   arg.cdrv = CurrDrive;
   arg.size = 256;
   res = ioctl(CurrDrive,FAT_IOCTL_GETCWD,&arg); // no device name needed
   	      
   return 0;
} 
// Volumes File System Status
int cmd_vstatus(char * args){

   long p1;
   FATFS *pfs;
   FRESULT res;
   struct ioctl_getfatfs arg;
   
   printf("Volumes File System Status:\n");
   
   if (!xatoi(&args, &p1)) {
    printf(" error in args\n");
    return 0;
   }
   
   arg.drv = 0;
   arg.ldrv = p1;
   arg.ppfs = &pfs;
   res = ioctl(_FAT_DISK_STRS[0],FAT_IOCTL_GET_FATFS,&arg);
   
   if( res != RES_OK) { printf("drive not ready.\n"); return 0; }
   
   if (!pfs->fs_type) { printf("Not mounted.\n"); return 0; }
   
   printf("FAT type = %u\nBytes/Cluster = %lu\n"
	  "Root DIR entries = %u\nNumber of clusters = %lu\n"
	  "FAT start (lba) = %lu\nDIR start (lba,clustor) = %lu\nData start (lba) = %lu\n\n",
		 (BYTE)(pfs->fs_type),
		 (DWORD)(pfs->csize) * 512,
		 pfs->n_rootdir, (DWORD)(pfs->n_fatent) - 2,
		 pfs->fatbase, pfs->dirbase, pfs->database );
				          
   return 0;
}


// Logical Drive Status
// lstatus hda0: hda1: etc.
int cmd_lstatus(char *args) // ...
{
  int i;
  FRESULT res;
    
  while (*args == ' ') args++;
  
  split_filename(args, drive, path, filename, ext, fullname, filepath, fullpath); // analyze args 
    
  printf(" lstatus [%s] ... \n",drive);
  if( !drive[1] ) { // one character drive name -> is it a JADOS drive ?
    if( (drive[0] >= 'A' && drive[0] <= 'Z') ||  // JADOS hard drive
	//(drive[0] >= 'a' && drive[0] <= 'z') ||
        (drive[0] >= '0' && drive[0] <= '3') ){  // JADOS floppy drive
	  res = cmd_lstatus_nkc(drive);	  
	  return 0;
    }else{  //invalid drive name
	  printf(" invalid drive name (%s)\n",drive);
	  return 0;//EINVAL;
    }
  }else{ // give it to the fat driver
    
    res = cmd_lstatus_fat(drive);
    if(res) printf(" cmd_lstatus_fat returned '%s'\n",get_rc_string(res));
    return 0;
  }
      
}

int cmd_lstatus_nkc(char * args){
  printf(" command not implemented for jados drives...\n");
  return 0;
}

int cmd_lstatus_fat(char * args){
  struct ioctl_opendir arg_opendir;
  struct ioctl_readdir arg_readdir;
  struct ioctl_getfree arg_getfree;
  struct ioctl_getlabel arg_getlabel;
  
  char * ptr2;
  char tmp[10];
  
  DWORD dw;
  FRESULT res;
  char pool[50];
  long p1,p2,p3;
  FATFS *fs;				/* Pointer to file system object */
  static const BYTE ft[] = {0, 12, 16, 32};
  
  while (*args == ' ') args++;
  strcpy(tmp,args);
  strcat(tmp,":");
  
  //printf("cmd_lstatus_fat [%s]\n",tmp);
  
  ptr2 = args;
#if _FS_READONLY 
  arg_opendir.dp = &dir;
  arg_opendir.path = tmp;     
  res = ioctl(args,FAT_IOCTL_OPEN_DIR,&arg_opendir);
  if (res) {
     printf(" Error OpenDir: %d (%s)\n", res, get_rc_string(res));
     fs = dir.fs;
     res = ioctl(args,FAT_IOCTL_CLOSE_DIR,&dir);
     if (res) {
	printf(" Error CloseDir: %d (%s)\n", res, get_rc_string(res));
     }
     return 0;
  }
#else      
  arg_getfree.path = tmp;
  arg_getfree.nclst = (DWORD*)&p1;
  arg_getfree.ppfatfs = &fs;   
  res = ioctl(args,FAT_IOCTL_GET_FREE,&arg_getfree);
  if (res) { 
    printf(" Error GetFree: %d (%s)\n", res, get_rc_string(res));
    return 0;     
  }   
#endif
  
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
  arg_getlabel.pldrv = ptr2;
  arg_getlabel.plabel = pool;
  arg_getlabel.psn = &dw;
  res = ioctl(args,FAT_IOCTL_GET_VLABEL,&arg_getlabel);
  if (res) { 
    printf(" Error GetVLabel: %d (%s)\n", res, get_rc_string(res));
    return 0;     
  }
  printf(pool[0] ? "Volume name is %s\n" : "No volume label\n", arg_getlabel.plabel);
  printf("Volume S/N is %04X-%04X\n", dw >> 16, dw & 0xFFFF);
#endif
  printf("...");
  AccSize = AccFiles = AccDirs = 0;
  res = scan_fat_files(tmp);
  if (res) { 
    printf(" Error ScanFatFiles: %d (%s)\n", res, get_rc_string(res));
    return 0;     
  }
  p2 = (fs->n_fatent - 2) * fs->csize;
  p3 = p1 * fs->csize;
#if _MAX_SS != 512
  p2 *= fs->ssize / 512;
  p3 *= fs->ssize / 512;
#endif
  p2 /= 2;
  p3 /= 2;
  printf("\r%u files, %llu bytes.\n%u folders.\n%lu KiB total disk space.\n",
	  AccFiles, AccSize, AccDirs, p2);
#if !FS_READONLY
  printf("%lu KiB available.\n", p3);
#endif

  return 0;
}

int cmd_vlabel (char * args){
   /* flabel <name> - Set volume label */
   FRESULT res;
   while (*args == ' ') args++;
   //put_rc(f_setlabel(args));         
   res = ioctl(CurrDrive,FAT_IOCTL_SET_VLABEL,args);
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
   char tmp[10];
   
   if (!xatoi(&args, &p1)) return 0;
   
   if (xatoi(&args, &p2)) {
	do {
	 Buff[p1++] = (BYTE)p2;
	} while (xatoi(&args, &p2));
	return 0;
   }
   
   for (;;) {
	printf("%04X %02X-", (WORD)(p1), (WORD)Buff[p1]);
	gets(ptr = tmp);
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


// not implemented:
/* fE - Enable fast seek and initialize cluster link map table */
/* ft <year> <month> <day> <hour> <min> <sec> <name> - Change timestamp of a file/dir */


int cmd_quit(char *args)
{
   printf(" QUIT called ...\n"
          "    args: %s\n", args);
   
   return 1;
}

