module controller(
    input  [6:0] opcode,
    input [2:0] func3,
    input [6:0] func7,
    input zero, nzero, lt, gt,
    output [1:0] ResultSrc,
    output       MemWrite, ALUSrcA, 
    output [1:0] ALUSrcB,
    output       RegWrite, 
    output [2:0] ImmSrc,
    //output [1:0] PCSrc,
    output [4:0] ALUControl,
    output is_m_instr,
    output Jump, Branch
);

wire [1:0] ALUOp;


main_decoder md(opcode, ResultSrc, MemWrite, Branch, ALUSrcA, ALUSrcB, 
             RegWrite, Jump, ImmSrc, ALUOp);
             
alu_decoder ad(opcode, func3, func7, ALUOp, ALUControl );

//assign PCSrc[0] = (Branch & zero)||(Branch & nzero)||(Branch & lt)||(Branch & gt)||(Jump && opcode == 7'd111);  // branch, jal
//assign PCSrc[1] = (opcode == 7'd103); // jalr

assign is_m_instr = (opcode==7'b0110011)&&(func7==7'b0000001); // m-ext

endmodule