
module UART (clk55MHz, HRESETn, uart_rst,tx,rx,alarm,HSEL_UART,HREADY,HREADY_UART,HWDATA); 

input    	clk55MHz ;
input 		HRESETn ;
input		uart_rst;
input		rx;
input		HSEL_UART ;
input		HREADY;
input		[31:0] HWDATA;

output		HREADY_UART ;
output	 	tx;
output		alarm;
  reg             alarm;
//
wire [9:0] 	address;
wire [17:0]	instruction;
wire [7:0]	port_id;
wire [7:0] 	out_port;
reg [7:0] 	in_port;

//reg  	write_strobe;
wire  	write_strobe;
wire  	read_strobe;
reg  		interrupt;
wire  	interrupt_ack;

// Signals for connection of peripherals
wire [7:0] 	uart_status_port;

// Signals to form an timer generating an interrupt every microsecond
reg [6:0] 	timer_count;
reg  		timer_pulse;

// Signals for UART connections

reg [9:0] 	baud_count;
reg  		en_16_x_baud;
wire  	write_to_uart;
wire  	tx_full;
wire  	tx_half_full;
reg  		read_from_uart;
wire [7:0] 	rx_data;
wire  	rx_data_present;
wire  	rx_full;
wire  	rx_half_full;
//wire    uart_rst = HRESETn ;
wire		cpu_out_ready;

//*********
reg [7:0]  tmp_data;
reg        data_signal;
reg [7:0]  out_port_reg;


kcpsm3 processor
(	.address(address),
    	.instruction(instruction),
    	.port_id(port_id),
    	.write_strobe(write_strobe),
    	.out_port(),                     //test
    	.read_strobe(read_strobe),
    	.in_port(in_port),
    	.interrupt(interrupt),
    	.interrupt_ack(interrupt_ack),
    	.reset(uart_rst),
    	.clk(clk55MHz));

uclock program_rom
(	.address(address),
    	.instruction(instruction),
   	.clk(clk55MHz));
		
		//
//--------------------------------------------------------------------------------------------------------------------------------
// Interrupt 
//--------------------------------------------------------------------------------------------------------------------------------
//
//
// Interrupt is a generated once every 50 clock cycles to provide a 1us reference. 
// Interrupt is automatically cleared by interrupt acknowledgment from KCPSM3.
//
//

