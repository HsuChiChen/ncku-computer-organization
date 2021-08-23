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
// File Name           : MISR32x8.v,v
// File Revision       : 1.2
// 
// Release Information : 
// 
//----------------------------------------------------------------------
// Purpose             : Design for test
// ---------------------------------------------------------------------
// Revision History    : Revision 1.0  2007/02/16 13:28 York Lin
//                   Initial revision
//           Revision 1.1  2007/05/07 07:34 Tai-Hua Lu
//           Using primitive polynomial 
//           X^190 + X^47 + X^2 +X^1 + 1
//           Pal = 2^(-190) = 6.37237e-58
//           Revision 1.2  2007/05/07 07:48 Tai-Hua Lu
//                   Add nWait singal in MISR for testing
//====================================================================--

// synopsys translate_off
//`include "timescale.v"
// synopsys translate_on

module testMISRreg(
        // Input signal from System
            nWAIT,
            //System
            clk,
            rst_n,
            //Write
            reg_num,
            write_data,
            write_mask,
            write_enable,
            //Read
            read_data,
        //core output
        core_out
            );
            
    // Input signal from System
        input       nWAIT;
    
        //System
        input           clk;            // System clk
        input           rst_n;          // System nReset

        //Write
        input   [2:0]   reg_num;        // Wirte/Read registers number
        input   [31:0]  write_data;     // Write data bus
        input   [31:0]  write_mask;     // Write data mask
        input           write_enable;   // Write enable

        //Read
        output  [31:0]  read_data;      // Read data bus
    
    //core_out
    input   [189:0] core_out;

        reg     [7:0]   addr_decode;
        wire    [7:0]   reg_enable;
    wire        shift_enable;
    wire        nwait_enable;

        reg     [31:0]  reg0, reg1, reg2, reg3,
                        reg4, reg5, reg6;
        wire    [31:0]  reg_write_data;
        reg     [31:0]  read_data_content;


        //=============================================================
        //      Decode3to8 - Register Selector
        //=============================================================
        always@(reg_num)
        begin
            case(reg_num)
                3'b000: addr_decode = 8'b00000001;
                3'b001: addr_decode = 8'b00000010;
                3'b010: addr_decode = 8'b00000100;
                3'b011: addr_decode = 8'b00001000;
                3'b100: addr_decode = 8'b00010000;
                3'b101: addr_decode = 8'b00100000;
                3'b110: addr_decode = 8'b01000000;
        default:addr_decode = 8'b00000000;
            endcase
    end
        //=============================================================
        //      Register 32bits x 8
        //=============================================================
        assign  reg_enable[0]   = write_enable & addr_decode[0];
        assign  reg_enable[1]   = write_enable & addr_decode[1];
        assign  reg_enable[2]   = write_enable & addr_decode[2];
        assign  reg_enable[3]   = write_enable & addr_decode[3];
        assign  reg_enable[4]   = write_enable & addr_decode[4];
        assign  reg_enable[5]   = write_enable & addr_decode[5];
        assign  reg_enable[6]   = write_enable & addr_decode[6];
        assign  shift_enable    = reg0[0];
        assign  nwait_enable    = reg0[1];

        assign  reg_write_data  = (read_data_content & write_mask)|(write_data & (~write_mask));

        always@(posedge clk or negedge rst_n)begin
                if ((!rst_n))
                        reg0<=32'b0;
                else if (reg_enable[0])
                        reg0<=reg_write_data;
                else    reg0<=reg0;
        end
    always@(posedge clk or negedge rst_n)begin
                if ((!rst_n))
                        reg1<=32'b0;
                else if (shift_enable&&(~nwait_enable||nWAIT)) 
                begin
                    reg1[0]<=core_out[0]^reg1[0]^reg1[1]^reg2[15]^reg6[29];
                    reg1[31:1]<=core_out[31:1]^reg1[30:0];
        end
        else if (reg_enable[1])
                        reg1<=reg_write_data;
                else    reg1<=reg1;
        end
    always@(posedge clk or negedge rst_n)begin
                if ((!rst_n))
                        reg2<=32'b0;
        else if (shift_enable&&(~nwait_enable||nWAIT)) reg2<=core_out[63:32]^{reg2[30:0],reg1[31]};
                else if (reg_enable[2])
                        reg2<=reg_write_data;
                else    reg2<=reg2;
        end
    always@(posedge clk or negedge rst_n)begin
                if ((!rst_n))
                        reg3<=32'b0;
        else if (shift_enable&&(~nwait_enable||nWAIT)) reg3<=core_out[95:64]^{reg3[30:0],reg2[31]};
                else if (reg_enable[3])
                        reg3<=reg_write_data;
                else    reg3<=reg3;
        end
    always@(posedge clk or negedge rst_n)begin
                if ((!rst_n))
                        reg4<=32'b0;
        else if (shift_enable&&(~nwait_enable||nWAIT)) reg4<=core_out[127:96]^{reg4[30:0],reg3[31]};
                else if (reg_enable[4])
                        reg4<=reg_write_data;
                else    reg4<=reg4;
        end
    always@(posedge clk or negedge rst_n)begin
                if ((!rst_n))
                        reg5<=32'b0;
        else if (shift_enable&&(~nwait_enable||nWAIT)) reg5<=core_out[159:128]^{reg5[30:0],reg4[31]};
                else if (reg_enable[5])
                        reg5<=reg_write_data;
                else    reg5<=reg5;
        end
    always@(posedge clk or negedge rst_n)begin
                if ((!rst_n))
                        reg6<=32'b0;
        else if (shift_enable&&(~nwait_enable||nWAIT)) reg6<={2'b0,core_out[189:160]^{reg6[28:0],reg5[31]}};
                else if (reg_enable[6])
                        reg6<=reg_write_data;
                else    reg6<=reg6;
        end
    

        //=============================================================
        //      Mux8to1 - read data
        //=============================================================

        always@(reg0 or reg1 or reg2 or reg3 or reg4 or reg5 or reg6 or reg_num)
        begin

            case(reg_num)
                3'b000: read_data_content = reg0;
                3'b001: read_data_content = reg1;
                3'b010: read_data_content = reg2;
                3'b011: read_data_content = reg3;
                3'b100: read_data_content = reg4;
                3'b101: read_data_content = reg5;
                3'b110: read_data_content = reg6;
                default: read_data_content = reg0;
           endcase

        end

     assign  read_data = read_data_content ;
     
endmodule

