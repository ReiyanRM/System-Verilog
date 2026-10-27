module mux_2_1 (input logic a , b ,sel 
        , output logic y);

    assign y = sel ? b : a ; // if sel=1 then y=b else y=a
endmodule