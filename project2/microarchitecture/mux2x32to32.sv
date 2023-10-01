`timescale 1 ps / 100 fs
// fpga4student.com: FPGA projects, Verilog Projects, VHDL projects
// Verilog project: 32-bit 5-stage Pipelined MIPS Processor in Verilog 
// mux2x32to32
module mux2x32to32( DataOut, Data0, Data1, Select);
	output [31:0] DataOut;
	input [31:0] Data0, Data1;
	input Select;
	
	assign DataOut = (Select) ? Data1 : Data0;

endmodule