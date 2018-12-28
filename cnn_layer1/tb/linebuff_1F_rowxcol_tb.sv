//


module linebuff_1F_rowxcol_tb;


localparam DATA_WIDTH    = 2;
localparam NUM_SHIFTS    = 32;
localparam NUM_TAPS      = 3; //final out-1 
localparam TAP_START     = 8;
localparam TAPS_STRIDE   = 8;
localparam NUM_PORT_OUT  = NUM_TAPS + 1 + 1;//1F + 1 shiftn out + num_taps

reg                                         tb_lb_clk;
reg                                         tb_lb_rst_b;
reg                                         tb_lb_en;
reg  [DATA_WIDTH-1 : 0]                     tb_lb_in_i;
wire [NUM_PORT_OUT-1 : 0][DATA_WIDTH-1 : 0] tb_lb_out_o;



linebuff_1F_rowxcol #(
                .DATA_WIDTH      (DATA_WIDTH),
                .NUM_SHIFTS      (NUM_SHIFTS),
                .NUM_TAPS        (NUM_TAPS),
                .TAP_START       (TAP_START), 
                .TAPS_STRIDE     (TAPS_STRIDE),
                .NUM_PORT_OUT    (NUM_PORT_OUT)
)
uut(
    .lb_clk      (tb_lb_clk),
    .lb_rst_b    (tb_lb_rst_b),
    .lb_en       (tb_lb_en),
    .lb_in_i     (tb_lb_in_i),
    .lb_out_o    (tb_lb_out_o)
);

always #5 tb_lb_clk = ~tb_lb_clk;

initial begin
    tb_lb_clk = 0;
    tb_lb_rst_b = 0;
    tb_lb_en = 0;
    tb_lb_in_i = '0;

    
    #10 tb_lb_rst_b = 1;
    #10 tb_lb_en = 1;

    #10 tb_lb_in_i = 2'b11;
    #10 tb_lb_in_i = 2'b01;
    #10 tb_lb_in_i = 2'b10;
    #10 tb_lb_in_i = 2'b00;
    #10 tb_lb_in_i = 2'b10;
    #10 tb_lb_in_i = 2'b01;
    #10 tb_lb_in_i = 2'b10;
    #10 tb_lb_in_i = 2'b01;
    #10 tb_lb_in_i = 2'b10;
    #10 tb_lb_in_i = 2'b01;
    #10 tb_lb_in_i = 2'b10;
    #10 tb_lb_in_i = 2'b11;
    #10 tb_lb_in_i = 2'b10;
    #10 tb_lb_in_i = 2'b01;
    #10 tb_lb_in_i = 2'b10;
    #10 tb_lb_in_i = 2'b01;
    #10 tb_lb_in_i = 2'b11;
    #10 tb_lb_in_i = 2'b00;
    #10 tb_lb_in_i = 2'b00;
    #10 tb_lb_in_i = 2'b11;
    #10 tb_lb_in_i = 2'b10;

    #400 $finish;

end

endmodule
