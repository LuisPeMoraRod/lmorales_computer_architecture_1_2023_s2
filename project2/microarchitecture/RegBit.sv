module RegBit(BitOut, BitData, WriteEn, reset, clk);
	output BitOut; // 1 bit of register
	input BitData, WriteEn; 
	input reset,clk;
	D_FF DFF0(BitOut, BitData, WriteEn, reset, clk);
endmodule