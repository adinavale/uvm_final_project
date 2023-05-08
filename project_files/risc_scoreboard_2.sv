class risc_scoreboard_2 extends uvm_scoreboard;

    `uvm_component_utils(risc_scoreboard_2)

    `include "remuldefs.svh"
    `ifdef RISC_0 `include "./duts/dut51.svp" 
    `elsif RISC_1 `include "./duts/dut52.svp" 
    `elsif RISC_2 `include "./duts/dut53.svp" 
    `elsif RISC_3 `include "./duts/dut54.svp" 
    `elsif RISC_4 `include "./duts/dut55.svp" 
    `elsif RISC_5 `include "./duts/dut56.svp" 
    `elsif RISC_6 `include "./duts/dut57.svp" 
    `elsif RISC_7 `include "./duts/dut58.svp"
    `endif 

    uvm_blocking_get_port #(risc_seq_item) sb2_get_port;
    
    reg [4:0] actual_val;
    reg [4:0] expected_val;
    string command;

    //Constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info("Constructor", "risc_scoreboard_2 has been created", UVM_MEDIUM)
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb2_get_port = new("sb2_get_port", this);
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        risc_seq_item req;

        forever begin
            sb2_get_port.get(req);

            `uvm_info ("SCOREBOARD_2", "START OF ITEM FROM DRIVER", UVM_MEDIUM);

            `uvm_info("SCOREBOARD_2", $sformatf("PACKET RECEIVED IN SCOREBOARD_2 %s",req.sprint()),UVM_MEDIUM)
                        
            `uvm_info ("SCOREBOARD_2", "END OF ITEM\n", UVM_MEDIUM);

            //Perform reset
            reset = 1;
            REMUL();

            //Execute instruction
            reset = 0;
            //mem[32'h8000_0000] = 32'b0000000_00001_10000_101_11100_0010011;
            // mem[32'h8000_0000] = {req.imm12, req.rs1, req.funct3, req.rd, req.opcode5, req.ones};
            mem[32'h8000_0000] = {req.funct7,req.rs2,req.rs1,req.funct3,req.rd,req.opcode5};
            //$display("SB_2 Register %d before REMUL: %d", req.rd, REG(req.rd));
            REMUL();
            //$display("SB_2 Register %d after REMUL: %d", req.rd, REG(req.rd));
            `uvm_info("SCOREBOARD_2_dut", $sformatf("Value stored in destination register REG[%0d] = %0d",req.rd,REG(req.rd)),UVM_MEDIUM)
	    actual_val = REG(req.rd);
	    expected_val = req.expected_val;
	    command = req.command;
	    check_data();
        end
    endtask : run_phase

    virtual task check_data();
    	if(actual_val != expected_val)
		`uvm_info("SCOREBOARD_2", $sformatf("********DATA MISMATCH FOR COMMAND %s********",command), UVM_MEDIUM)
	else 	`uvm_info("SCOREBOARD_2", $sformatf("********DATA MATCHED FOR COMMAND %s*********",command), UVM_MEDIUM);
    endtask : check_data
endclass : risc_scoreboard_2
