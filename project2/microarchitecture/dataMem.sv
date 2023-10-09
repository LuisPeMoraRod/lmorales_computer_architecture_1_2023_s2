`timescale 1 ps / 100 fs
// Data Memory 
module dataMem(data, address, writedata, writeenable,MemRead,clk);

input [31:0] address, writedata;
input writeenable,MemRead, clk;
output [31:0] data;
logic [5:0] address_ram;
assign address_ram = address[5:0]; //adjust to address size

ram ram_data (
	.address ( address_ram ),
	.clock ( clk ),
	.data ( writedata ),
	.wren ( writeenable ),
	.q ( data )
	);

endmodule