`timescale 1 ps / 100 fs
module alu (
	Output, CarryOut, zero, gt, overflow, negative, BussA, BussB, ALUControl
);
    input [31:0] BussA;        // Input A (32-bit)
    input [31:0] BussB;        // Input B (32-bit)
    input [2:0] ALUControl; // ALU Control (3-bit)
    output [31:0] Output;  // ALU Result (32-bit)
    output CarryOut;           // Carry Out
    output zero;           // Zero Flag
    output gt;           // Greater than Flag
    output overflow;       // Overflow Flag
    output negative;        // Negative Flag

	logic [31:0] output_add, output_sub, slt, xori, output_sll, output_srl;
	logic C_add, C_sub, Z_add, Z_sub, V_add, V_sub, N_add, N_sub, gt_sub;
	logic [5:0] shamt;
	assign shamt = BussB[10:6];

	//add
	adder_32bits add(.A(BussA), .B(BussB), .Cin(0), .R(output_add), .C(C_add), .N(N_add), .V(V_add), .Z(Z_add));
	
	//sub
	adder_32bits sub(.A(BussA), .B(BussB), .Cin(1), .R(output_sub), .C(C_sub), .N(N_sub), .V(V_sub), .Z(Z_sub));
	assign gt_sub = ~N_sub & ~V_sub & ~Z_sub;

	//xori
	assign xori = BussA ^ BussB;
	
	//set less than
	assign slt = (BussA < BussB) ? 32'b1 : 32'b0;
	
	//shift left logical
	assign output_sll = BussA << shamt;

	//shift right logical 
	assign output_srl = BussA >> shamt;

	mux6to1 #(32) mux_result(output_add, xori, output_sub, slt, output_sll, output_srl, ALUControl, Output);
	mux6to1 #(1) mux_C(C_add, 0, C_sub, 0, 0, 0, ALUControl, CarryOut);
	mux6to1 #(1) mux_Z(Z_add, 0, Z_sub, 0, 0, 0, ALUControl, zero);
	mux6to1 #(1) mux_V(V_add, 0, V_sub, 0, 0, 0, ALUControl, overflow);
	mux6to1 #(1) mux_N(N_add, 0, N_sub, 0, 0, 0, ALUControl, negative);
	mux6to1 #(1) mux_gt(0, 0, gt_sub, 0, 0, 0, ALUControl, gt);

endmodule