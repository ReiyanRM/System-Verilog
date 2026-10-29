
`timescale 1ns/1ps

module FIFO_tb;

    localparam int DATA_WIDTH = 8;
    localparam int FIFO_DEPTH = 4;

    logic clk = 0;
    logic rst_n;
    logic write_en, read_en;
    logic [DATA_WIDTH-1:0] data_in, data_out;
    logic full, empty;

    int pass_count = 0;
    int fail_count = 0;

    // Reference model
    logic [DATA_WIDTH-1:0] expected_data;
    logic expected_full, expected_empty;

    logic [DATA_WIDTH-1:0] model_q[$];

    // DUT
    FIFO #(
        .data_width(DATA_WIDTH),
        .fifo_depth(FIFO_DEPTH)
    ) dut (
        .clk      (clk),
        .rst_n    (rst_n),
        .write_en (write_en),
        .read_en  (read_en),
        .data_in  (data_in),
        .data_out (data_out),
        .full     (full),
        .empty    (empty)
    );

    // 10 ns clock period
    always #5 clk = ~clk;


    // Task: drive inputs at the falling edge
    task automatic drive(
        input bit w,
        input bit r,
        input logic [DATA_WIDTH-1:0] d
    );
        @(negedge clk);
        write_en = w;
        read_en  = r;
        data_in  = d;
    endtask


    // Task: idle
    task automatic idle();
        drive(0, 0, '0);
    endtask


    // Reference model and self-checking logic
    always @(posedge clk) begin : reference_model

        bit do_wr;
        bit do_rd;

        if (!rst_n) begin
            model_q.delete();
        end
        else begin

            // Determine accepted operations using
            // the queue occupancy BEFORE this clock edge.
            do_wr = write_en && (model_q.size() < FIFO_DEPTH);
            do_rd = read_en  && (model_q.size() > 0);

            // Process the write
            if (do_wr)
                model_q.push_back(data_in);

            // Process the read
            if (do_rd)
                expected_data = model_q.pop_front();

            // Allow DUT nonblocking assignments to settle
            #1;

            // Check output data after an accepted read
            if (do_rd) begin
                if (data_out !== expected_data) begin
                    $error(
                        "FAIL DATA: Expected=%0h Actual=%0h",
                        expected_data, data_out
                    );
                    fail_count++;
                end
                else begin
                    $display(
                        "PASS DATA: Read=%0h",
                        data_out
                    );
                    pass_count++;
                end
            end

            // Check FULL flag
            expected_full = (model_q.size() == FIFO_DEPTH);

            if (full !== expected_full) begin
                $error(
                    "FAIL FULL: Expected=%b Actual=%b",
                    expected_full, full
                );
                fail_count++;
            end
            else begin
                pass_count++;
            end

            // Check EMPTY flag
            expected_empty = (model_q.size() == 0);

            if (empty !== expected_empty) begin
                $error(
                    "FAIL EMPTY: Expected=%b Actual=%b",
                    expected_empty, empty
                );
                fail_count++;
            end
            else begin
                pass_count++;
            end

        end
    end


    // Main stimulus
    initial begin

        $dumpfile("FIFO_tb.vcd");
        $dumpvars(0, FIFO_tb);

        $display("Starting FIFO Testbench");

        // Initialize inputs
        rst_n    = 0;
        write_en = 0;
        read_en  = 0;
        data_in  = '0;

        repeat (2) @(negedge clk);
        rst_n = 1;

        // Test 1: Write and read one item
        drive(1, 0, 8'hA5);
        idle();
        drive(0, 1, '0);
        idle();

        // Test 2: Fill FIFO
        for (int i = 0; i < FIFO_DEPTH; i++) begin
            drive(1, 0, 8'hA0 + i);
        end

        idle();

        // Test 3: Attempt overflow
        drive(1, 0, 8'hFF);
        idle();

        // Test 4: Drain FIFO
        for (int i = 0; i < FIFO_DEPTH; i++) begin
            drive(0, 1, '0);
        end

        idle();

        // Test 5: Attempt underflow
        drive(0, 1, '0);
        idle();

        // Test 6: Simultaneous read and write
        drive(1, 0, 8'h11);
        idle();

        drive(1, 0, 8'h22);
        idle();

        drive(1, 1, 8'h33);
        idle();

        drive(0, 1, '0);
        drive(0, 1, '0);
        drive(0, 1, '0);
        idle();

        // Allow the last checks to finish
        repeat (2) @(posedge clk);
        #2;

        $display("Passed checks: %0d", pass_count);
        $display("Failed checks: %0d", fail_count);


        if (fail_count == 0)
            $display("ALL TESTS PASSED");
        else
            $fatal(1, "FIFO TEST FAILED");

        $finish;
    end


    // Timeout protection
    initial begin
        #1000;
        $fatal(1, "Testbench timeout!");
    end

endmodule
