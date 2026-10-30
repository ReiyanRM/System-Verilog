module sequence_detector(input clk , rst_n , din ,
                         output detected_signal);
 
 
  typedef enum logic [2:0] { s0 ,s1, s10, s101, s1011} state_t;
  state_t state, next;
  
  always_ff @(posedge clk ) begin 
  
    if (!rst_n) state <= s0;
    else state <= next; 
  end
  
  always_comb begin
    next = state;
  
  unique case (state)
    s0 : next = din ? s1 : s0 ;
    s1 : next = din ? s1 : s10;
    s10 : next = din ? s101 : s0;
    s101 : next = din ? s1011 : s10;
    s1011 : next = din ? s1 : s10 ;
    default : next = s0;
  endcase 
  end 
  
  assign detected_signal = ( state == s1011);
  
endmodule