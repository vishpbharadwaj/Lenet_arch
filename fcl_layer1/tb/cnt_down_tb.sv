//


module cnt_down_tb;

parameter CNT_WIDTH = 4;

reg                     tb_cnt_clk;
reg                     tb_cnt_rstn;
reg                     tb_cnt_en;
reg                     tb_cnt_ld;
reg [CNT_WIDTH-1 : 0]   tb_cnt_ld_val;
reg [CNT_WIDTH-1 : 0]   tb_cnt;        
wire                    tb_cnt_done;

cnt_down #(
    .CNT_WIDTH (CNT_WIDTH)
)
uut(
    .cnt_clk     (tb_cnt_clk),
    .cnt_rstn    (tb_cnt_rstn),
    .cnt_en      (tb_cnt_en),
    .cnt_ld      (tb_cnt_ld),
    .cnt_ld_val  (tb_cnt_ld_val),
    .cnt         (tb_cnt),
    .cnt_done    (tb_cnt_done)
);

initial begin
    tb_cnt_clk = 0;
    tb_cnt_rstn = 0;
    tb_cnt_en = 0;
    tb_cnt_ld_val = '1;
end

always begin
    #5 tb_cnt_clk = ~tb_cnt_clk;
end

initial begin
    #10 tb_cnt_en = 1;

    #10 tb_cnt_rstn = 1;

    #80 tb_cnt_en = 0;
    #50 tb_cnt_en = 1;

    #800 tb_cnt_rstn = 0;
    #100 tb_cnt_rstn = 1;

    #30 tb_cnt_en = 0;
    #20 tb_cnt_en = 1;
    #250 tb_cnt_en = 0;

    #10 tb_cnt_rstn = 0;
    #100 tb_cnt_rstn = 1;

    #50 $finish;
end

endmodule
