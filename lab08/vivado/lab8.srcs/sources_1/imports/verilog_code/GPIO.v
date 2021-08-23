
module GPIO(
    HRESETn,
	HSEL_LED,
	 clk,
	 HREADY,

    LED,
	HREADY_LED,
    HRESP_LED,
	HWDATA
    );
	 
	 input  HRESETn ;
	 input  HSEL_LED;
	 input  clk;
	 input  HREADY;
	 input  [31:0] HWDATA;
	 

	 output [7:0] LED;
	 output HREADY_LED;
     output [1:0]HRESP_LED;
	 
	 reg  [7:0] LED_reg ;
	 reg  write_ready;
	 
	 assign HREADY_LED = 1'b1;
	 assign HRESP_LED  = 2'b00;
	 
	 assign LED = LED_reg ;
	 

	
		 always@(posedge clk)
	   begin
	   if (!HRESETn)
	      write_ready <= 1'b0;
	   else 
	   begin
       if(HSEL_LED & HREADY)
			write_ready <= 1'b1;
       else	
	      write_ready <= 1'b0;
	  end
	  end
		
		always@(write_ready or HRESETn)
		 begin 
		    if(!HRESETn)
				LED_reg = 8'b0000_0000;
			else 
			begin 
				if(write_ready)
			    LED_reg = HWDATA[7:0] ;    
			  else
				LED_reg =  LED_reg; 
			end
		 end
		
	
	
		
endmodule
