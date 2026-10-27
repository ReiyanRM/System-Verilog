`timescale 1ns/1ps

module not_gate_tb ;

    logic a ,y ;

not_gate dut(.a(a), .y(y));

initial begin 
    for (int i=0; i < 2; i = i + 1) begin
        #10;
        a = i[0];

        if (y !== !i[0]) begin
            $display("Test failed for a=%b, y=%b", a, y);
        end else begin
            $display("Test passed for a=%b, y=%b", a, y);
        end
    end
end