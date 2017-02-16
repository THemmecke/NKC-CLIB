#include <signal.h>
#include <stdlib.h>
#include <stdio.h>



#ifdef NKC_DEBUG
#include "../nkc/llnkc.h"
#endif

int _abterm=0;

static void sigill(int p)
{
}

static void sigint(int p)
{
}

static void sigfpe(int p)
{
	fprintf(stderr,"\nFloating point exception");
	exit(EXIT_FAILURE);
}
static void sigsegv(int p)
{
	fprintf(stderr,"\nGeneral protection fault");
	exit(EXIT_FAILURE);
}
static void sigterm(int p)
{
	exit(EXIT_SUCCESS);
}
static void siguser1()
{
}
static void siguser2()
{
}
static void siguser3()
{
}
static void siguser()
{
}
static void sigbreak(int p)
{
	#ifdef NKC_DEBUG
	gp_write("sigbreak...\n");
	#endif
	exit(EXIT_FAILURE);
	
}
static void sigabort(int p)
{
	_abterm = 1;
	exit(EXIT_FAILURE);
}
static void (*deftab[NSIG])(int) = {
	 (void *)-1,  (void *)-1,	sigint,	 (void *)-1,
	sigill,  (void *)-1, (void *)-1, (void *)-1,
	sigfpe,  (void *)-1, (void *)-1, sigsegv,
	 (void *)-1, (void *)-1, (void *)-1,sigterm,
	siguser1,siguser2, (void *)-1, (void *)-1,
	siguser3,sigbreak,sigabort 
};

static void (*sigtab[NSIG])(int p);


void (*signal(int signum, void (*func)()))(int)
{
	void (*temp)(int);
	if (signum >= NSIG)
		return SIG_ERR;
	temp = sigtab[signum];
	if (temp == SIG_ERR)
		return SIG_ERR;
	if (temp == SIG_DFL) 
		sigtab[signum] = deftab[signum];
	else
		sigtab[signum] = func;
	return temp;
}


int raise(int sig)
{
	void (*temp)(int a) = sigtab[sig];
	if (temp == SIG_ERR)
		return 1;
	if (temp == SIG_IGN)
		return 0;
	(*temp)(sig);
	return 0;
}

/*
#pragma startup siginit 128
*/
//static 
void siginit(void)
{
	int i;
	for (i=0; i < NSIG; i++)
		sigtab[i] = deftab[i];
}



