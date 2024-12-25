module Memory (input clk, input MemRead, input MemWrite, input [2:0] funct3,
input [13:0] addr, input [31:0] data_in, output reg [31:0] data_out);

reg [7:0] mem [0:4095];

initial begin
// Initializing register values
{mem[3], mem[2], mem[1], mem[0]} = 32'b00000000000000000000000000110011; //add x0, x0, x0
{mem[7], mem[6], mem[5], mem[4]} = 32'b11111111111100000000011010010011; //addi x13, x0, -1
{mem[11], mem[10], mem[9], mem[8]} = 32'b00000000000100000000000010010011; //addi x1, x0, 1
{mem[15], mem[14], mem[13], mem[12]} = 32'b00001000110100000010000000100011; //sw x13, 128(x0)
{mem[19], mem[18], mem[17], mem[16]} = 32'b00001000110100000001010000100011; //sh x13, 136(x0)
{mem[23], mem[22], mem[21], mem[20]} = 32'b00001000010000000101100110000011; //lhu x19, 132(x0)
{mem[27], mem[26], mem[25], mem[24]} = 32'b00001000010000000001101000000011; // lh x20, 132(x0)
{mem[31], mem[30], mem[29], mem[28]} = 32'b00001000100000000100101010000011; // lbu x21, 136(x0)
{mem[34], mem[33], mem[33], mem[32]} = 32'b00001000100000000000101100000011; // lb x22, 136(x0)
{mem[38], mem[37], mem[36], mem[35]} = 32'b00001000000000000010101110000011; // lw x23, 128(x0)


{mem[131], mem[130], mem[129], mem[128]}    = 32'd17;    // Address 0: 20 in hex (32-bit word)
{mem[135], mem[134], mem[133], mem[132]}    = 32'd9;    // Address 0: 20 in hex (32-bit word)
{mem[139], mem[138], mem[137], mem[136]}    = 32'd25;    // Address 0: 20 in hex (32-bit word)
end

//This block is triggered at the positive edge of the clock (clk) and handles memory write operations.

always @(posedge clk) begin
 if (MemWrite == 1'b1) begin
        case (funct3)
            3'b000: mem[addr[13:7]+128] = data_in[7:0]; // Store 8 bits
            3'b001: {mem[addr[13:7]+129], mem[addr[13:7]+128]} = data_in[15:0]; // Store 16 bits
            3'b010: {mem[addr[13:7]+131], mem[addr[13:7]+130], mem[addr[13:7]+129], mem[addr[13:7]+128]} = data_in; // Store 32 bits
            default: ; // No operation for other funct3 values
        endcase
    end
end

//This block reads data from memory based on MemRead and funct3 values, which specify the data width and sign extension requirements.

always @(*) begin
if(~clk) begin 
    if (MemRead) begin
        case (funct3)
            3'd0: data_out <= {{24{mem[addr[13:7]+128][7]}}, mem[addr[13:7]+128]}; // Sign-extend byte
            3'd1: data_out <= {{16{mem[addr[13:7]+1+128][7]}},mem[addr[13:7]+128+1], mem[addr[13:7]+128]}; 
            3'd2: data_out <= {mem[addr[13:7]+128+3],mem[addr[13:7]+128+2],mem[addr[13:7]+128+1], mem[addr[13:7]+128]};
            3'd4: data_out <= {24'd0, mem[addr[13:7]+128]}; 
            3'd5: data_out <= {16'd0, mem[addr[13:7]+1+128],mem[addr[13:7]+128]}; 
            default: data_out <=0;
        endcase
    end
end
else

//reads four consecutive bytes from memory, starting at the address specified by
//and combines them into a single 32-bit word in little-endian order. The assembled 32-bit word is then assigned to data_out.
data_out = {mem[addr+3],mem[addr+2],mem[addr+1],mem[addr]};
end
//assign data_out= (MemRead==1)? mem[addr]:data_out;
endmodule

