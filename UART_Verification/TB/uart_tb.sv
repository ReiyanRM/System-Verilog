`timescale 1ns/

module uart_tb ;

    import uart_pkg::*;

    parameter int CLK_PER_BITS = 16;

    logic clk = 0;

    always #10 clk = ~clk;

    uart_if vif(clk);

    //internal loopback 

    assign vif.rx_serial = vif.tx_serial;

    uart_top #(.CLK_PER_BITS)
    DUT( .clk(clk), .rst_n(vif.rst_n), .tx_start(vif.tx_start),
         .tx_data(vif.tx_data), .tx_serial(vif.tx_serial), .tx_busy(vif.tx_busy),
         .rx_serial(vif.rx_serial), .rx_valid(vif.rx_serial), .rx_data(vif.rx_data), 
         .rx_error(vif.rx_error));

    initial begin 
        vif.rst_n =0;
        vif.tx_start =0 ;
        vif.tx_data =0;

        repeat(5)
            @(posedge clk);

        @(negedge clk);

        vif.rst_n = 1;

        uart_test test;

        test = new(vif);

        test.run();

        $finish;
    end

    initial begin 
        #2ms;
        $fatal (1, "SIMULATION TIMEOUT")
    end

endmodule