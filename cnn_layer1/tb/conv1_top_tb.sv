//

module conv1_top_tb;

/*sram writes for weight regs params*/
localparam NUM_FILTER        = 6;
localparam SRAM_CNT_WIDTH    = 3;
localparam SRAM_DEPTH        = 5;
localparam SRAM_ADDRW        = 3;
localparam SRAM_WIDTH        = 40;

/*Line Buffer 4x8 counter*/
localparam LB1_CNT_ROW_WIDTH     = 3; //2^3
localparam LB1_CNT_COLUMN_WIDTH  = 2; //2^2

/*Line Buffer 4x8 params*/
localparam LB1_DATA_WIDTH    = 32;
localparam LB1_NUM_SHIFTS    = 32;
localparam LB1_NUM_TAPS      = 3; //final out-1 
localparam LB1_TAP_START     = 8;
localparam LB1_TAPS_STRIDE   = 8;
localparam LB1_NUM_PORT_OUT  = LB1_NUM_TAPS + 1 + 1;//1F + 1 shiftn out + num_taps

/*Interm flop params*/
localparam INTRM_F_NUM_INPUTS    = 5; //should match LB1_NUM_PORT_OUT
localparam INTRM_F_INPUT_WIDTH   = 32;
localparam INTRM_F_OUTPUT_WIDTH  = 2 * INTRM_F_INPUT_WIDTH;

/*Routing unit params*/
localparam ROUTE_NUM_FILT_ROWS           = 5;
localparam ROUTE_DATA_WIDTH              = 64;
localparam ROUTE_PXL_WIDTH               = 8;
localparam ROUTE_WEIGHT_WIDTH            = 8;
localparam ROUTE_NUM_PXL                 = ROUTE_DATA_WIDTH / ROUTE_PXL_WIDTH;
localparam ROUTE_NUM_WGHT_PER_FILT_ROW   = 5;
localparam ROUTE_FILT_INST               = 4; //No. of times a filter is operated on the row data
localparam ROUTE_NUM_FILT                = 6;
localparam ROUTE_NUM_PXL_PER_FILT        = 5;
localparam ROUTE_PXL_DATA_PER_FILT_STRD  = ROUTE_FILT_INST * ROUTE_NUM_FILT_ROWS * ROUTE_NUM_PXL_PER_FILT;
localparam ROUTE_WEIGHT_WIDTH_BYTE       = 40; //5 Bytes, i.e. 5x5 filter

/*conv1 compute top params*/
localparam COMPUTE_STRIDE_LENGTH         = 4;
localparam COMPUTE_NUM_FILT              = 6;
localparam COMPUTE_NUM_PIXELS            = 100;
localparam COMPUTE_PIXEL_WIDTH           = 8;
localparam COMPUTE_NUM_FILT_ROWS         = 5;
localparam COMPUTE_WEIGHT_WIDTH          = 8;
localparam COMPUTE_NUM_WEIGHTS           = 25;
localparam COMPUTE_OPERAND_WIDTH         = 8;
localparam COMPUTE_NUM_PXL_OUT_PER_FILT  = 4;
localparam COMPUTE_STRD_OUTPUT_WIDTH     = 22; //2*8+3+ parladd = 22
localparam COMPUTE_INPUT_WIDTH           = COMPUTE_STRD_OUTPUT_WIDTH;
localparam COMPUTE_NUM_INPUTS            = COMPUTE_STRIDE_LENGTH;
localparam COMPUTE_ACTV_OUTPUT_WIDTH     = COMPUTE_INPUT_WIDTH;

/*Line Buffer 1x7 counter*/
localparam LB2_CNT_WIDTH = 3;

/*Line Buffer 1x7 params*/
localparam LB2_DATA_WIDTH    = 88;
localparam LB2_NUM_SHIFTS    = 7;
localparam LB2_NUM_TAPS      = 0; //final out-1 
localparam LB2_TAP_START     = 7;
localparam LB2_TAPS_STRIDE   = 7;
localparam LB2_NUM_PORT_OUT  = LB2_NUM_TAPS + 1 + 1;//1F + 1 shiftn out + num_taps

