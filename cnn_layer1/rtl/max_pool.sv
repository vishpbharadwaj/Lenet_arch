//


module max_pool #(
  		  parameter OPERAND_WDTH    = 19,
		  parameter NUM_PIXELS      =  2
)(
    input  logic                                       pool_clk,
    input  logic                                       pool_rst_b,
    input  logic [NUM_PIXELS-1 :0] [OPERAND_WDTH-1 :0] pool_a_i,
    input  logic [NUM_PIXELS-1 :0] [OPERAND_WDTH-1 :0] pool_b_i,
    output logic [OPERAND_WDTH-1 :0]                   max_pool_o
);

logic [NUM_PIXELS-1 :0] [OPERAND_WDTH-1 :0] max_sel_sig;
logic [OPERAND_WDTH-1 :0]                   max_pol_sig; 


always_ff @ (posedge pool_clk or negedge pool_rst_b) begin
    if (~ pool_rst_b)
        max_pool_o  <= {(OPERAND_WDTH){1'b0}};
    else
        max_pool_o  <= max_pol_sig;
end   

always_comb begin
    if( pool_a_i[0] >= pool_a_i[1])
        max_sel_sig[0] = pool_a_i[0];
    else
        max_sel_sig[0] = pool_a_i[1];
    
    if( pool_b_i[0] >= pool_b_i[1])
        max_sel_sig[1] = pool_b_i[0];
    else
        max_sel_sig[1] = pool_b_i[1];
    
    if(max_sel_sig[0] >= max_sel_sig[1])
        max_pol_sig = max_sel_sig[0];
    else
        max_pol_sig = max_sel_sig[1];

end

endmodule
