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
    
    bit [4:0] rs2_shamt;
    bit [4:0] rs1_val;
    bit [4:0] rd_dest;
    bit [31:0] actual_val;
    bit [31:0] expected_val;
    string command;

    //Constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb2_get_port = new("sb2_get_port", this);
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        risc_seq_item req;

        forever begin
            sb2_get_port.get(req);

            //`uvm_info("SCOREBOARD_2", $sformatf("PACKET RECEIVED IN SCOREBOARD_2 %s",req.sprint()),UVM_MEDIUM)
                        
            //Perform reset
            reset = 1;
            REMUL();

            //Execute instruction
            reset = 0;
            mem[32'h8000_0000] = {req.funct7,req.rs2,req.rs1,req.funct3,req.rd,req.opcode5, req.ones};
            REMUL();

            `uvm_info("SCOREBOARD_2_dut", $sformatf("Value stored in destination register REG[%0d] = %0d",req.rd,REG(req.rd)),UVM_MEDIUM)

	    rs1_val = req.rs1;
	    rs2_shamt = req.rs2;
	    rd_dest = req.rd;
	    actual_val = REG(req.rd);
	    expected_val = req.expected_val;
	    command = req.command;
            `uvm_info("SCOREBOARD_2", $sformatf("PACKET RECEIVED IN SCOREBOARD_2 %s",req.sprint()),UVM_MEDIUM)

	    check_data(actual_val,expected_val);
	    #5;
        end
    endtask : run_phase

    virtual function check_data(int actual_val,expected_val);
    	if(actual_val != expected_val) begin
		`uvm_info("SCOREBOARD_2", $sformatf("********DATA MISMATCH FOR COMMAND %s [ACTUAL = %0h, EXPECTED = %0h][rs1_val = %0d & rs2_shamt = %0d & rd_dest = %0d]********",command,actual_val,expected_val,rs1_val,rs2_shamt,rd_dest), UVM_MEDIUM); end
	else begin `uvm_info("SCOREBOARD_2", $sformatf("********DATA MATCHED FOR COMMAND %s [ACTUAL = %0h, EXPECTED = %0h][rs1_val = %0d & rs2_shamt = %0d & rd_dest = %0d]*********",command,actual_val,expected_val,rs1_val,rs2_shamt,rd_dest), UVM_MEDIUM);
	end
    endfunction : check_data
endclass : risc_scoreboard_2
