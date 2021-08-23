//
//////////////////////////////////////////////////////////////////////////////////
// Copyright © 2010, Xilinx, Inc.
// This file contains confidential and proprietary information of Xilinx, Inc. and is
// protected under U.S. and international copyright and other intellectual property laws.
//////////////////////////////////////////////////////////////////////////////////
//
// Disclaimer:
// This disclaimer is not a license and does not grant any rights to the materials
// distributed herewith. Except as otherwise provided in a valid license issued to
// you by Xilinx, and to the maximum extent permitted by applicable law: (1) THESE
// MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY
// DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY,
// INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT,
// OR FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable
// (whether in contract or tort, including negligence, or under any other theory
// of liability) for any loss or damage of any kind or nature related to, arising
// under or in connection with these materials, including for any direct, or any
// indirect, special, incidental, or consequential loss or damage (including loss
// of data, profits, goodwill, or any type of loss or damage suffered as a result
// of any action brought by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-safe, or for use in any
// application requiring fail-safe performance, such as life-support or safety
// devices or systems, Class III medical devices, nuclear facilities, applications
// related to the deployment of airbags, or any other applications that could lead
// to death, personal injury, or severe property or environmental damage
// (individually and collectively, "Critical Applications"). Customer assumes the
// sole risk and liability of any use of Xilinx products in Critical Applications,
// subject only to applicable laws and regulations governing limitations on product
// liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.
//
//////////////////////////////////////////////////////////////////////////////////
// 
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: 2.10
//  \   \         Filename: kcuart_tx.v
//  /   /         Date Last Modified:  March 19 2010
// /___/   /\     Date Created: October 14 2002
// \   \  /  \
//  \___\/\___\
//
// Device: Xilinx
// Purpose: Constant (K) Compact UART Transmitter
//          8 data bits, no parity, 1 stop bit
//
// NOTE : This macro is intended to be attached to bbfifo_16x8 and operation requires 
//        the interaction of signals to and from that FIFO buffer to work correctly. 
//
// This module was made for use with Spartan-3 Generation Devices and is also ideally 
// suited for use with Virtex-II(PRO) and Virtex-4 devices. Will also work in Virtex-5, 
// Virtex-6 and Spartan-6 devices but it is not specifically optimised for these 
// architectures.
//
//
// Contact: e-mail  picoblaze@xilinx.com
//
//
// Revision History:
//  Rev 1.00 - kc  - Start of design entry in VHDL,  October 14 2002.
//  Rev 1.01 - sus - Converted to verilog,  August 4 2004.
//  Rev 1.02 - njs - Synplicity attributes added,  September 6 2004.
//  Rev 1.03 - njs - Fixed simulation attributes from string to hex, November 2 2004.
//  Rev 1.04 - njs - INIT values specified using Verilog 2001 format,  June 7 2005.
//  Rev 1.03 - kc  - Minor format changes,  January 17 2007.
//  Rev 2.10 - njs - March 19 2010.
//                   The Verilog coding style adjusted to be compatible with XST provided  
//                   as part of the ISE v12.1i tools when targeting Spartan-6 and Virtex-6 
//                   devices. No functional changes.
//
//////////////////////////////////////////////////////////////////////////////////
//
// Format of this file.
//
// The module defines the implementation of the logic using Xilinx primitives.
// These ensure predictable synthesis results and maximise the density of the  
// implementation. The Unisim Library is used to define Xilinx primitives. 
// The source can be viewed at %XILINX%\verilog\src\unisims.
// 
//////////////////////////////////////////////////////////////////////////////////
//

