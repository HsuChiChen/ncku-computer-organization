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
//  \   \         Filename: kcuart_rx.v
//  /   /         Date Last Modified:  March 19 2010
// /___/   /\     Date Created: October 16 2002
// \   \  /  \
//  \___\/\___\
//
// Device: Xilinx
// Purpose: Constant (K) Compact UART Receiver
//          8 data bits, no parity, 1 stop bit
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
//  Rev 1.00 - kc  - Start of design entry in VHDL,  October 16 2002.
//  Rev 1.01 - sus - Converted to verilog,  August 4 2004.
//  Rev 1.02 - njs - Synplicity attributes added,  September 6 2004.
//  Rev 1.03 - njs - defparam values corrected, December 1 2005
//  Rev 1.04 - njs - INIT values specified using Verilog 2001 format,  June 7 2005.
//  Rev 1.21 - kc  - Minor format changes,  January 17 2007.
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

module kcuart_rx (
input        serial_in,
output [7:0] data_out,
output       data_strobe,
input        en_16_x_baud,
input        clk);

//
//////////////////////////////////////////////////////////////////////////////////
//
// Signals used in KCUART_RX
//
//////////////////////////////////////////////////////////////////////////////////
//

wire 	     sync_serial ;
wire       stop_bit ;
wire [7:0] data_int ;
wire [7:0] data_delay ;
wire 	     start_delay ;
wire 	     start_bit ;
wire 	     edge_delay ;
wire 	     start_edge ;
wire 	     decode_valid_char ;
wire 	     valid_char ;
wire 	     decode_purge ;
wire 	     purge ;
wire [8:0] valid_srl_delay ;
wire [8:0] valid_reg_delay ;
wire 	     decode_data_strobe ;

//
////////////////////////////////////////////////////////////////////////////////////
//
// Start of KCUART_RX circuit description
//
////////////////////////////////////////////////////////////////////////////////////
//	

// Synchronise input serial data to system clock

FD sync_reg(
.D	(serial_in),
.Q	(sync_serial),
.C	(clk) );

FD stop_reg( 	
.D	(sync_serial),
.Q	(stop_bit),
.C	(clk) );


// Data delays to capture data at 16 time baud rate
// Each SRL16E is followed by a flip-flop for best timing

genvar i ;
generate
for (i = 0; i <= 7; i = i + 1)
begin : data_loop
   
if (i < 7) begin : lsbs

SRL16E #(
.INIT	(16'h0000))	
delay15_srl(  	
.D	(data_int[i+1]),
.CE	(en_16_x_baud),
.CLK	(clk),
.A0	(1'b0),
.A1	(1'b1),
.A2	(1'b1),
.A3	(1'b1),
.Q	(data_delay[i])) ;

end
if (i == 7) begin : msb

SRL16E #(
.INIT	(16'h0000))	
delay15_srl(   	
.D	(stop_bit),
.CE	(en_16_x_baud),
.CLK	(clk),
.A0	(1'b0),
.A1	(1'b1),
.A2	(1'b1),
.A3	(1'b1),
.Q	(data_delay[i])) ;

end
   
FDE data_reg_0(
.D	(data_delay[i]),
.Q	(data_int[i]),
.CE	(en_16_x_baud),
.C	(clk) );

end
endgenerate

// Assign internal wires to outputs
assign data_out = data_int;
 
// Data delays to capture start bit at 16 time baud rate

SRL16E #(
.INIT	(16'h0000))	
start_srl(
.D	(data_int[0]),
.CE	(en_16_x_baud),
.CLK	(clk),
.A0	(1'b0),
.A1	(1'b1),
.A2	(1'b1),
.A3	(1'b1),
.Q	(start_delay)) ;

FDE start_reg(
.D	(start_delay),
.Q	(start_bit),
.CE	(en_16_x_baud),
.C	(clk) );

// Data delays to capture start bit leading edge at 16 time baud rate
// Delay ensures data is captured at mid-bit position

SRL16E #(
.INIT	(16'h0000))	
edge_srl(
.D	(start_bit),
.CE	(en_16_x_baud),
.CLK	(clk),
.A0	(1'b1),
.A1	(1'b0),
.A2	(1'b1),
.A3	(1'b0),
.Q	(edge_delay)) ;

FDE edge_reg(
.D	(edge_delay),
.Q	(start_edge),
.CE	(en_16_x_baud),
.C	(clk));

// Detect a valid character 

LUT4 #(
.INIT	(16'h0040))	
valid_lut(
.I0	(purge),
.I1	(stop_bit),
.I2	(start_edge),
.I3	(edge_delay),
.O	(decode_valid_char)) ;  

FDE valid_reg(
.D	(decode_valid_char),
.Q	(valid_char),
.CE	(en_16_x_baud),
.C	(clk));

// Purge of data status 

LUT3 #(
.INIT	(8'h54))		
purge_lut(
.I0	(valid_reg_delay[8]),
.I1	(valid_char),
.I2	(purge),
.O	(decode_purge)) ;
				   

FDE purge_reg(
.D	(decode_purge),
.Q	(purge),
.CE	(en_16_x_baud),
.C	(clk));

// Delay of valid_char pulse of length equivalent to the time taken 
// to purge data shift register of all data which has been used.
// Requires 9x16 + 8 delays which is achieved by packing of SRL16E with 
// 16 delays and utilising the dedicated flip flop in each of 8 stages.

generate
for (i = 0 ; i <= 8 ; i = i + 1)
begin : valid_loop

if (i == 0) begin : lsb

SRL16E #(
.INIT	(16'h0000))	
delay16_srl(
.D	(valid_char),
.CE	(en_16_x_baud),
.CLK	(clk),
.A0	(1'b0),
.A1	(1'b1),
.A2	(1'b1),
.A3	(1'b1),
.Q	(valid_srl_delay[i])) ;

end
if (i > 0) begin : msbs
  
SRL16E #(
.INIT	(16'h0000))	
delay16_srl(
.D	(valid_reg_delay[i-1]),
.CE	(en_16_x_baud),
.CLK	(clk),
.A0	(1'b1),
.A1	(1'b1),
.A2	(1'b1),
.A3	(1'b1),
.Q	(valid_srl_delay[i])) ;

end
   
FDE data_reg(
.D	(valid_srl_delay[i]),
.Q	(valid_reg_delay[i]),
.CE	(en_16_x_baud),
.C	(clk));

end
endgenerate

// Form data strobe

LUT2 #(
.INIT	(4'h8))	
strobe_lut( 	
.I0	(valid_char),
.I1	(en_16_x_baud),
.O	(decode_data_strobe)) ;

FD strobe_reg(
.D	(decode_data_strobe),
.Q	(data_strobe),
.C	(clk));

endmodule

//
////////////////////////////////////////////////////////////////////////////////////
//
// END OF FILE KCUART_RX.V
//
////////////////////////////////////////////////////////////////////////////////////
//
