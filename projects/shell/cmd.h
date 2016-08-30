#ifndef __CMD_H
#define __CMD_H



/* DOS partition types */

static const char *const fs_sys_types[] = {
	"\x00" "Empty",
	"\x01" "FAT12",
	"\x04" "FAT16 <32M",
	"\x05" "Extended",         /* DOS 3.3+ extended partition */
	"\x06" "FAT16",            /* DOS 16-bit >=32M */
	"\x07" "HPFS/NTFS",        /* OS/2 IFS, eg, HPFS or NTFS or QNX */
	"\x0a" "OS/2 Boot Manager",/* OS/2 Boot Manager */
	"\x0b" "Win95 FAT32",
	"\x0c" "Win95 FAT32 (LBA)",/* LBA really is 'Extended Int 13h' */
	"\x0e" "Win95 FAT16 (LBA)",
	"\x0f" "Win95 Ext'd (LBA)",
	"\x11" "Hidden FAT12",
	"\x12" "Compaq diagnostics",
	"\x14" "Hidden FAT16 <32M",
	"\x16" "Hidden FAT16",
	"\x17" "Hidden HPFS/NTFS",
	"\x1b" "Hidden Win95 FAT32",
	"\x1c" "Hidden W95 FAT32 (LBA)",
	"\x1e" "Hidden W95 FAT16 (LBA)",
	"\x3c" "Part.Magic recovery",
	"\x41" "PPC PReP Boot",
	"\x42" "SFS",
	"\x63" "GNU HURD or SysV", /* GNU HURD or Mach or Sys V/386 (such as ISC UNIX) */
	"\x80" "Old Minix",        /* Minix 1.4a and earlier */
	"\x81" "Minix / old Linux",/* Minix 1.4b and later */
	"\x82" "Linux swap",       /* also Solaris */
	"\x83" "Linux",
	"\x84" "OS/2 hidden C: drive",
	"\x85" "Linux extended",
	"\x86" "NTFS volume set",
	"\x87" "NTFS volume set",
	"\x8e" "Linux LVM",
	"\x9f" "BSD/OS",           /* BSDI */
	"\xa0" "Thinkpad hibernation",
	"\xa5" "FreeBSD",          /* various BSD flavours */
	"\xa6" "OpenBSD",
	"\xa8" "Darwin UFS",
	"\xa9" "NetBSD",
	"\xab" "Darwin boot",
	"\xb7" "BSDI fs",
	"\xb8" "BSDI swap",
	"\xbe" "Solaris boot",
	"\xeb" "BeOS fs",
	"\xee" "EFI GPT",                    /* Intel EFI GUID Partition Table */
	"\xef" "EFI (FAT-12/16/32)",         /* Intel EFI System Partition */
	"\xf0" "Linux/PA-RISC boot",         /* Linux/PA-RISC boot loader */
	"\xf2" "DOS secondary",              /* DOS 3.3+ secondary */
	"\xfd" "Linux raid autodetect",      /* New (2.2.x) raid partition with
						autodetect using persistent
						superblock */
	NULL
};

struct partition
{
        unsigned char   boot_flag;        /* 0 = Not active, 0x80 = Active */
        unsigned char   chs_begin_head;   /* start of partition: head */
        unsigned short  chs_begin_cyl;    /* start of partition: cyl/sect */ 
        unsigned char   sys_type;         /* For example : 82 --> Linux swap, 83 --> Linux native partition, ... */
        unsigned char   chs_end_head;     /* end of partition: head */
        unsigned short  chs_end_cyl;      /* end of partition: cyl/sec */
        unsigned int    start_sector;     /* Number of sectors between the MBR and the 1st sector of the partition, i.e. the start sector */
        unsigned int    nr_sector;        /* Number of sectors in the partition */
};
// internal functions

static const char * partition_type(unsigned char type);

// initialization functions

void init_cmd(void);
void exit_cmd(void);

// command prototypes
int cmd_cls(void);

int cmd_chdir(char *);
int cmd_copy(char *);
int cmd_dir(char *);
int cmd_dir_fat(char *,char* pd);
int cmd_dir_nkc(char *,char* pd);
int cmd_mkdir(char *);
int cmd_rmdir(char *);
int cmd_rename(char *);
int cmd_del(char *);
int cmd_quit(char *);

int cmd_dinit  (char * args); 
int cmd_ddump  (char * args); 
int cmd_dstatus(char * args); 
int cmd_bdump  (char * args); 
int cmd_bedit  (char * args); 
int cmd_bread  (char * args); 
int cmd_bwrite (char * args); 
int cmd_bfill  (char * args); 
int cmd_mount  (char * args);
int cmd_umount (char * args); 
int cmd_vstatus(char * args); 
int cmd_lstatus(char * args); 
int cmd_fopen  (char * args); 
int cmd_fclose (char * args); 
int cmd_fseek  (char * args); 
int cmd_fdump  (char * args); 
int cmd_fread  (char * args); 
int cmd_fwrite (char * args); 
int cmd_ftrunk (char * args); 
int cmd_vlabel (char * args); 
int cmd_mkfs   (char * args);
int cmd_mkptable (char * args);
int cmd_pwd    (char * args); 
int cmd_chmod  (char * args);
int cmd_chdrive(char * args);
int cmd_ptable (char * args);

int cmd_fstab(char* args);
int cmd_dev(char* args);
int cmd_fs(char* args);
int cmd_fatinfo(char* args);
int cmd_meminfo(char* args);
int cmd_history(char* args);

int cmd_setpoint(char* args);
int cmd_fill(char* args);
int cmd_test(char* args);


#endif
