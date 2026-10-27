module counter_4bit (input logic clk,rst_n,enable ,
    output logic [3:0] count);
    
    always_ff @(posedge clk) begin

        if (!rst_n) 
        begin
            count <= 4'b0000;
        end
        else if (enable)
        begin
            count <= count + 1'b1;
        end
    end
endmodule
