class risc_agent extends uvm_agent;

    //declare risc_agent components
    risc_driver driver;
    risc_sequencer sequencer;
    risc_scoreboard_1 scoreboard_1;
    risc_scoreboard_2 scoreboard_2;

    `uvm_component_utils(risc_agent)

    uvm_tlm_fifo #(risc_seq_item) m_tlm_fifo; //driver to scoreboard_1
    uvm_tlm_fifo #(risc_seq_item) sb_tlm_fifo; //scoreboard_1 to scoreboard_2

    //constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //build_phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sequencer = risc_sequencer::type_id::create("sequencer", this);
        driver = risc_driver::type_id::create("driver", this);
        scoreboard_1 = risc_scoreboard_1::type_id::create("scoreboard_1", this);
        scoreboard_2 = risc_scoreboard_2::type_id::create("scoreboard_2", this);

        //FIFO with depth 4
        m_tlm_fifo = new("uvm_tlm_fifo", this, 16);
        sb_tlm_fifo = new("sb_uvm_tlm_fifo", this, 16);
    endfunction : build_phase

    //connect phase
    function void connect_phase(uvm_phase phase);
        //Sequencer driver connection
        driver.seq_item_port.connect(sequencer.seq_item_export);

        //Connections driver to scoreboard_1
        driver.m_put_port.connect(m_tlm_fifo.put_export);
        scoreboard_1.m_get_port.connect(m_tlm_fifo.get_export);
        
        //Connects scoreboard_1 to scoreboard_2
        scoreboard_1.sb_put_port.connect(sb_tlm_fifo.put_export);
        scoreboard_2.sb2_get_port.connect(sb_tlm_fifo.get_export);
    endfunction : connect_phase
endclass : risc_agent
