module mux7to1 #(parameter N = 24) (
    input wire [N-1:0] D0,  // Data input 0
    input wire [N-1:0] D1,  // Data input 1
    input wire [N-1:0] D2,  // Data input 2
    input wire [N-1:0] D3,  // Data input 3
    input wire [N-1:0] D4,  // Data input 4
    input wire [N-1:0] D5,  // Data input 5
    input wire [N-1:0] D6,  // Data input 6
    input wire [2:0]  Sel, // Select input (3-bit)
    output wire [N-1:0] Y   // Output
);

    logic [N-1:0] Y_wire;
    always @(*) begin
        case (Sel)
            3'b000: Y_wire = D0;  // Select input 0 when Sel is 000
            3'b001: Y_wire = D1;  // Select input 1 when Sel is 001
            3'b010: Y_wire = D2;  // Select input 2 when Sel is 010
            3'b011: Y_wire = D3;  // Select input 3 when Sel is 011
            3'b100: Y_wire = D4;  // Select input 4 when Sel is 100
            3'b101: Y_wire = D5;  // Select input 5 when Sel is 101
            3'b110: Y_wire = D6;  // Select input 6 when Sel is 110
        endcase
    end

    assign Y = Y_wire;

endmodule