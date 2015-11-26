#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <signal.h>
#include <math.h>
#include <conio.h>
#include <memory.h>

//#define NKC_DEBUG	

#ifdef NKC_DEBUG
#include "../nkc/llnkc.h"
#endif



void PRINTF_TEST();
void MATH_TEST();
void MEM_TEST_I();
void MEM_TEST_II();
void FILEIO_TEST();
void TIME_TEST();
void TIME_TEST2();
void SIGNAL_TEST();
void CTRLC_TEST();
void CONIO_TEST();
void VMEM_TEST();


void walk_heap(void);


int main(int argc, const char* argv[])
{	
	
	//perror(" error message \n");
	//TIME_TEST();
	//TIME_TEST2();
	//CTRLC_TEST();
	//SIGNAL_TEST();
	//PRINTF_TEST();	
  	//MATH_TEST();
  		
	//MEM_TEST_I();
	//MEM_TEST_II();
	//FILEIO_TEST();
	//FAT32_TEST();	
	//VMEM_TEST();
	CONIO_TEST();
}





void CONIO_TEST()
{
  int x,y;
  //void drv_put_pixel(int x, int y, int p, unsigned char color);
  drv_put_pixel(10, 10, 0,0x01);
  nkc_getchar();
  
  for(y=10; y<50; y++)
    for(x=10;x<50;x++)
      drv_put_pixel(x,y,0,0x55);
}






void FAT32_TEST()
{
   char input;
   
   printf(" ******** FAT32-Test **********\n");

}


