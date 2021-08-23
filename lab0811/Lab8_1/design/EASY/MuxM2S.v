// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// 
// -----------------------------------------------------------------------------
// Version and Release Control Information:
// 
//  File Name : MuxM2S.v,v
//  File Revision : 1.4
//
//  Release Information : AUK-REL1v0
// 
// -----------------------------------------------------------------------------
// Purpose             : Central multiplexer - signals from masters to slaves
//                       Also generates the default master outputs when no
//                       other masters are selected.
//                       Stand-alone module to allow ease of removal if an
//                       alternative interconnection scheme is to be used.
// --=========================================================================--
 
module MuxM2S (HCLK, HRESETn, HMASTER, HREADY, 
							 HADDR_M1, HTRANS_M1, HWRITE_M1, HSIZE_M1, HBURST_M1, HPROT_M1, HWDATA_M1,
							 HADDR_M2, HTRANS_M2, HWRITE_M2, HSIZE_M2, HBURST_M2, HPROT_M2, HWDATA_M2,
							 HADDR_M3, HTRANS_M3, HWRITE_M3, HSIZE_M3, HBURST_M3, HPROT_M3, HWDATA_M3,
							 HADDR_M4, HTRANS_M4, HWRITE_M4, HSIZE_M4, HBURST_M4, HPROT_M4, HWDATA_M4,						 
               HADDR, HTRANS, HWRITE, HSIZE, HBURST, HPROT, HWDATA);
 
  input         HCLK;
  input         HRESETn;
  input   [4:0] HMASTER;
  input         HREADY;

  input  [31:0] HADDR_M1;
  input   [1:0] HTRANS_M1;
  input         HWRITE_M1;
  input   [2:0] HSIZE_M1;
  input   [2:0] HBURST_M1;
  input   [3:0] HPROT_M1;
  input  [31:0] HWDATA_M1;

  input  [31:0] HADDR_M2;
  input   [1:0] HTRANS_M2;
  input         HWRITE_M2;
  input   [2:0] HSIZE_M2;
  input   [2:0] HBURST_M2;
  input   [3:0] HPROT_M2;
  input  [31:0] HWDATA_M2;
  
  input  [31:0] HADDR_M3;
  input   [1:0] HTRANS_M3;
  input         HWRITE_M3;
  input   [2:0] HSIZE_M3;
  input   [2:0] HBURST_M3;
  input   [3:0] HPROT_M3;
  input  [31:0] HWDATA_M3;
  
  input  [31:0] HADDR_M4;
  input   [1:0] HTRANS_M4;
  input         HWRITE_M4;
  input   [2:0] HSIZE_M4;
  input   [2:0] HBURST_M4;
  input   [3:0] HPROT_M4;
  input  [31:0] HWDATA_M4;
  
  output [31:0] HADDR;
  output  [1:0] HTRANS;
  output        HWRITE;
  output  [2:0] HSIZE;
  output  [2:0] HBURST;
  output  [3:0] HPROT;
  output [31:0] HWDATA;
 
