//32 bit register 
module register(RegOut,RegIn,WriteEn,reset,clk); 
	output [31:0] RegOut;
	input [31:0] RegIn;
	input WriteEn,reset, clk;
	reg [31:0] q_reg;
	 
	always @(posedge clk or posedge reset)
		if (reset)
			q_reg = 32'h00000000; // On reset, set to 0
		else if (WriteEn)
			q_reg = RegIn; // Otherwise RegOut = RegIn 

	assign RegOut = q_reg;

endmodule