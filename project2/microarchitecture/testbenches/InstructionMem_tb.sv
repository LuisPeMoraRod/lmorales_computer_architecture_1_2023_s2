`timescale 1 ps / 100 fs
module InstructionMem_tb();

	reg [31:0] addr;
	wire [31:0] instr;

	InstructionMem dut(instr, addr);

	initial begin
		addr=32'd0;
		$display("Mem Address=%h instruction=%b",addr,instr);
		#10000 addr=32'd4;
		$display("Mem Address=%h instruction=%b",addr,instr);
		#10000 addr=32'd8;
		$display("Mem Address=%h instruction=%b",addr,instr);
		#10000 addr=32'd12;
		$display("Mem Address=%h instruction=%b",addr,instr);
		#10000 addr=32'd16;
		$display("Mem Address=%h instruction=%b",addr,instr);
		#10000 addr=32'd20;
		$display("Mem Address=%h instruction=%b",addr,instr);
		#10000 addr=32'd24;
		$display("Mem Address=%h instruction=%b",addr,instr);
		#10000 addr=32'd28;
		$display("Mem Address=%h instruction=%b",addr,instr);
		#10000;
		$finish;
	end

endmodule