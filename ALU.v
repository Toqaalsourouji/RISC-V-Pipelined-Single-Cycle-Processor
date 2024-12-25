module ALU #(parameter N=4) ( input [N-1:0] A, B, input wire [4:0] shamt, ID_EX_RegR2, input [3:0] AL, input shift_R, shift_I ,output reg [N-1:0] Y, output zeroflag, cf, vf, sf);

    wire [N-1:0] add, op_b;
    wire [N-1:0] W; 
    wire[N-1:0] RCA_out;
    wire [N-1:0] shift;
    reg[4:0] value_to_shifter;
    
     
    assign op_b = (~B);
    assign {cf, add} = AL[0] ? (A + op_b + 1'b1) : (A + B); //Replace RCA with add
    assign zeroflag = (add == 0);
    assign sf = add[31];
    assign vf = (A[31] ^ (op_b[31]) ^ add[31] ^ cf);
    assign W =  AL[2] ? ~B : B;   //SUB=1110

RCA #N rca ( A , W , AL[2] ,RCA_out); // AL[2] for twos complement +1 

always @(*) begin
    if (shift_R && !shift_I)
        value_to_shifter = ID_EX_RegR2;
    if ( shift_I && !shift_R)
        value_to_shifter = shamt;
end

Shifter shifter1 ( A, value_to_shifter, AL [1:0], shift);

always @(*) begin

case (AL)

// we dont support NOT and NOR 

        4'b0000: Y = RCA_out;    // ADD or SUB based on AL{2]
        4'b1110: Y = RCA_out;    // ADD or SUB based on AL{2]
        4'b1001: Y = A + B ;     // ADDI 
        4'b0001: Y = A & B;     // AND
        4'b0010: Y = A | B;     // OR
        4'b0011: Y = A ^ B;     // XOR
        4'b0100: Y = shift;    // SLL (Shift Left Logical)
        4'b0101: Y = shift;    // SRL (Shift Right Logical)
        4'b0110: Y = (A < B) ? 1 : 0; // SLT (Set Less Than)
        4'b0111: Y = ({0,A} < {0,B}) ? 1 : 0; // SLTU (Set Less Than Unsigned)
        4'b1111: Y = ({0,A} < {0,B}) ? 1 : 0; // SLTIU (Set Less Than Immediate Unsigned)
        4'b1010: Y = shift;   // SRA (Shift Right Arithmetic)
        default: Y = 0;         // Default case (Nop)
     endcase


end
endmodule

