module full_adder(input logic a ,b,carry ,
                  output logic sum , cout);



        logic sum1, carry1, carry2;

    half_adder HA1(.a(a), .b(b), .sum(sum1), .carry(carry1));
    half_adder HA2(.a(sum1), .b(carry), .sum(sum), .carry(carry2));
    assign cout = carry1 | carry2;

endmodule