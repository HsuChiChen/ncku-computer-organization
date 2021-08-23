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
//  File Name : easyfile.v",v
//  File Revision : 1.0
//
//  Release Information : 
//  
//  ----------------------------------------------------------------------------
// Revision History    : Revision 1.0  2005/10/25 14:23 Tai-Hua Lu
//			 Initial revision
//  --========================================================================--

//====================================================
// Design files
//====================================================
//`timescale 1ns / 1ps
//`define MVP
//`define DEBUG
//`define SBST_Kernel
`define MISR

`define stopconf 1'b0

`define stopaddr 32'hc0109378

`define stoppid 1'b0

//`define restart
`define restartaddr 32'hc000c5b0

//`define IRQ_Disable
`define Start_IRQ_PC 32'hc0109378

//`define SRAM


// --================================= End ===================================--
