module CU (input rst, input[4:0]inst, input [2:0] funct3, output reg [1:0] Memoffset, output reg Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, jal, jalr, auipc, lui, unsignedflag, output reg [1:0] ALUOp );

always @(*) begin 
if(rst) {Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, jal, jalr, auipc, lui, unsignedflag,Memoffset} = 0;
else

case(inst)
5'b01100:begin // R_format
Branch=1'b0;
MemRead=1'b0;
MemtoReg=1'b0;
ALUOp=2'b10;
MemWrite=1'b0;
ALUSrc=1'b0;
RegWrite=1'b1;
jal = 1'b0;
jalr = 1'b0;
auipc = 1'b0;
lui = 1'b0; 
end

5'b00100:begin // I_format
Branch=1'b0;
MemRead=1'b0;
MemtoReg=1'b0;
ALUOp=2'b11;
MemWrite=1'b0;
ALUSrc=1'b1;
RegWrite=1'b1; 
jal = 1'b0;
jalr = 1'b0;
auipc = 1'b0;
lui = 1'b0; 
end

5'b11000: begin //Branch EQ
Branch=1'b1;
MemRead=1'b0;
MemtoReg=1'bX;
ALUOp=2'b01;
MemWrite=1'b0;
ALUSrc=1'b0;
RegWrite=1'b0;
jal = 1'b0;
jalr = 1'b0;
auipc = 1'b0;
lui = 1'b0; 
end 

5'b11011: begin  //J_format JAL
Branch=1'b0;
MemRead=1'b0;
MemtoReg=1'bX;
ALUOp=2'bxx;
MemWrite=1'b0;
ALUSrc=1'b0;
RegWrite=1'b1;
jal = 1'b1;
jalr = 1'b0;
auipc = 1'b0;
lui = 1'b0;
end 

5'b11001: begin //I_format JALR
Branch=1'b0;
MemRead=1'b0;
MemtoReg=1'bX;
ALUOp=2'bxx;
MemWrite=1'b0;
ALUSrc=1'b0;
RegWrite=1'b1;
jal = 1'b0;
jalr = 1'b1;
auipc = 1'b0;
lui = 1'b0;
end

5'b01101: begin //lui 
Branch=1'b0;
MemRead=1'b0;
MemtoReg=1'bX;
ALUOp=2'bxx;
MemWrite=1'b0;
ALUSrc=1'b0;
RegWrite=1'b1;
jal = 1'b0;
jalr = 1'b0;
auipc = 1'b0;
lui = 1'b1;
end

5'b00101: begin //auipc 
Branch=1'b0;
MemRead=1'b0;
MemtoReg=1'bX;
ALUOp=2'bxx;
MemWrite=1'b0;
ALUSrc=1'b0;
RegWrite=1'b1;
jal = 1'b0;
jalr = 1'b0;
auipc = 1'b1;
lui = 1'b0;
end
endcase 
end 



always @ (inst) begin
if(rst) {Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, jal, jalr, auipc, lui, unsignedflag,Memoffset} = 0;
else

if (inst == 5'b00000 ) 
    if (funct3 == 3'b000) begin // lb
Branch=1'b0;
MemRead=1'b1;
MemtoReg=1'b1;
ALUOp=2'b00;
MemWrite=1'b0;
ALUSrc=1'b1;
RegWrite=1'b1;
jal = 1'b0;
jalr = 1'b0;
auipc = 1'b0;
lui = 1'b0;
unsignedflag = 1'b0;
Memoffset = 2'b01; 
end
   if (funct3 == 3'b001) begin // lh
Branch=1'b0;
MemRead=1'b1;
MemtoReg=1'b1;
ALUOp=2'b00;
MemWrite=1'b0;
ALUSrc=1'b1;
RegWrite=1'b1;
jal = 1'b0;
jalr = 1'b0;
auipc = 1'b0;
lui = 1'b0;
unsignedflag = 1'b0;
Memoffset = 2'b10; 
end
   if (funct3 == 3'b010) begin // lw
Branch=1'b0;
MemRead=1'b1;
MemtoReg=1'b1;
ALUOp=2'b00;
MemWrite=1'b0;
ALUSrc=1'b1;
RegWrite=1'b1;
jal = 1'b0;
jalr = 1'b0;
auipc = 1'b0;
lui = 1'b0;
unsignedflag = 1'b0;
Memoffset = 2'b11; 
end
   if (funct3 == 3'b100) begin // lbu
Branch=1'b0;
MemRead=1'b1;
MemtoReg=1'b1;
ALUOp=2'b00;
MemWrite=1'b0;
ALUSrc=1'b1;
RegWrite=1'b1;
jal = 1'b0;
jalr = 1'b0;
auipc = 1'b0;
lui = 1'b0;
unsignedflag = 1'b1;
Memoffset = 2'b01; 
end
   if (funct3 == 3'b110) begin // lhu
Branch=1'b0;
MemRead=1'b1;
MemtoReg=1'b1;
ALUOp=2'b00;
MemWrite=1'b0;
ALUSrc=1'b1;
RegWrite=1'b1;
jal = 1'b0;
jalr = 1'b0;
auipc = 1'b0;
lui = 1'b0;
unsignedflag = 1'b1;
Memoffset = 2'b10; 
end

if (inst == 5'b01000 ) 
    if (funct3 == 3'b000) begin // sb
Branch=1'b0;
MemRead=1'b0;
MemtoReg=1'b0;
ALUOp=2'b00;
MemWrite=1'b1;
ALUSrc=1'b1;
RegWrite=1'b0;
jal = 1'b0;
jalr = 1'b0;
auipc = 1'b0;
lui = 1'b0;
unsignedflag = 1'b0;
Memoffset = 2'b01; 
end
   if (funct3 == 3'b001) begin // sh
Branch=1'b0;
MemRead=1'b0;
MemtoReg=1'b0;
ALUOp=2'b00;
MemWrite=1'b1;
ALUSrc=1'b1;
RegWrite=1'b0;
jal = 1'b0;
jalr = 1'b0;
auipc = 1'b0;
lui = 1'b0;
unsignedflag = 1'b0;
Memoffset = 2'b10; 
end
   if (funct3 == 3'b010) begin // sw
Branch=1'b0;
MemRead=1'b0;
MemtoReg=1'b0;
ALUOp=2'b00;
MemWrite=1'b1;
ALUSrc=1'b1;
RegWrite=1'b0;
jal = 1'b0;
jalr = 1'b0;
auipc = 1'b0;
lui = 1'b0;
unsignedflag = 1'b0;
Memoffset = 2'b11; 
end
end
endmodule
