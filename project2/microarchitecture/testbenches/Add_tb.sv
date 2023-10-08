`timescale 1 ps / 100 fs
module Add_tb();
	logic [31:0] A, B, S;
	
	Add dut(S, A, B);

	initial begin
		A <= 32'b101;
		B <= 32'b100;
		#10;
		$display("A=%d, B=%d, S=A+B=%d", A, B, S);

		$finish;
	end

endmodule
