//Line buffer fill counter for pixel data


module lb1_pxl_cnt_tb;


parameter CNT_ROW_WIDTH = 3; //2^3
parameter CNT_COLUMN_WIDTH = 2; //2^2

reg tb_cnt_clk;
reg tb_cnt_rst_b;
reg tb_cnt_en;

wire tb_cnt_done_o;

lb1_pxl_cnt #(
            .CNT_ROW_WIDTH      (CNT_ROW_WIDTH),
            .CNT_COLUMN_WIDTH   (CNT_COLUMN_WIDTH)
)
uut(
    .cnt_clk     (tb_cnt_clk),
    .cnt_rst_b   (tb_cnt_rst_b),
    .cnt_en      (tb_cnt_en ),
    .cnt_done_o  (tb_cnt_done_o)
);


initial begin
    tb_cnt_clk = 0;
    tb_cnt_rst_b = 0;
    tb_cnt_en = 0;
end

always begin
    #5 tb_cnt_clk = ~tb_cnt_clk;
end

initial begin
    #10 tb_cnt_en = 1;

    #10 tb_cnt_rst_b = 1;

    #80 tb_cnt_en = 0;
    #50 tb_cnt_en = 1;

    #800 tb_cnt_rst_b = 0;
    #100 tb_cnt_rst_b = 1;

    #30 tb_cnt_en = 0;
    #20 tb_cnt_en = 1;
    #250 tb_cnt_en = 0;

    #10 tb_cnt_rst_b = 0;
    #100 tb_cnt_rst_b = 1;

    #50 $finish;
end

endmodule
