module up_and_down_counter #(parameter WIDTH = 4) (
    input logic clk,rst_n, enable , up_down,
    output logic [WIDTH-1:0] count  
);

always_ff @(posedge clk) begin 
    if (!rst_n) begin 
        count <= '0;
    end

    else if (enable && up_down) begin
        count <= count + 1'b1;
    end
    
    else if (enable && !up_down) begin
        count <= count - 1'b1;
    end
end
endmodule
