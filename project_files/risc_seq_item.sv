class risc_seq_item extends uvm_sequence_item;

    //I-type data
    rand reg [11:0] imm12;
    rand reg [4:0] rs1;
    reg [2:0] funct3;

    //J-type data
    rand reg [19:0] imm20_10_1_11_19_12;

    //Shared I- and J-type data
    rand reg [4:0] rd;
    reg [4:0] opcode5;
    rand reg [1:0] ones;

    `uvm_object_utils_begin(risc_seq_item)
        `uvm_field_int(imm12 ,UVM_ALL_ON)
        `uvm_field_int(rs1 ,UVM_ALL_ON)
        `uvm_field_int(funct3 ,UVM_ALL_ON)

        `uvm_field_int(imm20_10_1_11_19_12 ,UVM_ALL_ON)

        `uvm_field_int(rd ,UVM_ALL_ON)
        `uvm_field_int(opcode5 ,UVM_ALL_ON)
        `uvm_field_int(ones ,UVM_ALL_ON)
    `uvm_object_utils_end

    //Constructor
    function new(string name = "risc_seq_item");
        super.new(name);
        `uvm_info("Constructor", "risc_seq_item has been created", UVM_MEDIUM)
    endfunction

endclass : risc_seq_item