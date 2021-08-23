//+FHDR----------------------------------------------------------------
// (C) Copyright CASLab.EE.NCKU
// All Right Reserved
//---------------------------------------------------------------------
// FILE NAME: control_unit.v
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

module  control_unit(
        //-------------------------------------------------------------
        //  AHB Interface
        //-------------------------------------------------------------
        UI_SEL,
        UI_ADDR,
        UI_WRITE,
        UI_BE,
        UI_INFO,
        UI_WDATA,
        UI_READY,
        UI_ERROR,
        UI_RDATA,
        //-------------------------------------------------------------
        //  SRAM Interface
        //-------------------------------------------------------------
        SRAM_ADDR,
        SRAM_DIN,
        SRAM_WE,
        SRAM_DOUT
        );

    //-----------------------------------------------------------------
    //  AHB Interface
    //-----------------------------------------------------------------
    input           UI_SEL;
    input   [31:0]  UI_ADDR;
    input           UI_WRITE;
    input   [3:0]   UI_BE;
    input   [2:0]   UI_INFO;
    input   [31:0]  UI_WDATA;
    output          UI_READY;
    output          UI_ERROR;
    output  [31:0]  UI_RDATA;

    //-----------------------------------------------------------------
    //  SRAM Interface
    //-----------------------------------------------------------------
    output  [14:0]  SRAM_ADDR;
    output  [31:0]  SRAM_DIN;
    output  [3:0]   SRAM_WE;
    input   [31:0]  SRAM_DOUT;

//---------------------------------------------------------------------
// Internal signal or Parameter declarations
//---------------------------------------------------------------------
    wire            error;

//=====================================================================
//      Main Body
//=====================================================================

    //out of range (1MB)
    assign  error = (UI_ADDR[31:20]==12'b0) ? 1'b0 : 1'b1 ;

    //-----------------------------------------------------------------
    //  AHB Interface
    //-----------------------------------------------------------------
    assign  UI_READY = ((UI_ADDR==32'h0000_0000)|~(SRAM_DOUT==32'hEA000006))? 1'b1: 1'b0 ;
    assign  UI_RDATA = SRAM_DOUT;
    assign  UI_ERROR = error;

    //-----------------------------------------------------------------
    //  SRAM Interface
    //-----------------------------------------------------------------
    assign  SRAM_ADDR = UI_ADDR[14:2];
    assign  SRAM_DIN = UI_WDATA;
    assign  SRAM_WE = ( UI_SEL & UI_WRITE & (~error) ) ? UI_BE : 4'b0000;


endmodule