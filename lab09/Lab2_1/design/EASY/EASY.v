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
//  File Name : EASY.v,v
//  File Revision : 1.4
// 
//  Release Information : AUK-REL1v0
//  
//  ----------------------------------------------------------------------------
//  Purpose             : Structural architecture of Example Amba SYstem (EASY)
//  --========================================================================--

`timescale 1ns/1ps

// HTRANS transfer type signal encoding
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

module EASY (
	HCLK,
	HRESETn
//	nFIQ,
//	nIRQ
);

  input         HCLK;   		// External clock in
  input         HRESETn;   	// Power on reset input
  
 // wire 				nFIQ;
  wire 				nIRQ;
	
	
//--------------------------------------
// AHB Signals
//--------------------------------------  
  wire  [1:0] HTRANS;
  wire [31:0] HADDR;
  wire        HWRITE;
  wire  [2:0] HSIZE;
  wire  [2:0] HBURST;
  wire  [3:0] HPROT;
  wire [31:0] HWDATA;

// Multiplexed slave output signals
  wire [31:0] HRDATA;
  wire        HREADY;
  wire  [1:0] HRESP;

// Slave specific output signals


  wire        HSEL_mem;
  wire [31:0] HRDATA_mem;
  wire        HREADY_mem;
  wire  [1:0] HRESP_mem;
	
  wire        HSEL_tube;
  wire [31:0] HRDATA_tube;
  wire        HREADY_tube;
  wire  [1:0] HRESP_tube;

  wire        HSEL_testSlave;
  wire [31:0] HRDATA_testSlave;
  wire        HREADY_testSlave;
  wire  [1:0] HRESP_testSlave;
  
  wire        HSEL_EXmem;
  wire [31:0] HRDATA_EXmem;
  wire        HREADY_EXmem;
  wire  [1:0] HRESP_EXmem;
	
  wire        HSELDefault;
  wire        HREADYDefault;
  wire  [1:0] HRESPDefault;

// Master specific signals
  wire        HGRANTdummy;



  wire [31:0] 	HADDRM_RISC32;
  wire  [1:0] 	HTRANSM_RISC32;
  wire			HWRITEM_RISC32;
  wire  [2:0] 	HSIZEM_RISC32;
  wire  [2:0] 	HBURSTM_RISC32;
  wire  [3:0] 	HPROTM_RISC32;
  wire  [31:0] 	HWDATAM_RISC32;  
  wire			HBUSREQM_RISC32;
  wire 			HLOCKM_RISC32;
  wire        	HGRANTM_RISC32;  


  wire [31:0] HADDRM_testM01;
  wire  [1:0] HTRANSM_testM01;
  wire        HWRITEM_testM01;
  wire  [2:0] HSIZEM_testM01;
  wire  [2:0] HBURSTM_testM01;
  wire  [3:0] HPROTM_testM01;
  wire [31:0] HWDATAM_testM01;
  wire        HBUSREQM_testM01;
  wire        HLOCKM_testM01;
  wire        HGRANTM_testM01;
 
 
  wire [31:0] HADDRM_testM02;
  wire  [1:0] HTRANSM_testM02;
  wire        HWRITEM_testM02;
  wire  [2:0] HSIZEM_testM02;
  wire  [2:0] HBURSTM_testM02;
  wire  [3:0] HPROTM_testM02;
  wire [31:0] HWDATAM_testM02;
  wire        HBUSREQM_testM02;
  wire        HLOCKM_testM02;
  wire        HGRANTM_testM02;
  
  
  wire [31:0] HADDRM_testM03;
  wire  [1:0] HTRANSM_testM03;
  wire        HWRITEM_testM03;
  wire  [2:0] HSIZEM_testM03;
  wire  [2:0] HBURSTM_testM03;
  wire  [3:0] HPROTM_testM03;
  wire [31:0] HWDATAM_testM03;
  wire        HBUSREQM_testM03;
  wire        HLOCKM_testM03;
  wire        HGRANTM_testM03;
  
  
// Arbiter signals
  wire  [4:0] HMASTER;
  wire        HMASTLOCK;
  wire  [4:0] HSPLIT;
  
  
//--------------------------------------
// Tie Off Signals
//--------------------------------------
	wire       	Logic0;
	wire       	Logic1;
	wire 				Pause ;
	wire				Remap ;
	
//--------------------------------------
// Interrupt Signals
//--------------------------------------

wire		Timer1_ACK;


wire		Timer1_IRQ; 

 

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

// Set Signal Tie Offs

  assign Logic0 = 1'b0;
  assign Logic1 = 1'b1;
  assign Pause = Logic0 ;
  assign Remap = Logic0 ;
  
  RISC32 uRISC32 (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),
    
    // Signals from AMBA bus used during normal operation
    .HRDATAM     (HRDATA),
    .HREADYM     (HREADY),
    .HRESPM      (HRESP),
    .HGRANTM     (HGRANTM_RISC32),

    // Signals to AMBA bus used during normal operation
    .HADDRM      (HADDRM_RISC32),
    .HTRANSM     (HTRANSM_RISC32),
    .HWRITEM     (HWRITEM_RISC32),
    .HSIZEM      (HSIZEM_RISC32),
    .HBURSTM     (HBURSTM_RISC32),
    .HPROTM      (HPROTM_RISC32),
    .HWDATAM     (HWDATAM_RISC32),
    .HBUSREQM    (HBUSREQM_RISC32),
    .HLOCKM      (HLOCKM_RISC32),
    
    // Signals from AMBA bus used by MISR
    .HADDRS      (HADDR),
    .HTRANSS     (HTRANS),
    .HWRITES     (HWRITE),
    .HSIZES      (HSIZE),
    .HWDATAS     (HWDATA),
    .HSELS       (1'b0),
    .HREADYS     (HREADY),

    // Signals to AMBA bus used by MISR
    .HRDATAS     (),
    .HREADYOUTS  (),
    .HRESPS      (),

    // RISC32 interrupts
    .RISCNFIQ    (1'b1),
    .RISCNIRQ    (1'b1)
  );
  

	Master01 testMaster01 
	 ( 	.HCLK		(HCLK),
		.HRESETn	(HRESETn),
		.HREADYM	(HREADY),
		.HRESPM	 	(HRESP),
		.HGRANTM	(HGRANTM_testM01),
		
		.HADDRM		(HADDRM_testM01), 
		.HTRANSM	(HTRANSM_testM01),
		.HWRITEM	(HWRITEM_testM01),
		.HSIZEM      (HSIZEM_testM01),		
		.HBURSTM	(HBURSTM_testM01),
		.HPROTM      (HPROTM_testM01),		
        .HWDATAM	(HWDATAM_testM01), 
		.HBUSREQM	(HBUSREQM_testM01)
      );
	
	Master02 testMaster02 
	 ( 	.HCLK		(HCLK),
		.HRESETn	(HRESETn),
		.HREADYM	(HREADY),
		.HRESPM	 	(HRESP),
		.HGRANTM	(HGRANTM_testM02),
		
		.HADDRM		(HADDRM_testM02), 
		.HTRANSM	(HTRANSM_testM02),
		.HWRITEM	(HWRITEM_testM02),
		.HSIZEM      (HSIZEM_testM02),		
		.HBURSTM	(HBURSTM_testM02),
		.HPROTM      (HPROTM_testM02),		
        .HWDATAM	(HWDATAM_testM02), 
		.HBUSREQM	(HBUSREQM_testM02)
      );  
	  
	Master03 testMaster03 
	 ( 	.HCLK		(HCLK),
		.HRESETn	(HRESETn),
		.HREADYM	(HREADY),
		.HRESPM	 	(HRESP),
		.HGRANTM	(	),
		
		.HADDRM		(	), 
		.HTRANSM	(	),
		.HWRITEM	(	),
		.HSIZEM   (	),		
		.HBURSTM	(	),
		.HPROTM   (	),		
    .HWDATAM	(	), 
		.HBUSREQM	(	)
      );  
	  
	
  IntMem uIntMem_1 (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),
    .HADDR      (HADDR),
    .HTRANS     (HTRANS),
    .HWRITE     (HWRITE),
    .HSIZE      (HSIZE),
    .HWDATA     (HWDATA),
    .HSEL 		(HSEL_mem),
    .HREADYin   (HREADY),

    .HRDATA     (HRDATA_mem),
    .HREADYout  (HREADY_mem),
    .HRESP      (HRESP_mem)
  );
  
    ExtMem uExtMem (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),
    .HADDR      (HADDR),
    .HTRANS     (HTRANS),
    .HWRITE     (HWRITE),
    .HSIZE      (HSIZE),
    .HWDATA     (HWDATA),
    .HSEL 		(HSEL_EXmem),
    .HREADYin   (HREADY),

    .HRDATA     (HRDATA_EXmem),
    .HREADYout  (HREADY_EXmem),
    .HRESP      (HRESP_EXmem)
  );

  Tube uTube (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),
    .HADDR      (HADDR),
    .HTRANS     (HTRANS),
    .HWRITE     (HWRITE),
    .HSIZE      (HSIZE),
    .HWDATA     (HWDATA),
    .HSEL 		(HSEL_tube),
    .HREADYin   (HREADY),

    .HRDATA     (HRDATA_tube),
    .HREADYout  (HREADY_tube),
    .HRESP      (HRESP_tube)
    );
    
// The AHB system arbiter
  Arbiter  uArbiter (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),
    .HTRANS     (HTRANS),
    .HBURST     (HBURST),
    .HREADY     (HREADY),
    .HRESP      (HRESP),
                     
    .HSPLIT     (5'b00000),
                     
    .HBUSREQ0   (Pause),
    .HBUSREQ4   (	),				
    .HBUSREQ3   (HBUSREQM_testM02),
    .HBUSREQ2   (HBUSREQM_testM01),
    .HBUSREQ1   (HBUSREQM_RISC32),	
                     
    .HLOCK0     (Logic0),
    .HLOCK4     (Logic0),
    .HLOCK3     (Logic0),
    .HLOCK2     (Logic0),
    .HLOCK1     (HLOCKM_RISC32),	
                     
    .HGRANT0    (HGRANTdummy),
    .HGRANT4    (	),				
    .HGRANT3    (HGRANTM_testM02),
    .HGRANT2    (HGRANTM_testM01),
    .HGRANT1    (HGRANTM_RISC32),	
                     
    .HMASTER    (HMASTER),  // Current bus master
    .HMASTLOCK  (HMASTLOCK)
    );

	
	
  testMISRSlave_top testSlave(
									//AHB Bus Input
        .HCLK       (HCLK),
        .HRESET_n	(HRESETn),
        .HADDRS		(HADDR),
        .HTRANSS	(HTRANS),
        .HWRITES	(HWRITE),
        .HSIZES		(HSIZE),
        .HWDATAS     (HWDATA),
        .HSELS		(HSEL_testSlave),
        .HREADYS	(HREADY),
									//AHB Bus Output
        .HRDATAS	(HRDATA_testSlave),
        .HREADYOUTS	(HREADY_testSlave),
        .HRESPS		(HRESP_testSlave)
									//From core to IP
      //  core_out
        );

	
// The system address Decoder
  Decoder uDecoder (
    .HRESETn     (HRESETn),
    .HADDR       (HADDR),

	.HSELDefault (HSELDefault),  // Default Slave
    .HSEL_Slave1 (HSEL_mem),  		// Interna Memory
    .HSEL_Slave2 (HSEL_tube),  		// Tube
    .HSEL_Slave3 (HSEL_testSlave),  //testSlave
	.HSEL_Slave4 (HSEL_EXmem)		//External Memory
 );

// The Default Slave is selected when no other slaves are accessed
  DefaultSlave uDefaultSlave (
    .HCLK        (HCLK),
    .HRESETn     (HRESETn),
    .HTRANS      (HTRANS),
    .HSELDefault (HSELDefault),
    .HREADYin    (HREADY),

    .HREADYout   (HREADYDefault),
    .HRESP       (HRESPDefault)
    );
		

// Central multiplexer - masters to slaves
  MuxM2S uMuxM2S (
    .HCLK          (HCLK),
    .HRESETn       (HRESETn),
    .HMASTER       (HMASTER),
    .HREADY        (HREADY),

    .HADDR_M1      (HADDRM_RISC32),
    .HTRANS_M1     (HTRANSM_RISC32),
    .HWRITE_M1     (HWRITEM_RISC32),
    .HSIZE_M1      (HSIZEM_RISC32),
    .HBURST_M1     (HBURSTM_RISC32),
    .HPROT_M1      (HPROTM_RISC32),
    .HWDATA_M1     (HWDATAM_RISC32),
		
    .HADDR_M2      (HADDRM_testM01),
    .HTRANS_M2     (HTRANSM_testM01),
    .HWRITE_M2     (HWRITEM_testM01),
    .HSIZE_M2      (HSIZEM_testM01),
    .HBURST_M2     (HBURSTM_testM01),
    .HPROT_M2      (HPROTM_testM01),
    .HWDATA_M2     (HWDATAM_testM01),
    
	.HADDR_M3      (HADDRM_testM02),
    .HTRANS_M3     (HTRANSM_testM02),
    .HWRITE_M3     (HWRITEM_testM02),
    .HSIZE_M3      (HSIZEM_testM02),
    .HBURST_M3     (HBURSTM_testM02),
    .HPROT_M3      (HPROTM_testM02),
    .HWDATA_M3     (HWDATAM_testM02),

    .HADDR_M4      (	),
    .HTRANS_M4     (	),
    .HWRITE_M4     (	),
    .HSIZE_M4      (	),
    .HBURST_M4     (	),
    .HPROT_M4      (	),
    .HWDATA_M4     (	),

	
    .HADDR         (HADDR),
    .HTRANS        (HTRANS),
    .HWRITE        (HWRITE),
    .HSIZE         (HSIZE),
    .HBURST        (HBURST),
    .HPROT         (HPROT),
    .HWDATA        (HWDATA)
    );

// Central multiplexer - slaves to masters
  MuxS2M uMuxS2M (
    .HCLK           (HCLK),
    .HRESETn        (HRESETn),
    
    .HSELDefault 	(HSELDefault),  // Default Slave
    .HSEL_Slave1 	(HSEL_mem),  		// Interna Memory
    .HSEL_Slave2 	(HSEL_tube),  		// Tube
    .HSEL_Slave3 	(HSEL_testSlave),  	// testSlave
    .HSEL_Slave4 	(HSEL_EXmem),  		// Externa Memory
    .HSEL_Slave5 	(Logic0),  			
    .HSEL_Slave6 	(Logic0),   		
		
	.HRDATA_S1      (HRDATA_mem),
    .HREADY_S1      (HREADY_mem),
    .HRESP_S1       (HRESP_mem),
    
    .HRDATA_S2      (HRDATA_tube),
    .HREADY_S2  	(HREADY_tube),
    .HRESP_S2       (HRESP_tube),
    
    .HRDATA_S3      (HRDATA_testSlave),
    .HREADY_S3  	(HREADY_testSlave),
    .HRESP_S3       (HRESP_testSlave),
    
    .HRDATA_S4      (HRDATA_EXmem),
    .HREADY_S4  	(HREADY_EXmem),
    .HRESP_S4       (HRESP_EXmem),
    
    .HRDATA_S5      (),
    .HREADY_S5  	(),
    .HRESP_S5       (),
	
    .HRDATA_S6      (),
    .HREADY_S6  	(),
    .HRESP_S6       (),    	
    
    .HREADYDefault  (HREADYDefault),
    .HRESPDefault   (HRESPDefault),

    .HRDATA         (HRDATA),
    .HREADY         (HREADY),
    .HRESP          (HRESP)
    );
endmodule

// --================================= End ===================================--
