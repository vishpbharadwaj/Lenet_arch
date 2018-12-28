module mult_add_5pairs_tb;

parameter integer OPERAND_WIDTH = 8;
parameter integer OUTPUT_WIDTH  = 2 * OPERAND_WIDTH + 3;


reg                                     tb_mult_add5_clk;
reg                                     tb_mult_add5_rst_b;
reg   [`PAIR-1 : 0][OPERAND_WIDTH-1 : 0] tb_mult_add5_in_a_i;
reg   [`PAIR-1 : 0][OPERAND_WIDTH-1 : 0] tb_mult_add5_in_b_i;
reg   [`PAIR-1 : 0][OPERAND_WIDTH-1 : 0] tb_mult_add5_in_c_i;
reg   [`PAIR-1 : 0][OPERAND_WIDTH-1 : 0] tb_mult_add5_in_d_i;
reg   [`PAIR-1 : 0][OPERAND_WIDTH-1 : 0] tb_mult_add5_in_e_i;
wire  [OUTPUT_WIDTH-1 : 0]              tb_mult_add5_out_o;

mult_add_5pairs #(
      .OPERAND_WIDTH(OPERAND_WIDTH)
)
uut(
    .mult_add5_clk    (tb_mult_add5_clk),
    .mult_add5_rst_b  (tb_mult_add5_rst_b),
    .mult_add5_in_a_i (tb_mult_add5_in_a_i),
    .mult_add5_in_b_i (tb_mult_add5_in_b_i),
    .mult_add5_in_c_i (tb_mult_add5_in_c_i),
    .mult_add5_in_d_i (tb_mult_add5_in_d_i),
    .mult_add5_in_e_i (tb_mult_add5_in_e_i),
    .mult_add5_out_o  (tb_mult_add5_out_o)
);


always #5 tb_mult_add5_clk = ~tb_mult_add5_clk;


initial begin
 
    tb_mult_add5_clk = 0;
    tb_mult_add5_rst_b = 0;
  //tb_parl_add_in_i = 0;
  
  $monitor("starting simulation");

  #10 tb_mult_add5_rst_b = 1;
  
  #40 
     tb_mult_add5_in_a_i[0] = 8'hcc; tb_mult_add5_in_a_i[1] = 8'hcc;
     tb_mult_add5_in_b_i[0] = 8'hcc; tb_mult_add5_in_b_i[1] = 8'hcc;
     tb_mult_add5_in_c_i[0] = 8'hcc; tb_mult_add5_in_c_i[1] = 8'hcc;
     tb_mult_add5_in_d_i[0] = 8'hcc; tb_mult_add5_in_d_i[1] = 8'hcc;
     tb_mult_add5_in_e_i[0] = 8'hcc; tb_mult_add5_in_e_i[1] = 8'hcc;
  
  #40 
     tb_mult_add5_in_a_i[0] = 8'haa; tb_mult_add5_in_a_i[1] = 8'haa;
     tb_mult_add5_in_b_i[0] = 8'haa; tb_mult_add5_in_b_i[1] = 8'haa;
     tb_mult_add5_in_c_i[0] = 8'haa; tb_mult_add5_in_c_i[1] = 8'haa;
     tb_mult_add5_in_d_i[0] = 8'haa; tb_mult_add5_in_d_i[1] = 8'haa;
     tb_mult_add5_in_e_i[0] = 8'haa; tb_mult_add5_in_e_i[1] = 8'haa;
  

  #100 tb_mult_add5_rst_b = 0;
  #10 tb_mult_add5_rst_b = 1;
  
end

endmodule
