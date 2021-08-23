//  --========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from NCKU & AMIT Limited
//    (C) COPYRIGHT 2003 NCKU & AMIT Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from NCKU & AMIT Limited.
//  
//  ----------------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name : Tube.v,v
//  File Revision : 1.0
//
//  Release Information : 
//  
//  ----------------------------------------------------------------------------
//  Purpose             : Tube model for system messages
//  --========================================================================--

// synopsys translate_off
//`include "../tbench/timescale.v"
// synopsys translate_on

//20070412: York : modify to print right newline in windows

module Tube(HCLK, HRESETn, HADDR, HTRANS, HWRITE, HSIZE, HWDATA, HSEL,
              HREADYin, HRDATA, HREADYout, HRESP);

  input         HCLK;
  input         HRESETn;
  input  [31:0] HADDR;
  input   [1:0] HTRANS;
  input         HWRITE;
  input   [2:0] HSIZE;
  input  [31:0] HWDATA;
  input         HSEL;
  input         HREADYin;

  output [31:0] HRDATA;
  output        HREADYout;
  output  [1:0] HRESP;

//------------------------------------------------------------------------------
//  Constant declarations
//------------------------------------------------------------------------------

// HRESP transfer response signal encoding
  `define RSP_OKAY   2'b00
  `define RSP_ERROR  2'b01
  `define RSP_RETRY  2'b10
  `define RSP_SPLIT  2'b11
  `define	coreone 	 2'h1
  `define	coretwo 	 2'h2
  
//-----------------------------------------------------------------------------
// Constant declarations
//-----------------------------------------------------------------------------
// Control characters that are fed into the TUBE to control the output text.
  parameter CR    = 13; // Carriage Return
  parameter LF    = 10; // Line Feed
  parameter CTRLD =  4; // Program exit
  
  reg         HselReg;  // HSEL register
  reg  [31:0] HADDRReg;

//-----------------------------------------------------------------------------
// Signal declarations
//-----------------------------------------------------------------------------
  integer          i;                 // Used as loop value
  integer          Outfile;           // Output file reference value
  integer          Outbinfile;           // Output file reference value
  reg [7:0]        DataVal;           // Input TUBE character value
  integer          StringLength;      // TUBE data length
  integer          j;
  reg [(8*80)-1:0] TubeString;        // TUBE data
  reg              PosedgeXwen0;
  event            PosedgeXwen0Event; // posedge XWEN[0] event
  
  reg	[4:0]      counter;
  reg			   stop;
  
//-----------------------------------------------------------------------------
// Beginning of main code
//-----------------------------------------------------------------------------
	
  assign HRDATA = 32'b0;
  assign HREADYout = 1'b1;
  assign HRESP = `RSP_OKAY;

  always @(posedge (HCLK))
  begin
    if (!HRESETn)
    begin
      HselReg <= 1'b0;
      HADDRReg <= 32'h0 ;
      stop <= 1'b0 ;
    end
    else
    begin
      if (HREADYin)
      begin
        HselReg <= HSEL;
        HADDRReg <= HADDR ;
      end
      
      if ( HSEL == 1'b1 )
      begin
      	if ( HADDR[7:0] == 8'h04 )
      		stop <= 1'b1 ;
      		
      end
    end
  end  

//-----------------------------------------------------------------------------
// Tube Model
//-----------------------------------------------------------------------------

// Set up the file output variables
  initial
  begin
    Outfile = $fopen("Tube.txt");    // TUBE output file
    Outbinfile = $fopen("Tubebin.txt");    // TUBE output file
    counter = 0 ;
    DataVal = 0;
    StringLength = 0;
    for (j = 0; j < 8*80; j = j + 1) // Initialise output string to zero
       TubeString[j] = 1'b0;
  end

// Used to trigger event on posedge XWEN[0]
  always @(posedge HCLK)
  begin
     if ( HselReg )
     begin
     	if ( HADDRReg[7:0] == 8'h00 )
     	begin
     		$fwrite(Outbinfile, "%2h", HWDATA[7:0]);

     		if ( counter != 15 )
     			counter <= counter + 1 ;
     		else
     		begin
     			counter <= 0 ;
     			$fwrite(Outbinfile, "\n");
     		end     		
     		
     	end
     	
     	PosedgeXwen0 = 1'b1;
     	-> PosedgeXwen0Event;
     end
  end

// Triggered on posedge XWEN[0]
  always @(PosedgeXwen0Event)
  begin
      DataVal = HWDATA[7:0];

// Control-D, quit simulation, printing out string first
      if ( stop == 1'b1 )
      begin
        if (StringLength > 0)
        begin
          Display(Outfile, TubeString, StringLength);
        end
        
        $display("TUBE: Program exit");
        $finish;
      end

// Linefeed or carriage return, print output when tube contains data
      else if ((DataVal == LF) || (DataVal == CR))
      begin
        if (StringLength > 0 && HADDRReg[7:0] == 8'h00)
        begin
          Display(Outfile, TubeString, StringLength);
          StringLength = 0;
          for (j = 0; j < 8*80; j = j + 1)
            TubeString[j] = 1'b0;
        end
      end 
// A normal character
      else
      begin
        if ( HADDRReg[7:0] ==8'h00 )
        begin
        	StringLength = StringLength + 1;
        	if (StringLength > 80) // Overflowed buffer, so print it out
        	begin
        	  Display(Outfile, TubeString, StringLength);
        	  StringLength = 0;
        	  TubeString[((8 * 80) - 1):(8 * 79)] = DataVal[7:0];
        	  for (i = (8 * 79) - 1; i > 0; i = i - 1)
        	    TubeString[i] = 1'b0;
        	  end
        	else
        	begin
        	  i = (8 * 80) - (8 * StringLength); 
        	  for (j = 0; j < 8; j = j + 1)
        	  	TubeString[i+j] = DataVal[j];
        	end
       	end
      end
    PosedgeXwen0 = 1'b0;
  end

// Display Task
  task Display;
    input            FilePtr;
    input [1:(8*80)] String;
    input            StrLength;
    integer          i, j, k, FilePtr, StrLength,coreno;
    reg        [0:7] Char;
  begin
    	$write("TUBE: ");
    	
    for (i = 1; i <= (StrLength * 8) ; i = i + 8) 
    begin
      for (j = 0; j <= 7; j = j + 1)
      begin
        k = i + j;
        Char[j] = String[k];
      end
      $write("%s",Char); 
      $fwrite(FilePtr, "%s", Char);
    end
    $write("\n"); // 20070412: added by York to print Newline in Windows
    $fwrite(FilePtr, "\n");
    //$display("");
    //$fdisplay(FilePtr);
  end
  endtask

endmodule

// --================================= End ===================================--
