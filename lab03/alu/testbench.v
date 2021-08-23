module testbench;

	reg 	[7:0]	a;
	reg 	[7:0]	b;
	reg		[2:0]	op;
	
	wire	[7:0]	result;
	wire			overflow;

	ALU u_alu(a, b, op, result, overflow);
	
	initial  
	begin
		a 	= 0;
		b 	= 0;
		op	= 3'b000;	
	
	#100	// ADD 
		a 	= 8'b10000001;
		b 	= 8'b00000001;
		op	= 3'b000;
		
	#100	// SUB 
		op	= 3'b001;
	//==================== CHECK OVERFLOW ========================
	#100	// ADD 
		a 	= 8'b00000011;
		b 	= 8'b11111111;
		op	= 3'b000;
		
	#100	// SUB 
		op	= 3'b001;
	
	//==================== CHECK LOGIC OPERATION =================
	#100	// AND
		a 	= 8'b11011000;
		b 	= 8'b00011011;
		op	= 3'b100;
		
	#100	// OR
		op	= 3'b101;
		
	#100	// XOR
		op	= 3'b110;
		
	#100	// NOR
		op	= 3'b111;
	
	
		
	#500 $stop;
	end

endmodule	
	
