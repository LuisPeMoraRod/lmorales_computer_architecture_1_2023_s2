`timescale 1 ps / 100 fs
module alu #(parameter N=24) (
	Output, CarryOut, zero, gt, overflow, negative, BussA, BussB, ALUControl
);
    input [N-1:0] BussA;        // Input A (24-bit)
    input [N-1:0] BussB;        // Input B (24-bit)
    input [2:0] ALUControl; // ALU Control (3-bit)
    output [N-1:0] Output;  // ALU Result (24-bit)
    output CarryOut;           // Carry Out
    output zero;           // Zero Flag
    output gt;           // Greater than Flag
    output overflow;       // Overflow Flag
    output negative;        // Negative Flag

	logic [N-1:0] add, sub, slt, xori, sll, srl, mult;
	logic C_add, C_sub, C_mult, Z_add, Z_sub, Z_mult, V_add, V_sub, V_mult, N_add, N_sub, N_mult, gt_sub;
	logic [4:0] shamt;
	assign shamt = BussB[8:4];

	//add
	adder #(N) adder(.A(BussA), .B(BussB), .Cin(0), .R(add), .C(C_add), .N(N_add), .V(V_add), .Z(Z_add));
	
	//sub
	adder #(N) subtractor(.A(BussA), .B(BussB), .Cin(1), .R(sub), .C(C_sub), .N(N_sub), .V(V_sub), .Z(Z_sub));
	assign gt_sub = ~N_sub & ~V_sub & ~Z_sub;

	//xori
	assign xori = BussA ^ BussB;
	
	//set less than
	assign slt = (BussA < BussB) ? 24'b1 : 24'b0;
	
	//shift left logical
	assign sll = BussA << shamt;

	//shift right logical 
	assign srl = BussA >> shamt;

	//multiplication
	multiplicator #(N) multi(BussA, BussB, mult, Z_mult, C_mult, V_mult, N_mult);

	mux7to1 #(N) mux_result(add, xori, sub, slt, sll, srl, mult, ALUControl, Output);
	mux7to1 #(1) mux_C(C_add, 0, C_sub, 0, 0, 0, C_mult, ALUControl, CarryOut);
	mux7to1 #(1) mux_Z(Z_add, 0, Z_sub, 0, 0, 0, Z_mult, ALUControl, zero);
	mux7to1 #(1) mux_V(V_add, 0, V_sub, 0, 0, 0, V_mult, ALUControl, overflow);
	mux7to1 #(1) mux_N(N_add, 0, N_sub, 0, 0, 0, N_mult, ALUControl, negative);
	mux7to1 #(1) mux_gt(0, 0, gt_sub, 0, 0, 0, 0, ALUControl, gt);

endmodule