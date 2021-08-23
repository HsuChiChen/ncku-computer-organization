
module Timers (	HCLK, HRESETn, HSELT , ENABLE_D, VALUE_D, HADDR, ACK,timer_itr);

  input 	HCLK ;
  input 	HRESETn;
  input         HSELT;
  input [31:0] 	ENABLE_D;
  input [31:0] 	VALUE_D;
  input [31:0] 	HADDR ; 
  input		ACK;	
  output 	timer_itr ;
  

  wire  [31:0]  number_next;
  reg 	[31:0]	number_currnt;
  reg 	[31:0] 	ENABLE ;
  reg 	[31:0] 	VALUE ;
  reg   flag;
  reg   interrupt ;

  
  assign number_next = (ENABLE == 32'h0000_0001)? 
						(number_currnt == 32'h0000_0000)? 
						((ACK==1'b1)? VALUE : number_currnt) : (number_currnt - 32'h0000_0001) 

						:number_currnt ;
  
  always @(posedge (HCLK) )
   begin
	 	if( (HADDR[7:0]==8'h00) && HSELT ) ENABLE <= ENABLE_D ;
		//	else   ENABLE <= 32'h0000_0000;
			
		else if( (HADDR[7:0]==8'h04) && HSELT) 
			begin 
				VALUE <= VALUE_D ;
				flag<=1;
			end
		else   	
			flag<=0;
   end
  
  
  
  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))  
		number_currnt <= 32'hzzzz_zzzz;
	else if( flag /*(HADDR[7:0]==8'h04) && HSELT*/ ) 
	  	number_currnt <=  VALUE ; 
	else 
		number_currnt <= number_next;
  end

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
	 if ((!HRESETn))  
		interrupt <= 1'b0;
	else if(number_currnt == 32'h0000_0000 )
		begin
		 if(ACK==1'b1)
			interrupt <=  1'b0 ;
		 else
			interrupt <=  1'b1 ;
		end	
	else 
		interrupt <= 1'b0;
  end
  
  //assign timer_itr = (number_currnt == 32'h0000_0000 ) ? ( (ACK==1'b1)?1'b0 : 1'b1 ) : 1'b0 ;
  assign timer_itr = interrupt;
  
  endmodule
  
