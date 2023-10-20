`timescale 1 ps / 100 fs
// Discard instructions when needed
module Discard_Instr(ID_flush,IF_flush,jump,branch,jr);
	output ID_flush,IF_flush;
	input jump,branch,jr;
	or #50 OR1(IF_flush,jump,branch,jr);
	or #50 OR2(ID_flush,branch,jr);
endmodule