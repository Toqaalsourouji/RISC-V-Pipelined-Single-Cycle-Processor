module RCA #(parameter n=4)(  
    input [n-1:0] A,
    input [n-1:0] B,
    input cin,
    output [n-1:0] Sum,
    output Cout
);

wire [n-1:0] c; 

genvar i;
    generate
   for (i=0; i<=n-1; i=i+1) begin
    if(i==0) begin
        FullAdder toqa(A[0], B[0], cin, Sum[0], c[0]);
    end
    else begin
        FullAdder adham(A[i], B[i], c[i-1], Sum[i], c[i]);
    end
    end
endgenerate

assign Cout = c[n-1];
   
endmodule
