//

module dff_en_tb;

parameter DATA_WIDTH = 2;

reg                    tb_dff_clk;
reg                    tb_dff_rst_b;
reg                    tb_dff_en;
reg  [DATA_WIDTH-1 : 0]tb_dff_in_i;
wire [DATA_WIDTH-1 : 0]tb_dff_out_o;

dff_en #(
        .DATA_WIDTH (DATA_WIDTH)
)
uut(
    .dff_clk    (tb_dff_clk),
    .dff_rst_b  (tb_dff_rst_b),
    .dff_en     (tb_dff_en),
    .dff_in_i   (tb_dff_in_i),
    .dff_out_o  (tb_dff_out_o)
);

always #5 tb_dff_clk = ~tb_dff_clk;

initial begin
    tb_dff_clk = 0;
    tb_dff_rst_b = 1;
    tb_dff_en = 1;
    tb_dff_in_i = '0;

    //posedge tb_dff_clk 
        #1 
        #20 tb_dff_in_i = 2'b11;
        #20 tb_dff_in_i = 2'b00;
        #20 tb_dff_in_i = 2'b01;
        #20 tb_dff_in_i = 2'b10;
        #20 tb_dff_in_i = 2'b11;

    #100 $finish;
end

endmodule
