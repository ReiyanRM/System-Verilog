`timescale 1ns/1ps

module mux_2_1_tb ;

    logic a , b , sel , y ;
    logic expected_y ;

mux_2_1 dut(.a(a), .b(b), .sel(sel), .y(y));

initial begin 
    for (int i=0; i < 8; i = i + 1) begin
        #10;
        a = i[0];
        b = i[1];
        sel = i[2];

        expected_y = sel ? b : a;

        if (y !== expected_y) begin
            $display("Test failed for a=%b, b=%b, sel=%b, y=%b", a, b, sel, y);
        end else begin
            $display("Test passed for a=%b, b=%b, sel=%b, y=%b", a, b, sel, y);
        end
    end
    $finish;
end