`timescale 1 ps / 1ps

module kcuart_tx (
input   [7:0] data_in,
input         send_character,
input         en_16_x_baud,
output        serial_out,
output        Tx_complete,
input         clk );

//
//////////////////////////////////////////////////////////////////////////////////
//
// Signals used in KCUART_TX
//
//////////////////////////////////////////////////////////////////////////////////
//

wire 	     data_01;
wire 	     data_23;
wire 	     data_45;
wire 	     data_67;
wire 	     data_0123;
wire 	     data_4567;
wire 	     data_01234567;
wire [2:0] bit_select;
wire [2:0] next_count;
wire [2:0] mask_count;
wire [2:0] mask_count_carry;
wire [2:0] count_carry;
wire 	     ready_to_start;
wire 	     decode_Tx_start;
wire 	     Tx_start;
wire 	     decode_Tx_run;
wire 	     Tx_run;
wire 	     decode_hot_state;
wire 	     hot_state;
wire 	     hot_delay;
wire 	     Tx_bit;
wire 	     decode_Tx_stop;
wire 	     Tx_stop;
wire 	     decode_Tx_complete;

//
////////////////////////////////////////////////////////////////////////////////////
//
// Start of KCUART_TX circuit description
//
////////////////////////////////////////////////////////////////////////////////////
//	

// 8 to 1 multiplexer to convert parallel data to serial

LUT4 	#(
.INIT	(16'hE4FF))	
mux1_lut(
.I0	(bit_select[0]),
.I1	(data_in[0]),
.I2	(data_in[1]),
.I3	(Tx_run),
.O	(data_01)) ;

LUT4 	#(
.INIT	(16'hE4FF))	
mux2_lut (
.I0	(bit_select[0]),
.I1	(data_in[2]),
.I2	(data_in[3]),
.I3	(Tx_run),
.O	(data_23) ) ;

LUT4 	#(
.INIT	(16'hE4FF))
mux3_lut(
.I0	(bit_select[0]),
.I1	(data_in[4]),
.I2	(data_in[5]),
.I3	(Tx_run),
.O	(data_45) ) ;

LUT4 	#(
.INIT	(16'hE4FF))	
mux4_lut(
.I0	(bit_select[0]),
.I1	(data_in[6]),
.I2	(data_in[7]),
.I3	(Tx_run),
.O	(data_67) ) ;

MUXF5 mux5_muxf5(		
.I1	(data_23),
.I0	(data_01),
.S	(bit_select[1]),
.O	(data_0123) );

MUXF5 mux6_muxf5( 		
.I1	(data_67),
.I0	(data_45),
.S	(bit_select[1]),
.O	(data_4567) );

MUXF6 mux7_muxf6(		
.I1	(data_4567),
.I0	(data_0123),
.S	(bit_select[2]),
.O	(data_01234567) );

// Register serial output and force start and stop bits

FDRS pipeline_serial(   
.D(data_01234567),
.Q(serial_out),
.R(Tx_start),
.S(Tx_stop),
.C(clk) ) ;

// 3-bit counter
// Counter is clock enabled by en_16_x_baud
// Counter will be reset when 'Tx_start' is active
// Counter will increment when Tx_bit is active
// Tx_run must be active to count
// count_carry[2] indicates when terminal count [7] is reached and Tx_bit=1 (ie overflow)

genvar i ;
generate
for (i = 0 ; i <= 2 ; i = i + 1) begin : count_width_loop

FDRE 	register_bit(
.D	(next_count[i]),
.Q	(bit_select[i]),
.CE	(en_16_x_baud),
.R	(Tx_start),
.C	(clk) );

LUT2 	#(
.INIT	(4'h8))		
count_lut(
.I0	(bit_select[i]),
.I1	(Tx_run),
.O	(mask_count[i]) ) ;

MULT_AND mask_and(
.I0	(bit_select[i]),
.I1	(Tx_run),
.LO	(mask_count_carry[i]) );

if (i == 0) begin : lsb_count

MUXCY count_muxcy( 
.DI	(mask_count_carry[i]),
.CI	(Tx_bit),
.S	(mask_count[i]),
.O	(count_carry[i]) );
       
XORCY count_xor(
.LI	(mask_count[i]),
.CI	(Tx_bit),
.O	(next_count[i]) );
 
end
if (i > 0) begin : upper_count

MUXCY count_muxcy( 	
.DI	(mask_count_carry[i]),
.CI	(count_carry[i-1]),
.S	(mask_count[i]),
.O	(count_carry[i]) );
       
XORCY count_xor( 	
.LI	(mask_count[i]),
.CI	(count_carry[i-1]),
.O	(next_count[i]) );

end
end
endgenerate

// Ready to start decode

LUT3 	#(
.INIT	(8'h10))		
ready_lut( 	
.I0	(Tx_run),
.I1	(Tx_start),
.I2	(send_character),
.O	(ready_to_start ) ) ;

// Start bit enable

LUT4 	#(
.INIT	(16'h0190))	
start_lut( 	
.I0	(Tx_bit),
.I1	(Tx_stop),
.I2	(ready_to_start),
.I3	(Tx_start),
.O	(decode_Tx_start ) ) ;

FDE Tx_start_reg(	
.D	(decode_Tx_start),
.Q(	Tx_start),
.CE	(en_16_x_baud),
.C	(clk) );


// Run bit enable
LUT4 	#(
.INIT	(16'h1540))	
run_lut( 	
.I0	(count_carry[2]),
.I1	(Tx_bit),
.I2	(Tx_start),
.I3	(Tx_run),
.O	(decode_Tx_run ) ) ;

FDE Tx_run_reg(	
.D	(decode_Tx_run),
.Q	(Tx_run),
.CE	(en_16_x_baud),
.C	(clk) );

// Bit rate enable

LUT3 	#(
.INIT	(8'h94))		
hot_state_lut(	
.I0	(Tx_stop),
.I1	(ready_to_start),
.I2	(Tx_bit),
.O	(decode_hot_state) ) ;

FDE 	hot_state_reg(	
.D	(decode_hot_state),
.Q	(hot_state),
.CE	(en_16_x_baud),
.C	(clk) );

SRL16E 	#(
.INIT	(16'h0000))	
delay14_srl(	
.D	(hot_state),
.CE	(en_16_x_baud),
.CLK	(clk),
.A0	(1'b1),
.A1	(1'b0),
.A2	(1'b1),
.A3	(1'b1),
.Q	(hot_delay) ) ;

FDE 	Tx_bit_reg(	
.D	(hot_delay),
.Q	(Tx_bit),
.CE	(en_16_x_baud),
.C	(clk) );

// Stop bit enable
LUT4 	#(
.INIT	(16'h0180))	
stop_lut(	
.I0	(Tx_bit),
.I1	(Tx_run),
.I2	(count_carry[2]),
.I3	(Tx_stop),	  
.O	(decode_Tx_stop) ) ;

FDE 	Tx_stop_reg( 	    
.D	(decode_Tx_stop),
.Q	(Tx_stop),
.CE	(en_16_x_baud),
.C	(clk) );

// Tx_complete strobe

LUT2 	#(
.INIT	(4'h8))		
complete_lut( 	    
.I0	(count_carry[2]),
.I1	(en_16_x_baud),
.O	(decode_Tx_complete) ) ;

FD 	Tx_complete_reg( 	     
.D	(decode_Tx_complete),
.Q	(Tx_complete),
.C	(clk) );

endmodule

//
////////////////////////////////////////////////////////////////////////////////////
//
// END OF FILE KCUART_TX.V
//
////////////////////////////////////////////////////////////////////////////////////
//

