#ifndef __SD_S_H
#define __SD_S_H


DRESULT sddisk(USHORT cmd,ULONG arg1,ULONG arg2,BYTE disk,void* pdata);


struct _sddriveinfo *sdtest(BYTE disk);
//DRESULT sdtest(BYTE disk,struct _driveinfo** di)

#endif