`timescale 1 ps / 100 fs
// Verilog code for 32-bit adder 
module Add #(parameter N=24) (S,A,B);
    output [N-1:0] S;
    input [N-1:0] A,B;

    wire C, Neg, V, Z;

    adder #(24) adder(A, B, 0, S, C, Neg, V, Z);

endmodule