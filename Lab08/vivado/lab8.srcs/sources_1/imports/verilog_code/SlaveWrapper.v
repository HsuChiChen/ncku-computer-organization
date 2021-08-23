//+FHDR----------------------------------------------------------------
// (C) Copyright CASLab.EE.NCKU
// All Right Reserved
//---------------------------------------------------------------------
// FILE NAME: SlaveWrapper.v
// AUTHOR: Chen-Chieh Wang
// CONTACT INFORMATION: ccwang@mail.ee.ncku.edu.tw
//---------------------------------------------------------------------
// RELEASE VERSION: 2.1.0
// VERSION DESCRIPTION: First Edition no errata
//---------------------------------------------------------------------
// RELEASE: 2010/3/2 PM. 10:09:20
//-FHDR----------------------------------------------------------------
 
// synopsys translate_off
//`include "timescale.v"
//`include "define.v"
// synopsys translate_on
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

 module  SlaveWrapper(
        //-------------------------------------------------------------
        //  AHB Bus Interface - Input Signals
        //-------------------------------------------------------------
        HSELx,          //Select
        HADDR,          //Address
        HWRITE,         //Control
        HTRANS,         //Control
        HSIZE,          //Control
        HBURST,         //Control
        HREADY_in,      //Control
        HWDATA,         //Data
        HRESETn,        //Reset
        HCLK,           //Clock
        //HMASTER,      //Split-capable slave only (option)
        //HMASTLOCK,    //Split-capable slave only (option)
        //-------------------------------------------------------------
        //  AHB Bus Interface - Output Signals
        //-------------------------------------------------------------
        HREADY_out,     //Transfer response
        HRESP,          //Transfer response
        HRDATA,         //Data
        //HSPLITx,      //Split-capable slave only (option)
        //-------------------------------------------------------------
        //  User Interface - Output Signals
        //-------------------------------------------------------------
        UI_SEL,         //Select
        UI_ADDR,        //Address
        UI_WRITE,       //Control
        UI_BE,          //Control (Byte Enable)
        UI_INFO,        //Control {HBURST[2:0]}
        UI_WDATA,       //Data
        //-------------------------------------------------------------
        //  User Interface - Input Signals
        //-------------------------------------------------------------
        UI_READY,       //Transfer response
        UI_ERROR,       //Transfer response
        UI_RDATA        //Data
        );

    //-----------------------------------------------------------------
    //  AHB Bus Interface - Input Signals
    //-----------------------------------------------------------------
    input           HSELx;      //Select
    input   [31:0]  HADDR;      //Address
    input           HWRITE;     //Control
    input   [1:0]   HTRANS;     //Control
    input   [2:0]   HSIZE;      //Control
    input   [2:0]   HBURST;     //Control
    input           HREADY_in;  //Control
    input   [31:0]  HWDATA;     //Data
    input           HRESETn;    //Reset
    input           HCLK;       //Clock
    //input [3:0]   HMASTER;    //Split-capable slave only (option)
    //input         HMASTLOCK;  //Split-capable slave only (option)

    //-----------------------------------------------------------------
    //  AHB Bus Interface - Output Signals
    //-----------------------------------------------------------------
    output          HREADY_out; //Transfer response
    output  [1:0]   HRESP;      //Transfer response
    output  [31:0]  HRDATA;     //Data
    //output[15:0]  HSPLITx;    //Split-capable slave only (option)

    //-----------------------------------------------------------------
    //  User Interface - Output Signals
    //-----------------------------------------------------------------
    output          UI_SEL;     //Select
    output  [31:0]  UI_ADDR;    //Address
    output          UI_WRITE;   //Control
    output  [3:0]   UI_BE;      //Control (Byte Enable)
    output  [2:0]   UI_INFO;    //Control {HBURST[2:0]}
    output  [31:0]  UI_WDATA;   //Data

    //-----------------------------------------------------------------
    //  User Interface - Input Signals
    //-----------------------------------------------------------------
    input           UI_READY;   //Transfer response
    input           UI_ERROR;   //Transfer response
    input   [31:0]  UI_RDATA;   //Data

