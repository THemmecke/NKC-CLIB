#include <string.h>
#include <stdio.h>
#include <types.h>

#include "getopt.h"

// if getopt is called a second time, these variables have have to be reset again !!
int	opterr = 1;
int	optind = 1;
int	optopt;
char *optarg;

int
getopt(int argc, char **argv, char *opts)
{
	static int sp = 1;
	register int c;
	register char *cp;

	if(sp == 1)
		if(optind >= argc ||
		   argv[optind][0] != '-' || argv[optind][1] == '\0') {
         //printf("DEBUG: getopt EOF(1)\n");
			return(EOF);
      }
		else if(strcmp(argv[optind], "--") == NULL) {
			optind++;
         //printf("DEBUG: getopt EOF(2)\n");
			return(EOF);
		}
	optopt = c = argv[optind][sp];
	if(c == ':' || (cp=strchr(opts, c)) == NULL) {
		fprintf(stderr, ": illegal option -- %c\n", c);
		if(argv[optind][++sp] == '\0') {
			optind++;
			sp = 1;
		}
      //printf("DEBUG: getopt ?(1)\n");
		return('?');
	}
	if(*++cp == ':') {
		if(argv[optind][sp+1] != '\0'){
         //printf("DEBUG: getopt 1\n");
			optarg = &argv[optind++][sp+1];
      }
		else if(++optind >= argc) {
			fprintf(stderr, ": option requires an argument -- %c\n", c);
			sp = 1;
			return('?');
		} else {
         //printf("DEBUG: getopt 2\n");
			optarg = argv[optind++];
      }
		sp = 1;
	} else {
		if(argv[optind][++sp] == '\0') {
         //printf("DEBUG: getopt 3\n");
			sp = 1;
			optind++;
		}
      //printf("DEBUG: getopt 4\n");
		optarg = NULL;
	}

   //printf("DEBUG: getopt return(%c)\n",c);
	return(c);
}



/*

   str2argv creates an arc/argv environment for getopt by parsing a given arg-string

*/

int    __argc;
char  *__argv[ARGV_MAX];
static char  *__argv_token;

/* initialize empty argc/argv struct */
static void
argv_init()
{
   //printf("DEBUG: argv_init\n");
   __argc = 0;
   if ((__argv_token = calloc(ARGV_TOKEN_MAX, sizeof(char))) == NULL)
      fprintf(stderr, "argv_init: failed to calloc");
}

/* add a character to the current token */
static void
argv_token_addch(int c)
{
   int n;

   //printf("DEBUG: argv_token_addch [%c]\n", c);

   n = strlen(__argv_token);
   if (n == ARGV_TOKEN_MAX - 1)
      fprintf(stderr, "argv_token_addch: reached max token length (%d)", ARGV_TOKEN_MAX);

   __argv_token[n] = c;
}

/* finish the current token: copy it into __argv and setup next token */
void
argv_token_finish()
{
   //printf("DEBUG: argv_token_finish\n");

   if (__argc == ARGV_MAX)
      fprintf(stderr, "argv_token_finish: reached max argv length (%d)", ARGV_MAX);

/*STATUS("finishing token: '%s'\n", __argv_token);*/
   __argv[__argc++] = __argv_token;
   if ((__argv_token = calloc(ARGV_TOKEN_MAX, sizeof(char))) == NULL)
      fprintf(stderr, "argv_token_finish: failed to calloc");
   //memset(__argv_token, 0, ARGV_TOKEN_MAX * sizeof(char)); // ueberfluessig, da schon in calloc erledigt  
}

/* main parser */
void
str2argv(char *s)
{
   BOOL in_token;
   BOOL in_container;
   BOOL escaped;
   char container_start;
   char c;
   int  len;
   int  i;

   container_start = 0;
   in_token = FALSE;
   in_container = FALSE;
   escaped = FALSE;

   len = strlen(s);

   //printf("DEBUG: str2argv(%s), len = %d\n",s,len);

   argv_init();
   for (i = 0; i < len; i++) {
      c = s[i];

      //printf("DEBUG: %d\n",c);

      switch (c) {
         /* handle whitespace */
         case ' ':
         case '\t':
         case '\n':         
            if (!in_token)
               continue;

            if (in_container) {
               argv_token_addch(c);
               continue;
            }

            if (escaped) {
               escaped = FALSE;
               argv_token_addch(c);
               continue;
            }

            /* if reached here, we're at end of token */
            in_token = FALSE;
            argv_token_finish();
            break;

         /* handle quotes */
         case '\'':
         case '\"':

            if (escaped) {
               argv_token_addch(c);
               escaped = FALSE;
               continue;
            }

            if (!in_token) {
               in_token = TRUE;
               in_container = TRUE;
               container_start = c;
               continue;
            }

            if (in_container) {
               if (c == container_start) {
                  in_container = FALSE;
                  in_token = FALSE;
                  argv_token_finish();
                  continue;
               } else {
                  argv_token_addch(c);
                  continue;
               }
            }

            /* XXX in this case, we:
             *    1. have a quote
             *    2. are in a token
             *    3. and not in a container
             * e.g.
             *    hell"o
             *
             * what's done here appears shell-dependent,
             * but overall, it's an error.... i *think*
             */
            fprintf(stderr, "Parse Error! Bad quotes\n");
            break;

         case '\\':

            if (in_container && s[i+1] != container_start) {
               argv_token_addch(c);
               continue;
            }

            if (escaped) {
               argv_token_addch(c);
               continue;
            }

            escaped = TRUE;
            break;

         default:
            if (!in_token) {
               in_token = TRUE;
            }

            argv_token_addch(c);

            if(!s[i+1]) argv_token_finish(); // handle strings without \t or \n !!
      }
   }

   if (in_container)
      fprintf(stderr, "Parse Error! Still in container\n");

   if (escaped)
      fprintf(stderr, "Parse Error! Unused escape (\\)\n");
}