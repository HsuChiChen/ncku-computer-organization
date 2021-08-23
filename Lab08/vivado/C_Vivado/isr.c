#include "isr.h"

void __irq irq_isr(void)
{
  volatile int *tube =  (int*) 0x20000000;    
  volatile int *IRCntl =  (int*) 0x57000000;
  
  tube[0] = 'I' ;     
  tube[0] = 'R' ;
  tube[0] = 'Q' ;
  tube[0] = '\n' ;

  if(IRCntl[0]==0x8000)
	{
	  IRCntl[1] = IRCntl[0] ;
	  IRCntl[0] = 0x0 ; 
	    tube[0] = 'T' ;     
		tube[0] = 'e' ;
		tube[0] = 'r' ; 
		tube[0] = '1' ;
		tube[0] = '\n' ;
	}
	
  if(IRCntl[0]==0x4000)
	{
	  IRCntl[1] = IRCntl[0] ;
	  IRCntl[0] = 0x0 ; 
	    tube[0] = 'T' ;     
		tube[0] = 'e' ;
		tube[0] = 'r' ;
		tube[0] = '2' ;
		tube[0] = '\n' ;
	}
	
	
}