//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------

    // State encoding
    parameter       ST_NORMAL = 2'b00;
    parameter       ST_WAIT   = 2'b01;
    parameter       ST_ERROR1 = 2'b10;
    parameter       ST_ERROR2 = 2'b11;

    // HTRANS transfer type signal encoding (define.v)
    //      `define TRN_IDLE   2'b00
    //      `define TRN_BUSY   2'b01
    //      `define TRN_NONSEQ 2'b10
    //      `define TRN_SEQ    2'b11

    // HSIZE transfer type signal encoding (define.v)
    //      `define SZ_BYTE 3'b000
    //      `define SZ_HALF 3'b001
    //      `define SZ_WORD 3'b010

    // HRESP transfer response signal encoding (define.v)
    //      `define RSP_OKAY  2'b00
    //      `define RSP_ERROR 2'b01
    //      `define RSP_RETRY 2'b10
    //      `define RSP_SPLIT 2'b11


//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

    //wire            valid;
    wire            valid_reg;
    wire            ac_enable;      // Address & Contorl Register Enable

    reg     [31:0]  next_addr;
    reg     [1:0]   next_trans;
    reg             next_write;
    reg     [2:0]   next_size;
    reg     [2:0]   next_burst;

    reg             HSEL_reg;
    reg     [31:0]  HADDR_reg;
    reg     [1:0]   HTRANS_reg;
    reg             HWRITE_reg;
    reg     [2:0]   HSIZE_reg;
    reg     [2:0]   HBURST_reg;

    reg     [3:0]   byte_enable;

    reg     [1:0]   current_state;
    reg     [1:0]   next_state;

    reg     [3:0]   cur_count;
    reg     [3:0]   nxt_count;
    
    reg     [1:0]   iHRESP;
    reg             iHREADY_out;

    wire            EBT; //Early Burst Termination

//==============================================================================
// Beginning of main code
//==============================================================================

//------------------------------------------------------------------------------
// Valid transfer detection
//------------------------------------------------------------------------------
// The slave must only respond to a valid transfer, so this must be detected.

    always@(posedge HCLK or negedge HRESETn)
    begin

        if (!HRESETn)
            HSEL_reg <= 1'b0;
        else
            begin
            if (HREADY_in)
                HSEL_reg <= HSELx;
            end

    end

// Valid AHB transfers only take place when a non-sequential or sequential
//  transfer is shown on HTRANS - an idle or busy transfer should be ignored.

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
    assign ac_enable = HSELx & HREADY_in;


    // next contorl wire
    always@(ac_enable or HADDR or HTRANS or HWRITE or HSIZE or HBURST or
            HADDR_reg or HTRANS_reg or HWRITE_reg or HSIZE_reg or HBURST_reg)
    begin

        if(ac_enable)
            begin
            next_addr  = HADDR;
            next_trans = HTRANS;
            next_write = HWRITE;
            next_size  = HSIZE;
            next_burst = HBURST;
            end
        else
            begin
            next_addr  = HADDR_reg;
            next_trans = HTRANS_reg;
            next_write = HWRITE_reg;
            next_size  = HSIZE_reg;
            next_burst = HBURST_reg;
            end
    end



    // control registers
    always@(posedge HCLK or negedge HRESETn)
    begin
        if (!HRESETn)
            begin
            HADDR_reg  <= 32'h0000_0000;
            HTRANS_reg <= 2'b00;
            HWRITE_reg <= 1'b0;
            HSIZE_reg  <= 3'b000;
            HBURST_reg <= 3'b000;
            end
        else
            begin
            HADDR_reg  <= next_addr;
            HTRANS_reg <= next_trans;
            HWRITE_reg <= next_write;
            HSIZE_reg  <= next_size;
            HBURST_reg <= next_burst;
            end
    end

//------------------------------------------------------------------------------
// Write data byte enable generation
//------------------------------------------------------------------------------
// NOTE - this module is little endian, and must be modified for a big endian
//        system.

    always @(HSIZE_reg or HADDR_reg)
    begin
        //mask = 32'hFFFF_FFFF;
        case (HSIZE_reg)

            `SZ_BYTE :                   // Byte Access
                case (HADDR_reg[1:0])
                    2'b00 : byte_enable = 4'b0001;
                    2'b01 : byte_enable = 4'b0010;
                    2'b10 : byte_enable = 4'b0100;
                    2'b11 : byte_enable = 4'b1000;
                    default  : ;
                endcase

            `SZ_HALF :                   // Halfword Access
                case (HADDR_reg[1])
                    1'b0 : byte_enable = 4'b0011;
                    1'b1 : byte_enable = 4'b1100;
                    default  : ;
                endcase

            default  :                   // Word Access
                byte_enable = 4'b1111;

        endcase
    end


