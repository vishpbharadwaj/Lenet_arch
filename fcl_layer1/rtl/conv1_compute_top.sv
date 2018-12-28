//

module conv1_compute_top #(
                        parameter STRIDE_LENGTH         = 4,
                        parameter NUM_FILT              = 6,
                        parameter NUM_PIXELS            = 100,
                        parameter PIXEL_WIDTH           = 8,
                        parameter NUM_FILT_ROWS         = 5,
                        parameter WEIGHT_WIDTH          = 8,
                        parameter NUM_WEIGHTS           = 25,
                        parameter OPERAND_WIDTH         = 8,
                        parameter NUM_PXL_OUT_PER_FILT  = 4,
                        parameter STRD_OUTPUT_WIDTH     = 22, //2*8+3+ parladd = 22
                        parameter INPUT_WIDTH           = STRD_OUTPUT_WIDTH,
                        parameter NUM_INPUTS            = STRIDE_LENGTH,
                        parameter ACTV_OUTPUT_WIDTH     = INPUT_WIDTH
)(
    input logic                                                                                 conv1_top_clk,
    input logic                                                                                 conv1_top_rst_b,
    input logic [NUM_FILT-1 : 0][NUM_PIXELS-1 : 0][PIXEL_WIDTH-1 : 0]                           conv1_pxls_i, //TODO: should be NUM_FILT and then followed by the dimemsions
    input logic [NUM_FILT-1 : 0][STRIDE_LENGTH-1 : 0][NUM_WEIGHTS-1 : 0][WEIGHT_WIDTH-1 : 0]    conv1_wghts_i,
    output logic [NUM_FILT-1 : 0][NUM_PXL_OUT_PER_FILT-1 : 0][ACTV_OUTPUT_WIDTH-1 : 0]          conv1_out_o
);

genvar i;
generate
    for (i=0; i<NUM_FILT; i++) begin : conv1_compute_top
        conv1_compute_actv #(
                            .STRIDE_LENGTH      (STRIDE_LENGTH),
                            .FILTER_ROWS        (NUM_FILT_ROWS),
                            .PIXEL_WIDTH        (PIXEL_WIDTH),
                            .WEIGHT_WIDTH       (WEIGHT_WIDTH),
                            .NUM_PIXELS         (NUM_PIXELS),
                            .NUM_WEIGHTS        (NUM_WEIGHTS),
                            .OPERAND_WIDTH      (OPERAND_WIDTH),
                            .STRD_OUTPUT_WIDTH  (STRD_OUTPUT_WIDTH),
                            .INPUT_WIDTH        (INPUT_WIDTH),
                            .NUM_INPUTS         (NUM_INPUTS),
                            .ACTV_OUTPUT_WIDTH  (ACTV_OUTPUT_WIDTH)

        )
        conv1_compute_actv_per_filt_inst(
            .conv1_actv_clk             (conv1_top_clk),
            .conv1_actv_rst_b           (conv1_top_rst_b),
            .conv1_compute_actv_in_i    (conv1_pxls_i[i]),
            .conv1_weight_vals_i        (conv1_wghts_i[i]),
            .conv1_compute_actv_out_o   (conv1_out_o[i])
        );
    end
endgenerate

endmodule
