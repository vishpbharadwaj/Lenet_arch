//

module mult_add_2pairs_tb;

`define PAIR 2

parameter integer OPERAND_WIDTH = 8;
parameter integer OUTPUT_WIDTH  = 2 * OPERAND_WIDTH + 1;


reg                                   tb_mult_add_clk;
reg                                   tb_mult_add_rst_b;
reg [`PAIR-1 : 0][OPERAND_WIDTH-1 : 0] tb_mult_add_in_a_i;
reg [`PAIR-1 : 0][OPERAND_WIDTH-1 : 0] tb_mult_add_in_b_i;

wire[OUTPUT_WIDTH-1 : 0]              tb_mult_add_out_o;


mult_add_2pairs #(
OPERAND_WIDTH
)
uut(
.mult_add_clk     (tb_mult_add_clk),
.mult_add_rst_b   (tb_mult_add_rst_b),
.mult_add_in_a_i  (tb_mult_add_in_a_i),
.mult_add_in_b_i  (tb_mult_add_in_b_i),
.mult_add_out_o   (tb_mult_add_out_o)
);


initial begin
  tb_mult_add_clk = 0;
  tb_mult_add_rst_b = 1;
  
  $monitor("starting simulation");
end

always begin
    #5 tb_mult_add_clk = !tb_mult_add_clk;
end

initial begin
  #10 tb_mult_add_rst_b = 1;
  
  #10 tb_mult_add_in_a_i[0] = 8'hcc; tb_mult_add_in_a_i[1] = 8'haa; tb_mult_add_in_b_i[0] = 8'h0a; tb_mult_add_in_b_i[1] = 8'hdd;
  #10 tb_mult_add_in_a_i[0] = 8'hcc; tb_mult_add_in_a_i[1] = 8'haa; tb_mult_add_in_b_i[0] = 8'h0a; tb_mult_add_in_b_i[1] = 8'hdd;

  #10 tb_mult_add_rst_b = 0;
  #10 tb_mult_add_rst_b = 1;
  

  #50 $finish;
end

endmodule
