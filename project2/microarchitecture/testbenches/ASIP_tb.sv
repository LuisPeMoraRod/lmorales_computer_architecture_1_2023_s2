`timescale 1 ps / 100 fs
module ASIP_tb();

reg clk, reset;
logic [23:0] PC, instruction, WBRegData;
logic [3:0] WBReg;
logic beqControl;

ASIP dut(clk, reset, PC, instruction, WBRegData, WBReg, beqControl);
initial clk = 0;
always #10000 clk = ~clk;

initial 
begin
  reset = 1;
  #20000;
  reset = 0;
  
  #300000;

  reset = 1;
  #20000;
  reset = 0;
  
  #60000;
  $finish;
end
endmodule