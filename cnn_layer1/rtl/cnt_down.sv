// Author : Saurabh Patil

// Description : Unflopped cnt_done

module cnt_down #(
  parameter CNT_WIDTH = 4
)(
  input logic                   cnt_clk,
  input logic                   cnt_rstn,
  input logic                   cnt_en,
  input logic                   cnt_ld,
  input logic  [CNT_WIDTH-1 :0] cnt_ld_val,
  output logic [CNT_WIDTH-1 :0] cnt,
  output logic                  cnt_done
);  

logic [CNT_WIDTH-1 :0] cnt_nxt;

always_ff @(posedge cnt_clk or negedge cnt_rstn) begin
  if (~cnt_rstn)
    cnt <= {(CNT_WIDTH){1'b1}};
  else
    cnt <= cnt_nxt;
end

always_comb begin
  if (cnt_ld | cnt_done)
    cnt_nxt = cnt_ld_val;
  else if (cnt_en)
    cnt_nxt = cnt - 1'b1;
  else
    cnt_nxt = cnt;
end

assign cnt_done = cnt_en & (~|cnt);

endmodule
