class risc_test extends uvm_test;
    `uvm_component_utils(risc_test)

    risc_env env;
    risc_sequence seq;

    function new(string name, uvm_component parent);
        super.new(name,parent);
        `uvm_info("Constructor", "risc_test has been created", UVM_MEDIUM)
    endfunction : new

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        env = risc_env::type_id::create("env", this);
        seq = risc_sequence::type_id::create("seq");
    endfunction : build_phase

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        seq.start(env.agent.sequencer);
        //uvm_top.print_topology();
	#20;
        phase.drop_objection(this);
    endtask : run_phase

    function void end_of_elaboration_phase (uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction : end_of_elaboration_phase

endclass : risc_test
