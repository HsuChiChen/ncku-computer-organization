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
