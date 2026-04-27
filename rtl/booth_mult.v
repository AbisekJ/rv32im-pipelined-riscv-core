module booth_mult(a, b, out);
input signed [31:0]a, b;
output signed [63:0]out;
reg signed [64:0]q;
integer i;
always @(*) begin
q = {32'd0,b,1'd0};
for(i=0;i<32;i=i+1) begin
case(q[1:0])
2'd0, 2'd3: q = q>>>1;
2'd2: begin 
	q[64:33] = q[64:33]-a;
	q = q>>>1;
      end
2'd1: begin 
	q[64:33] = q[64:33]+a;
	q = q>>>1;
      end
endcase
end
end
assign out = q[64:1];
endmodule