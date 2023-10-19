module D_FF (q, d, write_en, reset, clk);
	output q;
	input d, write_en, reset, clk;
	reg q_reg; // Indicate that q is stateholding
	 
	always @(posedge clk or posedge reset)
		if (reset)
			q_reg = 0; // On reset, set to 0
		else if (write_en)
			q_reg = d; // Otherwise out = d 

	assign q = q_reg;
endmodule