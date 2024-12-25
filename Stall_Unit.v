module Stall_Unit(input [4:0] IF_ID_Rs1 ,input [4:0] IF_ID_Rs2,input [4:0] ID_EX_RD, input ID_EX_MemRead, output reg Stall);

initial begin
Stall=0;
end
always @(*) begin

if(((IF_ID_Rs1 == ID_EX_RD) || (IF_ID_Rs2 == ID_EX_RD))&& ID_EX_MemRead && (ID_EX_RD !=0))
        Stall=1;
    else
        Stall = 0;
    end

endmodule
