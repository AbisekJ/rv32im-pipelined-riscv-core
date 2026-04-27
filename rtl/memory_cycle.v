module memory(
    input clk,
    input rst,
    input [31:0] ImmExtM,
    input RegWriteM,
    input MemWriteM,
    input [1:0] ResultSrcM,
    input [4:0] RdM,
    input is_m_instrM,
    input [31:0] InstrM,
    input [31:0] ALUResultM,
    input [31:0] WriteDataM,
    input [31:0] PCPlus4M,
    input [31:0] m_resultM,

    output reg RegWriteW,
    output reg [1:0] ResultSrcW,
    output reg [4:0] RdW,

    output reg [31:0] ALUResultW,
    output reg [31:0] ReadDataW,
    output reg [31:0] PCPlus4W,
    output reg [31:0] m_resultW,
    output reg is_m_instrW,
    output reg [31:0] ImmExtW
);

wire [31:0] ReadData;

data_mem #(32,32,100) datamem(
    clk,
    rst,
    MemWriteM,
    InstrM[14:12],
    ALUResultM,
    WriteDataM,
    ReadData
);

always @(posedge clk or posedge rst) begin
    if(rst) begin
        RegWriteW <= 0;
        ResultSrcW<= 0;
        RdW       <= 0;
        ALUResultW<= 0;
        ReadDataW <= 0;
        PCPlus4W  <= 0;
        m_resultW <= 0;
        is_m_instrW <= 0;
        ImmExtW <= 0;
    end
    else begin
        RegWriteW <= RegWriteM;
        ResultSrcW<= ResultSrcM;
        RdW       <= RdM;
        ALUResultW<= ALUResultM;
        ReadDataW <= ReadData;
        PCPlus4W  <= PCPlus4M;
        m_resultW <= m_resultM;
        is_m_instrW <= is_m_instrM;
        ImmExtW <= ImmExtM;
    end
end

endmodule