void CTRLC_TEST()
{
 printf("\n CTRLC_TEST...\n");
 while(1) {};
 printf("\n ....CTRLC_TEST\n");
}
void MATH_TEST()
{
	double dblres,dbln;
	int slen,n ;
   	div_t divt;
   	ldiv_t ldivt;

        LONGLONG l1,l2,l3;
        
	printf("\n MATH_TEST...\n");
	
	
	l1 = 0xFFFFFFFFFFFFFFF;
	l2 = 0x12345678;
	
	l3 = l1 / l2,
	
	nkc_write("done...");
	printf(" l1 = 0x%llx, l2= 0x%llx, l3 = 0x%llx\n",l1,l2,l3);
	return;

	// math/divmod64.S
	/*
	DWORD do_div(PLARGE_INTEGER pli, DWORD base);
	DWORD div64(PLARGE_INTEGER pli, DWORD base); 
	DWORD div32(DWORD *divident, DWORD base);  	
	div_t       div(int __numer, int __denom);
	ldiv_t      ldiv(long __numer, long __denom);
	*/

/*
   printf("ldiv(1): 0xffffff / 0xffff0 = ");
   ldivt = ldiv(0xffffff, 0xffff0); // 0xffffff/0xffff0 => divt.quot = 0x10, divt.rem=0xff
   printf("ldivt.quot = %lx, ldivt.rem = %lx\n",ldivt.quot,ldivt.rem);

   printf("ldiv(2): 0xffff0 / 0x55 = ");
   ldivt = ldiv(0xffff0, 0x55); // 0xffff0/0x55 => divt.quot = 0x3030, divt.rem=0
   printf("ldivt.quot = %lx, ldivt.rem = %lx\n",ldivt.quot,ldivt.rem);

   printf("ldiv(3): 0xfff / 0x55 = ");
   ldivt = ldiv(0xfff, 0x55); // 0xfff/0x55 => divt.quot = 0x30, divt.rem=0xf
   printf("ldivt.quot = %lx, ldivt.rem = %lx\n",ldivt.quot,ldivt.rem);
*/	

   // double acos(double)
   printf ("acos( 0.0123 ) = %.4f (%.4f) ->(KEY)\n", acos( 0.0123 ), 1.558 ) ;  getchar();
   // double asin(double)
   printf ("asin( 0.987  ) = %.4f (%.4f) ->(KEY)\n", asin( 0.987 ), 1.409 ) ; getchar();
   // double atan(double)
   printf ("atan( 0.987  ) = %.4f (%.4f) ->(KEY)\n", atan( 0.987 ), 0.778856 ) ;  getchar();
   // ceil
   printf ("ceil( 2.3    ) = %.4f (%.4f) \nceil(-2.8    ) = %.4f (%.4f) ->(KEY)\n", ceil( 2.3 ), 3.0, ceil(-2.8),-2.0 ) ; getchar();
   // floor
   printf ("floor( 2.3   ) = %.4f (%.4f) \nfloor(-2.8   ) = %.4f (%.4f) ->(KEY)\n", floor( 2.3 ), 2.0, floor(-2.8),-3.0 ) ; getchar();
   // double cos(double)
   printf ("cos ( 9.8    ) = %.4f (%.4f) ->(KEY)\n", cos(9.8), -0.9304262721047 ) ; getchar();
   // cosh
   printf ("cosh( 9.8    ) = %.4f (%.4f) ->(KEY)\n", cosh(9.8), 9016.8725 ) ; getchar();   
   // exp
   printf ("exp ( 3.2    ) = %.4f (%.4f) ->(KEY)\n", exp(3.2), 24.533 ) ; getchar();
   // fabs
   printf ("fabs( -3.2   ) = %.4f (%.4f) ->(KEY)\n", fabs(-3.2), 3.2 ) ; getchar();
   // fmod
   printf ("fmod( 5.3, 2 ) = %.4f (%.4f) \nfmod(18.5,4.2) = %.4f (%.4f) ->(KEY)\n", fmod( 5.3, 2 ), 1.3, fmod(18.5,4.2),1.7 ) ; getchar();
   // frexp --
   dblres = frexp( 8.0, &n );
   printf ("frexp( 8.0, *exp ) = %.4f (%.4f) exp = %d (%d) ->(KEY)\n", dblres, 0.5, n,4 ) ; getchar();     
   // ldexp
   printf ("ldexp( 0.95, 4 ) = %.4f (%.4f) ->(KEY)\n", ldexp( 0.95, 4 ) , 15.2) ; getchar();
   // log
   printf ("log( 5.5 ) = %.4f (%.4f) ->(KEY)\n", log( 5.5 ) , 1.704748) ; getchar();
   // log10
   printf ("log10( 1000.0 ) = %.4f (%.4f) ->(KEY)\n", log10( 1000.0 ) , 3.0) ; getchar();
   // modf
   dblres = modf( 3.14159265, &dbln );
   printf ("modf( 3.14159265, &n ) = %.4f (%.4f); intpart = %.1f (%.1f) ->(KEY)\n", dblres , 0.141593, dbln, 3.0) ; getchar();
   // pow 	
   printf ("pow(3.1, 4.5 ) = 3.1 ^ 4.5 = %.4f (%.4f) ->(KEY)\n", pow(3.1, 4.5), 162.6026511 ) ; getchar();
   // sin
   printf ("sin( 0.523599  ) = %.4f (%.4f) ->(KEY)\n", sin( 0.523599 ), 0.5 ) ; getchar();
   // sinh
   printf ("sinh( 0.693147  ) = %.4f (%.4f) ->(KEY)\n", sinh( 0.693147 ), 0.7 ) ; getchar();
   // sqrt
   printf ("sqrt( 1024.0  ) = %.4f (%.4f) ->(KEY)\n", sqrt( 1024.0 ), 32.0 ) ; getchar();
   // tan
   printf ("tan( 0.785398  ) = %.4f (%.4f) ->(KEY)\n", tan( 0.785398 ), 1.0 ) ; getchar();
   // tanh
   printf ("tanh( 0.693147  ) = %.4f (%.4f) ->(KEY)\n", tanh( 0.693147 ), 0.6 ) ; getchar();
   // abs
   printf ("abs( -78  ) = %d (%d) ->(KEY)\n", abs( -78 ), 78 ) ; getchar();
   // rand
   // div, ldiv
   // test printf itself with float:
   printf ("printf: pow(3.1, 4.5 ) = 3.1 ^ 4.5 = %.4f (%.4f) ->(KEY)\n", pow(3.1, 4.5), 162.6026511 ) ; getchar();


	

	printf("\n ....MATH_TEST\n");
}

void SIGNAL_TEST()
{
  printf("\n SIGNAL_TEST....(KEY)"); getchar(); printf("\n");
  
  raise(SIGBREAK);
}

void TIME_TEST()
{
	time_t now;				
	struct tm * timeinfo;
			
	printf("\n TIME_TEST...\n");
											
  	now = time((time_t *)NULL);		
  	printf("%s\n", ctime(&now));  		
	
  	time ( &now ); // same as now = time((time_t *)NULL);
  	timeinfo = localtime ( &now );
  	printf ( "The current date/time is: %s", asctime (timeinfo) );
  	
  	printf(" ....TIME_TEST\n");
  
}




struct tm *tmnow;

