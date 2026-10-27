`timescale 1ns/1ps

module half_adder_tb ;

    logic a , b , sum , carry ;
    logic expected_sum , expected_carry ;

half_adder dut(.a(a), .b(b), .sum(sum), .carry(carry));
    
initial begin 
    for (int i=0; i < 4; i = i + 1) begin
        #10;
        a = i[0];
        b = i[1];

        expected_sum = a ^ b ;
        expected_carry = a & b ;

        if (sum !== expected_sum || carry !== expected_carry) begin
            $display("Test failed for a=%b, b=%b, sum=%b, carry=%b", a, b, sum, carry);
        end else begin
            $display("Test passed for a=%b, b=%b, sum=%b, carry=%b", a, b, sum, carry);
        end
    end
    $finish;
end

endmodule