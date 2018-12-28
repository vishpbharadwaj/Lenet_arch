/*
* non parameterized parallel adder with 2 number of inputs  
*
*/
module parl_add_2 #(
                parameter integer OPERAND_WIDTH = 18,
                parameter integer OUTPUT_WIDTH  = OPERAND_WIDTH+1
)(
    input logic                             parl_add_clk,
    input logic                             parl_add_rst_b,
    input logic     [OPERAND_WIDTH-1 : 0]   parl_add_in_a_i,
    input logic     [OPERAND_WIDTH-1 : 0]   parl_add_in_b_i,
    output logic    [OUTPUT_WIDTH-1  : 0]   parl_add_out_o
);


//signals
logic [OUTPUT_WIDTH-1 : 0] add_1_2_sig;

always_ff @( posedge(parl_add_clk) or negedge(parl_add_rst_b) ) begin
    if (~parl_add_rst_b)
      parl_add_out_o <= {(OUTPUT_WIDTH){1'b0}};
    else
      parl_add_out_o <= add_1_2_sig;
end

always_comb begin
  add_1_2_sig = parl_add_in_a_i + parl_add_in_b_i;
end

endmodule
