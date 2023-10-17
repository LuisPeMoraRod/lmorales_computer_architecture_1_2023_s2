`timescale 1 ps / 100 fs
// Sign-Extension
module sign_extend(sOut24,sIn13);
    output [23:0] sOut24;
    input [12:0] sIn13;
    assign sOut24 = {{16{sIn13[12]}},sIn13};
endmodule