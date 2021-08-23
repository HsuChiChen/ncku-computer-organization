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
//  \   \         Filename: kcpsm3.v
//  /   /         Date Last Modified: March 19 2010
// /___/   /\     Date First Created: May 19 2003
// \   \  /  \
//  \___\/\___\
//
// Device: Xilinx
// Purpose: PicoBlaze
//
// Constant (K) Coded Programmable State Machine for Spartan-3 Generation Devices.
// Also suitable for use with Virtex-II(PRO) and Virtex-4 devices. Will also work  
// in Virtex-5, Virtex-6 and Spartan-6 devices but it is not specifically optimised 
// for these architectures
//
// Includes additional code for enhanced verilog simulation.
//
// Instruction disassembly concept inspired by the work of Prof. Dr.-Ing. Bernhard Lang.
// University of Applied Sciences, Osnabrueck, Germany.
//
// Contact: e-mail  picoblaze@xilinx.com
//
// Revision History:
//    Rev 1.00 - kc -  Start of design entry,  May 19 2003.
//    Rev 1.20 - njs - Converted to verilog,  July 20 2004.
// 		           Verilog version creation supported by Chip Lukes,
//		           Advanced Electronic Designs, Inc.
//		           www.aedbozeman.com, chip.lukes@aedmt.com
//	Rev 1.21 - sus - Added text to adhere to HDL standard, August 4 2004.
//	Rev 1.30 - njs - Updated as per VHDL version 1.30 August 5 2004.
//	Rev 1.31 - njs - General tidy-up re INIT statements to produce less warnings in XST.
//	Rev 1.40 - njs - Updated as per VHDL version 1.40 February 10 2006.
//                     Two LUT1 primitives replaced with LUT2 primitives but offering the 
//                     same  overall functionality. This change was made to avoid an annoying 
//                     issue with the way different synthesis and simulation tools expect the 
//                     INIT value for a LUT1 to be represented.   
//	Rev 2.10 - njs - March 19 2010.
//               kdc   Coding style adjusted to be compatible with XST provided as part  
//                     of the ISE v12.1i tools when targeting Spartan-6 and Virtex-6 
//                     devices. No functional changes.
//
//////////////////////////////////////////////////////////////////////////////////
//
// Format of this file.
// 
// This file contains the definition of KCPSM3 as one complete module This 'flat'
// approach has been adopted to decrease the time taken to load the module into 
// simulators and the synthesis process.
//
//
// The module defines the implementation of the logic using Xilinx primitives.
// These ensure predictable synthesis results and maximise the density of the  
// implementation. The Unisim Library is used to define Xilinx primitives. 
// The source can be viewed at %XILINX%\verilog\src\unisims.
// 
//////////////////////////////////////////////////////////////////////////////////
//

