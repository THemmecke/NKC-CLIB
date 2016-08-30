#include <stdlib.h>
#include <string.h>
#include <ioctl.h>
#include <errno.h>

#include <fs.h>
#include <ff.h>
#include <gide.h>

//#include <conio.h>

#include "cmd.h"
#include "shell.h"

#include "gdp.h"

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
#define TEXT_CMDHELP_MOUNT              19
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
#define TEXT_CMDHELP_UMOUNT             34
#define TEXT_CMDHELP_PTABLE             35
#define TEXT_CMDHELP_CLS             	36
#define TEXT_CMDHELP_FSTAB		37
#define TEXT_CMDHELP_FS    		38
#define TEXT_CMDHELP_DEV		39
#define TEXT_CMDHELP_FATINFO		40
#define TEXT_CMDHELP_MEMINFO		41
#define TEXT_CMDHELP_HISTORY		42

#define TEXT_CMDHELP                    43

// TEST commands ...
#define	TEXT_CMDHELP_SP			44
#define	TEXT_CMDHELP_FILL		45
#define	TEXT_CMDHELP_TEST		46

// Help text ... 
struct CMDHLP hlptxt[] =
{
{TEXT_CMDHELP_CLS,              
                        "CLS: clear screen\n",
                        "cls \n"},	
{TEXT_CMDHELP_FSTAB,              
                        "FSTAB: show file system table\n",
                        "fstab \n"},
{TEXT_CMDHELP_FS,              
                        "FS: show registered file system\n",
                        "fs \n"},
{TEXT_CMDHELP_FATINFO,              
                        "FATINFO: show info about FAT file system\n",
                        "fatinfo \n"},
{TEXT_CMDHELP_DEV,              
                        "DEV: show registered devices\n",
                        "dev \n"},
{TEXT_CMDHELP_MEMINFO,              
                        "MEMINFO: show availabe memory\n",
                        "meminfo \n"},
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
            "dinit <disc name>\n"\
            "  disc name is HDA, HDB, SDA, SDB ... without':' !\n"},
{TEXT_CMDHELP_DD,
	    "DDUMP [<d#> <sec#>]: dump sector\n",
            "ddump [<d#> <sec#>]\n"\
            "  dump sector sec# of disc d#\n"\
            "  first disc is #0\n"},
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
{TEXT_CMDHELP_MOUNT,
	    "MOUNT <vol> <fs> <opt>: initialize/mount volume \n",
            "mount <vol> <fs> <opt>\n"\
            "   vol = HDA0,HDA1 ...\n"\
            "   fs = FAT32,JADOS ...\n"\
            "   opt = r,w,rw\n"\
	    "   mount only shows mounted volumes\n"},
{TEXT_CMDHELP_UMOUNT,
	    "UMOUNT <vol>: unmount volume\n",
            "umount <vol>  \n"\
            "   vol = HDA0,HDA1 ...\n"},            
{TEXT_CMDHELP_VSTATUS,
  	    "VSTATUS <vol>: show info of volumes FATFS structure\n",
            "vstatus <volume>\n"\
            "   - volume must be mounted.\n"\
            "   - info: FAT Type, FAT Start, DIR start, Data Start,\n"\
	    "           Root DIR entries, number of clusters\n"},	    
{TEXT_CMDHELP_LSTATUS,
	    "LSTATUS [<path>]: info on FS(FAT..) structure in current directory on current media\n",
            "lstatus [<path>]\n"\
            "    - info: FAT Type, Number of FATs, ClusterSize in sectors and bytes,\n"\
            "            Volume Label and S/N, number of files/directories,\n"\
            "            total/available disk space\n"},	  
{TEXT_CMDHELP_DS,
	    "DSTATUS <d#>: physical disk status (calls block driver)\n",
            "dstatus <d#>\n"\
            "  d# = HDA, HDB, SDA, SDB ....\n"\
            "  info: Model, Serial-Number,cyl-sec-heads, tracks LBA-Sectors etc.\n"},	    
{TEXT_CMDHELP_FOPEN,
	    "FOPEN <file> <mode>: open a file\n",
            "fopen <file> <mode>\n"\
            " mode:\n"\
            "    read           r  --> file[0]\n"\
            "    write          w  --> file[1]\n"\
            "    append         a\n"\
            "    binary         b\n"\
            "    text/ascii     t\n"\
	    "    update         +\n"},
{TEXT_CMDHELP_FCLOSE,
	    "FCLOSE <n>: close file[n]\n",
            "fclose <n>\n"},
{TEXT_CMDHELP_FSEEK,
	    "FSEEK <n> <mode> <ofs>: move filepointer of file n in mode\n",
            "fseek <n> <mode> <ofs>\n"\
            "      mode:\n"\
            "      0 - SEEK_SET : Beginning of file\n"\
            "      1 - SEEK_CUR : Current position of the file pointer\n"\
            "      2 - SEEK_END : End of file\n"},
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
	    "VLABEL <op> <volume> <label>: read/write volume label\n",
            "vlabel <op> <volume> <label>\n"\
            "    example: vlabel w hda0 test - sets label of hda0 to 'test'\n"\
            "             vlabel w hdb0      - clears label of hdb0\n"\
            "             vlabel r hda1      - reads label of hda1\n"},
{TEXT_CMDHELP_MKFS,
	    "MKFS <ld#> <fs> <rule> <cluster size>: create a file system\n",
            "mkfs <ld#> <fs> <rule> <cluster size>\n"\
            "     ld#          - volume\n"\
            "     fs           - file system\n"\
            "     rule         - 0=FDISK (1...4 partitions), 1=SFD (only 1 partition)\n"\
            "     cluster size - = sector size * n (n=1..128, power of 2)\n"\
            "                    if 0 is given, the cluster size is \n"\
            "                    determined depending by volume size\n"\
            "  example:\n"\
            "      mkfs HDA0 FAT 0 1024\n"\
            "      mkfs SDA0 FAT 1 1024\n"},
{TEXT_CMDHELP_MKPTABLE,
	    "MKPTABLE <pd#> <size1> <size2> <size3> <size4> - Create partition table \n",
            "mkptable <pd#> <size1> <size2> <size3> <size4>\n"\
            "          pd#: HDA = 1st (G)IDE disk \n"\
            "               SDA = 1st SD disk\n"},  
{TEXT_CMDHELP_PTABLE,
	    "PTABLE <pd#>  - show partition table of physical drive pd# \n",
            "ptable <pd#>\n"\
	    "  example:\n"\
	    "     ptable hda\n"},                      
{TEXT_CMDHELP_PWD,
	    "PWD: print working directory\n",
            "pwd\n"},           
	    
// TEST -----
{TEXT_CMDHELP_SP,             
                        "SP: set point <x,y,page,color>\n",
                        "set point: <x,y,page,color>\n"},	
{TEXT_CMDHELP_FILL,             
                        "FILL: fill area <x1,y1,x2,y2,page,color>\n",
                        "fill area: <x1,y1,x2,y2,page,color>\n"},
{TEXT_CMDHELP_TEST,             
                        "TEST\n",
                        "test function\n"},			
// TEST -----	    
	    
{TEXT_CMDHELP_QUIT,             
                        "QUIT: quit/exit program\n",
                        "quit\n"},    
{TEXT_CMDHELP_HISTORY,             
                        "HISTORY: show command history\n",
                        "history\n"},		
{TEXT_CMDHELP,
			"type cmd /? for more information on cmd\n",""},        
        {0,"",""}
};


// list of available commands ...
struct CMD internalCommands[] =
{
  {"CLS"        , cmd_cls       , TEXT_CMDHELP_CLS},
  {"FSTAB"      , cmd_fstab     , TEXT_CMDHELP_FSTAB},
  {"FS"         , cmd_fs        , TEXT_CMDHELP_FS},
  {"FATINFO"    , cmd_fatinfo   , TEXT_CMDHELP_FATINFO},
  {"DEV"        , cmd_dev       , TEXT_CMDHELP_DEV},
  {"MEMINFO"    , cmd_meminfo   , TEXT_CMDHELP_MEMINFO},
  {"DINIT"      , cmd_dinit     , TEXT_CMDHELP_DI},  
  {"DDUMP"      , cmd_ddump     , TEXT_CMDHELP_DD},
  {"DSTATUS"    , cmd_dstatus   , TEXT_CMDHELP_DS},
  {"BDUMP"      , cmd_bdump     , TEXT_CMDHELP_BD},
  {"BEDIT"      , cmd_bedit     , TEXT_CMDHELP_BE},
  {"BREAD"      , cmd_bread     , TEXT_CMDHELP_BR},
  {"BWRITE"     , cmd_bwrite    , TEXT_CMDHELP_BW},
  {"BFILL"      , cmd_bfill     , TEXT_CMDHELP_BF}, 
  {"MOUNT"      , cmd_mount     , TEXT_CMDHELP_MOUNT},
  {"UMOUNT"     , cmd_umount    , TEXT_CMDHELP_UMOUNT},
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
// --- TEST ------------------
  {"SP"      	, cmd_setpoint  , TEXT_CMDHELP_SP},  
  {"FILL"      	, cmd_fill  	, TEXT_CMDHELP_FILL}, 
  {"TEST"      	, cmd_test  	, TEXT_CMDHELP_TEST},  
// ---------------------------  
  {"QUIT"       , cmd_quit      , TEXT_CMDHELP_QUIT},
  {"Q"          , cmd_quit      , TEXT_CMDHELP_QUIT},  
  {"EXIT"       , cmd_quit      , TEXT_CMDHELP_QUIT},
  {"HISTORY"    , cmd_history   , TEXT_CMDHELP_HISTORY},
  {"HIST"       , cmd_history   , TEXT_CMDHELP_HISTORY},
  {"?"          , showcmds      , TEXT_CMDHELP_QUESTION},
  
