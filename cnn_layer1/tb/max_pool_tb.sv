//

module max_pool_tb;

parameter OPERAND_WDTH    = 19;
parameter NUM_PIXELS      =  2;

reg                                         tb_pool_clk;
reg                                         tb_pool_rst_b;
reg  [NUM_PIXELS-1 :0] [OPERAND_WDTH-1 :0]  tb_pool_a_i;
reg  [NUM_PIXELS-1 :0] [OPERAND_WDTH-1 :0]  tb_pool_b_i; 
wire [OPERAND_WDTH-1 :0]                    tb_max_pool_o;

max_pool #(
        .OPERAND_WDTH   (OPERAND_WDTH),
        .NUM_PIXELS     (NUM_PIXELS)
)
uut(
    .pool_clk    (tb_pool_clk),
    .pool_rst_b  (tb_pool_rst_b),
    .pool_a_i    (tb_pool_a_i),
    .pool_b_i    (tb_pool_b_i),
    .max_pool_o  (tb_max_pool_o)
);

initial begin
    tb_pool_clk = 0;
    tb_pool_rst_b = 0;
    tb_pool_a_i = '0;
    tb_pool_b_i = '0;
end

always begin
    #5 tb_pool_clk = ~tb_pool_clk;
end

initial begin
    #10 tb_pool_rst_b = 1;

    #20 
    tb_pool_a_i[0] = 19'b1000010111010101000; tb_pool_a_i[1] = 19'b1000101010101010101;
    tb_pool_b_i[0] = 19'b1111111110101010101; tb_pool_b_i[1] = 19'b1000101010101010101;

    #50 tb_pool_rst_b = 0;
    #50 tb_pool_rst_b = 1;

    #20 
    tb_pool_a_i[0] = 19'b1111111111111111111; tb_pool_a_i[1] = 19'b1111111111111111111;
    tb_pool_b_i[0] = 19'b0000000000000000000; tb_pool_b_i[1] = 19'b0000000000000000000;

    #20 
    tb_pool_a_i[0] = 19'b0000000000000000000; tb_pool_a_i[1] = 19'b0000000000000000000;
    tb_pool_b_i[0] = 19'b0000000000000000000; tb_pool_b_i[1] = 19'b0000000000000000000;

    #500 $finish;
end

endmodule