void today(void) {
   time_t tnow;

   time(&tnow);
   tmnow = localtime(&tnow);
   printf("Heute ist der ");
   printf("%d.%d.%d\n",
      tmnow->tm_mday, tmnow->tm_mon + 1, tmnow->tm_year + 1900);
}


void TIME_TEST2()
{

   
   int tag, monat, jahr;
   unsigned int i=0, tmp;

   printf("Bitte gib Deinen Geburtstag ein!\n");
   printf("Tag : ");
   scanf("%d", &tag);
   printf("Monat : ");
   scanf("%d", &monat);
   printf("Jahr (jjjj) : ");
   scanf("%d", &jahr);
   today();
   if(tmnow->tm_mon < monat) {
      i = 1;
      tmp=tmnow->tm_mon+1-monat;
      monat=tmp+12;
   }
   else {
      tmp=tmnow->tm_mon+1-monat;
      monat=tmp;
   }
   if(monat == 12) {
      monat = 0;
      i = 0;
   }
   printf("Sie sind %d Jahre %d Monat(e) %d Tag(e) alt\n",
      tmnow->tm_year+1900-jahr-i,monat, tmnow->tm_mday-tag);

}

void FILEIO_TEST()
{
	FILE *pf1,*pf2;
	char buffer[10]; // index 0...9
	unsigned int bytes;
	
	#ifdef NKC_DEBUG
	nkc_write("\n\n FILEIO_TEST:\n\n");
	#endif
	
	nkc_write(" writing into text file.....................................\n");
	nkc_getchar();
	pf1 = fopen("hda0:TEST1.TXT","w+");

	if(!pf1)
	{	
		printf(" error opening file ...\n");
		return;
	}
	
	nkc_write(" zeile 1:\n"); nkc_getchar(); fprintf(pf1," Dies ist Zeile 1\n");
	nkc_write(" zeile 2:\n"); nkc_getchar(); fprintf(pf1," Dies ist Zeile 2\n");
	nkc_write(" zeile 3:\n"); nkc_getchar(); fprintf(pf1," Dies ist Zeile 3\n");	
	nkc_write(" zeile 4:\n"); nkc_getchar(); fprintf(pf1," Dies ist Zeile 4\n");
	nkc_write(" zeile 5:\n"); nkc_getchar(); fprintf(pf1," Dies ist Zeile 5\n");
	nkc_write(" zeile 6:\n"); nkc_getchar(); fprintf(pf1," Dies ist Zeile 6\n");
	nkc_write(" zeile 7:\n"); nkc_getchar(); fprintf(pf1," Dies ist Zeile 7\n");
	nkc_write(" zeile 8:\n"); nkc_getchar(); fprintf(pf1," Dies ist Zeile 8\n");
		
	nkc_write(" closing input file\n"); nkc_getchar();
	fclose(pf1);
	return;
	
	nkc_write("seeking to start of file......................................\n");
	nkc_getchar();	
	
	fseek(pf1,0,SEEK_SET);
	
	buffer[9]=0;
	
	fgets(buffer,9,pf1);
	nkc_write(buffer);
	
	while(!feof(pf1))
	{		
		fgets(buffer,9,pf1);
		nkc_write(buffer);
	}

	nkc_write(" closing input file\n"); nkc_getchar();
	fclose(pf1);
		
	nkc_write(" Next..."); nkc_getchar(); nkc_write("\n");
	
	nkc_write(" copy text file..........................................\n");
	
	pf1 = fopen("hda0:TEST1.TXT","r");
	pf2 = fopen("hda0:TEST2.TXT","w");
	
	while(!feof(pf1))
	{
		fgets(buffer,9,pf1);
		nkc_write(buffer); nkc_getchar();
		fprintf(pf2,"%s",buffer);
	}

	fclose(pf1);
	fclose(pf2);	
	
	nkc_write(" Next..."); nkc_getchar(); nkc_write("\n");
	
	
	
	nkc_write(" copy text file (binary)...............................\n");

	pf1 = fopen("hda0:TEST1.TXT","rb");		
	nkc_write(" flags=0x"); nkc_write_hex8(pf1->flags); nkc_write("\n");
	
	pf2 = fopen("hda0:TEST3.TXT","wb");
	
	bytes = 0;
	
	while(!feof(pf1))  // schlägt nicht an ....
	{
		#ifdef NKC_DEBUG
		nkc_write("("); nkc_write_dec_dw(bytes); nkc_write(" -  "); nkc_write_hex8(pf1->fd); nkc_write(" : "); nkc_write_hex8(pf2->fd);	nkc_write(") next:"); nkc_getchar(); nkc_write("\n");
		#endif
		if(fread(buffer,2,4,pf1))
		{
		 fwrite(buffer,2,4,pf2)	;	
		 bytes +=8;	
		}
	}

	#ifdef NKC_DEBUG
	nkc_write("\nclose input file:\n");
	nkc_write(" flags=0x"); nkc_write_hex8(pf1->flags); nkc_write("\n");
	#endif
	fclose(pf1); // ruft write_sector obwohl read-only geöffnet !!
	#ifdef NKC_DEBUG
	nkc_write("\nclose output file:\n");	
	nkc_write(" flags=0x"); nkc_write_hex8(pf2->flags); nkc_write("\n");
	#endif
	fclose(pf2);	
		
	
}


