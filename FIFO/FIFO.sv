
module FIFO #(
    parameter int data_width = 8,
    parameter int fifo_depth = 64
)(
    input  logic                  clk,
    input  logic                  rst_n,
    input  logic                  write_en,
    input  logic                  read_en,
    input  logic [data_width-1:0] data_in,
    output logic [data_width-1:0] data_out,
    output logic                  full,
    output logic                  empty
);

    localparam int PTR_WIDTH =
        (fifo_depth <= 1) ? 1 : $clog2(fifo_depth);

    localparam int COUNT_WIDTH = $clog2(fifo_depth + 1);

    logic [data_width-1:0] mem [0:fifo_depth-1];
    logic [PTR_WIDTH-1:0] wr_ptr, rd_ptr;
    logic [COUNT_WIDTH-1:0] count;

    logic do_read, do_write;

    assign full  = (count == fifo_depth);
    assign empty = (count == 0);

    assign do_write = write_en && !full;
    assign do_read  = read_en && !empty;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            wr_ptr   <= '0;
            rd_ptr   <= '0;
            count    <= '0;
            data_out <= '0;
        end
        else begin
            // Count update
            count <= (do_write && !do_read) ? count + 1'b1 :
                     (do_read && !do_write) ? count - 1'b1 :
                     count;
                     
            // Write operation
            if (do_write) begin
                mem[wr_ptr] <= data_in;
                 wr_ptr <= (wr_ptr == fifo_depth - 1) ? '0 : wr_ptr + 1'b1;
            end

            // Read operation
            if (do_read) begin
                data_out <= mem[rd_ptr];
                read_ptr <= (rd_ptr == fifo_depth - 1) ? '0 : rd_ptr + 1'b1;
            end
        end
    end

endmodule
