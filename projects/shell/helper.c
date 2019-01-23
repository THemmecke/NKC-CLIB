#include <stdlib.h>
#include <debug.h>
#include <string.h>
#include <fs.h>


/*---------------------------------------------------------*/
/* Work Area                                               */
/*---------------------------------------------------------*/
struct fpinfo FPInfo; //  working struct for checkfp (check file-path), also stores current drive and path
struct fpinfo FPInfo1, FPInfo2; // working buffer(2) for arbitrary use with checkfp and checkargs


/*--------------------------------------------------------*/
/* Get a (long / 32Bit) value of the string               */
/* the variable, where res points to, has to be 32 bits ! */
/*--------------------------------------------------------*/
/*	"123 -5   0x3ff 0b1111 0377  w "
	    ^                           1st call returns 123 and next ptr
	       ^                        2nd call returns -5 and next ptr
                   ^                3rd call returns 1023 and next ptr
                          ^         4th call returns 15 and next ptr
                               ^    5th call returns 255 and next ptr
                                  ^ 6th call fails and returns 0
*/

int xatoi (			/* 0:Failed, 1:Successful */
	char **str,	/* Pointer to pointer to the string Note: char var[x] => &var cannot be used directly, use pvar = &var instead !*/
	long *res		/* Pointer to a variable to store the value Note: MUST be 32 bits ! */
)
{
	unsigned long val;
	unsigned char r, s = 0;
	char c;

	dbg(" xatoi(0x%08x 0x%08x 0x%08x)\n",**str,*str, str);

	*res = 0;
	while ((c = **str) == ' ') (*str)++;	/* Skip leading spaces */

	if (c == '-') {		/* negative? */
		s = 1;
		c = *(++(*str));
	}

	if (c == '0') {
		c = *(++(*str));
		switch (c) {
		case 'x':		/* hexdecimal */
			r = 16; c = *(++(*str));
			break;
		case 'b':		/* binary */
			r = 2; c = *(++(*str));
			break;
		default:
			if (c <= ' ') return 1;	/* single zero */
			if (c < '0' || c > '9') return 0;	/* invalid char */
			r = 8;		/* octal */
		}
	} else {
		if (c < '0' || c > '9') return 0;	/* EOL or invalid char */
		r = 10;			/* decimal */
	}

	val = 0;
	while (c > ' ') {
		if (c >= 'a') c -= 0x20;
		c -= '0';
		if (c >= 17) {
			c -= 7;
			if (c <= 9) return 0;	/* invalid char */
		}
		if (c >= r) return 0;		/* invalid char for current radix */
		val = val * r + c;
		c = *(++(*str));
	}
	if (s) val = 0 - val;			/* apply sign if needed */

	*res = val;
	return 1;
}

/*----------------------------------------------*/
/* Get a (string)value of the string            */
/*----------------------------------------------*/
/*	"HDA0   binary w "
	    ^                       1st call returns 'HDA0' and next ptr (if len = 4)
	        ^                   2nd call returns 'binary' and next ptr
                   ^            3rd call returns 'w' and next ptr                          
*/

int xatos (			/* 0:Failed, 1:Successful */
	char **str,		/* Pointer to pointer to the string */
	char *res,		/* Pointer to a variable to store the sub-string */
	int len			/* max length of sub-string without terminating NULL */
)
{	
	char *p= res;
	char c;
	int n=0;

	//printf(" xatos input = %s\n",*str);
	
	*res = 0;
	while ((c = **str) == ' ') (*str)++;	/* Skip leading spaces */

	
	while (c > ' ' && n < len) {
		*p++ = c;
		c = *(++(*str));
		n++;
	}
	
	*p = 0; /* terminate string */
	
	
	if(n == 0) return 0;
	//  else return 1;
	return 1;
}


