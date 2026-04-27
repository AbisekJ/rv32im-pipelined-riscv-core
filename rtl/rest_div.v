module rest_div(a, b, func3, quo, rem);
input [31:0]a, b;
input [2:0]func3;
output [31:0]quo, rem;

integer i;
reg [63:0]q;
reg [31:0]abs_a, abs_b;

always @(*) begin
if(func3 == 3'd4) begin
abs_a = a[31]? ~a+1'd1: a;
abs_b = b[31]? ~b+1'd1: b;
end
else begin
abs_a = a;
abs_b = b;
end
q = {32'd0, abs_a};
for(i=0;i<32;i=i+1) begin
q = q<<1;
q[63:32] = q[63:32]-abs_b;
if(q[63]) begin
q[63:32] = q[63:32]+abs_b;
q[0] = 1'd0;
end 
else q[0] = 1'd1;
end
end

assign quo = a[31]^b[31]? ~q[31:0]+1'd1: q[31:0];
assign rem = a[31]? ~q[63:32]+1'd1: q[63:32];

endmodule