/*conv1 pool params*/
localparam POOL_OPERAND_WDTH    = 22;
localparam POOL_NUM_PIXELS_BUF  = 4;
localparam POOL_NUM_PIXELS_POOL = 2;

/*FSM params*/

/*misc params*/
/*sr flop for compute*/

/*delay flops for compute*/
localparam DCOMPUTE_DATA_WIDTH    = 1;
localparam DCOMPUTE_NUM_SHIFTS    = 5;
localparam DCOMPUTE_NUM_TAPS      = 0; 
localparam DCOMPUTE_TAP_START     = 0;
localparam DCOMPUTE_TAPS_STRIDE   = 2;

/*delay flops for Pool*/
localparam DPOOL_DATA_WIDTH    = 1;
localparam DPOOL_NUM_SHIFTS    = 9; //line buff delay + 1 compute delay
localparam DPOOL_NUM_TAPS      = 0; 
localparam DPOOL_TAP_START     = 0;
localparam DPOOL_TAPS_STRIDE   = 0;


/*local params for File IOs*/
localparam IMG_FILE     = "../hex_files/mnist_image0.hex";
localparam IMG_ROW_WDTH = 32;
localparam IMG_NUM_ROWS = 256;


//------- weights loads -----------
localparam MEM_INIT_FILE1 = "../hex_files/w1_f1.hex";
localparam MEM_INIT_FILE2 = "../hex_files/w1_f2.hex";
localparam MEM_INIT_FILE3 = "../hex_files/w1_f3.hex";
localparam MEM_INIT_FILE4 = "../hex_files/w1_f4.hex";
localparam MEM_INIT_FILE5 = "../hex_files/w1_f5.hex";
localparam MEM_INIT_FILE6 = "../hex_files/w1_f6.hex";


initial begin
    $readmemh(MEM_INIT_FILE1, uut.wght_mem_inst[0].sram_weight_mems.mem_block);
    $readmemh(MEM_INIT_FILE1, uut.wght_mem_inst[1].sram_weight_mems.mem_block);
    $readmemh(MEM_INIT_FILE1, uut.wght_mem_inst[2].sram_weight_mems.mem_block);
    $readmemh(MEM_INIT_FILE1, uut.wght_mem_inst[3].sram_weight_mems.mem_block);

    $readmemh(MEM_INIT_FILE2, uut.wght_mem_inst[4].sram_weight_mems.mem_block);
    $readmemh(MEM_INIT_FILE2, uut.wght_mem_inst[5].sram_weight_mems.mem_block);
    $readmemh(MEM_INIT_FILE2, uut.wght_mem_inst[6].sram_weight_mems.mem_block);
    $readmemh(MEM_INIT_FILE2, uut.wght_mem_inst[7].sram_weight_mems.mem_block);

    $readmemh(MEM_INIT_FILE3, uut.wght_mem_inst[8].sram_weight_mems.mem_block);
    $readmemh(MEM_INIT_FILE3, uut.wght_mem_inst[9].sram_weight_mems.mem_block);
    $readmemh(MEM_INIT_FILE3, uut.wght_mem_inst[10].sram_weight_mems.mem_block);
    $readmemh(MEM_INIT_FILE3, uut.wght_mem_inst[11].sram_weight_mems.mem_block);

    $readmemh(MEM_INIT_FILE4, uut.wght_mem_inst[12].sram_weight_mems.mem_block);
    $readmemh(MEM_INIT_FILE4, uut.wght_mem_inst[13].sram_weight_mems.mem_block);
    $readmemh(MEM_INIT_FILE4, uut.wght_mem_inst[14].sram_weight_mems.mem_block);
    $readmemh(MEM_INIT_FILE4, uut.wght_mem_inst[15].sram_weight_mems.mem_block);

    $readmemh(MEM_INIT_FILE5, uut.wght_mem_inst[16].sram_weight_mems.mem_block);
    $readmemh(MEM_INIT_FILE5, uut.wght_mem_inst[17].sram_weight_mems.mem_block);
    $readmemh(MEM_INIT_FILE5, uut.wght_mem_inst[18].sram_weight_mems.mem_block);
    $readmemh(MEM_INIT_FILE5, uut.wght_mem_inst[19].sram_weight_mems.mem_block);

    $readmemh(MEM_INIT_FILE6, uut.wght_mem_inst[20].sram_weight_mems.mem_block);
    $readmemh(MEM_INIT_FILE6, uut.wght_mem_inst[21].sram_weight_mems.mem_block);
    $readmemh(MEM_INIT_FILE6, uut.wght_mem_inst[22].sram_weight_mems.mem_block);
    $readmemh(MEM_INIT_FILE6, uut.wght_mem_inst[23].sram_weight_mems.mem_block);
