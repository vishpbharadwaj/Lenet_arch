//

module srff_en_tb;

reg  tb_srff_clk;
reg  tb_srff_rst_b;
reg  tb_srff_en_i;
reg  tb_srff_S_i;
reg  tb_srff_R_i;
reg  tb_srff_Q_o; 
wire tb_srff_Qb_o;

srff_en uut(
    .srff_clk    (tb_srff_clk),
    .srff_rst_b  (tb_srff_rst_b),
    .srff_en_i   (tb_srff_en_i),
    .srff_S_i    (tb_srff_S_i),
    .srff_R_i    (tb_srff_R_i),
    .srff_Q_o    (tb_srff_Q_o), 
    .srff_Qb_o   (tb_srff_Qb_o)
);

always #5 tb_srff_clk = ~tb_srff_clk;

initial begin
    tb_srff_clk = 0;
    tb_srff_rst_b = 1;
    tb_srff_en_i = 1;
    tb_srff_S_i = 0;
    tb_srff_R_i = 0;

    #2 ;

    #10 tb_srff_S_i = 0; tb_srff_R_i = 1;
    #10 tb_srff_S_i = 1; tb_srff_R_i = 0;
    #10 tb_srff_S_i = 1; tb_srff_R_i = 1;
    #10 tb_srff_S_i = 0; tb_srff_R_i = 0;

    #100 $finish;


end

endmodule
