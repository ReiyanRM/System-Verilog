`timescale 1ns/1ps

module and_gate_tb ;

    logic a,b,y;

and_gate dut (.a(a), .b(b) , .y(y)) ;

initial begin 
    for (int i = 0; i < 4; i = i + 1) begin
        #10;
        a = i[0];
        b = i[1];

        if (y !== i[0] & i[1]) begin
            $display("Test failed for a=%b, b=%b, y=%b", a, b, y);
        end else begin
            $display("Test passed for a=%b, b=%b, y=%b", a, b, y);
        end
    end
    $finish;

end
endmodule