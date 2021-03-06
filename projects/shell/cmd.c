#include <stdlib.h>
#include <string.h>
#include <time.h>       /* time_t, struct tm, difftime, time, mktime */
#include <ioctl.h>
#include <errno.h>

#include <fs.h>

#include <debug.h>

#include "helper.h"
#include "cmd.h"
#include "shell.h"

#include "fdisk.h"
#include "wildcmp.h"

#include "sys.h"

#include "../../fs/fat/ff.h"
#include "../../fs/nkc/fs_nkc.h"
#include "../../nkc/llnkc.h"
#include "../../nkc/nkc.h"
#include "./../drivers/block/sdcard.h"
#include "./../drivers/block/sd_block_drv.h"


extern int _ll_settime(struct tm *tm2);

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
//#define TEXT_CMDHELP_MKPTABLE           33
#define TEXT_CMDHELP_UMOUNT             34
#define TEXT_CMDHELP_PTABLE             35
#define TEXT_CMDHELP_CLS             	36
#define TEXT_CMDHELP_FSTAB				37
#define TEXT_CMDHELP_FS    				38
#define TEXT_CMDHELP_DEV				39
#define TEXT_CMDHELP_FATINFO			40
#define TEXT_CMDHELP_MEMINFO			41
#define TEXT_CMDHELP_HISTORY			42
#define TEXT_CMDHELP_FDISK        43
#define TEXT_CMDHELP_SYS        44
#define TEXT_CMDHELP_CLOCK    			45


#define TEXT_CMDHELP                    46

// TEST commands ...
#define	TEXT_CMDHELP_SP					47
#define	TEXT_CMDHELP_FILL				48
#define	TEXT_CMDHELP_TEST				49

// Help text ... 
static struct CMDHLP hlptxt[] =
{
{TEXT_CMDHELP_CLS,              
                        "cls: clear screen\n",
                        "cls \n"},	
{TEXT_CMDHELP_FSTAB,              
                        "fstab: show file system table\n",
                        "fstab \n"},
{TEXT_CMDHELP_FS,              
                        "fs: show registered file system\n",
                        "fs \n"},
{TEXT_CMDHELP_FATINFO,              
                        "fatinfo: show info about FAT file system\n",
                        "fatinfo \n"},
{TEXT_CMDHELP_DEV,              
                        "dev: show registered devices\n",
                        "dev \n"},
{TEXT_CMDHELP_MEMINFO,              
                        "meminfo: show availabe memory\n",
                        "meminfo \n"},
{TEXT_CMDHELP_CHMOD,
                        "chmod: Change file/dir attribute\n",
                        "chmod <attr> <mask> <name>\n"\
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
			                  "cd: change current directory/drive\n",
                        "cd <dir>\n"\
                        "  cd         show current directory\n"\
                        "  cd ..      one level up\n"\
                        "  cd [dir]   change to dir\n"\
                        "  cd 1:      change to logical drive 1\n"},
{TEXT_CMDHELP_COPY,             
                        "copy: copy file(s) or directory(s)\n",
                        "copy <file1> <file2>\n"},
{TEXT_CMDHELP_DEL,              
                        "del: delete a file\n",
                        "del <filename>\n"},
{TEXT_CMDHELP_DIR,              
                        "dir: list directory contents\n",
                        "dir [<dir>]\n"},
{TEXT_CMDHELP_MD,               
                        "mkdir: make a directory\n",
                        "mkdir <dirname>\n"\
                        "mkdir <dirname>\n"},
{TEXT_CMDHELP_REN,              
                        "ren: rename a file/directory\n",
                        "ren <oldname> <newname>\n"},
{TEXT_CMDHELP_RD,               
                        "rmdir: remake/delete a directory\n",
                        "rmdir [-R] <dirname>\n"},

                        
{TEXT_CMDHELP_DI,
	    "dinit <d#>: initialize a disk\n",
            "dinit <disc name>\n"\
            "  disc name is HDA, HDB, SDA, SDB ... \n"},
{TEXT_CMDHELP_DD,
	    "ddump [<d#> <sec#>]: dump sector\n",
            "ddump [<d#> <sec#>]\n"\
            "  dump sector sec# of disc d#\n"\
            "  example: dd sda 10  (dump sector 10 of drive sda)\n"},
{TEXT_CMDHELP_BD,
	    "bdump <ofs>: dump working buffer\n",
            "bdump <buffer offset>\n"},
{TEXT_CMDHELP_BE,
	    "bedit <ofs> [<data>]: edit working buffer\n",
            "bedit <ofs> [<data>]\n"},
{TEXT_CMDHELP_BR,
	    "bread <d#> <sec#> <cnt>: read disk to working buffer\n",
            "bread <d#> <sec#> <cnt>\n"},
{TEXT_CMDHELP_BW,
	    "bwrite <d#> <sec#> <cnt>: write working buffer to disk\n",
            "bwrite <d#> <sec#> <cnt>\n"},
{TEXT_CMDHELP_BF,
	    "bfill <val>: fill working buffer\n",
            "bfill <val>\n"},
{TEXT_CMDHELP_MOUNT,
	    "mount <vol> <fs> : initialize/mount volume \n",
            "mount <vol> <fs>\n"\
            "   vol = hda0,sda1,hda0x1 ...\n"\
            "   fs = FAT,JDFS ...\n"\
	    "   mount only shows mounted volumes\n"},
{TEXT_CMDHELP_UMOUNT,
	    "umount <vol>: unmount volume\n",
            "umount <vol>  \n"\
            "   vol = hda0,sda1,hda0x1 ...\n"},            
{TEXT_CMDHELP_VSTATUS,
  	    "vstatus <vol>: show info of volumes FATFS structure\n",
            "vstatus <volume>\n"\
            "   - volume must be mounted.\n"\
            "   - info: FAT Type, FAT Start, DIR start, Data Start,\n"\
	    "           Root DIR entries, number of clusters\n"},	    
{TEXT_CMDHELP_LSTATUS,
	    "lstatus : info on FS(FAT..) structure in current drive/directory\n",
            "lstatus :\n"\
            "    - info: FAT Type, Number of FATs, ClusterSize in sectors and bytes,\n"\
            "            Volume Label and S/N, number of files/directories,\n"\
            "            total/available disk space\n"},	  
{TEXT_CMDHELP_DS,
	    "dstatus <d#>: physical disk status (calls block driver)\n",
            "dstatus <d#>\n"\
            "  d# = HDA, HDB, SDA, SDB ....\n"\
            "  info: Model, Serial-Number,cyl-sec-heads, tracks LBA-Sectors etc.\n"},	    
{TEXT_CMDHELP_FOPEN,
	    "fopen <file> <mode>: open a file\n",
            "fopen <file> <mode>\n"\
            " mode:\n"\
            "    read           r  --> file[0]\n"\
            "    write          w  --> file[1]\n"\
            "    append         a\n"\
            "    binary         b\n"\
            "    text/ascii     t\n"\
	    "    update         +\n"},
{TEXT_CMDHELP_FCLOSE,
	    "fclose <n>: close file[n]\n",
            "fclose <n>\n"},
{TEXT_CMDHELP_FSEEK,
	    "fseek <n> <mode> <ofs>: move filepointer of file n in mode\n",
            "fseek <n> <mode> <ofs>\n"\
            "      mode:\n"\
            "      0 - SEEK_SET : Beginning of file\n"\
            "      1 - SEEK_CUR : Current position of the file pointer\n"\
            "      2 - SEEK_END : End of file\n"},
{TEXT_CMDHELP_FDUMP,
	    "fdump <len>: dump the file\n",
            "fdump <len>\n"},
{TEXT_CMDHELP_FREAD,
	    "fread <len>: read the file\n",
            "fread <len>\n"},
{TEXT_CMDHELP_FWRITE,
	    "fwrite <len> <val>: write to the file\n",
            "fwrite <len> <val>\n"},
{TEXT_CMDHELP_FTRUNK,
	    "ftrunk : trunkate the file at current position\n",
            "ftrunk\n"},
{TEXT_CMDHELP_VLABEL,
	    "vlabel <op> <volume> <label>: read/write volume label\n",
            "vlabel <op> <volume> <label>\n"\
            "    example: vlabel w hda0 test - sets label of hda0 to 'test'\n"\
            "             vlabel w hdb0      - clears label of hdb0\n"\
            "             vlabel r hda1      - reads label of hda1\n"},
{TEXT_CMDHELP_MKFS,
	    "mkfs <ld#> <fs> <rule> <cluster size>: create a file system\n",
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
{TEXT_CMDHELP_PTABLE,
	    "ptable <pd#>  - show partition table of physical drive pd# \n",
            "ptable <pd#>\n"\
	    "  example:\n"\
	    "     ptable hda\n"},                      
{TEXT_CMDHELP_PWD,
	    "pwd: print working directory\n",
            "pwd\n"},  
{TEXT_CMDHELP_FDISK,
      "fdisk <device> - the fdisk utility\n",
            "fdisk hda\n"},  
{TEXT_CMDHELP_SYS,
      "sys <device> <loader> <os> [options]- install bootloader\n",
            "sys hda0 MBR.68k OS.SYS\n\n"\
            " MBR.68K is the MBR loader merged to sector 0 of disk/partition\n"\
            " OS.SYS is the os that should be loaded by the loader\n\n"\
            " options:\n"\
            "    -t  run in test mode (nothing will be written to disk)\n"\
            "    -b  put loader at sector 1 (needs space between MBR and 1st partition !)\n\n"\
            " example:\n"\
            "  sys hda MBR.bin shell.68k -b\n"\
            "   puts MBR.bin at sector 0 of hda and shell.68k to sector 1\n"},                                
	    
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
                        "quit: quit/exit program\n",
                        "quit\n"},    
{TEXT_CMDHELP_HISTORY,             
                        "history: show command history\n",
                        "history\n"},	
{TEXT_CMDHELP_CLOCK,             
                        "clock: show system clock (RTC)\n",
                        "clock [MMDDhhmm[[CC]YY][.ss]]\n"},                                                  			
{TEXT_CMDHELP,
			"type cmd /? for more information on cmd\n",""},        
        {0,"",""}
};


