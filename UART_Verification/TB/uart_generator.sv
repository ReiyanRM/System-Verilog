class uart_generator;

    mailbox #(uart_transaction) gen2drv;

        int no_of_trnsaction;

        function new(
            mailbox #(uart_transaction) gen2drv ,
            int no_of_trnsaction =30 );

            this.gen2drv = gen2drv;
            this.no_of_trnsaction =no_of_trnsaction;
        endfunction

task run();
    uart_transaction tr;

    repeat(no_of_trnsaction) begin 
        tr =new();

        if(!tr.randomize()) $fatal("Randomization Failed !");
        tr.display("GENERSTOR");
        gen2drv.put(tr);
    end

    $display("GENERATOR COMPLETED");
endtask

endclass