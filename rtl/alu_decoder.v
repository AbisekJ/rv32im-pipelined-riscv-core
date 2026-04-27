module alu_decoder(
    input  [6:0] opcode,
    input [2:0] func3,
    input [6:0] func7,
    input [1:0] ALUOp,
    output reg [4:0] ALUControl
);

always @(*) begin
  if(opcode == 7'd99) begin // B-type
    case(func3)
    3'b000: ALUControl = 5'b10000; // beq
    3'b001: ALUControl = 5'b01111;  // bne
    3'b100: ALUControl = 5'b01101; // bltu
    3'b101: ALUControl = 5'b01100; // bge
    3'b110: ALUControl = 5'b00101; // bltu
    3'b111: ALUControl = 5'b01110; // bgeu
    default: ALUControl = 5'b00000;
    endcase
  end
  else if(func7!=7'd1) begin
    case (ALUOp)
        2'b00: ALUControl = 5'b00000;             // addition
        2'b01: ALUControl = 5'b00001;             // subtraction
        default: begin
            case (func3) // R-type or I-type ALU
                3'b000: begin
                    // True for R-type subtract
                    if   (func7[5] & opcode[5]) ALUControl = 5'b00001; //sub
                    else ALUControl = 5'b00000; // add, addi
                end
                3'b001:  ALUControl = 5'b00111; // sll
                3'b101:  begin
                    if (opcode == 7'd19) ALUControl = (func7[5] ^ opcode[5])? 5'b01010: 5'b01011; // srli, srai
                    else ALUControl = (func7[5] & opcode[5])? 5'b01000: 5'b01001; // srl, sra
                end
                3'b100:  ALUControl = 5'b00100; // xor
                3'b010:  ALUControl = 5'b00101; // slt, slti
                3'b011:  ALUControl = 5'b00110; // sltu
                3'b110:  ALUControl = 5'b00011; // or, ori
                3'b111:  ALUControl = 5'b00010; // and, andi
                default: ALUControl = 5'bxxxxx; // ???
            endcase
          end
       endcase
     end
     else ALUControl = 5'd0; // m-ext
   end
endmodule