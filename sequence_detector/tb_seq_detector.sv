`timescale 1ns/1ps

module tb_seq_detector;

  logic clk = 0;
  logic rst_n, din, detected_signal;
  logic expected;
  logic [3:0] sr;
  int   errors = 0;

  localparam logic [6:0] pat = 7'b1011011;

  sequence_detector dut (.*);         

  always #5 clk = ~clk;

  // Reference model
  always_ff @(posedge clk) begin
    if (!rst_n) sr <= '0;
    else        sr <= {sr[2:0], din};
  end

  assign expected = (sr == 4'b1011);

  task automatic send(input logic b);
    din = b;
    @(posedge clk);
    #1;
    if (detected_signal !== expected) begin
      $error("[%0t] din=%b detected=%b expected=%b", $time, b, detected_signal, expected);
      errors++;
    end
    else if (detected_signal)
      $display("[%0t] 1011 detected", $time);
  endtask

  initial begin
    rst_n = 0; din = 0;
    repeat (2) @(posedge clk);
    #1 rst_n = 1;

    // Directed: overlapping pattern, should detect twice
    for (int i = 6; i >= 0; i--) send(pat[i]);

    // Random traffic
    repeat (200) send($urandom_range(0, 1));

    if (errors == 0) $display("PASS");
    else             $display("FAIL: %0d errors", errors);

    $finish;
  end

endmodule