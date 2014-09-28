/*
 *    assert.c - courtesy Kirill Joss
 */
#include <stdio.h>
#include <stdlib.h>

void __assertfail( char *__who, char *__file, int __line, char *__msg ) 
{
    fprintf( stderr, "%s %s(%d) : %s\n", __who, __file, __line, __msg );
    exit( EXIT_FAILURE );
}