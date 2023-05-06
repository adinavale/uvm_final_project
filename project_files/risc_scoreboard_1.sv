//`include "dut_file"

class risc_scoreboard_1 extends uvm_scoreboard;


    `uvm_component_utils(risc_scoreboard_1)
     `include "remuldefs.svh"
     `include "remul.sv"

    uvm_blocking_get_port #(risc_seq_item) m_get_port;

    //Constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info("Constructor", "risc_scoreboard_1 has been created", UVM_MEDIUM)
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_get_port = new("m_get_port", this);
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        risc_seq_item req;

        forever begin
            m_get_port.get(req);

            `uvm_info ("SCOREBOARD_1", "START OF ITEM FROM DRIVER", UVM_MEDIUM);
            `uvm_info ("SCOREBOARD_1", $sformatf("imm12: %x", req.imm12), UVM_MEDIUM);
            `uvm_info ("SCOREBOARD_1", $sformatf("rs1: %x", req.rs1), UVM_MEDIUM);
            `uvm_info ("SCOREBOARD_1", $sformatf("funct3: %x", req.funct3), UVM_MEDIUM);

            `uvm_info ("SCOREBOARD_1", $sformatf("imm20_10_1_11_19_12: %x", req.imm20_10_1_11_19_12), UVM_MEDIUM);
            `uvm_info ("SCOREBOARD_1", $sformatf("rd: %x", req.rd), UVM_MEDIUM);
            `uvm_info ("SCOREBOARD_1", $sformatf("opcode5: %x", req.opcode5), UVM_MEDIUM);
            `uvm_info ("SCOREBOARD_1", $sformatf("ones: %x", req.ones), UVM_MEDIUM);
            
            `uvm_info ("SCOREBOARD_1", "END OF ITEM\n", UVM_MEDIUM);

            //Perform reset
            reset = 1;
            REMUL();

            //Give instruction
            reset = 0;
            mem[32'h8000_0000] = 32'b0000000_00001_10000_101_11100_0010011;
            //todo: add SW instruction and read from memory
            $display("read attempt: %d", REG(28));
            REMUL();
            $display("read attempt: %d", REG(28));

            
            
        end
    endtask


endclass : risc_scoreboard_1