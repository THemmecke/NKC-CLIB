#include <stdlib.h>

unsigned int seed =0x45168297;

void srand(unsigned int sseed)
{
	seed = sseed;
}
int rand(void)
{
	seed = seed * 0x15a4e35 + 1;
	return((seed >> 16) & RAND_MAX);
}
