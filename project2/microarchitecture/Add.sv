`timescale 1 ps / 100 fs
// Verilog code for 32-bit adder 
module Add #(parameter N=24) (S,A,B);
    output [N-1:0] S;
    input [N-1:0] A,B;

    wire C, N, V, Z;

    adder_32bits adder(A, B, 0, S, C, N, V, Z);

endmodule