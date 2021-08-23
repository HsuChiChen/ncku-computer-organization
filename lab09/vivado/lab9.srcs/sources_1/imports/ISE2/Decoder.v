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
// File Name : Decoder.v,v
// File Revision : 1.4
// 
// Release Information : AUK-REL1v0
// 
// -----------------------------------------------------------------------------
//  Purpose             : Provides the HSELx module select outputs to the AHB
//                        system slaves, and controls the read data multiplexer.
//                        This module is specific to a particular implementation
// --=========================================================================--
 
module Decoder (HRESETn, HADDR, HSELDefault, HSEL_Slave1, HSEL_Slave2 );
 
  input        HRESETn;
  input [31:0] HADDR;

  
  output			 HSELDefault;     // Default Slave
  output			 HSEL_Slave1;			// Interna Memory
  output			 HSEL_Slave2;			// UART

 
//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------
  reg					 HSELDefault;     // Default Slave
  reg					 HSEL_Slave1;			// Interna Memory
  reg					 HSEL_Slave2;			// UART


  
  reg					 Memoryremap ;

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// AHB address decoding for slave selection and read data multiplexer control
//------------------------------------------------------------------------------
// Address decoding of HADDR is performed continuously.
// Address map is:

// 0x00000000 - 0x0FFFFFFF Internal RAM 
// 0x20000000 - 0x2FFFFFFF UART


	always @(HRESETn or HADDR )
  begin
    
    HSELDefault = 1'b0 ;
  	HSEL_Slave1 = 1'b0 ;
  	HSEL_Slave2 = 1'b0 ;

	
    if (!HRESETn)
      HSELDefault = 1'b1;      //  Reset (Default Slave)
    else
    begin
          case (HADDR[31:27])
        5'b00000 :
			HSEL_Slave1 = 1'b1;		//Internal RAM
 
        5'b00100 :
			HSEL_Slave2 = 1'b1;    	//  UART

	 			
		 
        default  :
          HSELDefault = 1'b1;   //  Undefined (Default Slave)


      endcase
    end
  end
 
endmodule

// --================================= End ===================================--
