//

module linebuff_1F_rowxcol #(
                        parameter DATA_WIDTH    = 32,
                        parameter NUM_SHIFTS    = 32,
                        parameter NUM_TAPS      = 3, //final out-1 
                        parameter TAP_START     = 8,
                        parameter TAPS_STRIDE   = 8,
                        parameter NUM_PORT_OUT  = NUM_TAPS + 1 + 1 //1F + 1 shiftn out + num_taps
)(
    input logic                                         lb_clk,
    input logic                                         lb_rst_b,
    input logic                                         lb_en,
    input logic [DATA_WIDTH-1 : 0]                      lb_in_i,
    output logic [NUM_PORT_OUT-1 : 0][DATA_WIDTH-1 : 0] lb_out_o
    
);

//------- signals --------//
logic [DATA_WIDTH-1 : 0] ff_out_sig;



/****** one flop ******/
dff_en #(
        .DATA_WIDTH (DATA_WIDTH)
)
first_flop_dff_en_inst(
    .dff_clk     (lb_clk),
    .dff_rst_b   (lb_rst_b),
    .dff_en      (lb_en),
    .dff_in_i    (lb_in_i),
    .dff_out_o   (ff_out_sig)
);
/****** one flop ends ******/

assign lb_out_o[0] = ff_out_sig;

/***** Shift registers ******/
shift_regn #(
            .DATA_WIDTH  (DATA_WIDTH),
            .NUM_SHIFTS  (NUM_SHIFTS),
            .NUM_TAPS    (NUM_TAPS),
            .TAP_START   (TAP_START),
            .TAPS_STRIDE (TAPS_STRIDE)
)
line_buff_regs_inst(
    .sr_clk      (lb_clk),
    .sr_rst_b    (lb_rst_b),
    .sr_en       (lb_en),
    .sr_data_i   (ff_out_sig),
    .sr_data_o   (lb_out_o[NUM_PORT_OUT-1 : 1])
);

/***** Shift registers ends ******/

endmodule
