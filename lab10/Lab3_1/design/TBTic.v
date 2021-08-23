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
//  File Name : TBTic.v,v
//  File Revision : 1.4
//  
//  Release Information : AUK-REL1v0
//  
//  ----------------------------------------------------------------------------
//  Purpose             : Test bench to test the EASY microcontroller through
//                        the TIC interface.
//  --========================================================================--
`timescale 1ns/1ps

//`define SYN
`define SBST

`include "./design/EASY/EASY.v"
`include "./design/EASY/Arbiter.v"
`include "./design/EASY/Decoder.v"
`include "./design/EASY/DefaultSlave.v"
`include "./design/EASY/IntMem.v"
`include "./design/EASY/ExtMem.v"
`include "./design/EASY/MuxM2S.v"
`include "./design/EASY/MuxS2M.v"
`include "./design/EASY/Tube.v"
`include "./design/testSlave/testMISRreg.v"
`include "./design/testSlave/testMISRSlave_top.v"
`include "./design/testSlave/testMISRWrapper.v"
`include "./design/Timer/Timers.v"
`include "./design/Timer/TimersSlave_top.v"
`include "./design/Timer/TimersWrapper.v"
`include "./design/IRCntl/IRCntl.v"
`include "./design/IRCntl/IRCntlSlave_top.v"
`include "./design/IRCntl/IRCntlWrapper.v"


//====================================================
// Cache parameter
//====================================================
//`include "./design/Core/parameter.v"

