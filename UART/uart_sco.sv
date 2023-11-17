//scoreboard
class sco extends uvm_scoreboard;
   `uvm_component_utils(sco)

   uvm_analysis_imp#(transaction,sco) recv;
   bit [31:0] arr[32] = '{default:0};
   bit [31:0] addr = 0;
   bit [31:0] data_rd = 0;

   function new(input string inst = "sco", uvm_component parent = null);
      super.new(inst,parent);
   endfunction
