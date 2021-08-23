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
// File Name : DefaultSlave.v,v
// File Revision : 1.4
// 
// Release Information : AUK-REL1v0
// 
// -----------------------------------------------------------------------------
// Purpose             : Default slave used to drive the slave response signals
//                       when there are no other slaves selected.
// --=========================================================================--
 
module DefaultSlave (HCLK, HRESETn, HTRANS, HSELDefault, HREADYin, HREADYout,
                     HRESP);
 
  input HCLK;
  input HRESETn;
  input [1:0] HTRANS;
  input HSELDefault;
  input HREADYin;
  output HREADYout;
  output [1:0] HRESP;
 
//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------
  wire       Invalid;    // Set during invalid transfer
  wire       HreadyNext; // Controls generation of HREADYout output
  reg        iHREADYout; // HREADYout register
  wire [1:0] HrespNext;  // Generated response
 
  reg  [1:0] HRESP;      // Registered output signal

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Invalid transfer detection
//------------------------------------------------------------------------------
// Set HIGH during the address phase of an invalid transfer, and is used to
//  control the generation of the response outputs.

  assign Invalid = ((HREADYin == 1'b1 && HSELDefault == 1'b1 &&
                     (HTRANS == `TRN_NONSEQ || HTRANS == `TRN_SEQ)) ? 1'b1 :
                   1'b0);

//------------------------------------------------------------------------------
// Default slave output drivers
//------------------------------------------------------------------------------
// When an undefined area of the memory map is accessed, or an invalid address
//  is driven onto the address bus, the default slave outputs are selected and
//  passed to the current bus master.

// For the two cycle error response, HREADY is set LOW during the first cycle
//  and HIGH during the second cycle.

  assign HreadyNext = (iHREADYout == 1'b0 ? 1'b1 :
                      (Invalid == 1'b1 ? 1'b0 :
                      1'b1));

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))
      iHREADYout <= 1'b1;
    else
      iHREADYout <= HreadyNext;
  end
 
  assign HREADYout = iHREADYout;

// An OKAY response is generated for IDLE or BUSY transfers to undefined
//  locations, but a two cycle ERROR response is generated if a non-sequential
//  or sequential transfer is attempted.

  assign HrespNext = (Invalid == 1'b1 ? `RSP_ERROR : `RSP_OKAY);

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))
      HRESP <= `RSP_OKAY;
    else
    begin
      if (iHREADYout)
        HRESP <= HrespNext;
    end
  end


endmodule

// --================================= End ===================================--
