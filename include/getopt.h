#ifndef __GETOPT_H
#define __GETOPT_H

#define ARGV_MAX  255
#define ARGV_TOKEN_MAX  255


/* public variables */
extern int    __argc;
extern char  *__argv[ARGV_MAX];


extern int	opterr;
extern int	optind;
extern int	optopt;
extern char *optarg;


/* public functions */
int getopt(int argc, char **argv, char *opts);
void str2argv(char *s);

#endif