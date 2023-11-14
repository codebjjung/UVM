typedef enum bit [3:0] {rand_baud_1_stop = 0, rand_length_1_stop = 1,
   length5wp = 2, length6wp = 3, length7wp = 4, length8wp = 5,
   length5wop = 6, length6wop = 7, length7wop = 8, length8wop = 9,
   rand_baud_2_stop = 11, rand_length_2_stop = 12
} oper_mode;

class transaction extends uvm_sequence_item;
   `uvm_object_utils(transaction)

   rand oper_mode op;
   logic tx_start, rx_start;
   logic rst;
   rand logic [7:0] tx_data;
   rand logic [16:0] baud;
   rand logic [3:0] length;
   rand logic parity_type, parity_en;
   logic stop2;
   logic tx_done, rx_done, tx_err, rx_err;
   logic [7:0] rx_out;

   constraint baud_c { baud inside {4800, 9600, 14400, 19200, 38400}; }
   constraint length_c { length inside {5, 6, 7, 8}; }

   function new(string name = "transaction");
      super.new(name);
   endfunction

endclass : transaction

class rand_baud extends uvm_sequence#(transaction);
   `uvm_object_utils(rand_baud)

   transaction tr;

   function new(string name = "rand_baud");
      super.new(name);
   endfunction

   virtual task body();
      repeat(5) begin
         tr = transaction::type_id::create("tr");
         start_item(tr);
         assert(tr.randomize);
         tr.op = rand_baud_1_stop;
         tr.length = 8;
         tr.baud = 9600;
         tr.rst = 1'b0;
         tr.tx_start = 1'b1;
         tr.parity_en = 1'b1;
         tr.stop2 = 1'b0;
         finish_item(tr);
      end
   endtask
endclass

class rand_baud_with_stop extends uvm_sequence#(transaction);
   `uvm_object_utils(rand_baud_with_stop)

   transaction tr;

   function new(string name = "rand_baud_with_stop");
      super.new(name);
   endfunction

   virtual task body();
      repeat(5) begin
         tr = transaction::type_id::create("tr");
         start_item(tr);
         assert(tr.randomize);
         tr.op = rand_length_2_stop;
         tr.rst = 1'b0;
         tr.length = 4'h8;
         tr.tx_start = 1'b1;
         tr.rx_start = 1'b1;
         tr.parity_en = 1'b1;
         tr.stop2 = 1'b1;
         finish_item(tr);
      end
   endtask
endclass
