class risc_sequence extends uvm_sequence #(risc_seq_item);

    `uvm_object_utils(risc_sequence)

    function new(string name = "risc_sequence");
        super.new(name);
    endfunction

    virtual task body();
	super.body();
        //repeat(10) begin
            req = risc_seq_item::type_id::create("req");
	    inst_SRLI();
	    inst_SLLI();
	    //inst_SRLI_rand();
	    //inst_SLLI_rand();
        //end
    endtask : body

//1st scenario: hard coded
    task inst_SRLI();
        start_item(req);
		req.opcode5 = 'b0010011;
  		req.funct7 = 'b0000000;
  		req.rs2 = 'b00001;//shamt
  		req.rs1 = 'b01000;//8th loc
  		req.funct3 = 'b101;
  		req.rd = 'b01110;
  		req.ones = 'b11;
		req.command = "SRLI";
        finish_item(req);
	#10;
    endtask : inst_SRLI

    task inst_SLLI();
        start_item(req);
  		req.opcode5 = 'b0010011;
  		req.funct7 = 'b0000000;
  		req.rs2 = 'b00001;//shamt
  		req.rs1 = 'b00110;//6th loc
  		req.funct3 = 'b001;
  		req.rd = 'b01111;
  		req.ones = 'b11;
		req.command = "SLLI";
        finish_item(req);
	#10;
    endtask : inst_SLLI

//2nd scenario: randomized
    task inst_SRLI_rand();
        start_item(req);
		assert(req.randomize());
		req.opcode5 = 'b0010011;
  		req.funct7 = 'b0000000;
  		req.funct3 = 'b101;
  		req.ones = 'b11;
		req.command = "SRLI_RAND";
        finish_item(req);
	#10;
    endtask : inst_SRLI_rand

    task inst_SLLI_rand();
        start_item(req);
		assert(req.randomize());
  		req.opcode5 = 'b0010011;
  		req.funct7 = 'b0000000;
  		req.funct3 = 'b001;
  		req.ones = 'b11;
		req.command = "SLLI_RAND";
        finish_item(req);
	#10;
    endtask : inst_SLLI_rand 

endclass : risc_sequence
