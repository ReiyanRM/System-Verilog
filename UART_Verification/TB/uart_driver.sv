class uart_driver;

    virtual uart_if vif;

    mailbox #(uart_transaction) gen2drv;
    mailbox #(bit [7:0]) expected_mb;


    function new(
        virtual uart_if vif , 
        mailbox #(uart_transaction) gen2drv,
        mailbox #(bit [7:0]) expected_mb);

        this.vif =vif;
        this.gen2drv = gen2drv;
        this.expected_mb = expected_mb;
    endfunction

task run();

    uart_transaction tr;

    forever begin
        gen2drv.get(tr);

        @(vif.drv_cb);

        while (vif.drv_cb.tx_busy)
            @(vif.drv_cb);
        
        vif.drv_cb.tx_data <= tr.data;
        vif.drv_cb.tx_start <= 1'b1;

        expected_mb.put(tr.data);

        @(vif.drv_cb);

        vif.drv_cb.tx_start <= 1'b0;

        $display("[0t%] DRICVER : Sending %02h", $time,tr.data);

        while (vif.drv_cb.tx_busy) @(vid.drv_cb);
    end

endtask
endclass