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

// ----------------------------------------------------------------------------
//AllRAM parameter                                                           
// ----------------------------------------------------------------------------
`define RAMDEPTH 4
`define ADDRWIDTH 2
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

