class risc_driver extends uvm_driver;
    `uvm_component_utils(risc_driver)

    // Constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info("Constructor", "risc_agent has been created", UVM_MEDIUM)
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction : build_phase

    // virtual task run_phase(uvm_phase phase);
    //     forever begin
            
    //     end
    // endtask : run_phase
endclass : risc_driver