//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------
// HMASTER output encoding
  `define MST_0 5'b00000
  `define MST_1 5'b00001
  `define MST_2 5'b00010
  `define MST_3 5'b00011
  `define MST_4 5'b00100  
 
//------------------------------------------------------------------------------
// Signal declaration
//------------------------------------------------------------------------------
  reg  [3:0] HmasterPrev; // Previous HMASTER value

// Registered output signals
  reg [31:0] HADDR;
  reg  [1:0] HTRANS;
  reg        HWRITE;
  reg  [2:0] HSIZE;
  reg  [2:0] HBURST;
  reg  [3:0] HPROT;
  reg [31:0] HWDATA;

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// HMASTER register for write data multiplexer
//------------------------------------------------------------------------------
// HREADY is used as an enable so that if the previous transfer is waited,
//  then the bus master number for that transfer is still stored.

  always @( posedge (HCLK) )
  begin
    if (!HRESETn)
      HmasterPrev <= 5'h0;
    else
    begin
      if (HREADY)
        HmasterPrev <= HMASTER;
    end
  end
 
//------------------------------------------------------------------------------
// Multiplexers
//------------------------------------------------------------------------------
// Multiplexers controlling address, control and write data to the slaves.

// When no masters are granted the Default Master settings are selected by the
//  muxes. This sets all outputs to zero, performing IDLE transfers.
// The HTRANS output is the only one required to be driven LOW when no masters
//  are selected - it is possible to drive all other outputs with values from
//  one of the masters that is not selected, removing the need for driving wide
//  buses LOW.

  always @(HMASTER or HADDR_M1 or HADDR_M2 or HADDR_M3 or HADDR_M4 )
  begin
    case (HMASTER)
      `MST_0 : HADDR = 32'h0000_0000;
      `MST_1 : HADDR = HADDR_M1;
      `MST_2 : HADDR = HADDR_M2;
      `MST_3 : HADDR = HADDR_M3;
      `MST_4 : HADDR = HADDR_M4;	  
      default  : HADDR = 32'h0000_0000;
    endcase
  end
  
  always @(HMASTER or HTRANS_M1 or HTRANS_M2 or HTRANS_M3 or HTRANS_M4 )
  begin
    case (HMASTER)
      `MST_0 : HTRANS = 2'b00;
      `MST_1 : HTRANS = HTRANS_M1;
      `MST_2 : HTRANS = HTRANS_M2;
      `MST_3 : HTRANS = HTRANS_M3;
      `MST_4 : HTRANS = HTRANS_M4;	  
      default  : HTRANS = 32'h0000_0000;
    endcase
  end
  
  always @(HMASTER or HWRITE_M1 or HWRITE_M2 or HWRITE_M3 or HWRITE_M4 )
  begin
    case (HMASTER)
      `MST_0 : HWRITE = 1'b0;
      `MST_1 : HWRITE = HWRITE_M1;
      `MST_2 : HWRITE = HWRITE_M2;
      `MST_3 : HWRITE = HWRITE_M3;
      `MST_4 : HWRITE = HWRITE_M4;
      default  : HWRITE = 1'b0;
    endcase
  end
  
  always @(HMASTER or HSIZE_M1 or HSIZE_M2 or HSIZE_M3 or HSIZE_M4 )
  begin
    case (HMASTER)
      `MST_0 : HSIZE = 3'b000;
      `MST_1 : HSIZE = HSIZE_M1;
      `MST_2 : HSIZE = HSIZE_M2;
      `MST_3 : HSIZE = HSIZE_M3;
      `MST_4 : HSIZE = HSIZE_M4;
      default  : HSIZE = 3'b000;
    endcase
  end
  
  always @(HMASTER or HBURST_M1 or HBURST_M2 or HBURST_M3 or HBURST_M4 )
  begin
    case (HMASTER)
      `MST_0 : HBURST = 3'b000;
      `MST_1 : HBURST = HBURST_M1;
      `MST_2 : HBURST = HBURST_M2;
      `MST_3 : HBURST = HBURST_M3;
      `MST_4 : HBURST = HBURST_M4;	  
      default  : HBURST = 3'b000;
    endcase
  end
  
  always @(HMASTER or HPROT_M1 or HPROT_M2 or HPROT_M3 or HPROT_M4 )
  begin
    case (HMASTER)
      `MST_0 : HPROT = 4'b0000;
      `MST_1 : HPROT = HPROT_M1;
      `MST_2 : HPROT = HPROT_M2;
      `MST_3 : HPROT = HPROT_M3;
      `MST_4 : HPROT = HPROT_M4;	  
      default  : HPROT = 4'b0000;
    endcase
  end
  
  always @(HmasterPrev or HWDATA_M1 or HWDATA_M2 or HWDATA_M3 or HWDATA_M4 )
  begin
    case (HmasterPrev)
      `MST_0 : HWDATA = 32'h0000_0000;
      `MST_1 : HWDATA = HWDATA_M1;
      `MST_2 : HWDATA = HWDATA_M2;
      `MST_3 : HWDATA = HWDATA_M3;
      `MST_4 : HWDATA = HWDATA_M4;
      default  : HWDATA = 32'h0000_0000;
    endcase
  end

endmodule

// --================================= End ===================================--
