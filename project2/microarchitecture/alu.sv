`timescale 1 ps / 100 fs
module alu (
	Output, CarryOut, zero, overflow, negative, BussA, BussB, ALUControl
);
    input [31:0] BussA;        // Input A (32-bit)
    input [31:0] BussB;        // Input B (32-bit)
    input [1:0] ALUControl; // ALU Control (2-bit)
    output [31:0] Output;  // ALU Result (32-bit)
    output CarryOut;           // Carry Out
    output zero;           // Zero Flag
    output overflow;       // Overflow Flag
    output negative;        // Negative Flag

	logic [31:0] output_add, output_sub, slt, xori;
	logic C_add, C_sub, Z_add, Z_sub, V_add, V_sub, N_add, N_sub;

	adder_32bits add(.A(BussA), .B(BussB), .Cin(0), .R(output_add), .C(C_add), .N(N_add), .V(V_add), .Z(Z_add));
	adder_32bits sub(.A(BussA), .B(BussB), .Cin(1), .R(output_sub), .C(C_sub), .N(N_sub), .V(V_sub), .Z(Z_sub));
	assign xori = BussA ^ BussB;
	assign slt = (BussA < BussB) ? 32'b1 : 32'b0;
	mux4to1 #(32) mux_result(output_add, xori, output_sub, slt, ALUControl, Output);
	mux4to1 #(1) mux_C(C_add, 0, C_sub, 0, ALUControl, CarryOut);
	mux4to1 #(1) mux_Z(Z_add, 0, Z_sub, 0, ALUControl, zero);
	mux4to1 #(1) mux_V(V_add, 0, V_sub, 0, ALUControl, overflow);
	mux4to1 #(1) mux_N(N_add, 0, N_sub, 0, ALUControl, negative);

endmodule