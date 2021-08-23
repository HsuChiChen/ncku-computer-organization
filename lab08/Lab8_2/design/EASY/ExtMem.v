//  --========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//  ----------------------------------------------------------------------------
//  Version and Release Control Information:
//
//  File Name : IntMem.v,v
//  File Revision : 1.4
//  
//  Release Information : AUK-REL1v0
//
//  ----------------------------------------------------------------------------
//  Purpose             : Internal memory, 32 bits wide, little endian,
//                        configurable size (default 1Kbyte), single wait state.
//                        This is a behavioral Verilog model, and not
//                        representative of a real on-chip SRAM.
//                        Reads in a Verilog $readmemh format intram.dat file.
//  --========================================================================--
`timescale 1ns / 1ps

module ExtMem(HCLK, HRESETn, HADDR, HTRANS, HWRITE, HSIZE, HWDATA, HSEL,
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
// Default memory size and input filename settings
//------------------------------------------------------------------------------
  parameter MemSize  = 1;            // Memory size in Kbytes
  parameter FileName = ""; // Input filename
  parameter BaseAddr = 32'h4000_0000 ;

//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

  reg  [31:0] Mem [0:((MemSize * 256)-1)]; // Memory register array

  reg         HselReg;  // HSEL register
  wire        RegValid; // Shows module selected, transfer is nseq/seq

  wire        ACRegEn;  // Enable for address and control registers
  reg  [31:0] HaddrReg;
  reg   [1:0] HtransReg;
  reg         HwriteReg;
  reg   [2:0] HsizeReg;

  reg  [31:0] Data;     // Output data
  reg  [31:0] MemAddr;  // Padded memory address
  reg  [31:0] HrdataInt;   // Registered output signal
  
  reg	  [2:0] waitcycle;
  

  integer i; // Loop counter used in memory initialisation

//------------------------------------------------------------------------------
// Initialise Memory (only once)
//------------------------------------------------------------------------------

  initial
  begin
    $display("### Loading External memory, Based Addr = 0x%x, Length = 0x%x ###",BaseAddr,MemSize*1024);
    for (i=0; i<=((MemSize * 256)-1); i = i+1)
      Mem[i] = 32'h0000_0000;
    if (FileName != "")
    begin
      $readmemh(FileName, Mem);
    end
    $display("### Load internal memory Complete ###");
  end

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Valid transfer detection
//------------------------------------------------------------------------------
// The slave must only respond to a valid transfer, so this must be detected.
 
  always @(negedge (HRESETn) or posedge (HCLK))
  begin
    if (!HRESETn)
      HselReg <= 1'b0;
    else
    begin
      if (HREADYin)
        HselReg <= HSEL;
    end
  end
 
//  Valid AHB transfers only take place when a non-sequential or sequential
//   transfer is shown on HTRANS - an idle or busy transfer should be ignored.

  assign RegValid = (HselReg == 1'b1 && (HtransReg == `TRN_NONSEQ ||
                                         HtransReg == `TRN_SEQ)) ? 1'b1 :
                    1'b0;

//------------------------------------------------------------------------------
// Address and control registers
//------------------------------------------------------------------------------
// Registers are used to store the address and control signals from the address
//  phase for use in the data phase of the transfer.
// Only enabled when the HREADYin input is HIGH and the module is addressed.

  assign ACRegEn = HSEL & HREADYin;

  always @(negedge (HRESETn) or posedge (HCLK))
  begin
    if (!HRESETn)
    begin
      HaddrReg  <= 32'h0000_0000;
      HtransReg <= 2'b00;
      HwriteReg <= 1'b0;
      HsizeReg  <= 3'b000;
    end
    else
    begin
      if (ACRegEn)
      begin
        HaddrReg  <= HADDR - BaseAddr ;
        HtransReg <= HTRANS;
        HwriteReg <= HWRITE;
        HsizeReg  <= HSIZE;
      end
    end
  end

//------------------------------------------------------------------------------
//  Memory read and write
//------------------------------------------------------------------------------
// The read data is generated by converting the current byte address into a word
//  address, and then reading the data value from Mem at that address.
// A write is performed by first reading the entire word from memory. Then the
//  appropriate bytes of the word are changed before writing back the entire 
//  word.
// Since both a memory read and write operation require the data at the current
//  address to be read from the memory, then this common section of code can be
//  used by both operations.

// NOTE - this module is little endian, and must be modified for a big endian
//        system.

  always @(RegValid or HaddrReg or HCLK)
  begin
    if (RegValid) // Common to read and write operations
    begin
      MemAddr = {2'b00, HaddrReg[31:2]}; // Word address (not byte)
      Data    = Mem[MemAddr];

      @(posedge HCLK)           // Write-only section performed on the rising
      if (HwriteReg & RegValid) //  edge of the clock.
      begin
        case (HsizeReg)

          `SZ_BYTE :                // Byte access
            case (HaddrReg[1:0])
              2'b00   : Data[7:0]   = HWDATA[7:0];
              2'b01   : Data[15:8]  = HWDATA[15:8];
              2'b10   : Data[23:16] = HWDATA[23:16];
              default : Data[31:24] = HWDATA[31:24];
            endcase

          `SZ_HALF :                // Halfword access
            case (HaddrReg[1])
              1'b0    : Data[15:0]  = HWDATA[15:0];
              default : Data[31:16] = HWDATA[31:16];
            endcase

          default :                // Word access
            Data = HWDATA;

        endcase
        Mem[MemAddr] = Data;
      end
    end
  end

//------------------------------------------------------------------------------
// Output Drivers
//------------------------------------------------------------------------------
// Drive output data bus during read operation

  always @(RegValid or HwriteReg or Data)
  begin
    if (RegValid & ~HwriteReg)
      HrdataInt = Data;
    else
      HrdataInt = 32'h0000_0000;
  end
  
  always@(posedge HCLK)
  begin
  	if (!HRESETn)
  		waitcycle<=3'b000;
  	else
  	begin
  		if ( ACRegEn )
  			waitcycle<=3'b001;
  		else
  			waitcycle<= waitcycle << 1 ;
  	end
  end

// A 2 ns delay has been added to create a more realistic memory model, and to
//  ensure that data reads from memory do not violate the data input hold time
//  on the system ARM CPU.
// This delay value may need changing depending on the clock frequency of the
//  system.

  assign HRDATA = HrdataInt;

// No wait states are inserted by this memory model, so HREADYout can be driven
//  HIGH all of the time.

  //assign HREADYout = waitcycle[2] ;
  assign HREADYout = 1'b1 ;

// The response will always be OKAY to show that the transfer has been performed
//  successfully.

  assign HRESP = `RSP_OKAY;


endmodule

// --================================= End ===================================--
