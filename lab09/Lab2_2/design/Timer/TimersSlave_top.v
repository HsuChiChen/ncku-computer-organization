// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from CAS LAB, NCKU Limited
//    (C) COPYRIGHT 2007 Computer and System LAB, NCKU Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from CAS LAB, NCKU Limited.
//  
//----------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name           : MISRSlave_top.v,v
// File Revision       : 1.1
// 
// Release Information : 
// 
//----------------------------------------------------------------------
// Purpose             : Design for test
// ---------------------------------------------------------------------
// Revision History    : Revision 1.0  2007/02/16 13:28 York Lin
//               	 Initial revision
//			 Revision 1.1  2007/05/07 07:48 Tai-Hua Lu
//               	 Add nWait singal in Timers for testing
//====================================================================--

// synopsys translate_off
//`include "timescale.v"
// synopsys translate_on

module  TimersSlave_top(
	
        //AHB Bus Input
        HCLK,
        HRESET_n,
        HADDRS,
        HTRANSS,
        HWRITES,
        HSIZES,
        HWDATAS,
        HSELS,
        HREADYS,
        //AHB Bus Output
        HRDATAS,
        HREADYOUTS,
        HRESPS,

        //From IP to IntCntl
	IRQ,
        //From IntCntl to IP
 	ACK
        );

        //AHB Bus Input
        input           HCLK;
        input           HRESET_n;
        input   [31:0]  HADDRS;
        input   [1:0]   HTRANSS;
        input           HWRITES;
        input   [2:0]   HSIZES;
        input   [31:0]  HWDATAS;
        input           HSELS;
        input           HREADYS;
	

        //AHB Bus Output
        output  [31:0]  HRDATAS;
        output          HREADYOUTS;
        output  [1:0]   HRESPS;
        
        //From IP to IntCntl
        output  		IRQ;

        //From IntCntl to IP
        input  		ACK;
        
  //---------------------------------------------------------------------- 
  // Signal declarations
  //----------------------------------------------------------------------
        //To IP (Timers)
        wire            IP_SEL;
        wire    [31:0]  IP_ADDR;
        wire            IP_WRITE;
        wire    [31:0]  IP_MASK;
        wire    [31:0]  IP_WDATA;
        //From IP (Timers)
        wire    [31:0]  IP_RDATA;
        wire            IP_ERROR;
        wire            IP_READY;

        //Timers control
        wire            write_enable;
//	wire	[31:0]	testOUTPUT ;

//=====================================================================
//      AHB Slave
//=====================================================================
        //initial $sdf_annotate("SlaveWrapper.sdf", u_Slave1) ;
//		assign  testOUTPUT = 32'h0000_abcd;

        TimersWrapper     uTimers_Wra (
                         //AHB Bus Input
                         .HCLK             (HCLK),
                         .HRESET_n          (HRESET_n),
                         .HADDR           (HADDRS),
                         .HTRANS          (HTRANSS),
                         .HWRITE          (HWRITES),
                         .HSIZE           (HSIZES),
                         .HWDATA          (HWDATAS),
                         .HSEL_slave      (HSELS),
                         .HREADY_in       (HREADYS),
                         //AHB Bus Output
                         .HRDATA          (HRDATAS),
                         .HREADY_out       (HREADYOUTS),
                         .HRESP            (HRESPS),
                         //To IP (Timers)
                         .IP_SEL           (IP_SEL),
                         .IP_ADDR          (IP_ADDR),
                         .IP_WRITE         (IP_WRITE),
                         .IP_MASK          (IP_MASK),
                         .IP_WDATA         (IP_WDATA),
                         //From IP (Timers)
                         .IP_RDATA         (IP_RDATA),
                         .IP_READY         (IP_READY),
                         .IP_ERROR         (IP_ERROR)
                        );

//=====================================================================
//      Timers
//=====================================================================
        assign  IP_READY = 1'b1;
        assign  IP_ERROR = (IP_ADDR[9:5]==5'b0) ? 1'b0 : 1'b1 ; // [4:2] -> 8 addressable reg
        assign  write_enable = IP_SEL&IP_WRITE&(!IP_ERROR)&IP_READY;

		  Timers  uTimers (	
	
						//AHB Bus Input
						.HCLK		(HCLK), 
						.HRESETn 	(HRESET_n),
						.HSELT		(IP_SEL), 
						.ENABLE_D	(	),   
						.VALUE_D	(	),  
						.HADDR		(IP_ADDR),   
						
						//Timer intput
						.ACK		(ACK),
						//Timer output
						.timer_itr	(	)
							);					
						

endmodule




