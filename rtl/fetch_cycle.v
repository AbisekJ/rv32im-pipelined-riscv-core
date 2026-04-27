module fetch(
    input clk,
    input rst,
    input FlushD,
    input StallD,
    input StallF,
    input [1:0] PCSrcE,
    input [31:0] PCTargetE,
    input [31:0] ALUResultM,
    output reg [31:0] InstrD,
    output reg [31:0] PCD,
    output reg [31:0] PCPlus4D
);

wire [31:0] PC;
wire [31:0] PCNext;
wire [31:0] PCPlus4;
wire [31:0] Instr;

mux3 #(32) pc_mux(PCPlus4, PCTargetE, ALUResultM, PCSrcE, PCNext);

reset_ff #(32) pcreg(clk, rst, StallF, PCNext, PC);

instr_mem instrmem(PC, Instr);

adder add1(PC, 32'd4, PCPlus4);

always @(posedge clk or posedge rst) begin
    if(rst) begin
        InstrD   <= 0;
        PCD      <= 0;
        PCPlus4D <= 0;
    end
    else if (FlushD) begin
        InstrD   <= 32'h00000013;
        PCD      <= 0;
        PCPlus4D <= 0;
    end
    
    else if(!StallD) begin
        InstrD   <= Instr;
        PCD      <= PC;
        PCPlus4D <= PCPlus4;
    end
end

endmodule
