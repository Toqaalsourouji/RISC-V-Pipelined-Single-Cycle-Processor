module ALU_CU( input [1:0] ALUop, input [2:0] Inst1, input Inst2, input[6:0]imm, output reg [3:0] ALUSelection, output reg shift_R, shift_I );

always @(*) begin 
case(ALUop)

//2'b00:begin 
//ALUSelection = 4'b0010; //Load/Store
//end 

2'b01: begin //Branching
ALUSelection= 4'b0001;
end

2'b10:begin   //R-type
if(Inst1 == 3'b000) begin
    if(Inst2==1'b0) begin
    ALUSelection = 4'b0000;//ADD
    end
    else begin  ALUSelection = 4'b1110;//SUB    
end 
end
else if(Inst1 == 3'b111) begin 
    ALUSelection = 4'b0001; //AND
end   
else if(Inst1 == 3'b110) begin 
    ALUSelection = 4'b0010; //OR 
end
else if(Inst1 == 3'b100) begin 
    ALUSelection = 4'b0011; //XOR
end 
else if(Inst1 == 3'b011) begin
    ALUSelection = 4'b0100; //SLL (Shift Left Logical) 
    shift_R = 1;
    shift_I = 0;
end
else if(Inst1 == 3'b101) begin   
    ALUSelection = 4'b0101;
    shift_R = 1;
    shift_I = 0;    // SRL (Shift Right Logical)
end
else if(Inst1 == 3'b010) begin 
    ALUSelection = 4'b0110;  // SLT (Set Less Than)
end 
else if (Inst1 == 3'b011) begin 
     ALUSelection = 4'b0111; // SLTU (Set Less Than Unsigned)
   end 
else if(Inst1 == 3'b101) begin 
    ALUSelection = 4'b1010; // SRA (Shift Right Arithmetic) 
    shift_R = 1;
    shift_I = 0; 
end 
end


 2'b11: begin //I-type
if(Inst1 == 3'b000) begin

    ALUSelection = 4'b1001;//ADDI  
end 
else if(Inst1 == 3'b111) begin 
    ALUSelection = 4'b0001; //ANDI
end   
else if(Inst1 == 3'b110) begin 
    ALUSelection = 4'b0010; //ORI 
end
else if(Inst1 == 3'b100) begin 
    ALUSelection = 4'b0011; //XORI
end 
else if(Inst1 == 3'b001) begin
    ALUSelection = 4'b0100; //SLLI (Shift Left Logical Immediate) 
    shift_R = 0;
    shift_I = 1;
end
else if(Inst1 == 3'b010) begin 
    ALUSelection = 4'b0110;  // SLTI (Set Less Than Immediate)
end 
else if (Inst1 == 3'b011) begin 
     ALUSelection = 4'b0111; // SLTUI (Set Less Than Unsigned Immediate)
   end 
else if(Inst1 == 3'b101) begin 
    if (imm==0) begin
        ALUSelection = 4'b0101; // SRLI (Shift Right Logical Immediaate) 
        shift_R = 0;
        shift_I = 1;
    end
    else begin 
    ALUSelection = 4'b1010; // SRAI (Shift Right Arithmetic Immediate)
    shift_R = 0;
    shift_I = 1;
    end 
end 
end
endcase 
end
endmodule


