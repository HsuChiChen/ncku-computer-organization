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

`timescale 1ns/10ps
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
	HRESETn,
	
	LED0,
	LED1,
	LED2,
	LED3,
	LED4,
	LED5,
	LED6,
	LED7
	);

  input     HCLK;   		// External clock in
  input     HRESETn;   	// Power on reset input

  output LED0;     
  output LED1;
  output LED2;
  output LED3;
  output LED4;
  output LED5;
  output LED6;
   output LED7;


 // output 		 LIGHT;
 // output   		 LIGHT1;

  wire 				nIRQ;
  wire	HCLK ;
  wire [7:0] LED;	
	
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

  wire        HSEL_LED;
  wire [31:0] HRDATA_LED;
  wire        HREADY_LED;
  wire  [1:0] HRESP_LED;
 
	
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
wire		Timer2_ACK;

wire		Timer1_IRQ; 
wire		Timer2_IRQ;
wire     clk32MHz; 
wire 		clka;
wire 	lock;

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------


//  assign LIGHT1 = (|LED); 
// assign LIGHT = (|HRDATA);

  assign Logic0 = 1'b0;
  assign Logic1 = 1'b1;
  assign Pause = Logic0 ;
  assign Remap = Logic0 ;

   assign        LED0 = ;	
   assign        LED1 = ;
   assign        LED2 = ;		
   assign        LED3 = ;
   assign        LED4 = ;
   assign        LED5 = ;
   assign        LED6 = ;
   assign		  LED7 = ;		
  
  
  
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
 
	
  MySRAM_AHB32_Top mem_top (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),
    .HADDR      (HADDR),
    .HTRANS     (HTRANS),
    .HWRITE     (HWRITE),
    .HSIZE      (HSIZE),
    .HWDATA     (HWDATA),
    .HSELx 		(HSEL_mem),
    .HREADY_in   (HREADY),

    .HRDATA_MEM     (HRDATA_mem),
    .HREADY_out  (HREADY_mem),
    .HRESP      (HRESP_mem)
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
    .HBUSREQ4   (Pause),
    .HBUSREQ2   (Pause),
    .HBUSREQ3   (Pause),
    .HBUSREQ1   (HBUSREQM_RISC32),	
                     
    .HLOCK0     (Logic0),
    .HLOCK4     (Logic0),
    .HLOCK2     (Logic0),
    .HLOCK3     (Logic0),
    .HLOCK1     (HLOCKM_RISC32),	
                     
    .HGRANT0    (HGRANTdummy),
    .HGRANT4    (HGRANTM_testM01),
    .HGRANT2    (HGRANTM_testM02),
    .HGRANT3    (HGRANTM_testM03),
    .HGRANT1    (HGRANTM_RISC32),	
                     
    .HMASTER    (HMASTER),  // Current bus master
    .HMASTLOCK  (HMASTLOCK)
    );

	
	

// The system address Decoder
  Decoder uDecoder (
    .HRESETn     (HRESETn),
    .HADDR       (HADDR),

	.HSELDefault (HSELDefault),  // Default Slave
    .HSEL_Slave1 (HSEL_mem),  	// Internal Memory
    .HSEL_Slave2 (HSEL_LED)  		// LED
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
		
    .HADDR_M2      (HADDRM_testM02),
    .HTRANS_M2     (HTRANSM_testM02),
    .HWRITE_M2     (HWRITEM_testM02),
    .HSIZE_M2      (HSIZEM_testM02),
    .HBURST_M2     (HBURSTM_testM02),
    .HPROT_M2      (HPROTM_testM02),
    .HWDATA_M2     (HWDATAM_testM02),
    
    .HADDR_M4      (HADDRM_testM01),
    .HTRANS_M4     (HTRANSM_testM01),
    .HWRITE_M4     (HWRITEM_testM01),
    .HSIZE_M4      (HSIZEM_testM01),
    .HBURST_M4     (HBURSTM_testM01),
    .HPROT_M4      (HPROTM_testM01),
    .HWDATA_M4     (HWDATAM_testM01),
	
	.HADDR_M3      (HADDRM_testM03),
    .HTRANS_M3     (HTRANSM_testM03),
    .HWRITE_M3     (HWRITEM_testM03),
    .HSIZE_M3      (HSIZEM_testM03),
    .HBURST_M3     (HBURSTM_testM03),
    .HPROT_M3      (HPROTM_testM03),
    .HWDATA_M3     (HWDATAM_testM03),

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
    .HSEL_Slave1 	(HSEL_mem),  		// Internal Memory
    .HSEL_Slave2 	(HSEL_LED),  		// LED
    .HSEL_Slave3 	(Logic0),  		
    .HSEL_Slave4 	(Logic0), 			
    .HSEL_Slave5 	(Logic0),  	
    .HSEL_Slave6 	(Logic0),   	
		
	.HRDATA_S1      (HRDATA_mem),
    .HREADY_S1      (HREADY_mem),
    .HRESP_S1       (HRESP_mem),
    
    .HRDATA_S2      (HRDATA_LED),
    .HREADY_S2  	(HREADY_LED),
    .HRESP_S2       (HRESP_LED),
    
    .HRDATA_S3      (),
    .HREADY_S3  	(),
    .HRESP_S3       (),
    
    .HRDATA_S4      (),					// External Memory 
    .HREADY_S4  	(),
    .HRESP_S4       (),
    
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


	
 GPIO  uGPIO(
    .HRESETn(HRESETn),
	.HSEL_LED(HSEL_LED),
	 .clk(HCLK),
	 .HREADY(HREADY),

    .LED(LED),
	.HREADY_LED(HREADY_LED),
    .HRESP_LED(HRESP_LED),
	.HWDATA(HWDATA)
    );	
	

	 
//
//	 my_dcm instance_name (
//    .CLKIN_IN(HCLK), 
//    .CLKFX_OUT(HCLK), 
//    .CLKIN_IBUFG_OUT(), 
//    .CLK0_OUT(), 
//    .LOCKED_OUT(lock)
//    );

endmodule

	 