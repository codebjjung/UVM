class mon extends uvm_monitor;
  `uvm_component_utils(mon)

  uvm_analysis_port#(transaction) send;
  transaction tr;
  spi_cov_c spi_cov;
  virtual spi_i vif;

  function new(input string inst = "mon", uvm_component parent = null);
    super.new(inst,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = transaction::type_id::create("tr");
    spi_cov = spi_cov_c::type_id::create("spi_cov", this);
    send = new("send", this);
    if(!uvm_config_db#(virtual spi_i)::get(this,"","vif",vif))
      `uvm_error("MON", "Unable to access Interface");
    this.spi_cov.vintf = vif;
  endfunction
