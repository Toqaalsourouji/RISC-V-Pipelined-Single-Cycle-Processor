module Mux2X1(input in2, in1, select, output out);

assign out = select ? in1 : in2;

endmodule
