module NBitMux #(N=8)( input [N-1:0] D0, input [N-1:0] D1, input sel, output [N-1:0] Y);

wire [N-1:0] D0;
wire [N-1:0] D1;
wire sel;
wire [N-1:0] Y;

genvar i;
generate 

for( i = 0 ; i < N ; i = i + 1) begin

Mux2X1 MUX( .in2(D0[i]), .in1(D1[i]), .select(sel), .out(Y [i]));


end 
endgenerate
endmodule
