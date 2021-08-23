
module ALU (a, b, op, result, overflow);

	input	[7:0]	a;
	input	[7:0]	b;
	input	[2:0]	op;
	output	[7:0]	result;	
	output			overflow;

	reg 	[8:0]	Result;
//==============================================================
/*			Ins.			op code	
			ADD			000				
			SUB			001
	
			AND			100
			OR			101
			XOR			110
			NOR			111 */
//==============================================================
	assign	result 	 = 	Result[7:0];
	assign  overflow = 	(((op[2:0] == 3'b000)||(op[2:0] == 3'b001)) && (Result[8] == 1'b1))?1'b1:1'b0;
	
	always@(a or b or op)
	begin
		case(op)
			3'b000:	Result = a+b;				// ADD
			3'b001:	Result = a-b;				// SUB
			3'b100:	Result = a&b;				// AND
			3'b101:	Result = a|b;				// OR	
			3'b110:	Result = a^b;				// XOR
			3'b111:	Result = ~(a|b);			// NOR
		endcase
	end
endmodule

