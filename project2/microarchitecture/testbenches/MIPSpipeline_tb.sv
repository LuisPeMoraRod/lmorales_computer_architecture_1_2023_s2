`timescale 1 ps / 100 fs
module MIPSpipeline_tb();

reg clk, reset;
logic [31:0] PC, instruction, WBRegData, B, ALU;
logic [5:0] WBReg;
logic beqControl, ALUSrc;

MIPSpipeline  dut(clk, reset, PC, instruction, WBRegData, WBReg, beqControl, B, ALUSrc, ALU);
initial clk = 0;
always #10000 clk = ~clk;

initial 
begin
   reset = 1;
  #20000;
  reset = 0;
  #400000;
  $finish;
end
endmodule