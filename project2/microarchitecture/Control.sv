`timescale 1 ps / 100 fs
// Control unit
module Control(
RegDst,
ALUSrc,
MemtoReg,
RegWrite,
MemRead,
MemWrite,
Branch,
ALUOp,
Jump,
SignZero,
BranchSrc,
Opcode,
Funct
);

output RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,Jump,SignZero,BranchSrc;
output [1:0] ALUOp;
input [2:0] Opcode; 
input [3:0] Funct;

reg RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,Jump,SignZero,BranchSrc;
reg [1:0] ALUOp;

logic isShift;
assign isShift = (Funct == 4'h3) || (Funct == 4'h4);

always @(*)
casex (Opcode)
 3'b000 : begin // R - type
     RegDst = 1'b1;
     ALUSrc = (isShift) ? 1'b1 : 1'b0;
     MemtoReg= 1'b0;
     RegWrite= 1'b1;
     MemRead = 1'b0;
     MemWrite= 1'b0;
     Branch = 1'b0;
     BranchSrc = 1'b0;
     ALUOp = 2'b10;
     Jump = 1'b0;
     SignZero= 1'b0;
    end
 3'b001 : begin // xori - XOR immidiate
     RegDst = 1'b0;
     ALUSrc = 1'b1;
     MemtoReg= 1'b0;
     RegWrite= 1'b1;
     MemRead = 1'b0;
     MemWrite= 1'b0;
     Branch = 1'b0;
     BranchSrc = 1'b0;
     ALUOp = 2'b11;
     Jump = 1'b0;
     SignZero= 1'b0; // zero extend
    end
 3'b010 : begin // beq - branch on equal
     RegDst = 1'b0;
     ALUSrc = 1'b0;
     MemtoReg= 1'b0;
     RegWrite= 1'b0;
     MemRead = 1'b0;
     MemWrite= 1'b0;
     Branch = 1'b1;
     BranchSrc = 1'b0;
     ALUOp = 2'b01;
     Jump = 1'b0;
     SignZero= 1'b0; // sign extend
    end
 3'b011 : begin // bgt - branch on greater than
     RegDst = 1'b0;
     ALUSrc = 1'b0;
     MemtoReg= 1'b0;
     RegWrite= 1'b0;
     MemRead = 1'b0;
     MemWrite= 1'b0;
     Branch = 1'b1;
     BranchSrc = 1'b1;
     ALUOp = 2'b01;
     Jump = 1'b0;
     SignZero= 1'b0; // sign extend
    end
 3'b100 : begin // sw - store word
     RegDst = 1'bx;
     ALUSrc = 1'b1;
     MemtoReg= 1'bx;
     RegWrite= 1'b0;
     MemRead = 1'b0;
     MemWrite= 1'b1;
     Branch = 1'b0;
     BranchSrc = 1'b0;
     ALUOp = 2'b00;
     Jump = 1'b0;
     SignZero= 1'b0;
    end
 3'b101 : begin // lw - load word
     RegDst = 1'b0;
     ALUSrc = 1'b1;
     MemtoReg= 1'b1;
     RegWrite= 1'b1;
     MemRead = 1'b1;
     MemWrite= 1'b0;
     Branch = 1'b0;
     BranchSrc = 1'b0;
     ALUOp = 2'b00;
     Jump = 1'b0;
     SignZero= 1'b0; // sign extend
    end
 3'b110 : begin // j - Jump
     RegDst = 1'b0;
     ALUSrc = 1'b0;
     MemtoReg= 1'b0;
     RegWrite= 1'b0;
     MemRead = 1'b0;
     MemWrite= 1'b0;
     Branch = 1'b0;
     BranchSrc = 1'b0;
     ALUOp = 2'b00;
     Jump = 1'b1;
     SignZero= 1'b0;
    end
 default : begin 
     RegDst = 1'b0;
     ALUSrc = 1'b0;
     MemtoReg= 1'b0;
     RegWrite= 1'b0;
     MemRead = 1'b0;
     MemWrite= 1'b0;
     Branch = 1'b0;
     BranchSrc = 1'b0;
     ALUOp = 2'b10;
     Jump = 1'b0;
     SignZero= 1'b0;
    end
 
endcase

endmodule