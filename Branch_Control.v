module Branch_Control(input [2:0] ID_EX_Func, input branch, zeroflag, cf, vf, sf, output reg branch_assigned );
    
always @(branch) begin //Branch Logic what about i make it its own module
    case (ID_EX_Func[2:0])  // func3
    
        3'b000: begin  // BEQ 
            if (zeroflag) begin
                branch_assigned = 1'b1;  
            end 
            else begin
                branch_assigned = 1'b0;  
            end
        end
        
        3'b001: begin  // BNE 
            if (!zeroflag) begin
                branch_assigned = 1'b1;  
            end 
            else begin
                branch_assigned = 1'b0;  
            end
        end

        3'b100: begin  // BLT 
            if (sf != vf) begin
                branch_assigned = 1'b1;  
            end 
            else begin
                branch_assigned = 1'b0; 
            end
        end

        3'b101: begin  // BGE 
            if (sf == vf) begin
                branch_assigned = 1'b1;  
            end 
            else begin
                branch_assigned = 1'b0;  
            end
        end

        3'b110: begin  // BLTU // still didnt handle unsigned here
            if (cf) begin
                branch_assigned = 1'b1;  
            end 
            else begin
                branch_assigned = 1'b0;  
            end
        end

        3'b111: begin  // BGEU // still didnt handle unsigned here
            if (!cf) begin
                branch_assigned = 1'b1;  
            end 
            else begin
                branch_assigned = 1'b0;  
            end
        end

        default: begin
            branch_assigned = 1'b0;  
        end
    endcase
end
endmodule
