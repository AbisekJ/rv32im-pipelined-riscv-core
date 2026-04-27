module hazard_unit(
    rst, Rs1E, Rs2E, RdM, RdW,
    RegWriteM, RegWriteW, is_m_instrW,   // ADD is_m_instrW
    ResultSrcE0, Rs1D, Rs2D, RdE, PCSrcE,
    ForwardAE, ForwardBE,
    lwStall, StallF, StallD, FlushD, FlushE
);
input rst, RegWriteM, RegWriteW, is_m_instrW, ResultSrcE0, PCSrcE;
input [4:0] Rs1E, Rs2E, RdM, RdW, Rs1D, Rs2D, RdE;
output [1:0] ForwardAE, ForwardBE;
output lwStall, StallF, StallD, FlushD, FlushE;

wire WBwrite = RegWriteW | is_m_instrW;   // either normal or MUL writeback

assign ForwardAE = (!rst) ?
    (((Rs1E == RdM) & RegWriteM)  & (Rs1E != 0)) ? 2'b10 :
    (((Rs1E == RdW) & WBwrite)    & (Rs1E != 0)) ? 2'b01 : 2'b00
    : 2'b00;

assign ForwardBE = (!rst) ?
    (((Rs2E == RdM) & RegWriteM)  & (Rs2E != 0)) ? 2'b10 :
    (((Rs2E == RdW) & WBwrite)    & (Rs2E != 0)) ? 2'b01 : 2'b00
    : 2'b00;

assign lwStall = ResultSrcE0 & ((Rs1D == RdE) | (Rs2D == RdE));
assign StallF  = lwStall;
assign StallD  = lwStall;
assign FlushD  = PCSrcE;
assign FlushE  = lwStall | PCSrcE;
endmodule