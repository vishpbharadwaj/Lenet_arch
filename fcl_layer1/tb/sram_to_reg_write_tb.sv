//

module sram_to_reg_write_tb;


parameter NUM_FILTER = 6;
parameter CNT_WIDTH  = 3;
parameter RAM_DEPTH  = 5;
parameter RAM_ADDRW  = 3;
parameter RAM_WIDTH  = 40;


reg  tb_writes_clk;
reg  tb_writes_rst_b;
reg  tb_writes_en_i;
wire tb_writes_cnt_done_o;

sram_to_reg_write #(
            .NUM_FILTER  (NUM_FILTER),
            .CNT_WIDTH   (CNT_WIDTH),
            .RAM_DEPTH   (RAM_DEPTH),
            .RAM_ADDRW   (RAM_ADDRW),
            .RAM_WIDTH   (RAM_WIDTH)
)
uut(
    .reg_write_clk           (tb_writes_clk),
    .reg_write_rst_b         (tb_writes_rst_b),
    .reg_write_en_i          (tb_writes_en_i),
    .reg_write_cnt_done_o    (tb_writes_cnt_done_o)
);

initial begin
    tb_writes_clk = 0;
    tb_writes_rst_b = 0;
    tb_writes_en_i = 0;
end

always begin
    #5 tb_writes_clk = ~tb_writes_clk;
end

initial begin
    #10 tb_writes_rst_b = 1;
    
    #10 tb_writes_en_i = 1;

    #200 $finish;
end

endmodule
