// reset_ff.v - 8-bit resettable D flip-flop

module reset_ff #(parameter WIDTH = 8) (
    input       clk, rst, StallF,
    input       [WIDTH-1:0] d,
    output reg  [WIDTH-1:0] q
);

reg init = 1;
always @(posedge clk or posedge rst) begin
    if (rst) begin q <= 0; 
       init <= 0; 
    end
    else if (!init && !rst) begin
        q <= 0;   
        init <= 1;
    end
    else if (StallF) q <= q;
    else     q <= d;
end

endmodule
