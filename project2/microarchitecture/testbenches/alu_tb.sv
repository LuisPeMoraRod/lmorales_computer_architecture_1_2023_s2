`timescale 1 ps / 100 fs
module alu_tb();
    logic CarryOut,overflow,negative,zero;
    logic [31:0] Output;
    logic [31:0] BussA,BussB;
    logic [1:0] ALUControl;

    alu dut(Output, CarryOut, zero, overflow, negative, BussA, BussB, ALUControl);

    initial begin

        BussA <= 32'hffffffff;
        BussB <= 32'd1;
        ALUControl <= 2'b00;
        #10;
        $display("A=%d\tB=%d\tALUControl=%b\tOutput=%b\tCarryOut=%b\tzero=%b\toverflow=%b\tnegative=%b", BussA, BussB, ALUControl, Output, CarryOut, zero, overflow, negative);

        BussA <= 32'h7fffffff;
        BussB <= 32'd1;
        ALUControl <= 2'b00;
        #10;
        $display("A=%d\tB=%d\tALUControl=%b\tOutput=%b\tCarryOut=%b\tzero=%b\toverflow=%b\tnegative=%b", BussA, BussB, ALUControl, Output, CarryOut, zero, overflow, negative);

        BussA <= 32'd3;
        BussB <= 32'd5;
        ALUControl <= 2'b10;
        #10;
        $display("A=%d\tB=%d\tALUControl=%b\tOutput=%b\tCarryOut=%b\tzero=%b\toverflow=%b\tnegative=%b", BussA, BussB, ALUControl, Output, CarryOut, zero, overflow, negative);

        ALUControl <= 2'b01;
        #10;
        $display("A=%d\tB=%d\tALUControl=%b\tOutput=%b\tCarryOut=%b\tzero=%b\toverflow=%b\tnegative=%b", BussA, BussB, ALUControl, Output, CarryOut, zero, overflow, negative);

        ALUControl <= 2'b11;
        #10;
        $display("A=%d\tB=%d\tALUControl=%b\tOutput=%b\tCarryOut=%b\tzero=%b\toverflow=%b\tnegative=%b", BussA, BussB, ALUControl, Output, CarryOut, zero, overflow, negative);

        BussA <= 32'd5;
        BussB <= 32'd3;
        ALUControl <= 2'b11;
        #10;
        $display("A=%d\tB=%d\tALUControl=%b\tOutput=%b\tCarryOut=%b\tzero=%b\toverflow=%b\tnegative=%b", BussA, BussB, ALUControl, Output, CarryOut, zero, overflow, negative);        $finish;
    end
endmodule