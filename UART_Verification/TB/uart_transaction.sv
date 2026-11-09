class uart_transaction;

    rand bit[7:0] data;

    bit [7:0] received;
    bit passed;

constraint data_c {
        data inside {
            8'h00,
            8'hFF,
            8'h55,
            8'hAA,
            [8'h01:8'hFE]
        };
    }

function void display (string name = "TRANSACTION");

    $display("[%0t] %s : DATA = %02h",$time,name,data)
endfunction

endclass