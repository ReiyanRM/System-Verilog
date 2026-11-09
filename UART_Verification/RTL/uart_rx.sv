module uart_rx #(parameter int CLK_PER_BITS = 16 )
    (
        input clk, rst_n, rx_serial,
        output logic [7:0] rx_data ,
        output logic rx_error , rx_valid );

typedef enum logic[1:0] { 
    IDEL,
    START,
    DATA,
    STOP
 } state_t ;


 state_t state ;

 logic [7:0] daata_reg ;
 logic [2:0] bit_index ;
 integer clk_count;

 always_ff @(posedge clk ) begin

    if(!rst_n) begin 
        state <= IDLE ;
        rx_data <= '0 ;
        data_reg <= '0;
        rx_valid <= 0;
        rx_error <= 1'b0 ;
        bit_index <= 0;
        clk_count <= CLK_PER_BITS;
    end

    else begin 
        case (STATE)
            IDLE : begin 
                clk_count <= CLK_PER_BITS;
                bit_index <= 0;

                if(!rx_serial) state<= START ;
            end

            START :begin 
                if (clk_count == 0) begin 
                    clk_count <= CLK_PER_BITS;

                    if (!rx_serial) state <= DATA;
                    else state <= IDLE ;
                end

                else clk_count <= clk_count -1 ;
            end

            DATA : begin 
                if (clk_count == 0) begin 
                    clk_count <= 0 ;

                    data_reg[bit_index] <= rx_serial;

                 bit_index <= (bit_index == 3'd7) ? 3'd0 : bit_index + 3'd1;
                state     <= (bit_index == 3'd7) ? STOP : state;
                end

                else clk_count <=  clk_count -1;
            end

            STOP : begin 
                if (clk_count == 0) begin 
                    clk_count <=CLK_PER_BITS;

                    if (rx_serial) begin 
                        rx_data <= data_reg;
                        rx_valid <= 1'b1; end
                    else rx_error <= 1;

                    STATE <= IDLE;
                end

                else clk_count <=  clk_count -1;
            end
        endcase 
    end

 end


endmodule