//------------------------------------------------------------------------------
// FSM
//------------------------------------------------------------------------------
// This SlaveWrapper don't have SPLIT/RETRY function.
// A two-cycle response is required for an error condition.

    // FSM next state logic
    always @(current_state or valid_reg or UI_READY or UI_ERROR)
    begin
        case (current_state)

            ST_NORMAL :
                if(valid_reg)
                    begin
                    if(UI_ERROR)
                        next_state = ST_ERROR1 ;
                    else if(~UI_READY)
                        next_state = ST_WAIT;
                    else
                        next_state = ST_NORMAL ;
                    end
                else
                    next_state = ST_NORMAL ;

            ST_WAIT :
                if(UI_ERROR)
                    next_state = ST_ERROR1 ;
                else if(~UI_READY)
                    next_state = ST_WAIT;
                else
                    next_state = ST_NORMAL ;

            // A two-cycle response is required for an error condition
            ST_ERROR1 :
                next_state = ST_ERROR2 ;

            ST_ERROR2 :
                next_state = ST_NORMAL ;

            default :
                next_state = ST_NORMAL ;

        endcase
    end

    // FSM current state
    always@(posedge HCLK or negedge HRESETn)
    begin
        if (!HRESETn)
            current_state <= ST_NORMAL;
        else
            current_state <= next_state;
    end

//------------------------------------------------------------------------------
// Burst Counter 
//------------------------------------------------------------------------------

    always@(posedge HCLK or negedge HRESETn)
    begin

        if(!HRESETn)
            cur_count <= 4'b0000;
        else
            cur_count <= nxt_count;
    end

    always@(HTRANS or HBURST or ac_enable or cur_count)
    begin

        case(HTRANS)
            `TRN_IDLE   :   nxt_count = 4'b0000;
            `TRN_BUSY   :   nxt_count = cur_count;
            `TRN_NONSEQ :   begin
                            case(HBURST)
                                `BUR_INCR16 : nxt_count = 4'b1111;
                                `BUR_WRAP16 : nxt_count = 4'b1111;
                                `BUR_INCR8  : nxt_count = 4'b0111;
                                `BUR_WRAP8  : nxt_count = 4'b0111;
                                `BUR_INCR4  : nxt_count = 4'b0011;
                                `BUR_WRAP4  : nxt_count = 4'b0011;
                                `BUR_INCR   : nxt_count = 4'b0000;
                                `BUR_SINGLE : nxt_count = 4'b0000 ;
                            endcase                            
                            end
            `TRN_SEQ    :   begin
                            if(ac_enable)
                                nxt_count = (cur_count == 4'b0000) ? 4'b0000 : cur_count - 4'b0001 ;               
                            else
                                nxt_count = cur_count;
                            end     
        endcase
        
    end
                
    assign  EBT = (cur_count!=4'b0000) & (HTRANS!=`TRN_SEQ) ;

//------------------------------------------------------------------------------
// Output drivers
//------------------------------------------------------------------------------

    //iHRESP
    always @(current_state)
    begin

        case (current_state)
            ST_NORMAL :     iHRESP = `RSP_OKAY ;
            ST_WAIT   :     iHRESP = `RSP_OKAY ;
            ST_ERROR1 :     iHRESP = `RSP_ERROR ;
            ST_ERROR2 :     iHRESP = `RSP_ERROR ;
            default :       iHRESP = `RSP_OKAY ;
        endcase

    end


    //iHREADY_out
    always @(current_state or UI_ERROR or UI_READY or valid_reg)
    begin

        case (current_state)
            ST_NORMAL :     iHREADY_out = (valid_reg==1'b1)
                                             ? (~UI_ERROR)&(UI_READY)
                                             : 1'b1 ;
            ST_WAIT   :     iHREADY_out = (~UI_ERROR)&(UI_READY);
            ST_ERROR1 :     iHREADY_out = 1'b0 ;
            ST_ERROR2 :     iHREADY_out = 1'b1 ;
            default :       iHREADY_out = 1'b0 ;
        endcase

    end

    // Drive the output ports with the internal versions.
    assign  HREADY_out = (HSEL_reg==1'b1) ? iHREADY_out : 1'b1 ;
    assign  HRESP = iHRESP;

//------------------------------------------------------------------------------
//      User Interface
//------------------------------------------------------------------------------

    // Output Signals
    assign  UI_SEL = valid_reg;
    assign  UI_ADDR = {{12'h000},HADDR_reg[19:0]};
    assign  UI_WRITE = HWRITE_reg;
    assign  UI_BE = byte_enable;
    assign  UI_INFO = (EBT) ? `BUR_SINGLE : HBURST_reg ;
    assign  UI_WDATA = HWDATA;

    // Input Signals
    assign  HRDATA = UI_RDATA;


endmodule
