`timescale 1 ps / 100 fs
module microarchitecture(clk, reset, audio_sel, outPC, outInstruction, outWriteData, outWriteRegister, outBranchControl);
    input clk, reset, audio_sel;

    //output for testbenches
    output [23:0] outPC, outInstruction, outWriteData;
    output [5:0] outWriteRegister;
    output outBranchControl;

    ASIP asip(clk, reset, audio_sel, outPC, outInstruction, outWriteData, outWriteRegister, outBranchControl);

endmodule
