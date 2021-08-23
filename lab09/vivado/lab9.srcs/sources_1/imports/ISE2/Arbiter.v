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
//  File Name : Arbiter.v,v
//  File Revision : 1.4
//
//  Release Information : AUK-REL1v0
//  
//  ----------------------------------------------------------------------------
//  Purpose             : AHB System Arbiter.
//                        The arbiter processes requests for ownership of the
//                        bus and grants one bus master according to the
//                        arbitration scheme.
//                        The arbitration scheme of this implementation is a
//                        simple priority encoded scheme where the highest
//                        priority master requesting the bus is granted.
//  --========================================================================--
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

`define WORD_WIDTH 2'b10
`define HWORD_WIDTH 2'b01
`define BYTE_WIDTH 2'b00

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

// HRESP transfer response signal encoding
`define RSP_OKAY   2'b00
`define RSP_ERROR  2'b01
`define RSP_RETRY  2'b10
`define RSP_SPLIT  2'b11
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

module Arbiter (HCLK, HRESETn, HTRANS, HBURST, HREADY, HRESP, HSPLIT,
                HBUSREQ0, HBUSREQ1, HBUSREQ2, HBUSREQ3,HBUSREQ4,
                HLOCK0,   HLOCK1,   HLOCK2,   HLOCK3, HLOCK4,
                HGRANT0,  HGRANT1,  HGRANT2,  HGRANT3, HGRANT4,
                HMASTER, HMASTLOCK);

  input       HCLK;
  input       HRESETn;
  input [1:0] HTRANS;
  input [2:0] HBURST;
  input       HREADY;
  input [1:0] HRESP;
  input [4:0] HSPLIT;
  input       HBUSREQ0;
  input       HBUSREQ1;
  input       HBUSREQ2;
  input       HBUSREQ3;
  input       HBUSREQ4;
  input       HLOCK0;
  input       HLOCK1;
  input       HLOCK2;
  input       HLOCK3;
  input       HLOCK4;  

  output       HGRANT0;
  output       HGRANT1;
  output       HGRANT2;
  output       HGRANT3;
  output       HGRANT4;  
  output [4:0] HMASTER;
  output       HMASTLOCK;
  
//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------
  wire         HCLK;
  wire         HRESETn;
  wire [1:0]   HTRANS;
  wire [2:0]   HBURST;
  wire         HREADY;
  wire [1:0]   HRESP;
  wire [4:0]   HSPLIT;
  wire         HBUSREQ0;
  wire         HBUSREQ1;
  wire         HBUSREQ2;
  wire         HBUSREQ3;
  wire         HBUSREQ4;
  wire         HLOCK0;
  wire         HLOCK1;
  wire         HLOCK2;
  wire         HLOCK3;
  wire         HLOCK4;
  reg          HGRANT0;
  reg          HGRANT1;
  reg          HGRANT2;
  reg          HGRANT3;
  reg          HGRANT4;  
  reg [4:0]    HMASTER;
  wire         HMASTLOCK;
  
  // Request generation
  wire [4:0]   HBUSREQ;
  reg [4:0]    BusReqReg;
  wire [4:0]   Request;
  reg [4:0]    TopRequest;
  reg [4:0]    GrantMaster;
  reg [4:0]    AddrMaster;
  reg [4:0]    DataMaster;
  
  // Burst counter logic
  reg [4:0]    NextBurst;
  reg [4:0]    CurrentBurst;
  wire         BurstInProgress;
  
  // Locked transfer logic
  reg          Lock;
  reg          iHMASTLOCK;
  reg          LockedData;
  wire         HoldLock;
  wire         SplitRetry1;
  reg          SplitRetry2;
  
  // Split transfer logic
  wire         Split1;
  reg          Split2;
  reg [4:0]    SplitReg;
  wire [4:0]   SplitMask;
  reg [4:0]    SplitMaskReg;
  reg [4:0]    SplitMaskSet;
  
  // Signals used when a locked master receives a Split response
  wire         ForceNoGrant;
  reg          ForceNoMaster;
  wire         LockedSplitSet;
  reg          LockedSplitClr;

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------
// Overview of the Arbiter operation
// The following key signals are used in the arbiter:-
// GrantMaster is the number of the master that currently has its grant signal.
// AddrMaster  is the number of the master that owns the address/control signals.
// DataMaster  is the number of the master that owns the read/write data buses.

//------------------------------------------------------------------------------
// Register request inputs
//------------------------------------------------------------------------------
// The arbiter requests inputs are registered before use.
//
// Bus master 0 is reserved for the dummy bus master (which only
//  performs IDLE transfers). A "Pause" input signal can be connected
//  to this input signal to requst that no other masters are to be granted.

  assign HBUSREQ = {HBUSREQ4,HBUSREQ3, HBUSREQ2, HBUSREQ1, HBUSREQ0};
  
  always @ (negedge HRESETn or posedge HCLK)
    begin
      if  ( HRESETn ==1'b0 )
        BusReqReg  <= {5{1'b0}};
      else
        BusReqReg  <= HBUSREQ ;
    end 

// Mask the Request inputs - If any master has received a Split transfer
//  reponse then its request input is masked until it is un-split.

//  assign  Request  = (BusReqReg  & (~SplitMask ));
  assign  Request  = (HBUSREQ  & (~SplitMask ));

//------------------------------------------------------------------------------
// Arbitration Priority Scheme
//------------------------------------------------------------------------------
// This section contains the arbitration priority algorithm and should be
//  changed if a different arbitration scheme is required. At this point in
//  the arbiter the individual requests (upto 15) are combined to give a single
//  master which is highest priority and is encoded in a 4-bit number.
//
// The default scheme is:
//   HBUSREQ(3) is the highest priority
//   HBUSREQ(0) is the second highest priority - This must only be connected to
//              a Pause input.
//   HBUSREQ(2) is the middle priority.
//   HBUSREQ(1) is the lowest priority and default bus master - This input is
//              usually used for an uncached ARM core.
//
//  Bus master 0 is reserved for the dummy bus master, which never performs
//   real transfers. This master is granted when the default master is
//   performing a locked transfer which has received a split response.
 
 always @ (Request or AddrMaster)
    begin
      if (		)   	
      begin
      	if  ( Request[4])
      		TopRequest  = 5'b00100;
      	else if ( Request[3])
        	TopRequest  = 5'b00011;
      	else if ( Request[2])
        	TopRequest  = 5'b00010;
      	else if ( Request[1])
        	TopRequest  = 5'b00001;
      	else if ( Request[0])
        	TopRequest  = 5'b00000;
      	else
        	TopRequest  = 5'b00000;  // Dummy master
      end
      else if (		)
      begin
      	if  ( Request[0])
      		TopRequest  = 5'b00000;
      	else if ( Request[4])
        	TopRequest  = 5'b00100;
      	else if ( Request[3])
        	TopRequest  = 5'b00011;
      	else if ( Request[2])
        	TopRequest  = 5'b00010;
      	else if ( Request[1])
        	TopRequest  = 5'b00001;
      	else
        	TopRequest  = 5'b00000;  // Dummy master
      end
	  else if(		) //è«‹å?å­¸å??å‰©ä¸‹Round-Robin code
	  if  ( Request[1])
            TopRequest  = 5'b00001;
        else if ( Request[0])
          TopRequest  = 5'b00000;
        else if ( Request[4])
          TopRequest  = 5'b00100;
        else if ( Request[3])
          TopRequest  = 5'b00011;
        else if ( Request[2])
          TopRequest  = 5'b00010;
        else
          TopRequest  = 5'b00000;  // Dummy master

	  else if ( 		 )

      else if ( 		 )

      else

	  
	  
	  
	 end 

/*	
  always @ (Request or AddrMaster)// or SplitMask)
    begin
		if  ( Request[4])
			TopRequest  = 5'b00100;
		else if ( Request[3])
			TopRequest  = 5'b00011;
		else if ( Request[2])
			TopRequest  = 5'b00010;
		else if ( Request[1])
			TopRequest  = 5'b00001;
		else if ( Request[0])
			TopRequest  = 5'b00000;	
		else
			TopRequest  = 5'b00000;  // Dummy master
    end 
*/	
	
// The selection of the new HGRANT signal is based on the following
//   1. If the current transfer is locked then keep the current
//      master granted.
//   2. If a burst is in progress and it has not received a Split or
//      Retry response then keep the current master granted.
//   3. Otherwise grant the higheset requesting master.

  always @ (iHMASTLOCK or HoldLock or BurstInProgress or SplitRetry2 or 
            AddrMaster or TopRequest)
    begin
      if  ( (iHMASTLOCK  || HoldLock ))
        GrantMaster  = AddrMaster ;
      else if ( (BurstInProgress  && SplitRetry2 ==1'b0 ))
        GrantMaster  = AddrMaster ;
      else
        GrantMaster  = TopRequest ;
    end
  
// The "GrantMaster" encoding is decoded to generate individual HGRANT signals
//  to each bus master.
// In the special case of a master receiving a Split response on a locked
//  transfer, as indicated by ForceNoGrant, the HGRANT outputs are overriden to grant
//  the bus to the dummy master.

  always @ (ForceNoGrant or GrantMaster)
    begin
      // Default assigments
      HGRANT0 = 1'b0;
      HGRANT1 = 1'b0;
      HGRANT2 = 1'b0;
      HGRANT3 = 1'b0;
      HGRANT4 = 1'b0;
      
      if  ( ForceNoGrant )
        HGRANT0 = 1'b1; // Grants the dummy bus master
      else
        begin
          case (GrantMaster )
            5'b00000: HGRANT0 = 1'b1;
            5'b00001: HGRANT1 = 1'b1;
            5'b00010: HGRANT2 = 1'b1;
            5'b00011: HGRANT3 = 1'b1;
            5'b00100: HGRANT4 = 1'b1;
            default: begin
                     end
          endcase
        end 
    end 

//------------------------------------------------------------------------------
// HMASTER output generation and registers
//------------------------------------------------------------------------------
// When HREADY is HIGH the master which currently has its grant signal asserted
//  becomes the owner of the address bus and the number of this master is
//  reflected on to the HMASTER output.
// The register that generates HMASTER does not have a reset term to ensure
//  that it reflects the correct master number during reset.

  always @ (posedge HCLK)
    begin
      if  ( HREADY )
        AddrMaster  <= GrantMaster ;
    end 

// In the special case of a master receiving a Split response on a locked
//  transfer the HMASTER outputs are overriden to grant the bus to dummy
//  master.

  always @ (ForceNoMaster or AddrMaster)
    begin
      if  ( ForceNoMaster )
        HMASTER  = 5'b00000;
      else
        HMASTER  = AddrMaster ;
    end 

//------------------------------------------------------------------------------
// BURST TRANSFER COUNTER
//------------------------------------------------------------------------------
// During a fixed length burst transfer a master may de-assert its request
//  but the arbiter will not change the currently selected master until
//  the last transfer of the burst.
//
// The Burst counter is used to count down from the number of transfers the
//  master should perform and when the counter reaches zero the bus may be
//  passed to another master.
// The value initially loaded into the counter is dependent on whether or
//  not the address phase of the first transfer is waited.

  always @ (HREADY or HTRANS or HBURST or CurrentBurst)
    begin
      if  ( HREADY ==1'b0 )
        begin 
          if  ( HTRANS ==`TRN_NONSEQ )
            begin 
              case (HBURST )
                `BUR_INCR16 ,`BUR_WRAP16 : NextBurst  = 5'b01111;
                `BUR_INCR8  ,`BUR_WRAP8  : NextBurst  = 5'b00111;
                `BUR_INCR4  ,`BUR_WRAP4  : NextBurst  = 5'b00011;
                `BUR_SINGLE ,`BUR_INCR   : NextBurst  = 5'b00000;
                default                  : NextBurst  = 5'b00000;
              endcase
            end
          else
            NextBurst  = CurrentBurst ;
        end
      else  // HREADY = '1'
        begin
          case (HTRANS )
            `TRN_NONSEQ :
              begin
                case (HBURST )
                  `BUR_INCR16 ,`BUR_WRAP16 : NextBurst  = 5'b01110;
                  `BUR_INCR8  ,`BUR_WRAP8  : NextBurst  = 5'b00110;
                  `BUR_INCR4  ,`BUR_WRAP4  : NextBurst  = 5'b00010;
                  `BUR_SINGLE ,`BUR_INCR   : NextBurst  = 5'b00000;
                  default                  : NextBurst  = 5'b00000;
                endcase
              end
            `TRN_SEQ  :
              begin
                if  ( CurrentBurst ==5'b00000)
                  NextBurst  = 5'b00000;
                else
                  NextBurst  = (CurrentBurst  - 1'b1 );
              end
            `TRN_BUSY : NextBurst  = CurrentBurst ;
            `TRN_IDLE : NextBurst  = 5'b00000;
            default   : NextBurst  = 5'b00000;
          endcase
        end 
    end 

  always @ (negedge HRESETn or posedge HCLK)
    begin
      if  ( HRESETn ==1'b0 )
        CurrentBurst  <= {5{1'b0}};
      else
        CurrentBurst  <= NextBurst ;
    end 

  assign BurstInProgress  = ((CurrentBurst ==5'b00000 || NextBurst == 5'b00000) ? 1'b0 : 1'b1 );

//------------------------------------------------------------------------------
// LOCKED TRANSFERS
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Lock generation
//------------------------------------------------------------------------------
// When a master is granted the bus its HLOCK input is sampled to determine
//  whether or not it requires locked access. 
// The HoldLock signal is used to ensure that no other master is granted
//  during if data phase of the last locked transfer receives a Split or
//  Retry response.

  always @ (HoldLock or GrantMaster or HLOCK0 or HLOCK1 or HLOCK2 or HLOCK3 or HLOCK4)
    begin
      if  ( HoldLock )
        Lock  = 1'b1 ;
      else
        begin
          case (GrantMaster )
            5'b00000: Lock  = HLOCK0;
            5'b00001: Lock  = HLOCK1;
            5'b00010: Lock  = HLOCK2;
            5'b00011: Lock  = HLOCK3;
            5'b00100: Lock  = HLOCK4;
            default: Lock  = 1'b0 ;
          endcase
        end 
    end 

// The HMASTLOCK output indicates if the current address is a locked transfer.

  always @ (negedge HRESETn or posedge HCLK)
    begin
      if  ( HRESETn ==1'b0 )
        iHMASTLOCK  <= 1'b0 ;
      else
        begin
          if  ( HREADY )
            iHMASTLOCK  <= Lock ;
        end 
    end 

  assign  HMASTLOCK  = iHMASTLOCK ;

//------------------------------------------------------------------------------
// Last Locked Data
//------------------------------------------------------------------------------
// The signal LockedData is HIGH when the data phase a locked
//  transfer is underway. The arbiter needs to know when this is occuring in
//  case the data receives either a Split or Retry response, in which case
//  it must ensure that the current master remains granted until the data
//  phase has been completed.
//
// LockedData is simply a delayed version of HMASTLOCK.

  always @ (negedge HRESETn or posedge HCLK)
    begin
      if  ( HRESETn ==1'b0 )
        LockedData  <= 1'b0 ;
      else
        begin
          if  ( HREADY )
            LockedData  <= iHMASTLOCK ;
        end 
    end 

//----------------------------------------------------------------------
// Split/Retry detection
//----------------------------------------------------------------------
// SplitRetry1 is set HIGH during the first cycle of a split/retry response
//  (when HREADY is LOW). The registered SplitRetry2 is HIGH during the second
//  cycle of the response (when HREADY is HIGH).

  assign SplitRetry1  = (((HREADY ==1'b0 ) & ((HRESP ==`RSP_RETRY ) | (HRESP ==`RSP_SPLIT ))) 
                         ? 1'b1  : (1'b0 ));
  
  always @ (negedge HRESETn or posedge HCLK)
    begin
      if  ( HRESETn ==1'b0 )
        SplitRetry2  <= 1'b0 ;
      else
        SplitRetry2  <= SplitRetry1 ;
    end 

// The HoldLock signal is asserted when the data phase of the last locked
//  transfer receives either a Split or Retry response. This is used to
//  force the iHMASTLOCK signal 

  assign HoldLock  = (((LockedData ) & (SplitRetry2 )) ? 1'b1  : 1'b0 );

//----------------------------------------------------------------------
// SPLIT TRANSFERS
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Split Response Detection
//----------------------------------------------------------------------
// The following section is used to detect and monitor Split
//  responses. A register with one bit per master is used to record
//  which masters have received a Split response.
// 
// DataMaster contains the number of the master that is currently
//  driving/reading the data buses and is used to determine which bit
//  of the SplitMask should be set when a split response is detected.

  always @ (negedge HRESETn or posedge HCLK)
    begin
      if  ( HRESETn ==1'b0 )
        DataMaster  <= {5{1'b0}};
      else
        begin
          if  ( HREADY )
            DataMaster  <= AddrMaster ;
        end 
    end 

  assign Split1  = (((HRESP ==`RSP_SPLIT ) & (HREADY ==1'b0 )) ? 1'b1  : (1'b0 ));
  
  always @ (negedge HRESETn or posedge HCLK)
    begin
      if  ( HRESETn ==1'b0 )
        Split2  <= 1'b0 ;
      else
        Split2  <= Split1 ;
    end 

  always @ (Split2 or DataMaster)
    begin
      if  ( Split2 )
        begin 
          case (DataMaster )
            5'b00000: SplitMaskSet  = 5'b00001;
            5'b00001: SplitMaskSet  = 5'b00010;
            5'b00010: SplitMaskSet  = 5'b00100;
            5'b00011: SplitMaskSet  = 5'b01000;
            5'b00100: SplitMaskSet  = 5'b10000;			
            default: SplitMaskSet  = 5'b00000;
          endcase
        end
      else
        SplitMaskSet  = 5'b00000;
    end 

// HSPLIT is used to clear the appropriate bits in the SplitMask
//  when a split-capable slave indicates that it can complete the
//  transfer. Clearing must have priority over setting to ensure
//  that the SplitMask is cleared if HSPLITx is assertd in the
//  second cycle of a Split Response.

  always @ (negedge HRESETn or posedge HCLK)
    begin
      if  ( HRESETn ==1'b0 )
        SplitReg  <= {5{1'b0}};
      else
        SplitReg  <= HSPLIT ;
    end 

  assign  SplitMask  = ((SplitMaskReg  | SplitMaskSet ) & (~SplitReg ));

  always @ (negedge HRESETn or posedge HCLK)
    begin
      if  ( HRESETn ==1'b0 )
        SplitMaskReg  <= {5{1'b0}};
      else
        SplitMaskReg  <= SplitMask ;
    end 

//----------------------------------------------------------------------
// LOCKED TRANSFER WITH SPLIT RESPONSE
//----------------------------------------------------------------------
// A special case that needs to be considered within the Arbiter is
//  when a Split response is given to a Locked transfer.
// It should be noted, that performing locked transfers to memory
//  regions that give split response is not recommended as this will
//  cause the bus to be locked for a large number of cycles.
// A split response to a locked transfer is detected using the
// LockedSplitSet signal.

  assign LockedSplitSet  = (((LockedData ) & (Split2 )) ? 1'b1  : (1'b0 ));
  
  always @ (DataMaster or SplitReg)
    begin
      case (DataMaster )
        5'b0000: LockedSplitClr  = SplitReg[0];
        5'b0001: LockedSplitClr  = SplitReg[1];
        5'b0010: LockedSplitClr  = SplitReg[2];
        5'b0011: LockedSplitClr  = SplitReg[3];
        5'b0100: LockedSplitClr  = SplitReg[4];		
        default: LockedSplitClr  = 1'b0 ;
      endcase
    end 

// The signal ForceNoGrant is used to force all the HGRANT signals LOW
//  and a delayed version, ForceNoMaster, is used to force the HMASTER
//  output to zero, indicating that the dummy master has been granted.
// This must happen when a master performing a locked transfer, but the
//  slave gives a Split response.

  assign ForceNoGrant  = ((LockedSplitSet ) ? 1'b1  : ((LockedSplitClr ) ? 1'b0  : (ForceNoMaster )));

  always @ (negedge HRESETn or posedge HCLK)
    begin
      if  ( HRESETn ==1'b0 )
        ForceNoMaster  <= 1'b0 ;
      else
        begin
          if  ( HREADY )
            ForceNoMaster  <= ForceNoGrant ;
        end 
    end 

endmodule
