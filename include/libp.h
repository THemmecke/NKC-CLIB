/* The prototypes in this file which start with _ll are OS dependent
 * and some of the C functions will require them to be implemented
 * notably:
 *   memory allocation
 *   file handling
 *   time & date
 *   system-level functions
 *
 * C functions which don't depend on the above mechanisms are self-contained
 * and should work generically
 */

/* Initialize the file stuff */
void _ll_init(void);

/* File open close */
int _ll_open(const char *__name, int flags);
int _ll_creat(const char *__name, int flags);
int _ll_close(int __fd);

/* Convert C-style open flags to os-style open flags */
int _ll_flags(int __oldflags);

/* File read/write */
int _ll_write(int __fd,void *__buf,size_t __size);
int _ll_read(int __fd,void *__buf,size_t __len);

/* File positioning */
size_t _ll_getpos(int __fd);
int _ll_seek(int __fd, size_t __pos, int __origin);

/* File utilities */
int _ll_rename(const char *__old, const char *__new);
int _ll_remove(const char *__name);

/* malloc stuff */
void *_ll_malloc(size_t __size);
void _ll_free(void *__blk);
void _ll_transfer(void);

/* System stuff */
int _ll_getenv(char *buf, int id);
int _ll_system(const char *string);

/* Time & date stuff */
/*void _ll_gettime(time_t *__time);*/
struct tm *_ll_gettime(struct tm *tm2);
long _ll_ticks(void);

/* Internal functions, already implemented */
int _baseputc(int __c, FILE *__stream);
int _basegetc(FILE *__stream);
FILE *_basefopen(const char *name, const char *mode,FILE *stream);
int _basefclose(FILE *stream,int release);
int _scanf(char *buffer, const char *format,void *arglist);
int _writebuf(FILE *__stream);

/* The following constants and structures govern the memory allocation
 * mechanism
 */
#define ALLOCSIZE 100*1024

typedef struct _freelist {
	size_t size;
	struct _freelist *next;
} FREELIST;

typedef struct _blkhead {
	struct _blkhead *next;
	FREELIST *list;
} BLKHEAD;
