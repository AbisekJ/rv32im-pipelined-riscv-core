module alu_unit(
  input [31:0] SrcA, SrcB,
  input [4:0] ALUControl,
  output reg [31:0] ALUResult,
  output reg zero, nzero, lt, gt
);
  
  always @(*) begin
    // Default assignments to prevent latch inference
    ALUResult = 0;
    zero = 0;
    nzero = 0;
    lt = 0;
    gt = 0;

    case (ALUControl)
      5'b00000:  ALUResult = SrcA + SrcB;                 // ADD
      5'b00001:  ALUResult = SrcA + (~SrcB) + 1'b1;       // SUB
      5'b00010:  ALUResult = SrcA & SrcB;                 // AND
      5'b00011:  ALUResult = SrcA | SrcB;                 // OR
      5'b00100:  ALUResult = SrcA ^ SrcB;                 // XOR
      5'b00101:  begin
                   ALUResult = ($signed(SrcA) < $signed(SrcB)) ? 1 : 0; // SLT
                   lt = ALUResult[0];
                 end
      5'b00110:  ALUResult = (SrcA < SrcB) ? 1 : 0;       // SLTU
      5'b00111:  ALUResult = SrcA << SrcB[4:0];           // SLL
      5'b01000:  ALUResult = $signed(SrcA) >>> SrcB[4:0]; // SRA
      5'b01001:  ALUResult = SrcA >> SrcB[4:0];           // SRL
      5'b01010:  ALUResult = $signed(SrcA) >>> SrcB;      // SRAI
      5'b01011:  ALUResult = SrcA >> SrcB;                // SRLI
      5'b01100:  gt = ($signed(SrcA) >= $signed(SrcB));   // BGE
      5'b01101:  lt = ($signed(SrcA) < $signed(SrcB));    // BLT
      5'b01110:  gt = (SrcA >= SrcB);                     // BGEU
      5'b01111:  nzero = ((SrcA + ~SrcB + 1'b1) != 0) ? 1'b1 : 1'b0; // BNE
      5'b10000:  zero = ((SrcA + ~SrcB + 1'b1) == 0) ? 1'b1 : 1'b0; // BEQ
      default: ; // All values already defaulted above
    endcase
  end
endmodule