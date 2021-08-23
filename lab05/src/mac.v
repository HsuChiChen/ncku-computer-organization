module MAC(clk, rstz,
           req_valid, req_funct7, req_rs1, req_rs2, req_ready,
           rsp_ready, rsp_rd, rsp_valid,
           mem_rdata, mem_addr, mem_en);

input             clk;
input             rstz;

// request interface
input             req_valid;
input      [6:0]  req_funct7;
input      [31:0] req_rs1;
input      [31:0] req_rs2;
output reg        req_ready;

// response interface
input             rsp_ready;
output     [31:0] rsp_rd;
output reg        rsp_valid;

// memory interface
input      [31:0] mem_rdata;
output reg [31:0] mem_addr;
output reg        mem_en;

reg [1:0]  state, nstate;
reg [3:0]  i;
reg [31:0] result;
wire [31:0] kernel[0:8];

assign rsp_rd = result;


assign kernel[0] = 32'd1;
assign kernel[1] = 32'd1;
assign kernel[2] = 32'd1;
assign kernel[3] = 32'd1;
assign kernel[4] = 32'd1;
assign kernel[5] = 32'd1;
assign kernel[6] = 32'd1;
assign kernel[7] = 32'd1;
assign kernel[8] = 32'd1;

parameter RST    = 2'd0;
parameter LOAD_I = 2'd1;
parameter LOAD   = 2'd2;
parameter RESULT = 2'd3;

always @(posedge clk or negedge rstz) begin
    if (~rstz) 
        state <= RST;
    else
        state <= nstate;
end

always @(*) begin
    case(state)
        RST:    nstate = (req_funct7[0] && req_valid)?LOAD_I:RST;
        LOAD_I: nstate = LOAD;
        LOAD:   nstate = (i==4'd8)?RESULT:LOAD;
        RESULT: nstate = (req_funct7[1] && req_valid)?RST:RESULT;
        default: nstate = RST;
    endcase
end

always @(posedge clk) begin
    case(state)
        RST : begin
            req_ready <= 1'b1;
            rsp_valid <= 1'b0;
            mem_en <= 1'b0;
            result <= 32'd0;
            i <= 4'd0;
            mem_addr <= req_rs1 + { 28'd0, i};
        end
        LOAD_I : begin
            mem_en <= 1'b1;
        end
        LOAD : begin
            req_ready <= 1'b0;
            mem_en <= 1'b1;
            result <= result + mem_rdata * kernel[i];
            i <= (i==4'd8)?i:(i + 4'd1);
            mem_addr <= mem_addr + 32'd4;
        end
        RESULT : begin
            req_ready <= 1'b1;
            rsp_valid <= 1'b1;
        end
    endcase
end

endmodule