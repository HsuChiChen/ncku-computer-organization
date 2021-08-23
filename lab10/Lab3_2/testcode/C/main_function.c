#include "main_function.h"

void main_function ()
{
	volatile int *tube =  (int*) 0x20000000;
	volatile int*  Timer1;
	volatile int*  Timer2;

	Timer1 = (int*) 0x50000000;
	Timer1[0] = 1;
	Timer1[1] = 90;

	Timer2 = (int*) 0x51000000;
	Timer2[0] = 1;
	Timer2[1] = 100;

	tube[0] = '\n';     
	tube[0] = 'H' ;
	tube[0] = 'e' ;
	tube[0] = 'l' ;
	tube[0] = 'l' ;
	tube[0] = 'o' ;
	tube[0] = '\t';  
	tube[0] = 'E' ;
	tube[0] = 'A' ;
	tube[0] = 'S' ;
	tube[0] = 'Y' ;
	tube[0] = '!' ;
	tube[0] = '\n'; 
	
	while(1);
}





