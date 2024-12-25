module TopModule(input clk, ssdclk, reset, load, input [1:0] ledSel, input [3:0] ssdSel, output reg [15:0] leds, output  [3:0] Anode , output  [6:0] LED_out );

wire [31:0] ALU_in2;
wire [31:0] memdata_out;
wire [31:0] DMux_out; // output of last mux 
wire [31:0] data_out; // output from memory
wire [31:0] pc_out;
wire [31:0] gen_out;
wire [1:0] ALUOp ;
wire Branch, MemRead, MemtoReg , MemWrite, ALUSrc, RegWrite, zeroflag;
wire [31:0] RD1, RD2;
wire [3:0] ALUSelection;
wire [31:0] Alu_out;
wire [31:0] shift_out;
wire [31:0] adder_branch, adder_JAL, adder2_out;
wire [31:0] ID_EXadder_branch, ID_EXadder_JAL;
wire and_out; 
wire [31:0] AMux_out; // and gate mux
reg [12:0] ssd;
wire BranchANDGate; 
wire [31:0] IF_ID_PC, IF_ID_Inst;
wire [31:0] ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm;
wire [4:0] ID_EX_Rs1, ID_EX_Rs2; // to handle forwarding later 
wire [3:0] ID_EX_Func;
wire [4:0] ID_EX_Rd;
wire ID_Branch, ID_MemRead, ID_MemtoReg, ID_MemWrite, ID_ALUsrc, ID_RegWrite;
wire [1:0] ID_ALUop, ID_memoffset;
wire ID_unsignedflag;
wire EX_Branch, EX_MemRead, EX_MemtoReg, EX_MemWrite, EX_RegWrite;
wire EX_zeroflag; 
wire EX_MEM_BranchAddOut;
wire EX_MEM_branch_assigned;
wire [31:0] EX_MEM_Alu_out, EX_MEM_RegR2, EX_MEM_PC,EX_MEM_adder_JALR, EX_MEM_adder_AUIPC, EX_MEM_adderPC_4,
EX_MEM_adder_branch, EX_MEM_adder_JAL, EX_MEM_ALU_in2; 
wire [31:0] MEM_WB_adder_branch, MEM_WB_adder_JAl, MEM_WB_adder_AUIPC, MEM_WB_adder_JALR ; 
wire [4:0] EX_MEM_Rd;
wire [31:0] MEM_WB_Mem_out, MEM_WB_ALU_out;
wire [4:0] MEM_WB_Rd;
wire MEM_WB_MemtoReg, MEM_WB_RegWrite;
wire [1:0] forwardAsignal, forwardBsignal; 
reg [31:0] forwardingMUXA, forwardingMUXB ; 
wire stall; 
reg [14:0] Stall_Mux_out;
wire flush;
wire [31:0] muxedinst_flush;
wire [11:0] Mux_CU_Flush1; 
reg halt;
wire cf, vf, sf;
wire branch_assigned; 
wire [31:0] loadoutput;
wire [6:0]  ID_EX_inst_Imm;
wire [31:0] PC_Imm_Adder;
wire [31:0] PC_Imm_adder_ID_EX_out; 
wire [31:0] IF_ID_Mem_mux_out, ID_EX_Mem_mux_out, final_mux_out, inst_or_data, EX_MEM_Mem_mux_out, MEM_Mem_mux_out ;
wire WB_mem_access; // to be checked for potenial errors
wire jal, jalr, auipc, lui;
wire ID_jal, ID_jalr, ID_auipc, ID_lui;
wire shift_R, shift_I;
wire [31:0] adder_JALR, ID_EXadder_JALR, adder_AUIPC, ID_EXadder_AUIPC; 
wire [19:0] shift_12; //  make sure its 20 not 32
wire MEM_sf;
wire unsignedflag;
wire [1:0] memoffset, EX_MEM_memoffset;
wire EX_MEM_unsignedflag;
reg [31:0] PC_Input;
wire MEM_branch;
wire EX_MEM_jal, EX_MEM_jalr, EX_MEM_lui, EX_MEM_auipc, MEM_WB_jal, MEM_WB_jalr, MEM_WB_lui, MEM_WB_auipc ;
wire[31:0] adderPC_4, MEM_adderPC_4;
wire [2:0]  EX_Memfunct3;
wire [31:0] MEM_WB_IMM, EX_MEM_IMM;

always @ (*) begin 
if (EX_MEM_jal == 1) begin //we should take them from the EX_MEM as in the pipelne we branch after the ex_mem so all should be the same 
PC_Input = EX_MEM_adder_JAL;
end
else if (EX_MEM_jalr == 1) begin 
PC_Input = EX_MEM_adder_JALR;
end
else if (EX_Branch == 1) begin 
PC_Input = EX_MEM_adder_branch;
end
else 
PC_Input=0;
end

