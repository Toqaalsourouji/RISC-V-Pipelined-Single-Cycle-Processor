module ImmGen(input[31:0] inst, output[31:0] gen_out);

reg [11:0] immediate;
reg [31:0] gen_out; 

always @ (*) begin 

    if (inst [6] == 1'b1) begin 
     immediate = {inst [31], inst[7], inst [30:25] , inst [11:8]}; //I_Type
     gen_out = {{20{inst[31]}},immediate};
    end
    else if(inst[5]==1'b1) begin 
     immediate = {inst[31:25], inst[11:7]}; //Store
     gen_out = {{20{inst[31]}},immediate};
    end 
    else begin 
     immediate = inst [31:20]; //Load
     gen_out = {{20{inst[31]}},immediate}; 
    end
    end
    
endmodule
