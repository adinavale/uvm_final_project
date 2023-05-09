class risc_scoreboard_1 extends uvm_scoreboard;


    `uvm_component_utils(risc_scoreboard_1)
     `include "remuldefs.svh"
     `include "remul.sv"

    uvm_blocking_get_port #(risc_seq_item) m_get_port;
    uvm_blocking_put_port #(risc_seq_item) sb_put_port;

    //Constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_get_port = new("m_get_port", this);
        sb_put_port = new("sb_put_port", this);
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        risc_seq_item req;

        forever begin
            m_get_port.get(req);

	    `uvm_info("SCOREBOARD_1", $sformatf("PACKET RECEIVED IN SCOREBOARD_1 %s",req.sprint()),UVM_MEDIUM)
            
            //Perform reset
            reset = 1;
            REMUL();

            //Give instruction
            reset = 0;
            mem[32'h8000_0000] = {req.funct7,req.rs2,req.rs1,req.funct3,req.rd,req.opcode5,req.ones};
            REMUL();
	    
	    `uvm_info("SCOREBOARD_1", $sformatf("Value stored in destination register REG[%0d] = %0d",req.rd,REG(req.rd)),UVM_MEDIUM)

            req.expected_val = REG(req.rd);

            sb_put_port.put(req);
        end
    endtask


endclass : risc_scoreboard_1
