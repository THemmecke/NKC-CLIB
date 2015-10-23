#ifndef __CMD_H
#define __CMD_H


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
int cmd_vmount (char * args);
int cmd_vumount(char * args); 
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

#endif