int checkargs(char* args, char* fullpath1, char* fullpath2) 
{
  int res;
  
  char *arg1=0;
  char *arg2=0;  
  
  
  while (*args == ' ') args++; // skip whitespace
  arg1 = args;     // pointer to 1st parameter
   
  arg2 = strchr(args, ' ');  // search 2nd parameter
  if (!arg2)                   // if no 2nd parameter
     arg2 = arg1;   //   2nd parameter == 1st parameter
  else *arg2++ = 0;    // terminate 1st par and increment pointer to next char
  while (*arg2 == ' ') arg2++; // skip whitespace   
   

  dbg("checkargs: arg1 = %s, arg2 = %s\n\n", arg1, arg2);


  /* initialize default values */
  strcpy(FPInfo1.psz_cdrive,FPInfo.psz_cdrive);
  strcpy(FPInfo1.psz_cpath,FPInfo.psz_cpath);
        
  res = checkfp(arg1, &FPInfo1);
       
  dbg("\nFPINFO1:\n");
  dbg(" psz_driveName:  [%s]\n",FPInfo1.psz_driveName ); // FIXME: wenn leer, dann cdrive !?
  dbg(" psz_deviceID:   [%s]\n",FPInfo1.psz_deviceID );
  dbg(" c_deviceNO:     [%c]\n",FPInfo1.c_deviceNO );
  dbg(" n_partition:    [%d]\n",FPInfo1.n_partition );
  dbg(" psz_path:       [%s]\n",FPInfo1.psz_path );
  dbg(" psz_filename:   [%s]\n",FPInfo1.psz_filename );
  dbg(" c_separator:    [%c]\n",FPInfo1.c_separator );
  dbg(" psz_fileext:    [%s]\n",FPInfo1.psz_fileext );
  dbg(" psz_cdrive:     [%s]\n",FPInfo1.psz_cdrive );
  dbg(" psz_cpath:      [%s]\n",FPInfo1.psz_cpath );
  dbg(" b_has_wcard:    [%d]\n",FPInfo1.b_has_wcard );
  dbg(" psz_wcard:      [%s]\n",FPInfo1.psz_wcard );
  dbg("\nres = %d\n",res);
 
   
  if(fullpath2) {
    /* initialize default values */
    strcpy(FPInfo2.psz_cdrive,FPInfo.psz_cdrive);
    strcpy(FPInfo2.psz_cpath,FPInfo.psz_cpath);
       
    res = checkfp(arg2, &FPInfo2); 

    if(!FPInfo1.b_has_wcard)     /* if arg1 has no wild cards and arg2 has no filename, copy filename from arg1 to arg2 */
      if(!FPInfo2.psz_filename[0]) {
          strcpy(FPInfo2.psz_filename,FPInfo1.psz_filename);
          FPInfo2.c_separator = FPInfo1.c_separator;
          strcpy(FPInfo2.psz_fileext,FPInfo1.psz_fileext);       
      }
  
     
    if(arg1 == arg2){               /* if no 2nd argument, force to default drive and path */
      FPInfo2.psz_driveName[0] = 0;
      FPInfo2.psz_deviceID[0] = 0;
      FPInfo2.c_deviceNO = 0;
      FPInfo2.n_partition = 0;
      FPInfo2.psz_path[0] = 0;
    } 
     
    
    dbg("\nFPINFO2:\n");
    dbg(" psz_driveName:  [%s]\n",FPInfo2.psz_driveName ); // FIXME: wenn leer, dann cdrive !?
    dbg(" psz_deviceID:   [%s]\n",FPInfo2.psz_deviceID );
    dbg(" c_deviceNO:     [%c]\n",FPInfo2.c_deviceNO );
    dbg(" n_partition:    [%d]\n",FPInfo2.n_partition );
    dbg(" psz_path:       [%s]\n",FPInfo2.psz_path );
    dbg(" psz_filename:   [%s]\n",FPInfo2.psz_filename );
    dbg(" c_separator:    [%c]\n",FPInfo2.c_separator );
    dbg(" psz_fileext:    [%s]\n",FPInfo2.psz_fileext );
    dbg(" psz_cdrive:     [%s]\n",FPInfo2.psz_cdrive );
    dbg(" psz_cpath:      [%s]\n",FPInfo2.psz_cpath );
    dbg(" b_has_wcard:    [%d]\n",FPInfo2.b_has_wcard );
    dbg(" psz_wcard:      [%s]\n",FPInfo2.psz_wcard );
    dbg("\nres = %d\n",res);
  }
   
  /* ------------ build fullpath  (1) ------------ */

  /* 1: drive */
  fullpath1[0]=0;
  if( !FPInfo1.psz_driveName[0] ){                                   /* use current drive if no drive given */
    dbg("no psz_driveName, use psz_cdrive in fullpath1...\n");     
    strcat(fullpath1,FPInfo1.psz_cdrive); 
  }else{
    strcat(fullpath1,FPInfo1.psz_driveName);
    dbg("use psz_driveName in fullpath1...\n");    
  }

  strcat(fullpath1,":");     
                
  /* 2: path */
  switch (FPInfo1.psz_path[0]) {
    case 0 :                                                       /* if no path given and .... */ 
         if( !FPInfo1.psz_driveName[0] ||                          /* no drive given or ... */ 
             !strcmp(FPInfo1.psz_driveName, FPInfo1.psz_cdrive) )  /* given drive == current drive */
           strcat(fullpath1,FPInfo1.psz_cpath);                    /* => use current path */
         break;
    case '/':                                                      /* absolute path given => use given path */
         strcat(fullpath1,FPInfo1.psz_path);
         break;
   default:                                                        /* relative path given => add given path to current path */
                                                                   /* but only if given drive == current drive */

         if( !FPInfo1.psz_driveName[0] ||                          /* no drive given or ... */ 
             !strcmp(FPInfo1.psz_driveName, FPInfo1.psz_cdrive) )  /* given drive == current drive */
           strcat(fullpath1,FPInfo1.psz_cpath);                    /* => use current path */

         strcat(fullpath1,FPInfo1.psz_path);                       /* add given path */
  }

  if(fullpath1[strlen(fullpath1)-1] != '/'){                       /* termitate path with '/' */
    fullpath1[strlen(fullpath1)+1] = 0;
    fullpath1[strlen(fullpath1)] = '/';
  }

  /* 3: filename.ext */
  if(!FPInfo1.b_has_wcard){                                        /* if arg has no wildcard, add filename to fullpath ... */
     strcat(fullpath1,FPInfo1.psz_filename);
     fullpath1[strlen(fullpath1)+1] = 0;       
     fullpath1[strlen(fullpath1)] = FPInfo1.c_separator;       
     strcat(fullpath1,FPInfo1.psz_fileext);
  }

  /* ------------ build fullpath  (2) ------------ */
  if(fullpath2) {
    /* 1: drive */
    fullpath2[0]=0;
    if( !FPInfo2.psz_driveName[0] ){                                   /* use current drive if no drive given */
       dbg("no psz_driveName, use psz_cdrive in fullpath2...\n");
       strcat(fullpath2,FPInfo2.psz_cdrive); 
    }else{
       strcat(fullpath2,FPInfo2.psz_driveName);
       dbg("use psz_driveName in fullpath1...\n");    
    }

    strcat(fullpath2,":");     
                  
    /* 2: path */              
    switch (FPInfo2.psz_path[0]) {
        case 0 :                                                       /* if no path given and .... */ 
          if( !FPInfo2.psz_driveName[0] ||                          /* no drive given or ... */ 
              !strcmp(FPInfo2.psz_driveName, FPInfo2.psz_cdrive) )  /* given drive == current drive */
            strcat(fullpath2,FPInfo2.psz_cpath);                    /* => use current path */
          break;
        case '/':                                                      /* absolute path given => use given path */
          strcat(fullpath2,FPInfo2.psz_path);
          break;
        default:                                                        /* relative path given => add given path to current path */
                                                                    /* rules from 'case 0' apply !! => if current path is not usable, use given path as
                                                                       an absolute path .... */

          if( !FPInfo2.psz_driveName[0] ||                          /* no drive given or ... */ 
              !strcmp(FPInfo2.psz_driveName, FPInfo2.psz_cdrive) )  /* given drive == current drive */
            strcat(fullpath2,FPInfo2.psz_cpath);                    /* => use current path */

          strcat(fullpath2,FPInfo2.psz_path);                       /* add given path */
    }

    if(fullpath2[strlen(fullpath2)-1] != '/'){                       /* termitate path with '/' */
      fullpath2[strlen(fullpath2)+1] = 0;
      fullpath2[strlen(fullpath2)] = '/';
    }

  /* 3: filename.ext */
    if(!FPInfo1.b_has_wcard){ /* if arg1 has no wildcard, add filename to fullpath ... */
      strcat(fullpath2,FPInfo2.psz_filename);
      fullpath2[strlen(fullpath2)+1] = 0;       
      fullpath2[strlen(fullpath2)] = FPInfo2.c_separator;       
      strcat(fullpath2,FPInfo2.psz_fileext);
    }
  }

  return 0;
}


