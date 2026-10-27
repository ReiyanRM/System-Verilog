`timescale 1ns/1ps

module counter_4bit_tb ;

    logic clk,rst_n,enable;
    logic [3:0] count;

    logic [3:0] expected_count;
    int pass_count, fail_count;

counter_4bit dut (.clk(clk), .rst_n(rst_n), .enable(enable), .count(count));

initial clk = 0;

always #5 clk = ~clk;

task automatic check_count(input logic [3:0] expected);
    if (count !== expected) begin
        $display("Test failed: Expected count = %b, Actual count = %b", expected, count);
        fail_count++;
    end else begin
        $display("Test passed: Count = %b", count);
        pass_count++;
    end
endtask

initial begin
    rst_n = 0;
    enable = 0;
    expected_count = 0;
    pass_count = 0; 
    fail_count = 0;

    #10;
    rst_n = 1;  
    enable = 1;

    repeat (16) begin
        @ (posedge clk);
        expected_count = expected_count + 1'b1;
        #1;
        check_count(expected_count);
    end

    @(posedge clk);
    enable = 0;
    #10;

    repeat (5) begin
        #10;s
        check_count(expected_count);
    end

    @(posedge clk);
    rst_n = 0;
    #10;
    expected_count = 4'b0000;
    check_count(expected_count);

    $display("Passed tests: %0d, Failed tests: %0d", pass_count, fail_count);
    $finish;
end
endmodule

