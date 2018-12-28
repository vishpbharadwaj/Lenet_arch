//

module srff_en (
    input logic  srff_clk,
    input logic  srff_rst_b,
    input logic  srff_en_i,
    input logic  srff_S_i,
    input logic  srff_R_i,
    output logic srff_Q_o,     
    output logic srff_Qb_o     
);

always_ff @(posedge srff_clk or negedge srff_rst_b) begin
    if (~srff_rst_b) begin
        srff_Q_o <= 1'b0;
        srff_Qb_o <= 1'b1;
    end
    else if (srff_en_i) begin
        case ({srff_S_i,srff_R_i})
            {1'b0,1'b0} : begin srff_Q_o <= srff_Q_o; srff_Qb_o <= srff_Qb_o; end
            {1'b0,1'b1} : begin srff_Q_o <= 1'b0; srff_Qb_o <= 1'b1; end
            {1'b1,1'b0} : begin srff_Q_o <= 1'b1; srff_Qb_o <= 1'b0; end
            default     : begin srff_Q_o <= 1'bX; srff_Qb_o <= 1'bX; end
        endcase
    end
end

endmodule
