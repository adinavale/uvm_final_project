class risc_sequence extends uvm_sequence #(risc_seq_item);

    `uvm_object_utils(risc_sequence)

    function new(string name = "risc_sequence");
        super.new(name);
        `uvm_info("Constructor", "risc_sequence has been created", UVM_MEDIUM)
    endfunction

    virtual task body();
        repeat(10) begin
            req = risc_seq_item::type_id::create("req");
            start_item(req);
                assert(req.randomize());
            finish_item(req);
        end
        #20;
    endtask : body
endclass : risc_sequence