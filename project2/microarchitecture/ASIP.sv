`timescale 1 ps / 100 fs
// Top level Verilog code for 24-bit 5-stage Pipelined ASIP Processor 
module ASIP(clk, reset, audio_sel, outPC, outInstruction, outWriteData, outWriteRegister, outBranchControl);
		input clk, reset, audio_sel;

		//output for testbenches
		output [23:0] outPC, outInstruction, outWriteData;
		output [5:0] outWriteRegister;
		output outBranchControl;

		wire [23:0] PC, PCin;
		wire [23:0] PCp1,ID_PCp1,EX_PCp1; //PC + 1
		wire [23:0] PCbne,PCp1bne,PCj,PCp1bnej,PCjr; // PC signals in MUX
		wire [23:0] Instruction,ID_Instruction,EX_Instruction; // Output of Instruction Memory
		wire [2:0] Opcode;
		wire [3:0] Funct;

		// Extend
		wire [15:0] imm13; // immediate in I type instruction
		wire [23:0] Im13_Ext,EX_Im13_Ext;
		wire [23:0] sign_ext_out,zero_ext_out;
		// regfile
		wire [3:0] rs,rt,rd,EX_rs,EX_rt,EX_rd,EX_WriteRegister,MEM_WriteRegister,WB_WriteRegister;
		wire [23:0] WB_WriteData, ReadData1, ReadData2,ReadData1Out,ReadData2Out, EX_ReadData1, EX_ReadData2;

		// ALU
		wire [23:0] Bus_A_ALU,Bus_B_ALU,Bus_B_forwarded;
		wire [23:0] EX_ALUResult,MEM_ALUResult,WB_ALUResult;
		wire ZeroFlag, gtFlag, BFlag, OverflowFlag, CarryFlag, NegativeFlag;

		wire [23:0] WriteDataOfMem,MEM_ReadDataOfMem,WB_ReadDataOfMem;

		//Control signals 
		wire RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,BranchSrc,Jump,SignZero,JRControl;
		wire ID_RegDst,ID_ALUSrc,ID_MemtoReg,ID_RegWrite,ID_MemRead,ID_MemWrite,ID_Branch,ID_BranchSrc,ID_JRControl;
		wire EX_RegDst,EX_ALUSrc,EX_MemtoReg,EX_RegWrite,EX_MemRead,EX_MemWrite,EX_Branch,EX_BranchSrc,EX_JRControl;
		wire MEM_MemtoReg,MEM_RegWrite,MEM_MemRead,MEM_MemWrite;
		wire WB_MemtoReg,WB_RegWrite;
		wire [1:0] ALUOp,ID_ALUOp,EX_ALUOp;
		wire [2:0] ALUControl;
		wire branchControl,notbranchControl;
		wire JumpControl,JumpFlush;
		wire [1:0] ForwardA,ForwardB;
			 //flush
		wire IF_flush,IFID_flush,notIFID_flush,Stall_flush,flush;
		//shift left
		wire [23:0] shiftleft2_bne_out,shiftleft2_jump_out; // shift left output
		// PC Write Enable, IF/ID Write Enable
		wire PC_WriteEn,IFID_WriteEn;


		//====== PC register======
		register PC_Reg(PC,PCin,PC_WriteEn,reset,clk);
		Add Add1(PCp1,PC,{23'b0,1'b1}); // PCp1 = PC + 1

		InstructionMem InstructionMem1(audio_sel, Instruction, PC);

		// register IF/ID

		register IFID_PCp1(ID_PCp1,PCp1,IFID_WriteEn,reset,clk);
		register IFID_Instruction(ID_Instruction,Instruction,IFID_WriteEn,reset,clk);
		RegBit IF_flush_bit(IFID_flush,IF_flush, IFID_WriteEn,reset, clk);

		//========= ID STAGE===========
		assign Opcode = ID_Instruction[23:21];
		assign rs = ID_Instruction[20:17];
		assign rt = ID_Instruction[16:13];
		assign rd = ID_Instruction[12:9];
		assign Funct = ID_Instruction[3:0];
		assign imm13= ID_Instruction[12:0];

		 // Main Control
		Control MainControl(
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

		 // Regfile
		regfile Register_File(
		ReadData1,
		ReadData2,
		WB_WriteData,
		rs,
		rt,
		WB_WriteRegister,
		WB_RegWrite,
		reset,
		clk);

		// forward Read Data if Write and Read at the same time
		WB_forward  WB_forward_block(ReadData1Out,ReadData2Out,ReadData1,ReadData2,rs,rt,WB_WriteRegister,WB_WriteData,WB_RegWrite);
		 // Sign-extend
		sign_extend sign_extend1(sign_ext_out,imm13);
		 // Zero-extend
		zero_extend zero_extend1(zero_ext_out,imm13);
		 // immediate extend: sign or zero
		mux2to1 #(24) muxSignZero( Im13_Ext,sign_ext_out,zero_ext_out, SignZero);

		JRControl_Block JRControl_Block1( JRControl, ALUOp, Funct);

		Discard_Instr Discard_Instr_Block(ID_flush,IF_flush,JumpControl,branchControl,EX_JRControl);

		or #(50) OR_flush(flush,ID_flush,IFID_flush,Stall_flush);
		flush_block flush_block1(ID_RegDst,ID_ALUSrc,ID_MemtoReg,ID_RegWrite,ID_MemRead,ID_MemWrite,ID_Branch,ID_BranchSrc,ID_ALUOp,
		ID_JRControl,flush,RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,BranchSrc,ALUOp,JRControl);

		//==========EX STAGE=========================
		// thanh ghi ID/EX
		register IDEX_PCp1(EX_PCp1,ID_PCp1,1'b1,reset,clk);

		register IDEX_ReadData1(EX_ReadData1,ReadData1Out,1'b1,reset,clk);
		register IDEX_ReadData2(EX_ReadData2,ReadData2Out,1'b1,reset,clk);


		register IDEX_Im13_Ext(EX_Im13_Ext,Im13_Ext,1'b1,reset,clk);
		register IDEX_rs_rt_rd(EX_Instruction[23:0],ID_Instruction,1'b1,reset,clk);
		assign EX_rs = EX_Instruction[20:17];
		assign EX_rt = EX_Instruction[16:13];
		assign EX_rd = EX_Instruction[12:9];
		// 9 control signals via ID/EX
		RegBit  IDEX_RegDst(EX_RegDst, ID_RegDst, 1'b1,reset, clk);
		RegBit  IDEX_ALUSrc(EX_ALUSrc, ID_ALUSrc, 1'b1,reset, clk);
		RegBit  IDEX_MemtoReg(EX_MemtoReg, ID_MemtoReg, 1'b1,reset, clk);
		RegBit  IDEX_RegWrite(EX_RegWrite, ID_RegWrite, 1'b1,reset, clk);
		RegBit  IDEX_MemRead(EX_MemRead, ID_MemRead, 1'b1,reset, clk);
		RegBit  IDEX_MemWrite(EX_MemWrite, ID_MemWrite, 1'b1,reset, clk);
		RegBit  IDEX_Branch(EX_Branch, ID_Branch, 1'b1,reset, clk);
		RegBit  IDEX_BranchSrc(EX_BranchSrc, ID_BranchSrc, 1'b1,reset, clk);
		RegBit  IDEX_JRControl(EX_JRControl, ID_JRControl, 1'b1,reset, clk);
		RegBit  IDEX_ALUOp1(EX_ALUOp[1], ID_ALUOp[1], 1'b1,reset, clk);
		RegBit  IDEX_ALUOp0(EX_ALUOp[0], ID_ALUOp[0], 1'b1,reset, clk);
		//  Forwarding unit
		ForwardingUnit Forwarding_Block(ForwardA,ForwardB,MEM_RegWrite,WB_RegWrite,MEM_WriteRegister,WB_WriteRegister,EX_rs,EX_rt);
		// mux 3x24 to 1 to choose source of ALU (forwarding)
		mux3to1 #(24)  mux3A(Bus_A_ALU,EX_ReadData1,MEM_ALUResult,WB_WriteData,ForwardA);
		mux3to1 #(24)  mux3B(Bus_B_forwarded,EX_ReadData2,MEM_ALUResult,WB_WriteData,ForwardB);
		// mux 2x24 to 1 to select source Bus B of ALU
		mux2to1 #(24) muxALUSrc( Bus_B_ALU,Bus_B_forwarded,EX_Im13_Ext, EX_ALUSrc);
		// ALU Control
		ALUControl_Block ALUControl_Block1( ALUControl, EX_ALUOp, EX_Im13_Ext[3:0]);
		// EX_Im13_Ext[3:0] is funct

		// ALU
		alu alu_block(EX_ALUResult, CarryFlag, ZeroFlag, gtFlag, OverflowFlag, NegativeFlag, Bus_A_ALU, Bus_B_ALU, ALUControl);

		// mux 2x4 to 1 choose shift register is Rd or Rt
		mux2to1 #(4) muxRegDst( EX_WriteRegister,EX_rt,EX_rd, EX_RegDst);

		//==============MEM STAGE=================
		// register EX/MEM
		register EXMEM_ALUResult(MEM_ALUResult,EX_ALUResult,1'b1,reset,clk);
		register EXMEM_WriteDataOfMem(WriteDataOfMem, Bus_B_forwarded,1'b1,reset,clk);
		RegBit  EXMEM_MemtoReg(MEM_MemtoReg, EX_MemtoReg, 1'b1,reset, clk);
		RegBit  EXMEM_RegWrite(MEM_RegWrite, EX_RegWrite, 1'b1,reset, clk);
		RegBit  EXMEM_MemRead(MEM_MemRead, EX_MemRead, 1'b1,reset, clk);
		RegBit  EXMEM_MemWrite(MEM_MemWrite, EX_MemWrite, 1'b1,reset, clk);
		RegBit  EXMEM_WriteRegister3(MEM_WriteRegister[3], EX_WriteRegister[3], 1'b1,reset, clk);
		RegBit  EXMEM_WriteRegister2(MEM_WriteRegister[2], EX_WriteRegister[2], 1'b1,reset, clk);
		RegBit  EXMEM_WriteRegister1(MEM_WriteRegister[1], EX_WriteRegister[1], 1'b1,reset, clk);
		RegBit  EXMEM_WriteRegister0(MEM_WriteRegister[0], EX_WriteRegister[0], 1'b1,reset, clk);

		 // Data Memory 
		dataMem dataMem1(MEM_ReadDataOfMem, //data 
			  MEM_ALUResult,       //address
			  WriteDataOfMem,       //writedata
			  MEM_MemWrite,        //writeenable
			  MEM_MemRead,        
			  clk);
		//==========WB STAGE====================
		// register MEM/WB
		register MEMWB_ReadDataOfMem(WB_ReadDataOfMem,MEM_ReadDataOfMem,1'b1,reset,clk);
		register MEMWB_ALUResult(WB_ALUResult,MEM_ALUResult,1'b1,reset,clk);
		RegBit  MEMWB_WriteRegister3(WB_WriteRegister[3], MEM_WriteRegister[3], 1'b1,reset, clk);
		RegBit  MEMWB_WriteRegister2(WB_WriteRegister[2], MEM_WriteRegister[2], 1'b1,reset, clk);
		RegBit  MEMWB_WriteRegister1(WB_WriteRegister[1], MEM_WriteRegister[1], 1'b1,reset, clk);
		RegBit  MEMWB_WriteRegister0(WB_WriteRegister[0], MEM_WriteRegister[0], 1'b1,reset, clk);

		RegBit  MEMWB_MemtoReg(WB_MemtoReg, MEM_MemtoReg, 1'b1,reset, clk);
		RegBit  MEMWB_RegWrite(WB_RegWrite, MEM_RegWrite, 1'b1,reset, clk);

		 // Select Data to WriteData for regfile
		mux2to1 #(24) muxMemtoReg( WB_WriteData, WB_ALUResult, WB_ReadDataOfMem,WB_MemtoReg);

		//Stalling
		StallControl StallControl_block(PC_WriteEn,IFID_WriteEn,Stall_flush,EX_MemRead,EX_rt,rs,rt,Opcode);

		//j, beq, bgt , jr
		
		// beq and bgt
		Add Add_beq(PCbne,EX_PCp1,EX_Im13_Ext); // use same immediate instead of imm * 4
		assign BFlag = (EX_BranchSrc) ? gtFlag : ZeroFlag;
		and #(50) andbranchControl(branchControl,EX_Branch, BFlag);
		mux2to1 #(24)  muxbranchControl( PCp1bne,PCp1, PCbne, branchControl);
		
		// jump
		assign PCj = {ID_PCp1[23:21],ID_Instruction[20:0]}; //assign PC the new address where to jump

		not #(50) notIFIDFlush(notIFID_flush,IFID_flush);
		and #(50) andJumpFlush(JumpFlush,Jump,notIFID_flush);
		not #(50) notbne(notbranchControl,branchControl);
		and #(50) andJumpBNE(JumpControl,JumpFlush,notbranchControl);
		mux2to1 #(24)  muxJump( PCp1bnej,PCp1bne, PCj, JumpControl);

		 // JR: Jump Register
		assign PCjr = Bus_A_ALU;
		mux2to1 #(24)  muxJR( PCin,PCp1bnej, PCjr, EX_JRControl);

		// Testbench signals
		assign outPC = PC;
		assign outInstruction = Instruction;
		assign outWriteRegister = WB_WriteRegister;
		assign outWriteData = WB_WriteData;
		assign outBranchControl = branchControl;

endmodule