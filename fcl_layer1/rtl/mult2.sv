//
`define max_eq(a,b) (a > b) ? a : b

module mult2 #(
              parameter OPERAND_WIDTH = 8,
              parameter OUTPUT_WIDTH = 2 * OPERAND_WIDTH
)(
    input logic                        mult2_clk,
    input logic                        mult2_rst_b,
    input logic [OPERAND_WIDTH-1 : 0]  mult2_a_i,
    input logic [OPERAND_WIDTH-1 : 0]  mult2_b_i,
    output logic [OUTPUT_WIDTH-1 : 0]  mult2_out_o
);

//signals
logic [OUTPUT_WIDTH-1 :0]mult2_sig;

always_ff @( posedge(mult2_clk) or negedge(mult2_rst_b) ) begin
    if (~mult2_rst_b)
        mult2_out_o <= 'b0;
    else
        mult2_out_o <= mult2_sig;
end

assign mult2_sig = mult2_a_i * mult2_b_i;

endmodule
