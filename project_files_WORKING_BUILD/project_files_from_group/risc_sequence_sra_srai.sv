class risc_sequence_sra_srai extends uvm_sequence #(risc_seq_item);

    `uvm_object_utils(risc_sequence_sra_srai)

    function new(string name = "risc_sequence_sra_srai");
        super.new(name);
    endfunction

    virtual task body();
	super.body();
            req = risc_seq_item::type_id::create("req");
	    inst_SRA();
	    inst_SRAI();
    endtask : body
    
  task inst_SRA();
    for(int sh=0; sh < 32; sh++)
        for(int dest = 0 ; dest < 32; dest++) begin
            start_item(req);
            assert(req.randomize());
            req.rs2 = sh;
            req.rd = dest;
            req.opcode5 = 'b01100;
            req.funct7 = 'b0100000;
            req.funct3 = 'b101;
            req.ones = 'b11;
            req.command = "SRA";
            finish_item(req);
            #20;
        end
    endtask : inst_SRA

task inst_SRAI();
    for(int sh=0; sh < 32; sh++)
        for(int dest = 0 ; dest < 32; dest++) begin
            start_item(req);
            assert(req.randomize());
            req.rs2 = sh;
            req.rd = dest;
            req.opcode5 = 'b00100;
            req.funct7 = 'b0100000;
            req.funct3 = 'b101;
            req.ones = 'b11;
            req.command = "SRAI";
            finish_item(req);
            #20;
        end
    endtask : inst_SRAI 
          

endclass : risc_sequence_sra_srai


