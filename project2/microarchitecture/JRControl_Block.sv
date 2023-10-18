`timescale 1 ps / 100 fs
// Control singals for JR instruction
module JRControl_Block( JRControl, ALUOp, Funct);
	output JRControl;
	reg JRControl;
	input [1:0] ALUOp;
	input [3:0] Funct;
	wire [5:0] jr_funct;
	assign jr_funct = {ALUOp,Funct};
	always @(jr_funct)
	case (jr_funct)
		6'b100110 : JRControl=1'b1; 
		default: JRControl=1'b0;
	endcase
endmodule