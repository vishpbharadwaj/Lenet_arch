//

module upcounter_tb;

parameter CNT_WIDTH = 3;

reg                     tb_cnt_clk;
reg                     tb_cnt_rst_b;
reg                     tb_cnt_en;
reg                     tb_cnt_ld_en;
reg [CNT_WIDTH-1 : 0]   tb_cnt_ld_val;
reg [CNT_WIDTH-1 : 0]   tb_cnt_upto;
reg  [CNT_WIDTH-1 : 0]  tb_cnt_out;
wire                    tb_cnt_done;





upcounter #(
        .CNT_WIDTH (CNT_WIDTH)
)
uut(
   .cnt_clk     (tb_cnt_clk),
   .cnt_rst_b   (tb_cnt_rst_b),
   .cnt_en      (tb_cnt_en),
   .cnt_ld_en   (tb_cnt_ld_en),
   .cnt_ld_val  (tb_cnt_ld_val),
   .cnt_upto    (tb_cnt_upto),
   .cnt_out     (tb_cnt_out),
   .cnt_done    (tb_cnt_done)
);

initial begin
    tb_cnt_clk = 0;
    tb_cnt_en = 0;
    tb_cnt_rst_b = 0;
    tb_cnt_upto = 3'b101;
    tb_cnt_ld_val = '0;
    tb_cnt_ld_en = 0;
end

always begin
    #5 tb_cnt_clk = ~tb_cnt_clk;
end

initial begin

    #10 tb_cnt_rst_b = 1;
    #10 tb_cnt_en = 1;

    #1000 $finish;
end

endmodule
