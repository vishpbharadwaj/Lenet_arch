
module parl_add_top_tb; 

//TODO
localparam  OPERAND_WIDTH = 19;
localparam  OUTPUT_WIDTH  = 22;

reg                        tb_parl_add_top_clk;
reg                        tb_parl_add_top_rst_b;
reg [OPERAND_WIDTH-1 : 0]  tb_parl_add_top_in_a_i;
reg [OPERAND_WIDTH-1 : 0]  tb_parl_add_top_in_b_i;
reg [OPERAND_WIDTH-1 : 0]  tb_parl_add_top_in_c_i;
reg [OPERAND_WIDTH-1 : 0]  tb_parl_add_top_in_d_i;
reg [OPERAND_WIDTH-1 : 0]  tb_parl_add_top_in_e_i;
   
wire  [OUTPUT_WIDTH-1 : 0]   tb_parl_add_top_out_o;


parl_add_5 #(
          OPERAND_WIDTH,
          OUTPUT_WIDTH
)
uut(
    .parl_add_top_clk    (tb_parl_add_top_clk) ,                    
    .parl_add_top_rst_b  (tb_parl_add_top_rst_b),
    .parl_add_top_in_a_i (tb_parl_add_top_in_a_i),
    .parl_add_top_in_b_i (tb_parl_add_top_in_b_i),
    .parl_add_top_in_c_i (tb_parl_add_top_in_c_i),
    .parl_add_top_in_d_i (tb_parl_add_top_in_d_i),
    .parl_add_top_in_e_i (tb_parl_add_top_in_e_i),
    .parl_add_top_out_o  (tb_parl_add_top_out_o)
);

initial begin
    tb_parl_add_top_clk   = 1'b0;
  //  tb_parl_add_top_rst_b = 1'b0;

end


always #5 tb_parl_add_top_clk = ~tb_parl_add_top_clk;

initial begin

      tb_parl_add_top_rst_b = 1'b0;
  #30 tb_parl_add_top_rst_b = 1'b1;

   tb_parl_add_top_in_a_i = 19'h2FFF; tb_parl_add_top_in_b_i = 19'h2FFF; tb_parl_add_top_in_c_i = 19'h2FFF; tb_parl_add_top_in_d_i = 19'h2FFF; tb_parl_add_top_in_e_i = 19'h2FFF;
  #100 tb_parl_add_top_in_a_i = 19'h1000; tb_parl_add_top_in_b_i = 19'h1000; tb_parl_add_top_in_c_i = 19'h1000; tb_parl_add_top_in_d_i = 19'h1000; tb_parl_add_top_in_e_i = 19'h1000;
  #100 tb_parl_add_top_in_a_i = 19'h2000; tb_parl_add_top_in_b_i = 19'h2000; tb_parl_add_top_in_c_i = 19'h2000; tb_parl_add_top_in_d_i = 19'h2000; tb_parl_add_top_in_e_i = 19'h2000;

  #10 tb_parl_add_top_rst_b = 1'b0;
  #10 tb_parl_add_top_rst_b = 1'b1;

  #100 $finish;

end  
	
endmodule  




























