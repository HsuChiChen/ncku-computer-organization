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


// --========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from CAS LAB, NCKU Limited
//    (C) COPYRIGHT 2005 Computer and System LAB, NCKU Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from CAS LAB, NCKU Limited.
//
// ----------------------------------------------------------------------------
// Purpose             : RAM parameter define
// -----------------------------------------------------------------------------
// Revision History    : Revision 1.0  2011/05/27 17:29 Sheng-Hsin Lo
//  			 Initial revision
// 			 Revision 1.0  2011/05/27 17:29 Sheng-Hsin Lo
// --=========================================================================--
// Modify RAMDEPTH to fit in with your design
// 1 for 32B ; 2 for 64B ; 4 for 128B ; 8 for 256B ; 16 for 512B ;
// 32 for 1KB ; 64 for 2KB ; 128 for 4KB ; 256 for 8KB ;
// MAX RAMDEPTH is 256
// --=========================================================================--


//bit0-1 : byte select
//bit2-4 : cache bank select

//`define syn_rst
`define ASYN

// ----------------------------------------------------------------------------
//AllRAM parameter                                                           
// ----------------------------------------------------------------------------
`ifdef SRAM
    `ifdef Line64
        `define RAMDEPTH 64
    `else
        `define RAMDEPTH 256
    `endif
`else
    `define RAMDEPTH 64
`endif

`define ADDRWIDTH ((`RAMDEPTH>16)?((`RAMDEPTH>64)?((`RAMDEPTH>128)?8:7):((`RAMDEPTH>32)?6:5)):((`RAMDEPTH>4)?((`RAMDEPTH>8)?4:3):((`RAMDEPTH>2)?2:1)))
// ----------------------------------------------------------------------------
//CacheRAM parameter
// ----------------------------------------------------------------------------
`define ValueRAMWIDTH 8

// ----------------------------------------------------------------------------
//DirtyRAM parameter
// ----------------------------------------------------------------------------
`define DirtyRAMWIDTH 1  

// ----------------------------------------------------------------------------
//PATagRAM parameter
// ----------------------------------------------------------------------------
`define PARAMWIDTH 26

// ----------------------------------------------------------------------------
//TagRAM parameter
// ----------------------------------------------------------------------------
`define TAGRAMWIDTH (27-`ADDRWIDTH)

// ----------------------------------------------------------------------------
//ValidRAM parameter
// ----------------------------------------------------------------------------
`define ValidRAMWIDTH 1

`define ADDR_OFFSET 32'h00000004
`define DATA_WIDTH 32
`define DDATA_WIDTH 64
`define DATA_ACCESS_SIZE 2
`define IMMED_WIDTH 32 
`define IMMED_SEL 3
`define REG_ADDR 4
`define PSR_MODE 5 
`define WORD_ZERO 32'b0	
`define SHIFT_IMMED 5
`define SHIFT_TYPE_NUM 2
`define OPERN_ADDR 24
`define CONDITION_CODE 4
`define MASK_FIELD 4

`define EXCEPTION_TYPE 3

`define RST   3'b000
`define I_UND 3'b001
`define SWI   3'b011
`define I_ABT 3'b010
`define D_ABT 3'b110
`define IRQ_E   3'b111
`define FIQ_E   3'b101

`define MSR_TYPE 2
`define PSR_WRITE_DATA_SEL 2

`define MUL_TYPE 2
`define MUL   3'b001
`define MLA   3'b011
`define UMULL 3'b100
`define UMLAL 3'b101
`define SMULL 3'b110
`define SMLAL 3'b111

`define ALU_TYPE_NUM 4 		 //4-bits
`define ALU_OTHER_NUM 4 		 //4-bits
`define ALU_AND 4'b0000
`define ALU_EOR 4'b0001
`define ALU_SUB 4'b0010
`define ALU_RSB 4'b0011
`define ALU_ADD 4'b0100
`define ALU_ADC 4'b0101
`define ALU_SBC 4'b0110
`define ALU_RSC 4'b0111
`define ALU_TST 4'b1000
`define ALU_TEQ 4'b1001
`define ALU_CMP 4'b1010
`define ALU_CMN 4'b1011
`define ALU_ORR 4'b1100
`define ALU_MOV 4'b1101
`define ALU_BIC 4'b1110
`define ALU_MVN 4'b1111

`define USR 5'b10000	 // User and System mode
`define FIQ 5'b10001	 // FIQ mode
`define IRQ 5'b10010	 // IRQ mode
`define SVC 5'b10011	 // Supervisor mode
`define	ABT 5'b10111	 // Abort mode
`define	UND 5'b11011	 // Undefine mode
`define SYS 5'b11111     // System mode

`define FOURTH_SEL 2

`define SHIFT_LSL 2'b00	   //Logicl shift left
`define SHIFT_LSR 2'b01	   //Logicl shift right
`define SHIFT_ASR 2'b10	   //Arithmetic shift right
`define SHIFT_ROR 2'b11	   //Rotate right

`define MULTI_NUMBER 4
`define MULTIPLE_LIST_WIDTH 16
`define MULTI_TYPE 2
`define DA 2'b00
`define IA 2'b01
`define DB 2'b10
`define IB 2'b11

`define HAND_SHAKING_STATE 2
`define ABSENT  2'b10
`define GO      2'b01
`define WAIT_S  2'b00
`define LAST    2'b11

`define FORWARD_SEL_NUM 2

`define WORD_WIDTH 2'b10
`define HWORD_WIDTH 2'b01
`define BYTE_WIDTH 2'b00

`define TRN_IDLE   2'b00
`define TRN_BUSY   2'b01
`define TRN_NONSEQ 2'b10
`define TRN_SEQ    2'b11

`define RSP_OKAY  2'b00
`define RSP_ERROR 2'b01
`define RSP_RETRY 2'b10
`define RSP_SPLIT 2'b11

`define SZ_BYTE    3'b000
`define SZ_HALF    3'b001
`define SZ_WORD    3'b010