`timescale 1 ps / 1ps

module kcpsm3(
output  [9:0] address,
input  [17:0] instruction,
output  [7:0] port_id,
output        write_strobe,
output  [7:0] out_port,
output        read_strobe,
input   [7:0] in_port,
input	        interrupt,
output        interrupt_ack,
input	        reset,
input	        clk) ;

//
////////////////////////////////////////////////////////////////////////////////////
//
// Signals used in KCPSM3
//
////////////////////////////////////////////////////////////////////////////////////
//

// Fundamental control and decode signals

wire 		t_state ;
wire 		not_t_state ;
wire 		internal_reset ;
wire 		reset_delay ;
wire 		move_group ;
wire 		condition_met ;
wire 		normal_count ;
wire 		call_type ;
wire 		push_or_pop_type ;
wire 		valid_to_move ;

// Flag signals

wire 		flag_type ;
wire 		flag_write ;
wire 		flag_enable ;
wire 		zero_flag ;
wire 		sel_shadow_zero ;
wire 		low_zero ;
wire 		high_zero ;
wire 		low_zero_carry ;
wire 		high_zero_carry ;
wire 		zero_carry ;
wire 		zero_fast_route ;
wire 		low_parity ;
wire 		high_parity ;
wire 		parity_carry ;
wire 		parity ;
wire 		carry_flag ;
wire 		sel_parity ;
wire 		sel_arith_carry ;
wire 		sel_shift_carry ;
wire 		sel_shadow_carry ;
wire 	[3:0]	sel_carry ;
wire 		carry_fast_route ;

// Interrupt signals

wire 		active_interrupt ;
wire 		int_pulse ;
wire 		clean_int ;
wire 		shadow_carry ;
wire 		shadow_zero ;
wire 		int_enable ;
wire 		int_update_enable ;
wire 		int_enable_value ;
wire 		interrupt_ack_internal ;

// Program Counter signals

wire 	[9:0]	pc ;
wire 	[9:0]	pc_vector ;
wire 	[8:0]	pc_vector_carry ;
wire 	[9:0]	inc_pc_vector ;
wire 	[9:0]	pc_value ;
wire 	[8:0]	pc_value_carry ;
wire 	[9:0]	inc_pc_value ;
wire 		pc_enable ;

// Data Register signals

wire 	[7:0]	sx ;
wire 	[7:0]	sy ;
wire 		register_type ;
wire 		register_write ;
wire 		register_enable ;
wire 	[7:0]	second_operand ;

// Scratch Pad Memory signals

wire 	[7:0]	memory_data ;
wire 	[7:0]	store_data ;
wire 		memory_type ;
wire 		memory_write ;
wire 		memory_enable ;

// Stack signals

wire 	[9:0]	stack_pop_data ;
wire 	[9:0]	stack_ram_data ;
wire 	[4:0]	stack_address ;
wire 	[4:0]	half_stack_address ;
wire 	[3:0]	stack_address_carry ;
wire 	[4:0]	next_stack_address ;
wire 		stack_write_enable ;
wire 		not_active_interrupt ;

// ALU signals

wire 	[7:0]	logical_result ;
wire 	[7:0]	logical_value ;
wire 		sel_logical ;
wire 	[7:0]	shift_result ;
wire 	[7:0]	shift_value ;
wire 		sel_shift ;
wire 		high_shift_in ;
wire 		low_shift_in ;
wire 		shift_in ;
wire 		shift_carry ;
wire 		shift_carry_value ;
wire 	[7:0]	arith_result ;
wire 	[7:0]	arith_value ;
wire 	[7:0]	half_arith ;
wire 	[7:0]	arith_internal_carry ;
wire 		sel_arith_carry_in ;
wire 		arith_carry_in ;
wire 		invert_arith_carry ;
wire 		arith_carry_out ;
wire 		sel_arith ;
wire 		arith_carry ;

// ALU multiplexer signals

wire 		input_fetch_type ;
wire 		sel_group ;
wire 	[7:0]	alu_group ;
wire 	[7:0]	input_group ;
wire 	[7:0]	alu_result ;

// read and write strobes

wire 		io_initial_decode ;
wire 		write_active ;
wire 		read_active ;

//
////////////////////////////////////////////////////////////////////////////////////
//
// Start of KCPSM3 circuit description
//
////////////////////////////////////////////////////////////////////////////////////
//
// Fundamental Control
//
// Definition of T-state and internal reset
//
////////////////////////////////////////////////////////////////////////////////////
//
LUT2 	#(
.INIT	(4'h1)) 
t_state_lut(
.I0	(t_state),
.I1	(internal_reset),
.O	(not_t_state)) ;

FD 	toggle_flop (
.D	(not_t_state),
.Q	(t_state),
.C	(clk));

FDS 	reset_flop1 (
.D	(1'b0),
.Q	(reset_delay),
.S	(reset),
.C	(clk));

FDS 	reset_flop2 (
.D	(reset_delay),
.Q	(internal_reset),
.S	(reset),
.C	(clk));
//
////////////////////////////////////////////////////////////////////////////////////
//
// Interrupt input logic, Interrupt enable and shadow Flags.
//
// Captures interrupt input and enables the shadow flags.
// Decodes instructions which set and reset the interrupt enable flip-flop.
//
////////////////////////////////////////////////////////////////////////////////////
//
// Interrupt capture

FDR 	int_capture_flop (
.D	(interrupt),
.Q	(clean_int),
.R	(internal_reset),
.C	(clk));

LUT4 	#(
.INIT	(16'h0080))	
int_pulse_lut(
.I0	(t_state),
.I1	(clean_int),
.I2	(int_enable),
.I3	(active_interrupt),
.O	(int_pulse )) ;

FDR 	int_flop (
.D	(int_pulse),
.Q	(active_interrupt),
.R	(internal_reset),
.C	(clk));

FD 	ack_flop (
.D	(active_interrupt),
.Q	(interrupt_ack_internal),
.C	(clk));

assign interrupt_ack = interrupt_ack_internal ;

// Shadow flags

FDE 	shadow_carry_flop (
.D	(carry_flag),
.Q	(shadow_carry),
.CE	(active_interrupt),
.C	(clk));

FDE 	shadow_zero_flop (
.D	(zero_flag),
.Q	(shadow_zero),
.CE	(active_interrupt),
.C	(clk));

// Decode instructions that set or reset interrupt enable

LUT4 	#(
.INIT	(16'hEAAA))	
int_update_lut(
.I0	(active_interrupt),
.I1	(instruction[15]),
 .I2	(instruction[16]),
 .I3	(instruction[17]),
 .O	(int_update_enable)) ;

LUT3 	#(
.INIT	(8'h04))		
int_value_lut (
.I0	(active_interrupt),
.I1	(instruction[0]),
.I2	(interrupt_ack_internal),
.O	(int_enable_value )) ;

FDRE 	int_enable_flop (
.D	(int_enable_value),
.Q	(int_enable),
.CE	(int_update_enable),
.R	(internal_reset),
.C	(clk));
//
////////////////////////////////////////////////////////////////////////////////////
//
// Decodes for the control of the program counter and CALL/RETURN stack
//
////////////////////////////////////////////////////////////////////////////////////
//
LUT4 	#(
.INIT	(16'h7400))	
move_group_lut (
.I0	(instruction[14]),
.I1	(instruction[15]),
.I2	(instruction[16]),
.I3	(instruction[17]),
.O	(move_group)) ;

LUT4 	#(
.INIT	(16'h5A3C))	
condition_met_lut (
.I0	(carry_flag),
.I1	(zero_flag),
.I2	(instruction[10]),
.I3	(instruction[11]),
.O	(condition_met)) ;

LUT3 	#(
.INIT	(8'h2F))		
normal_count_lut (
.I0	(instruction[12]),
.I1	(condition_met),
.I2	(move_group),
.O	(normal_count )) ;

LUT4 	#(
.INIT	(16'h1000))	
call_type_lut (
.I0	(instruction[14]),
.I1	(instruction[15]),
.I2	(instruction[16]),
.I3	(instruction[17]),
.O	(call_type )) ;

LUT4 	#(
.INIT	(16'h5400))	
push_pop_lut (
.I0	(instruction[14]),
.I1	(instruction[15]),
.I2	(instruction[16]),
.I3	(instruction[17]),
.O	(push_or_pop_type)) ;

LUT2 	#(
.INIT	(4'hD))		
valid_move_lut (
.I0	(instruction[12]),
.I1	(condition_met),
.O	(valid_to_move )) ;
//
////////////////////////////////////////////////////////////////////////////////////
//
// The ZERO and CARRY Flags
//
////////////////////////////////////////////////////////////////////////////////////
//
// Enable for flags

LUT4 	#(
.INIT	(16'h41FC))	
flag_type_lut (
.I0	(instruction[14]),
.I1	(instruction[15]),
.I2	(instruction[16]),
.I3	(instruction[17]),
.O	(flag_type )) ;

FD 	flag_write_flop (
.D	(flag_type),
.Q	(flag_write),
.C	(clk));

LUT2 	#(
.INIT	(4'h8))		
flag_enable_lut (
.I0	(t_state),
.I1	(flag_write),
.O	(flag_enable)) ;

// Zero Flag

LUT4 	#(
.INIT	(16'h0001))	
low_zero_lut (
.I0	(alu_result[0]),
.I1	(alu_result[1]),
.I2	(alu_result[2]),
.I3	(alu_result[3]),
.O	(low_zero )) ;

LUT4 	#(
.INIT	(16'h0001))	
high_zero_lut (
.I0	(alu_result[4]),
.I1	(alu_result[5]),
.I2	(alu_result[6]),
.I3	(alu_result[7]),
.O	(high_zero)) ;

MUXCY 	low_zero_muxcy (
.DI	(1'b0),
.CI	(1'b1),
.S	(low_zero),
.O	(low_zero_carry));

MUXCY 	high_zero_cymux (
.DI	(1'b0),
.CI	(low_zero_carry),
.S	(high_zero),
.O	(high_zero_carry));

LUT3 	#(
.INIT	(8'h3F))		
sel_shadow_zero_lut (
.I0	(shadow_zero),
.I1	(instruction[16]),
.I2	(instruction[17]),
.O	(sel_shadow_zero )) ;

MUXCY zero_cymux (
.DI	(shadow_zero),
.CI	(high_zero_carry),
.S	(sel_shadow_zero),
.O	(zero_carry ));

XORCY zero_xor(
.LI	(1'b0),
.CI	(zero_carry),
.O	(zero_fast_route));

FDRE zero_flag_flop (
.D	(zero_fast_route),
.Q	(zero_flag),
.CE	(flag_enable),
.R	(internal_reset),
.C	(clk));

// Parity detection

LUT4 	#(
.INIT	(16'h6996))	
low_parity_lut (
.I0	(logical_result[0]),
.I1	(logical_result[1]),
.I2	(logical_result[2]),
.I3	(logical_result[3]),
.O	(low_parity )) ;

LUT4 	#(
.INIT	(16'h6996))	
high_parity_lut (
.I0	(logical_result[4]),
.I1	(logical_result[5]),
.I2	(logical_result[6]),
.I3	(logical_result[7]),
.O	(high_parity )) ;

MUXCY parity_muxcy (
.DI	(1'b0),
.CI	(1'b1),
.S	(low_parity),
.O	(parity_carry) );

XORCY parity_xor (
.LI	(high_parity),
.CI	(parity_carry),
.O	(parity));

// CARRY flag selection

LUT4 	#(
.INIT	(16'hF3FF))	
sel_parity_lut (
.I0	(parity),
.I1	(instruction[13]),
.I2	(instruction[15]),
.I3	(instruction[16]),
.O	(sel_parity )) ;

LUT3 #(
.INIT	(8'hF3))		
sel_arith_carry_lut (
.I0	(arith_carry),
.I1	(instruction[16]),
.I2	(instruction[17]),
.O	(sel_arith_carry )) ;

LUT2 	#(
.INIT	(4'hC))		
sel_shift_carry_lut (
.I0	(shift_carry),
.I1	(instruction[15]),
.O	(sel_shift_carry )) ;

LUT2 	#(
.INIT	(4'h3))		
sel_shadow_carry_lut (
.I0	(shadow_carry),
.I1	(instruction[17]),
.O	(sel_shadow_carry )) ;

MUXCY sel_shadow_muxcy (
.DI	(shadow_carry),
.CI	(1'b0),
.S	(sel_shadow_carry),
.O	(sel_carry[0]) );

MUXCY sel_shift_muxcy (
.DI	(shift_carry),
.CI	(sel_carry[0]),
.S	(sel_shift_carry),
.O	(sel_carry[1]) );

MUXCY sel_arith_muxcy (
.DI	(arith_carry),
.CI	(sel_carry[1]),
.S	(sel_arith_carry),
.O	(sel_carry[2]) );

MUXCY sel_parity_muxcy (
.DI	(parity),
.CI	(sel_carry[2]),
.S	(sel_parity),
.O	(sel_carry[3]) );

XORCY carry_xor(
.LI	(1'b0),
.CI	(sel_carry[3]),
.O	(carry_fast_route));

FDRE carry_flag_flop (
.D	(carry_fast_route),
.Q	(carry_flag),
.CE	(flag_enable),
.R	(internal_reset),
.C	(clk));
//
////////////////////////////////////////////////////////////////////////////////////
//
// The Program Counter
//
// Definition of a 10-bit counter which can be loaded from two sources.
//
////////////////////////////////////////////////////////////////////////////////////
//

INV invert_enable(// Inverter should be implemented in the CE to flip flops
.I	(t_state),
.O	(pc_enable));

genvar i ;
generate
for (i = 0 ; i <= 9 ; i = i+1)
begin : pc_loop

FDRSE register_bit (
.D	(inc_pc_value[i]),
.Q	(pc[i]),
.R	(internal_reset),
.S	(active_interrupt),
.CE	(pc_enable),
.C	(clk));

LUT3 	#(
.INIT	(8'hE4))		
vector_select_mux (
.I0	(instruction[15]),
.I1	(instruction[i]),
.I2	(stack_pop_data[i]),
.O	(pc_vector[i])) ;

LUT3 	#(
.INIT	(8'hE4))		
value_select_mux(
.I0	(normal_count),
.I1	(inc_pc_vector[i]),
.I2	(pc[i]),
.O	(pc_value[i])) ;

if (i == 0) begin : pc_lsb_carry

MUXCY pc_vector_muxcy (
.DI	(1'b0),
.CI	(instruction[13]),
.S	(pc_vector[i]),
.O	(pc_vector_carry[i]));

XORCY pc_vector_xor (
.LI	(pc_vector[i]),
.CI	(instruction[13]),
.O	(inc_pc_vector[i]));

MUXCY pc_value_muxcy (
.DI	(1'b0),
.CI	(normal_count),
.S	(pc_value[i]),
.O	(pc_value_carry[i]));

XORCY pc_value_xor (
.LI	(pc_value[i]),
.CI	(normal_count),
.O	(inc_pc_value[i]));

end
if (i > 0 && i < 9) begin : pc_mid_carry

MUXCY pc_vector_muxcy (
.DI	(1'b0),
.CI	(pc_vector_carry[i-1]),
.S	(pc_vector[i]),
.O	(pc_vector_carry[i]));

XORCY pc_vector_xor (
.LI	(pc_vector[i]),
.CI	(pc_vector_carry[i-1]),
.O	(inc_pc_vector[i]));

MUXCY pc_value_muxcy (
.DI	(1'b0),
.CI	(pc_value_carry[i-1]),
.S	(pc_value[i]),
.O	(pc_value_carry[i]));

XORCY pc_value_xor (
.LI	(pc_value[i]),
.CI	(pc_value_carry[i-1]),
.O	(inc_pc_value[i]));

end

if (i == 9) begin : pc_msb_carry

XORCY pc_vector_xor (
.LI	(pc_vector[i]),
.CI	(pc_vector_carry[i-1]),
.O	(inc_pc_vector[i]));

XORCY pc_value_xor (
.LI	(pc_value[i]),
.CI	(pc_value_carry[i-1]),
.O	(inc_pc_value[i]));

end
end
endgenerate

assign address = pc ;

//
////////////////////////////////////////////////////////////////////////////////////
//
// Register Bank and second operand selection.
//
// Definition of an 8-bit dual port RAM with 16 locations
// including write enable decode.
//
// Outputs are assigned to PORT_ID and OUT_PORT.
//
////////////////////////////////////////////////////////////////////////////////////
//
// Forming decode signal

LUT4 	#(
.INIT	(16'h0145))	
register_type_lut (
.I0	(active_interrupt),
.I1	(instruction[15]),
.I2	(instruction[16]),
.I3	(instruction[17]),
.O	(register_type )) ;

FD register_write_flop (
.D	(register_type),
.Q	(register_write),
.C	(clk));

LUT2 	#(
.INIT	(4'h8))  	
register_enable_lut (
.I0	(t_state),
.I1	(register_write),
.O	(register_enable)) ;

generate
for (i = 0; i <= 7; i = i+1)
begin : reg_loop

RAM16X1D #(
.INIT	(16'h0000))	
reg_loop_register_bit(
.D	(alu_result[i]),
.WE	(register_enable),
.WCLK	(clk),
.A0	(instruction[8]),
.A1	(instruction[9]),
.A2	(instruction[10]),
.A3	(instruction[11]),
.DPRA0	(instruction[4]),
.DPRA1	(instruction[5]),
.DPRA2	(instruction[6]),
.DPRA3	(instruction[7]),
.SPO	(sx[i]),
.DPO	(sy[i])) ;

LUT3 	#(
.INIT	(8'hE4))		
operand_select_mux(
.I0	(instruction[12]),
.I1	(instruction[i]),
.I2	(sy[i]),
.O	(second_operand[i])) ;

end
endgenerate

assign out_port = sx;
assign port_id = second_operand;
//
////////////////////////////////////////////////////////////////////////////////////
//
// Store Memory
//
// Definition of an 8-bit single port RAM with 64 locations
// including write enable decode.
//
////////////////////////////////////////////////////////////////////////////////////
//
// Forming decode signal

LUT4 	#(
.INIT	(16'h0400))	
memory_type_lut (
.I0	(active_interrupt),
.I1	(instruction[15]),
.I2	(instruction[16]),
.I3	(instruction[17]),
.O	(memory_type )) ;

FD memory_write_flop (
.D	(memory_type),
.Q	(memory_write),
.C	(clk));

LUT4 	#(
.INIT	(16'h8000))	
memory_enable_lut (
.I0	(t_state),
.I1	(instruction[13]),
.I2	(instruction[14]),
.I3	(memory_write),
.O	(memory_enable )) ;

generate
for (i = 0; i <= 7; i = i + 1)
begin : store_loop

RAM64X1S #(
.INIT	(64'h0000000000000000))	
memory_bit (
.D	(sx[i]),
.WE	(memory_enable),
.WCLK	(clk),
.A0	(second_operand[0]),
.A1	(second_operand[1]),
.A2	(second_operand[2]),
.A3	(second_operand[3]),
.A4	(second_operand[4]),
.A5	(second_operand[5]),
.O	(memory_data[i])) ;

FD store_flop (
.D	(memory_data[i]),
.Q	(store_data[i]),
.C	(clk));

end
endgenerate

//
////////////////////////////////////////////////////////////////////////////////////
//
// Logical operations
//
// Definition of AND, OR, XOR and LOAD functions which also provides TEST.
// Includes pipeline stage used to form ALU multiplexer including decode.
//
////////////////////////////////////////////////////////////////////////////////////
//
LUT4 	#(
.INIT	(16'hFFE2))	
sel_logical_lut (
.I0	(instruction[14]),
.I1	(instruction[15]),
.I2	(instruction[16]),
.I3	(instruction[17]),
.O	(sel_logical)) ;

generate
for (i = 0; i <= 7; i = i + 1)
begin : logical_loop

LUT4 	#(
.INIT	(16'h6E8A))	
logical_lut (
.I0	(second_operand[i]),
.I1	(sx[i]),
.I2	(instruction[13]),
.I3	(instruction[14]),
.O	(logical_value[i])) ;

FDR logical_flop (
.D	(logical_value[i]),
.Q	(logical_result[i]),
.R	(sel_logical),
.C	(clk));

end
endgenerate

//
////////////////////////////////////////////////////////////////////////////////////
//
// Shift and Rotate operations
//
// Includes pipeline stage used to form ALU multiplexer including decode.
//
////////////////////////////////////////////////////////////////////////////////////
//
INV sel_shift_inv( 		// Inverter should be implemented in the reset to flip flops
.I	(instruction[17]),
.O	(sel_shift));

// Bit to input to shift register

LUT3 	#(
.INIT	(8'hE4))		
high_shift_in_lut (
.I0	(instruction[1]),
.I1	(sx[0]),
.I2	(instruction[0]),
.O	(high_shift_in )) ;

LUT3 	#(
.INIT	(8'hE4))		
low_shift_in_lut (
.I0	(instruction[1]),
.I1	(carry_flag),
.I2	(sx[7]),
.O	(low_shift_in)) ;

MUXF5 shift_in_muxf5 (
.I1	(high_shift_in),
.I0	(low_shift_in),
.S	(instruction[2]),
.O	(shift_in ));

// Forming shift carry signal

LUT3 	#(
.INIT	(8'hE4))		
shift_carry_lut (
.I0	(instruction[3]),
.I1	(sx[7]),
.I2	(sx[0]),
.O	(shift_carry_value )) ;

FD pipeline_bit (
.D	(shift_carry_value),
.Q	(shift_carry),
.C	(clk));

generate
for (i = 0 ; i <= 7 ; i = i + 1)
begin : shift_loop

if (i == 0) begin : lsb_shift

LUT3 	#(
.INIT	(8'hE4))		
shift_mux_lut (
.I0	(instruction[3]),
.I1	(shift_in),
.I2	(sx[i+1]),
.O	(shift_value[i])) ;

end
if (i > 0 && i < 7) begin : mid_shift

LUT3 	#(
.INIT	(8'hE4))		
shift_mux_lut (
.I0	(instruction[3]),
.I1	(sx[i-1]),
.I2	(sx[i+1]),
.O	(shift_value[i])) ;

end
if (i == 7) begin : msb_shift

LUT3 	#(
.INIT	(8'hE4))		
shift_mux_lut (
.I0	(instruction[3]),
.I1	(sx[i-1]),
.I2	(shift_in),
.O	(shift_value[i]) ) ;

end

FDR shift_flop (
.D	(shift_value[i]),
.Q	(shift_result[i]),
.R	(sel_shift),
.C	(clk));

end
endgenerate
//
////////////////////////////////////////////////////////////////////////////////////
//
// Arithmetic operations
//
// Definition of ADD, ADDCY, SUB and SUBCY functions which also provides COMPARE.
// Includes pipeline stage used to form ALU multiplexer including decode.
//
////////////////////////////////////////////////////////////////////////////////////
//
LUT3 	#(
.INIT	(8'h1F))		
sel_arith_lut (
.I0	(instruction[14]),
.I1	(instruction[15]),
.I2	(instruction[16]),
.O	(sel_arith)) ;

generate
for (i = 0 ; i <= 7 ; i = i + 1)
begin : arith_loop

if (i == 0) begin : lsb_arith

LUT3 	#(
.INIT	(8'h6C))		
arith_carry_in_lut (
.I0	(instruction[13]),
.I1	(instruction[14]),
.I2	(carry_flag),
.O	(sel_arith_carry_in )) ;

MUXCY arith_carry_in_muxcy (
.DI	(1'b0),
.CI	(1'b1),
.S	(sel_arith_carry_in),
.O	(arith_carry_in));

MUXCY arith_muxcy (
.DI	(sx[i]),
.CI	(arith_carry_in),
.S	(half_arith[i]),
.O	(arith_internal_carry[i]));

XORCY arith_xor (
.LI	(half_arith[i]),
.CI	(arith_carry_in),
.O	(arith_value[i]));

end
if (i > 0 && i < 7) begin : mid_arith

MUXCY arith_muxcy (
.DI	(sx[i]),
.CI	(arith_internal_carry[i-1]),
.S	(half_arith[i]),
.O	(arith_internal_carry[i]));

XORCY arith_xor (
.LI	(half_arith[i]),
.CI	(arith_internal_carry[i-1]),
.O	(arith_value[i]));

end
if (i == 7) begin : msb_arith

MUXCY arith_muxcy (
.DI	(sx[i]),
.CI	(arith_internal_carry[i-1]),
.S	(half_arith[i]),
.O	(arith_internal_carry[i]));

XORCY arith_xor (
.LI	(half_arith[i]),
.CI	(arith_internal_carry[i-1]),
.O	(arith_value[i]));

LUT2 	#(
.INIT	(4'h2))		
arith_carry_out_lut (
.I0	(instruction[14]),
.I1	(internal_reset),
.O	(invert_arith_carry )) ;

XORCY arith_carry_out_xor (
.LI	(invert_arith_carry),
.CI	(arith_internal_carry[i]),
.O	(arith_carry_out));

FDR arith_carry_flop (
.D	(arith_carry_out),
.Q	(arith_carry),
.R	(sel_arith),
.C	(clk));

end

LUT3 	#(
.INIT	(8'h96))		
arith_lut (
.I0	(sx[i]),
.I1	(second_operand[i]),
.I2	(instruction[14]),
.O	(half_arith[i])) ;

FDR arith_flop (
.D	(arith_value[i]),
.Q	(arith_result[i]),
.R	(sel_arith),
.C	(clk));

end
endgenerate
//
////////////////////////////////////////////////////////////////////////////////////
//
// ALU multiplexer
//
////////////////////////////////////////////////////////////////////////////////////
//
LUT4 	#(
.INIT	(16'h0002))	
input_fetch_type_lut (
.I0	(instruction[14]),
.I1	(instruction[15]),
.I2	(instruction[16]),
.I3	(instruction[17]),
.O	(input_fetch_type )) ;

FD sel_group_flop (
.D	(input_fetch_type),
.Q	(sel_group),
.C	(clk));

generate
for (i = 0 ; i <= 7 ; i = i + 1)
begin : alu_mux_loop

LUT3 	#(
.INIT	(8'hFE))		
or_lut (
.I0	(logical_result[i]),
.I1	(arith_result[i]),
.I2	(shift_result[i]),
.O	(alu_group[i])) ;

LUT3 	#(
.INIT	(8'hE4))		
mux_lut (
.I0	(instruction[13]),
.I1	(in_port[i]),
.I2	(store_data[i]),
.O	(input_group[i])) ;

MUXF5 	shift_in_muxf5 (
.I1	(input_group[i]),
.I0	(alu_group[i]),
.S	(sel_group),
.O	(alu_result[i]) );

end
endgenerate
//
////////////////////////////////////////////////////////////////////////////////////
//
// Read and Write Strobes
//
////////////////////////////////////////////////////////////////////////////////////
//
LUT4 	#(
.INIT	(16'h0010))	
io_decode_lut (
.I0	(active_interrupt),
.I1	(instruction[13]),
.I2	(instruction[14]),
.I3	(instruction[16]),
.O	(io_initial_decode )) ;

LUT4 	#(
.INIT	(16'h4000))	
write_active_lut (
.I0	(t_state),
.I1	(instruction[15]),
.I2	(instruction[17]),
.I3	(io_initial_decode),
.O	(write_active )) ;

FDR write_strobe_flop (
.D	(write_active),
.Q	(write_strobe),
.R	(internal_reset),
.C	(clk));

LUT4 	#(
.INIT	(16'h0100))	
read_active_lut (
.I0	(t_state),
.I1	(instruction[15]),
.I2	(instruction[17]),
.I3	(io_initial_decode),
.O	(read_active )) ;

FDR read_strobe_flop (
.D	(read_active),
.Q	(read_strobe),
.R	(internal_reset),
.C	(clk));
//
////////////////////////////////////////////////////////////////////////////////////
//
// Program CALL/RETURN stack
//
// Provided the counter and memory for a 32 deep stack supporting nested
// subroutine calls to a depth of 31 levels.
//
////////////////////////////////////////////////////////////////////////////////////
//
// Stack memory is 32 locations of 10-bit single port.

INV stack_ram_inv (               // Inverter should be implemented in the WE to RAM
.I	(t_state),
.O	(stack_write_enable));

generate
for (i = 0 ; i <= 9 ; i = i + 1)
begin : stack_ram_loop

RAM32X1S #(
.INIT	(32'h00000000))	
stack_bit (
.D	(pc[i]),
.WE	(stack_write_enable),
.WCLK	(clk),
.A0	(stack_address[0]),
.A1	(stack_address[1]),
.A2	(stack_address[2]),
.A3	(stack_address[3]),
.A4	(stack_address[4]),
.O	(stack_ram_data[i])) ;

FD 	stack_flop (
.D	(stack_ram_data[i]),
.Q	(stack_pop_data[i]),
.C	(clk));

end
endgenerate

// Stack address pointer is a special 4-bit counter

INV stack_count_inv(              // Inverter should be implemented in the CE to the flip-flops
.I	(active_interrupt),
.O	(not_active_interrupt));

generate
for (i = 0 ; i <= 4 ; i = i + 1)
begin : stack_count_loop

FDRE stack_count_loop_register_bit (
.D	(next_stack_address[i]),
.Q	(stack_address[i]),
.R	(internal_reset),
.CE	(not_active_interrupt),
.C	(clk));

if (i == 0) begin : lsb_stack_count

LUT4 	#(
.INIT	(16'h6555))	
count_lut (
.I0	(stack_address[i]),
.I1	(t_state),
.I2	(valid_to_move),
.I3	(push_or_pop_type),
.O	(half_stack_address[i]) ) ;

MUXCY count_muxcy (
.DI	(stack_address[i]),
.CI	(1'b0),
.S	(half_stack_address[i]),
.O	(stack_address_carry[i]));

XORCY count_xor (
.LI	(half_stack_address[i]),
.CI	(1'b0),
.O	(next_stack_address[i]));

end
if (i > 0 && i < 4) begin : mid_stack_count

LUT4 	#(
.INIT	(16'hA999))	
count_lut (
.I0	(stack_address[i]),
.I1	(t_state),
.I2	(valid_to_move),
.I3	(call_type),
.O	(half_stack_address[i]) ) ;

MUXCY count_muxcy (
.DI	(stack_address[i]),
.CI	(stack_address_carry[i-1]),
.S	(half_stack_address[i]),
.O	(stack_address_carry[i]));

XORCY count_xor (
.LI	(half_stack_address[i]),
.CI	(stack_address_carry[i-1]),
.O	(next_stack_address[i]));

end
if (i == 4) begin : msb_stack_count

LUT4 	#(
.INIT	(16'hA999))	
count_lut (
.I0	(stack_address[i]),
.I1	(t_state),
.I2	(valid_to_move),
.I3	(call_type),
.O	(half_stack_address[i]) ) ;

XORCY count_xor (
.LI	(half_stack_address[i]),
.CI	(stack_address_carry[i-1]),
.O	(next_stack_address[i]));

end
end
endgenerate

//
////////////////////////////////////////////////////////////////////////////////////
//
// End of description for KCPSM3 macro.
//
////////////////////////////////////////////////////////////////////////////////////
//
//**********************************************************************************
// Code for simulation purposes only after this line
//**********************************************************************************
//
////////////////////////////////////////////////////////////////////////////////////
//
// Code for simulation.
//
// Disassemble the instruction codes to form a text string for display.
// Determine status of reset and flags and present in the form of a text string.
// Provide local variables to simulate the contents of each register and scratch
// pad memory location.
//
////////////////////////////////////////////////////////////////////////////////////
//
 //All of this section is ignored during synthesis.
 //synthesis translate_off
 //
 //complete instruction decode
 //
 reg 	[1:152] kcpsm3_opcode ;
 //
 //Status of flags and processor
 //
 reg 	[1:104] kcpsm3_status ;
 //
 //contents of each register
 //
 reg 	[7:0]	s0_contents ;
 reg 	[7:0]	s1_contents ;
 reg  	[7:0]	s2_contents ;
 reg  	[7:0]	s3_contents ;
 reg  	[7:0]	s4_contents ;
 reg  	[7:0]	s5_contents ;
 reg  	[7:0]	s6_contents ;
 reg  	[7:0]	s7_contents ;
 reg  	[7:0]	s8_contents ;
 reg  	[7:0]	s9_contents ;
 reg  	[7:0]	sa_contents ;
 reg  	[7:0]	sb_contents ;
 reg  	[7:0]	sc_contents ;
 reg  	[7:0]	sd_contents ;
 reg  	[7:0]	se_contents ;
 reg  	[7:0]	sf_contents ;
 //
 //contents of each scratch pad memory location
 //
 reg 	[7:0] 	spm00_contents ;
 reg 	[7:0] 	spm01_contents ;
 reg 	[7:0] 	spm02_contents ;
 reg 	[7:0] 	spm03_contents ;
 reg 	[7:0] 	spm04_contents ;
 reg 	[7:0] 	spm05_contents ;
 reg 	[7:0] 	spm06_contents ;
 reg 	[7:0] 	spm07_contents ;
 reg 	[7:0] 	spm08_contents ;
 reg 	[7:0] 	spm09_contents ;
 reg 	[7:0] 	spm0a_contents ;
 reg 	[7:0] 	spm0b_contents ;
 reg 	[7:0] 	spm0c_contents ;
 reg 	[7:0] 	spm0d_contents ;
 reg 	[7:0] 	spm0e_contents ;
 reg 	[7:0] 	spm0f_contents ;
 reg 	[7:0] 	spm10_contents ;
 reg 	[7:0] 	spm11_contents ;
 reg 	[7:0] 	spm12_contents ;
 reg 	[7:0] 	spm13_contents ;
 reg 	[7:0] 	spm14_contents ;
 reg 	[7:0] 	spm15_contents ;
 reg 	[7:0] 	spm16_contents ;
 reg 	[7:0] 	spm17_contents ;
 reg 	[7:0] 	spm18_contents ;
 reg 	[7:0] 	spm19_contents ;
 reg 	[7:0] 	spm1a_contents ;
 reg 	[7:0] 	spm1b_contents ;
 reg 	[7:0] 	spm1c_contents ;
 reg 	[7:0] 	spm1d_contents ;
 reg 	[7:0] 	spm1e_contents ;
 reg 	[7:0] 	spm1f_contents ;
 reg 	[7:0] 	spm20_contents ;
 reg 	[7:0] 	spm21_contents ;
 reg 	[7:0] 	spm22_contents ;
 reg 	[7:0] 	spm23_contents ;
 reg 	[7:0] 	spm24_contents ;
 reg 	[7:0] 	spm25_contents ;
 reg 	[7:0] 	spm26_contents ;
 reg 	[7:0] 	spm27_contents ;
 reg 	[7:0] 	spm28_contents ;
 reg 	[7:0] 	spm29_contents ;
 reg 	[7:0] 	spm2a_contents ;
 reg 	[7:0] 	spm2b_contents ;
 reg 	[7:0] 	spm2c_contents ;
 reg 	[7:0] 	spm2d_contents ;
 reg 	[7:0] 	spm2e_contents ;
 reg 	[7:0] 	spm2f_contents ;
 reg 	[7:0] 	spm30_contents ;
 reg 	[7:0] 	spm31_contents ;
 reg 	[7:0] 	spm32_contents ;
 reg 	[7:0] 	spm33_contents ;
 reg 	[7:0] 	spm34_contents ;
 reg 	[7:0] 	spm35_contents ;
 reg 	[7:0] 	spm36_contents ;
 reg 	[7:0] 	spm37_contents ;
 reg 	[7:0] 	spm38_contents ;
 reg 	[7:0] 	spm39_contents ;
 reg 	[7:0] 	spm3a_contents ;
 reg 	[7:0] 	spm3b_contents ;
 reg 	[7:0] 	spm3c_contents ;
 reg 	[7:0] 	spm3d_contents ;
 reg 	[7:0] 	spm3e_contents ;
 reg 	[7:0] 	spm3f_contents ;

 // initialise the values
 initial begin
 kcpsm3_status = "NZ, NC, Reset";

 s0_contents = 8'h00 ;
 s1_contents = 8'h00 ;
 s2_contents = 8'h00 ;
 s3_contents = 8'h00 ;
 s4_contents = 8'h00 ;
 s5_contents = 8'h00 ;
 s6_contents = 8'h00 ;
 s7_contents = 8'h00 ;
 s8_contents = 8'h00 ;
 s9_contents = 8'h00 ;
 sa_contents = 8'h00 ;
 sb_contents = 8'h00 ;
 sc_contents = 8'h00 ;
 sd_contents = 8'h00 ;
 se_contents = 8'h00 ;
 sf_contents = 8'h00 ;

 spm00_contents = 8'h00 ;
 spm01_contents = 8'h00 ;
 spm02_contents = 8'h00 ;
 spm03_contents = 8'h00 ;
 spm04_contents = 8'h00 ;
 spm05_contents = 8'h00 ;
 spm06_contents = 8'h00 ;
 spm07_contents = 8'h00 ;
 spm08_contents = 8'h00 ;
 spm09_contents = 8'h00 ;
 spm0a_contents = 8'h00 ;
 spm0b_contents = 8'h00 ;
 spm0c_contents = 8'h00 ;
 spm0d_contents = 8'h00 ;
 spm0e_contents = 8'h00 ;
 spm0f_contents = 8'h00 ;
 spm10_contents = 8'h00 ;
 spm11_contents = 8'h00 ;
 spm12_contents = 8'h00 ;
 spm13_contents = 8'h00 ;
 spm14_contents = 8'h00 ;
 spm15_contents = 8'h00 ;
 spm16_contents = 8'h00 ;
 spm17_contents = 8'h00 ;
 spm18_contents = 8'h00 ;
 spm19_contents = 8'h00 ;
 spm1a_contents = 8'h00 ;
 spm1b_contents = 8'h00 ;
 spm1c_contents = 8'h00 ;
 spm1d_contents = 8'h00 ;
 spm1e_contents = 8'h00 ;
 spm1f_contents = 8'h00 ;
 spm20_contents = 8'h00 ;
 spm21_contents = 8'h00 ;
 spm22_contents = 8'h00 ;
 spm23_contents = 8'h00 ;
 spm24_contents = 8'h00 ;
 spm25_contents = 8'h00 ;
 spm26_contents = 8'h00 ;
 spm27_contents = 8'h00 ;
 spm28_contents = 8'h00 ;
 spm29_contents = 8'h00 ;
 spm2a_contents = 8'h00 ;
 spm2b_contents = 8'h00 ;
 spm2c_contents = 8'h00 ;
 spm2d_contents = 8'h00 ;
 spm2e_contents = 8'h00 ;
 spm2f_contents = 8'h00 ;
 spm30_contents = 8'h00 ;
 spm31_contents = 8'h00 ;
 spm32_contents = 8'h00 ;
 spm33_contents = 8'h00 ;
 spm34_contents = 8'h00 ;
 spm35_contents = 8'h00 ;
 spm36_contents = 8'h00 ;
 spm37_contents = 8'h00 ;
 spm38_contents = 8'h00 ;
 spm39_contents = 8'h00 ;
 spm3a_contents = 8'h00 ;
 spm3b_contents = 8'h00 ;
 spm3c_contents = 8'h00 ;
 spm3d_contents = 8'h00 ;
 spm3e_contents = 8'h00 ;
 spm3f_contents = 8'h00 ;
 end
 //
 //
 wire	[1:16] 	sx_decode ; //sX register specification
 wire 	[1:16]  sy_decode ; //sY register specification
 wire 	[1:16]	kk_decode ; //constant value specification
 wire 	[1:24]	aaa_decode ; //address specification
 //
 ////////////////////////////////////////////////////////////////////////////////
 //
 // Function to convert 4-bit binary nibble to hexadecimal character
 //
 ////////////////////////////////////////////////////////////////////////////////
 //
 function [1:8] hexcharacter ;
 input 	[3:0] nibble ;
 begin
 case (nibble)
 4'b0000 : hexcharacter = "0" ;
 4'b0001 : hexcharacter = "1" ;
 4'b0010 : hexcharacter = "2" ;
 4'b0011 : hexcharacter = "3" ;
 4'b0100 : hexcharacter = "4" ;
 4'b0101 : hexcharacter = "5" ;
 4'b0110 : hexcharacter = "6" ;
 4'b0111 : hexcharacter = "7" ;
 4'b1000 : hexcharacter = "8" ;
 4'b1001 : hexcharacter = "9" ;
 4'b1010 : hexcharacter = "A" ;
 4'b1011 : hexcharacter = "B" ;
 4'b1100 : hexcharacter = "C" ;
 4'b1101 : hexcharacter = "D" ;
 4'b1110 : hexcharacter = "E" ;
 4'b1111 : hexcharacter = "F" ;
 endcase
 end
 endfunction
  /*
 //
 ////////////////////////////////////////////////////////////////////////////////
 //
 begin
 */
 // decode first register
 assign sx_decode[1:8] = "s" ;
 assign sx_decode[9:16] = hexcharacter(instruction[11:8]) ;

 // decode second register
 assign sy_decode[1:8] = "s";
 assign sy_decode[9:16] = hexcharacter(instruction[7:4]);

 // decode constant value
 assign kk_decode[1:8] = hexcharacter(instruction[7:4]);
 assign kk_decode[9:16] = hexcharacter(instruction[3:0]);

 // address value
 assign aaa_decode[1:8] = hexcharacter({2'b00, instruction[9:8]});
 assign aaa_decode[9:16] = hexcharacter(instruction[7:4]);
 assign aaa_decode[17:24] = hexcharacter(instruction[3:0]);

 // decode instruction
 always @ (instruction or kk_decode or sy_decode or sx_decode or aaa_decode)
 begin
 case (instruction[17:12])
 6'b000000 : begin kcpsm3_opcode <= {"LOAD ", sx_decode, ",", kk_decode, " "} ; end
 6'b000001 : begin kcpsm3_opcode <= {"LOAD ", sx_decode, ",", sy_decode, " "} ; end
 6'b001010 : begin kcpsm3_opcode <= {"AND  ", sx_decode, ",", kk_decode, " "} ; end
 6'b001011 : begin kcpsm3_opcode <= {"AND  ", sx_decode, ",", sy_decode, " "} ; end
 6'b001100 : begin kcpsm3_opcode <= {"OR   ", sx_decode, ",", kk_decode, " "} ; end
 6'b001101 : begin kcpsm3_opcode <= {"OR   ", sx_decode, ",", sy_decode, " "} ; end
 6'b001110 : begin kcpsm3_opcode <= {"XOR  ", sx_decode, ",", kk_decode, " "} ; end
 6'b001111 : begin kcpsm3_opcode <= {"XOR  ", sx_decode, ",", sy_decode, " "} ; end
 6'b010010 : begin kcpsm3_opcode <= {"TEST ", sx_decode, ",", kk_decode, " "} ; end
 6'b010011 : begin kcpsm3_opcode <= {"TEST ", sx_decode, ",", sy_decode, " "} ; end
 6'b011000 : begin kcpsm3_opcode <= {"ADD  ", sx_decode, ",", kk_decode, " "} ; end
 6'b011001 : begin kcpsm3_opcode <= {"ADD  ", sx_decode, ",", sy_decode, " "} ; end
 6'b011010 : begin kcpsm3_opcode <= {"ADDCY", sx_decode, ",", kk_decode, " "} ; end
 6'b011011 : begin kcpsm3_opcode <= {"ADDCY", sx_decode, ",", sy_decode, " "} ; end
 6'b011100 : begin kcpsm3_opcode <= {"SUB  ", sx_decode, ",", kk_decode, " "} ; end
 6'b011101 : begin kcpsm3_opcode <= {"SUB  ", sx_decode, ",", sy_decode, " "} ; end
 6'b011110 : begin kcpsm3_opcode <= {"SUBCY", sx_decode, ",", kk_decode, " "} ; end
 6'b011111 : begin kcpsm3_opcode <= {"SUBCY", sx_decode, ",", sy_decode, " "} ; end
 6'b010100 : begin kcpsm3_opcode <= {"COMPARE ", sx_decode, ",", kk_decode, " "} ; end
 6'b010101 : begin kcpsm3_opcode <= {"COMPARE ", sx_decode, ",", sy_decode, " "} ; end
 6'b100000 : begin
   case (instruction[3:0])
     4'b0110 : begin kcpsm3_opcode <= {"SL0 ", sx_decode, " "}; end
     4'b0111 : begin kcpsm3_opcode <= {"SL1 ", sx_decode, " "}; end
     4'b0100 : begin kcpsm3_opcode <= {"SLX ", sx_decode, " "}; end
     4'b0000 : begin kcpsm3_opcode <= {"SLA ", sx_decode, " "}; end
     4'b0010 : begin kcpsm3_opcode <= {"RL ", sx_decode, " "}; end
     4'b1110 : begin kcpsm3_opcode <= {"SR0 ", sx_decode, " "}; end
     4'b1111 : begin kcpsm3_opcode <= {"SR1 ", sx_decode, " "}; end
     4'b1010 : begin kcpsm3_opcode <= {"SRX ", sx_decode, " "}; end
     4'b1000 : begin kcpsm3_opcode <= {"SRA ", sx_decode, " "}; end
     4'b1100 : begin kcpsm3_opcode <= {"RR ", sx_decode, " "}; end
     default : begin kcpsm3_opcode <= "Invalid Instruction"; end
   endcase
 end
 6'b101100 : begin kcpsm3_opcode <= {"OUTPUT ", sx_decode, ",", kk_decode, " "}; end
 6'b101101 : begin kcpsm3_opcode <= {"OUTPUT ", sx_decode, ",(", sy_decode, ") "}; end
 6'b000100 : begin kcpsm3_opcode <= {"INPUT ", sx_decode, ",", kk_decode, " "}; end
 6'b000101 : begin kcpsm3_opcode <= {"INPUT ", sx_decode, ",(", sy_decode, ") "}; end
 6'b101110 : begin kcpsm3_opcode <= {"STORE ", sx_decode, ",", kk_decode, " "}; end
 6'b101111 : begin kcpsm3_opcode <= {"STORE ", sx_decode, ",(", sy_decode, ") "}; end
 6'b000110 : begin kcpsm3_opcode <= {"FETCH ", sx_decode, ",", kk_decode, " "}; end
 6'b000111 : begin kcpsm3_opcode <= {"FETCH ", sx_decode, ",(", sy_decode, ") "}; end
 6'b110100 : begin
   case (instruction[11:10])
     2'b00   : begin kcpsm3_opcode <= {"JUMP ", aaa_decode, " "}; end
     2'b01   : begin kcpsm3_opcode <= {"JUMP ", aaa_decode, " "}; end
     2'b10   : begin kcpsm3_opcode <= {"JUMP ", aaa_decode, " "}; end
     2'b11   : begin kcpsm3_opcode <= {"JUMP ", aaa_decode, " "}; end
     default : begin kcpsm3_opcode <= "Invalid Instruction"; end
   endcase
end
 6'b110101 : begin
   case (instruction[11:10])
     2'b00   : begin kcpsm3_opcode <= {"JUMP Z,", aaa_decode, " "}; end
     2'b01   : begin kcpsm3_opcode <= {"JUMP NZ,", aaa_decode, " "}; end
     2'b10   : begin kcpsm3_opcode <= {"JUMP C,", aaa_decode, " "}; end
     2'b11   : begin kcpsm3_opcode <= {"JUMP NC,", aaa_decode, " "}; end
     default : begin kcpsm3_opcode <= "Invalid Instruction"; end
   endcase
 end
 6'b110000 : begin
   case (instruction[11:10])
     2'b00   : begin kcpsm3_opcode <= {"CALL ", aaa_decode, " "}; end
     2'b01   : begin kcpsm3_opcode <= {"CALL ", aaa_decode, " "}; end
     2'b10   : begin kcpsm3_opcode <= {"CALL ", aaa_decode, " "}; end
     2'b11   : begin kcpsm3_opcode <= {"CALL ", aaa_decode, " "}; end
     default : begin kcpsm3_opcode <= "Invalid Instruction"; end
   endcase
end
 6'b110001 : begin
   case (instruction[11:10])
     2'b00   : begin kcpsm3_opcode <= {"CALL Z,", aaa_decode, " "}; end
     2'b01   : begin kcpsm3_opcode <= {"CALL NZ,", aaa_decode, " "}; end
     2'b10   : begin kcpsm3_opcode <= {"CALL C,", aaa_decode, " "}; end
     2'b11   : begin kcpsm3_opcode <= {"CALL NC,", aaa_decode, " "}; end
     default : begin kcpsm3_opcode <= "Invalid Instruction"; end
   endcase
 end
 6'b101010 : begin kcpsm3_opcode <= "RETURN "; end
 6'b101011 : begin
 case (instruction[11:10])
     2'b00   : begin kcpsm3_opcode <= "RETURN Z "; end
     2'b01   : begin kcpsm3_opcode <= "RETURN NZ "; end
     2'b10   : begin kcpsm3_opcode <= "RETURN C "; end
     2'b11   : begin kcpsm3_opcode <= "RETURN NC "; end
     default : begin kcpsm3_opcode <= "Invalid Instruction"; end
   endcase
 end
 6'b111000 : begin
   case (instruction[0])
     1'b0    : begin kcpsm3_opcode <= "RETURNI DISABLE "; end
     1'b1    : begin kcpsm3_opcode <= "RETURNI ENABLE "; end
     default : begin kcpsm3_opcode <= "Invalid Instruction"; end
   endcase
 end
 6'b111100 : begin
   case (instruction[0])
     1'b0    : begin kcpsm3_opcode <= "DISABLE INTERRUPT "; end
     1'b1    : begin kcpsm3_opcode <= "ENABLE INTERRUPT "; end
     default : begin kcpsm3_opcode <= "Invalid Instruction"; end
   endcase
 end
 default : begin kcpsm3_opcode <= "Invalid Instruction"; end
 endcase
 end

 //reset and flag status information
 always @ (posedge clk) begin
   if (reset==1'b1 || reset_delay==1'b1) begin
     kcpsm3_status = "NZ, NC, Reset";
   end
   else begin
     kcpsm3_status[65:104] <= "       ";
     if (flag_enable == 1'b1) begin
       if (zero_carry == 1'b1) begin
         kcpsm3_status[1:32] <= " Z, ";
       end
       else begin
         kcpsm3_status[1:32] <= "NZ, ";
       end
       if (sel_carry[3] == 1'b1) begin
         kcpsm3_status[33:48] <= " C";
       end
       else begin
         kcpsm3_status[33:48] <= "NC";
       end
     end
   end
 end
 //simulation of register contents
 always @ (posedge clk) begin
   if (register_enable == 1'b1) begin
     case (instruction[11:8])
       4'b0000 : begin s0_contents <= alu_result; end
       4'b0001 : begin s1_contents <= alu_result; end
       4'b0010 : begin s2_contents <= alu_result; end
       4'b0011 : begin s3_contents <= alu_result; end
       4'b0100 : begin s4_contents <= alu_result; end
       4'b0101 : begin s5_contents <= alu_result; end
       4'b0110 : begin s6_contents <= alu_result; end
       4'b0111 : begin s7_contents <= alu_result; end
       4'b1000 : begin s8_contents <= alu_result; end
       4'b1001 : begin s9_contents <= alu_result; end
       4'b1010 : begin sa_contents <= alu_result; end
       4'b1011 : begin sb_contents <= alu_result; end
       4'b1100 : begin sc_contents <= alu_result; end
       4'b1101 : begin sd_contents <= alu_result; end
       4'b1110 : begin se_contents <= alu_result; end
       default : begin sf_contents <= alu_result; end
     endcase
   end
 end
 //simulation of scratch pad memory contents
 always @ (posedge clk) begin
   if (memory_enable==1'b1) begin
     case (second_operand[5:0])
       6'b000000 : begin spm00_contents <= sx ; end
       6'b000001 : begin spm01_contents <= sx ; end
       6'b000010 : begin spm02_contents <= sx ; end
       6'b000011 : begin spm03_contents <= sx ; end
       6'b000100 : begin spm04_contents <= sx ; end
       6'b000101 : begin spm05_contents <= sx ; end
       6'b000110 : begin spm06_contents <= sx ; end
       6'b000111 : begin spm07_contents <= sx ; end
       6'b001000 : begin spm08_contents <= sx ; end
       6'b001001 : begin spm09_contents <= sx ; end
       6'b001010 : begin spm0a_contents <= sx ; end
       6'b001011 : begin spm0b_contents <= sx ; end
       6'b001100 : begin spm0c_contents <= sx ; end
       6'b001101 : begin spm0d_contents <= sx ; end
       6'b001110 : begin spm0e_contents <= sx ; end
       6'b001111 : begin spm0f_contents <= sx ; end
       6'b010000 : begin spm10_contents <= sx ; end
       6'b010001 : begin spm11_contents <= sx ; end
       6'b010010 : begin spm12_contents <= sx ; end
       6'b010011 : begin spm13_contents <= sx ; end
       6'b010100 : begin spm14_contents <= sx ; end
       6'b010101 : begin spm15_contents <= sx ; end
       6'b010110 : begin spm16_contents <= sx ; end
       6'b010111 : begin spm17_contents <= sx ; end
       6'b011000 : begin spm18_contents <= sx ; end
       6'b011001 : begin spm19_contents <= sx ; end
       6'b011010 : begin spm1a_contents <= sx ; end
       6'b011011 : begin spm1b_contents <= sx ; end
       6'b011100 : begin spm1c_contents <= sx ; end
       6'b011101 : begin spm1d_contents <= sx ; end
       6'b011110 : begin spm1e_contents <= sx ; end
       6'b011111 : begin spm1f_contents <= sx ; end
       6'b100000 : begin spm20_contents <= sx ; end
       6'b100001 : begin spm21_contents <= sx ; end
       6'b100010 : begin spm22_contents <= sx ; end
       6'b100011 : begin spm23_contents <= sx ; end
       6'b100100 : begin spm24_contents <= sx ; end
       6'b100101 : begin spm25_contents <= sx ; end
       6'b100110 : begin spm26_contents <= sx ; end
       6'b100111 : begin spm27_contents <= sx ; end
       6'b101000 : begin spm28_contents <= sx ; end
       6'b101001 : begin spm29_contents <= sx ; end
       6'b101010 : begin spm2a_contents <= sx ; end
       6'b101011 : begin spm2b_contents <= sx ; end
       6'b101100 : begin spm2c_contents <= sx ; end
       6'b101101 : begin spm2d_contents <= sx ; end
       6'b101110 : begin spm2e_contents <= sx ; end
       6'b101111 : begin spm2f_contents <= sx ; end
       6'b110000 : begin spm30_contents <= sx ; end
       6'b110001 : begin spm31_contents <= sx ; end
       6'b110010 : begin spm32_contents <= sx ; end
       6'b110011 : begin spm33_contents <= sx ; end
       6'b110100 : begin spm34_contents <= sx ; end
       6'b110101 : begin spm35_contents <= sx ; end
       6'b110110 : begin spm36_contents <= sx ; end
       6'b110111 : begin spm37_contents <= sx ; end
       6'b111000 : begin spm38_contents <= sx ; end
       6'b111001 : begin spm39_contents <= sx ; end
       6'b111010 : begin spm3a_contents <= sx ; end
       6'b111011 : begin spm3b_contents <= sx ; end
       6'b111100 : begin spm3c_contents <= sx ; end
       6'b111101 : begin spm3d_contents <= sx ; end
       6'b111110 : begin spm3e_contents <= sx ; end
       default   : begin spm3f_contents <= sx ; end
     endcase
   end
 end
 //synthesis translate_on
//
////////////////////////////////////////////////////////////////////////////////////
//
//**********************************************************************************
// End of simulation code.
//**********************************************************************************

endmodule

//
////////////////////////////////////////////////////////////////////////////////////
//
// END OF FILE KCPSM3.V
//
////////////////////////////////////////////////////////////////////////////////////
//
