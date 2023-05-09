//------------------------
//AUTHOR : DIVYAMANI SINGH
//------------------------
class riscv_drv extends uvm_driver#(riscv_txn);
 `uvm_component_utils(riscv_drv)
 
 virtual riscv_intf vif;
 
 function new(string name = "riscv_drv", uvm_component parent=null);
  super.new(name,parent);
 endfunction
 
 virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(virtual riscv_intf)::get(this,"","vif",vif))begin
   `uvm_error(get_type_name(),"Interface not found")
  end
 endfunction:build_phase
 
 task run_phase(uvm_phase phase);
  super.run_phase(phase);
   
  begin
  //riscv_txn txn = riscv_txn::type_id::create("txn");
  seq_item_port.get_next_item(txn);
  `uvm_info(get_type_name(),$sformatf("PRINTING OBJECT FROM DRIVER::\n %s",txn.sprint()),UVM_MEDIUM)
  drive(txn);
  seq_item_port.item_done();
  end
 endtask:run_phase
 
 //driving to the model
 task drive(riscv_txn txn);
  vif.reset <= txn.reset;
  //#10;
 endtask
 
endclass:riscv_txn

