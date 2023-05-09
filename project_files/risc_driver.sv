class risc_driver extends uvm_driver #(risc_seq_item);
    `uvm_component_utils(risc_driver)

    uvm_blocking_put_port #(risc_seq_item) m_put_port;

    // Constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info("Constructor", "risc_driver has been created", UVM_MEDIUM)
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_put_port = new("m_put_port", this);
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
                `uvm_info ("DRIVER", "START OF ITEM FROM SEQUENCER", UVM_MEDIUM);
                `uvm_info ("DRIVER", $sformatf("PACKET RECEIVED IN DRIVER: %s", req.sprint()), UVM_MEDIUM);
                `uvm_info ("DRIVER", "END OF ITEM\n", UVM_MEDIUM);
                m_put_port.put(req);
            seq_item_port.item_done();
        end
    endtask : run_phase
endclass : risc_driver
