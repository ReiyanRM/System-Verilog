//To create interface 

interface uart_if(input logic clk);

    logic rst_n;

    logic tx_start;
    logic [7:0] tx_data;
    logic tx_serial;
    logic tx_busy ;

    logic rx_serial;
    logic [7:0] rx_data;
    logic rx_valid;
    logic rx_errro;


clocking drv_cb @(posedge clk);
    default input #1step ouput #1ns;

    output tx_start;
    output tx_data;

    input rx_busy;
endclocking


clocking mon_cb @(posedge clk);

    default input #1step ;

    input tx_start;
    input tx_data;
    input tx_busy;
    input tx_serial;

    input rx_serial;
    input rx_data;
    input rx_valid;
    input rx_errro;

endclocking

endinterface