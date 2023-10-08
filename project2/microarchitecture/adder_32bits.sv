module adder_32bits 
	 (input logic [31:0] A,
	  input logic [31:0] B,
	  input logic Cin,
	  output logic [31:0] R,
	  output C,
	  output N,
	  output V,
	  output Z);
	  
	logic [32:0] cins, B_logic;
	assign cins[0] = Cin;
	assign B_logic = (Cin) ? ~B : B;

	genvar i;
	
	generate
		for (i = 0; i < 32; i += 1) begin : GenAdders
			full_adder U1 (.A(A[i]), .B(B_logic[i]), .cin(cins[i]), .cout(cins[i + 1]),
									.R(R[i]));
		end
	endgenerate
	
	assign C = cins[32];
	assign N = R[31];
	assign Z = ~(R || '0) && ~C;
	assign V = (~Cin && (A[31] == B[31]) && (R[31] != A[31])) || (Cin && (A[31] != B[31]) && (R[31] != A[31])); 

endmodule
