typedef enum bit [2:0] {readd = 0, writed = 1, rstdut = 2, writeerr = 3, readerr = 4} oper_mode;

class transaction extends uvm_sequence_item;

  rand oper_mode  op;
  logic wr;
  logic rst;
  rand logic [7:0] addr;
  rand logic [7:0] din;
  logic [7:0] dout;
  logic done;
  logic err;

  `uvm_object_utils_begin(transaction)
  `uvm_field_int (wr,UVM_ALL_ON)

  constraint addr_c {addr <= 31;}
  constraint addrp_c {addr > 31;}

  function new(string name = "transaction");
    super.new(name);
  endfunction
endclass : transaction

//write

class write_data extends uvm_sequence#(transaction);
  `uvm_object_utils(write_data)

  transaction tr;

  function new(string name = "write_data");
    super.new(name);
  endfunction

  virtual task body();
    tr = transaction::type_id::create("tr");
    repeat(15)
    begin
      tr.addr_c.constraint_mode(1);
      tr.addrp_c.constraint_mode(0);
      start_item(tr);
      assert(tr.randomize);
      tr.op = writed;
      finish_item(tr);
    end
  endtask
endclass

//read

class read_data extends uvm_sequence#(transaction);
  `uvm_object_utils(read_data)

  transaction tr;

  function new(string name = "read_data");
    super.new(name);
  endfunction

  virtual task body();
    tr = transaction::type_id::create("tr");
    repeat(15)
      begin
        tr.addr_c.constraint_mode(1);
        tr.addrp_c.constraint_mode(0);
        start_item(tr);
        assert(tr.randomize);
        tr.op = readd;
        finish_item(tr);
      end
  endtask
endclass

//reset_dut

class reset_dut extends uvm_sequence#(transaction);
  `uvm_object_utils(reset_dut)

  transaction tr;

  function new(string name = "reset_dut");
    super.new(name);
  endfunction

  virtual task body();
    tr = transaction::type_id::credate("tr");
    repeat(20)
      begin
        tr.addr_c.constraint_mode(1);
        tr.addrp_c.constraint_mode(0);
        start_item(tr);
        assert(tr.randomize);
        tr.op = rstdut;
        finish_item(tr);
      end
  endtask
endclass
