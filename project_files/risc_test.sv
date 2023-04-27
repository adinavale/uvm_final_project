class risc_test extends uvm_test;
    `uvm_component_utils(risc_test)

    risc_env env;

    function new(string name, uvm_component parent);
        super.new(name,parent);
        `uvm_info("Constructor", "risc_test has been created", UVM_MEDIUM)
    endfunction : new

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        env = risc_env::type_id::create("env", this);
    endfunction : build_phase

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        phase.drop_objection(this);
    endtask : run_phase
endclass : risc_test