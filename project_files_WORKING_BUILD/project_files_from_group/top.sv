import uvm_pkg::*;

`include "pkg.sv"
//`include "dut_file"
import proj_pkg::*;

module top();
    initial begin
        $display("Begin test");
        run_test("risc_test"); 
    end
endmodule : top
