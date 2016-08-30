#ifndef __MEM_H
#define __MEM_H

void *memset16(void *str, unsigned int c, unsigned int n);
void *memcpy16(void *dest, const void *src, unsigned int n);
void *memmove16(void *dest, const void *src, unsigned int n);


void setpixel(const int x, const int y, const int color);
void *saveblock(void *dest, const int x1, const int y1, const int x2, const int y2);
void *restoreblock(void *src, const int x1, const int y1, const int x2, const int y2);
	
#endif	