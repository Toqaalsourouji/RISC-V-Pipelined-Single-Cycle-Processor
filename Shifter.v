module Shifter (
    input  wire [31:0] a,      // Input value to be shifted
    input  wire [4:0] shamt,   // Shift amount (5 bits to shift a 32-bit value)
    input  wire [1:0] type,    // Shift type: 00 for logical left, 01 for logical right, 10 for arithmetic right
    output reg  [31:0] r       // Shifted output
);



    always @(*) begin
        case(type)
            2'b00: r = a << shamt;      // Logical Shift Left (SLL)
            2'b01: r = a >> shamt;      // Logical Shift Right (SRL)
            2'b10: r = $signed(a) >>> shamt; // Arithmetic Shift Right (SRA)
            default: r = 32'b0;         // Default case for safety
        endcase
    end
endmodule
