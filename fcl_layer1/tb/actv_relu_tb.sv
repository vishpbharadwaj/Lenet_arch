//

module actv_relu_tb;

parameter INPUT_WIDTH = 22;
parameter NUM_INPUTS = 4;
parameter OUTPUT_WIDTH = INPUT_WIDTH;


reg                                            tb_actv_clk;
reg                                            tb_actv_rst_b;
reg    [NUM_INPUTS-1 : 0][INPUT_WIDTH-1 : 0]   tb_actv_in_i;
wire    [NUM_INPUTS-1 : 0][OUTPUT_WIDTH-1 : 0] tb_actv_out_o;

actv_relu #(
          INPUT_WIDTH,
          NUM_INPUTS, 
          OUTPUT_WIDTH
)
uut(
    .actv_clk    (tb_actv_clk),
    .actv_rst_b  (tb_actv_rst_b),
    .actv_in_i   (tb_actv_in_i),
    .actv_out_o  (tb_actv_out_o)
);

initial begin
    tb_actv_clk = 'b0;
    tb_actv_rst_b = 'b0;
end

always begin
    #5 tb_actv_clk = !tb_actv_clk;
end

initial begin
    #10 tb_actv_rst_b = 1;

    #10 tb_actv_in_i[0] = 22'h200000; tb_actv_in_i[1] = 22'h100000;tb_actv_in_i[2] = 22'h1fffff;tb_actv_in_i[3] = 22'h2fffff;

    #1000 $finish;
end

endmodule
