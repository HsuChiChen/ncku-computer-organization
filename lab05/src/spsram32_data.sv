// Copyright (c) 2020 Sonal Pinto
// SPDX-License-Identifier: Apache-2.0

// 32-bit byte-addressable Single Port SRAM model

module spsram32_data #(
    parameter WORDS = 4096,
    parameter AWIDTH = 32,
    parameter logic MASK_WR_ONLY = 0
)(
    input  logic                clk,
    input  logic [AWIDTH-1:0]   addr,
    input  logic [31:0]         wdata,
    output logic [31:0]         rdata,
    input  logic                en,
    input  logic                wr_en,
    input  logic [3:0]          mask
);

parameter D = $clog2(WORDS);

logic [31:0] DATA [WORDS];
logic [D-1:0] adr;

assign adr = addr[2+:D];

always_ff @(posedge clk) begin
    if (en) begin
        if (wr_en) begin
            for (int i=0; i<4; i++) begin
                if (mask[i]) DATA[adr][i*8+:8] <= wdata[i*8+:8];
            end
        end
        else begin
            if (MASK_WR_ONLY) rdata <=  DATA[adr];
            else begin
                for (int i=0; i<4; i++) begin
                    if (mask[i]) rdata[i*8+:8] <= DATA[adr][i*8+:8];
                    else rdata[i*8+:8] <= 'x;
                end
            end
        end
    end
end

endmodule