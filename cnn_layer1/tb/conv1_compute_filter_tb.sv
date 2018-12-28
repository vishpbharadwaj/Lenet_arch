//

module conv1_compute_filter_tb;

localparam FILTER_ROWS      = 5;
localparam PIXEL_WIDTH      = 8;
localparam WEIGHT_WIDTH     = 8;
localparam NUM_PIXELS       = 25;
localparam NUM_WEIGHTS      = 25;
localparam OPERAND_WIDTH    = 8;
localparam OUTPUT_WIDTH     = 22;//2*8+3+ parladd = 22


reg                                                 tb_conv1_filt_clk;
reg                                                 tb_conv1_filt_rst_b;
reg signed [NUM_PIXELS-1 : 0][PIXEL_WIDTH-1 : 0]    tb_pxl_filt_vals_i; //outside of this the rows needs to be concatinated so jumps of 5s are done
reg signed [NUM_WEIGHTS-1 : 0][WEIGHT_WIDTH-1 : 0]  tb_weight_vals_i;//outside of this the rows needs to be concatinated so jumps of 5s are done 
wire signed [OUTPUT_WIDTH-1 : 0]                    tb_conv1_compute_filter_o;

conv1_compute_filter #(
                .FILTER_ROWS     (FILTER_ROWS),
                .PIXEL_WIDTH     (PIXEL_WIDTH),
                .WEIGHT_WIDTH    (WEIGHT_WIDTH),
                .NUM_PIXELS      (NUM_PIXELS),
                .NUM_WEIGHTS     (NUM_WEIGHTS),
                .OPERAND_WIDTH   (OPERAND_WIDTH),
                .OUTPUT_WIDTH    (OUTPUT_WIDTH)
)
uut(
    .conv1_filt_clk          (tb_conv1_filt_clk),
    .conv1_filt_rst_b        (tb_conv1_filt_rst_b),
    .pxl_filt_vals_i         (tb_pxl_filt_vals_i),
    .weight_vals_i           (tb_weight_vals_i),
    .conv1_compute_filter_o  (tb_conv1_compute_filter_o)
);

always #5 tb_conv1_filt_clk = ~tb_conv1_filt_clk;

initial begin
    tb_conv1_filt_clk = 0;
    tb_conv1_filt_rst_b = 0;
    tb_pxl_filt_vals_i = '0;
    tb_weight_vals_i = '0;
    $display("simulation starting\n");

    #10 tb_conv1_filt_rst_b = 1;
    #10 tb_pxl_filt_vals_i = '1; tb_weight_vals_i = '1;

    #500 $finish;
end

endmodule
