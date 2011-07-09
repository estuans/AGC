// --------------------------------------------------------------------
// ng_AGC CPM Micro code ROM decoder
// --------------------------------------------------------------------
`include "ControlPulses.h"
// --------------------------------------------------------------------
module ng_SUB(
	input 	  [ 7:0]		SUBSEQ,			// Sub-Sequence input
	output     [22:0]		SUBSEQ_BUS		// Sub sequence output
);

// --------------------------------------------------------------------
// Input assignments:
// --------------------------------------------------------------------
wire 			SB_02 = SUBSEQ[  7];		// Sub-Select 2
wire 			SB_01 = SUBSEQ[  6];		// Sub-Select 1
wire [ 3:0]	SQ    = SUBSEQ[5:2];		// Sequence Pulses
wire 			STB_1	= SUBSEQ[  1];		// Stage 1
wire 			STB_0	= SUBSEQ[  0];		// Stage 0

// --------------------------------------------------------------------
// Output assignments
// --------------------------------------------------------------------
assign SUBSEQ_BUS[22  ] = PINC; 
assign SUBSEQ_BUS[21  ] = MINC; 
assign SUBSEQ_BUS[20:0] = NSUBSQ;

// --------------------------------------------------------------------
// Sub-branch decode
// --------------------------------------------------------------------
wire PINC = !( SB_01 & !SB_02);	// Decode SB signals
wire MINC = !(!SB_01 &  SB_02);  

// --------------------------------------------------------------------
// Sub Sequence decoder - only needed for debugging
// --------------------------------------------------------------------
reg [19:0]  NSUBSQ;                           // Sub sequence output
wire [5:0]  subseq = {SQ[3:0], STB_1,STB_0};  // Decoder address

always @(subseq) begin                                 //      (Dec) (Oct) (Dec   Dec)
   case(subseq)                                        // Sgnl  Indx        Row   Col
      6'b0000_00 : NSUBSQ <= 20'b11111111111111111110; // TC0   =  0  o00 _ 0       0
      6'b0001_00 : NSUBSQ <= 20'b11111111111111111101; // CCS0  =  1  o01 _ 0       1
      6'b0010_00 : NSUBSQ <= 20'b11111111111111111011; // CCS1  =  2  o02 _ 0       2
      6'b0011_00 : NSUBSQ <= 20'b11111111111111110111; // NDX0  =  3  o03 _ 0       3
      6'b1001_00 : NSUBSQ <= 20'b11111111111111101111; // NDX1  =  4  o11 _ 0       4
      6'b1010_00 : NSUBSQ <= 20'b11111111111111011111; // RSM3  =  5  o12 _ 0       5
      6'b1011_00 : NSUBSQ <= 20'b11111111111110111111; // XCH0  =  6  o13 _ 0       6
      6'b1100_00 : NSUBSQ <= 20'b11111111111101111111; // CS0   =  7  o14 _ 0       7
      6'b1101_00 : NSUBSQ <= 20'b11111111111011111111; // TS0   =  8  o15 _ 0       8
      6'b1110_00 : NSUBSQ <= 20'b11111111110111111111; // AD0   =  9  o16 _ 0       9
      6'b1111_00 : NSUBSQ <= 20'b11111111101111111111; // MASK0 = 10  o17 _ 0      10
      6'b0000_01 : NSUBSQ <= 20'b11111111011111111111; // MP0   = 11  o00 _ 1      11
      6'b0001_01 : NSUBSQ <= 20'b11111110111111111111; // MP1   = 12  o01 _ 1      12
      6'b0010_01 : NSUBSQ <= 20'b11111101111111111111; // MP3   = 13  o02 _ 1      13
      6'b1001_01 : NSUBSQ <= 20'b11111011111111111111; // DV0   = 14  o11 _ 1      14
      6'b1010_01 : NSUBSQ <= 20'b11110111111111111111; // DV1   = 15  o12 _ 1      15
      6'b0000_10 : NSUBSQ <= 20'b11101111111111111111; // SU0   = 16  o00 _ 2      16
      6'b0011_10 : NSUBSQ <= 20'b11011111111111111111; // RUPT1 = 17  o03 _ 2      17
      6'b1010_10 : NSUBSQ <= 20'b10111111111111111111; // RUPT3 = 18  o12 _ 2      18
      6'b1011_10 : NSUBSQ <= 20'b01111111111111111111; // STD2  = 19  o13 _ 2      19
      default    : NSUBSQ <= 20'b11111111111111111111; // NOSEQ = XX  All others 
   endcase 
end 

// --------------------------------------------------------------------
endmodule
// --------------------------------------------------------------------

