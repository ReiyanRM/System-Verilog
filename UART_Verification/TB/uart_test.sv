class uart_test;

    uart_env env;

    function new (virtual uart_if vif);
    env = new(vif);
    endfunction

    task run();

        $display ("UART TEST START");

        env.run();

        wait(env.scb.checked == 30);

        #100ns;

        env.scb.report();
        env.cov.report();

        if (env.scb.fail_count == 0) $display ("\n UART TEST PASSES");
        else $fatal(1, "\n UART TEST FAILED")
    endtask

endclass