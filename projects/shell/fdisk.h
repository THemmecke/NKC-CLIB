#ifndef __FDISK_H
#define __FDISK_H

typedef enum {
  T_WRITE_MBR = 1,
  T_MKFS_JDXFS,  
  T_MKFS_FAT,
} T_TYPE;

struct task {
	T_TYPE type;	/* what to do */
	UINT p1;		/* 32bit parameters  */
	UINT p2;
	UINT p3;
	struct task *next;		/* pointer to next task */
};

// public
int cmd_fdisk(char* args);

// private
int task_add(T_TYPE t, UINT p1, UINT p2, UINT p3);
struct task *task_get(T_TYPE t);
void task_clear_all(void);

#endif