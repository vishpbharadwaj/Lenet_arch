//


module dff_en #(
                parameter DATA_WIDTH = 8   
)(
    input logic                     dff_clk,
    input logic                     dff_rst_b,
    input logic                     dff_en,
    input logic [DATA_WIDTH-1 : 0]  dff_in_i,
    output logic [DATA_WIDTH-1 : 0] dff_out_o
);

always_ff @( posedge(dff_clk) or negedge(dff_rst_b) ) begin
    if (~dff_rst_b)
        dff_out_o <= {(DATA_WIDTH){1'b0}};
    else if (dff_en)
        dff_out_o <= dff_in_i;
end

endmodule
