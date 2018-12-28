//

module intrm_flop #(
                        parameter INPUT_WIDTH   = 32,
                        parameter OUTPUT_WIDTH  = 2 * INPUT_WIDTH
)(
    input logic                         intrm_flop_clk,
    input logic                         intrm_flop_rst_b,
    input logic                         intrm_flop_en_i,
    input logic [INPUT_WIDTH-1 : 0]     intrm_flop_in_i,
    output logic [OUTPUT_WIDTH-1 : 0]   intrm_flop_out_o
);

//signal
logic [INPUT_WIDTH-1 : 0] flop_out_sig;


always_ff @( posedge(intrm_flop_clk) or negedge(intrm_flop_rst_b) ) begin
    if (~intrm_flop_rst_b)
        flop_out_sig <= {(INPUT_WIDTH){1'b0}};
    else if (intrm_flop_en_i)
        flop_out_sig <= intrm_flop_in_i;
end

always_ff @( posedge(intrm_flop_clk) or negedge(intrm_flop_rst_b) ) begin
    if (~intrm_flop_rst_b)
        intrm_flop_out_o <= {(INPUT_WIDTH){1'b0}};
    else if (intrm_flop_en_i)
        intrm_flop_out_o <= {intrm_flop_in_i,flop_out_sig};
end

endmodule
