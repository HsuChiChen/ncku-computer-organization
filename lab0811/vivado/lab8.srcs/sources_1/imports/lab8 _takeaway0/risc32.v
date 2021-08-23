// Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2014.4 (win64) Build 1071353 Tue Nov 18 18:29:27 MST 2014
// Date        : Tue Mar 29 11:53:51 2016
// Host        : CASLAB-PC running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -mode port risc32.v
// Design      : RISC32
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module RISC32(HRDATAM, HRESPM, HADDRM, HTRANSM, HSIZEM, HBURSTM, HPROTM, HWDATAM, HADDRS, HTRANSS, HSIZES, HWDATAS, HRDATAS, HRESPS, HCLK, HRESETn, HREADYM, HGRANTM, HWRITEM, HBUSREQM, HLOCKM, RISCNIRQ, RISCNFIQ, HWRITES, HSELS, HREADYS, HREADYOUTS);
  input [31:0] HRDATAM;
  input [1:0] HRESPM;
  output [31:0] HADDRM;
  output [1:0] HTRANSM;
  output [2:0] HSIZEM;
  output [2:0] HBURSTM;
  output [3:0] HPROTM;
  output [31:0] HWDATAM;
  input [31:0] HADDRS;
  input [1:0] HTRANSS;
  input [2:0] HSIZES;
  input [31:0] HWDATAS;
  output [31:0] HRDATAS;
  output [1:0] HRESPS;
  input HCLK;
  input HRESETn;
  input HREADYM;
  input HGRANTM;
  output HWRITEM;
  output HBUSREQM;
  output HLOCKM;
  input RISCNIRQ;
  input RISCNFIQ;
  input HWRITES;
  input HSELS;
  input HREADYS;
  output HREADYOUTS;

endmodule
