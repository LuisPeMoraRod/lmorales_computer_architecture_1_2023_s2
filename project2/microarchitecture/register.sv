module register #(parameter N=24) (RegOut,RegIn,WriteEn,reset,clk); 
	output [N-1:0] RegOut;
	input [N-1:0] RegIn;
	input WriteEn,reset, clk;
	reg [N-1:0] q_reg;
	 
	always @(posedge clk or posedge reset)
		if (reset)
			q_reg = 24'h000000; // On reset, set to 0
		else if (WriteEn)
			q_reg = RegIn; // Otherwise RegOut = RegIn 

	assign RegOut = q_reg;

endmodule