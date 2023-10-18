`timescale 1 ps / 100 fs
// ALU Control unit
module ALUControl_Block( ALUControl, ALUOp, funct);
	output [1:0] ALUControl;
	reg [2:0] ALUControl;
	input [1:0] ALUOp;
	input [3:0] funct;
	wire [5:0] ALUControlIn;
	assign ALUControlIn = {ALUOp,funct};
	always @(ALUControlIn)
	casex (ALUControlIn)
		6'b11xxxx: ALUControl=3'b001; //xor for xori
		6'b00xxxx: ALUControl=3'b000; //add for sw-lw
		6'b01xxxx: ALUControl=3'b010; //sub for beq
		6'b100000: ALUControl=3'b000; //add for R-type add
		6'b100001: ALUControl=3'b010; //sub for R-type sub
		6'b100010: ALUControl=3'b110; //mult for R-type mult
		6'b100011: ALUControl=3'b100; //shift left for R-type sll
		6'b100100: ALUControl=3'b101; //shift right for R-type srl
		6'b100101: ALUControl=3'b011; //less than for R-type slt
		default: ALUControl=3'b000;
	endcase
endmodule