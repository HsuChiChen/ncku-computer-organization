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
// File Name : MuxS2M.v,v
// File Revision : 1.4
// 
// Release Information : AUK-REL1v0
// 
// -----------------------------------------------------------------------------
// Purpose             : Central multiplexer - signals from slaves to masters
//                       Stand-alone module to allow ease of removal if an
//                       alternative interconnection scheme is to be used.
// --=========================================================================--
 
module MuxS2M (HCLK, HRESETn,
							 HSELDefault, HSEL_Slave1, HSEL_Slave2, HSEL_Slave3, HSEL_Slave4, HSEL_Slave5, HSEL_Slave6,
               HRDATA_S1, HREADY_S1, HRESP_S1, //ExtMem
               HRDATA_S2, HREADY_S2, HRESP_S2, //NCKU RISC32 MISR 1
               HRDATA_S3, HREADY_S3, HRESP_S3, //NCKU RISC32 MISR 2
               HRDATA_S4, HREADY_S4, HRESP_S4, //NCKU PTM
               HRDATA_S5, HREADY_S5, HRESP_S5, //NCKU TEST Controller       
               HRDATA_S6, HREADY_S6, HRESP_S6, //NCKU TEST Controller     			   
               HREADYDefault, HRESPDefault,             //Default
               HRDATA, HREADY, HRESP
               
               );
 
  input         HCLK;
  input         HRESETn;
  
  input				  HSELDefault;      // Default Slave
  input				  HSEL_Slave1;			// Externa Memory
  input				  HSEL_Slave2;			// NCKU RISC32 MISR 1
  input				  HSEL_Slave3;			// NCKU RISC32 MISR 2
  input				  HSEL_Slave4;			// NCKU PTM
  input				  HSEL_Slave5;			// NCKU TEST Controller
  input		 		  HSEL_Slave6;     	  // _Slave6 Slave
  
  input  [31:0] HRDATA_S1;
  input         HREADY_S1;
  input   [1:0] HRESP_S1;

  input  [31:0] HRDATA_S2;
  input         HREADY_S2;
  input   [1:0] HRESP_S2;
  
  input  [31:0] HRDATA_S3;
  input         HREADY_S3;
  input   [1:0] HRESP_S3;
  
  input  [31:0] HRDATA_S4;
  input         HREADY_S4;
  input   [1:0] HRESP_S4;
  
  input  [31:0] HRDATA_S5;
  input         HREADY_S5;
  input   [1:0] HRESP_S5;

  input  [31:0] HRDATA_S6;
  input         HREADY_S6;
  input   [1:0] HRESP_S6;

  input         HREADYDefault;
  input   [1:0] HRESPDefault;

  output [31:0] HRDATA;
  output        HREADY;
  output  [1:0] HRESP;
 
//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------
// HselReg encoding. This must be extended if more than eight AHB peripherals
//  are used in the system.
  `define HSEL_1  			8'b00000001
  `define HSEL_2  			8'b00000010
  `define HSEL_3  			8'b00000100
  `define HSEL_4  			8'b00001000
  `define HSEL_5  			8'b00010000
  `define HSEL_6		  	8'b00100000
 
//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------
  wire  [7:0] HselNext; // HSEL input bus
  reg   [7:0] HselReg;  // HSEL input register

  reg  [31:0] HRDATA;   // Registered output signal
  reg         HREADY;
  reg   [1:0] HRESP;    // Registered output signal

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// HSEL bus and registers
//------------------------------------------------------------------------------
// The internal HSEL bus is made up of the HSEL inputs and extra padding for the
//  bits that are not used.

  assign HselNext = {2'b00,
                     HSEL_Slave6,
                     HSEL_Slave5,
                     HSEL_Slave4,
                     HSEL_Slave3,
                     HSEL_Slave2,
                     HSEL_Slave1};

// Registered HSEL outputs are needed to control the slave output multiplexers,
//  as the multiplexers must be switched in the cycle after the HSEL signals
//  have been driven.

  always @( posedge (HCLK) )
  begin
    if (!HRESETn)
      HselReg <= 8'h00;
    else
    begin
      if (HREADY)
        HselReg <= HselNext;
    end
  end
 
//------------------------------------------------------------------------------
// Multiplexers
//------------------------------------------------------------------------------
// Multiplexers controlling read data and responses from slaves to masters.
// When no slaves are selected by the Decoder, the default outputs are used to
//  generate the response.
// A default read data value is not strictly required as all reads from
//  undefined regions of memory receive an error response, but may aid debugging
//  by ensuring that the read data bus is zero when no peripherals are being
//  accessed.

  always @( HselReg or HRDATA_S1 or HRDATA_S2 or HRDATA_S3 or HRDATA_S4 or HRDATA_S5 or HRDATA_S6 )
  begin
    case (HselReg)
      `HSEL_1  			: HRDATA = HRDATA_S1;
      `HSEL_2  			: HRDATA = HRDATA_S2;
      `HSEL_3   		: HRDATA = HRDATA_S3;
      `HSEL_4			: HRDATA = HRDATA_S4;
      `HSEL_5			: HRDATA = HRDATA_S5;
      `HSEL_6			: HRDATA = HRDATA_S6;
      default       : HRDATA = 32'h0000_0000;
    endcase
  end
  
  always @( HselReg or HREADY_S1 or HREADY_S2 or HREADY_S3 or HREADY_S4 or HREADY_S5 or HREADY_S6 )
  begin
    case (HselReg)
      `HSEL_1  			: HREADY = HREADY_S1;
      `HSEL_2  			: HREADY = HREADY_S2;
      `HSEL_3   		: HREADY = HREADY_S3;
      `HSEL_4			: HREADY = HREADY_S4;
      `HSEL_5			: HREADY = HREADY_S5;
      `HSEL_6			: HREADY = HREADY_S6;
      default       : HREADY = HREADYDefault;
    endcase
  end
  
  always @( HselReg or HRESP_S1 or HRESP_S2 or HRESP_S3 or HRESP_S4 or HRESP_S5 or HRESP_S6)
  begin
    case (HselReg)
      `HSEL_1  			: HRESP = HRESP_S1;
      `HSEL_2  			: HRESP = HRESP_S2;
      `HSEL_3   		: HRESP = HRESP_S3;
      `HSEL_4			: HRESP = HRESP_S4;
      `HSEL_5			: HRESP = HRESP_S5;
      `HSEL_6			: HRESP = HRESP_S6;
      default       : HRESP = HRESPDefault;
    endcase
  end

endmodule

// --================================= End ===================================--