  {0,0,0}
};



/*---------------------------------------------------------*/
/* Work Area                                               */
/*---------------------------------------------------------*/

LONGLONG AccSize;			/* Work register for scan_fat_files() */
//char drive[10],path[255],filename[20], ext[10], fname[30], fullname[320], filepath[255], fullpath[255]; /* work register for split_filename() -> fs.c */

extern struct fpinfo FPInfo; // shell.c :  working struct for checkfp (check file-path), also stores current drive and path

// 
struct fpinfo FPInfo1, FPInfo2; // working buffer(2) for arbitrary use with checkfp and checkargs

WORD AccFiles, AccDirs;
BYTE Buff[262144];			/* Working buffer */

//extern char FPInfo.psz_cpath[300];		/* shell.c */
//extern char FPInfo.psz_cdrive[MAX_CHAR];	/* shell.c */
//extern BYTE CurrFATDrive;		/* shell.c */

// ---
FILE* file[2];				/* Pointer to File objects file[0] idt used for read and file[1] ist used for write */

char tmp[_MAX_PATH];

/*---------------------------------------------------------*/
/* Helper Functions                                        */
/*---------------------------------------------------------*/
#include "errcodes.h"	

		
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

void init_cmd(void) {
   FPInfo1.psz_driveName = (char*)malloc(_MAX_DRIVE_NAME);  if(FPInfo1.psz_driveName == 0) exit(1); // exit with fatal error !!
   FPInfo1.psz_deviceID = (char*)malloc(_MAX_DRIVE_NAME);   if(FPInfo1.psz_deviceID == 0) exit(1);
   FPInfo1.psz_path = (char*)malloc(_MAX_PATH);       if(FPInfo1.psz_path == 0) exit(1); 
   FPInfo1.psz_filename = (char*)malloc(_MAX_FILENAME);   if(FPInfo1.psz_filename ==0 ) exit(1);
   FPInfo1.psz_fileext = (char*)malloc(_MAX_FILEEXT);    if(FPInfo1.psz_fileext == 0 ) exit(1);
   FPInfo1.psz_cdrive = (char*)malloc(_MAX_DRIVE_NAME);     if(FPInfo1.psz_cdrive == 0 ) exit(1);
   FPInfo1.psz_cpath = (char*)malloc(_MAX_PATH);      if(FPInfo1.psz_cpath == 0 ) exit(1);
   
   FPInfo2.psz_driveName = (char*)malloc(_MAX_DRIVE_NAME);  if(FPInfo2.psz_driveName == 0) exit(1); // exit with fatal error !!
   FPInfo2.psz_deviceID = (char*)malloc(_MAX_DRIVE_NAME);   if(FPInfo2.psz_deviceID == 0) exit(1);
   FPInfo2.psz_path = (char*)malloc(_MAX_PATH);       if(FPInfo2.psz_path == 0) exit(1); 
   FPInfo2.psz_filename = (char*)malloc(_MAX_FILENAME);   if(FPInfo2.psz_filename ==0 ) exit(1);
   FPInfo2.psz_fileext = (char*)malloc(_MAX_FILEEXT);    if(FPInfo2.psz_fileext == 0 ) exit(1);
   FPInfo2.psz_cdrive = (char*)malloc(_MAX_DRIVE_NAME);     if(FPInfo2.psz_cdrive == 0 ) exit(1);
   FPInfo2.psz_cpath = (char*)malloc(_MAX_PATH);      if(FPInfo2.psz_cpath == 0 ) exit(1);
}

void exit_cmd(void) {
  free( FPInfo1.psz_driveName);
  free( FPInfo1.psz_deviceID);
  free( FPInfo1.psz_path);
  free( FPInfo1.psz_filename);
  free( FPInfo1.psz_fileext);
  free( FPInfo1.psz_cdrive);
  free( FPInfo1.psz_cpath);
  
  free( FPInfo2.psz_driveName);
  free( FPInfo2.psz_deviceID);
  free( FPInfo2.psz_path);
  free( FPInfo2.psz_filename);
  free( FPInfo2.psz_fileext);
  free( FPInfo2.psz_cdrive);
  free( FPInfo2.psz_cpath);
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
	
	//split_filename(ppath, drive, path, filename, ext, fullname, filepath, fullpath, FPInfo.psz_cdrive, FPInfo.psz_cpath); // analyze args
	res=checkfp(ppath, &FPInfo);
	
	//printf("scan_fat_files: path[%s] drive[%s] fullpath[%s]\n",ppath,drive,fullpath);
    
	// build fullpath
	tmp[0]=NULL;
	strcat(tmp,FPInfo.psz_driveName);
	strcat(tmp,":");
	strcat(tmp,FPInfo.psz_path);
	strcat(tmp,FPInfo.psz_filename);
	strncat(tmp,&FPInfo.c_separator,1);
	strcat(tmp,FPInfo.psz_fileext);
	
	if( tmp[strlen(tmp)-1] == '/' ) tmp[strlen(tmp)-1] = 0;
	
	arg_opendir.path = tmp;
	arg_opendir.dp = &dir;		
	arg_readdir.dp = &dir;
	arg_readdir.fno = &Finfo;
	
	//printf("scan_fat_files: path[%s] drive[%s] fullpath[%s]\n",ppath,FPInfo.psz_driveName,tmp);
	
	if ((res = ioctl(FPInfo.psz_driveName,FAT_IOCTL_OPEN_DIR,&arg_opendir)) == FR_OK) {
		i = strlen(tmp);
		
		while (((res = ioctl(FPInfo.psz_driveName,FAT_IOCTL_READ_DIR,&arg_readdir)) == FR_OK) && Finfo.fname[0]) {
			if (_FS_RPATH && Finfo.fname[0] == '.') continue;
#if _USE_LFN
			fn = *Finfo.lfname ? Finfo.lfname : Finfo.fname;
#else
			fn = Finfo.fname;
#endif
			if (Finfo.fattrib & AM_DIR) {
				AccDirs++;
				*(tmp+i) = '/'; strcpy(tmp+i+1, fn);
				res = scan_fat_files(tmp);
				*(tmp+i) = '\0';
				if (res != FR_OK) break;
			} else {
//				printf("%s/%s\n", ppath, fn);
				AccFiles++;
				AccSize += Finfo.fsize;
			}
		}
		res = ioctl(FPInfo.psz_driveName,FAT_IOCTL_CLOSE_DIR,&dir);
		//if(res) printf("error 0:%d in scan_fat_files\n",res);
	} //else printf("error 1:%d in scan_fat_files\n",res);

	//printf("scan_fat_files => %d\n",res);
	return res;
}

/*--------------------------------------------------------*/
/* Get a (long / 32Bit) value of the string               */
/* the variable, where res points to, has to be 32 bits ! */
/*--------------------------------------------------------*/
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
	long *res		/* Pointer to a variable to store the value */
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
/* Get a (string)value of the string            */
/*----------------------------------------------*/
/*	"HDA0   binary w "
	    ^                       1st call returns 'HDA0' and next ptr (if len = 4)
	        ^                   2nd call returns 'binary' and next ptr
                       ^            3rd call returns 'w' and next ptr                          
*/

