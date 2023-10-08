module mux4to1 #(parameter N = 32) (
    input wire [N-1:0] D0,  // Data input 0
    input wire [N-1:0] D1,  // Data input 1
    input wire [N-1:0] D2,  // Data input 2
    input wire [N-1:0] D3,  // Data input 3
    input wire [1:0]  Sel, // Select input (2-bit)
    output wire [N-1:0] Y   // Output
);

    logic [N-1:0] Y_wire;
    always @(*) begin
        case (Sel)
            2'b00: Y_wire = D0;  // Select input 0 when Sel is 00
            2'b01: Y_wire = D1;  // Select input 1 when Sel is 01
            2'b10: Y_wire = D2;  // Select input 2 when Sel is 10
            2'b11: Y_wire = D3;  // Select input 3 when Sel is 11
        endcase
    end

    assign Y = Y_wire;

endmodule