/*
    assert.h
*/

#if !defined( __ASSERT_H__ )
#define __ASSERT_H__


void __assertfail( char *__who, char *__file, int __line, char *__msg );


#undef assert
#if !defined( NDEBUG )
#  define assert(p) ( (p) ? (void)0 : (void) __assertfail( \
                    "Assertion failed", __FILE__, __LINE__, #p ) )
#else
#  define assert(p) ((void)0)
#endif

#endif /* __ASSERT_H__ */