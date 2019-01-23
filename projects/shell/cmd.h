#ifndef __CMD_H
#define __CMD_H

// internal functions

static const char * partition_type(unsigned char type);

// command prototypes
int cmd_cls(void);

int cmd_chdir(char *);
int cmd_copy(char *);
int cmd_dir(char *);

int cmd_dir_fat(char *,char* pd,BOOL b_has_wcard,char* wc );
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
int cmd_clock(char* args);

int cmd_setpoint(char* args);
int cmd_fill(char* args);
int cmd_test(char* args);

int cmd_shcmds(void);


#endif
