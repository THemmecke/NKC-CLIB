#ifndef __FS_FAT_H
#define __FS_FAT_H

#include "ff.h"

/* Public Prototypes */

static int     fatfs_open(struct _file *filp);
static int     fatfs_close(struct _file *filp);
static int     fatfs_read(struct _file *filp, char *buffer, int buflen);
static int     fatfs_write(struct _file *filp, const char *buffer, int buflen);
static int     fatfs_seek(struct _file *filp, int offset, int whence);
static int     fatfs_remove(struct _file *filp);
static int     fatfs_getpos(struct _file *filp);
static int     fatfs_rename(struct _file *filp, const char *oldrelpath, const char *newrelpath);
//static int     fatfs_ioctl(struct _file *filp, int cmd, unsigned long arg);
static int     fatfs_ioctl(struct fstabentry* pfstab, int cmd, unsigned long arg);
static int     fatfs_mkdir(struct _file *filp, const char *relpath);
static int     fatfs_rmdir(struct _file *filp, const char *relpath);
static int     fatfs_opendir(struct _file *filp, const char *relpath, DIR *dir);
static int     fatfs_closedir(struct _file *filp, DIR *dir);
static int     fatfs_readdir(struct _file *filp, DIR *dir,FILINFO* finfo);

void    fatfs_init_fs(void);

static struct slist* fatfs_get_slist(struct _file *filp);

#endif
