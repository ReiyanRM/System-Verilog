package counter_pkg;
    typedef enum logic [1:0] {
        IDLE = 2'b00,  // hold current value
        UP   = 2'b01,  // increment
        DOWN = 2'b10,  // decrement
        LOAD = 2'b11   // load external data
    } mode_t;
endpackage

module programmable_counter
    import counter_pkg::*;
#(
    parameter int WIDTH = 4
)(
    input  logic             clk,
    input  logic             rst_n,
    input  logic             enable,
    input  mode_t            mode,
    input  logic [WIDTH-1:0] load_data,
    output logic [WIDTH-1:0] count
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= '0;
        end else if (enable) begin
            unique case (mode)
                IDLE:    count <= count;
                UP:      count <= count + 1'b1;
                DOWN:    count <= count - 1'b1;
                LOAD:    count <= load_data;
                default: count <= count;
            endcase
        end
    end

endmodule