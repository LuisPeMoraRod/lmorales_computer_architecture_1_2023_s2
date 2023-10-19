`timescale 1 ps / 100 fs
// Data Memory 
module dataMem(data, address, writedata, writeenable,MemRead,clk);

input [23:0] address, writedata;
input writeenable,MemRead, clk;
output [23:0] data;

logic [17:0] address_ram;
logic [15:0] data_ram, writedata_ram;
assign address_ram = address[17:0]; //adjust to address size
assign writedata_ram = writedata[15:0]; //adjust to address size

ram ram_data (
	.address ( address_ram ),
	.clock ( ~clk ),
	.data ( writedata_ram ),
	.wren ( writeenable ),
	.q ( data_ram )
	);

assign data = {8'b0 , data_ram};
endmodule