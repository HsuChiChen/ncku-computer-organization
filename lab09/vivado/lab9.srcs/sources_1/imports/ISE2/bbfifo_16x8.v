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
//  \   \         Filename: bbfifo_16x8.v
//  /   /         Date Last Modified:  March 19 2010
// /___/   /\     Date Created: October 14 2002
// \   \  /  \
//  \___\/\___\
//
// Device:	Xilinx
// Purpose: 'Bucket Brigade' FIFO, 16 deep, 8-bit data
//
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
//  Rev 1.03 - njs - defparam values corrected,  December 1 2005.
//  Rev 1.04 - njs - INIT values specified using Verilog 2001 format,  July 6 2005.
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

module bbfifo_16x8(
input  [7:0] data_in,
output [7:0] data_out,
input        reset,
input        write,
input        read,
output       full,
output       half_full,
output       data_present,
input        clk);

//	 
//////////////////////////////////////////////////////////////////////////////////
//
// Signals used in BBFIFO_16x8
//
//////////////////////////////////////////////////////////////////////////////////
//

wire [3:0] pointer;
wire [3:0] next_count;
wire [3:0] half_count;
wire [2:0] count_carry;

wire       pointer_zero;
wire       pointer_full;
wire 	     decode_data_present;
wire 	     data_present_int;
wire 	     valid_write;

//
//////////////////////////////////////////////////////////////////////////////////
//
// Start of BBFIFO_16x8 circuit description
//
//////////////////////////////////////////////////////////////////////////////////
//
	
// SRL16E data storage

genvar i ;
generate
for (i = 0; i <= 7; i = i + 1)
begin : data_width_loop
   
SRL16E #(
.INIT	(16'h0000))	
data_srl (   	
.D	(data_in[i]),
.CE	(valid_write),
.CLK	(clk),
.A0	(pointer[0]),
.A1	(pointer[1]),
.A2	(pointer[2]),
.A3	(pointer[3]),
.Q	(data_out[i])) ;

end
endgenerate

// 4-bit counter to act as data pointer
// Counter is clock enabled by 'data_present'
// Counter will be reset when 'reset' is active
// Counter will increment when 'valid_write' is active

generate
for (i = 0; i <= 3; i = i + 1)
begin : count_width_loop

FDRE register_bit( 	
.D	(next_count[i]),
.Q	(pointer[i]),
.CE	(data_present_int),
.R	(reset),
.C	(clk));

LUT4 	#(
.INIT	(16'h6606))	
count_lut( 	
.I0	(pointer[i]),
.I1	(read),
.I2	(pointer_zero),
.I3	(write),
.O	(half_count[i])) ;

if (i == 0) begin : lsb_count

MUXCY count_muxcy_0( 	
.DI	(pointer[i]),
.CI	(valid_write),
.S	(half_count[i]),
.O	(count_carry[i]) );
       
XORCY count_xor_0( 	
.LI	(half_count[i]),
.CI	(valid_write),
.O	(next_count[i]));

end

if (i > 0 && i < 3) begin : mid_count

MUXCY count_muxcy ( 	
.DI	(pointer[i]),
.CI	(count_carry[i-1]),
.S	(half_count[i]),
.O	(count_carry[i]));
       
XORCY count_xor( 	
.LI	(half_count[i]),
.CI	(count_carry[i-1]),
.O	(next_count[i]));

end

if (i == 3) begin : msb_count

XORCY count_xor( 	
.LI	(half_count[i]),
.CI	(count_carry[i-1]),
.O	(next_count[i]));

end
end
endgenerate

// Detect when pointer is zero and maximum

LUT4 	#(
.INIT	(16'h0001))	
zero_lut( 	
.I0	(pointer[0]),
.I1	(pointer[1]),
.I2	(pointer[2]),
.I3	(pointer[3]),
.O	(pointer_zero)) ;

LUT4 	#(
.INIT	(16'h8000))	
full_lut( 	
.I0	(pointer[0]),
.I1	(pointer[1]),
.I2	(pointer[2]),
.I3	(pointer[3]),
.O	(pointer_full)) ;

// Data Present status

LUT4 	#(
.INIT	(16'hBFA0))	
dp_lut( 	
.I0	(write),
.I1	(read),
.I2	(pointer_zero),
.I3	(data_present_int),
.O	(decode_data_present)) ;

FDR dp_flop( 	
.D	(decode_data_present),
.Q	(data_present_int),
.R	(reset),
.C	(clk));

// Valid write wire

LUT3 	#(
.INIT	(8'hC4))		
valid_lut( 	
.I0	(pointer_full),
.I1	(write),
.I2	(read),
.O	(valid_write)) ;

// assign internal wires to outputs

assign full = pointer_full;  
assign half_full = pointer[3];  
assign data_present = data_present_int;	 

endmodule

//
//////////////////////////////////////////////////////////////////////////////////
//
// END OF FILE BBFIFO_16x8.V
//
//////////////////////////////////////////////////////////////////////////////////
//

