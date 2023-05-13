class risc_sequence_srli_slli extends uvm_sequence #(risc_seq_item);

    `uvm_object_utils(risc_sequence_srli_slli)

    function new(string name = "risc_sequence_srli_slli");
        super.new(name);
    endfunction

    virtual task body();
	super.body();
            req = risc_seq_item::type_id::create("req");
	    inst_SRLI();
	    inst_SLLI();
    endtask : body


    task inst_SRLI();
        for(int sh = 0; sh < 32; sh++)
		for(int dest = 0; dest < 32; dest++) begin
        		start_item(req);
				assert(req.randomize());
				req.rs2 = sh;
				req.rd = dest;
				req.opcode5 = 'b00100;
  				req.funct7 = 'b0000000;
  				req.funct3 = 'b101;
  				req.ones = 'b11;
				req.command = "SRLI";
        		finish_item(req);
	#20;
	end
    endtask : inst_SRLI

    task inst_SLLI();
        for(int sh = 0; sh < 32; sh++)
		for(int dest = 0; dest < 32; dest++) begin
        		start_item(req);
				assert(req.randomize());
				req.rs2 = sh;
				req.rd = dest;
  				req.opcode5 = 'b00100;
  				req.funct7 = 'b0000000;
  				req.funct3 = 'b001;
  				req.ones = 'b11;
				req.command = "SLLI";
        		finish_item(req);
	#20;
	end
     endtask : inst_SLLI

          

endclass : risc_sequence_srli_slli

