class risc_seq_item extends uvm_sequence_item;

	reg [4:0] opcode5;
	rand reg [4:0] rd;
	reg [2:0] funct3;
	rand reg [4:0] rs1;
	rand reg [4:0] rs2;
	reg [6:0] funct7;
	reg [1:0] ones;
	reg [4:0] expected_val;
	string command;

	constraint reg_val {rd != rs1;}
	constraint shift_val {rs2 inside {[1:4]};}

    `uvm_object_utils_begin(risc_seq_item)
        `uvm_field_int(rs2 ,UVM_ALL_ON)
        `uvm_field_int(rs1 ,UVM_ALL_ON)
        `uvm_field_int(funct3 ,UVM_ALL_ON)
        `uvm_field_int(funct7 ,UVM_ALL_ON)
        `uvm_field_int(rd ,UVM_ALL_ON)
        `uvm_field_int(opcode5 ,UVM_ALL_ON)
        `uvm_field_int(ones ,UVM_ALL_ON)
        `uvm_field_int(expected_val ,UVM_ALL_ON)
	`uvm_field_string(command ,UVM_ALL_ON)
    `uvm_object_utils_end

    //Constructor
    function new(string name = "risc_seq_item");
        super.new(name);
        `uvm_info("Constructor", "risc_seq_item has been created", UVM_MEDIUM)
    endfunction

endclass : risc_seq_item
