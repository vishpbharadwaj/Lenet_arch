//

module conv1_max_pool_tb;


parameter OPERAND_WDTH    = 19;
parameter NUM_PIXELS_BUF  = 4;
parameter NUM_PIXELS_POOL = 2;

reg                                             tb_conv1_pool_clk;
reg                                             tb_conv1_pool_rst_b;
reg  [NUM_PIXELS_BUF-1 :0] [OPERAND_WDTH-1 :0]  tb_conv1_pool_a_i;
reg  [NUM_PIXELS_BUF-1 :0] [OPERAND_WDTH-1 :0]  tb_conv1_pool_b_i;
wire [NUM_PIXELS_POOL-1 :0] [OPERAND_WDTH-1 :0] tb_conv1_max_pool_o;

conv1_max_pool #(
        .OPERAND_WDTH    (OPERAND_WDTH),
        .NUM_PIXELS_BUF  (NUM_PIXELS_BUF),
        .NUM_PIXELS_POOL (NUM_PIXELS_POOL)
)
uut(
    .conv1_pool_clk      (tb_conv1_pool_clk),
    .conv1_pool_rst_b    (tb_conv1_pool_rst_b),
    .conv1_pool_a_i      (tb_conv1_pool_a_i),
    .conv1_pool_b_i      (tb_conv1_pool_b_i),
    .conv1_max_pool_o    (tb_conv1_max_pool_o)
);

initial begin
    tb_conv1_pool_clk = 0;
    tb_conv1_pool_rst_b = 0;
    tb_conv1_pool_a_i = '0;
    tb_conv1_pool_b_i = '0;
end

always begin
    #5 tb_conv1_pool_clk = ~tb_conv1_pool_clk;

end

initial begin
    #10 tb_conv1_pool_rst_b = 1;
    
    #20 
    tb_conv1_pool_a_i[0] = 19'b1000010111010101000; tb_conv1_pool_a_i[1] = 19'b1000101010101010101; tb_conv1_pool_a_i[2] = 19'b1111111111111111111; tb_conv1_pool_a_i[3] = 19'b1111111111111111111;
    tb_conv1_pool_b_i[0] = 19'b1111111110101010101; tb_conv1_pool_b_i[1] = 19'b1000101010101010101; tb_conv1_pool_b_i[2] = 19'b0000000000000000001; tb_conv1_pool_b_i[3] = 19'b0000000000000000000;

    #20 
    tb_conv1_pool_a_i[0] = 19'b0000000000000000000; tb_conv1_pool_a_i[1] = 19'b0000000000000000000; tb_conv1_pool_a_i[2] = 19'b0000000000000000000; tb_conv1_pool_a_i[3] = 19'b0000000000000000000;
    tb_conv1_pool_b_i[0] = 19'b0000000000000000000; tb_conv1_pool_b_i[1] = 19'b0000000000000000000; tb_conv1_pool_b_i[2] = 19'b0000000000000000000; tb_conv1_pool_b_i[3] = 19'b0000000000000000000;

    #50 tb_conv1_pool_rst_b = 0;
    #50 tb_conv1_pool_rst_b = 1;

    #20 
    tb_conv1_pool_a_i[0] = 19'b1111111111111111111; tb_conv1_pool_a_i[1] = 19'b1111111111111111111; tb_conv1_pool_a_i[2] = 19'b1111111111111111111; tb_conv1_pool_a_i[3] = 19'b1111111111111111111;
    tb_conv1_pool_b_i[0] = 19'b1111111111111111111; tb_conv1_pool_b_i[1] = 19'b1111111111111111111; tb_conv1_pool_b_i[2] = 19'b1111111111111111111; tb_conv1_pool_b_i[3] = 19'b1111111111111111111;

    #20
    tb_conv1_pool_a_i[0] = 19'b0000000000000000000; tb_conv1_pool_a_i[1] = 19'b0000000000000000000; tb_conv1_pool_a_i[2] = 19'b0000000000000000000; tb_conv1_pool_a_i[3] = 19'b1111111111111111111;
    tb_conv1_pool_b_i[0] = 19'b0000000000000000000; tb_conv1_pool_b_i[1] = 19'b0111000000000000000; tb_conv1_pool_b_i[2] = 19'b0000000000111110001; tb_conv1_pool_b_i[3] = 19'b0000000000000000001;

    #100 $finish;
end

endmodule
