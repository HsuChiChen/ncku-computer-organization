//+FHDR----------------------------------------------------------------
// (C) Copyright CASLab.EE.NCKU
// All Right Reserved
//---------------------------------------------------------------------
// FILE NAME: define.v
// AUTHOR: Chen-Chieh Wang
// CONTACT INFORMATION: ccwang@mail.ee.ncku.edu.tw
//---------------------------------------------------------------------
// RELEASE VERSION: 1.1.0
// VERSION DESCRIPTION: First Edition no errata
//---------------------------------------------------------------------
// RELEASE: 2008/1/7 12:29¤U¤È
//---------------------------------------------------------------------
// PURPOSE:
//-FHDR----------------------------------------------------------------

// HTRANS transfer type signal encoding
    `define TRN_IDLE    2'b00
    `define TRN_BUSY    2'b01
    `define TRN_NONSEQ  2'b10
    `define TRN_SEQ     2'b11

// HSIZE transfer type signal encoding
    `define SZ_BYTE     3'b000
    `define SZ_HALF     3'b001
    `define SZ_WORD     3'b010

// HRESP transfer response signal encoding
    `define RSP_OKAY    2'b00
    `define RSP_ERROR   2'b01
    `define RSP_RETRY   2'b10
    `define RSP_SPLIT   2'b11

// HBURST transfer type signal encoding
    `define BUR_SINGLE  3'b000
    `define BUR_INCR    3'b001
    `define BUR_WRAP4   3'b010
    `define BUR_INCR4   3'b011
    `define BUR_WRAP8   3'b100
    `define BUR_INCR8   3'b101
    `define BUR_WRAP16  3'b110
    `define BUR_INCR16  3'b111


