`timescale 1 ps / 100 fs
module mux2to1 #(parameter N=24)( DataOut, Data0, Data1, Select);
	output [N-1:0] DataOut;
	input [N-1:0] Data0, Data1;
	input Select;
	
	assign DataOut = (Select) ? Data1 : Data0;

endmodule