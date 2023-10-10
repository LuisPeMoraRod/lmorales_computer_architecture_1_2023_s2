`timescale 1 ps / 100 fs
module mux3x32to32(DataOut,A,B,C,Select);
	output [31:0] DataOut;
	input [1:0] Select;
	input [31:0] A,B,C;

	logic [31:0] DataOut_wire;

	always @(*) begin
		 case (Select)
			2'b00: DataOut_wire = A;
			2'b01: DataOut_wire = B;
			2'b10: DataOut_wire = C;
			default: DataOut_wire = 32'b0;
		 endcase
	  end
	
	assign DataOut = DataOut_wire;

endmodule