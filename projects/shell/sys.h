#ifndef __SYS_H
#define __SYS_H

typedef struct {
	DWORD	JUMP;			/* 4EFA 0051 = jmp main(%pc) */
	DWORD	NOP;			/* 4E71 4E71 = nop nop       */

	BYTE 	disk;			/* 0x08: disk type (0=IDE, 1=SD) */
	BYTE 	drive;			/* 0x09: physical drive numberf (1=1st drive) */
	BYTE 	partition;		/* 0x0A: partition (0=1st partition, 0xff=no partition table) */
	BYTE    dummy;			/* 0x0B: alignment */
	DWORD 	sector;			/* 0x0C: start sector of OS.SYS */
	DWORD 	nsector;		/* 0x10: size in sectors of OS.SYS */
	DWORD   target;			/* 0x14: target address for OS.SYS */
	char    name[12];			/* 0x18: filename (8.3) */

} MBRINFO;

// public
int cmd_sys(char* args);

// private


#endif