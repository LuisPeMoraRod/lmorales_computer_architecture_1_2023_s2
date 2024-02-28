module adder #(parameter N=24)
	 (input logic [N-1:0] A,
	  input logic [N-1:0] B,
	  input logic Cin,
	  output logic [N-1:0] R,
	  output C,
	  output Neg,
	  output V,
	  output Z);
	  
	logic [N:0] cins, B_logic;
	assign cins[0] = Cin;
	assign B_logic = (Cin) ? ~B : B;

	genvar i;
	
	generate
		for (i = 0; i < N; i += 1) begin : GenAdders
			full_adder U1 (.A(A[i]), .B(B_logic[i]), .cin(cins[i]), .cout(cins[i + 1]),
									.R(R[i]));
		end
	endgenerate
	
	assign C = cins[N];
	assign Neg = R[N-1];
	assign Z = (R == 24'h000000) ? 1 : 0;
	assign V = (~Cin && (A[N-1] == B[N-1]) && (R[N-1] != A[N-1])) || (Cin && (A[N-1] != B[N-1]) && (R[N-1] != A[N-1])); 

endmodule
