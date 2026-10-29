`timescale 1ns/1ps 

module d_ff_tb ;
  
  logic clk , rst_n, d;
  logic q , q_bar;
  
  d_flip_flop dut ( .clk (clk) , .rst_n(rst_n) , .d(d) , .q(q) , .q_bar(q_bar)) ;
  
  initial clk = 0;
  always #5 clk = ~clk;
  
 initial begin
   
   rst_n =0;
   d = 0;
   #10
   @(posedge clk );
   #1 $display ("Q = %d 	Q_Bar = %d ", q,q_bar);
   
   rst_n = 1;
    @(posedge clk );
   #1 $display ("Q = %d 	Q_Bar = %d ", q,q_bar);
   
   #10
   for ( int i =0 ; i < 2 ; i++) begin
     d=i[0];
      @(posedge clk );
   		#1 $display ("Q = %d 	Q_Bar = %d ", q,q_bar);
     
   end 
  $finish; 
 end
  
 
  
endmodule