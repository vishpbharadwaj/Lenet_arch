//


module actv_relu #(
                        parameter INPUT_WIDTH   = 22,
                        parameter NUM_INPUTS    = 4,
                        parameter OUTPUT_WIDTH  = INPUT_WIDTH
)(
    input logic                                         actv_clk,
    input logic                                         actv_rst_b,
    input logic [NUM_INPUTS-1 : 0][INPUT_WIDTH-1 : 0]   actv_in_i,
    output logic [NUM_INPUTS-1 : 0][OUTPUT_WIDTH-1 : 0] actv_out_o
);

//signals
logic [NUM_INPUTS-1 : 0][OUTPUT_WIDTH-1 : 0] actv_out_sig;

/* Flop */
always_ff @( posedge(actv_clk) or negedge(actv_rst_b) ) begin
    if (~actv_rst_b) 
        actv_out_o <= {(NUM_INPUTS*OUTPUT_WIDTH){1'b0}};
    else
        actv_out_o <= actv_out_sig;
end

genvar j;
generate 
    for(j=0; j<NUM_INPUTS; j=j+1)begin
        assign actv_out_sig[j] = ( actv_in_i[j][INPUT_WIDTH-1] == 1 ) ? 0 : actv_in_i[j]; //RELU activation function
    end
endgenerate

endmodule
