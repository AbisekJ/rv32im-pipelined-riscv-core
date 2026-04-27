module data_mem #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 32, MEM_SIZE = 64)(
    input clk,
    input rst,
    input WE,
    input [2:0] func3,
    input [31:0] A, WD,
    output [31:0] ReadData
);
  reg [DATA_WIDTH-1:0] Dmemory [0:MEM_SIZE-1];
  integer k;

  always @(posedge clk) begin
  if (rst) begin
      for (k = 0; k < MEM_SIZE; k = k + 1)
        Dmemory[k] <= 0;
    end
   else if (WE) begin
      case (func3)
        3'd0: Dmemory[A] <= {24'b0, WD[7:0]};      // SB
        3'd1: Dmemory[A] <= {16'b0, WD[15:0]};     // SH
        3'd2: Dmemory[A] <= WD;                    // SW
        default: Dmemory[A] <= WD;                
      endcase
    end
  end
 
  assign ReadData = (func3 == 3'b000)? {{24{Dmemory[A][7]}}, Dmemory[A][7:0]}:
                    ((func3 == 3'b001)? {{16{Dmemory[A][15]}}, Dmemory[A][15:0]}:
                    ((func3 == 3'b100)? {24'b0, Dmemory[A][7:0]}:
                    ((func3 == 3'b101)? {16'b0, Dmemory[A][15:0]}: Dmemory[A])));

endmodule