#include "integer.h"
#include "diskio.h"
#include "gide.h"

#include "../../../CLIBS/nkc/nkc.h"


void test( USHORT a, BYTE b, ULONG c)
{
	struct _driveinfo lwdata;
	
	lwdata.numcyl = a;
	lwdata.numhead = b;
	lwdata.numsec = b;
	lwdata.nkcmode = c;
	
	lwdata.idename[23] = 0;
	printf(lwdata.idename);
			
	
}


	
