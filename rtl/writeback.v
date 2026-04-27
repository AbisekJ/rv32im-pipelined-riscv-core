module writeback(
    input RegWriteW,
    input is_m_instrW,
    input [1:0] ResultSrcW,
    input [31:0] ImmExtW,

    input [31:0] ALUResultW,
    input [31:0] m_resultW,
    input [31:0] ReadDataW,
    input [31:0] PCPlus4W,
    output [31:0] ResultW
);

wire [31:0] Op_ResultW;

mux2 #(32) mux_IvsM(ALUResultW, m_resultW, is_m_instrW, Op_ResultW);

mux4 #(32) result_mux(
    Op_ResultW,
    ReadDataW,
    PCPlus4W,
    ImmExtW,
    ResultSrcW,
    ResultW
);

endmodule