// list of available commands ...
static struct CMD internalCommands[] =
{
  {"cls"        , cmd_cls       , TEXT_CMDHELP_CLS},
  {"fstab"      , cmd_fstab     , TEXT_CMDHELP_FSTAB},
  {"fs"         , cmd_fs        , TEXT_CMDHELP_FS},
  {"fatinfo"    , cmd_fatinfo   , TEXT_CMDHELP_FATINFO},
  {"dev"        , cmd_dev       , TEXT_CMDHELP_DEV},
  {"meminfo"    , cmd_meminfo   , TEXT_CMDHELP_MEMINFO},
  {"dinit"      , cmd_dinit     , TEXT_CMDHELP_DI},  
  {"ddump"      , cmd_ddump     , TEXT_CMDHELP_DD},
  {"dd"      	  , cmd_ddump     , TEXT_CMDHELP_DD},
  {"dstatus"    , cmd_dstatus   , TEXT_CMDHELP_DS},
  {"bdump"      , cmd_bdump     , TEXT_CMDHELP_BD},
  {"bedit"      , cmd_bedit     , TEXT_CMDHELP_BE},
  {"bread"      , cmd_bread     , TEXT_CMDHELP_BR},
  {"bwrite"     , cmd_bwrite    , TEXT_CMDHELP_BW},
  {"bfill"      , cmd_bfill     , TEXT_CMDHELP_BF}, 
  {"mount"      , cmd_mount     , TEXT_CMDHELP_MOUNT},
  {"umount"     , cmd_umount    , TEXT_CMDHELP_UMOUNT},
  {"vstatus"    , cmd_vstatus   , TEXT_CMDHELP_VSTATUS},
  {"lstatus"    , cmd_lstatus   , TEXT_CMDHELP_LSTATUS},
  {"fopen"      , cmd_fopen     , TEXT_CMDHELP_FOPEN},
  {"fclose"     , cmd_fclose    , TEXT_CMDHELP_FCLOSE},
  {"fseek"      , cmd_fseek     , TEXT_CMDHELP_FSEEK},
  {"fdump"      , cmd_fdump     , TEXT_CMDHELP_FDUMP},
  {"fread"      , cmd_fread     , TEXT_CMDHELP_FREAD},
  {"fwrite"     , cmd_fwrite    , TEXT_CMDHELP_FWRITE},
  {"ftrunk"     , cmd_ftrunk    , TEXT_CMDHELP_FTRUNK},
  {"vlabel"     , cmd_vlabel    , TEXT_CMDHELP_VLABEL},
  {"mkfs"       , cmd_mkfs      , TEXT_CMDHELP_MKFS},        
  {"pwd"        , cmd_pwd       , TEXT_CMDHELP_PWD},  
  {"chmod"      , cmd_chmod     , TEXT_CMDHELP_CHMOD},
  {"attrib"     , cmd_chmod     , TEXT_CMDHELP_CHMOD},
  {"cd"         , cmd_chdir     , TEXT_CMDHELP_CD},  
  {"chdir"      , cmd_chdir     , TEXT_CMDHELP_CD},
  {"copy"       , cmd_copy      , TEXT_CMDHELP_COPY },
  {"cp"         , cmd_copy      , TEXT_CMDHELP_COPY },
  {"del"        , cmd_del       , TEXT_CMDHELP_DEL},
  {"dir"        , cmd_dir       , TEXT_CMDHELP_DIR},
  {"ls"         , cmd_dir       , TEXT_CMDHELP_DIR},
  {"mkdir"      , cmd_mkdir     , TEXT_CMDHELP_MD},
  //{"mkptable"   , cmd_mkptable  , TEXT_CMDHELP_MKPTABLE},
  {"ptable"     , cmd_ptable    , TEXT_CMDHELP_PTABLE},  
  {"ren"        , cmd_rename    , TEXT_CMDHELP_REN},
  {"rename"     , cmd_rename    , TEXT_CMDHELP_REN},
  {"rmdir"      , cmd_rmdir     , TEXT_CMDHELP_RD},
  {"quit"       , cmd_quit      , TEXT_CMDHELP_QUIT},
  {"q"          , cmd_quit      , TEXT_CMDHELP_QUIT},  
  {"exit"       , cmd_quit      , TEXT_CMDHELP_QUIT},
  {"history"    , cmd_history   , TEXT_CMDHELP_HISTORY},
  {"hist"       , cmd_history   , TEXT_CMDHELP_HISTORY},
  {"clock"      , cmd_clock     , TEXT_CMDHELP_CLOCK},
  {"test"       , cmd_test   	  , TEXT_CMDHELP_TEST},
  {"fdisk"      , cmd_fdisk     , TEXT_CMDHELP_FDISK},
  {"sys"        , cmd_sys       , TEXT_CMDHELP_SYS},  
  {"t"          , cmd_test   	  , TEXT_CMDHELP_TEST},
  {"?"          , cmd_shcmds    , TEXT_CMDHELP_QUESTION},
  
