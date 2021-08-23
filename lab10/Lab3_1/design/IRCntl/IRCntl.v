
 
module IRCntl (HCLK, HRESETn,  HSELT, HADDR, HWRITE,HIRQSource,HIRQAck,HWDATA,HRDATA,nIRQ);
 
  input        	HCLK;
  input        	HRESETn;
  input        	HSELT;
  input        	HWRITE;
  input  [31:0] HADDR; 
  
  input  [15:0]	HIRQSource;


  output [15:0]	HIRQAck;

  
  input  [31:0]	HWDATA; 
  output [31:0]	HRDATA;
  output       	nIRQ;        // IRQ interrupt output to CPU 
  
  
  wire 	nCLK;
  reg	[31:0]	HIRQSourcesel;
  reg 	[31:0]	pending;
  reg	[31:0]	clean;
  reg 	Cflag ;
  reg	[15:0] 	AckTemp;
  reg	[31:0] RDATA;
	
	assign nCLK = ~HCLK; 
  
  /*
	assign HRDATA = ((HADDR[7:0]==8'h00)&& (~HWRITE) && (HSELT))? pending :
					((HADDR[7:0]==8'h04)&& (~HWRITE)&& (HSELT))? clean : HRDATA ;
	
  */
	assign HRDATA  =  RDATA;
	//assign HIRQAck = AckTemp ;
			
	assign nIRQ = (pending==32'h0000_0000)? 1'b1 :1'b0 ; 

	
 always @ (negedge (HRESETn) or posedge (HCLK))	
	begin
		if ((!HRESETn))
		RDATA <= 32'h0000_0000;
    
		else if((HADDR[7:0]==8'h00)&& (~HWRITE) && (HSELT)) 
			RDATA <= pending ;	
		
		else if((HADDR[7:0]==8'h04)&& (~HWRITE)&& (HSELT))
			RDATA <= clean ;	
		
		else 
			RDATA <= RDATA;
	end
	
	
 always @( negedge (HRESETn) or posedge (HCLK) )//or HIRQSource or clean)
  begin
    if ((!HRESETn))
		HIRQSourcesel <= 32'h0000_0000;
    
	else 
		begin
		HIRQSourcesel <= {16'h0000,HIRQSource};
		if(!(clean==32'h0000_0000))							
			HIRQSourcesel <= HIRQSourcesel&(~clean) ; 
		end
  end		

 
//------------------------------------------------------------------------------
// Fixed Priority & Masking 
//------------------------------------------------------------------------------
  
  always @( negedge (HRESETn) or posedge (HCLK) )// or HIRQSourcesel or clean)
	begin
	  if ((!HRESETn))
		pending <= 32'h0000_0000;
		
	  else  if(!Cflag && (pending[15:0]==16'h0000))//?
 	  begin
		if(HIRQSourcesel[15]||HIRQAck[15])
			pending <= 32'h0000_8000;
			
		else if(HIRQSourcesel[14]||HIRQAck[14])	
			pending <= 32'h0000_4000;
			
		else if(HIRQSourcesel[13]||HIRQAck[13])	
			pending <= 32'h0000_2000;
			
		else if(HIRQSourcesel[12]||HIRQAck[12])	
			pending <= 32'h0000_1000;
			
		else if(HIRQSourcesel[11]||HIRQAck[11])	
			pending <= 32'h0000_0800;
			
		else if(HIRQSourcesel[10]||HIRQAck[10])	
			pending <= 32'h0000_0400;
			
		else if(HIRQSourcesel[9]||HIRQAck[9])	
			pending <= 32'h0000_0200;
			
		else if(HIRQSourcesel[8]||HIRQAck[8])	
			pending <= 32'h0000_0100;
			
		else if(HIRQSourcesel[7]||HIRQAck[7])	
			pending <= 32'h0000_0080;
			
		else if(HIRQSourcesel[6]||HIRQAck[6])	
			pending <= 32'h0000_0040;
			
		else if(HIRQSourcesel[5]||HIRQAck[5])	
			pending <= 32'h0000_0020;
			
		else if(HIRQSourcesel[4]||HIRQAck[4])	
			pending <= 32'h0000_0010;
			
		else if(HIRQSourcesel[3]||HIRQAck[3])	
			pending <= 32'h0000_0008;
			
		else if(HIRQSourcesel[2]||HIRQAck[2])	
			pending <= 32'h0000_0004;
			
		else if(HIRQSourcesel[1]||HIRQAck[1])	
			pending <= 32'h0000_0002;
			
		else if(HIRQSourcesel[0]||HIRQAck[0])	
			pending <= 32'h0000_0001;
			
		else 
			pending <= pending ;
	   end
	   
	   else if(Cflag)
			pending <= 32'h0000_0000;  //clean
	  
	end
	
always @(negedge (HRESETn) or posedge (HCLK) )//or HWDATA or HSELT)
   begin
		if ((!HRESETn))
			begin 
			clean <= 32'h0000_0000 ;
			Cflag <= 0 ;
			end
	 	else if( (HADDR[7:0]==8'h04)&& (HWRITE)&& (HSELT) ) 
			begin
			clean <= HWDATA ;
			Cflag <= 1 ;
			end
		
		else if(nIRQ==1'b1)
			begin 
			Cflag <= 0;
			clean <= 32'h0000_0000 ;
			end
		else Cflag <= Cflag ;
	
   end

	
	always@(posedge (nCLK) )	
	  begin
		if((!nIRQ) && nCLK)
		AckTemp = pending[15:0] ;
		else 
		AckTemp = 16'h0000;
	  end	
	  
	assign HIRQAck = AckTemp ;  
 
endmodule

