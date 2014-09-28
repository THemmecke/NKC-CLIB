#ifndef __SIGNAL_H
#define __SIGNAL_H


typedef int sig_atomic_t;   /* Atomic entity type (ANSI) */

typedef void (* _CatcherPTR)();

#define SIG_DFL ((_CatcherPTR)0)   /* Default action   */
#define SIG_IGN ((_CatcherPTR)1)   /* Ignore action    */
#define SIG_ERR ((_CatcherPTR)-1)  /* Error return     */

#define SIGABRT         22
#define SIGFPE           8              /* Floating point trap  */
#define SIGILL           4              /* Illegal instruction  */
#define SIGINT           2
#define SIGSEGV         11              /* Memory access violation */
#define SIGTERM         15
#define SIGUSR1         16              /* User-defined signal 1 */
#define SIGUSR2         17              /* User-defined signal 2 */
#define SIGUSR3         20              /* User-defined signal 3 */
#define SIGBREAK        21              /* Control-Break interrupt */


int raise(int __sig);
void (* signal(int __sig, void ( * __func)())) (int);

#define NSIG   23      /* highest defined signal no. + 1 */


#endif  /* __SIGNAL_H */
