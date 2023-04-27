class risc_agent extends uvm_agent;

    //declare risc_agent components
    risc_driver driver;
    risc_sequencer sequencer;

    `uvm_component_utils(risc_agent)

    //constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info("Constructor", "risc_agent has been created", UVM_MEDIUM)
    endfunction : new

    //build_phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sequencer = risc_sequencer::type_id::create("sequencer", this);
        driver = risc_driver::type_id::create("driver", this);
    endfunction : build_phase

    //connect phase
    function void connect_phase(uvm_phase phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction : connect_phase
endclass : risc_agent