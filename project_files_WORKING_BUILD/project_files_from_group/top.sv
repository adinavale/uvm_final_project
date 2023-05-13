import uvm_pkg::*;

`include "pkg.sv"
//`include "dut_file"
import proj_pkg::*;

module top();
    initial begin
        $display("Begin test");
        //run_test("risc_test"); 
        //run_test("risc_test_srli_slli"); 
        //run_test("risc_test_sll_srl"); 
        run_test("risc_test_sra_srai"); 
    end
endmodule : top
