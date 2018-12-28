//
  

module conv1_max_pool #(
  		  parameter OPERAND_WDTH    = 22,
		  parameter NUM_PIXELS_BUF  = 4,
		  parameter NUM_PIXELS_POOL = 2 
)(
    input logic                                             conv1_pool_clk,
    input  logic                                            conv1_pool_rst_b,
    input  logic [NUM_PIXELS_BUF-1 :0] [OPERAND_WDTH-1 :0]  conv1_pool_a_i,
    input  logic [NUM_PIXELS_BUF-1 :0] [OPERAND_WDTH-1 :0]  conv1_pool_b_i,
    output logic [NUM_PIXELS_POOL-1 :0] [OPERAND_WDTH-1 :0] conv1_max_pool_o
);

localparam NUM_PIXELS = NUM_PIXELS_BUF/2;


genvar i;
generate
    for (i=0 ;i<NUM_PIXELS_POOL; i=i+1) begin : conv1_pool_inst
        max_pool #(
                .OPERAND_WDTH (OPERAND_WDTH),
	            .NUM_PIXELS   (NUM_PIXELS)
	    ) 
        conv1_inst
        (
            .pool_clk        (conv1_pool_clk),
            .pool_rst_b      (conv1_pool_rst_b),
            .pool_a_i        (conv1_pool_a_i[(2*i)+1:(2*i)]),
            .pool_b_i        (conv1_pool_b_i[(2*i)+1:(2*i)]),
            .max_pool_o      (conv1_max_pool_o[i])
        );
    end
endgenerate

endmodule
