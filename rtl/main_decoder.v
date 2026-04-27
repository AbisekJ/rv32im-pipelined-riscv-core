module main_decoder(
    input  [6:0] opcode,
    output [1:0] ResultSrc,
    output MemWrite, Branch, ALUSrcA, 
    output [1:0] ALUSrcB,
    output RegWrite, Jump,
    output [2:0] ImmSrc,
    output [1:0] ALUOp
);
reg [13:0] controls;

always @(*) begin
    case (opcode)
        // RegWrite_ImmSrc_ALUSrcA_ALUSrcB_MemWrite_ResultSrc_Branch_ALUOp_Jump
        7'b0000011: controls = 14'b1_000_0_01_0_01_0_00_0; // lw
        7'b0100011: controls = 14'b0_001_0_01_1_00_0_00_0; // sw
        7'b0110011: controls = 14'b1_xxx_0_00_0_00_0_10_0; // R-type, m-ext
        7'b1100011: controls = 14'b0_010_0_00_0_00_1_xx_0; // B-Type
        7'b0010011: controls = 14'b1_000_0_01_0_00_0_10_0; // I-type ALU
        7'b1101111: controls = 14'b1_011_1_10_0_10_0_00_1; // jal
        7'b0110111: controls = 14'b1_100_0_01_0_11_0_00_0; // lui
        7'b0010111: controls = 14'b1_100_1_01_0_00_0_00_0; // auipc
        7'b1100111: controls = 14'b1_000_0_01_0_10_0_00_1; // jalr
        default:    controls = 14'bx_xxx_x_xx_x_xx_x_xx_x; // ???
    endcase
end

assign {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUOp, Jump} = controls;

endmodule