void init_helper(void) {

  /* allocate memeory ... */ 
  FPInfo.psz_driveName  = (char*)malloc(_MAX_DRIVE_NAME);
  FPInfo.psz_deviceID   = (char*)malloc(_MAX_DEVICE_ID);
  FPInfo.psz_path     = (char*)malloc(_MAX_PATH);
  FPInfo.psz_filename   = (char*)malloc(_MAX_FILENAME);
  FPInfo.psz_fileext    = (char*)malloc(_MAX_FILEEXT);
  FPInfo.psz_cdrive   = (char*)malloc(_MAX_DRIVE_NAME);
  FPInfo.psz_cpath    = (char*)malloc(_MAX_PATH);
  FPInfo.psz_wcard    = (char*)malloc(_MAX_PATH);
  
   if( !FPInfo.psz_driveName || !FPInfo.psz_deviceID || !FPInfo.psz_path || !FPInfo.psz_filename ||
      !FPInfo.psz_fileext || !FPInfo.psz_fileext || !FPInfo.psz_cpath || !FPInfo.psz_wcard)
  {
    printf(" error allocating memory for FPInfo....\n");
    exit(1);
  }

  FPInfo1.psz_driveName = (char*)malloc(_MAX_DRIVE_NAME);  if(FPInfo1.psz_driveName == 0) exit(1); // exit with fatal error !!
  FPInfo1.psz_deviceID = (char*)malloc(_MAX_DRIVE_NAME);   if(FPInfo1.psz_deviceID == 0) exit(1);
  FPInfo1.psz_path = (char*)malloc(_MAX_PATH);       if(FPInfo1.psz_path == 0) exit(1); 
  FPInfo1.psz_filename = (char*)malloc(_MAX_FILENAME);   if(FPInfo1.psz_filename ==0 ) exit(1);
  FPInfo1.psz_fileext = (char*)malloc(_MAX_FILEEXT);    if(FPInfo1.psz_fileext == 0 ) exit(1);
  FPInfo1.psz_cdrive = (char*)malloc(_MAX_DRIVE_NAME);     if(FPInfo1.psz_cdrive == 0 ) exit(1);
  FPInfo1.psz_cpath = (char*)malloc(_MAX_PATH);      if(FPInfo1.psz_cpath == 0 ) exit(1);
  FPInfo1.psz_wcard = (char*)malloc(_MAX_PATH);      if(FPInfo1.psz_wcard == 0 ) exit(1);
  
  FPInfo2.psz_driveName = (char*)malloc(_MAX_DRIVE_NAME);  if(FPInfo2.psz_driveName == 0) exit(1); // exit with fatal error !!
  FPInfo2.psz_deviceID = (char*)malloc(_MAX_DRIVE_NAME);   if(FPInfo2.psz_deviceID == 0) exit(1);
  FPInfo2.psz_path = (char*)malloc(_MAX_PATH);       if(FPInfo2.psz_path == 0) exit(1); 
  FPInfo2.psz_filename = (char*)malloc(_MAX_FILENAME);   if(FPInfo2.psz_filename ==0 ) exit(1);
  FPInfo2.psz_fileext = (char*)malloc(_MAX_FILEEXT);    if(FPInfo2.psz_fileext == 0 ) exit(1);
  FPInfo2.psz_cdrive = (char*)malloc(_MAX_DRIVE_NAME);     if(FPInfo2.psz_cdrive == 0 ) exit(1);
  FPInfo2.psz_cpath = (char*)malloc(_MAX_PATH);      if(FPInfo2.psz_cpath == 0 ) exit(1);
  FPInfo2.psz_wcard = (char*)malloc(_MAX_PATH);      if(FPInfo2.psz_wcard == 0 ) exit(1);
}

void exit_helper(void) {

  free(FPInfo.psz_driveName);
  free(FPInfo.psz_deviceID );
  free(FPInfo.psz_path     );
  free(FPInfo.psz_filename );
  free(FPInfo.psz_fileext  );
  free(FPInfo.psz_cdrive   );
  free(FPInfo.psz_cpath    );
  free(FPInfo.psz_wcard    );

  free( FPInfo1.psz_driveName);
  free( FPInfo1.psz_deviceID);
  free( FPInfo1.psz_path);
  free( FPInfo1.psz_filename);
  free( FPInfo1.psz_fileext);
  free( FPInfo1.psz_cdrive);
  free( FPInfo1.psz_cpath);
  free( FPInfo1.psz_wcard);
  
  free( FPInfo2.psz_driveName);
  free( FPInfo2.psz_deviceID);
  free( FPInfo2.psz_path);
  free( FPInfo2.psz_filename);
  free( FPInfo2.psz_fileext);
  free( FPInfo2.psz_cdrive);
  free( FPInfo2.psz_cpath);
  free( FPInfo2.psz_wcard);
}