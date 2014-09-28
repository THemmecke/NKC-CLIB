#include <stdlib.h>

void *bsearch(const void *key, const void *base, size_t num, size_t width,
			int (*compare)(const void *elem1, const void *elem2))
{
	size_t bottom = 0;
	size_t top = num;
	size_t mid;
	int l;
	while (1) {
		mid = (top + bottom)/2;
		if ((l=(*compare)(key,(char *)base + mid*width))== 0)
			return (char *)base +mid * width;
		if (l < 0)
			top = mid;
		else
			bottom = mid;
		if ((top +bottom)/2 == mid)
			return 0;
	}
	return 0;	/* Never gets here */
}