NBitMux #32 Pc_Mux ( pc_out+4, PC_Input, (EX_MEM_jal || EX_MEM_jalr || EX_Branch),  AMux_out); //this is the first mux branch out = pcsrc 

PC #32 pc( clk,  reset, !stall, AMux_out,  pc_out); 

assign muxedinst_flush = (flush) ? 32'd0 : data_out; // this MUX if for flushing instruction  to change data_out

PC #64 IF_ID_REG ( ~clk, reset, !stall, { pc_out , muxedinst_flush},{ IF_ID_PC ,IF_ID_Inst }); 

//muxedinst_flush will be changed to output the memory

Stall_Unit SU( IF_ID_Inst[19:15], IF_ID_Inst[24:20], ID_EX_Rd, ID_MemRead, stall); // Hazard Unit

 always @(*) begin
    if( stall || flush ) // this is to set all the control signals for 0 in case of flushing and stalling
           Stall_Mux_out = 0;
    else
        Stall_Mux_out = { memoffset, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite,jal, jalr, auipc, lui, unsignedflag,ALUOp};
 end //maybe in handling the nop operations use, also this is the or gate/ mux 


CU control (reset, IF_ID_Inst [6:2], IF_ID_Inst[14:12], memoffset, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, jal, jalr, auipc, 
lui, unsignedflag, ALUOp) ;

 
RF rf ( clk , reset, MEM_WB_RegWrite, IF_ID_Inst[19:15], IF_ID_Inst[24:20], MEM_WB_Rd , F_mux ,  RD1,  RD2); 
//DMux_out needs to be changed depending on the output of the 4x1 mux

ImmGen immgen (IF_ID_Inst, gen_out); 
//shift 1 left when we branch , we shift 12 auipc and lui 
Shift1  #32 shift (gen_out, shift_out);
Shifter shift12(gen_out, 5'b01010, 2'b00, shift_12); // to handle auipc and lui shift left 12

RCA #32 adder_Branch (IF_ID_PC, shift_out, 0, adder_branch, target);

RCA #32 Adder_JAL (IF_ID_PC, gen_out, 0, adder_JAL, target1);

PC #233 ID_EX_REG ( clk, reset, 1, { IF_ID_Inst[31:25],IF_ID_Inst[19:15], IF_ID_Inst[24:20],
IF_ID_PC, RD1, RD2, gen_out, adder_branch, adder_JAL, IF_ID_Inst[11:7], {IF_ID_Inst[30], IF_ID_Inst[14:12]},Stall_Mux_out}, 

{ID_EX_inst_Imm ,ID_EX_Rs1, ID_EX_Rs2, ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2 , ID_EX_Imm,
ID_EXadder_branch, ID_EXadder_JAL, 
ID_EX_Rd, ID_EX_Func, ID_memoffset, ID_Branch, ID_MemRead, ID_MemtoReg, 
ID_MemWrite, ID_ALUsrc, ID_RegWrite,ID_jal, ID_jalr, ID_auipc, ID_lui, ID_unsignedflag, ID_ALUop}); 
// add rs1 and rs2 ID/EX for forwarding , also make sure the concatenation of stall_mux_out is correct

RCA #32 Pc_adder_4 (ID_EX_PC, 4, 0, adderPC_4, dkk);// PC+4_adder this to be passed to mem stage

NBitMux #32 RF_Mux ( forwardingMUXB , ID_EX_Imm, ID_ALUsrc,  ALU_in2); // this handles immediate dependencies

ALU_CU alcu (ID_ALUop, ID_EX_Func[2:0], ID_EX_Func[3], ID_EX_inst_Imm,  ALUSelection, shift_R, shift_I);

always @ (*) begin