//====================================================
// Design files
//====================================================
/*
`include "./design/Core/RISC32.v"
`include "./design/Core/TestShell/TShell.v"
`include "./design/Core/misr/MISRreg.v"
`include "./design/Core/misr/MISRSlave_top.v"
`include "./design/Core/misr/MISRWrapper.v"
`include "./design/Core/IntegerCore/IntegerCore.v"
`ifndef SYN
`include "./design/Core/IntegerCore/model05.v"
`include "./design/Core/IntegerCore/controller.v"
`include "./design/Core/IntegerCore/instruction_fetch.v"
`include "./design/Core/IntegerCore/forwarding_unit.v"   
`include "./design/Core/IntegerCore/hazard_detection_unit.v"
`include "./design/Core/IntegerCore/memory_access_unit.v"
`include "./design/Core/IntegerCore/memory_read_unit.v"
`include "./design/Core/IntegerCore/psr_status.v"
`include "./design/Core/IntegerCore/alu_op.v"
`include "./design/Core/IntegerCore/barrel_shift.v"
`include "./design/Core/IntegerCore/condition_code_check.v"  
`include "./design/Core/IntegerCore/exe_bypassing.v"
`include "./design/Core/IntegerCore/exception_handler.v"
`include "./design/Core/IntegerCore/coprocessor_unit.v"
`include "./design/Core/IntegerCore/coprocessor_access_unit.v"
`include "./design/Core/IntegerCore/general_regs.v"
`else
`include "./design/tsmc90.v"
`include "./design/model05_syn.v"
`endif
`include "./design/Core/MemorySystem/memorysystem.v"
`include "./design/Core/MemorySystem/FCSE/FCSE.v"
`include "./design/Core/MemorySystem/EXT/EXT.v"
`include "./design/Core/MemorySystem/Wrapper/Wraper.v"
`include "./design/Core/MemorySystem/CP15/CP15.v"
`include "./design/Core/MemorySystem/CP15/CopInterface.v"
`include "./design/Core/MemorySystem/CP15/CP15_Reg.v"
`include "./design/Core/MemorySystem/others/nWAIT_Hub.v"
`include "./design/Core/MemorySystem/others/PipelineReg.v"
`include "./design/Core/MemorySystem/others/Route.v"
`include "./design/Core/MemorySystem/others/WFI.v"
`include "./design/Core/MemorySystem/WriteBuffer/Write_Buffer_Unit.v"
`include "./design/Core/MemorySystem/WriteBuffer/Write_Buffer_Addr_unit.v"
`include "./design/Core/MemorySystem/WriteBuffer/Write_Buffer_Status_unit.v"
`include "./design/Core/MemorySystem/WriteBuffer/Write_Buffer_Data_unit.v"
`include "./design/Core/MemorySystem/WriteBuffer/Write_Buffer_Controller.v"
`include "./design/Core/MemorySystem/WriteBuffer/behavioural/Write_Buffer_AddrRAM.v"
`include "./design/Core/MemorySystem/WriteBuffer/behavioural/Write_Buffer_DataRAM.v"
`include "./design/Core/MemorySystem/WriteBuffer/behavioural/Write_Buffer_StatusRAM.v"
`include "./design/Core/MemorySystem/Cache/Common/Address_phase_MUX.v"
`include "./design/Core/MemorySystem/Cache/Common/Cache_bank.v"
`include "./design/Core/MemorySystem/Cache/Common/Comparison.v"
`include "./design/Core/MemorySystem/Cache/Common/Data_phase_Valid_MUX.v"
`include "./design/Core/MemorySystem/Cache/Common/MVA_Reg.v"
`include "./design/Core/MemorySystem/Cache/Common/TAG_unit.v"
`include "./design/Core/MemorySystem/Cache/Common/Valid_unit.v"
`include "./design/Core/MemorySystem/Cache/behavioural/CacheRAM.v"
`include "./design/Core/MemorySystem/Cache/behavioural/DirtyRAM.v"
`include "./design/Core/MemorySystem/Cache/behavioural/PA_TAGRAM.v"
`include "./design/Core/MemorySystem/Cache/behavioural/TAGRAM.v"
`include "./design/Core/MemorySystem/Cache/behavioural/ValidRAM.v"
`include "./design/Core/MemorySystem/Cache/ICache/Direct_Map_I_Cache.v"
`include "./design/Core/MemorySystem/Cache/ICache/Direct_Map_ICache_Controller.v"
`include "./design/Core/MemorySystem/Cache/ICache/ICache.v"
`include "./design/Core/MemorySystem/Cache/ICache/ILine_fill_unit.v"
`include "./design/Core/MemorySystem/Cache/ICache/Value_unit.v"
`include "./design/Core/MemorySystem/Cache/DCache/Data_phase_Dirty_MUX.v"
`include "./design/Core/MemorySystem/Cache/DCache/Data_phase_Value_MUX.v"
`include "./design/Core/MemorySystem/Cache/DCache/DCache.v"
`include "./design/Core/MemorySystem/Cache/DCache/Direct_Map_D_Cache.v"
`include "./design/Core/MemorySystem/Cache/DCache/Direct_Map_DCache_Controller.v"
`include "./design/Core/MemorySystem/Cache/DCache/Dirty_unit.v"
`include "./design/Core/MemorySystem/Cache/DCache/DLine_fill_unit.v"
`include "./design/Core/MemorySystem/Cache/DCache/DValue_unit.v"
`include "./design/Core/MemorySystem/Cache/DCache/Entry_MVA_Index_MUX.v"
`include "./design/Core/MemorySystem/Cache/DCache/PA_TAG_unit.v"
`include "./design/Core/MemorySystem/MMU/MMU/MMU.v"
`include "./design/Core/MemorySystem/MMU/MMU/MVA_selection_unit.v"
`include "./design/Core/MemorySystem/MMU/MMU/Protection_unit.v"
`include "./design/Core/MemorySystem/MMU/MMU/Table_Walking_unit.v"
`include "./design/Core/MemorySystem/MMU/MMU/TLB_Pipeline_Reg.v"
`include "./design/Core/MemorySystem/MMU/MMU/VAtoPA_unit.v"
`include "./design/Core/MemorySystem/MMU/TLB/TLB.v"
`include "./design/Core/MemorySystem/MMU/TLB/TLB_Comparison.v"
`include "./design/Core/MemorySystem/MMU/TLB/TLB_Controller.v"
`include "./design/Core/MemorySystem/MMU/TLB/TLB_operation_MUX.v"
`include "./design/Core/MemorySystem/MMU/TLB/TLB_TAG_unit.v"
`include "./design/Core/MemorySystem/MMU/TLB/TLB_Valid_MUX.v"
`include "./design/Core/MemorySystem/MMU/TLB/TLB_Valid_unit.v"
`include "./design/Core/MemorySystem/MMU/TLB/TLB_Value_unit.v"
`include "./design/Core/MemorySystem/MMU/behavioural/TLB_TAGRAM.v"
`include "./design/Core/MemorySystem/MMU/behavioural/TLB_ValidRAM.v"
`include "./design/Core/MemorySystem/MMU/behavioural/TLB_ValueRAM.v"
*/
// --================================= End ===================================--

module TBTic;

