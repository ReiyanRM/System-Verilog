module uart_top #(
    parameter int CLKS_PER_BIT = 16
)(
    input logic clk,
    input logic rst_n,

    input logic tx_start,
    input logic [7:0] tx_data,
    output logic tx_serial,
    output logic tx_busy,

    input logic rx_serial,
    output logic [7:0] rx_data,
    output logic rx_valid,
    output logic rx_error
);

    uart_tx #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) TX (
        .clk,
        .rst_n,
        .tx_start,
        .tx_data,
        .tx_serial,
        .tx_busy
    );

    uart_rx #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) RX (
        .clk,
        .rst_n,
        .rx_serial,
        .rx_data,
        .rx_valid,
        .rx_error
    );

endmodule