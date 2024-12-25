module Forwarding_unit(input EX_MEM_CTRL_regwrite, MEM_WB_CTRL_regwrite, input[4:0] EX_MEM_rd, MEM_WB_rd, EX_MEMRegisterRS1,
EX_MEMRegisterRS2, ID_EX_rs1, ID_EX_rs2, output reg [1:0] Forward_SelA, Forward_SelB );

always@(*)

begin
if ( (EX_MEM_CTRL_regwrite == 1'b1) && (EX_MEM_rd != 0) && ( EX_MEM_rd == ID_EX_rs1) )
Forward_SelA = 2'b10;
else if ( ((MEM_WB_CTRL_regwrite==1'b1) && (MEM_WB_rd != 0) && (MEM_WB_rd== ID_EX_rs1) ) && (!((EX_MEM_CTRL_regwrite==1'b1) && (EX_MEM_rd != 0) && (EX_MEM_rd== ID_EX_rs1))))
Forward_SelA = 2'b01;
else
Forward_SelA = 2'b00;

if ( (EX_MEM_CTRL_regwrite==1'b1) &&( EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs2) )
Forward_SelB = 2'b10;

else if (( (MEM_WB_CTRL_regwrite==1'b1) && ( MEM_WB_rd != 0) && ( MEM_WB_rd == ID_EX_rs2) ) && (!((EX_MEM_CTRL_regwrite==1'b1) && ( EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs2))) )
Forward_SelB = 2'b01;
else
Forward_SelB = 2'b00;

end
endmodule
