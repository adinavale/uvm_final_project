class risc_env extends uvm_env;
    risc_agent agent;

    `uvm_component_utils(risc_env)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info("Constructor", "risc_env has been created", UVM_MEDIUM)
    endfunction : new

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        agent = risc_agent::type_id::create("risc_agent", this);
    endfunction : build_phase
endclass : risc_env