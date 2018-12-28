// Mult add 2 pairs

`define PAIR 2

module mult_add_2pairs #(
                parameter integer OPERAND_WIDTH = 8,
                parameter integer OUTPUT_WIDTH  = 2 * OPERAND_WIDTH + 1
)(
    input logic                                    mult_add_clk,
    input logic                                    mult_add_rst_b,
    input logic [`PAIR-1 : 0][OPERAND_WIDTH-1 : 0] mult_add_in_a_i,
    input logic [`PAIR-1 : 0][OPERAND_WIDTH-1 : 0] mult_add_in_b_i,
    output logic [OUTPUT_WIDTH-1 : 0]              mult_add_out_o
);

//signals
logic [2 * OPERAND_WIDTH -1 : 0] mult_pair1_sig;
logic [2 * OPERAND_WIDTH -1 : 0] mult_pair2_sig;
logic [OUTPUT_WIDTH-1 : 0]       add_mults_sig;


always_ff @( posedge(mult_add_clk) or negedge(mult_add_rst_b) ) begin
    if (~mult_add_rst_b)
        mult_add_out_o <= {(OUTPUT_WIDTH){1'b0}};
    else
        mult_add_out_o <= add_mults_sig;
end

always_comb begin
    mult_pair1_sig = mult_add_in_a_i[0] * mult_add_in_a_i[1];
    mult_pair2_sig = mult_add_in_b_i[0] * mult_add_in_b_i[1];
    
    add_mults_sig = mult_pair1_sig + mult_pair2_sig;
end

endmodule
