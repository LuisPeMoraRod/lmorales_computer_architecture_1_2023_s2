`timescale 1 ps / 100 fs
// fpga4student.com: FPGA projects, Verilog Projects, VHDL projects
// Verilog project: 32-bit 5-stage Pipelined MIPS Processor in Verilog 
// Zero-Extension
module zero_extend(zOut24,zIn13);
output [23:0] zOut24;
input [12:0] zIn13;
assign zOut24 = {{11{1'b0}},zIn13};
endmodule