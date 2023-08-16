class driver extends uvm_driver #(transaction);
  `uvm_component_utils(driver)

  virtual spi_i vif;
  transaction tr;

  function new(input string path = "drv", uvm_component parent = null);
    super.new(path, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = transaction::type_id::create("tr");

    if(!uvm_config_db#(virtual spi_i)::get(this,"","vif",vif))
      `uvm_error("drv", "Unable to access Interface");
  endfunction

  
