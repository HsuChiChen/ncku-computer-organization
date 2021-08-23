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
// File Name           : MISRWrapper.v,v
// File Revision       : 1.0
// 
// Release Information : 
// 
//----------------------------------------------------------------------
// Purpose             : Design for test
// ---------------------------------------------------------------------
// Revision History    : Revision 1.0  2007/02/16 13:28 York Lin
//               	 Initial revision
//====================================================================--

// synopsys translate_off
//`include "timescale.v"
//`include "define.v"
// synopsys translate_on

module  IRCntlWrapper(
        //AHB Bus Input Signals
        HCLK,
        HRESET_n,
        HADDR,
        HTRANS,
        HWRITE,
        HSIZE,
        HWDATA,
        HSEL_slave,
        HREADY_in,
        //AHB Bus Output Signals
        HRDATA,
        HREADY_out,
        HRESP,
        //To IP (IRCntl)
        IP_SEL,
        IP_ADDR,
        IP_WRITE,
        IP_MASK,
        IP_WDATA,
        //From IP (IRCntl)
        IP_RDATA,
        IP_READY,
        IP_ERROR
        );


        //AHB Bus Input
        input           HCLK;
        input           HRESET_n;
        input   [31:0]  HADDR;
        input   [1:0]   HTRANS;
        input           HWRITE;
        input   [2:0]   HSIZE;
        input   [31:0]  HWDATA;
        input           HSEL_slave;
        input           HREADY_in;

        //AHB Bus Output
        output  [31:0]  HRDATA;
        output          HREADY_out;
        output  [1:0]   HRESP;

        //To IP (internal registers)
        output          IP_SEL;
        output  [31:0]  IP_ADDR;
        output          IP_WRITE;
        output  [31:0]  IP_MASK;
        output  [31:0]  IP_WDATA;
        //From IP (internal registers)
        input   [31:0]  IP_RDATA;
        input       	IP_READY;
        input           IP_ERROR;

//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------


// HTRANS transfer type signal encoding (define.v)
      `define TRN_IDLE   2'b00
      `define TRN_BUSY   2'b01
      `define TRN_NONSEQ 2'b10
      `define TRN_SEQ    2'b11

