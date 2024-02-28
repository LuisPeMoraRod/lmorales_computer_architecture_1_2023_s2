`timescale 1 ps / 100 fs
module InstructionMem #(parameter N=24) (sel, instruction, address);

input [N-1:0] address;
input sel;
output [N-1:0] instruction;
reg [N-1:0]instrmem_a0[255:0]; //reverberation script
reg [N-1:0]instrmem_a1[255:0]; //dereverberation script
reg [N-1:0] temp;

buf #1000 buf0(instruction[0],temp[0]),
   buf1(instruction[1],temp[1]),
   buf2(instruction[2],temp[2]),
   buf3(instruction[3],temp[3]),
   buf4(instruction[4],temp[4]),
   buf5(instruction[5],temp[5]),
   buf6(instruction[6],temp[6]),
   buf7(instruction[7],temp[7]),
   buf8(instruction[8],temp[8]),
   buf9(instruction[9],temp[9]),
   buf10(instruction[10],temp[10]),
   buf11(instruction[11],temp[11]),
   buf12(instruction[12],temp[12]),
   buf13(instruction[13],temp[13]),
   buf14(instruction[14],temp[14]),
   buf15(instruction[15],temp[15]),
   buf16(instruction[16],temp[16]),
   buf17(instruction[17],temp[17]),
   buf18(instruction[18],temp[18]),
   buf19(instruction[19],temp[19]),
   buf20(instruction[20],temp[20]),
   buf21(instruction[21],temp[21]),
   buf22(instruction[22],temp[22]),
   buf23(instruction[23],temp[23]);

always @(address)
begin
 temp = (sel) ? instrmem_a1[address] : instrmem_a0[address];
end

initial
begin
   // $readmemb("script0.txt", instrmem_a0);
   // $readmemb("script1.txt", instrmem_a1);
   $readmemb("../../script0.txt", instrmem_a0);
   $readmemb("../../script1.txt", instrmem_a1);
end

endmodule