void PRINTF_TEST()
{
	int i,j ;
	int slen,n ;
        char *ptr = "Hello world!";
        char *np = 0;
	char buf[256];
	char string[] = "Text-String";
	
	printf(" PRINTF_TEST:\n\n");
	printf(" DEC      HEX      OCT      STRING\n");
	for(i=0; i< 15; i++)
	{	
		j = rand() % 100;		
		printf(" %d       0x%0x    o%o      %s\n",j,j,j,string);
	}
	printf(" weiter mit Taste..."); getchar(); printf("\n");

	printf ("ptr=%s, %s is null pointer, char %c='a'\n", ptr, np, 'a');
   	printf ("hex %x = ff, hex02=%02x\n", 0xff, 2);   //  hex handling
   	printf ("signed %d = %uU = 0x%X\n", -3, -3, -3);   //  int formats
   	printf ("%d %s(s) with %%\n", 0, "message");

   	slen = sprintf (buf, "justify: left=\"%-10s\", right=\"%10s\"\n", "left", "right");
   	printf ("[len=%d] %s", slen, buf);
   
   	printf("     padding (pos): zero=[%04d], left=[%-4d], right=[%4d]\n", 3, 3, 3) ;


   	//  test walking string builder
   	slen = 0 ;
   	slen += sprintf(buf+slen, "padding (neg): zero=[%04d], ", -3) ;   //lint !e845
   	slen += sprintf(buf+slen, "left=[%-4d], ", -3) ;
   	slen += sprintf(buf+slen, "right=[%4d]\n", -3) ;
   	printf ("[%d] %s", slen, buf);
   	printf("+ format: int: %+d, %+d, double: %+.1f, %+.1f, reset: %d, %.1f\n", 3, -3, 3.0, -3.0, 3, 3.0) ;

   	printf ("%.2f is a double\n", 3.31) ;


   	printf ("multiple unsigneds: %u %u %2u %X\n", 15, 5, 23, 0xB38F) ;
   	

   	printf ("multiple chars: %c %c %c %c\n", 'a', 'b', 'c', 'd') ;
   	

   	printf ("multiple doubles: %f %.1f %2.0f %.2f %.3f %.2f [%-8.3f]\n",
                  3.45, 3.93, 2.45, -1.1, 3.093, 13.72, -4.382) ;
   	
   	printf ("double special cases: %f %.f %.0f %2f %2.f %2.0f\n",
                  3.14159, 3.14159, 3.14159, 3.14159, 3.14159, 3.14159) ;
   	
   	printf ("rounding doubles: %.1f %.1f %.3f %.2f [%-8.3f]\n",
                  3.93, 3.96, 3.0988, 3.999, -4.382) ;
                  
        printf("**** String longer that 32Bytes ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 ****");                  
   	
}


void MEM_TEST_II()
{
	unsigned char mem1[100], mem2[100], *p; // array of memory
	int i;

	printf(" mem1 = 0x%lx, mem2 = 0x%lx\n",mem1,mem2);
	printf(" Start memmove Test: (KEY)"); getchar(); printf("\n\n");

	memset(mem1,0x55,50);
	memset (mem1+50,0xAA,50);
	memset(mem2,0x00,100);

	memmove(mem2,mem1,100);

	for(i=0; i<50;i++){
		if((unsigned char)mem2[i] != 0x55) {
			printf("Fehler(%d): 0x%x =!= 0x%x\n",i,mem2+i,(unsigned char)mem2[i]);
			getchar();
		}
		//printf(" 0x%lx = 0x%x\n",&mem2[i],mem2[i]);
	}

	for(i=50; i<100;i++){
		if((unsigned char)mem2[i] != 0xAA) {
			printf("Fehler(%d): 0x%x =!= 0x%x\n",i,mem2+i,(unsigned char)mem2[i]);
			getchar();
		}
		//printf(" 0x%lx = 0x%x\n",&mem2[i],mem2[i]);
	}

	printf(" Start memcpy Test: (KEY)"); getchar(); printf("\n\n");	

	memset(mem1,0x55,50);
	memset (mem1+50,0xAA,50);
	memset(mem2,0x00,100);

	memcpy(mem2,mem1,100);

	for(i=0; i<50;i++){
		if((unsigned char)mem2[i] != 0x55) {
			printf("Fehler(%d): 0x%x =!= 0x%x\n",i,mem2+i,(unsigned char)mem2[i]);
			getchar();
		}
	}

	for(i=50; i<100;i++){
		if((unsigned char)mem2[i] != 0xAA) {
			printf("Fehler(%d): 0x%x =!= 0x%x\n",i,mem2+i,(unsigned char)mem2[i]);
			getchar();
		}
	}
}

