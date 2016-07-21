#ifndef __SD_S_H
#define __SD_S_H

#include <sd.h>


DRESULT sddisk(USHORT cmd,ULONG arg1,ULONG arg2,BYTE disk,void* pdata);


struct _driveinfo *sdtest(BYTE disk);
//DRESULT sdtest(BYTE disk,struct _driveinfo** di)

#endif