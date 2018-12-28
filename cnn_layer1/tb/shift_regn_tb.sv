//

module shift_regn_tb;

parameter DATA_WIDTH = 32;
parameter NUM_SHIFTS = 32;
parameter NUM_TAPS = 4; //excluding la
parameter TAP_START = 0;
parameter TAPS_STRIDE = 8;
parameter NUM_TOTAL_OUT = 1 + NUM_TAPS;

reg                                           tb_sr_clk;
reg                                           tb_sr_rst_b;
reg                                           tb_sr_en;
reg  [DATA_WIDTH-1 : 0]                       tb_sr_data_i;
wire [NUM_TOTAL_OUT-1 : 0][DATA_WIDTH-1 : 0]  tb_sr_data_o; //2D array due to taps

//instantiation
shift_regn #(
DATA_WIDTH,
NUM_SHIFTS,
NUM_TAPS,
TAP_START,
TAPS_STRIDE,
NUM_TOTAL_OUT
)
uut(
.sr_clk     (tb_sr_clk),
.sr_rst_b   (tb_sr_rst_b),
.sr_en      (tb_sr_en),
.sr_data_i  (tb_sr_data_i),
.sr_data_o  (tb_sr_data_o)
);

initial begin
    tb_sr_clk     = 0;
    tb_sr_rst_b   = 0;
    tb_sr_en      = 0;
    tb_sr_data_i  = '0;

    $monitor("starting simulation");
end

always begin
    #5 tb_sr_clk = !tb_sr_clk;
end

initial begin
    #10 tb_sr_rst_b = 1;
    #10 tb_sr_en = 1;

    #10 tb_sr_data_i = 32'h1111_1111;
    #10 tb_sr_data_i = 32'h2222_2222;
    #10 tb_sr_data_i = 32'h3333_3333;
    #10 tb_sr_data_i = 32'h4444_4444;
    #10 tb_sr_data_i = 32'h5555_5555;
    #10 tb_sr_data_i = 32'h6666_6666;
    #10 tb_sr_data_i = 32'h7777_7777;
    #10 tb_sr_data_i = 32'h8888_8888;
    #10 tb_sr_data_i = 32'h9999_9999;
    #10 tb_sr_data_i = 32'haaaa_aaaa;
    #10 tb_sr_data_i = 32'hbbbb_bbbb;
    #10 tb_sr_data_i = 32'hcccc_cccc;
    #10 tb_sr_data_i = 32'hdddd_dddd;
    #10 tb_sr_data_i = 32'heeee_eeee;
    #10 tb_sr_data_i = 32'hffff_ffff;
    #10 tb_sr_data_i = 32'h0000_1111;
    #10 tb_sr_data_i = 32'h0000_2222;
    #10 tb_sr_data_i = 32'h0000_3333;
    #10 tb_sr_data_i = 32'h0000_4444;
    #10 tb_sr_data_i = 32'h0000_5555;
    #10 tb_sr_data_i = 32'h0000_6666;
    #10 tb_sr_data_i = 32'h0000_7777;
    #10

    #10 tb_sr_en = 0;
    #50
    #10 tb_sr_en = 1;

    #10 tb_sr_rst_b = 0;
    #50
    #10 tb_sr_rst_b = 1;

    #10 tb_sr_data_i = 32'h1111_1111;
    #10 tb_sr_data_i = 32'h2222_2222;
    #10 tb_sr_data_i = 32'h3333_3333;

    #50 $finish;
end


endmodule
