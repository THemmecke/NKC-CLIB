#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <signal.h>
#include <math.h>
#include <memory.h>

extern unsigned int _RAM_TOP;

int main(int argc, const char* argv[])
{
  
  printf(" Hello to the world from boot ( 0x%lx )...\n",_RAM_TOP);
  while(1) {}
  
  getch();
  
}