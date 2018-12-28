//


module conv1_compute_filter #(
                            parameter FILTER_ROWS   = 5,
                            parameter PIXEL_WIDTH   = 8,
                            parameter WEIGHT_WIDTH  = 8,
                            parameter NUM_PIXELS    = 25,
                            parameter NUM_WEIGHTS   = 25,
                            parameter OPERAND_WIDTH = 8,
                            parameter OUTPUT_WIDTH  = 22 //2*8+3+ parladd = 22
)(
    input logic                                          conv1_filt_clk,
    input logic                                          conv1_filt_rst_b,
    input logic [NUM_PIXELS-1 : 0][PIXEL_WIDTH-1 : 0]    pxl_filt_vals_i, //outside of this the rows needs to be concatinated so jumps of 5s are done
    input logic [NUM_WEIGHTS-1 : 0][WEIGHT_WIDTH-1 : 0]  weight_vals_i,//outside of this the rows needs to be concatinated so jumps of 5s are done 
    output logic [OUTPUT_WIDTH-1 : 0]                    conv1_compute_filter_o
);


//localparams
localparam multadd_filt_out_width = 2 * OPERAND_WIDTH + 3;  //TODO: equation


//signals
logic [FILTER_ROWS-1 : 0][multadd_filt_out_width-1 : 0]multadd_filt_out_sig;


/* Generate 5 times mult_add */
genvar i;
generate 
    for (i=0; i<FILTER_ROWS; i=i+1) begin : filt_inst
        mult_add_5pairs #(
                    .OPERAND_WIDTH     (OPERAND_WIDTH)
        )
        mult_add_per_row_inst(
            .mult_add5_clk    (conv1_filt_clk),
            .mult_add5_rst_b  (conv1_filt_rst_b),
            .mult_add5_in_a_i ({pxl_filt_vals_i[(5*i)+0],weight_vals_i[(5*i)+0]}), //mult_add[0] concat wgt[1]
            .mult_add5_in_b_i ({pxl_filt_vals_i[(5*i)+1],weight_vals_i[(5*i)+1]}),
            .mult_add5_in_c_i ({pxl_filt_vals_i[(5*i)+2],weight_vals_i[(5*i)+2]}),
            .mult_add5_in_d_i ({pxl_filt_vals_i[(5*i)+3],weight_vals_i[(5*i)+3]}),
            .mult_add5_in_e_i ({pxl_filt_vals_i[(5*i)+4],weight_vals_i[(5*i)+4]}),
            .mult_add5_out_o  (multadd_filt_out_sig[i])
        );
    end

endgenerate

/* single adder for one filter */
parl_add_5 #(
            .OPERAND_WIDTH  (multadd_filt_out_width)
)
parallel_add_filt_inst(
      .parl_add_top_clk    (conv1_filt_clk),
      .parl_add_top_rst_b  (conv1_filt_rst_b),
      .parl_add_top_in_a_i (multadd_filt_out_sig[0]),
      .parl_add_top_in_b_i (multadd_filt_out_sig[1]),
      .parl_add_top_in_c_i (multadd_filt_out_sig[2]),
      .parl_add_top_in_d_i (multadd_filt_out_sig[3]),
      .parl_add_top_in_e_i (multadd_filt_out_sig[4]),
      .parl_add_top_out_o  (conv1_compute_filter_o)
);

endmodule
