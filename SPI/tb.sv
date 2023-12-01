//testbench

`include "spi_cfg.sv"
`include "spi_if.sv"
`include "spi_seq.sv"
`include "spi_cov.sv"
`include "spi_mon.sv"
`include "spi_sc.sv"
`include "spi_drv.sv"
`include "spi_agent.sv"
`include "spi_env.sv"
`include "spi_test.sv"

module tb;

spi_i vif();

top dut (.wr(vif.wr),
   .clk(vif.clk),
   .rst(vif.rst),
   .addr(vif.addr),
   .din(vif.din),
   .dout(vif.dout),
   .done(vif.done),
   .err(vif.err)
);

initial begin
   vif.clk <= 0;
end

always #10 vif.clk <= ~vif.clk;

initial begin
   uvm_config_db#(virtual spi_i)::set(null, "*", "vif", vif);
   run_test("test");
end

initial begin
   $fsdbDumpfile("dump.fsdb");
   $fsdbDumpvars;
end

endmodule
