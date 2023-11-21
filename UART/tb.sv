module tb;

initial begin
   vif.clk <= 0;
end

always #10 vif.clk <= ~vif.clk;

initial begin
   uvm_config_db#(virtual uart_if)::set(null, "*", "vif", vif);
   run_test("test");
end

initial begin
   $fsdbDumpfile("dump.fsdb");
   $fsdbDumpvars;
end
endmodule
