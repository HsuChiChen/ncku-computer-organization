#include "isr.h"

void __irq irq_isr(void)
{
	volatile int *tube =  (int*) 0x20000000;    
	volatile int *IRCntl =  (int*) 0x57000000;   

	tube[0] = 'I';     
	tube[0] = 'R';
	tube[0] = 'Q';
	tube[0] = '\n';


	if(IRCntl[0]==0x8000)		//若是SW1發出的intterrupt，請讓Tube印出 "*LED"
	{
		
	}    
	else if(IRCntl[0]==0x4000)	//若是Timer1發出的intterrupt，請讓Tube印出"Ter1"
	{
		
	}	  
	else if(IRCntl[0]==0x2000)	//若是Timer2發出的intterrupt，請讓Tube印出"Ter2"
	{
		
	}

	//請讓clean被寫入pending的值，再對pending寫入0x0	
	IRCntl[1] = IRCntl[0] ;
	IRCntl[0] = 0x0 ; 
}