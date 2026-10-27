module half_adder (input logic a , b ,
                  output logic sum , carry);

    assign sum = a ^ b ; // sum = a XOR b
    assign carry = a & b ; // carry = a AND b

endmodule