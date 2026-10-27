`timescale 1ns/1ps

module full_adder_tb;

    logic a , b , carry ,sum , cout;

full_adder dut (.a(a), .b(b), .carry(carry), .sum(sum), .cout(cout));   

initial begin

        repeat (10) begin
        a = $urandom_range(0,1);
        b = $urandom_range(0,1);
        carry = $urandom_range(0,1);

        #10
        assert (sum == a ^ b ^ carry;) else $error("Sum mismatch");
        assert (cout == (a & b) | (a & carry) | (b & carry)) else $error("Carry mismatch");
        end

    $display("Random testing completed");
    $finish;
    
    end 
endmodule   