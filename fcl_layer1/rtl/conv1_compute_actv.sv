//


module conv1_compute_actv #(
                            parameter STRIDE_LENGTH     = 4,
                            parameter FILTER_ROWS       = 5,
                            parameter PIXEL_WIDTH       = 8,
                            parameter WEIGHT_WIDTH      = 8,
                            parameter NUM_PIXELS        = 100,
                            parameter NUM_WEIGHTS       = 25,
                            parameter OPERAND_WIDTH     = 8,
                            parameter STRD_OUTPUT_WIDTH = 22, //2*8+3+ parladd = 22
                            parameter INPUT_WIDTH       = STRD_OUTPUT_WIDTH,
                            parameter NUM_INPUTS        = STRIDE_LENGTH,
                            parameter ACTV_OUTPUT_WIDTH = INPUT_WIDTH

)(
    input logic                                                                 conv1_actv_clk,
    input logic                                                                 conv1_actv_rst_b,
    input logic [NUM_PIXELS-1 : 0][PIXEL_WIDTH-1 : 0]                           conv1_compute_actv_in_i,
    input logic [STRIDE_LENGTH-1 : 0][NUM_WEIGHTS-1 : 0][WEIGHT_WIDTH-1 : 0]    conv1_weight_vals_i,//outside of this the rows needs to be concatinated so jumps of 5s are done 
    output logic [NUM_INPUTS-1 : 0][ACTV_OUTPUT_WIDTH-1 : 0]                    conv1_compute_actv_out_o
);

//signals
logic [STRIDE_LENGTH-1 : 0][STRD_OUTPUT_WIDTH-1 : 0] conv1_compute_stride_o_sig;

//compute instantiation
conv1_compute_stride #(
                    .STRIDE_LENGTH   (STRIDE_LENGTH),
                    .FILTER_ROWS     (FILTER_ROWS),
                    .PIXEL_WIDTH     (PIXEL_WIDTH),
                    .WEIGHT_WIDTH    (WEIGHT_WIDTH),
                    .NUM_PIXELS      (NUM_PIXELS),
                    .NUM_WEIGHTS     (NUM_WEIGHTS),
                    .OPERAND_WIDTH   (OPERAND_WIDTH),
                    .OUTPUT_WIDTH    (STRD_OUTPUT_WIDTH) 
)
conv1_compute_stride_per_filt_inst(
    .conv1_stride_clk        (conv1_actv_clk),
    .conv1_stride_rst_b      (conv1_actv_rst_b),
    .pxl_strd_vals_i         (conv1_compute_actv_in_i),
    .weight_vals_i           (conv1_weight_vals_i),
    .conv1_compute_stride_o  (conv1_compute_stride_o_sig)
);

//actviation instantiation
actv_relu #(
            .INPUT_WIDTH     (INPUT_WIDTH),
            .NUM_INPUTS      (NUM_INPUTS),
            .OUTPUT_WIDTH    (ACTV_OUTPUT_WIDTH)
)
conv1_actv_relu_inst(
    .actv_clk    (conv1_actv_clk),
    .actv_rst_b  (conv1_actv_rst_b),
    .actv_in_i   (conv1_compute_stride_o_sig),
    .actv_out_o  (conv1_compute_actv_out_o)
);

endmodule
