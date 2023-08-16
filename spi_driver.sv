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

  task reset_dut();

    repeat(5)
      begin
        vif.rst <= 1'b1;
        vif.addr <= 'h0;
        vif.din <= 'h0;
        vif.wr <= 1'b0;
        `uvm_info("DRV", "System Reset : Start of Simulation", UVM_MEDIUM);
        @(posedge vif.clk);
      end
  endtask

  task drive();
    reset_dut();
    forever begin

      seq_item_port.get_next_item(tr);

      if(tr.op == rstdut)
        begin
          vif.rst <= 1'b1;
          @(posedge vif.clk);
        end
      else if(tr.op == writed || tr.op == writeerr || tr.op == rstdut)
        begin
          vif.rst <= 1'b0;
          vif.wr <= 1'b1;
          vif.addr <= tr.addr;
          vif.din <= tr.din;
          @(posedge vif.clk);
          `uvm_info("DRV", $sformatf("mode : Write addr:%0h din:%0h wr:%0h", vif.addr, vif.din, vif.wr), UVM_NONE);
          @posedge(vif.done);
        end
      else if(tr.op == readd || tr.op == readerr)
        begin
          vif.rst <= 1'b0;
          vif.wr <= 1'b0;
          vif.addr <= tr.addr;
          vif.din <= tr.din;
          @(posedge vif.clk);
          `uvm_info("DRV", sformatf("mode : Read addr:%0h din:%0h wr:%0h", vif.addr, vif.din, vif.wr), UVM_NONE);
          @(posedge vif.done);
        end
      seq_item_port.item_done();
    end
  endtask
  
          
          `uvm_info("DRV", $sformatf("mode : Write addr:%0h din:%0h wr:%0h", vif.addr, vif.din, vif.wr), UVM_NONE);
          @(posedge vif.done);
        end
      else if
