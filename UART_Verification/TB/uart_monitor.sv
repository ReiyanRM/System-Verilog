class uart_monitor;
    virtual uart_if vif ;

    mailbox #(bit[7:0]) actual_mb;

    uart_coverage cov;

    function new( virtual uart_if vif ,mailbox #(bit[7:0]) actual_mb , uart_coverage cov);
        this.vif = vif ;
        this.actual_mb = actual_mb ;
        this.cov = cov;

    endfunction

task run();
    forever begin 
        @(vif.mon_cb);

        if (vif.mon_cb.rx_valid) begin 
            cov.sample_data(vif.mon_cb.rx_data);
            actual_mb.put(vif.mon_cb.rx_data);
            $display("[%0t] MONITOR : Received %02h ", $time , vif.mon_cb.rx_data);
        end

        if(vif.mon_cb.rx_error) begin 
            $error("UART RECEIVER STOP BIT ERROR");
        end
    end
endtask;
endclass;