always @(posedge clk55MHz) begin
      
      if (timer_count==49) 
		begin
         		timer_count <= 1'b0;
         		timer_pulse <= 1'b1;
		end
       else
		begin
         		timer_count <= timer_count + 1;
         		timer_pulse <= 1'b0;
		end
      

      if (interrupt_ack == 1'b1)
		begin
         		interrupt <= 1'b0;
		end
       else if (timer_pulse == 1'b1) 
		begin 
         		interrupt <= 1'b1;
		end
        else
		begin
         		interrupt <= interrupt;
		end

end

//--------------------------------------------------------------------------------------------------------------------------------
// KCPSM3 input ports 
//--------------------------------------------------------------------------------------------------------------------------------
//
//
// UART FIFO status signals to form a bus
//

  assign uart_status_port = {3'b 000,rx_data_present,rx_full,rx_half_full,tx_full,tx_half_full};
  
//
// The inputs connect via a pipelined multiplexer
//

  always @(posedge clk55MHz) begin
    case(port_id[0] )
    // read UART status at address 00 hex
    1'b 0 : 
	begin
      in_port <= uart_status_port;
    	end
    // read UART receive data at address 01 hex
    1'b 1 : 
	begin
      in_port <= rx_data;
    	end
    // Don't care used for all other addresses to ensure minimum logic implementation
    default : 
	begin
      in_port <= 8'b XXXXXXXX;
    	end
    endcase

    // Form read strobe for UART receiver FIFO buffer.
    // The fact that the read strobe will occur after the actual data is read by 
    // the KCPSM3 is acceptable because it is really means 'I have read you'!
	 
	// read_from_uart <= read_strobe & port_id[0] ;
    if(cpu_out_ready)
	    read_from_uart <= 1'b0;
	 else	 
       read_from_uart <= read_strobe & port_id[0] ;
  end

/*
//new_clk
new_clk n_c(
	.clk (HCLK),
	.rst (HRESETn),
	.new_clk (clka)
);
*/

//--------------------------------------------------------------------------------------------------------------------------------
// KCPSM3 output ports 
//--------------------------------------------------------------------------------------------------------------------------------
//
// adding the output registers to the clock processor
  always @(posedge clk55MHz) begin
    if(write_strobe == 1'b 1) begin
      // Alarm register at address 00 hex with data bit0 providing control
      if(port_id[0]  == 1'b 0) begin
        alarm <= out_port[0] ;
      end
    end
  end

//
// write to UART transmitter FIFO buffer at address 01 hex.
// This is a combinatorial decode because the FIFO is the 'port register'.
//
//assign write_to_uart = write_strobe & port_id[0] ;
//
//--------------------------------------------------------------------------------------------------------------------------------
// UART  
//--------------------------------------------------------------------------------------------------------------------------------
//
// Connect the 8-bit, 1 stop-bit, no parity transmit and receive macros.
// Each contains an embedded 16-byte FIFO buffer.
//
uart_tx transmit
(	   .data_in(out_port),
    	.write_buffer(write_to_uart),
    	.reset_buffer(1'b0),
    	.en_16_x_baud(en_16_x_baud),
    	.serial_out(tx),
    	.buffer_full(tx_full),
    	.buffer_half_full(tx_half_full),
    	.clk(clk55MHz));

uart_rx receive
(	   .serial_in(rx),
    	.data_out(rx_data),
    	.read_buffer(read_from_uart),
    	.reset_buffer(1'b0),
    	.en_16_x_baud(en_16_x_baud),
    	.buffer_data_present(rx_data_present),
    	.buffer_full(rx_full),
    	.buffer_half_full(rx_half_full),
    	.clk(clk55MHz)); 


// Set baud rate to 38400 for the UART communications
// Requires en_16_x_baud to be 614400Hz which is a single cycle pulse every 90 cycles at 55MHz 
//
// NOTE : If the highest value for baud_count exceeds 127 you will need to adjust 
//        the width in the reg declaration for baud_count.
//
//--------------------------------------------------------------------------------------------------------------------------------
  always @(posedge clk55MHz) 
  begin
      if (baud_count == 88) 
		begin
           		baud_count <= 1'b0;
      	     	en_16_x_baud <= 1'b1;
		end
       else
		begin
           		baud_count <= baud_count + 1;
           		en_16_x_baud <= 1'b0;
      end
  end


//----------------------------------------------------------------------------------------------------------------------------------
//
// END OF FILE uart_clock.v
//
//----------------------------------------------------------------------------------------------------------------------------------

//test//

reg [7:0]     cpu_data;
reg 		write_to_uart_reg;	


assign out_port = out_port_reg ;
wire  [7:0]cpu_out;

assign write_to_uart = write_to_uart_reg;
	
uart_control control
(	.HRESETn(HRESETn) ,
	.HSEL_UART(HSEL_UART),
	 .clk(clk55MHz),
	 .HREADY(HREADY),
	 .rx_in(tmp_data),
    .cpu_out(cpu_out),
	 .cpu_out_ready(cpu_out_ready),
	 .HREADY_UART(HREADY_UART),
    .HRESP_UART(HRESP_UART),
	 .HWDATA(HWDATA)
		);
		
		
always@(posedge clk55MHz)
begin
   if(cpu_out_ready)
      begin
	    write_to_uart_reg <=1'b1;
       out_port_reg <= cpu_out;  
	   end
   else
       write_to_uart_reg <=1'b0;	
end 
	 
	 
	 
endmodule

// --================================= End ===================================--
