//

module shift_regn #(
                parameter DATA_WIDTH    = 32,
                parameter NUM_SHIFTS    = 32,
                parameter NUM_TAPS      = 4, //excluding last one, should be always less then NUM_SHIFTS
                parameter TAP_START     = 0,
                parameter TAPS_STRIDE   = 8,
                parameter NUM_TOTAL_OUT = 1 + NUM_TAPS
) (
  input logic                                           sr_clk,
  input logic                                           sr_rst_b,
  input logic                                           sr_en,
  input logic  [DATA_WIDTH-1 : 0]                       sr_data_i,
  output logic [NUM_TOTAL_OUT-1 : 0][DATA_WIDTH-1 : 0]  sr_data_o //2D array due to taps
);


//signals
logic [NUM_SHIFTS : 0][DATA_WIDTH-1 : 0]sr_flops_sig; //moving to packed array as it is easier to assign zero

assign sr_flops_sig[0] = sr_data_i; 

genvar i;
generate
    for (i=0; i<NUM_SHIFTS; i++) begin : shifts
        always_ff @(posedge(sr_clk) or negedge(sr_rst_b)) begin
            if (~sr_rst_b)
                sr_flops_sig[i+1] <= 'b0; 
            else if (sr_en)
                sr_flops_sig[i+1] <= sr_flops_sig[i];
        end
    end
endgenerate

//taps
genvar j;
generate
    for(j=0; j<NUM_TAPS; j++) begin: taps_out
        //if(j==0)
        //    assign sr_data_o[0] = sr_flops_sig[0]; //for when j=0
        //else
        //    assign sr_data_o[j] = sr_flops_sig[(TAP_START+TAPS_STRIDE*j)];
        assign sr_data_o[j] = sr_flops_sig[(TAP_START+TAPS_STRIDE*j)];
    end
endgenerate

//Final out
assign sr_data_o[NUM_TOTAL_OUT-1] = sr_flops_sig[NUM_SHIFTS];

endmodule