end

/*variables*/
integer i_tmp = 0;
integer img_reg_addr = 0;



//---- IO ----
reg                                                                         tb_conv1_top_clk;
reg                                                                         tb_conv1_top_rst_b;
reg                                                                         tb_conv1_top_data_valid;
reg  [LB1_DATA_WIDTH-1 : 0]                                                 tb_conv1_lb_in_i;
reg                                                                         tb_sof;
reg                                                                         tb_eof;
reg  [NUM_FILTER-1 : 0][POOL_NUM_PIXELS_POOL-1 :0][POOL_OPERAND_WDTH-1 :0]  tb_pool_out_o;
wire                                                                        tb_pool_valid_out_o;

//---- Instantiation ----//
conv1_top uut(
    .conv1_top_clk           (tb_conv1_top_clk),
    .conv1_top_rst_b         (tb_conv1_top_rst_b),
    .conv1_top_data_valid    (tb_conv1_top_data_valid),
    .conv1_lb_in_i           (tb_conv1_lb_in_i),
    .sof                     (tb_sof),
    .eof                     (tb_eof),
    .pool_out_o              (tb_pool_out_o),
    .pool_valid_out_o        (tb_pool_valid_out_o)
);


/***** Signals of TB *****/
logic [IMG_ROW_WDTH-1 : 0] img_reg[IMG_NUM_ROWS-1 : 0];


/**** Tasks ****/

//loading img data to tb reg
task load_img_to_reg();
    $readmemh(IMG_FILE, img_reg);
endtask


//passing 4pxl to line buffer //TODO: for loop implementation makes it easier??
task img_reg_out(input int addr, output logic [IMG_ROW_WDTH-1 : 0]pxl4);
    pxl4 = img_reg[addr];
    img_reg_addr++;
endtask
/**** Tasks END ****/




/*******************
* Test bench inputs
* *****************/
always #5 tb_conv1_top_clk = ~tb_conv1_top_clk;

initial begin
    tb_conv1_top_clk        = 0;
    tb_conv1_top_rst_b      = 0;
    tb_conv1_top_data_valid = 0;
    tb_conv1_lb_in_i        = '0;
    tb_sof                  = 0;
    tb_eof                  = 0;
    load_img_to_reg();
    $display("Simulation starting with initialized values\n");


//-------- Driving inputs -----------
    #20 tb_conv1_top_rst_b = 1;
    //#1 ;

    for (i_tmp = 0; i_tmp<256; i_tmp++) begin
        @(posedge(tb_conv1_top_clk))  begin
            if (img_reg_addr === '0)
                #11 tb_sof = 1;
            else
                #10 tb_sof = 0;

            tb_conv1_top_data_valid = 1;
            img_reg_out(img_reg_addr,tb_conv1_lb_in_i);
        end
    end

    #20 tb_conv1_top_data_valid = 0;
        tb_eof = 1;


    #3000 $finish;
end


endmodule
