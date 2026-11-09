class uart_scoreboard;

    mailbox #(bit [7:0]) expected_mb;
    mailbox #(bit [7:0]) actual_mb;

    int pass_count=0;
    int fail_count=0;
    int checked=0;

    function new (
        mailbox #(bit [7:0]) expected_mb,
        mailbox #(bit [7:0]) actual_mb);
    this.expected_mb = expected_mb;
    this.actual_mb = actual_mb ;

    endfunction

task run();

    bit[7:0] expected_data;
    bit[7:0] actual_data;

    forever begin 
        expected_mb.get(expected_data);
        actual_mb.get(actual_data);

        if (expected_data === actual_data ) begin 
            pass_count ++;

        $display("[%0t] PASS: EXPECTED=%02h ACTUAL=%02h",$time,expected_data, actual_data );
        end

        else begin 
            fail_count++;

            $error ( "FAIL : EXPECTED = %02h ACTUAL = %02h", expected_data, actual_data);
        end

        checked++ ;
    end

endtask

function void report();
    $display ("Total Checked =  %0d",checked);
    $display("Pass Count = %0d",pass_count);
    $display("Fail Count = %0d", fail_count);
endfunction

endclass   