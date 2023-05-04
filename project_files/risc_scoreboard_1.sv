`include "dut_file"

class risc_scoreboard_1 extends uvm_scoreboard;

    `uvm_component_utils(risc_scoreboard_1)

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
            `uvm_info ("SCOREBOARD_1", "END OF ITEM\n", UVM_MEDIUM);
        end
    endtask


endclass : risc_scoreboard_1