int xatos (			/* 0:Failed, 1:Successful */
	char **str,		/* Pointer to pointer to the string */
	char *res,		/* Pointer to a variable to store the sub-string */
	int len			/* max length of sub-string without terminating NULL */
)
{	
	char *p= res;
	char c;
	int n=0;

	//printf(" xatos input = %s\n",*str);
	
	*res = 0;
	while ((c = **str) == ' ') (*str)++;	/* Skip leading spaces */

	
	while (c > ' ' && n < len) {
		*p++ = c;
		c = *(++(*str));
		n++;
	}
	
	*p = 0; /* terminate string */
	
	
	//if(n==len) return 0;
	//  else return 1;
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

int checkargs(char* args, char* fullpath1, char* fullpath2) 
{
  FRESULT res;
  
  char *arg1=0;
  char *arg2=0;  
  
  
   while (*args == ' ') args++;	// skip whitespace
   arg1 = args;			// pointer to 1st parameter
   
   arg2 = strchr(args, ' ');	// search 2nd parameter
   if (!arg2)                   // if no 2nd parameter
     arg2 = arg1;		//   2nd parameter == 1st parameter
   else *arg2++ = 0;		// terminate 1st par and increment pointer to next char
   while (*arg2 == ' ') arg2++; // skip whitespace   
   
#ifdef CONFIG_DEBUG
   printf(" arg1 = %s, arg2 = %s\n\n", arg1, arg2);
#endif   
   strcpy(FPInfo1.psz_cdrive,FPInfo.psz_cdrive);
   strcpy(FPInfo1.psz_cpath,FPInfo.psz_cpath);
    
     
   res = checkfp(arg1, &FPInfo1);
#ifdef CONFIG_DEBUG         
   printf("\nFPINFO1:\n");
   printf(" psz_driveName:  [%s]\n",FPInfo1.psz_driveName );
   printf(" psz_deviceID:   [%s]\n",FPInfo1.psz_deviceID );
   printf(" c_deviceNO:     [%c]\n",FPInfo1.c_deviceNO );
   printf(" n_partition:    [%d]\n",FPInfo1.n_partition );
   printf(" psz_path:       [%s]\n",FPInfo1.psz_path );
   printf(" psz_filename:   [%s]\n",FPInfo1.psz_filename );
   printf(" c_separator:    [%c]\n",FPInfo1.c_separator );
   printf(" psz_fileext:    [%s]\n",FPInfo1.psz_fileext );
   printf(" psz_cdrive:     [%s]\n",FPInfo1.psz_cdrive );
   printf(" psz_cpath:      [%s]\n",FPInfo1.psz_cpath );
   printf("\nres = %d (KEY)\n",res);
   getchar();
#endif   
   
   if(fullpath2) {          
     strcpy(FPInfo2.psz_cdrive,FPInfo.psz_cdrive);
     strcpy(FPInfo2.psz_cpath,FPInfo.psz_cpath);
     
     res = checkfp(arg2, &FPInfo2); 
     
      if(arg1 == arg2){       // == no 2nd argument
       FPInfo2.psz_driveName[0] = 0;
       FPInfo2.psz_deviceID[0] = 0;
       FPInfo2.c_deviceNO = 0;
       FPInfo2.n_partition = 0;
       FPInfo2.psz_path[0] = 0;
     }
     
     if(!FPInfo2.psz_filename[0]) {
       strcpy(FPInfo2.psz_filename,FPInfo1.psz_filename);
       FPInfo2.c_separator = FPInfo1.c_separator;
       strcpy(FPInfo2.psz_fileext,FPInfo1.psz_fileext);
     }
     
#ifdef CONFIG_DEBUG     
     printf("\nFPINFO2:\n");
     printf(" psz_driveName:  [%s]\n",FPInfo2.psz_driveName );
     printf(" psz_deviceID:   [%s]\n",FPInfo2.psz_deviceID );
     printf(" c_deviceNO:     [%c]\n",FPInfo2.c_deviceNO );
     printf(" n_partition:    [%d]\n",FPInfo2.n_partition );
     printf(" psz_path:       [%s]\n",FPInfo2.psz_path );
     printf(" psz_filename:   [%s]\n",FPInfo2.psz_filename );
     printf(" c_separator:    [%c]\n",FPInfo2.c_separator );
     printf(" psz_fileext:    [%s]\n",FPInfo2.psz_fileext );
     printf(" psz_cdrive:     [%s]\n",FPInfo2.psz_cdrive );
     printf(" psz_cpath:      [%s]\n",FPInfo2.psz_cpath );
     printf("\nres = %d (KEY)\n",res);
     getchar();
#endif     
   }
   
   // build fullpath  (1)
   fullpath1[0]=0;
   if( !FPInfo1.psz_driveName[0] )		// use current drive if no drive given   
     strcat(fullpath1,FPInfo1.psz_cdrive); 
   else
     strcat(fullpath1,FPInfo1.psz_driveName);    
   strcat(fullpath1,":");
                                                  
    if(arg1[0] == '/') { 			// absolute path given as argument -> superseds current path !
#ifdef CONFIG_DEBUG      
      printf(" absolute path argument '%s'\n",arg1);
#endif      
      strcat(fullpath1,arg1);
    } else { // relative path, append args to current path...
#ifdef CONFIG_DEBUG      
     printf(" relative path argument '%s'\n",arg1); 
#endif     
     if(FPInfo1.psz_cpath[0] != '/') strcat(fullpath1,"/");          
     //strcat(fullpath,FPInfo.psz_cpath);  
     if(!FPInfo1.psz_driveName[0] || !strcmp(FPInfo1.psz_driveName,FPInfo1.psz_cdrive)) strcat(fullpath1,FPInfo1.psz_cpath);  // append current path only, if no drive given or given drive equal to current drive !
     
     if(fullpath1[strlen(fullpath1)-1] == '/') {
       if(FPInfo1.psz_path[0] == '/') fullpath1[strlen(fullpath1)-1] = 0;       
     }else{
       if(FPInfo1.psz_path[0] != '/') strcat(fullpath1,"/");
     }
     strcat(fullpath1,FPInfo1.psz_path);

     if(fullpath1[strlen(fullpath1)-1] != '/') strcat(fullpath1,"/");
     strcat(fullpath1,FPInfo1.psz_filename);
     fullpath1[strlen(fullpath1)+1] = 0;       
     fullpath1[strlen(fullpath1)] = FPInfo1.c_separator;       
     strcat(fullpath1,FPInfo1.psz_fileext);

     if(fullpath1[strlen(fullpath1)-1] == '/') fullpath1[strlen(fullpath1)-1] = 0;      
    }
    
    if(fullpath2) {
    // build fullpath  (2)
       fullpath2[0]=0;
       if( !FPInfo2.psz_driveName[0] )		// use current drive if no drive given   
         strcat(fullpath2,FPInfo2.psz_cdrive); 
       else 
         strcat(fullpath2,FPInfo2.psz_driveName);    
       strcat(fullpath2,":");
                                                      
        if(arg2[0] == '/') { 			// absolute path given as argument -> superseds current path !
#ifdef CONFIG_DEBUG	  
          printf(" absolute path argument '%s'\n",arg2);
#endif	  
          strcat(fullpath2,FPInfo2.psz_path);
        } else { // relative path, append args to current path...
#ifdef CONFIG_DEBUG	  
         printf(" relative path argument '%s'\n",arg2); 
#endif	 
         if(FPInfo2.psz_cpath[0] != '/') strcat(fullpath2,"/");          
         if(!FPInfo2.psz_driveName[0] || !strcmp(FPInfo2.psz_driveName,FPInfo2.psz_cdrive)) strcat(fullpath2,FPInfo2.psz_cpath);  // append current path only, if no drive given or given drive equal to current drive !
        }
         if(fullpath2[strlen(fullpath2)-1] == '/') {
           if(FPInfo2.psz_path[0] == '/') fullpath2[strlen(fullpath2)-1] = 0;       
         }else{
           if(FPInfo2.psz_path[0] != '/') strcat(fullpath2,"/");
         }
         strcat(fullpath2,FPInfo2.psz_path);
          
         if(fullpath2[strlen(fullpath2)-1] != '/') strcat(fullpath2,"/");
         strcat(fullpath2,FPInfo2.psz_filename);
         fullpath2[strlen(fullpath2)+1] = 0;       
         fullpath2[strlen(fullpath2)] = FPInfo2.c_separator;       
         strcat(fullpath2,FPInfo2.psz_fileext);
      
         if(fullpath2[strlen(fullpath2)-1] == '/') fullpath2[strlen(fullpath2)-1] = 0;                      
          
   }
   
      return 0;
}

// ****************** high level filesystem (fat) commands.... *************************************

int cmd_cls (void){
  nkc_clrscr();
  return 0;
}

// calls via ioctl (start) -------
int cmd_pwd    (char * args){
   FRESULT res;
   struct ioctl_get_cwd arg;
   
   arg.cpath = FPInfo.psz_cpath;
   arg.cdrive  = FPInfo.psz_cdrive;
   arg.size = 256;
   res = ioctl(NULL,FS_IOCTL_GETCWD,&arg);

   if (res) {
	put_rc(res);
   } else {	
	printf("%s:%s\n",FPInfo.psz_cdrive,FPInfo.psz_cpath);	
   }
         
   return 0; // sonst bricht die shell ab ....      
   return res;
} 


int cmd_chmod(char* args) {
   /* fa <attrib> <mask> <name> - Change file/dir attribute */
   long attrib,mask;
   struct ioctl_chmod arg;
   FRESULT res;
   
   
   if (!xatoi(&args, &attrib) || !xatoi(&args, &mask)) return 0;
   while (*args == ' ') args++;
   
   res=checkfp(args, &FPInfo);
   if( res != EZERO) return res;
   
   // build fullpath
   tmp[0]=0;
   strcat(tmp,FPInfo.psz_driveName);
   strncat(tmp,':',1);
   strcat(tmp,FPInfo.psz_path);
   strcat(tmp,FPInfo.psz_filename);
   strncat(tmp,&FPInfo.c_separator,1);
   strcat(tmp,FPInfo.psz_fileext);

   arg.value = (BYTE)attrib;	/* Attribute bits */
   arg.mask  = (BYTE)mask,	/* Attribute mask to change */
   arg.fpath = tmp;		/* Pointer to the full file path */
    
   res = ioctl(NULL,FS_IOCTL_CHMOD,&arg);
   
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
    
   arg.cpath = FPInfo.psz_cpath;
   arg.cdrive  = FPInfo.psz_cdrive;
   arg.size = _MAX_PATH;
   res = ioctl(NULL,FS_IOCTL_GETCWD,&arg);
      
   
   if(res != RES_OK) put_rc(res);
         
   return 0;
}

int cmd_chdir(char *args)
{
   FRESULT res;
   struct ioctl_get_cwd arg;
   char fullpath[_MAX_PATH];
   
   if(!args) return 0;
     
   while (*args == ' ') args++;  
   
#ifdef CONFIG_DEBUG   
   printf("cmd_chdir(%s)\n",args);
#endif
   
   res=checkfp(args, &FPInfo);
   
   
  // build fullpath
   fullpath[0]=0;
   if( !FPInfo.psz_driveName[0] )		// use current drive if no drive given   
      strcat(FPInfo.psz_driveName,FPInfo.psz_cdrive); 

    strcat(fullpath,FPInfo.psz_driveName);    
    strcat(fullpath,":");
                                                  
    if(args[0] == '/') { 			// absolute path given as argument -> superseds current path !
#ifdef CONFIG_DEBUG      
      printf(" absolute path argument '%s'\n",args);
#endif
      strcat(fullpath,args);
    } else { // relative path, append args to current path...
#ifdef CONFIG_DEBUG      
     printf(" relative path argument '%s'\n",args); 
#endif
     if(FPInfo.psz_cpath[0] != '/') strcat(fullpath,"/");          
     strcat(fullpath,FPInfo.psz_cpath);  
     
     if(fullpath[strlen(fullpath)-1] == '/') {
       if(FPInfo.psz_path[0] == '/') fullpath[strlen(fullpath)-1] = 0;       
     }else{
       if(FPInfo.psz_path[0] != '/') strcat(fullpath,"/");
     }
     strcat(fullpath,FPInfo.psz_path);
      
     if(strlen(FPInfo.psz_filename)) {
       if(fullpath[strlen(fullpath)-1] != '/') strcat(fullpath,"/");
	strcat(fullpath,FPInfo.psz_filename);
     }
     
     if(fullpath[strlen(fullpath)-1] == '/') fullpath[strlen(fullpath)-1] = 0;      
    }

#ifdef CONFIG_DEBUG
   printf(" cd [%s]\n",fullpath);
#endif
   
   res = ioctl(FPInfo.psz_cdrive,FS_IOCTL_CD,fullpath);
   if(res != RES_OK) put_rc(res);   
   
   arg.cpath = FPInfo.psz_cpath;
   arg.cdrive = FPInfo.psz_cdrive;
   arg.size = 256;
   res = ioctl(NULL,FS_IOCTL_GETCWD,&arg); // no device name needed
   
   if(res != RES_OK) put_rc(res);
   
   return 0;
}


int cmd_dir(char *args) // ...
{
  int i;
  FRESULT res;
  char fullpath1[_MAX_PATH];
  
  while (*args == ' ') args++;
  
#ifdef CONFIG_DEBUG  
  printf("cmd_dir(%s) ...\n",args);
#endif
  res = checkargs(args, fullpath1, NULL);
  res = checkfp(fullpath1, &FPInfo1);
#ifdef CONFIG_DEBUG
  printf(" dir [%s] ... \n",fullpath1);
#endif
  printf(" directory of %s is:\n",fullpath1);

  

  if( !FPInfo1.psz_driveName[1] ) { // one character drive name -> is it a JADOS drive ?
    if( (FPInfo1.psz_driveName[0] >= 'A' && FPInfo1.psz_driveName[0] <= 'Z') ||  // JADOS hard drive
        (FPInfo1.psz_driveName[0] >= '0' && FPInfo1.psz_driveName[0] <= '3') ){  // JADOS floppy drive
	  res = cmd_dir_nkc(fullpath1,FPInfo1.psz_driveName);
	  if(res) printf(" cmd_dir_nkc returned '%s'\n",get_rc_string(res));
	  return 0;
    }else{  //invalid drive name
	  printf(" invalid drive name (%s)\n",FPInfo1.psz_driveName);
	  return 0;//EINVAL;
    }
  }else{ // give it to the fat driver
    
    res = cmd_dir_fat(fullpath1,FPInfo1.psz_driveName);
    if(res) printf(" cmd_dir_fat returned '%s'\n",get_rc_string(res));
    return 0;
  }
      
}

int cmd_dir_nkc(char *args, 		// arguments
		char* pd		// drive 
	       ) // NKC/JADOS dir
{
  printf(" JADOS/NKC dir...\n");
  FRESULT res;
  struct ioctl_nkc_dir arg;
  char *buffer;  
  char *pargs,*pc1,*pc2;
  int len;
  
  // remove path information from filename...
  pc1 = args;
  len = strlen(pc1);
  
#ifdef CONFIG_DEBUG  
  printf(" try allocating %d bytes for pargs: ",len);
#endif
  pc2 = pargs = (char*)malloc(len);  
#ifdef CONFIG_DEBUG
  printf(" malloc returned 0x%x\n",pc2);
#endif  
  if(!pc2) return EZERO;
#ifdef CONFIG_DEBUG  
  printf(" try allocating %d bytes for buffer: ",256*40+1);
#endif
  buffer = (char*)malloc(256*40+1);  
#ifdef CONFIG_DEBUG  
  printf(" malloc returned 0x%x\n",buffer);
#endif
  
  
  if(!buffer){
    printf(" error: not enough memory\n");
    free(pc2);
    return EZERO;
  }
  
  *pc2=0;
  while(*pc1){
    if(*pc1 != '/'){*pc2++ = *pc1;}
    pc1++;	  
  }
  *pc2=0;
  
#ifdef CONFIG_DEBUG  
  printf(" src-pattern = [%s], dst-pattern = [%s]\n",args,pargs);
#endif
  

  arg.attrib = 7; // show all types of files (1=file length; 2=date; 4=r/w attribute)
  arg.cols = 2;   // format output in 2 columns
  arg.size = 256*40; // maximum buffer size for full directory
  arg.pbuf = buffer;
  arg.ppattern = pargs;
  
#ifdef CONFIG_DEBUG  
  printf(" pattern to jados [%s]\n", pargs);	
#endif
  
  res = ioctl(pd,NKC_IOCTL_DIR,&arg); // fetch directory using JADOS function call

  //          14          7     10	  2+6
  printf("File-Name     Size   Date      Flags File-Name     Size   Date      Flags\n\n");
  
  printf(buffer);
  printf("\n JADOS/NKC filesystem     \n");
  
  put_rc(res);
  
  free(buffer);
  free(pargs);
  
  return EZERO;
}

int cmd_dir_fat(char *args,  // fullpath
		char* pd)    // drivename
{
   
   DIR dir;				/* FAT Directory object */
   FILINFO Finfo;			/* File info object */
   FATFS *fs;				/* Pointer to file system object */
   FRESULT res;
   UINT s1, s2;
   long p1,p2,line=0;  
   
   struct ioctl_opendir arg_opendir;
   struct ioctl_readdir arg_readdir;
   struct ioctl_getfree arg_getfree;
   
#ifdef CONFIG_DEBUG   
   printf(" FAT dir ...\n");
#endif
   
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
  char fullpath1[_MAX_PATH];
  
  while (*args == ' ') args++;
  
#ifdef CONFIG_DEBUG  
  printf(" cmd_mkdir(%s)\n",args);
#endif
       
  res = checkargs(args, fullpath1, NULL);
  res = checkfp(fullpath1, &FPInfo1);
#ifdef CONFIG_DEBUG   
  printf(" mkdir [%s] ... \n",args);
#endif
      
  res = ioctl(FPInfo1.psz_driveName,FS_IOCTL_MKDIR,fullpath1);  
  
  if(res != EZERO) put_rc(res);
   
  return 0;
}

int cmd_rmdir(char *args)
{
  
   FRESULT res;    
   char fullpath1[_MAX_PATH];
#ifdef CONFIG_DEBUG  
   printf(" RMDIR (%s) ...\n", args);
#endif
   
   if(!args) {
	printf(" usage: rmdir [dirpath]\n\n");
	return 0;
   }
   
   while (*args == ' ') args++;   
      
   res = checkargs(args, fullpath1, NULL);
   res = checkfp(fullpath1, &FPInfo1);
   
   res = ioctl(FPInfo1.psz_driveName,FS_IOCTL_RMDIR,fullpath1);
   
   if(res != EZERO) put_rc(res);
   
   return 0;
}

int cmd_rename(char *args)
{
   char * ptr2;
   
   char fullpath1[_MAX_PATH];
   char fullpath2[_MAX_PATH];
   
   FRESULT res; 
   struct ioctl_rename arg_rename;
   
   while (*args == ' ') args++;	// skip whitespace
   
   checkargs(args, fullpath1, fullpath2);     
   
   printf(" rename %s --> %s\n",fullpath1,fullpath2);
   
   arg_rename.path_old = fullpath1;
   arg_rename.path_new = fullpath2;   
   res = ioctl(FPInfo.psz_cdrive,FS_IOCTL_RENAME,&arg_rename);
   if(res != RES_OK) put_rc(res);
   
   return 0;
}

int cmd_del(char *args) {
   /* del <name> - delete a file */
   FRESULT res; 
   char fullpath1[_MAX_PATH];
   
   while (*args == ' ') args++;
   
   checkargs(args, fullpath1, NULL);
#ifdef CONFIG_DEBUG   
   printf(" cmd_del( %s )\n",fullpath1);
#endif
   
   res = ioctl(NULL,FS_IOCTL_DEL,&fullpath1);
   if(res) put_rc(res);
   
   return 0;
}
// calls via ioctl (end) -------

// standard clib calls (start) -----



int cmd_copy(char *args)
{
   FRESULT res;
   char *ptr2;   
   long p1;
   UINT s1,s2;
   
    char fullpath1[_MAX_PATH];
    char fullpath2[_MAX_PATH];
 
  
  
#ifdef CONFIG_DEBUG   
   printf("cmd_copy(%s):\n",args);
#endif
   
   checkargs(args, fullpath1, fullpath2);
#ifdef CONFIG_DEBUG      
   printf(" copy [%s -> %s]\n",fullpath1,fullpath2);
#endif
   
#ifdef CONFIG_DEBUG
   printf("Opening \"%s\"\n", fullpath1);
#endif
   //                                0x00		0x01
   //res = f_open(&file[0], args, FA_OPEN_EXISTING | FA_READ);
   file[0] = fopen(fullpath1,"rb");
   
   if (file[0]==NULL) {
      printf("error opening file !\n");

      return 0;
   }
#ifdef CONFIG_DEBUG
   printf("Creating \"%s\"\n", fullpath2); getchar();
#endif
   //                                  0x08		0x02
   //res = f_open(&file[1], ptr2, FA_CREATE_ALWAYS | FA_WRITE);
   file[1] = fopen(fullpath2,"wb");
   printf("\n");
   if (file[1]==NULL) {
     fclose(file[0]);
     printf("error creating file !\n");
    
     return 0;
   }
   printf("Start Copy %s ==> %s ...",fullpath1,fullpath2);
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
   printf("\nready\n");   
   fclose(file[0]);
   fclose(file[1]);
   printf("%lu bytes copied.\n", p1);
   
   
   return 0;
}

int cmd_fopen  (char * args){
  /* fopen <file> <mode> - Open a file (OK) */
   
   char *mode;
   char fullpath[_MAX_PATH];
   FRESULT res;
   FILE* f;
   
   while (*args == ' ') args++; /* skip whitespace */
   mode = strchr(args, ' ');	/* find space before mode */
   if (!mode) 
   {
     printf("missing mode...\n");
     return 0;
   }
   *mode++ = 0;			/* terminate filename, args now points to filename */
   while (*mode == ' ') mode++; /* skip whitespace */
   if (!mode) 
   {
     printf("missing mode...\n");
     return 0;
   }  
				/* mode now points to mode string */
				
				
   res = checkargs(args, fullpath, NULL);			
     
#ifdef CONFIG_DEBUG
   printf(" fopen %s %s\n",fullpath,mode);
#endif     
   f = fopen(fullpath,mode);
  
   if(f) {
     printf(" file %s opened in mode %s\n",fullpath,mode);
     
     if(strchr(mode,'r'))
      file[0] = f;
     else file[1] = f;
	
   }
   else printf(" error opening file %s in mode %s\n",fullpath,mode);
   
   return 0;
} 

int cmd_fclose (char * args){
  
   if(strchr(args,'0'))
    fclose(file[0]);
   else fclose(file[1]);
   
   return 0;
}

int cmd_fseek  (char * args){
   /* fseek <n> <mode> <ofs> */
   /*
    * mode:
    * SEEK_SET (0) Beginning of file
    * SEEK_CUR (1) Current position of the file pointer
    * SEEK_END (2) End of file (not standad, portability not granted)
    * 
    */ 
   long ofs;
   int whence;
   UINT n;
   FRESULT res;
   
   while (*args == ' ') args++; 	/* skip whitespace */
   if (!xatoi(&args, &n)) return 0;	/* get file        */
   if (!xatoi(&args, &whence)) return 0;/* get mode        */
   if (!xatoi(&args, &ofs)) return 0;	/* get offset      */
      
   printf(" fseek: file[%d], ofs=%l, whence=%d\n",n,ofs,whence);
   
   
   res = fseek(file[n],ofs,whence); // seek ofs bytes from the current position
   if(res) put_rc(res);   
   
   return 0;
} 


int cmd_fdump  (char * args){
   long len;
   UINT cnt;
   DWORD ofs = 0;
   FRESULT res;
   
   if (!xatoi(&args, &len)) len = 128;
   //ofs = file[0].curp - file[0].buffer;
   
   while (len) {
     if ((UINT)len >= 16) { cnt = 16; len -= 16; }
     else	{ cnt = len; len = 0; }
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
  /* FREAD <len>: read the file */
   long len,p2;
   UINT s2, cnt;
   FRESULT res;
   struct ioctl_file_rw arg;
   
   if (!xatoi(&args, &len)) return 0;
   p2 =0;
   while (len) {
    if ((UINT)len >= sizeof Buff) {
	cnt = sizeof Buff; len -= sizeof Buff;
    } else {
	cnt = len; len = 0;
    }
    s2 = fread(Buff, 1, cnt, file[0]);
    if(s2 != 0) res = ERROR;
    else res = EZERO;
    if (res != EZERO) { put_rc(res); return 0; }
    p2 += s2;
    if (cnt != s2) return 0;
   }
   printf("%lu bytes read.\n", p2);          
   
   return 0;
} 
int cmd_fwrite (char * args){
   /* fw <len> <val> - write file */
   // FS_IOCTL_DISK_WRITE is a low level function acting directly at sector level
   long p1,p2;
   UINT s2, cnt;
   FRESULT res;
   struct ioctl_file_rw arg;
   
   if (!xatoi(&args, &p1) || !xatoi(&args, &p2)) return 0;
   memset(Buff, (BYTE)p2, sizeof Buff);
   p2 = 0;
   while (p1) {
	if ((UINT)p1 >= sizeof Buff) { cnt = sizeof Buff; p1 -= sizeof Buff; }
	else 				  { cnt = p1; p1 = 0; }
	s2 = fwrite(Buff, 1, cnt, file[1]);	          
	if(s2 != 0) res = ERROR;
	else res = EZERO;
	if (res != EZERO) { put_rc(res); return 0; }
	p2 += s2;
	if (cnt != s2) break;
   }
   printf("%lu bytes written.\n", p2);          
   
   return 0;
} 
int cmd_ftrunk (char * args){
   /* fv - Truncate file */
   //put_rc(f_truncate(&file[0]));      // FIXME    
   return 0;
} 

// standard clib calls (end) -----

// ***************************** low level disc commands *****************************
int cmd_dinit  (char * args){
// dinit <disc number/device, ie. A, B .... hda,sda etc.>
   char* p1;
   WORD w;
   DWORD dw;
   FRESULT res;   
   
#ifdef CONFIG_DEBUG   
   printf("dinit [%s]\n",args);
#endif
   
   while (*args == ' ') args++;
   
   p1=args;
   
   while(*p1) { *p1 = toupper( *p1 );  p1++; } // convert to uppercase

#ifdef CONFIG_DEBUG   
   printf("DINIT[%s]\n",args);
#endif      

   res = ioctl(args,FS_IOCTL_DISK_INIT,NULL);  

#ifdef CONFIG_DEBUG     
   put_rc(res);
#endif
   
   cmd_dstatus(args);
  
   if (ioctl(args, FS_IOCTL_DISK_GET_SECTOR_SIZE, &w) == RES_OK)
	printf(" Sector size = %u\n", w);
   if (ioctl(args, FS_IOCTL_DISK_GET_SECTOR_COUNT, &dw) == RES_OK)
	printf(" Number of sectors = %u\n", dw);
       
   return 0;
}

/* Disk Drive Status 
 * physical disk status (calls block driver):
 * Model, Serial-Number,cyl-sec-heads, tracks LBA-Sectors etc.
 */
int cmd_dstatus(char * args){
  /* DSTATUS <d#>: display disc status, d# = HDA,HDB ....*/
   long p1;
   char *ptr;
   FRESULT res;
   struct _deviceinfo di;
   
   printf("Disk Drive Status:\n");
   printf("==================\n");
   
   
   while (*args == ' ') args++; /* skip whitespace */
   
   if(!args) return 0; 
   
   res = ioctl(args, FS_IOCTL_GET_DISK_DRIVE_STATUS, &di);  
   
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
// DDUMP [<d#> <sec#>]: dump sector d# => physical drive (HDA,HDB,SDA,SDB ....), sec# => sector number (0,1....)
   long p1,p2;
   BYTE *buf;
   int res;
   WORD w;
   struct ioctl_disk_rw ioctl_args;
   char drive[4];
   DWORD ofs = 0, sect = 0; 
   
  
   while (*args == ' ') args++; /* skip whitespace */
     
   if (!xatos(&args, drive,3) || !xatoi(&args, &sect)) return 0;
   
   // fill ioctl information struct an read the sector ....
   ioctl_args.drv = drive;
   ioctl_args.buff = Buff;
   ioctl_args.sector = sect;
   ioctl_args.count = 1;   
   res = ioctl(drive, FS_IOCTL_DISK_READ, &ioctl_args);
   
   if (res) { printf("rc=%d\n", (WORD)res); return 0; }
   
   printf("Drive:%s Sector:%lu\n", drive, sect);
   
   if (ioctl(drive, FS_IOCTL_DISK_GET_SECTOR_SIZE, &w) != RES_OK) return 0;

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
     mkfs <ld#> <fstype> <partition rule> <cluster size> - Create file system in logical drive/partition ld# (mount #ld first !)
     
     ld#            	= HDA0, HDA1, HDB0, SDA1 ....
     fstype	    	= FAT12, FAT16, FAT32
     partition rule 	= 0:FDISK (create an FS in a partition), 
			  1:SFD (create only one primary partition starting at the first sector of the PHYSICAL disk
     cluster size(au)  	= Cluster Siz in Bytes.The value must be sector size * n (n is 1 to 128 and power of 2 - 1,2,4,8,16 ...)
     
     au and partition size ( =>mkptable) determine if FAT-type will be FAT12,16 or 32 ... see /fs/fat/ff.c - f_mkfs()
     fstype will be for future use....
      =>
	if au == 0 -> au = 1
	if au > 128 -> au = 128
	number of clusters = volume size (from ptable) / au
	
	if (n_clst <  MIN_FAT16) fmt = FS_FAT12;
	if (n_clst >= MIN_FAT16) fmt = FS_FAT16;
	if (n_clst >= MIN_FAT32) fmt = FS_FAT32;
   
     */   
   char *ptr;   
   char tmp[5];
   long sfd,au;
   int res;
   char part[5];
   char type[6];
   struct ioctl_mkfs ioctl_args;
   
   if (!xatos(&args, part,4) || !xatos(&args, type,5) || !xatoi(&args, &sfd) || !xatoi(&args, &au)) return 0;
   
   ptr=part; while(*ptr) { *ptr = toupper( *ptr );  ptr++; } // convert to uppercase
   ptr=type; while(*ptr) { *ptr = toupper( *ptr );  ptr++; } // convert to uppercase
 
   ioctl_args.part = part;    /* partition */
   ioctl_args.fstype = type;  /* file system type */
   ioctl_args.au = au;        /* allocation unit */    
   ioctl_args.sfd = sfd;      /* partitioning rule */  // dito ?
   
   if( !strncmp ( "FAT", type, 3) ) {
     printf("The volume will be formatted. Are you sure? (Y/n)=");
     gets(ptr = tmp);
     if (*ptr != 'Y') return 0;
     res = ioctl(part, FAT_IOCTL_MKFS, &ioctl_args);
   } else
   {
     printf(" %s file system not supported !\n");
   }
   put_rc(res);
   return 0;
}




int cmd_mkptable (char * args) {
   /* fp <pd#> <size1> <size2> <size3> <size4> - Create partition table 
          pd# = HDA, HDB ....
          size 1...4 = size of pafrtitions
    */
   DWORD pts[4];
   char drive[4];
   char *ptr;
   int res;
   char tmp[10];
   struct ioctl_mkptable ioctl_args;
   // struct ioctl_mkptable {
   //	char *devicename;		/* pointer to physical drive name (HDA,HDB,SDA,SDB ....) */
   //	const unsigned int *szt;	/* Pointer to the size table for each partitions */
   //	void* work;			/* Pointer to the working buffer  ( >= _MAX_SS ) */
   //      };
   
   #if _MULTI_PARTITION
   if (!xatos(&args, drive,3)) return 0; // get drive
   xatoi(&args, &pts[0]);		 // size of 1st partition in ?
   xatoi(&args, &pts[1]);		 // size of 2nd partition in ?
   xatoi(&args, &pts[2]);		 // size of 3rd partition in ?
   xatoi(&args, &pts[3]);		 // size of 4th partition in ?
   printf("The physical drive %s will be re-partitioned. Are you sure? (Y/n)=", drive);
   gets(ptr = tmp);
   if (*ptr != 'Y') return 0;
   //put_rc(f_fdisk((BYTE)p1, pts, Buff));
   ioctl_args.devicename = drive;
   ioctl_args.szt = pts;
   ioctl_args.work = Buff;
   
   
   res = ioctl(drive, FS_IOCTL_MKPTABLE, &ioctl_args);
   
   put_rc(res);
   #else
   printf(" mkptable: multi partition feature not implemented\n");
   #endif
   return 0;
}



static const char *
partition_type(unsigned char type)
{
	int i;	

	for (i = 0; fs_sys_types[i]; i++)
		if ((unsigned char)fs_sys_types[i][0] == type)
			return fs_sys_types[i] + 1;

	return "Unknown";
}

void dump_partition(struct partition *part, int partition_number)
{ 
  
  printf("Partition %d\n", partition_number + 1);
  printf("   boot_flag = %02X", part->boot_flag);
  printf("   sys_type = %02X (%s)\n", part->sys_type, partition_type(part->sys_type) );
  
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
   char *p1;
   UINT i;
   struct ioctl_disk_rw ioctl_args;
   FRESULT res;
   char drive[4];
   
  
   while (*args == ' ') args++;  
  
   if (!xatos(&args, drive,3)) return 0;
  
   p1=drive; while(*p1) { *p1 = toupper( *p1 );  p1++; } // convert to uppercase
  
   ioctl_args.drv = drive;  
   ioctl_args.buff = Buff;
   ioctl_args.sector = 0;
   ioctl_args.count = 1; 
  
   res = ioctl(drive, FS_IOCTL_DISK_READ, &ioctl_args);
   
   if(res) {
         printf(" disc error\n");
         return 0;
        }

        p = Buff + MBR_Table;
        
        printf(" The 4 Main Partitions: \n\n");
        
        for (i = 0; i < 4; i++, p += SZ_PTE) {
                dump_partition(p, i);
        }
        
        return 0;
}

int _cmd_ptable(char * args) { // args = "HDA", "HDB" etc.
   BYTE *p;
   char *p1;
   UINT i;
   struct ioctl_disk_rw ioctl_args;
   FRESULT res;
   char drive[4];
   
  
   while (*args == ' ') args++;  
  
   if (!xatos(&args, drive,3)) return 0;
  
   p1=drive; while(*p1) { *p1 = toupper( *p1 );  p1++; } // convert to uppercase
  
   ioctl_args.drv = drive;  
   ioctl_args.buff = Buff;
   ioctl_args.sector = 0;
   ioctl_args.count = 1; 
  
   res = ioctl(drive, FS_IOCTL_DISK_READ, &ioctl_args);
   
   if(res) {
         printf(" disc error\n");
         return 0;
        }

        p = Buff + MBR_Table;
        
        printf(" The 4 Main Partitions: \n\n");
	
	printf("Disk %s: 2048 MB, 2048901120 bytes\n",drive);
	printf("64 heads, 63 sectors/track, 992 cylinders, total 4001760 sectors\n");
	printf("Units = sectors of 1 * 512 = 512 bytes\n");
	printf("Sector size (logical/physical): 512 bytes / 512 bytes\n");
	printf("I/O size (minimum/optimal): 512 bytes / 512 bytes\n");
	printf("Disk identifier: 0x00000000\n");

	printf("Device Boot      Start         End      Blocks   Id  System\n");
	

        
        for (i = 0; i < 4; i++, p += SZ_PTE) {
                printf("sdb1              63        8063        4000+   4  FAT16 <32M\n");
        }
        
        return 0;
}

int cmd_mount (char * args){
   /* args = <vol> <fs> <opt>*/
   FRESULT res;
   char vol[6];
   char fs[10];
   char opt[6];
   char* pc;
   
   struct ioctl_mount_fs mnt_args;
	//   struct ioctl_mount_fs {
	//     char *devicename;   		/* devicename (HDA0, SDB1, A, B, 1, 2, ... */
	//     char* fsname;			/* file system name (FAT32, JADOS ...)    */
	//     unsigned char options;        /* mount options (FS_READ, FS_RW, ....)   */  
	//   };
   
   if(args[0] == 0)  // list mounted partitions ....
   {
     cmd_fstab(NULL);
     
     return 0;
   }
   
   //retreive arguments...   
  
   pc=args;
   while(*pc){			// convert args to uppercase
    *pc = toupper(*pc);
    pc++;
   }   
   
   if ( !xatos(&args, vol,5) || !xatos(&args, fs,9) || !xatos(&args,opt,5) ) return 0; 
   
   printf(" try mounting filesystem %s on volume %s with option %s ... \n",fs,vol,opt);
   
   mnt_args.devicename = vol;
   mnt_args.fsname = fs;
   mnt_args.options = opt;
      
   res = ioctl(NULL, FS_IOCTL_MOUNT, &mnt_args); 
   
   put_rc(res);
   
   return 0;
} 



int cmd_umount (char * args){
   /* fmount <ld#>  - unmount drive ld#; arg = HDA1.....*/
   FRESULT res;
   
 
   if (!args){
     printf(" error in args.\n");
     return 0;
   }   
   
   while (*args == ' ') args++;
         
   res = ioctl(args, FS_IOCTL_UMOUNT, 0);
   put_rc(res);
      
   return 0;
} 


/* Volumes File System Status
 * info of FATFS structure:
 * FAT Type, FAT Start, DIR start, Data Start, Root DIR entries, number of clusters
 */
int cmd_vstatus(char * args){
  char *pc;
  long vol;
  FATFS *pfs;
  FRESULT res;
  struct ioctl_getfatfs arg;
  static const BYTE ft[] = {0, 12, 16, 32};
   
   printf("Volumes File System Status...\n");
   
   if (!args){
     printf(" error in args.\n");
     return 0;
   }   
   
   while (*args == ' ') args++;  	// skip whitespace
  
   res=checkfp(args, &FPInfo);		// analyze argumennt
   
   //pc=args;  
   //while(*pc){			// convert to uppercase
   // *pc = toupper(*pc);
   // pc++;
   //}
  
   arg.vol = dn2vol(FPInfo.psz_driveName);
   printf("disk (%s) (volume %u):\n\n",FPInfo.psz_driveName,arg.vol);

   arg.ppfs = &pfs;
   res = ioctl(FPInfo.psz_driveName,FAT_IOCTL_GET_FATFS,&arg);
   
   if( res != RES_OK) { printf("drive not ready.\n"); return 0; }
   
   if (!pfs->fs_type) { printf("Not mounted.\n"); return 0; }
   
   printf(" FAT type = %u (FAT%u)\n Bytes/Cluster = %lu\n"
	  " Root DIR entries = %u\n Number of clusters = %lu\n"
	  " FAT start (lba) = %lu\n DIR start (lba,cluster) = %lu\n Data start (lba) = %lu\n\n",
		 (BYTE)(pfs->fs_type),ft[pfs->fs_type & 3],
		 (DWORD)(pfs->csize) * 512,
		 pfs->n_rootdir, (DWORD)(pfs->n_fatent) - 2,
		 pfs->fatbase, pfs->dirbase, pfs->database );
				          
   return 0;
}


/* Logical Drive Status
 * info on FS(FAT) structure in current directory on actual media:
 * FAT Type, Number of FATs, ClusterSize in sectors and bytes, Volume Label and S/N,
 * number of files/directories, total/available disk space
 */
int cmd_lstatus(char *args) // ...
{  
  int i;
  FRESULT res;
    
  while (*args == ' ') args++;
  
  res=checkfp(args, &FPInfo);		// analyze argumennt
  if( res == EINVDRV ) 
  {
    printf(" error in args ...\n");
    return 0;
  }
  
   
  printf(" lstatus [%s] ... \n",FPInfo.psz_driveName);
#ifdef USE_JADOS  
  if( !FPInfo.psz_driveName[1] ) { // one character drive name -> is it a JADOS drive ?
    if( (FPInfo.psz_driveName[0] >= 'A' && FPInfo.psz_driveName[0] <= 'Z') ||  // JADOS hard drive
        (FPInfo.psz_driveName[0] >= '0' && FPInfo.psz_driveName[0] <= '3') ){  // JADOS floppy drive
	  res = cmd_lstatus_nkc(FPInfo.psz_driveName);	  
	  return 0;
    }else{  //invalid drive name
	  printf(" invalid drive name (%s)\n",FPInfo.psz_driveName);
	  return 0;//EINVAL;
    }
  }else{ // give it to the fat driver
    
    res = cmd_lstatus_fat(FPInfo.psz_driveName);
    if(res) printf(" cmd_lstatus_fat returned '%s'\n",get_rc_string(res));
    return 0;
  }
#else
  // give it to the fat driver
  res = cmd_lstatus_fat(FPInfo.psz_driveName);
  if(res) printf(" cmd_lstatus_fat returned '%s'\n",get_rc_string(res));
  return 0;
#endif
      
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
  arg_getlabel.volume = ptr2;
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
   /* flabel <op> <volume> <label> - Set/get volume label */
   FRESULT res;
   char op[2];
   char volume[6];
   char label[10];
   char tmp[20];
   char *p1;
   DWORD sn;
   struct ioctl_getlabel getlbl;
   
   while (*args == ' ') args++;
   
   if ( !xatos(&args,op,1) || !xatos(&args, volume,5) ) { // fetch op and volum 
     printf(" bad arguments.\n");
     return 0;   
   }
   
   xatos(&args, label,9); // fetch labe (emtpty => clear label if op = w(rite)
   
   p1=volume; while(*p1) { *p1 = toupper( *p1 );  p1++; } // convert to uppercase   
   
#ifdef CONFIG_DEBUG
   printf(" vlabel %s %s %s\n",op,volume,label);
#endif
   
   
   if(op[0] == 'w' || op[0] == 'W') { // write label to volume        
      strcat(tmp,volume);
      strcat(tmp,":");
      strcat(tmp,label);
      res = ioctl(volume,FAT_IOCTL_SET_VLABEL,tmp); 		// we send this directly to the FAT fs driver ...
      return 0;
   }
   
   if(op[0] == 'r' || op[0] == 'R') { // read label from volume  
     
     getlbl.volume = volume; // pointer will be changed by ioctl !
     getlbl.plabel = label;
     getlbl.psn = &sn;
     
     res = ioctl(volume,FAT_IOCTL_GET_VLABEL,&getlbl);
     
     printf(" Volume Label: %s\n",label);
     printf(" Volume S/N  : %04X-%04X\n", sn >> 16, sn & 0xFFFF);
     
     return 0;
   }
   
   printf(" operation '%s' unknown ...\n",op);
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
  // printf("rc=%u\n", disk_read((BYTE)p1, Buff, p2, (BYTE)p3));          
   return 0;
} 
int cmd_bwrite (char * args){
   /* bw <pd#> <sect> <count> - Write Buff[] into disk */
   long p1,p2,p3;
   
   if (!xatoi(&args, &p1) || !xatoi(&args, &p2) || !xatoi(&args, &p3)) return 0;
  // printf("rc=%u\n", disk_write((BYTE)p1, Buff, p2, (BYTE)p3));          
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

int cmd_fstab(char* args)  // wird auch durch mount ohne argumente aufgerufen (= eingehängte file systems)
{
    //  struct fs_driver
    //{
    //	char 				*pname;		/* name of filesystem (FAT,FAT32,NKC...) */
    //	struct file_operations 		*f_oper;	/* file operations */
    //	struct fs_driver			*next;		/* pointer to next driver in driverlist */
    //};
  
    //  struct blk_driver
    //{
    //	char				*pdrive;	/* name of drive, i.e. A, B... ,HD, SD... */
    //	struct block_operations 	*blk_oper;	/* block operations */
    //	struct blk_driver		*next;		/* pointer to next driver in driverlist */
    //};
  
    //  struct fstabentry
    //{
    //  char* devicename;				/* devicename A, B ,HDA0 , HDB1... */
    //  char* fsname;					/* file system name FAT32, JADOS ... */
    //  struct fs_driver	*pfsdrv;			/* pointer to file system driver */
    //  struct blk_driver *pblkdrv;			/* pointer to block device driver */
    //  unsigned char options;			/* mount options */
    //  struct fstabentry* next;			/* pointer to next fstab entry */
    //};
  int res, line; 
  struct fstabentry *fstab;
  
  res = ioctl(NULL,FS_IOCTL_GETFSTAB,&fstab);
  line = 0;
  
  printf(" FS       VOL     PHYS      FSOPER         BLKOPER        OPT\n\n");
  
  while(fstab)
  {		
      printf(" %-8s %-7s %-9d 0x%011x  0x%011x  %d\n",fstab->pfsdrv->pname, fstab->devname, fstab->pdrv, fstab->pfsdrv->f_oper, fstab->pblkdrv->blk_oper, fstab->options);      
      if(!(++line % 10)) getchar(); 
      
      fstab = fstab->next;
  }
  
  return 0;
}

int cmd_fs(char* args)
{
  int res, line; 
  struct fs_driver *p_fs_driver;
  
  res = ioctl(NULL,FS_IOCTL_GETFSDRIVER,&p_fs_driver);
  line = 0;
  
  printf(" FS          FSOPER\n\n");
  
  while(p_fs_driver)
  {		
      printf(" %-10s  0x%x\n",p_fs_driver->pname, p_fs_driver->f_oper );      
      if(!(++line % 10)) getchar(); 
      
      p_fs_driver = p_fs_driver->next;
  }
  
  return 0;
}

int cmd_fatinfo(char* args)
{
  int res;
  
  res = ioctl(NULL,FAT_IOCTL_INFO,"FAT");

  return 0;
}

int cmd_dev(char* args)
{
  int res, line; 
  struct blk_driver *driver;
  
  res = ioctl(NULL,FS_IOCTL_GETBLKDEV,&driver);
  line = 0;
  
  printf(" DRIVE    BLKLDRV    BLKOPER\n\n");
  
  while(driver)
  {		
      printf(" %-7s  0x%x      0x%x\n",driver->pdrive, driver, driver->blk_oper);      
      if(!(++line % 10)) getchar(); 
      
      driver = driver->next;
  }
  
  return 0;
}

int cmd_meminfo(char* args)
{
  int res, line; 
 
  walk_heap();  // /nkc/first
  
#ifdef USE_JADOS
  printf(" JADOS User-Start : 0x%x\n",_nkc_get_laddr() );  
  printf(" JADOS RAMTOP     : 0x%x\n",_nkc_get_ramtop() );
  printf(" JADOS GP-Start   : 0x%x\n",_nkc_get_gp() );
#endif
    
  return 0;
}

int cmd_history(char* args)
{
  // shell.c: char HistoryBuffer[MAX_HISTORY+1][MAX_CHAR]; /* History Buffer */
  char line = 0;
  char level = histOLDEST;
  
  printf("command history:\n");
  
  while(level != histNEWEST) {
    printf("%s\n",HistoryBuffer[level++]);    
    
    if(level > MAX_HISTORY) level = 0; 
    
    if(!(++line % 10)) getchar();     
  }
  
  return 0;
}




// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// ------------------------------------------ conio test --------------------------------------------------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

// define number of pixel per byte
#define PPB 2
// define resolution
#define HPIXELS 512
#define VPIXELS 256



#if defined M68000
#define GDPBASE 0x0E00000
#elif defined M68020
#define GDPBASE 0x1C00000
#else
#error "conio.c: no cpu type given"
#endif
   

#define PAGE0 GDPBASE
#define PAGE1 GDPBASE + 1 * (HPIXELS/PPB * VPIXELS)
#define PAGE2 GDPBASE + 2 * (HPIXELS/PPB * VPIXELS)
#define PAGE3 GDPBASE + 3 * (HPIXELS/PPB * VPIXELS)


static 
unsigned char *mem[] = {(unsigned char*) PAGE0,
                        (unsigned char*) PAGE1,
		        (unsigned char*) PAGE2,
		        (unsigned char*) PAGE3,
                       };

	
/* ******************************************************************************************************************************************
 * 	arbitrary functions, slow
 *
 *
 * ******************************************************************************************************************************************/

static 
void drv_put_pixel(int x, int y, int p, unsigned char color)
{
  
    register unsigned char tmp,mask,col;
    
    col=0;
#if PPB == 8
    register int offset = (y<<6) + x/8;
    mask = 0b10000000 >> (x % 8);
    if(color)
      col  = 0b10000000 >> (x % 8);    
#elif PPB == 4       
    register int offset = (y<<7) + x/4;
    mask = 0b11000000 >> ((x % 4)*2);
    if(color)
      col  = (color << 6) >> ((x % 4)*2);
#elif PPB == 2   
    register int offset = (y<<8) + x/2;
    mask = 0b11110000 >> ((x % 2)*4);
    if(color)
      col  = (color << 4) >> ((x % 2)*4);    
#elif PPB == 1   
    register int offset = (y<<9) + x;
    mask = 0b11111111;   
    col = color; 
#endif        

    if(color)
    {
      tmp = *(mem[p] + offset) & ~mask;            
      *(mem[p] + offset) = tmp | col;
    }
    else
    {
      *(mem[p] + offset) &= ~mask;
    }        
}


/*
 * static void drv_fill_area(int x1, int y1, int x2, int y2, int p, unsigned char color)
 * 
 * Input:
 * 	x1,y1	-	left bottom corner of area 
 * 	x2,y2	-	top rigth corner of area 
 * 	buffer	-	pointer to buffer, enough buffer space must already be allocated by caller
 * 	page	-	gdp page
 * 
 * Output:

 */ 
static 
void drv_fill_area(int x1, int y1, int x2, int y2, int p, unsigned char color)
{
  
    register unsigned char tmp,mask,col;
    register int offset,col16,xx1,xx2,yy; 
    
    col16=color + (color << 4) + (color << 8) + (color << 12); // 4 Pixel auf Einmal !!
    
   
    // linker Rand
    xx1 = x1;
    switch(xx1 % 4)
      {
	
	case 2: // 8-Bit Grenze
		// erstes Byte komplett
		// Rest mit memset16
	  for(yy = y1; yy < y2; yy++)
	  {
	    offset = (yy<<8) + xx1/2;
	    *(mem[p]+offset) = (unsigned char)(color + (color << 4));	    
	  }
	  xx1+=2;	  
	  break;
	case 1: // zweites Pixel erstes Byte eines Word
		// erstes Byte mit drv_put_pixel
		// zweites Byte komplett als Byte
	  for(yy = y1; yy < y2; yy++)
	  {
	    drv_put_pixel(xx1,yy,p,color);
	    offset = (yy<<8) + (xx1+1)/2;
	    *(mem[p]+offset) = (unsigned char)(color + (color << 4));
	  }	  	  
	  xx1+=3;
	  break;
	case 3: // zweites Pixel zweites Byte eines Word
		// erstes Byte mit drv_put_pixel
		// Rest mit memset16
	  for(yy = y1; yy < y2; yy++)
	  {
	      drv_put_pixel(xx1,yy,p,color);	      
	  }	  	  
	  xx1+=1;
	  break;
	case 0: // 16-Bit Grenze (0,4,8,12...)
	        // memset16
	  break;
	  
      }
      
      // Rechter Rand
      xx2 = x2;
      switch(xx2 % 4)
      {
	case 0: // letzten 3 Pixel felhlen
	  for(yy = y1; yy < y2; yy++)
	  {	    	    
	    drv_put_pixel(xx2,yy,p,color);
	  }
	  xx2--;	  
	  break;
	case 1: // letzte beiden Pixel fehlen
	  for(yy = y1; yy < y2; yy++)
	  {	    
	    offset = (yy<<8) + (xx2-1)/2;
	    *(mem[p]+offset) = (unsigned char)(color + (color << 4));
	  }
	  xx2-=2;;	  
	  break;
	case 2: // letztes Pixel fehlt	
	  for(yy = y1; yy < y2; yy++)
	  {	    
	    offset = (yy<<8) + (xx2-2)/2;
	    *(mem[p]+offset) = (unsigned char)(color + (color << 4));
	    drv_put_pixel(xx2,yy,p,color);
	  }
	  xx2-=3;	  
	  break;
	case 3: // 16-Bit voll	      	  
	  break;
      }
	  
      // fast fill ...
      for(yy = y1; yy < y2; yy++)
      {
	offset = (yy<<8) + xx1/2;
	memset16(mem[p]+offset,col16,(xx2-xx1)/2);
      }


}

static
void drv_save_area(void* buffer,unsigned int x,unsigned int y,unsigned int sx,unsigned int sy,unsigned int page)
{
  unsigned char pixel_offset; 			// -3 ... +3, legt notwenidge Verschiebung der 16Bit Wortes fest
  unsigned char left_mask, right_mask;		// legt fest, welche bits im Zielbereich maskiert werden müssen

}

static
void drv_restore_area(void* buffer,unsigned int x,unsigned int y,unsigned int sx,unsigned int sy,unsigned int page)
{
  unsigned char pixel_offset; 			// -3 ... +3, legt notwenidge Verschiebung der 16Bit Wortes fest
  unsigned char left_mask, right_mask;		// legt fest, welche bits im Zielbereich maskiert werden müssen

}

static
void drv_move_area(unsigned int x1,unsigned int y1,unsigned int x2,unsigned int y2,unsigned int sx,unsigned int sy,unsigned int page)
{
  unsigned char pixel_offset; 			// -3 ... +3, legt notwenidge Verschiebung der 16Bit Wortes fest
  unsigned char left_mask, right_mask;		// legt fest, welche bits im Zielbereich maskiert werden müssen
  
}

static
void drv_draw_line(unsigned int x1, unsigned int y1, unsigned int x2, unsigned int y2, unsigned int page, unsigned int color)
{
}

/* ******************************************************************************************************************************************
 * 	optimized functions for 16 bit access, faster ....
 *
 *
 * ******************************************************************************************************************************************/

/*
 * static void drv_fill_area16(int x, int y, int sx, int sy, int p, unsigned char color)
 * 
 * Input:
 * 	x1,y1	-	left bottom corner of area (x1 has to be at 16 bit boundary: if PPB=2 => x1 in 0,4,8,12 ....)
 * 	sx,sy	-	sizes of area in pixels in x and y direction (sx has to be multiple of 4 if PPB=2)
 * 	buffer	-	pointer to buffer, enough buffer space must already be allocated by caller
 * 	page	-	gdp page
 * 	color	-	fill color
 * 
 * Output:

 */ 
static 
void drv_fill_area16(int x, int y, int sx, int sy, int p, unsigned char color)
{
   register unsigned long i,xx,yy,offset;
   register unsigned short col16;

   
   col16=color + (color << 4) + (color << 8) + (color << 12); // 4 Pixel auf Einmal !!
   
    // fast fill ...
    for(yy = y; yy < y+sy; yy++)
    {
      offset = (yy<<8) + x/2;
      memset16(mem[p]+offset,col16,sx/2);
    }
}


/*
 * static int drv_save_area16(void* buffer,unsigned int x,unsigned int y,unsigned int sx,unsigned int sy, unsigned int page)
 * 
 * Input:
 * 	x,y	-	left bottom corner of area (x has to be at 16 bit boundary: if PPB=2 => x in 0,4,8,12 ....)
 * 	sx,sy	-	sizes of area in pixels in x and y direction (sx has to be multiple of 4 if PPB=2)
 * 	buffer	-	pointer to buffer, enough buffer space must already be allocated by caller
 * 	page	-	gdp page
 * 
 * Output:
 * 	0	- 	success
 * 	1	-	failed 
 */ 
static
int drv_save_area16(void* buffer,unsigned int x,unsigned int y,unsigned int sx,unsigned int sy,unsigned int page)
{
  register unsigned long i,xx,yy,offset;
  
  // check, if values are at 16bit boundary
  
  for(yy=y; yy<y+sy; yy++) {
	offset = (yy<<8) + x/2;
        memcpy16(buffer+(yy-y)*sx, mem[page]+offset, sx/2);
      }
}

/*
 * static int drv_restore_area16(void* buffer,unsigned int x,unsigned int y,unsigned int sx,unsigned int sy, unsigned int page)
 * 
 * Input:
 * 	x,y	-	left bottom corner of area (x has to be at 16 bit boundary: if PPB=2 => x in 0,4,8,12 ....)
 * 	sx,sy	-	sizes of area in pixels in x and y direction (sx has to be multiple of 4 if PPB=2)
 * 	buffer	-	pointer to buffer, enough buffer space must already be allocated by caller
 * 	page	-	gdp page
 * 
 * Output:
 * 	0	- 	success
 * 	1	-	failed 
 */ 
static
int drv_restore_area16(void* buffer,unsigned int x,unsigned int y,unsigned int sx,unsigned int sy,unsigned int page)
{
  register unsigned long i,xx,yy,offset;
  
  // check, if values are at 16bit boundary
  
  for(yy=y; yy<y+sy; yy++) {
	offset = (yy<<8) + x/2;
        memcpy16( mem[page]+offset, buffer+(yy-y)*sx, sx/2);
      }
}

static
void drv_draw_border(unsigned int x, unsigned int y, unsigned int sx, unsigned int sy, unsigned int page, unsigned int color, unsigned int single)
{
  gdp_set_page(0, 0, 1);
  gdp_setcolor(color, 0);
  
  gdp_movetoxy(x,y);
  gdp_drawtoxy(x+sx,y);
  gdp_drawtoxy(x+sx,y+sy);
  gdp_drawtoxy(x,y+sy);
  gdp_drawtoxy(x,y);
}


/* ******************************************************************************************************************************************
 * 	shell commands ....
 *
 *
 * ******************************************************************************************************************************************/



int cmd_setpoint(char* args)
{
  // SP: set point <x,y,page,color>
  
  unsigned long x,y,page,color,offs;
  unsigned char *p;

  
  if (!xatoi(&args, &x) || !xatoi(&args, &y) || !xatoi(&args, &page)|| !xatoi(&args, &color)) return 0;
  
  drv_put_pixel(x,y,page,color);
  
  return 0;
}

int cmd_fill(char* args)
{
  // FILL: fill area <x1,y1,x2,y2, page,color>
  
  unsigned long x1,y1,x2,y2,page,color,offs;
  unsigned char *p;

  
  if (!xatoi(&args, &x1) || !xatoi(&args, &y1) || !xatoi(&args, &x2) || !xatoi(&args, &y2) || !xatoi(&args, &page)|| !xatoi(&args, &color)) return 0;
  
  
  drv_fill_area(x1,y1,x2,y2,page,color);
  
  return 0;
}


int cmd_test(char* args)
{
  
  nkc_curoff();
  nkc_setflip(0,0);
  
  gdp_init();
  gdp_sethwcursor(1);
  
  drv_draw_border(4,4,43,40,0,4,0);
  
  nkc_getchar();
  
  gdp_sethwcursor(0);
  nkc_curon();
  nkc_setflip(20,0);
  
  return 0;
}