// HSIZE transfer type signal encoding (define.v)
      `define SZ_BYTE 3'b000
      `define SZ_HALF 3'b001
      `define SZ_WORD 3'b010


//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

        parameter       ST_NORMAL = 2'b00;
        parameter   ST_WAIT   = 2'b01;
        parameter       ST_ERROR1 = 2'b10;
        parameter       ST_ERROR2 = 2'b11;


        //wire            valid;
        wire            valid_reg;
        wire            ac_enable;  // Address & Contorl Register Enable

    reg     [31:0]  next_addr;
    reg     [1:0]   next_trans;
    reg             next_write;
    reg     [2:0]   next_size;

        reg             HSEL_reg;
        reg     [31:0]  HADDR_reg;
        reg     [1:0]   HTRANS_reg;
        reg             HWRITE_reg;
        reg     [2:0]   HSIZE_reg;

        reg     [31:0]  mask;

        reg     [1:0]   current_state;
        reg     [1:0]   next_state;

        reg     [1:0]   iHRESP;
        reg             iHREADY_out;
	reg  	[31:0]  testOUTPUT; 

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Valid transfer detection
//------------------------------------------------------------------------------
// The slave must only respond to a valid transfer, so this must be detected.
        always@(posedge HCLK or negedge HRESET_n)
        begin

            if (!HRESET_n)
                HSEL_reg <= 1'b0;
            else
                begin
                if (HREADY_in)
                    HSEL_reg <= HSEL_slave;
                end

        end

// Valid AHB transfers only take place when a non-sequential or sequential
//  transfer is shown on HTRANS - an idle or busy transfer should be ignored.

        // Module is selected with valid transfer
        //assign  valid = ( (HSEL_slave == 1'b1) &&
        //                  ( (HTRANS == `TRN_NONSEQ) ||
        //                    (HTRANS == `TRN_SEQ)
        //                   )
        //                 ) ? 1'b1 : 1'b0;

        // Module was selected with valid transfer
        assign  valid_reg = ( (HSEL_reg == 1'b1) &&
                             ( (HTRANS_reg == `TRN_NONSEQ) ||
                               (HTRANS_reg == `TRN_SEQ)
                              )
                            ) ? 1'b1 : 1'b0;

//------------------------------------------------------------------------------
// Address and control registers
//------------------------------------------------------------------------------
// Registers are used to store the address and control signals from the address
//  phase for use in the data phase of the transfer.
// Only enabled when the HREADYin input is HIGH and the module is addressed.

        // Address & Contorl Register Enable
        assign ac_enable = HSEL_slave & HREADY_in;


    // next contorl wire
    always@(ac_enable or HADDR or HTRANS or HWRITE or HSIZE or
            HADDR_reg or HTRANS_reg or HWRITE_reg or HSIZE_reg)
    begin

        if(ac_enable)
            begin
                next_addr  = HADDR;
                next_trans = HTRANS;
                next_write = HWRITE;
                next_size  = HSIZE;
                end
            else
                begin
                next_addr  = HADDR_reg;
                next_trans = HTRANS_reg;
                next_write = HWRITE_reg;
                next_size  = HSIZE_reg;
                end
    end



    // control registers
        always@(posedge HCLK or negedge HRESET_n)
        begin
            if (!HRESET_n)
                begin
                HADDR_reg  <= 32'h0000_0000;
                HTRANS_reg <= 2'b00;
                HWRITE_reg <= 1'b0;
                HSIZE_reg  <= 3'b000;
                end
            else
                begin
                HADDR_reg  <= next_addr;
                HTRANS_reg <= next_trans;
                HWRITE_reg <= next_write;
                HSIZE_reg  <= next_size;
                end
        end

//------------------------------------------------------------------------------
// Write data mask generation
//------------------------------------------------------------------------------
// The data written to the registers depends on the transfer size setting.
// Unchanging bits of the write data are set HIGH in the mask.
// Changing   bits of the write data are set LOW  in the mask.
// The mask is used to allow the use of one set of size decoding logic for all
//  registers in the system.

// NOTE - this module is little endian, and must be modified for a big endian
//        system.
        always @(HSIZE_reg or HADDR_reg)
        begin
            mask = 32'hFFFF_FFFF;
            case (HSIZE_reg)

                `SZ_BYTE :                   // Byte Access
                    case (HADDR_reg[1:0])
                        2'b00 : mask[7:0] = 8'h00;
                        2'b01 : mask[15:8] = 8'h00;
                        2'b10 : mask[23:16] = 8'h00;
                        default  : mask[31:24] = 8'h00; //2'b11
                    endcase

                `SZ_HALF :                   // Halfword Access
                    if (HADDR_reg[1]) mask[31:16] = 16'h0000;
		    else mask[15:0] = 16'h0000;
                default  :                   // Word Access
                    mask = 32'h0000_0000;

            endcase
        end


//------------------------------------------------------------------------------
// HRESP generation
//------------------------------------------------------------------------------
// HRESP is registered to improve the output timing, and allows a state machine
//  to be used to control its generation.
// This Slave don't have SPLIT/RETRY function.
// A two-cycle response is required for an error condition.

        // FSM next state logic
        always @(current_state or IP_READY or IP_ERROR)
        begin
            case (current_state)

                ST_NORMAL :
                    if(IP_ERROR==1'b1)
                        next_state = ST_ERROR1 ;
                    else if(IP_READY==1'b0)
                        next_state = ST_WAIT;
                    else
                        next_state = ST_NORMAL ;

        ST_WAIT :
                    if(IP_ERROR==1'b1)
                        next_state = ST_ERROR1 ;
                    else if(IP_READY==1'b0)
                        next_state = ST_WAIT;
                    else
                        next_state = ST_NORMAL ;

                ST_ERROR1 :
                    next_state = ST_ERROR2 ;

                default : //ST_ERROR2
                    next_state = ST_NORMAL ; 

            endcase
        end

        // FSM current state
        always@(posedge HCLK or negedge HRESET_n)
        begin
            if (!HRESET_n)
                current_state <= ST_NORMAL;
            else
                current_state <= next_state;
        end




//------------------------------------------------------------------------------
// Output drivers
//------------------------------------------------------------------------------

    //iHRESP
        always @(current_state)
        begin

            case (current_state)
                ST_NORMAL :     iHRESP = `RSP_OKAY ;
                ST_ERROR1 :     iHRESP = `RSP_ERROR ;
                ST_ERROR2 :     iHRESP = `RSP_ERROR ;
                default :       iHRESP = `RSP_OKAY ;//ST_WAIT
            endcase

        end


    //iHREADY_out
        always @(current_state or IP_ERROR or IP_READY)
        begin

            case (current_state)
                ST_NORMAL :     iHREADY_out = (~IP_ERROR)&(IP_READY);
                ST_WAIT   :     iHREADY_out = (~IP_ERROR)&(IP_READY);
                ST_ERROR2 :     iHREADY_out = 1'b1 ;
                default :       iHREADY_out = 1'b0 ;//ST_ERROR1
            endcase

        end

        // Drive the output ports with the internal versions.
        assign  HREADY_out = iHREADY_out;
        assign  HRESP = iHRESP;

//------------------------------------------------------------------------------
//      IRCntl Control Signals
//------------------------------------------------------------------------------

        //To IRCntl
        assign  IP_SEL = valid_reg;
        assign  IP_ADDR = HADDR_reg;
        assign  IP_WRITE = HWRITE_reg;
        assign  IP_MASK = mask;					//??
        assign  IP_WDATA = HWDATA;

        //From IRCntl
	
        assign  HRDATA = IP_RDATA ;

	
endmodule


