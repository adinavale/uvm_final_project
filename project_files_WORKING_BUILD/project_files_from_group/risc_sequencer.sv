class risc_sequencer extends uvm_sequencer#(risc_seq_item);
    `uvm_component_utils(risc_sequencer)

    //Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info("Constructor", "risc_sequencer has been created", UVM_MEDIUM)
    endfunction : new
endclass : risc_sequencer
