// Mult add 5 pairs

`define PAIR 2

module mult_add_5pairs #(
                parameter integer OPERAND_WIDTH = 8,
                parameter integer OUTPUT_WIDTH  = 2 * OPERAND_WIDTH + 3
)(
    input logic                                    mult_add5_clk,
    input logic                                    mult_add5_rst_b,
    input logic [`PAIR-1 : 0][OPERAND_WIDTH-1 : 0] mult_add5_in_a_i,
    input logic [`PAIR-1 : 0][OPERAND_WIDTH-1 : 0] mult_add5_in_b_i,
    input logic [`PAIR-1 : 0][OPERAND_WIDTH-1 : 0] mult_add5_in_c_i,
    input logic [`PAIR-1 : 0][OPERAND_WIDTH-1 : 0] mult_add5_in_d_i,
    input logic [`PAIR-1 : 0][OPERAND_WIDTH-1 : 0] mult_add5_in_e_i,
    output logic [OUTPUT_WIDTH-1 : 0]              mult_add5_out_o
);

//localparam
localparam pair5_out_width = 2 * OPERAND_WIDTH;
localparam mult_add_out_width_stage_1 = 2 * OPERAND_WIDTH + 1;
localparam max_pair_1234 = 1 + mult_add_out_width_stage_1;

//signals
//first stage mult_add signals
logic [pair5_out_width-1 : 0]            pair5_bf_ff_sig; //before flop
logic [mult_add_out_width_stage_1-1 : 0] multaddout_pair12_sig;
logic [mult_add_out_width_stage_1-1 : 0] multaddout_pair34_sig;

//2nd stage adder signals
logic [pair5_out_width-1 : 0] pair5_af_ff_sig; //after flop
logic [max_pair_1234 -1 : 0]  addout_pair1234;

//final stage
logic [OUTPUT_WIDTH-1 : 0] multadd5_out_sig;


//Logic starts

/*pair 5 flop */
always_ff @( posedge(mult_add5_clk) or negedge(mult_add5_rst_b) ) begin
    if (~mult_add5_rst_b)
        pair5_af_ff_sig <= {(pair5_out_width){1'b0}};
    else
        pair5_af_ff_sig <= pair5_bf_ff_sig;
end



//instantiations

/* pair 1 and 2 */
mult_add_2pairs #(
        .OPERAND_WIDTH (OPERAND_WIDTH)
)
mult_add_pair_1_2_inst(
    .mult_add_clk     (mult_add5_clk),
    .mult_add_rst_b   (mult_add5_rst_b),
    .mult_add_in_a_i  (mult_add5_in_a_i),
    .mult_add_in_b_i  (mult_add5_in_b_i),
    .mult_add_out_o   (multaddout_pair12_sig)
);

/* pair 3 and 4 */
mult_add_2pairs #(
        .OPERAND_WIDTH (OPERAND_WIDTH)
)
mult_add_pair_3_4_inst(
    .mult_add_clk     (mult_add5_clk),
    .mult_add_rst_b   (mult_add5_rst_b),
    .mult_add_in_a_i  (mult_add5_in_c_i),
    .mult_add_in_b_i  (mult_add5_in_d_i),
    .mult_add_out_o   (multaddout_pair34_sig)
);

/* Adder of pair 1,2 and pair 3,4 */
parl_add_2 #(
        .OPERAND_WIDTH  (mult_add_out_width_stage_1)
)
adder_pair_12_34_inst(
    .parl_add_clk     (mult_add5_clk),
    .parl_add_rst_b   (mult_add5_rst_b),
    .parl_add_in_a_i  (multaddout_pair12_sig),
    .parl_add_in_b_i  (multaddout_pair34_sig),
    .parl_add_out_o   (addout_pair1234)
);


/* pair 5 */
mult2 #(
        .OPERAND_WIDTH (OPERAND_WIDTH)
)
mult_add_pair_5_inst(
    .mult2_clk   (mult_add5_clk),   
    .mult2_rst_b (mult_add5_rst_b),
    .mult2_a_i   (mult_add5_in_e_i[0]),
    .mult2_b_i   (mult_add5_in_e_i[1]),
    .mult2_out_o (pair5_bf_ff_sig)
);


/* Adder of pair 1,2,3,4 and 5 */
parl_add_2 #(
        .OPERAND_WIDTH  (max_pair_1234)
)
adder_pair_1234_5_inst(
    .parl_add_clk     (mult_add5_clk),
    .parl_add_rst_b   (mult_add5_rst_b),
    .parl_add_in_a_i  (addout_pair1234),
    .parl_add_in_b_i  ({2'b0,pair5_af_ff_sig}),
    .parl_add_out_o   (multadd5_out_sig)
);


/* final flop */
always_ff @( posedge(mult_add5_clk) or negedge(mult_add5_rst_b) ) begin
    if (~mult_add5_rst_b)
        mult_add5_out_o <= {(OUTPUT_WIDTH){1'b0}};
    else
        mult_add5_out_o <= multadd5_out_sig;
end

endmodule
