module d_flip_flop ( input logic clk , rst_n ,d ,
                    output logic  q , q_bar );
  
  logic q_0;
  assign q_bar = ~q_0;
  assign q = q_0;
  
  always_ff @(posedge clk ) begin 
    
    if (!rst_n) q_0 <= 0 ; 
    else q_0 <= d;
    
  end
endmodule
  