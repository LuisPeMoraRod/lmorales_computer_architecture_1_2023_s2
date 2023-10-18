`timescale 1 ps / 100 fs
module dataMem_tb();

	logic [31:0] data, addr, writedata, MemRead;
	logic writeenable, clk;

	dataMem dut(data, addr, writedata, writeenable,MemRead,clk);

	always #5 clk = ~clk;

	initial begin
		clk <= 0;
		writeenable <= 0;
		writedata <= 32'b0;
		addr=32'd0;
		#10;
		$display("Mem Address=%h data=%b",addr,data);
		addr=32'd1;
		#10;
		$display("Mem Address=%h data=%b",addr,data);
		addr=32'd2;
		#10; 
		$display("Mem Address=%h data=%b",addr,data);
		addr=32'd3;
		#10; 
		$display("Mem Address=%h data=%b",addr,data);
		writeenable <= 1;
		writedata <= 32'h00000007;
		addr=32'd4;
		#10
		writeenable <= 1;
		$display("Mem Address=%h data=%b",addr,data);
		$finish;
	end

endmodule
