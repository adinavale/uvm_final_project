class risc_sequence extends uvm_sequence #(risc_seq_item);

    `uvm_object_utils(risc_sequence)

    function new(string name = "risc_sequence");
        super.new(name);
    endfunction

    virtual task body();
	super.body();
            req = risc_seq_item::type_id::create("req");
	    inst_SRLI_rand();
	    //inst_SLLI_rand();
	    //inst_SLL_rand();
	    //inst_SRL_rand();
	    //inst_SRAI_rand();
	    //inst_SRA_rand();
    endtask : body

    task inst_SRLI_rand();
	repeat(20) begin
        start_item(req);
		assert(req.randomize());
		req.opcode5 = 'b00100;
  		req.funct7 = 'b0000000;
  		req.funct3 = 'b101;
  		req.ones = 'b11;
		req.command = "SRLI";
        finish_item(req);
	#10;
	end
    endtask : inst_SRLI_rand

    task inst_SLLI_rand();
	repeat(20) begin
        start_item(req);
		assert(req.randomize());
  		req.opcode5 = 'b00100;
  		req.funct7 = 'b0000000;
  		req.funct3 = 'b001;
  		req.ones = 'b11;
		req.command = "SLLI";
        finish_item(req);
	#10;
	end
     endtask : inst_SLLI_rand

     task inst_SLL_rand();
        start_item(req);
		assert(req.randomize());
		req.opcode5 = 'b01100;
  		req.funct7 = 'b0000000;
  		req.funct3 = 'b001;
  		req.ones = 'b11;
		req.command = "SLL";
        finish_item(req);
	#10;
      endtask : inst_SLL_rand

      task inst_SRL_rand();
        start_item(req);
		assert(req.randomize());
		req.opcode5 = 'b01100;
  		req.funct7 = 'b0000000;
  		req.funct3 = 'b101;
  		req.ones = 'b11;
		req.command = "SRL";
        finish_item(req);
	#10;
      endtask : inst_SRL_rand

      task inst_SRAI_rand();
        start_item(req);
		assert(req.randomize());
		req.opcode5 = 'b00100;
  		req.funct7 = 'b0100000;
  		req.funct3 = 'b101;
  		req.ones = 'b11;
		req.command = "SRAI";
        finish_item(req);
	#10;
      endtask : inst_SRAI_rand

      task inst_SRA_rand();
        start_item(req);
		assert(req.randomize());
		req.opcode5 = 'b01100;
  		req.funct7 = 'b0100000;
  		req.funct3 = 'b101;
  		req.ones = 'b11;
		req.command = "SRA";
        finish_item(req);
	#10;
      endtask : inst_SRA_rand
     

endclass : risc_sequence
