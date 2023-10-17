`timescale 1 ps / 100 fs
// ALU Control unit
module ALUControl_Block( ALUControl, ALUOp, funct);
	output [1:0] ALUControl;
	reg [2:0] ALUControl;
	input [1:0] ALUOp;
	input [5:0] funct;
	wire [7:0] ALUControlIn;
	assign ALUControlIn = {ALUOp,funct};
	always @(ALUControlIn)
	casex (ALUControlIn)
		8'b11xxxxxx: ALUControl=3'b001; //xor for xori
		8'b00xxxxxx: ALUControl=3'b000; //add for sw-lw
		8'b01xxxxxx: ALUControl=3'b010; //sub for beq
		8'b10100000: ALUControl=3'b000; //add for R-type add
		8'b10100010: ALUControl=3'b010; //sub for R-type sub
		8'b10101010: ALUControl=3'b011; //less than for R-type slt
		8'b10000000: ALUControl=3'b100; //shift left for R-type sll
		8'b10000010: ALUControl=3'b101; //shift right for R-type srl
		8'b10100011: ALUControl=3'b110; //mult for R-type mult
		default: ALUControl=3'b000;
	endcase
endmodule