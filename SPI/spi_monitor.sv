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

  virtual task run_phase(uvm_phase phase);
    forever begin
      repeat(2) @(posedge vif.clk);
      if(vif.rst)
        begin
          tr.op = rstdut;
          `uvm_info("MON", "SYSTEM RESET DETECTED", UVM_NONE);
          send.write(tr);
          spi_cov.spi_cg.sample();
        end
      else if (!vif.rst && vif.wr)
        begin
          @(posedge vif.done);
          tr.op = writed;
          tr.din = vif.din;
          tr.addr = vif.addr;
          tr.err = vif.err;
          `uvm_info("MON", $sformatf("DATA WRITE addr : %0h data : %0h err : %0h", tr.addr, tr.din, tr.err), UVM_NONE);
          send.write(tr);
          spi_cov.spi_cg.sample();
        end
      else if (!vif.rst && !vif.wr)
        begin
          @(posedge vif.done);
          tr.op = readd;
          tr.addr = vif.addr;
          tr.err = vif.err;
          tr.dout = vif.dout;
          `uvm_info("MON", $sformatf("DATA READ addr : %0h data : %0h slverr : %0h", tr.addr, tr.dout, tr.err), UVM_NONE);
          send.write(tr);
        end
    end
  endtask
endclass
                                     
