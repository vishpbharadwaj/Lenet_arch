//Line buffer fill counter for pixel data


module lb1_pxl_cnt #(
                    parameter CNT_ROW_WIDTH     = 3, //2^3
                    parameter CNT_COLUMN_WIDTH  = 2 //2^2
)(
   input logic  cnt_clk,
   input logic  cnt_rst_b,
   input logic  cnt_en,
   output logic cnt_done_o
);

//signals
logic cnt3_done_sig;
logic [CNT_ROW_WIDTH-1 :0] cnt3_row_cnt;
logic [CNT_COLUMN_WIDTH -1 :0] cnt2_col_cnt;

/*** Row counter ***/
cnt_down #(
        .CNT_WIDTH  (CNT_ROW_WIDTH)
)
lb_pxl_row_cnt_inst(
    .cnt_clk     (cnt_clk),
    .cnt_rstn    (cnt_rst_b),
    .cnt_en      (cnt_en),
    .cnt_ld      (1'b0),
    .cnt_ld_val  ({(CNT_ROW_WIDTH){1'b1}}),
    .cnt         (cnt3_row_cnt),
    .cnt_done    (cnt3_done_sig)
);
/******/

/*** Column counter ***/
cnt_down #(
        .CNT_WIDTH  (CNT_COLUMN_WIDTH)
)
lb_pxl_col_cnt_inst(
    .cnt_clk     (cnt_clk),
    .cnt_rstn    (cnt_rst_b),
    .cnt_en      (cnt3_done_sig),
    .cnt_ld      (1'b0),
    .cnt_ld_val  ({(CNT_COLUMN_WIDTH){1'b1}}),
    .cnt         (cnt2_col_cnt),
    .cnt_done    (cnt_done_o)
);
/******/

endmodule