if (forwardAsignal == 2'b00)  
forwardingMUXA = ID_EX_RegR1;

else if (forwardAsignal == 2'b01)  
forwardingMUXA = final_mux_out;

else  
forwardingMUXA = EX_MEM_Alu_out;

end 

always @ (*) begin

if (forwardBsignal == 2'b00)  
forwardingMUXB = ID_EX_RegR2;

else if (forwardBsignal == 2'b01)  
forwardingMUXB = final_mux_out;

else 
forwardingMUXB = EX_MEM_Alu_out;

end 
 
ALU #32 alu ( forwardingMUXA, ALU_in2, ID_EX_Rs2, ID_EX_RegR2,  ALUSelection, shift_R, shift_I , Alu_out,  zeroflag, cf, vf, sf); 
// if any errors in ALU due to shifting check 


Forwarding_unit FU (EX_RegWrite, MEM_WB_RegWrite, EX_MEM_Rd, MEM_WB_Rd, EX_MEM_Alu_out,
EX_MEM_RegR2, ID_EX_Rs1, ID_EX_Rs2, forwardAsignal, forwardBsignal );


RCA #32 Adder_JALR (ID_EX_Rs1, ID_EX_Imm, 0, adder_JALR, dk);// jalr passed to EX/MEM

RCA #32 Adder_AUIPC (ID_EX_PC, shift_12, 0, adder_AUIPC, dontcare);// auipc passed to EX/MEM

Branch_Control branchC (ID_EX_Func, Mux_CU_Flush1[11], zeroflag, cf, vf, sf, branch_assigned); //unneccasary but okay 

assign flush = EX_Branch & branch_assigned; // changed EX_branch to ID_Branch

assign Mux_CU_Flush1 = (flush)  ? 12'b000000000000 : {ID_Branch, ID_MemRead, ID_MemtoReg, ID_memoffset, ID_unsignedflag, 
ID_jal, ID_jalr, 
ID_auipc, ID_lui, //check if they need to be removed from this or not
ID_MemWrite, ID_RegWrite}; // this MUX is for flushing and so it changes all the CU in the ID/EX stage signals to 0 to flush 


PC #341  EX_MEM_REG (clk,  reset,  1'b1, { ID_EX_Imm ,ID_EX_Func[2:0], ID_EX_PC, Mux_CU_Flush1, adder_JALR, Alu_out, ALU_in2, adder_AUIPC, 
branch_assigned, adderPC_4, ID_EXadder_branch, ID_EXadder_JAL, ID_EX_RegR2, ID_EX_Rd}, 

{EX_MEM_IMM ,EX_Memfunct3, EX_MEM_PC ,EX_Branch ,EX_MemRead , EX_MemtoReg , EX_MEM_memoffset, EX_MEM_unsignedflag, EX_MEM_jal, 
EX_MEM_jalr, EX_MEM_lui, EX_MEM_auipc, EX_MemWrite, EX_RegWrite ,EX_MEM_adder_JALR, EX_MEM_Alu_out, EX_MEM_ALU_in2,
EX_MEM_adder_AUIPC, EX_MEM_branch_assigned, EX_MEM_adderPC_4, EX_MEM_adder_branch, EX_MEM_adder_JAL, EX_MEM_RegR2, EX_MEM_Rd});
//check if ALU_in2 is forwardingBmux or not ? 
 
wire [13:0] mem_in;
reg is_inst;
assign mem_in = EX_MemRead ? EX_MEM_Alu_out : pc_out;
always @(*) begin 
if (mem_in == pc_out)
is_inst = 1'b1;
else 
is_inst = 1'b0;
end
wire [2:0] funct3_in;
assign funct3_in = EX_MemRead ? EX_Memfunct3 : 3'b010;

Memory MEM ( clk,  1, EX_MemWrite, funct3_in, mem_in, EX_MEM_RegR2 , data_out);


PC #268 MEM_WB_REG ( clk,  reset,  1, { EX_MEM_IMM ,EX_MEM_adder_JAL ,EX_MEM_adder_AUIPC, EX_MEM_adder_JALR ,EX_MEM_adderPC_4, 
EX_MEM_adder_branch, EX_Branch, data_out, EX_MEM_Alu_out, EX_MEM_jal, EX_MEM_jalr, EX_MEM_lui, 
EX_MEM_auipc, EX_MemtoReg, EX_RegWrite, EX_MEM_Rd}, 

{MEM_WB_IMM ,MEM_WB_adder_JAl, MEM_WB_adder_AUIPC, MEM_WB_adder_JALR, MEM_adderPC_4,MEM_WB_adder_branch, MEM_branch, MEM_WB_Mem_out,
 MEM_WB_ALU_out, MEM_WB_jal, MEM_WB_jalr,
 MEM_WB_lui, MEM_WB_auipc, MEM_WB_MemtoReg, MEM_WB_RegWrite, MEM_WB_Rd});

always @(*) begin 

end 

NBitMux #32 Final_Mux ( MEM_WB_Mem_out, MEM_WB_ALU_out , MEM_WB_MemtoReg || MEM_WB_RegWrite  , final_mux_out); //MEM_WB_MemtoReg

wire [31:0]F_mux;

assign F_mux = (MEM_WB_MemtoReg || MEM_WB_RegWrite && ~(MEM_WB_jal && MEM_WB_jalr && MEM_WB_auipc &&MEM_WB_lui )) ? final_mux_out: 
(MEM_WB_jal || MEM_WB_jalr) ? MEM_adderPC_4: (MEM_WB_lui)?
 MEM_WB_IMM: (MEM_WB_auipc) ? (MEM_adderPC_4 + MEM_WB_IMM): MEM_WB_ALU_out; // The input of the register file write port


endmodule
