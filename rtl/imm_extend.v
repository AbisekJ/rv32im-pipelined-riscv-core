module ImmExt(input [31:7]imm_in, input [2:0]ImmSrc, output reg [31:0]ImmExt);
  //reg [31:0]temp;
 
  always @(*) begin
    case(ImmSrc)
      3'd1: ImmExt={{20{imm_in[31]}}, imm_in[31:25], imm_in[11:7]}; // S
      3'd0: ImmExt={{20{imm_in[31]}}, imm_in[31:20]}; // I
      3'd2: ImmExt={{20{imm_in[31]}}, imm_in[7], imm_in[30:25], imm_in[11:8], 1'b0}; // B
      3'd3: ImmExt={{12{imm_in[31]}}, imm_in[19:12], imm_in[20], imm_in[30:21], 1'b0}; // J
      3'd4: ImmExt={imm_in[31:12],12'b0}; // u
      default: ImmExt=32'd0;
    endcase
  end
endmodule