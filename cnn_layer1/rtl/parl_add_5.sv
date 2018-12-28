//


module parl_add_5 #(
                parameter integer OPERAND_WIDTH   =  19,
                parameter integer OUTPUT_WIDTH    =  OPERAND_WIDTH + 3 // write expression
)(
    input logic                          parl_add_top_clk,
    input logic                          parl_add_top_rst_b,
    input logic  [OPERAND_WIDTH-1 : 0]   parl_add_top_in_a_i,
    input logic  [OPERAND_WIDTH-1 : 0]   parl_add_top_in_b_i,
    input logic  [OPERAND_WIDTH-1 : 0]   parl_add_top_in_c_i,
    input logic  [OPERAND_WIDTH-1 : 0]   parl_add_top_in_d_i,
    input logic  [OPERAND_WIDTH-1 : 0]   parl_add_top_in_e_i,
    output logic [OUTPUT_WIDTH-1 : 0]    parl_add_top_out_o
);

//Local params
localparam LEVEL1_S1_OUTPUT_WIDTH = OPERAND_WIDTH + 1;
localparam LEVEL2_S1_OUTPUT_WIDTH = LEVEL1_S1_OUTPUT_WIDTH + 1;


//signals
logic  [LEVEL1_S1_OUTPUT_WIDTH-1  : 0]  parl_add_s1;
logic  [LEVEL1_S1_OUTPUT_WIDTH-1  : 0]  parl_add_s2;
logic  [LEVEL2_S1_OUTPUT_WIDTH-1  : 0]  parl_add_s3;
logic  [OUTPUT_WIDTH-1  : 0]            parl_add_final_sig;
logic  [OPERAND_WIDTH-1 : 0]            parl_add_top_in_e_i_ff1; //before 2nd ff
logic  [OPERAND_WIDTH-1 : 0]            parl_add_top_in_e_i_ff2;//after 2nd ff


/* Adding 1 and 2 */
parl_add_2 #(
          .OPERAND_WIDTH  (OPERAND_WIDTH)
           )

parl_add_pair_1_2_inst
(   .parl_add_clk      (parl_add_top_clk),
    .parl_add_rst_b    (parl_add_top_rst_b),
    .parl_add_in_a_i   (parl_add_top_in_a_i),
    .parl_add_in_b_i   (parl_add_top_in_b_i),
    .parl_add_out_o    (parl_add_s1)
);


/* Adding 3 and 4 */
parl_add_2  #(
          .OPERAND_WIDTH   (OPERAND_WIDTH)
          )
parl_add_pair_3_4_inst
(   .parl_add_clk      (parl_add_top_clk),
    .parl_add_rst_b    (parl_add_top_rst_b),
    .parl_add_in_a_i   (parl_add_top_in_c_i),
    .parl_add_in_b_i   (parl_add_top_in_d_i),
    .parl_add_out_o    (parl_add_s2)
);

/* Flopping 5th 1st time to match latency */
always_ff @( posedge(parl_add_top_clk) or negedge(parl_add_top_rst_b) ) 
   begin
    if (~parl_add_top_rst_b)
        parl_add_top_in_e_i_ff1 <= {(OPERAND_WIDTH){1'b0}};
    else
        parl_add_top_in_e_i_ff1 <= parl_add_top_in_e_i;
end


/* Adding interm 1_2 and 3_4 */
parl_add_2  #(  
          .OPERAND_WIDTH  (LEVEL1_S1_OUTPUT_WIDTH)
)
parl_add_interm_12_34_inst(
    .parl_add_clk     (parl_add_top_clk),
    .parl_add_rst_b   (parl_add_top_rst_b),
    .parl_add_in_a_i  (parl_add_s1),
    .parl_add_in_b_i  (parl_add_s2),
    .parl_add_out_o   (parl_add_s3)
);


/* Flopping 5th 2nd time to match latency */
always_ff @( posedge(parl_add_top_clk) or negedge(parl_add_top_rst_b) ) 
   begin
    if (~parl_add_top_rst_b)
        parl_add_top_in_e_i_ff2 <= {(OPERAND_WIDTH){1'b0}};
    else
       parl_add_top_in_e_i_ff2  <= parl_add_top_in_e_i_ff1;
end


/* Adding 1234 and 5 input */
parl_add_2 #(
        .OPERAND_WIDTH  (LEVEL2_S1_OUTPUT_WIDTH)
       )
parl_add_1234_5_inst(
    .parl_add_clk      (parl_add_top_clk),
    .parl_add_rst_b    (parl_add_top_rst_b),
    .parl_add_in_a_i   (parl_add_s3),
    .parl_add_in_b_i   ({2'b00,parl_add_top_in_e_i_ff2}),
    .parl_add_out_o    (parl_add_final_sig)
);

    
/* Final flopped output*/
always_ff @( posedge(parl_add_top_clk) or negedge(parl_add_top_rst_b) ) 
   begin
    if (~parl_add_top_rst_b)
        parl_add_top_out_o <= {(OUTPUT_WIDTH){1'b0}};
    else
        parl_add_top_out_o <= parl_add_final_sig;
end

endmodule
