module execute(
    input clk,
    input rst,
    input [1:0] ForwardAE,
    input [1:0] ForwardBE,
    input [31:0] RD1E,
    input [31:0] RD2E,
    input [31:0] ResultW,
    input [31:0] InstrE,
    input [31:0] ImmExtE,
    input [31:0] PCE,
    input [31:0] PCPlus4E,
    input [4:0] RdE,
    input [4:0] ALUControlE,
    input RegWriteE,
    input MemWriteE,
    input BranchE,
    input ALUSrcAE,             
    input [1:0] ALUSrcBE,      
    input [1:0] ResultSrcE,
    input is_m_instrE,
    output reg [31:0] ALUResultM,
    output reg [31:0] WriteDataM,
    output reg [31:0] PCPlus4M,
    output reg [31:0] m_resultM,
    output reg [31:0] InstrM,
    output reg [4:0] RdM,
    output reg RegWriteM,
    output reg MemWriteM,
    output reg [1:0] ResultSrcM,
    output reg is_m_instrM,
    output reg [31:0] ImmExtM,
    output [31:0] PCTargetE,   
    output [1:0] PCSrcE,
    output zero, nzero, lt, gt
);

wire [31:0] tempA, tempB;
wire [31:0] SrcA, SrcB;
wire [31:0] ALUResult;
wire [31:0] m_result;
wire [31:0] FwdMEMval;

assign FwdMEMval = is_m_instrM ? m_resultM : ALUResultM;

// Forwarding muxes
mux3 #(32) fwdA(RD1E, ResultW, FwdMEMval, ForwardAE, tempA);
mux2 #(32) muxA(tempA, PCE, ALUSrcAE, SrcA);   
mux3 #(32) muxB(tempB, ImmExtE, 32'd4, ALUSrcBE, SrcB); 
mux3 #(32) fwdB(RD2E, ResultW, FwdMEMval, ForwardBE, tempB);
// ALU and MDU
alu_unit alu(SrcA, SrcB, ALUControlE, ALUResult, zero, nzero, lt, gt);
mdu_wrapper MDU(SrcA, SrcB, InstrE[14:12], InstrE[31:25], InstrE[6:0], m_result);

// PC target for branches and jumps
adder pc_adder(PCE, ImmExtE, PCTargetE);

assign PCSrcE[0] = (BranchE & zero)  |
                   (BranchE & nzero) |
                   (BranchE & lt)    |
                   (BranchE & gt)    |
                   (InstrE[6:0] == 7'b1101111); // JAL
assign PCSrcE[1] = (InstrE[6:0] == 7'b1100111); // JALR

// Pipeline register EX/MEM
always @(posedge clk or posedge rst) begin
    if(rst) begin
        RegWriteM  <= 0;
        MemWriteM  <= 0;
        ResultSrcM <= 0;
        RdM        <= 0;
        ALUResultM <= 0;
        WriteDataM <= 0;
        PCPlus4M   <= 0;
        m_resultM  <= 0;
        is_m_instrM<= 0;
        InstrM     <= 0;
        ImmExtM <= 0;
    end
    else begin
        RegWriteM  <= RegWriteE;
        MemWriteM  <= MemWriteE;
        ResultSrcM <= ResultSrcE;
        RdM        <= RdE;
        ALUResultM <= ALUResult;
        WriteDataM <= tempB;
        PCPlus4M   <= PCPlus4E;
        m_resultM  <= m_result;
        is_m_instrM<= is_m_instrE;
        InstrM     <= InstrE;
        ImmExtM <= ImmExtE;
    end
end
endmodule
