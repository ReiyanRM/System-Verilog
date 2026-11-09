module uart_tx 
    #(parameter int  CLK_PER_BITS = 16)
    ( 
    input logic clk , rst_n ,tx_start,
    input logic [7:0] tx_data ,
    output logic tx_busy,tx_serial
);

typrdef enum logic[1:0] {
    IDLE,
    STRAT,
    DATA,
    STOP
} state_t;

state_t sstate ;

logic [7:0] data_reg;
logic [1:0] bit_index;

integer clk_count;

always_ff @(posedge clk ) begin

    if (!rst_n) begin

        state <= IDLE;
        tx_serial <= 1'b1;
        tx_busy <= 1'b0;
        data_reg <= '0;
        bit_index <= '0;
        clk_count <= CLK_PER_BITS; end
    
    else begin 
        case(state)

            IDLE : begin 
                tx_serial <= 1'b1;
                tx_busy <= 1'b0;
                clk_count<= CLK_PER_BITS; 
            
            if (tx_start)begin 
                data_reg <= tx_data ;
                tx_serial <= 1'b0;
                tx_busy <= 1'b1;
                state <= START;end
             end
            
            START: begin 
                if (clk_count == 0) begin 
                    clk_count <= CLK_PER_BITS;
                    bit_index <= 0;
                    tx_serial <= data_reg[0];
                    state <= DATA; end
                else clk_count <= clk_count -1;
            end

            DATA : begin 
                if (clk_count == 0 ) begin 
                    clk_count <= 0;
                    if (bit_index == 7 ) begin 
                        tx_serial <1'b1;
                        state <= STOP; end

                    else begin 
                        bit_index <= bit_index + 1;
                        tx_serial <= data_reg [bit_index +1];
                    end
                end
                else clk_count <= clk_count -1 ;
            end

            STOP : begin
                if (clk_count == 0 ) begin 
                    tx_serial <= 1'b1;
                    tx_busy <= 1'b0;
                    clk_count<= CLK_PER_BITS;
                    state <= IDLE;
                end

                else clk_count <= clk_count-1;
            end
        endcase 
    end    
end
endmodule