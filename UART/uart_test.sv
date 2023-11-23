class test extends test;
   `uvm_component_utils(test)

   function new(input string inst = "test", uvm_component c);
      super.new(inst,c);
   endfunction

   env e;
   rand_baud_len8 rb8lwop;

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      e = env::type_id::create("env", this);

      rb8lwop = rand_baud_len8::type_id::create("rb8lwop");

   endfunction

   virtual task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      rb8lwop.start(e.a.seqr);
      #20;
      phase.drop_objection(this);
   endtask
endclass