  {0,0,0}
};

static struct SHELL_ENV cmd_env;

/*---------------------------------------------------------*/
/* external variables                                      */
/*---------------------------------------------------------*/

extern char   _start;
extern char   __BUILD_DATE;
extern char   __BUILD_NUMBER;

extern void* _RAM_TOP;
extern void* _HEAP;

struct block_header{
			ULONG start;	// block start
			ULONG size;	// block size
			void *next;	// next memory block in chain
			ULONG free;	//for allocated or not (0 if allocated)					
};

/*---------------------------------------------------------*/
/* Work Area                                               */
/*---------------------------------------------------------*/

LONGLONG AccSize;			/* Work register for scan_fat_files() */

WORD AccFiles, AccDirs;
BYTE *Buff;           /* a work buffer */
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
	struct rc_code_struct *p_rc_code;
	
	for (p_rc_code = rc_codes
        ; p_rc_code->rc_string && p_rc_code->rc != rc
        ; p_rc_code++){
        }
	
	return p_rc_code->rc_string;
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
	printf("rc=%u '%s'\n", (UINT)rc, get_rc_string(rc));
}


FRESULT scan_fat_files (	/* used in cmd_lstatus */
	char* ppath		/* Pointer to the path name working buffer */
)
{
	DIR dir;			/* directory object */
	FRESULT res;
	FILINFO Finfo;			/* File info object */
	int i;
	char *fn;
	char* save_ptr;
	struct ioctl_opendir arg_opendir;
	struct ioctl_readdir arg_readdir;
	
	
	
	dbg("scan_fat_files(%s) ...\n",ppath);
	save_ptr = ppath;
	dbg("   (1) save_ptr(0x%0x)->(%s) ...\n",save_ptr,save_ptr);
	
	arg_opendir.path = ppath;
	arg_opendir.dp = &dir;		
	arg_readdir.dp = &dir;
	arg_readdir.fno = &Finfo;

	
	if ((res = ioctl(FPInfo.psz_driveName,FS_IOCTL_OPEN_DIR,&arg_opendir)) == FR_OK) {
		i = strlen(ppath);
		
		dbg("scan_fat_files after opendir: ppath(0x%0x)->'%s' ...\n",ppath,ppath);
		dbg("   (2) save_ptr(0x%0x)->(%s) ...\n",save_ptr,save_ptr);
		
		
		while (((res = ioctl(FPInfo.psz_driveName,FS_IOCTL_READ_DIR,&arg_readdir)) == FR_OK) && Finfo.fname[0]) {
		  
			dbg("scan_fat_files after readdir: ppath->'%s' ...\n",ppath);
			dbg("%s -- DIR.index = %d\n",Finfo.fname,dir.index);
			
			if (_FS_RPATH && Finfo.fname[0] == '.') continue;
#if _USE_LFN
			fn = *Finfo.lfname ? Finfo.lfname : Finfo.fname;
#else
			fn = Finfo.fname;
#endif			
			
			if (Finfo.fattrib & AM_DIR) {
				AccDirs++;
				
				if( strlen(ppath) + strlen(fn) + 2 < _MAX_PATH){ // paranoja check !
				  *(ppath+i) = '/'; strcpy(ppath+i+1, fn);  /* add subdir info */
				  dbg("scan_fat_files: recurse with path = '%s' ...\n",ppath);
				  res = scan_fat_files(ppath);	/* recurse into subdir */
				 *(ppath+i) = '\0';	/* remove subdir info to proceed in current directory */
				 dbg("scan_fat_files: continue with path = '%s' ...\n",ppath);
				} else {
				  printf(" cannot recurse deeper, buffer too small ...\n");
				}
				
				if (res != FR_OK) break;
			} else {
				lldbg("scan_fat_files: AccFiles++; AccSize += Finfo.fsize\n");
				printf("%s/%s\n", ppath, fn);
				AccFiles++;
				AccSize += Finfo.fsize;
			}
		}
		lldbg("scan_fat_files: about to close dir...\n");
		res = ioctl(FPInfo.psz_driveName,FS_IOCTL_CLOSE_DIR,&dir);
		if(res) printf("error 0:%d in scan_fat_files\n",res);
	} else printf("error 1:%d in scan_fat_files\n",res);

	printf("scan_fat_files => %d\n",res);
	return res;
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



// ******************  commands.... *************************************
int cmd_shcmds(void){
  showcmds(hlptxt);
}

int cmd_cls (void){
  gp_clrscr();
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
    
#ifdef CONFIG_DEBUG   
   printf(" FS_IOCTL_CHDRIVE => %d\n",res);
#endif
   
   arg.cpath = FPInfo.psz_cpath;
   arg.cdrive  = FPInfo.psz_cdrive;
   arg.size = _MAX_PATH;
   res = ioctl(NULL,FS_IOCTL_GETCWD,&arg);

#ifdef CONFIG_DEBUG   
   printf(" FS_IOCTL_GETCWD => %d\n",res);
#endif  
   
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
   printf(" cmd_chdir(%s)\n",args);
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
  struct fstabentry *pfstab;
  
  while (*args == ' ') args++;
  

  dbg("cmd_dir(%s) ...\n",args);

  res = checkargs(args, fullpath1, NULL);

  dbg(" dir [%s] ... \n",fullpath1);

  printf(" directory of %s is:\n",fullpath1);

  if(FPInfo1.psz_driveName[0])
    pfstab = get_fstabentry(FPInfo1.psz_driveName);
  else pfstab  = get_fstabentry(FPInfo1.psz_cdrive);
  
  if( pfstab ){
    if( !strcmp(pfstab->pfsdrv->pname, "JDFS") ||  // JADOS drive
        !strcmp(pfstab->pfsdrv->pname, "FAT") )  { // FAT drive

      if(FPInfo1.psz_driveName[0])
        res = cmd_dir_fat(fullpath1,FPInfo1.psz_driveName,FPInfo1.b_has_wcard,FPInfo1.psz_wcard);
      else res = cmd_dir_fat(fullpath1,FPInfo1.psz_cdrive,FPInfo1.b_has_wcard,FPInfo1.psz_wcard);

      if(res) printf(" cmd_dir_fat returned '%s'\n",get_rc_string(res));
      return 0;
    }else{ // unknown filesystem
      printf(" error: unknown filesystem '%s'\n",pfstab->pfsdrv->pname);
      return 0;
    }
  }

      
}


int cmd_dir_fat(char *args,   // fullpath
		char* pd,                 // drivename
    BOOL b_has_wcard,         // use wildcard matching
    char* wc )                // wildcard string
{
   
   DIR dir;				/* FAT Directory object */
   FILINFO Finfo;			/* File info object */
   FS *fs;				/* Pointer to file system object */
   FRESULT res;
   UINT s1, s2;
   char key=0;
   long p1,p2,line=0;  
   
   struct ioctl_opendir arg_opendir;
   struct ioctl_readdir arg_readdir;
   struct ioctl_getfree arg_getfree;
  
   dbg(" cmd_dir_fat(%s,%s,%d,%s)\n",args,pd,b_has_wcard,wc);
   
   while (*args == ' ') args++;     
   
   arg_opendir.dp = &dir;
   arg_opendir.path = args;
   
   res = ioctl(pd,FS_IOCTL_OPEN_DIR,&arg_opendir);
   
   if (res) { put_rc(res); return 0; }
   AccSize = s1 = s2 = 0;
   
   printf("Attr.    Date    Time      Size   File-Name\n\n");
   
   for(;;) {
        arg_readdir.dp = &dir;
      	arg_readdir.fno = &Finfo;

      	res = ioctl(pd,FS_IOCTL_READ_DIR,&arg_readdir);
      	
      	if ((res != FR_OK) || !Finfo.fname[0]) break;


        if(b_has_wcard){
          if (wildcmp(wc, Finfo.fname)) {
            dbg(" %s ---> we have a match!\n",Finfo.fname);
          } else {
            dbg(" %s ---> no match =(\n",Finfo.fname);
            continue;
          }          
        }


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
         	    printf(" ---- KEY ---- "); key=getchar(); printf("\n");
      	}
	     line++;
       if(key=='q' || key=='Q') break;
   }

   res = ioctl(pd,FS_IOCTL_CLOSE_DIR,&dir);
   printf("%4u File(s),%11llu bytes total\n%4u Dir(s)", s1, AccSize, s2);     
   
   arg_getfree.path = args;
   arg_getfree.nclst = (DWORD*)&p1;
   arg_getfree.ppfs = &fs;   
   if(ioctl(pd,FS_IOCTL_GET_FREE,&arg_getfree) == FR_OK) {
     
	  switch(fs->fs_id) {
	    case FS_TYPE_FAT:   
		  p2 = ((FATFS*)fs)->csize *512; 
		  dbg("fs_id = FS_TYPE_FAT\n");
		  break;
	    case FS_TYPE_JADOS: 
	          p2 = ((JDFS*)fs)->pjdhd->csize;
		  dbg("name  = %s\n",((JDFS*)fs)->pjdhd->name);
		  dbg("csize = %d\n",((JDFS*)fs)->pjdhd->csize);
		  dbg("sects = %d\n",((JDFS*)fs)->pjdhd->nsectors);
		  dbg("fs_id = FS_TYPE_JADOS\n");
		  break;
	    default:
	          dbg("fs_id = %d (unknown)\n",fs->fs_id);
	  }
	  
	   printf(",%12llu bytes free\n", (LONGLONG)p1*p2);
   }
   else printf("\n");
   
   return 0;
}



