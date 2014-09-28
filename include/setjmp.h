/*  setjmp.h

    Defines typedef and functions for setjmp/longjmp.

*/

#ifndef __SETJMP_H
#define __SETJMP_H

typedef struct __jmp_buf {
#ifdef _i386_
    unsigned	j_eax;
    unsigned	j_ecx;
    unsigned	j_edx;
    unsigned	j_ebx;
    unsigned	j_esp;
    unsigned	j_ebp;
    unsigned	j_esi;
    unsigned	j_edi;
    unsigned	j_flag;
    unsigned	j_pc;
#else
    unsigned    j_d0;
    unsigned    j_d1;
    unsigned    j_d2;
    unsigned    j_d3;
    unsigned    j_d4;
    unsigned    j_d5;
    unsigned    j_d6;
    unsigned    j_d7;
    unsigned    j_a0;
    unsigned    j_a1;
    unsigned    j_a2;
    unsigned    j_a3;
    unsigned    j_a4;
    unsigned    j_a5;
    unsigned    j_a6;
    unsigned    j_a7;
    unsigned	j_flag;
    unsigned    j_pc;
#endif

}   jmp_buf[1];

void    longjmp(jmp_buf __jmpb, int __retval);
int     setjmp(jmp_buf __jmpb);

#endif  /* __SETJMP_H */