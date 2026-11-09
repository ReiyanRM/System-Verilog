class uart_coverage ;

    bit[7:0] data ;

    covergroup uart_cg;

        option.per_instance =1;

        DATA_COVERAGE : coverpoint data {

        bins zero = {8'h00};
        bins ones = {8'hFF};

        bins alternating_1 = {8'h55};
        bins alternating_2 = {8'hAA};

        bins low_values = {[8'h01 : 8'h3F]};
        bins middle_values = {[8'h40 : 8'hBF]};
        bins high_values = {[8;hC0 : 8'hFE]};

        }

    endgroup

    function new();
        uart_cg= new();
    endfunction 

    function void sample_data(bit [7:0] sampled_data);
        data = sample_data;
        uart_cg.sample();
    endfunction

    function void report();
        $display("UART FUNCTIONAL COVERAGE = %0.2f%%", uart_cg.getcoverage());

endclass