void MEM_TEST_I()
{

	
	void *mem[100],*p; // array of memory

	printf(" Start MALLOC Test: (KEY)"); getchar(); printf("\n\n");

	mem[0] = malloc(10000);  // 0x02710
	mem[1] = malloc(500);	 // 0x001F4
	mem[2] = malloc(200000); // 0x30D40
	mem[3] = malloc(10);	 // 0xA
	mem[4] = malloc(100);	 // 0x64
	mem[5] = malloc(500000); // 0x7A120
	
	walk_heap(); getchar();
	
	free(mem[1]); 
	free(mem[3]);
	free(mem[4]);
	
	walk_heap(); getchar();
	
	mem[1] = malloc(450);
	
	walk_heap(); getchar();
	
	mem[3] = malloc(105);
	
	walk_heap(); getchar();
	
	free(mem[2]);
	
	walk_heap(); getchar();
	
	mem[2] = malloc(200010);
	 
	walk_heap(); getchar();
	
	mem[4] = malloc(200010);
	 
	walk_heap(); getchar();
	
	free(mem[0]);
	free(mem[1]);
	free(mem[2]);
	free(mem[3]);
	free(mem[4]);
	free(mem[5]);
	
	walk_heap(); getchar();
	
	printf("Ready !\n");
}



// ******************** VIDEO TEST ROUTINES **********************************************


void VMEM_TEST()
{
   unsigned char *p0,*p1,*p2,*p3;
   unsigned short *s0;
   unsigned int psize,i,j;
   unsigned int mem1[300], mem2[300]; // array of memory

   printf(" ******** VMEM-Test **********\n");
   
   printf("Press any key to continue...");
   getchar();  
   
   memset(mem2, 0, 300);
/*
   // pixel (x,y) == 1Cp0000 + y<<8 + x/2
   printf("Point at 1C00000 (x/y) = (0/0)");
   p0 = 0x1C00000;
   *p0 = 0x5555;
   getchar();

   printf("Point at 1C0FFFF (x/y) = (511/256)");
   p0 = 0x1C00000+510/2+(unsigned int)(255<<8);
   *p0 = 0x5555;
   getchar();
   //nkc_setflip(0,0);
*/  

   //void restore_block(int x1, int y1, int x2, int y2, void* src)
   //void safe_block(int x1, int y1, int x2, int y2, void* dst)

   // (x)512 x (y)256 Bildpunkte
  
  p0 = 0x1C00000 + (0 << 8) + 0/2;	// Zeiger auf Bildschirmspeicherbereich an der Stelle (x=0,y=0)
  p1 = 0x1C00000 + (255 << 8) + 511/2;	// Zeiger auf Bildschirmspeicherbereich an der Stelle (x=100,y=100)
  
   /*
   for(i=0; i<100; i++)
   {     
     s0 = 0x1C00000 + (i*2 << 8) + (i*2)/2;	// Zeiger auf Bildschirmspeicherbereich an der Stelle (x=0,y=0)
     mem1[0] = *s0; // save
     *s0 = 0x2222; // set yellow
     _keyci();
     *s0 = mem1[0]; // restore
   }
   */
   
   /*
   gdp_set_page(0, 0, 0);
   
   for(i=0; i<100; i++)
   {
     save_block(10+i*2, 10+i*2, 20+i*2+1, 20+i*2,mem1); 
     fill_block(10+i*2, 10+i*2, 20+i*2+1, 20+i*2,0x2222);      
     _keyci();
     restore_block(10+i*2, 10+i*2, 20+i*2+1, 20+i*2,mem1);
     
   }
   */
   
}
