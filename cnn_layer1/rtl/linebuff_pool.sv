//

module linebuff_pool #(
                    parameter NUM_FILT      = 6,
                    parameter DATA_WIDTH    = 88,
                    parameter NUM_SHIFTS    = 7,
                    parameter NUM_TAPS      = 0, //final out-1 
                    parameter TAP_START     = 0,
                    parameter TAPS_STRIDE   = 7,
                    parameter NUM_PORT_OUT  = NUM_TAPS + 1 + 1//1F + 1 shiftn out + num_taps
)(
    input logic                                                         lb_pool_clk,
    input logic                                                         lb_pool_rst_b,
    input logic                                                         lb_pool_en,
    input logic  [NUM_FILT-1 :0][DATA_WIDTH-1 : 0]                      lb_pool_in_i,
    output logic [NUM_FILT-1 :0][NUM_PORT_OUT-1 : 0][DATA_WIDTH-1 : 0]  lb_pool_out_o
);

genvar i;
generate 
    for (i=0; i<NUM_FILT; i++) begin: pool_line_buff_inst
        linebuff_1F_rowxcol #(
                    .DATA_WIDTH      (DATA_WIDTH),
                    .NUM_SHIFTS      (NUM_SHIFTS),
                    .NUM_TAPS        (NUM_TAPS),
                    .TAP_START       (TAP_START),
                    .TAPS_STRIDE     (TAPS_STRIDE)
        )
        conv1_pool_line_buff_inst(
            .lb_clk      (lb_pool_clk),
            .lb_rst_b    (lb_pool_rst_b),
            .lb_en       (lb_pool_en),
            .lb_in_i     (lb_pool_in_i[i]),
            .lb_out_o    (lb_pool_out_o[i])
        );
    end
endgenerate

endmodule
