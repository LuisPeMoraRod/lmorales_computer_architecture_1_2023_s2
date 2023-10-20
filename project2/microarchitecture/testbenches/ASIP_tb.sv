`timescale 1 ps / 100 fs
module ASIP_tb();

reg clk, reset, sel;
logic [23:0] PC, instruction, WBRegData;
logic [3:0] WBReg;
logic branchControl;

microarchitecture dut(clk, reset, sel, PC, instruction, WBRegData, WBReg, branchControl);
initial clk = 0;
always #10000 clk = ~clk;

initial 
begin
  sel = 1;
  reset = 1;
  #20000;
  reset = 0;
  
  #160000;

  reset = 1;
  sel = 0;
  #20000;
  reset = 0;
  
  #260000;
  $finish;
end
endmodule