int cmd_mkdir(char *args)
{  
  FRESULT res;
  char fullpath1[_MAX_PATH];
  
  while (*args == ' ') args++;
   
  dbg(" cmd_mkdir(%s)\n",args);

  res = checkargs(args, fullpath1, NULL);

  dbg(" mkdir [%s] ... \n",args);

  if(FPInfo1.psz_driveName[0])
    res = ioctl(FPInfo1.psz_driveName,FS_IOCTL_MKDIR,fullpath1);
  else res = ioctl(FPInfo1.psz_cdrive,FS_IOCTL_MKDIR,fullpath1);

  
  if(res != EZERO) put_rc(res);
   
  return 0;
}

int cmd_rmdir(char *args)
{
  
  FRESULT res;    
  char fullpath1[_MAX_PATH];

  dbg(" RMDIR (%s) ...\n", args);
 
  if(!args) {
	  printf(" usage: rmdir [dirpath]\n\n");
	   return 0;
  }
   
  while (*args == ' ') args++;   
      
  res = checkargs(args, fullpath1, NULL);
   
  if(FPInfo1.psz_driveName[0])
    res = ioctl(FPInfo1.psz_driveName,FS_IOCTL_RMDIR,fullpath1);
  else res = ioctl(FPInfo1.psz_cdrive,FS_IOCTL_RMDIR,fullpath1); 
   
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

int _del(char *dst) {
   FRESULT res=RES_OK; 
   
   dbg(" _del( %s )\n",dst);

   printf(" delete %s\n",dst);
   res = ioctl(NULL,FS_IOCTL_DEL,dst);
  
   if(res) put_rc(res);
   
   return 0;
}

int cmd_del(char *args) {
   /* del <name> - delete a file */
   DIR dir;       /* FAT Directory object */
   FILINFO Finfo;     /* File info object */
   FS *fs;        /* Pointer to file system object */
   FRESULT res;
   UINT s1, s2;
   long p1,p2,line=0;  
   
   struct ioctl_opendir arg_opendir;
   struct ioctl_readdir arg_readdir;
   struct ioctl_getfree arg_getfree;

   char fullpath1[_MAX_PATH];
   char src[_MAX_PATH];
   char dst[_MAX_PATH];
 
   dbg("cmd_del(%s):\n",args);

   checkargs(args, fullpath1, NULL);
    
   dbg("cmd_del: delete [%s]\n",fullpath1);


   if(FPInfo1.b_has_wcard){ /* wild cards in arg ==> cycle through directory and delete all matching files .... */

      /* open dir and cycle through .... */
      arg_opendir.dp = &dir;
      arg_opendir.path = fullpath1;

      if(FPInfo1.psz_driveName[0])
       res = ioctl(FPInfo1.psz_driveName,FS_IOCTL_OPEN_DIR,&arg_opendir);
     else res = ioctl(FPInfo1.psz_cdrive,FS_IOCTL_OPEN_DIR,&arg_opendir);
   
      if (res) { put_rc(res); return 0; }

      for(;;) {
        arg_readdir.dp = &dir;
        arg_readdir.fno = &Finfo;

        if(FPInfo1.psz_driveName[0])
         res = ioctl(FPInfo1.psz_driveName,FS_IOCTL_READ_DIR,&arg_readdir);
        else res = ioctl(FPInfo1.psz_cdrive,FS_IOCTL_READ_DIR,&arg_readdir);
        
        if ((res != FR_OK) || !Finfo.fname[0]) break;

        if( Finfo.fattrib == AM_VOL ) continue; /* Volume Label */
        if( Finfo.fattrib == AM_DIR ) continue; /* Directory */
        if( Finfo.fattrib == AM_LFN ) continue; /* LFN Entry (not supported yet) */

        if (wildcmp(FPInfo1.psz_wcard, Finfo.fname)) {          
          sprintf(dst,"%s%s",fullpath1,Finfo.fname);          
          _del(dst);
        } else {
          dbg(" %s ---> no match =(\n",Finfo.fname);
          continue;
        }                    
    }
    
    if(FPInfo1.psz_driveName[0])
          res = ioctl(FPInfo1.psz_driveName,FS_IOCTL_CLOSE_DIR,&dir);       
    else res = ioctl(FPInfo1.psz_cdrive,FS_IOCTL_CLOSE_DIR,&dir); 

   }else{
    // standard (no wildcard) delete
    printf("standard del ....\n");
    //sprintf(dst,"%s/%s",fullpath1,Finfo.fname);          
    _del(fullpath1);
   }

   return 0;
}


// calls via ioctl (end) -------

// standard clib calls (start) -----

int _copy(char *src, char *dst)
{
   FRESULT res;
   char *ptr2;   
   long p1;
   UINT s1,s2;
    
   dbg("_copy: copy ['%s' -> '%s']\n",src,dst);
   //printf("_copy: copy [%s -> %s]\n",src,dst); return 0;

   dbg("_copy: Opening '%s'\n", src);

   //                                0x00		0x01
   //res = f_open(&file[0], args, FA_OPEN_EXISTING | FA_READ);
   file[0] = fopen(src,"rb");
   
   if (file[0]==NULL) {
      printf("error opening source '%s' !\n",src);
      return 0;
   }

   dbg("_copy: Creating '%s'\n", dst); 

   //                                  0x08		0x02
   //res = f_open(&file[1], ptr2, FA_CREATE_ALWAYS | FA_WRITE);
   file[1] = fopen(dst,"wb");

   if (file[1]==NULL) {
     fclose(file[0]);
     printf("error creating destination '%s' !\n",dst);
    
     return 0;
   }
   printf("Copy '%s' ==> '%s' ",src,dst);
   
   p1 = 0;
   start_progress();
   for (;;) {
     do_progress();
     s1 = fread(Buff, 1, sizeof Buff, file[0]); 
     if (s1 == 0) {
       dbg("\n_copy: src at eof !\n");
       break;   /* error or eof */
     }

     s2 = fwrite(Buff, 1, s1, file[1]);         

     p1 += s2;

     //printf("%d bytes written to destination (total %d)\n",s2,p1);

     if (s2 < s1) {
       printf("\nerror or disk full !\n");
       break;   /* error or disk full */
     }

   }

   fclose(file[0]);
   fclose(file[1]);
   printf("\n%lu bytes\n", p1);
  
   return 0;
}


int cmd_copy(char *args) /* wildcard copy */
{
   
   DIR dir;       /* FAT Directory object */
   FILINFO Finfo;     /* File info object */
   FS *fs;        /* Pointer to file system object */
   FRESULT res;
   UINT s1, s2;
   long p1,p2,line=0;  
   
   struct ioctl_opendir arg_opendir;
   struct ioctl_readdir arg_readdir;
   struct ioctl_getfree arg_getfree;

   char fullpath1[_MAX_PATH];
   char fullpath2[_MAX_PATH];
   char src[_MAX_PATH];
   char dst[_MAX_PATH];
 
   dbg("cmd_copy(%s):\n",args);

   checkargs(args, fullpath1, fullpath2);
    
   dbg("cmd_copy: copy ['%s' -> '%s']\n",fullpath1,fullpath2);


   if(FPInfo1.b_has_wcard){ /* wild cards in source ==> cycle through directory and copy all matching files .... */

      if( (strlen(FPInfo2.psz_filename) && FPInfo2.psz_filename[0] != '*') || 
          (strlen(FPInfo2.psz_fileext)  && FPInfo2.psz_fileext[0] != '*') ){
        printf("invalid second path argument, trailing '/' missing ? \n");
        return 0;
      }

      arg_opendir.dp = &dir;
      arg_opendir.path = fullpath1;

      if(FPInfo1.psz_driveName[0])
       res = ioctl(FPInfo1.psz_driveName,FS_IOCTL_OPEN_DIR,&arg_opendir);
     else res = ioctl(FPInfo1.psz_cdrive,FS_IOCTL_OPEN_DIR,&arg_opendir);
   
      if (res) { put_rc(res); return 0; }

      for(;;) {
        arg_readdir.dp = &dir;
        arg_readdir.fno = &Finfo;

        if(FPInfo1.psz_driveName[0])
         res = ioctl(FPInfo1.psz_driveName,FS_IOCTL_READ_DIR,&arg_readdir);
        else res = ioctl(FPInfo1.psz_cdrive,FS_IOCTL_READ_DIR,&arg_readdir);
        
        if ((res != FR_OK) || !Finfo.fname[0]) break;

        if( Finfo.fattrib == AM_VOL ) continue; /* Volume Label */
        if( Finfo.fattrib == AM_DIR ) continue; /* Directory */
        if( Finfo.fattrib == AM_LFN ) continue; /* LFN Entry (not supported yet) */

        if (wildcmp(FPInfo1.psz_wcard, Finfo.fname)) {        
          sprintf(src,"%s%s",fullpath1,Finfo.fname);
          sprintf(dst,"%s%s",fullpath2,Finfo.fname);          
          _copy(src, dst);
        } else {
          dbg(" %s ---> no match =(\n",Finfo.fname);
          continue;
        }                    
    }
    
    if(FPInfo1.psz_driveName[0])
          res = ioctl(FPInfo1.psz_driveName,FS_IOCTL_CLOSE_DIR,&dir);       
    else res = ioctl(FPInfo1.psz_cdrive,FS_IOCTL_CLOSE_DIR,&dir); 

   }else{
    // standard (no wildcard) copy
    dbg("standard copy ....\n");
    //printf(" %s ==> %s\n",fullpath1,fullpath2);
    _copy(fullpath1, fullpath2);
   }

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
   char key=0;
   
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
	     printf(" ---- KEY ---- "); key=getchar(); printf("\n");
     }
     if(key=='q' || key=='Q') break;
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
   
   //p1=args;   
   //while(*p1) { *p1 = toupper( *p1 );  p1++; } // convert to uppercase
   
   p1=args;
   
   while( isalnum( *p1 ) ) p1++;	// cut non-alphanumeric characters
   *p1 = 0;

#ifdef CONFIG_DEBUG   
   printf("DINIT[%s]\n",args);
#endif      

   res = ioctl(args,FS_IOCTL_DISK_INIT,NULL);  

#ifdef CONFIG_DEBUG     
   put_rc(res);
#endif
   
   if(res != FR_OK) {
     printf(" no device\n");
     return 0;
   }
   
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
   struct _driveinfo di;
   
   printf("Disk Drive Status:\n");
   printf("==================\n");
   
   
   while (*args == ' ') args++; /* skip whitespace */
   
   if(!args) return 0; 
   
   res = ioctl(args, FS_IOCTL_GET_DISK_DRIVE_STATUS, &di);  
   
   if(res != RES_OK){
     put_rc(res);
     return 0;
   }
			
   printf(" Model       : %s\n",di.idename);
   printf("   Cylinders      : %u\n",di.numcyl);
   printf("   Heads          : %u\n",di.numhead);
   printf("   Sectors/Card   : %lu\n",di.numsec);
		
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
   char key=0;
   
  
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
     	    printf(" ---- KEY ---- "); key=getchar(); printf("\n");
  	}
    if(key=='q' || key=='Q') break;
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
   
   //ptr=part; while(*ptr) { *ptr = toupper( *ptr );  ptr++; } // convert to uppercase
   ptr=type; while(*ptr) { *ptr = toupper( *ptr );  ptr++; } // convert to uppercase
 
   ioctl_args.part = part;    /* partition */
   ioctl_args.fstype = type;  /* file system type */
   ioctl_args.au = au;        /* allocation unit */    
   ioctl_args.sfd = sfd;      /* partitioning rule */  // dito ?
   
   if( !strncmp ( "FAT", type, 3) ) {
     printf("volume %s will be formatted. Are you sure? (y/N)",part);
     gets(ptr = tmp);
     if (*ptr != 'Y' && *ptr != 'y') return 0;
     res = ioctl(part, FS_IOCTL_MKFS, &ioctl_args);
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

void dump_partition(struct ptable *part, int partition_number)
{ 
  
  printf("Partition %d\n", partition_number + 1);
  printf("   boot_flag = %02X", part->bootable);
  printf("   sys_type = %02X (%s)\n", part->type, partition_type(part->type) );
  
  printf("   chs_begin: head = %d, cyl = %d, sec = %d\n",(part->start_chs & 0xFF0000) >> 16,
                                                         (part->start_chs & 0x006000 >> 6) + part->start_chs & 0x0000FF,
                                                         (part->start_chs & 0x003F00) >> 8);                
  printf("   chs_end: head = %d, cyl = %d, sec = %d\n",  (part->end_chs & 0xFF0000) >> 16,
                                                         (part->end_chs & 0x006000 >> 6) + part->end_chs & 0x0000FF,
                                                         (part->end_chs & 0x003F00) >> 8);

  printf("   start_sector = %d",ENDIAN(part->start_sector));
  printf("   nr_sector = %d\n",ENDIAN(part->num_sector));

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


int cmd_mount (char * args){
   /* args = <vol> <fs> */
   FRESULT res;
   char vol[10],*p;
   char fs[10];
   char* pc;
   UINT opt;


   struct ioctl_mount_fs mnt_args;
	
   if(args[0] == 0)  // list mounted partitions ....
   {
     cmd_fstab(NULL);
     
     return 0;
   }
   
   if ( !xatos(&args, vol,9) || !xatos(&args, fs,9) ) return 0; 

   if(!xatoi(&args, &opt)) opt = 1; // default =1 (immediate mount)


   switch(opt) {
    case 0: mnt_args.options = FS_MOUNT_DELAY; break;
    case 1: mnt_args.options = FS_MOUNT_IMMEDIATE; break;
    default: mnt_args.options = FS_MOUNT_IMMEDIATE;
  }
   
   printf(" try mounting filesystem %s on volume %s (option=%d) ... \n",fs,vol,mnt_args.options);
   
   if(p = strchr(vol,':')) *p = 0; /* remove trailing : and path */

   mnt_args.devicename = vol;
   mnt_args.fsname = fs;
   //mnt_args.options = opt; //FS_RW; /* we always mount read/write */
      
  res = ioctl(NULL, FS_IOCTL_MOUNT, &mnt_args); 
   
   put_rc(res);
   
   return 0;
} 



int cmd_umount (char * args){
   /* fmount <ld#>  - unmount drive ld#; arg = HDA1.....*/
   FRESULT res;
   char* p;
 
   if (!args){
     printf(" error in args.\n");
     return 0;
   }   
   
   while (*args == ' ') args++;
   
   if(p = strchr(args,':')) *p = 0; /* remove trailing : and path */

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
  FATFS *pfs;
  FRESULT res;

  struct fstabentry *pfstabentry;
 
  static const BYTE ft[] = {0, 12, 16, 32};
   
   printf("Volumes File System Status...\n");
   
   if (!args){
     printf(" error in args.\n");
     return 0;
   }   
   
     
   while (*args == ' ') args++;  	// skip whitespace
  
   if(pfstabentry = get_fstabentry(args)){ 
     pfs = (FATFS*)pfstabentry->pfs; /* Get pointer to the file system object */
   }else{
     printf(" error: volume not found in fstab\n");
     return 0;
   }

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
  
  printf(" lstatus [%s] ... \n",FPInfo.psz_cdrive);
  
  // give it to the fat driver
  res = cmd_lstatus_fat(FPInfo.psz_cdrive);
  if(res) printf(" cmd_lstatus_fat returned '%s'\n",get_rc_string(res));
  return 0;
      
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
  
  printf("cmd_lstatus_fat [%s] (1)\n",tmp);
  
  ptr2 = args;
#if _FS_READONLY 
  arg_opendir.dp = &dir;
  arg_opendir.path = tmp;     
  res = ioctl(args,FS_IOCTL_OPEN_DIR,&arg_opendir);
  if (res) {
     printf(" Error OpenDir: %d (%s)\n", res, get_rc_string(res));
     fs = dir.fs;
     res = ioctl(args,FS_IOCTL_CLOSE_DIR,&dir);
     if (res) {
	printf(" Error CloseDir: %d (%s)\n", res, get_rc_string(res));
     }
     return 0;
  }
  printf("cmd_lstatus_fat [%s] (2)\n",tmp);
#else      
  arg_getfree.path = tmp;
  arg_getfree.nclst = (DWORD*)&p1;
  arg_getfree.ppfs = (FS*)&fs;   
  printf("cmd_lstatus_fat [%s] (3)\n",tmp);
  res = ioctl(args,FS_IOCTL_GET_FREE,&arg_getfree); // <<--- !!
  printf("cmd_lstatus_fat [%s] (4)\n",tmp);
  if (res) { 
    printf(" Error GetFree: %d (%s)\n", res, get_rc_string(res));
    return 0;     
  }   
  printf("cmd_lstatus_fat [%s] (5)\n",tmp);
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
  res = ioctl(args,FS_IOCTL_GET_VLABEL,&arg_getlabel);
  if (res) { 
    printf(" Error GetVLabel: %d (%s)\n", res, get_rc_string(res));
    return 0;     
  }
  printf(pool[0] ? "Volume name is %s\n" : "No volume label\n", arg_getlabel.plabel);
  printf("Volume S/N is %04X-%04X\n", dw >> 16, dw & 0xFFFF);
#endif
  AccSize = AccFiles = AccDirs = 0;
      
  printf("cmd_lstatus_fat [%s] (4)\n",tmp);
  
  strcpy(tmp,args);
  strcat(tmp,":");
  
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
   
   xatos(&args, label,9); // fetch label (emtpty => clear label if op = w(rite)
   
   //p1=volume; while(*p1) { *p1 = toupper( *p1 );  p1++; } // convert to uppercase   
   
#ifdef CONFIG_DEBUG
   printf(" vlabel %s %s %s\n",op,volume,label);
#endif
   
   
   if(op[0] == 'w' || op[0] == 'W') { // write label to volume        
      strcat(tmp,volume);
      strcat(tmp,":");
      strcat(tmp,label);
      res = ioctl(volume,FS_IOCTL_SET_VLABEL,tmp); 		// we send this directly to the FAT fs driver ...
      return 0;
   }
   
   if(op[0] == 'r' || op[0] == 'R') { // read label from volume  
     
     getlbl.volume = volume; // pointer will be changed by ioctl !
     getlbl.plabel = label;
     getlbl.psn = &sn;
     
     res = ioctl(volume,FS_IOCTL_GET_VLABEL,&getlbl);
     
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
   char key=0;
   
   if (!xatoi(&args, &p1)) return 0;
   for (buf = &Buff[p1], ofs = p1, cnt = 32; cnt; cnt--, buf += 16, ofs += 16) {
  	put_dump(buf, ofs, 16);
  	if(!(ofs % 160) && ofs != 0) {
  		printf(" ---- KEY ---- "); key=getchar(); printf("\n");
  	}
    if(key=='q' || key=='Q') break;
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
  
  res = ioctl(NULL,FS_IOCTL_INFO,"FAT");

  return 0;
}

int cmd_dev(char* args)
{
  int res, line; 
  struct blk_driver *driver;
  
  res = ioctl(NULL,FS_IOCTL_GETBLKDEV,&driver);
  line = 0;
  
  printf(" Registered block device drivers:\n DRIVE    BLKLDRV    BLKOPER\n\n");
  
  while(driver)
  {		
      printf(" %-7s  0x%x      0x%x\n",driver->pdrive, driver, driver->blk_oper);      
      if(!(++line % 10)) getchar(); 
      
      driver = driver->next;
  }
  
  // fetch geometry of 1st and 2nd drive from each driver:
  // look for partitions/partitiontype of each regular drive:
  
  return 0;
}

int cmd_meminfo(char* args)
{
  int res, line; 
  struct block_header *location = (struct block_header*)_HEAP,*next;
  UINT allocated_ram = 0, free_ram = 0, biggest_free_junk = 0,free_blocks = 0, allocated_blocks = 0;
  
  while (location != 0)
  {
    if(location->free == 1) {
      free_blocks++;
      free_ram += location->size;
      if(biggest_free_junk < location->size) biggest_free_junk = location->size;
    } else {
      allocated_blocks++;
      allocated_ram += location->size;
    }
    
    location = location->next;
  }
      
#ifdef USE_JADOS
  printf(" JADOS User-Start : 0x%x\n",jd_get_laddr() );  
  printf(" JADOS RAMTOP     : 0x%x\n",jd_get_ramtop() );
  printf(" JADOS GP-Start   : 0x%x\n",jd_get_gp() );
#else
  printf(" no JADOS !\n");  
#endif
    
  printf("\n");
  printf(" _HEAP starts at  :  0x%08x\n", _HEAP);
  printf(" _STACK starts at :  0x%08x\n", _RAM_TOP);
  printf(" dynamic memory   :  0x%08x (%.3f KB)\n", _RAM_TOP - _HEAP, (_RAM_TOP - _HEAP)/1024.0 );
  printf(" allocated memory :  0x%08x (%.3f KB)\n", allocated_ram, allocated_ram/1024.0);
  printf(" free memory      :  0x%08x (%.3f KB)\n", free_ram, free_ram/1024.0);
  printf(" blocks           :  %d (%d free, %d allocated)\n", free_blocks + allocated_blocks, free_blocks, allocated_blocks);
  printf(" biggest free junk:  0x%08x\n", biggest_free_junk);
  /*
   note: if there is only one free block, all allocated memory is continuous and fragmentation is 0%
         fragmentation calculation is only a hint of how many discontinuous junks are embedded free fragments between allocated memory blocks
  */
  if(free_blocks > 0) free_blocks--; 
  printf("    fragmentation :  %.2f%%\n", free_blocks * 100.0 / allocated_blocks);
  
  
  
  walk_heap();  // /nkc/first
  
  
  return 0;
}

int cmd_history(char* args)
{
  // shell.c: char HistoryBuffer[MAX_HISTORY+1][MAX_CHAR]; /* History Buffer */
  char line = 0;
  char level = cmd_env.histOLDEST;
  
  printf("command history:\n");
  
  while(level != cmd_env.histNEWEST) {
    printf("%s\n",cmd_env.HistoryBuffer[level++]);    
    
    if(level > MAX_HISTORY) level = 0; 
    
    if(!(++line % 10)) getchar();     
  }
  
  return 0;
}


/*
int _ll_settime(struct tm *tm2)

struct tm
{
  int   tm_sec;
  int   tm_min;
  int   tm_hour;
  int   tm_mday;
  int   tm_mon;
  int   tm_year;
  int   tm_wday;
  int   tm_yday;
  int   tm_isdst;
};
*/


/*
clock [MMDDhhmm[[CC]YY][.ss]]
*/
int cmd_clock(char* args)
{
  
  time_t timer;
  struct tm y2k = {0};
  struct tm *py2k;
  double seconds;
  unsigned char century, year, month, day, hour, minute, second, error;
  char MM[3];
  char DD[3];
  char hh[3];
  char mm[3];
  char CC[3];
  char YY[3];
  char ss[3];
  char answer;
  int res;


  printf("sytem clock (RTC) [%s](%d):\n",args, strlen(args));

  time(&timer);  				/* get current time; same as: timer = time(NULL)  */
  py2k = localtime(&timer);		/* get pointer to struct tm */
  printf ("The current local time is: %s\n", ctime (&timer));

  /*parse args ...*/
  if(strlen(args) > 8) {
   /* skip whitespace */
   while (*args == ' ') args++; 
     
   /* scan MMDDhhmm */
   if (!xatos(&args, MM,2) || !xatos(&args, DD,2) || !xatos(&args, hh,2) || !xatos(&args, mm,2)) {   	
   	printf(" error in args (1), try 'clock /?'\n");
   	return 0;
   }

   /* check for optional .ss */
   ss[0]=0;
   if(*args == '.'){
   	args++;
   	if(!xatos(&args,ss,2)){
   	 printf(" error in args (2), try 'clock /?'\n");
   	 return 0;
   	}
   } 
   /* check for optional CC and YY */
   if(xatos(&args, CC,2)) { 
   	if(!xatos(&args,YY,2)){
   		strcpy(YY,CC);
   		strcpy(CC,"20");
   	} 
   } else {
   	sprintf(YY,"%02d",py2k->tm_year-100);
   	strcpy(CC,"20");
   }

   /* again for optional .ss if not already done*/
   if(ss[0] == 0){
	   if(*args == '.'){
	   	args++;
	   	if(!xatos(&args,ss,2)){
	   	 printf(" error in args (3), try 'clock /?'\n");
	   	 return 0;
	   	}
	   } else {
	   	strcpy(ss,"59");
	   }
   }
   		
   /* convert to number */		
   month = atoi(MM);
   day = atoi(DD);
   hour = atoi(hh);
   minute = atoi(mm);
   second = atoi(ss);
   century = atoi(CC);
   year = atoi(YY);
   
   error = 0;
   if( month < 1 || month > 12){
   	printf(" error: month (%d) not vaid, should be 1..12 ! \n",month);
   	error = 1;
   }

   if( day < 1 || day > 31){
   	printf(" error: day (%d) not vaid, should be 1..31 ! \n",day);
   	error = 1;
   }   

   if( hour < 0 || hour > 23){
   	printf(" error: hour (%d) not vaid, should be 0..23 ! \n",hour);
   	error = 1;
   }

   if( minute < 0 || minute > 59){
   	printf(" error: minute (%d) not vaid, should be 0..59 ! \n",minute);
   	error = 1;
   }  
 
   if( century != 19 || century != 20){
   	printf(" error: century (%d) not vaid, should be 19 or 20 ! \n",century);
   	error = 1;
   }

   if( year < 0 || year > 99){
   	printf(" error: year (%d) not vaid, should be 0..99 ! \n",year);
   	error = 1;
   }

   if( second < 0 || second > 59){
   	printf(" error: second (%d) not vaid, should be 0..59 ! \n",second);
   	error = 1;
   }

   if(error != 0){
   	
   	printf("  ==> MM = %02d, DD = %02d, hh = %02d, mm = %02d, CC = %02d, YY = %02d, ss = %02d\n",month,day,hour,minute,century,year,second);
   	printf("  set clock with new values ? [y|N]:");

   	answer = toupper(getchar()); printf("%c\n",answer);

   	if(answer == 'Y'){
   		/* set clock with new values */
   		y2k.tm_sec = second;
   		y2k.tm_min = minute;
   		y2k.tm_hour = hour;
   		y2k.tm_mday = day;
   		y2k.tm_mon = month;
   		y2k.tm_year = year + 100;
   		y2k.tm_wday = 0;
   		y2k.tm_yday = 0;
   		y2k.tm_isdst = 0;

   		//res = ioctl(NULL,NKC_IOCTL_SETCLOCK,&py2k);

   		_ll_settime(&y2k);
   	}


   }
  } /* end parsing */

  return 0;
}

/* ####################### TEST REGION ########################################## */


int cmd_test(char* args)
{
  UINT i;
  start_progress();
  for(i=0; i<0xFFFFFFFF; i++) do_progress();

  printf("\n test end\n");
  
  return 0;
}






/*-----------------------------------------------------------------------*/
/* Main                                                                  */

static void prompt()
{
  printf("%s:%s>",FPInfo.psz_cdrive,FPInfo.psz_cpath);
}

int main (int argc, char *argv[])
{
  int ii; 


  init_helper();

  Buff = malloc(262144); // allocate bigger working buffer

  if(!Buff){
    printf("error allocation memory fpr working buffer\n");
    exit(0);
  }
  
  sprintf(FPInfo.psz_cpath,"/");
  ioctl(NULL,FS_IOCTL_GETDRV,FPInfo.psz_cdrive);

  // default environment values
  cmd_env.histOLDEST = 0;                         
  cmd_env.histNEWEST = 0;         
  cmd_env.histLEVEL = 0;          
  cmd_env.insmode = 0;  

  // clear history
  for(ii=0; ii<MAX_HISTORY; ii++){
    cmd_env.HistoryBuffer[ii][0] = 0;
  }

  // print some information ...
  printf("\n\n Test-Shell v %d.%d\n\n"
   "   To access any drive, you have to mount it first.\n"
   "   Use the following commands:\n"
   "      fs    - to show available file systems\n"
   "      dev   - to show available devices\n"
   "      mount - to mount a device and associate it with a file system\n"
   "      ?     - for help on all commands\n\n",
   (unsigned long) &__BUILD_DATE - (unsigned long) &_start,
   (unsigned long) &__BUILD_NUMBER - (unsigned long) &_start);


  shell(prompt, &cmd_env, internalCommands, hlptxt, 0); // call the shell ....

  free(Buff);
  exit_helper();
    
  return 0;
}