//-----------------------------------------------------------------------------
// Constant and Signal Declarations
//-----------------------------------------------------------------------------
// The following default frequency settings are specified. The required clock
//  period should be uncommented for use, or a new frequency specified. This
//  setting will depend on the operating frequency of the core used in the
//  system.

parameter PERIOD = 10; // 100.0 MHz
parameter PHASETIME = (PERIOD)/2;

integer i,j,fp1,fp2,off; // Used in generation of nReset

reg XCLKIN,nReset;
/*
reg fiq_n;
reg irq_n;
*/

//==============================================================
integer half_cycles,cycles,fp;
//==============================================================

//-----------------------------------------------------------------------------
// Re-define Parameter
//-----------------------------------------------------------------------------  
// Memory size in Kbytes, set to 64 MB
defparam uEASY.uIntMem_1.MemSize  = 1024*64;         

// Input filename
defparam uEASY.uIntMem_1.FileName = "./testcode/testcode.txt";

// Memory size in Kbytes, set to 32 kB
defparam uEASY.uExtMem.MemSize  = 32;         

// Input filename
defparam uEASY.uExtMem.FileName = "";

`ifdef SYN
initial $sdf_annotate( "./design/model05_syn.sdf", uEASY.uRISC32.uEASY.uRISC32.uIntegerCore.umodel05);   
`endif
//defparam uEASY.uIntMem_1.FileName = "code.mif";


//-----------------------------------------------------------------------------
// Beginning of main code
//-----------------------------------------------------------------------------

  EASY uEASY (
    .HCLK   (XCLKIN), // External clock in
    .HRESETn   (nReset)  // Power on reset input
    );
/*
  Tube uTube (
    .XD   (XD),   		// External data bus
    .XCSN (XCSN), 		// External chip enable
    .XWEN (XWEN)  		// External write enable
    );
*/
// TB_assertion uTB_assertion();
// This controls the clock generation for the system
  initial
    XCLKIN = 1; // Start clock from LOW

//=======================================================================    
  //initial fp5=  $fopen("out_reg.txt");

  always @(negedge XCLKIN) begin
      cycles = cycles + 1;
   end

  always @(posedge XCLKIN or negedge XCLKIN) begin
      half_cycles= half_cycles+1;
  end
  
  
   initial begin

//	  rst = `YES;
     @ (posedge XCLKIN)
	  #1
	  half_cycles = 0;
    //      FIQ_from_MMU = `NO;
    //      IRQ_from_MMU = `NO;
     @ (posedge XCLKIN)
     @ (posedge XCLKIN)
          #1
//          nReset = `NO;
	  cycles = 0;
   end

//=======================================================================

  always
    #PHASETIME XCLKIN = ~XCLKIN;
/* 
  initial fork 
      fiq_n=1'b1;
      irq_n=1'b1;
   join
*/
// This controls the timing of the nReset signal.
// The loop values should be changed for different reset timing.
  initial
  begin
    nReset = 1;
    for (i = 0; i < 10; i = i + 1)
      @(XCLKIN);
    nReset = 0;

    for (i = 0; i < 10; i = i + 1)
      @(XCLKIN);
    nReset = 1;
  end
/*
  initial fp=  $fopen("testing.txt","w");
 
  
  always @(posedge XCLKIN or negedge XCLKIN ) 
  begin
      if (half_cycles >= 1 ) 
      begin        
          $fwrite(fp,"%d %h %h %h %h %h %b %b %b %b %b %b %b %b %b %b\n" ,half_cycles,uEASY.uRISC32.uIntegerCore.ID,
          uEASY.uRISC32.uIntegerCore.DDIN,uEASY.uRISC32.uIntegerCore.CHSDE,uEASY.uRISC32.uIntegerCore.CHSEX,uEASY.uRISC32.uIntegerCore.CPDIN,uEASY.uRISC32.uIntegerCore.clk,
          uEASY.uRISC32.uIntegerCore.rst_n,uEASY.uRISC32.uIntegerCore.nWAIT,uEASY.uRISC32.uIntegerCore.IABORT,uEASY.uRISC32.uIntegerCore.DABORT,uEASY.uRISC32.uIntegerCore.BIGEND,
          uEASY.uRISC32.uIntegerCore.HIVECS,uEASY.uRISC32.uIntegerCore.nfiq,uEASY.uRISC32.uIntegerCore.nirq,uEASY.uRISC32.uIntegerCore.CPEN);//
      end      
  end
  */
endmodule

// --================================= End ===================================--
