//


module conv1_compute_stride #(
                            parameter STRIDE_LENGTH = 4,
                            parameter FILTER_ROWS = 5,
                            parameter PIXEL_WIDTH = 8,
                            parameter WEIGHT_WIDTH = 8,
                            parameter NUM_PIXELS = 100,
                            parameter NUM_WEIGHTS = 25,
                            parameter OPERAND_WIDTH = 8,
                            parameter OUTPUT_WIDTH = 22 //2*8+3+ parladd = 22
                            
)(
    input logic                                                                 conv1_stride_clk,
    input logic                                                                 conv1_stride_rst_b,
    input logic [NUM_PIXELS-1 : 0][PIXEL_WIDTH-1 : 0]                           pxl_strd_vals_i,
    input logic [STRIDE_LENGTH-1 : 0][NUM_WEIGHTS-1 : 0][WEIGHT_WIDTH-1 : 0]    weight_vals_i,//outside of this the rows needs to be concatinated so jumps of 5s are done 
    output logic [STRIDE_LENGTH-1 : 0][OUTPUT_WIDTH-1 : 0]                      conv1_compute_stride_o
);


/* Generate 4 times cov1_compute_filter */
genvar i;
generate 
    for (i=0; i<STRIDE_LENGTH; i++) begin : stride_inst
        conv1_compute_filter #(
                      .FILTER_ROWS      (FILTER_ROWS),
                      .PIXEL_WIDTH      (PIXEL_WIDTH),
                      .WEIGHT_WIDTH     (WEIGHT_WIDTH),
                      .NUM_PIXELS       (NUM_PIXELS/STRIDE_LENGTH),
                      .NUM_WEIGHTS      (NUM_WEIGHTS),
                      .OPERAND_WIDTH    (OPERAND_WIDTH),
                      .OUTPUT_WIDTH     (OUTPUT_WIDTH)
        )
        conv_filter_stride_inst(
            .conv1_filt_clk         (conv1_stride_clk),
            .conv1_filt_rst_b       (conv1_stride_rst_b),
            .pxl_filt_vals_i        (pxl_strd_vals_i[(i * NUM_WEIGHTS + 24) : (i * NUM_WEIGHTS)]), //1st 25 is for 1st filter and next is for next and so on
            .weight_vals_i          (weight_vals_i[i]),
            .conv1_compute_filter_o (conv1_compute_stride_o[i])
        );
    end

endgenerate

endmodule
