#include <stdlib.h>
#include <memory.h>

     
void qsort(void *base, size_t num, size_t width,
						int (*compare)(const void *elem1, const void *elem2))
{
	int i,j;
	void *buf = malloc(width);
	char *wp1 = base;
	if (!buf)
		return;
	for (i=0; i < num-1;i++) {
		char *wp2 = wp1 + width;
		for (j=i+1; j < num; j++) {
			if ((*compare)(wp1,wp2) >0) {
				memcpy(buf,wp1,width);
				memcpy(wp1,wp2,width);
				memcpy(wp2,buf,width);
			}
			wp2 += width;
		}
		wp1 += width;
	}
	free(buf);
			
}
