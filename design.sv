`timescale 1ns / 1ps

module spi_intf(
  input wr, clk, rst, reday, op_done,
  input [7:0] addr, din,
  output [7:0] dout,
  input miso,
  output reg done, err
);

  reg [16:0] din_reg;
  reg [7:0] dout_reg;

  integer count = 0;

  typedef enum bit [2:0] {idle = 0, load = 1, check_op = 2, send_data = 3, read_data1 = 4, read_data2 = 5, error = 6, check_ready = 7} state_type;
  state_type state = idle;

  always@(posedge clk)
    begin
      if(rst)
        begin
          state <= idle;
          count <= 0;
          cs <= 1'b1;
          mosi <=1'b0;
          err <= 1;b0;
          done <= 1'b0;
        end

      load: begin
        din_reg <= {din, addr, wr};
        state <= check_op;
      end
endmodule
