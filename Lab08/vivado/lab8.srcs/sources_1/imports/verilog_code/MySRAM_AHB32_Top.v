//+FHDR----------------------------------------------------------------
// (C) Copyright CASLab.EE.NCKU
// All Right Reserved
//---------------------------------------------------------------------
// FILE NAME: MySRAM_AHB32_Top.v
// AUTHOR: Chen-Chieh Wang
// CONTACT INFORMATION: ccwang@mail.ee.ncku.edu.tw
//---------------------------------------------------------------------
// RELEASE VERSION: 1.0.0
// VERSION DESCRIPTION: First Edition no errata
//---------------------------------------------------------------------
// RELEASE: 2009/2/5 PM. 05:43:22
//---------------------------------------------------------------------
// PURPOSE:
//-FHDR----------------------------------------------------------------

// synopsys translate_off
//`include "timescale.v"
// synopsys translate_on
  `define TRN_IDLE   2'b00
  `define TRN_BUSY   2'b01
  `define TRN_NONSEQ 2'b10
  `define TRN_SEQ    2'b11
 
// HRESP transfer response signal encoding
  `define RSP_OKAY  2'b00
  `define RSP_ERROR 2'b01
  `define RSP_RETRY 2'b10
  `define RSP_SPLIT 2'b11
  
  // HBURST transfer type signal encoding
  `define BUR_SINGLE 3'b000
  `define BUR_INCR   3'b001
  `define BUR_WRAP4  3'b010
  `define BUR_INCR4  3'b011
  `define BUR_WRAP8  3'b100
  `define BUR_INCR8  3'b101
  `define BUR_WRAP16 3'b110
  `define BUR_INCR16 3'b111
  
  // HSIZE transfer type signal encoding
  `define SZ_BYTE    3'b000
  `define SZ_HALF    3'b001
  `define SZ_WORD    3'b010

module  MySRAM_AHB32_Top(
        //-------------------------------------------------------------
        //  AHB Bus Interface - Input Signals
        //-------------------------------------------------------------
        HSELx,          //Select
        HADDR,          //Address
        HWRITE,         //Control
        HTRANS,         //Control
        HSIZE,          //Control
        HBURST,         //Control
        HREADY_in,      //Control
        HWDATA,         //Data
        HRESETn,        //Reset
        HCLK,           //Clock
        //HMASTER,      //Split-capable slave only (option)
        //HMASTLOCK,    //Split-capable slave only (option)
        //-------------------------------------------------------------
        //  AHB Bus Interface - Output Signals
        //-------------------------------------------------------------
        HREADY_out,     //Transfer response
        HRESP,          //Transfer response
        HRDATA_MEM          //Data
        //HSPLITx,      //Split-capable slave only (option)
        );

    //-----------------------------------------------------------------
    //  AHB Bus Interface - Input Signals
    //-----------------------------------------------------------------
    input           HSELx;      //Select
    input   [31:0]  HADDR;      //Address
    input           HWRITE;     //Control
    input   [1:0]   HTRANS;     //Control
    input   [2:0]   HSIZE;      //Control
    input   [2:0]   HBURST;     //Control
    input           HREADY_in;  //Control
    input   [31:0]  HWDATA;     //Data
    input           HRESETn;    //Reset
    input           HCLK;       //Clock
    //input [3:0]   HMASTER;    //Split-capable slave only (option)
    //input         HMASTLOCK;  //Split-capable slave only (option)

    //-----------------------------------------------------------------
    //  AHB Bus Interface - Output Signals
    //-----------------------------------------------------------------
    output          HREADY_out; //Transfer response
    output  [1:0]   HRESP;      //Transfer response
    output  [31:0]  HRDATA_MEM;     //Data
    //output[15:0]  HSPLITx;    //Split-capable slave only (option)


//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

    //-----------------------------------------------------------------
    //  AHB Interface
    //-----------------------------------------------------------------
    wire            UI_SEL;     //Select
    wire    [31:0]  UI_ADDR;    //Address
    wire            UI_WRITE;   //Control
    wire    [3:0]   UI_BE;      //Control (Byte Enable)
    wire    [2:0]   UI_INFO;    //Control {HBURST[2:0]}
    wire    [31:0]  UI_WDATA;   //Data
    wire            UI_READY;   //Transfer response
    wire            UI_ERROR;   //Transfer response
    wire    [31:0]  UI_RDATA;   //Data

    //-----------------------------------------------------------------
    //  SRAM Interface
    //-----------------------------------------------------------------
    wire    [14:0]  SRAM_ADDR;
    wire    [31:0]  SRAM_DIN;
    wire    [3:0]   SRAM_WE;
    wire    [31:0]  SRAM_DOUT;


//=====================================================================
//      AHB Slave
//=====================================================================

    //initial $sdf_annotate("SlaveWrapper.sdf", u_Slave1) ;

    SlaveWrapper
        u_Slave(
         //------------------------------------------------------------
         //  AHB Bus Interface - Input Signals
         //------------------------------------------------------------
         .HSELx         (HSELx),        //Select
         .HADDR         (HADDR),//Address
         .HWRITE        (HWRITE),       //Control
         .HTRANS        (HTRANS),       //Control
         .HSIZE         (HSIZE),        //Control
         .HBURST        (HBURST),       //Control
         .HREADY_in     (HREADY_in),    //Control
         .HWDATA        (HWDATA),       //Data
         .HRESETn       (HRESETn),      //Reset
         .HCLK          (HCLK),         //Clock
         //.HMASTER     (HMASTER),      //Split-capable slave only
         //.HMASTLOCK   (HMASTLOCK),    //Split-capable slave only
         //------------------------------------------------------------
         //  AHB Bus Interface - Output Signals
         //------------------------------------------------------------
         .HREADY_out    (HREADY_out),   //Transfer response
         .HRESP         (HRESP),        //Transfer response
         .HRDATA        (HRDATA_MEM),       //Data
         //.HSPLITx     (HSPLITx),      //Split-capable slave only
         //------------------------------------------------------------
         //  User Interface - Output Signals
         //------------------------------------------------------------
         .UI_SEL        (UI_SEL),       //Select
         .UI_ADDR       (UI_ADDR),      //Address
         .UI_WRITE      (UI_WRITE),     //Control
         .UI_BE         (UI_BE),        //Control (Byte Enable)
         .UI_INFO       (UI_INFO),      //Control {HBURST[2:0]}
         .UI_WDATA      (UI_WDATA),     //Data
         //------------------------------------------------------------
         //  User Interface - Input Signals
         //------------------------------------------------------------
         .UI_READY      (UI_READY),     //Transfer response
         .UI_ERROR      (UI_ERROR),     //Transfer response
         .UI_RDATA      (UI_RDATA)      //Data
        );

//=====================================================================
//      Control Unit
//=====================================================================

    control_unit
        u_cu(
         //AHB Interface
         .UI_SEL        (UI_SEL),       //Select
         .UI_ADDR       (UI_ADDR),      //Address
         .UI_WRITE      (UI_WRITE),     //Control
         .UI_BE         (UI_BE),        //Control (Byte Enable)
         .UI_INFO       (UI_INFO),      //Control {HBURST[2:0]}
         .UI_WDATA      (UI_WDATA),     //Data
         .UI_READY      (UI_READY),     //Transfer response
         .UI_ERROR      (UI_ERROR),     //Transfer response
         .UI_RDATA      (UI_RDATA),     //Data
         //SRAM Interface
         .SRAM_ADDR     (SRAM_ADDR),
         .SRAM_DIN      (SRAM_DIN),
         .SRAM_WE       (SRAM_WE),
         .SRAM_DOUT     (SRAM_DOUT)
        );

//=====================================================================
//      SRAM Behavioral Module
//=====================================================================
	blk_mem_gen_0
		u_block_mem (
			.clka(HCLK),
			.wea(SRAM_WE), // Bus [3 : 0] 
			.addra(SRAM_ADDR), // Bus [14 : 0] 
			.dina(SRAM_DIN), // Bus [31 : 0] 
			.douta(SRAM_DOUT) // Bus [31 : 0] 
			);


endmodule


