`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:20:57 08/14/2012 
// Design Name: 
// Module Name:    uart_control 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module uart_control(
    HRESETn,
	HSEL_UART,
	 clk,
	 HREADY,
	 rx_in,
    cpu_out,
	 cpu_out_ready,
	 HREADY_UART,
    HRESP_UART,
	 HWDATA
    );
	 
	 input  HRESETn ;
	 input  HSEL_UART;
	 input  clk;
	 input  HREADY;
	 input  [31:0] HWDATA;
	 input  [7:0] rx_in;
	 output cpu_out_ready;
	 output [7:0] cpu_out;
	 output HREADY_UART;
    output [1:0]HRESP_UART;
	 
	 
	 assign HREADY_UART = 1'b1;
	 assign HRESP_UART  = 2'b00;
	 reg  [7:0] cpu_out_reg ;
	 reg  cpu_out_ready_reg;
	 
	 assign cpu_out = cpu_out_reg ;
	 assign cpu_out_ready = cpu_out_ready_reg;
	 

	 
	 
	 always@(posedge clk)
	   begin
	   if (!HRESETn)
	      cpu_out_ready_reg <= 1'b0;
	   else 
	   begin
       if(HSEL_UART & HREADY)
			cpu_out_ready_reg <= 1'b1;
       else	
	      cpu_out_ready_reg <= 1'b0;
	  end
	  end
		
		always@(cpu_out_ready or HRESETn)
		 begin 
		    if(!HRESETn)
				cpu_out_reg = 8'b0000_0000;
			else 
			begin 
				if(cpu_out_ready)
			    cpu_out_reg = HWDATA[7:0] ; 
			  else
				cpu_out_reg =  8'b0101_1010; 
			end
		 end
		
	
		
endmodule
