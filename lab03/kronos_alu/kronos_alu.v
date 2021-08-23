module kronos_alu(  op1,
                    op2,
                    aluop,
                    result
                    );
input  [31:0] op1;
input  [31:0] op2;
input  [3:0]  aluop;
output reg [31:0] result;

wire          cin;
wire          rev;

wire   [31:0] r_adder;
wire   [31:0] r_and;
wire   [31:0] r_or;
wire   [31:0] r_xor;
wire   [31:0] r_shift;

wire   [31:0] adder_A;
wire   [31:0] adder_B;
wire          cout;

wire          r_lt;
wire          r_ltu;
wire          r_comp;

wire   [31:0] data;
wire   [4:0]  shamt;
wire          shift_in;
wire   [31:0] p0;
wire   [31:0] p1;
wire   [31:0] p2;
wire   [31:0] p3;
wire   [31:0] p4;

// ============================================================
//  Operation Decode
assign cin = aluop[3] || aluop[1];    // SUB & Compare
assign rev = ~aluop[2];

// ============================================================
//                           ADDER
// ============================================================

// if the operation is SUB, invert op2 (adder_b) before add operation
assign adder_A = op1;
assign adder_B = ((aluop[3:0] == 4'b1000) || (aluop[3:0] == 4'b0010))?((~op2)):op2;

// Add Operation
assign {cout, r_adder} = {1'b0, adder_A} + {1'b0, adder_B} + cin;


// ============================================================
//                            LOGIC
// ============================================================

assign r_and = op1 & op2;
assign r_or  = op1 | op2;
assign r_xor = op1 ^ op2;

// ============================================================
//                     COMPARATOR (SLT & SLTU)
//-------------------------------------------------------------
//  if (aluop[0]==1) ==> Unsigned
//  op1[31]  op2[31]
//     0        0    --> = 2'complement
//     0        1    --> op1 > op2 0
//     1        0    --> op1 < op2 1
//     1        1    --> = 2'complement
// ============================================================

// Signed Less Than (SLT)
assign r_lt = (op1[31] > op2[31])?1'b1:
              (op1[31] < op2[31])?1'b0:
              r_adder[31];

// Unsigned Less Than (SLTU) : check the carry out on op1-op2
assign r_ltu = ~cout;

// Select output
assign r_comp = (aluop[0] == 1) ? r_ltu : r_lt;

// ============================================================
//                      BARREL SHIFTER
// ============================================================

// Reverse data to the shifter for SHL operations
assign data = rev ? {<<{op1}} : op1;
assign shift_in = cin & op1[31];
assign shamt = op2[4:0];

// The barrel shifter is formed by a 5-level fixed RIGHT-shifter
// that pipes in the value of the last stage

assign p0 = shamt[0] ? {    shift_in  , data[31:1]} : data;
assign p1 = shamt[1] ? {{ 2{shift_in}}, p0[31:2]}   : p0;
assign p2 = shamt[2] ? {{ 4{shift_in}}, p1[31:4]}   : p1;
assign p3 = shamt[3] ? {{ 8{shift_in}}, p2[31:8]}   : p2;
assign p4 = shamt[4] ? {{16{shift_in}}, p3[31:16]}  : p3;

// Reverse last to get SHL result
assign r_shift = rev ? {<<{p4}} : p4;


// ============================================================
// Result Mux
always@(*) begin
  case(aluop)
    4'b0010,                                    // SLT
    4'b0011     : result = {31'b0, r_comp};     // SLTU
    4'b0100     : result = r_xor;               // XOR
    4'b0110     : result = r_or;                // OR
    4'b0111     : result = r_and;               // AND
    4'b0001,                                    // SLL
    4'b0101,                                    // SRL
    4'b1101     : result = r_shift;             // SRA
    default     : result = r_adder;             // ADD, SUB
  endcase
end

endmodule