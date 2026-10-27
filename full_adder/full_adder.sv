module full_adder (input logic a , b , cin ,
                  output logic sum , cout);

    assign sum = a ^ b ^ cin ; // sum = a XOR b XOR cin
    assign cout = (a & b) | (b & cin) | (a & cin) ; // cout = (a AND b) OR (b AND cin) OR (a AND cin)

endmodule