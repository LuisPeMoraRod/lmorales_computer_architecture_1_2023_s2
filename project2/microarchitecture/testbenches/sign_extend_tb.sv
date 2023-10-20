`timescale 1 ps / 100 fs
module sign_extend_tb();
    logic [31:0] out;
    logic [15:0] in;

    sign_extend dut(out, in);

    initial begin
        in <= 16'hfff6;
        #10;
        $display("Input: %b, Output: %b", in, out);
        $finish;
    end
endmodule
