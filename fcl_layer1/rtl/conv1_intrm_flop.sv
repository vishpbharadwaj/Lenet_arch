//

module conv1_intrm_flop #(
                        parameter NUM_INPUTS    = 5,
                        parameter INPUT_WIDTH   = 32,
                        parameter OUTPUT_WIDTH  = 2 * INPUT_WIDTH
)(
    input logic                                           intrm_flop_clk,
    input logic                                           intrm_flop_rst_b,
    input logic                                           intrm_flop_en_i,
    input logic [NUM_INPUTS-1 : 0][INPUT_WIDTH-1 : 0]     intrm_flop_in_i,
    output logic [NUM_INPUTS-1 : 0][OUTPUT_WIDTH-1 : 0]   intrm_flop_out_o
);

genvar i;
generate 
    for (i=0; i<NUM_INPUTS; i++) begin : intrm_flop_inst
        intrm_flop #(
                    .INPUT_WIDTH    (INPUT_WIDTH),
                    .OUTPUT_WIDTH   (OUTPUT_WIDTH)
        )
        conv1_top_intrm_flop_inst(
            .intrm_flop_clk      (intrm_flop_clk),
            .intrm_flop_rst_b    (intrm_flop_rst_b),
            .intrm_flop_en_i     (intrm_flop_en_i),
            .intrm_flop_in_i     (intrm_flop_in_i[i]),
            .intrm_flop_out_o    (intrm_flop_out_o[i])
        );
    end
endgenerate

endmodule
