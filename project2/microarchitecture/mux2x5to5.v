`timescale 1 ps / 100 fs
// fpga4student.com: FPGA projects, Verilog Projects, VHDL projects
// Verilog project: 32-bit 5-stage Pipelined MIPS Processor in Verilog 
// mux2x5to5
// Select Write Register
module mux2x5to5( AddrOut, Addr0, Addr1, Select);
	output [4:0] AddrOut; // Address Out
	input [4:0] Addr0, Addr1; // Address In 1 and 2
	input Select;
	
	assign AddrOut = (Select) ? Addr1 : Addr0;
endmodule