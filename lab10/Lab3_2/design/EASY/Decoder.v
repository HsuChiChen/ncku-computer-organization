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
 
module Decoder (HRESETn, HADDR, HSELDefault, HSEL_Slave1, HSEL_Slave2,
                HSEL_Slave3, HSEL_Slave4, HSEL_Slave5,HSEL_Slave6,HSEL_Slave7);
 
  input        HRESETn;
  input [31:0] HADDR;

  
  output			 HSELDefault;     // Default Slave
  output			 HSEL_Slave1;			// Interna Memory
  output			 HSEL_Slave2;			// Tube
  output			 HSEL_Slave3;			// testSlave
  output			 HSEL_Slave4;			// Externa Memory
  output			 HSEL_Slave5;			// Timer1
  output			 HSEL_Slave6;			// Timer2
  output			 HSEL_Slave7;			// IRCntl
 
//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------
  reg					 HSELDefault;     // Default Slave
  reg					 HSEL_Slave1;			// Interna Memory
  reg					 HSEL_Slave2;			// Tube
  reg					 HSEL_Slave3;			// testSlave
  reg					 HSEL_Slave4;			// Externa Memory
  reg					 HSEL_Slave5;			// Timer1
  reg					 HSEL_Slave6;			// Timer2
  reg					 HSEL_Slave7;			// IRCntl
  
  reg					 Memoryremap ;

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// AHB address decoding for slave selection and read data multiplexer control
//------------------------------------------------------------------------------
// Address decoding of HADDR is performed continuously.
// Address map is:

// 0x00000000 - 0x0FFFFFFF Enternal RAM 
// 0x20000000 - 0x2FFFFFFF Tube
// 0x30000000 - 0x3FFFFFFF testSlave
// 0x50000000 - 0x50FFFFFF Timer1
// 0x51000000 - 0x51FFFFFF Timer2
// 0x57000000 - 0x57FFFFFF IRCntl

	always @(HRESETn or HADDR )
  begin
    
    HSELDefault = 1'b0 ;
  	HSEL_Slave1 = 1'b0 ;
  	HSEL_Slave2 = 1'b0 ;
  	HSEL_Slave3 = 1'b0 ;
  	HSEL_Slave4 = 1'b0 ;
  	HSEL_Slave5 = 1'b0 ;
  	HSEL_Slave6 = 1'b0 ;	
  	HSEL_Slave7 = 1'b0 ;	
	
    if (!HRESETn)
      HSELDefault = 1'b1;      //  Reset (Default Slave)
    else
    begin
          case (HADDR[31:27])
        5'b00000 :
			HSEL_Slave1 = 1'b1;
 
        5'b00100 :
			HSEL_Slave2 = 1'b1;    //  Tube
		5'b00110 :
			HSEL_Slave3 = 1'b1;   	//    testSlave
			
		5'b01000 :
			HSEL_Slave4 = 1'b1;   	//External RAM	
			
		5'b01010 :
		  begin 
			if(HADDR[26:24]==3'b000)
				HSEL_Slave5 = 1'b1;   //    Timer1

			else if(HADDR[26:24]==3'b001)
				HSEL_Slave6 = 1'b1;   //    Timer2

			else if(HADDR[26:24]==3'b111)
				HSEL_Slave7 = 1'b1;   //    IRCntl 	 	 			
		  end
        default  :
          HSELDefault = 1'b1;   //  Undefined (Default Slave)


      endcase
    end
  end
 
endmodule

// --================================= End ===================================--
