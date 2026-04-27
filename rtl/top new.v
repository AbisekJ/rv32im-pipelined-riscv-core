module t1c_riscv_cpu (
    input         clk, reset,
    input         Ext_MemWrite,
    input  [31:0] Ext_WriteData, Ext_DataAdr,
    output        MemWrite,
    output [31:0] WriteData, DataAdr, ReadData, PCD, ResultW
);

wire [31:0] PCPlus4D;
wire [31:0] InstrD;

wire RegWriteE, MemWriteE;
wire ALUSrcAE;                  
wire [1:0] ALUSrcBE;            
wire [1:0] ResultSrcE;
wire [4:0] ALUControlE;         
wire [31:0] RD1E, RD2E, ImmExtE, PCE, PCPlus4E, InstrE;
wire [4:0] RdE, Rs1E, Rs2E;
wire is_m_instrE;
wire BranchE, JumpE;                   

wire [1:0] PCSrcE;
wire [31:0] ImmExtW, ImmExtM;

wire RegWriteM, MemWriteM;
wire [1:0] ResultSrcM;
wire [31:0] ALUResultM, WriteDataM, PCPlus4M, m_resultM, InstrM;
wire [4:0] RdM;
wire is_m_instrM;

wire RegWriteW;
wire [1:0] ResultSrcW;
wire [4:0] RdW;
wire [31:0] ALUResultW, ReadDataW, PCPlus4W, m_resultW;
wire is_m_instrW;

wire [1:0] ForwardAE, ForwardBE;
wire StallF, StallD, FlushD, FlushE, lwStall;
wire [31:0] PCTargetE;
wire zero, lt, gt, nzero;

fetch fetch_stage(
    .clk(clk),
    .rst(reset),
    .FlushD(FlushD),
    .StallD(StallD),
    .StallF(StallF),
    .PCSrcE(PCSrcE),
    .PCTargetE(PCTargetE),
    .ALUResultM(ALUResultM),
    .InstrD(InstrD),
    .PCD(PCD),
    .PCPlus4D(PCPlus4D)
);

decode decode_stage(
    .clk(clk),
    .rst(reset),
    .RegWriteW(RegWriteW),
    .InstrD(InstrD),
    .PCD(PCD),
    .PCPlus4D(PCPlus4D),
    .ResultW(ResultW),
    .zero(zero),                
    .nzero(nzero),
    .lt(lt),
    .gt(gt),
    .RdW(RdW),
    .RegWriteE(RegWriteE),
    .MemWriteE(MemWriteE),
    .ALUSrcAE(ALUSrcAE),        
    .ALUSrcBE(ALUSrcBE),        
    .ResultSrcE(ResultSrcE),
    .ALUControlE(ALUControlE),
    .RD1E(RD1E),
    .RD2E(RD2E),
    .ImmExtE(ImmExtE),
    .PCE(PCE),
    .PCPlus4E(PCPlus4E),
    .InstrE(InstrE),
    .RdE(RdE),
    .Rs1E(Rs1E),
    .Rs2E(Rs2E),
    .is_m_instrE(is_m_instrE),
    .BranchE(BranchE),
    .JumpE(JumpE),
    .FlushE(FlushE)
);

execute execute_stage(
    .clk(clk),
    .rst(reset),
    .ForwardAE(ForwardAE),
    .ForwardBE(ForwardBE),
    .RD1E(RD1E),
    .RD2E(RD2E),
    .ResultW(ResultW),
    .InstrE(InstrE),
    .ImmExtE(ImmExtE),
    .PCE(PCE),                  
    .PCPlus4E(PCPlus4E),
    .RdE(RdE),
    .ALUControlE(ALUControlE),
    .RegWriteE(RegWriteE),
    .MemWriteE(MemWriteE),
    .BranchE(BranchE),          
    .ALUSrcAE(ALUSrcAE),        
    .ALUSrcBE(ALUSrcBE),        
    .ResultSrcE(ResultSrcE),
    .is_m_instrE(is_m_instrE),
    .ALUResultM(ALUResultM),
    .WriteDataM(WriteDataM),
    .PCPlus4M(PCPlus4M),
    .m_resultM(m_resultM),
    .InstrM(InstrM),
    .RdM(RdM),
    .RegWriteM(RegWriteM),
    .MemWriteM(MemWriteM),
    .ResultSrcM(ResultSrcM),
    .is_m_instrM(is_m_instrM),
    .PCTargetE(PCTargetE),     
    .PCSrcE(PCSrcE),
    .ImmExtM(ImmExtM),
    .zero(zero),                
    .nzero(nzero),
    .lt(lt),
    .gt(gt)
);

memory memory_stage(
    .clk(clk),
    .rst(reset),
    .RegWriteM(RegWriteM),
    .MemWriteM(MemWriteM),
    .ResultSrcM(ResultSrcM),
    .RdM(RdM),
    .is_m_instrM(is_m_instrM),
    .InstrM(InstrM),
    .ALUResultM(ALUResultM),
    .WriteDataM(WriteDataM),
    .PCPlus4M(PCPlus4M),
    .m_resultM(m_resultM),
    .RegWriteW(RegWriteW),
    .ResultSrcW(ResultSrcW),
    .RdW(RdW),
    .ImmExtM(ImmExtM),
    .ALUResultW(ALUResultW),
    .ReadDataW(ReadDataW),
    .PCPlus4W(PCPlus4W),
    .m_resultW(m_resultW),
    .is_m_instrW(is_m_instrW),
    .ImmExtW(ImmExtW)
);

writeback writeback_stage(
    .RegWriteW(RegWriteW),
    .is_m_instrW(is_m_instrW),
    .ResultSrcW(ResultSrcW),
    .ALUResultW(ALUResultW),
    .m_resultW(m_resultW),
    .ReadDataW(ReadDataW),
    .PCPlus4W(PCPlus4W),
    .ResultW(ResultW),
    .ImmExtW(ImmExtW)
);

hazard_unit hazard(
    .rst(reset),
    .Rs1E(Rs1E),
    .Rs2E(Rs2E),
    .RdM(RdM),
    .RdW(RdW),
    .RegWriteM(RegWriteM),
    .RegWriteW(RegWriteW),
    .ResultSrcE0(ResultSrcE[0]),
    .Rs1D(InstrD[19:15]),       
    .Rs2D(InstrD[24:20]),
    .is_m_instrW (is_m_instrW),      // ADD THIS LINE       
    .RdE(RdE),                  
    .PCSrcE(|PCSrcE),           
    .ForwardAE(ForwardAE),
    .ForwardBE(ForwardBE),
    .lwStall(lwStall),
    .StallF(StallF),
    .StallD(StallD),
    .FlushD(FlushD),
    .FlushE(FlushE)
);

assign MemWrite  = (Ext_MemWrite && reset) ? 1'b1 : MemWriteM;
assign WriteData = (Ext_MemWrite && reset) ? Ext_WriteData : WriteDataM;
assign DataAdr   = reset ? Ext_DataAdr : ALUResultM;
assign ReadData  = ReadDataW;

endmodule
