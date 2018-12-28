//

module conv1_intrm_flop_tb;

parameter NUM_INPUTS = 5;
parameter INPUT_WIDTH = 32;
parameter OUTPUT_WIDTH = 2 * INPUT_WIDTH;

reg                                        tb_intrm_flop_clk;
reg                                        tb_intrm_flop_rst_b;
reg                                        tb_intrm_flop_en_i;
reg  [NUM_INPUTS-1 : 0][INPUT_WIDTH-1 : 0] tb_intrm_flop_in_i;
wire [NUM_INPUTS-1 : 0][OUTPUT_WIDTH-1 : 0]tb_intrm_flop_out_o;

conv1_intrm_flop #(
            .NUM_INPUTS  (NUM_INPUTS),
            .INPUT_WIDTH (INPUT_WIDTH)
)
uut(
    .intrm_flop_clk      (tb_intrm_flop_clk),
    .intrm_flop_rst_b    (tb_intrm_flop_rst_b),
    .intrm_flop_en_i     (tb_intrm_flop_en_i),
    .intrm_flop_in_i     (tb_intrm_flop_in_i),
    .intrm_flop_out_o    (tb_intrm_flop_out_o)
);

initial begin
    tb_intrm_flop_clk = 0;
    tb_intrm_flop_rst_b = 0;
    tb_intrm_flop_en_i = 0;
    tb_intrm_flop_in_i = '0;
end

always #5 tb_intrm_flop_clk = ~tb_intrm_flop_clk;

initial begin
    #5;

    #10 tb_intrm_flop_rst_b = 1;
    #10 tb_intrm_flop_en_i = 1;

    #10  tb_intrm_flop_in_i[0] = 32'haaaa_aaaa; tb_intrm_flop_in_i[1] = 32'hbbbb_bbbb; tb_intrm_flop_in_i[2] = 32'hcccc_cccc; tb_intrm_flop_in_i[3] = 32'hdddd_dddd; tb_intrm_flop_in_i[4] = 32'heeee_eeee;
    #10  tb_intrm_flop_in_i[0] = 32'h1111_1111; tb_intrm_flop_in_i[1] = 32'h2222_2222; tb_intrm_flop_in_i[2] = 32'h3333_3333; tb_intrm_flop_in_i[3] = 32'h4444_4444; tb_intrm_flop_in_i[4] = 32'h5555_5555;
    #10  tb_intrm_flop_in_i[0] = 32'haaaa_aaaa; tb_intrm_flop_in_i[1] = 32'haaaa_aaaa; tb_intrm_flop_in_i[2] = 32'haaaa_aaaa; tb_intrm_flop_in_i[3] = 32'haaaa_aaaa; tb_intrm_flop_in_i[4] = 32'haaaa_aaaa;


    #50 tb_intrm_flop_rst_b = 0;
    #60 tb_intrm_flop_rst_b = 1;

    #5 tb_intrm_flop_in_i[0] = 32'haaaa_0000; tb_intrm_flop_in_i[1] = 32'h0000_bbbb; tb_intrm_flop_in_i[2] = 32'hcccc_0000; tb_intrm_flop_in_i[3] = 32'h0000_dddd; tb_intrm_flop_in_i[4] = 32'heeee_0000;

    #20 tb_intrm_flop_en_i = 0;
    #50 tb_intrm_flop_en_i = 1;


    #5 tb_intrm_flop_in_i[0] = 32'h9999_9999; tb_intrm_flop_in_i[1] = 32'h8888_8888; tb_intrm_flop_in_i[2] = 32'h7777_7777; tb_intrm_flop_in_i[3] = 32'h6666_6666; tb_intrm_flop_in_i[4] = 32'h5555_5555;

    #100 $finish;
end

endmodule
