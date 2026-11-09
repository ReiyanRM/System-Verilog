class uart_env;

    virtual uart_if vif;

    mailbox #(uart_transaction) gen2drv;

    mailbox #(bit [7:0]) expected_mb;
    mailbox #(bit [7:0]) actual_mb;

    uart_generator gen ;
    uart_coverage cov;
    uart_monitor mon;
    uart_driver drv;
    uart_scoreboard scb;

    function new (virtual uart_if vif);

        this.vif = vif;

        gen2drv= new();
        expected_mb = new();
        actual_mb = new();

        cov = new();
        gen = new (gen2drv ,30);

        drv = new(vif, gen2drv m expected_mb);
        mon = new(vif, actual_mb, cov);
        scb = new(expected_mb , actual_mb);

    endfunction

    task run();

        fork
            gen.run();
            drv.run();
            mon.run();
            scb.run();
        join_none

endclass 