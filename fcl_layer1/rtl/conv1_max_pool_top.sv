//

module conv1_max_pool_top #(
                    parameter NUM_FILT        = 6,
  		            parameter OPERAND_WDTH    = 22,
		            parameter NUM_PIXELS_BUF  = 4,
		            parameter NUM_PIXELS_POOL = 2 

)(
    input logic                                                             conv1_pool_clk,
    input logic                                                             conv1_pool_rst_b,
    input  logic [NUM_FILT-1 :0][NUM_PIXELS_BUF-1 :0] [OPERAND_WDTH-1 :0]   conv1_pool_a_i,
    input  logic [NUM_FILT-1 :0][NUM_PIXELS_BUF-1 :0] [OPERAND_WDTH-1 :0]   conv1_pool_b_i,
    output logic [NUM_FILT-1 :0][NUM_PIXELS_POOL-1 :0] [OPERAND_WDTH-1 :0]  conv1_max_pool_o
);

genvar i;
generate
    for (i=0; i<NUM_FILT; i++) begin: pool_per_filt_inst
        conv1_max_pool #(
                        .OPERAND_WDTH    (OPERAND_WDTH),
                        .NUM_PIXELS_BUF  (NUM_PIXELS_BUF),
                        .NUM_PIXELS_POOL (NUM_PIXELS_POOL)
        )
        conv1_max_pool_inst(
            .conv1_pool_clk      (conv1_pool_clk),
            .conv1_pool_rst_b    (conv1_pool_rst_b),
            .conv1_pool_a_i      (conv1_pool_a_i[i]),
            .conv1_pool_b_i      (conv1_pool_b_i[i]),
            .conv1_max_pool_o    (conv1_max_pool_o[i])
        );
    end
endgenerate

endmodule
