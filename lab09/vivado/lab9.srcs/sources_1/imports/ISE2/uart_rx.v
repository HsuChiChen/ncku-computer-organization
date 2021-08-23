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
//  \   \         Filename: uart_rx.v
//  /   /         Date Last Modified:  March 19 2010
// /___/   /\     Date Created: October 16 2002
// \   \  /  \
//  \___\/\___\
//
// Device: Xilinx
// Purpose: UART Receiver with integral 16 byte FIFO buffer
//          8 bit, no parity, 1 stop bit
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
//  Rev 1.02 - njs - Converted to verilog 2001,  February 10 2006.
//  Rev 1.03 - kc  - Minor format changes,  January 17 2007.
//  Rev 2.10 - njs - March 19 2010.
//                   Format and text changes consistent with sub-modules.
//                   No functional changes.
//
//////////////////////////////////////////////////////////////////////////////////
//

`timescale 1 ps / 1ps
 
module uart_rx (
input        serial_in,
output [7:0] data_out,
input        read_buffer,
input        reset_buffer,
input        en_16_x_baud,
output       buffer_data_present,
output       buffer_full,
output       buffer_half_full,
input        clk);

//
//////////////////////////////////////////////////////////////////////////////////
//
// Signals used in UART_RX
//
//////////////////////////////////////////////////////////////////////////////////
//

wire [7:0] uart_data_out;
wire       fifo_write;

//
//////////////////////////////////////////////////////////////////////////////////
//
// Start of UART_RX circuit description
//
//////////////////////////////////////////////////////////////////////////////////
//	

kcuart_rx kcuart (
	.serial_in	(serial_in),
    	.data_out	(uart_data_out),
    	.data_strobe	(fifo_write),
    	.en_16_x_baud	(en_16_x_baud),
    	.clk		(clk));

bbfifo_16x8 buf_0 (
	.data_in	(uart_data_out),
    	.data_out	(data_out),
    	.reset		(reset_buffer),
    	.write		(fifo_write),
    	.read		(read_buffer),
    	.full		(buffer_full),
    	.half_full	(buffer_half_full),
    	.data_present	(buffer_data_present),
    	.clk		(clk));

endmodule

//
//////////////////////////////////////////////////////////////////////////////////
//
// END OF FILE UART_RX.V
//
//////////////////////////////////////////////////////////////////////////////////
//
