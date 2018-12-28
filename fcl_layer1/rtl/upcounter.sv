//

module upcounter #(
                parameter CNT_WIDTH = 3
)(
    input logic                     cnt_clk,
    input logic                     cnt_rst_b,
    input logic                     cnt_en,
    input logic                     cnt_ld_en,
    input logic [CNT_WIDTH-1 : 0]   cnt_ld_val,
    input logic [CNT_WIDTH-1 : 0]   cnt_upto,
    output logic [CNT_WIDTH-1 : 0]  cnt_out,
    output logic                    cnt_done
);

//signals
logic [CNT_WIDTH-1 : 0] mux_lvl_1;
logic [CNT_WIDTH-1 : 0] mux_lvl_2;
logic [CNT_WIDTH-1 : 0] mux_lvl_3;
logic                   cnt_done_sig;

always_ff @( posedge(cnt_clk) or negedge(cnt_rst_b) ) begin
    if (~cnt_rst_b)
        cnt_out <= 0;
    else 
        cnt_out <= mux_lvl_3;
end

always_ff @( posedge(cnt_clk) or negedge(cnt_rst_b) ) begin
    if (~cnt_rst_b)
        cnt_done <= 0;
    else 
        cnt_done <= cnt_done_sig;
end

always_comb begin
    if (mux_lvl_3 == cnt_upto)
        cnt_done_sig = 1;
    else
        cnt_done_sig = 0;
end

always_comb begin
    if (cnt_done)
        mux_lvl_3 = {(CNT_WIDTH){1'b0}};
    else if (cnt_ld_en)
        mux_lvl_3 = cnt_ld_val;
    else if (cnt_en)
        mux_lvl_3 = cnt_out + 1'b1;
    else
        mux_lvl_3 = cnt_out;
end

endmodule
