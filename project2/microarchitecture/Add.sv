`timescale 1 ps / 100 fs
// Verilog code for 32-bit adder 
module Add(S,A,B);
    output [31:0] S;
    input [31:0] A,B;

    wire C, N, V, Z;

    adder_32bits adder(A, B, 0, S, C, N, V, Z);

endmodule