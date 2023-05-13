class risc_sequence_sll_srl extends uvm_sequence #(risc_seq_item);

    `uvm_object_utils(risc_sequence_sll_srl)

    function new(string name = "risc_sequence_sll_srl");
        super.new(name);
    endfunction

    virtual task body();
	super.body();
            req = risc_seq_item::type_id::create("req");
	    inst_SLL();
	    //inst_SRL();
    endtask : body
    
   task inst_SLL();
       for(int sh=0; sh < 32;sh++)
		for(int dest = 0 ; dest < 32; dest++) begin
		start_item(req);
		assert(req.randomize());
		req.rs2 = sh;
		req.rd = dest;
		req.opcode5 = 'b01100;
  		req.funct7 = 'b0000000;
  		req.funct3 = 'b001;
  		req.ones = 'b11;
		req.command = "SLL";
        finish_item(req);
	#20;
	end
      endtask : inst_SLL
	  
	 task inst_SRL();
    for(int sh=0; sh < 32; sh++)
        for(int dest = 0 ; dest < 32; dest++) begin
            start_item(req);
            assert(req.randomize());
            req.rs2 = sh;
            req.rd = dest;
            req.opcode5 = 'b01100;
            req.funct7 = 'b0000000;
            req.funct3 = 'b101;
            req.ones = 'b11;
            req.command = "SRL";
            finish_item(req);
            #20;
        end
    endtask : inst_SRL
          

endclass : risc_sequence_sll_srl

