// #define EZERO    0      /* Error 0   (no error)     */
// #define EINVFNC  1      /* Invalid function number  */
// #define ENOFILE  2      /* File not found           */
// #define ENOPATH  3      /* Path not found           */
// #define EMFILE   4      /* Too many open files      */
// #define EACCES   5      /* Permission denied        */
// #define EBADF    6      /* Bad file number          */
// #define ECONTR   7      /* Memory blocks destroyed  */
// #define ENOMEM   8      /* Not enough core          */
// #define EINVMEM  9      /* Invalid memory block address */
// #define EINVENV 10      /* Invalid environment      */
// #define EINVFMT 11      /* Invalid format           */
// #define EINVACC 12      /* Invalid access code      */
// #define EINVDAT 13      /* Invalid data             */
// #define EFAULT  14      /* Unknown error            */
// #define EINVDRV 15      /* No such device  */
// #define ECURDIR 16      /* Attempt to remove CurDir */
// #define ENOTSAM 17      /* Not same device          */
// #define ENMFILE 18      /* No more files            */
// #define EINVAL  19      /* Invalid argument         */
// #define E2BIG   20      /* Arg list too long        */
// #define ENOEXEC 21      /* Exec format error        */
// #define EXDEV   22      /* Cross-device link        */
// #define ENFILE  23      /* Too many open files      */
// #define ECHILD  24      /* No child process         */
// #define ENOTTY  25      /* UNIX - not MSDOS         */
// #define ETXTBSY 26      /* UNIX - not MSDOS         */
// #define EFBIG   27      /* UNIX - not MSDOS         */
// #define ENOSPC  28      /* No space left on device  */
// #define ESPIPE  29      /* Illegal seek             */
// #define EROFS   30      /* Read-only file system    */
// #define EMLINK  31      /* UNIX - not MSDOS         */
// #define EPIPE   32      /* Broken pipe              */
// #define EDOM    33      /* Math argument            */
// #define ERANGE  34      /* Result too large         */
// #define EEXIST  35      /* File already exists      */
// #define EDEADLOCK 36    /* Locking violation        */
// #define EPERM   37      /* Operation not permitted  */
// #define ESRCH   38      /* UNIX - not MSDOS         */
// #define EINTR   39      /* Interrupted function call */
// #define EIO     40      /* Input/output error       */
// #define ENXIO   41      /* No such device or address */
// #define EAGAIN  42      /* Resource temporarily unavailable */
// #define ENOTBLK 43      /* UNIX - not MSDOS         */
// #define EBUSY   44      /* Resource busy            */
// #define ENOTDIR 45      /* UNIX - not MSDOS         */
// #define EISDIR  46      /* UNIX - not MSDOS         */
// #define EUCLEAN 47      /* UNIX - not MSDOS         */
// 
// /* extensions ... */
// #define ENAMETOOLONG 48 /* Filename too long        */
// #define ENODRV 49	/* no driver 		    */


// const char *p_rc_code =
// 		"OK\0DISK_ERR\0INT_ERR\0NOT_READY\0NO_FILE\0NO_PATH\0INVALID_NAME\0"
// 		"DENIED\0EXIST\0INVALID_OBJECT\0WRITE_PROTECTED\0INVALID_DRIVE\0"
// 		"NOT_ENABLED\0NO_FILE_SYSTEM\0MKFS_ABORTED\0TIMEOUT\0LOCKED\0"
// 		"NOT_ENOUGH_CORE\0TOO_MANY_OPEN_FILES\0INVALID_PARAMETER\0NO_DRIVER\0";	
		
const char *p_rc_code =
"Error 0   (no error)     \0"
"Invalid function number  \0"
"File not found           \0"
"Path not found           \0"
"Too many open files      \0"
"Permission denied        \0"
"Bad file number          \0"
"Memory blocks destroyed  \0"
"Not enough core          \0"
"Invalid memory block address \0"
"Invalid environment      \0"
"Invalid format           \0"
"Invalid access code      \0"
"Invalid data             \0"
"Unknown error            \0"
"No such device  	 \0"
"Attempt to remove CurDir \0"
"Not same device          \0"
"No more files            \0"
"Invalid argument         \0"
"Arg list too long        \0"
"Exec format error        \0"
"Cross-device link        \0"
"Too many open files      \0"
"No child process         \0"
"UNIX - not MSDOS         \0"
"UNIX - not MSDOS         \0"
"UNIX - not MSDOS         \0"
"No space left on device  \0"
"Illegal seek             \0"
"Read-only file system    \0"
"UNIX - not MSDOS         \0"
"Broken pipe              \0"
"Math argument            \0"
"Result too large         \0"
"File already exists      \0"
"Locking violation        \0"
"Operation not permitted  \0"
"UNIX - not MSDOS         \0"
"Interrupted function call\0"
"Input/output error       \0"
"No such device or address\0"
"Resource temporarily unavailable \0"
"UNIX - not MSDOS         \0"
"Resource busy            \0"
"UNIX - not MSDOS         \0"
"UNIX - not MSDOS         \0"
"UNIX - not MSDOS         \0"
"Filename too long        \0"
"no driver                \0";