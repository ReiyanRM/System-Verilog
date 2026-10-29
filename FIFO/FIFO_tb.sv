`timescale 1ns/1ps

module FIFO_tb ;

    localparam int DATA_WIDTH = 8;
    localparam int FIFO_DEPTH = 4;

    localparam int COUNT_WIDTH = $clog2(FIFO_DEPTH + 1);

    logic clk, rst_n,full, empty, write_en, read_en;
    logic [DATA_WIDTH-1:0] data_in, data_out;
    logic [COUNT_WIDTH-1:0] count;

FIFO #(.data_width(DATA_WIDTH), .fifo_depth(FIFO_DEPTH)) dut (
    .clk(clk),
    .rst_n(rst_n),
    .write_en(write_en),
    .read_en(read_en),
    .data_in(data_in),
    .data_out(data_out),
    .full(full),
    .empty(empty)
);

logic [DATA_WIDTH-1:0] expected_data_out;
logic expected_read;

logic expected_fifo_q[$];

initial clk = 0;
always #5 clk = ~clk;

// Check FIFO status against expected values
task automatic check_status(input string test_name );

    logic expected_full = (expected_fifo_q.size() == FIFO_DEPTH);
    logic expected_empty = (expected_fifo_q.size() == 0);

    if ((count !== expected_fifo_q.size()) || full !== expected_full || empty !== expected_empty) begin
        
        $error("Test failed for %s: count=%0d (expected %0d), full=%b (expected %b), empty=%b (expected %b)", 
            test_name, count, expected_fifo_q.size(), full, expected_full, empty, expected_empty);

        fail_count++;
    end 
    else begin
        $display("Test passed for %s: count=%0d, full=%b, empty=%b", 
            test_name, count, full, empty);
        pass_count++;

    end
endtask



    