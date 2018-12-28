//

module conv1_top #(
                    parameter NUM_STRIDE_LEN    = 4,
                    parameter CNT_WIDTH         = 3,
            /*sram writes for weight regs params*/
                    parameter NUM_FILTER        = 6,
                    parameter SRAM_CNT_WIDTH    = 5,
                    parameter SRAM_DEPTH        = 5,
                    parameter SRAM_ADDRW        = 5, //for 24 values
                    parameter SRAM_WIDTH        = 40,

            /*Line Buffer 4x8 counter*/
                    parameter LB1_CNT_ROW_WIDTH     = 3, //2^3
                    parameter LB1_CNT_COLUMN_WIDTH  = 2, //2^2

            /*Line Buffer 4x8 params*/
                    parameter LB1_DATA_WIDTH    = 32,
                    parameter LB1_NUM_SHIFTS    = 32,
                    parameter LB1_NUM_TAPS      = 3, //final out-1 
                    parameter LB1_TAP_START     = 8,
                    parameter LB1_TAPS_STRIDE   = 8,
                    parameter LB1_NUM_PORT_OUT  = LB1_NUM_TAPS + 1 + 1,//1F + 1 shiftn out + num_taps

            /*Interm flop params*/
                    parameter INTRM_F_NUM_INPUTS    = 5, //should match LB1_NUM_PORT_OUT
                    parameter INTRM_F_INPUT_WIDTH   = 32,
                    parameter INTRM_F_OUTPUT_WIDTH  = 2 * INTRM_F_INPUT_WIDTH,

            /*Routing unit params*/
                    parameter ROUTE_NUM_FILT_ROWS           = 5,
                    parameter ROUTE_DATA_WIDTH              = 64,
                    parameter ROUTE_PXL_WIDTH               = 8,
                    parameter ROUTE_WEIGHT_WIDTH            = 8,
                    parameter ROUTE_NUM_PXL                 = ROUTE_DATA_WIDTH / ROUTE_PXL_WIDTH,
                    parameter ROUTE_NUM_WGHT_PER_FILT_ROW   = 5,
                    parameter ROUTE_FILT_INST               = NUM_STRIDE_LEN, //No. of times a filter is operated on the row data
                    parameter ROUTE_NUM_FILT                = 6,
                    parameter ROUTE_NUM_PXL_PER_FILT        = 5,
                    parameter ROUTE_PXL_DATA_PER_FILT_STRD  = ROUTE_FILT_INST * ROUTE_NUM_FILT_ROWS * ROUTE_NUM_PXL_PER_FILT,
                    parameter ROUTE_WEIGHT_WIDTH_BYTE       = 40, //5 Bytes, i.e. 5x5 filter

            /*conv1 compute top params*/
                    parameter COMPUTE_STRIDE_LENGTH         = 4,
                    parameter COMPUTE_NUM_FILT              = 6,
                    parameter COMPUTE_NUM_PIXELS            = 100,
                    parameter COMPUTE_PIXEL_WIDTH           = 8,
                    parameter COMPUTE_NUM_FILT_ROWS         = 5,
                    parameter COMPUTE_WEIGHT_WIDTH          = 8,
                    parameter COMPUTE_NUM_WEIGHTS           = 25,
                    parameter COMPUTE_OPERAND_WIDTH         = 8,
                    parameter COMPUTE_NUM_PXL_OUT_PER_FILT  = 4,
                    parameter COMPUTE_STRD_OUTPUT_WIDTH     = 22, //2*8+3+ parladd = 22
                    parameter COMPUTE_INPUT_WIDTH           = COMPUTE_STRD_OUTPUT_WIDTH,
                    parameter COMPUTE_NUM_INPUTS            = COMPUTE_STRIDE_LENGTH,
                    parameter COMPUTE_ACTV_OUTPUT_WIDTH     = COMPUTE_INPUT_WIDTH,

            /*Line Buffer 1x7 counter*/
                    parameter LB2_CNT_WIDTH = 3,

            /*Line Buffer 1x7 params*/
                    parameter LB2_DATA_WIDTH    = 88,
                    parameter LB2_NUM_SHIFTS    = 7,
                    parameter LB2_NUM_TAPS      = 0, //final out-1 
                    parameter LB2_TAP_START     = 7,
                    parameter LB2_TAPS_STRIDE   = 7,
                    parameter LB2_NUM_PORT_OUT  = LB2_NUM_TAPS + 1 + 1,//1F + 1 shiftn out + num_taps

            /*conv1 pool params*/
  		            parameter POOL_OPERAND_WDTH    = 22,
		            parameter POOL_NUM_PIXELS_BUF  = 4,
		            parameter POOL_NUM_PIXELS_POOL = 2,

            /*FSM params*/

            /*misc params*/
                    /*sr flop for compute*/

                    /*delay flops for compute*/
                    parameter DCOMPUTE_DATA_WIDTH    = 1,
                    parameter DCOMPUTE_NUM_SHIFTS    = 5,
                    parameter DCOMPUTE_NUM_TAPS      = 0, 
                    parameter DCOMPUTE_TAP_START     = 0,
                    parameter DCOMPUTE_TAPS_STRIDE   = 2,

                    /*delay flops for Pool*/
                    parameter DPOOL_DATA_WIDTH    = 1,
                    parameter DPOOL_NUM_SHIFTS    = 9, //line buff delay + 1 compute delay
                    parameter DPOOL_NUM_TAPS      = 0, 
                    parameter DPOOL_TAP_START     = 0,
                    parameter DPOOL_TAPS_STRIDE   = 0
)(
    input logic                                                                         conv1_top_clk,
    input logic                                                                         conv1_top_rst_b,
    input logic                                                                         conv1_top_data_valid,
    input logic [LB1_DATA_WIDTH-1 : 0]                                                  conv1_lb_in_i,
    input logic                                                                         sof,
    input logic                                                                         eof,
    output logic [NUM_FILTER-1 : 0][POOL_NUM_PIXELS_POOL-1 :0][POOL_OPERAND_WDTH-1 :0]  pool_out_o,
    output logic                                                                        pool_valid_out_o
);
//---------- Local Params ---------------


//---------- SRAM writes signals ----------
logic [SRAM_CNT_WIDTH-1 : 0]                                sram_cnt_out_addr_sig; //count out acts as address
logic [CNT_WIDTH-1 : 0]                                     cnt_out_addr_sig; //count out acts as address
logic [NUM_FILTER*NUM_STRIDE_LEN-1 : 0][SRAM_WIDTH-1 : 0]   sram_data_out_sig; //ram out i.e. 40 bits for each filter
logic [SRAM_WIDTH-1 : 0]                                    conv1_wght_reg [NUM_FILTER*NUM_STRIDE_LEN-1 : 0][SRAM_DEPTH-1 : 0];
logic                                                       sram_cnt_done_sig;


//--------- FSM control Signals ----------
logic lb_pxl_cnt_en_ctrl_o_sig;
logic lb_pxl_cnt_dlyd_en_ctrl_o_sig;
logic lb_pxl_cnt_done_i_sig;
logic lb_pool_cnt_en_ctrl_o_sig;
logic conv1_compute_out_valid_i_sig;
//logic lb_pool_cnt_done_i_sig;
logic load_sram_reg_en_ctrl_o_sig;


//--------- Line buffer 1 i.e. PXL buff signals ---------
logic  [LB1_NUM_PORT_OUT-1 : 0][LB1_DATA_WIDTH-1 : 0] lb_pxl_out_o_sig;
logic  [LB1_NUM_PORT_OUT-1 : 0][LB1_DATA_WIDTH-1 : 0] lb_pxl_out_o_rvrs_sig; //reversing the index as it is in opp direction


//-------- Interm flop signals ---------------------
logic [INTRM_F_NUM_INPUTS-1 : 0][INTRM_F_OUTPUT_WIDTH-1 : 0] intrm_flop_out_o_sig;

//-------- Routing unit signals -------------------
logic [ROUTE_NUM_FILT*NUM_STRIDE_LEN-1 : 0][ROUTE_NUM_FILT_ROWS-1 : 0][ROUTE_WEIGHT_WIDTH_BYTE-1 : 0]                                   filt_wght_matx_i_sig; // i.e. 4 x 5*5
logic [NUM_FILTER-1 : 0][ROUTE_PXL_DATA_PER_FILT_STRD-1 : 0][ROUTE_PXL_WIDTH-1 : 0]                                                     pxl_data_out_o_sig; //pixel data 100x8 i.e including 4 inst of data
logic [ROUTE_NUM_FILT-1 : 0][NUM_STRIDE_LEN-1 : 0][ROUTE_NUM_WGHT_PER_FILT_ROW * ROUTE_NUM_FILT_ROWS-1 : 0][ROUTE_WEIGHT_WIDTH-1 : 0]   filt_wght_matx_o_sig; //weight data 6x5*5


//-------- Compute unit signals -------------------
logic [COMPUTE_NUM_FILT-1 : 0][COMPUTE_NUM_PXL_OUT_PER_FILT-1 : 0][COMPUTE_ACTV_OUTPUT_WIDTH-1 : 0] conv1_out_o_sig;


//-------- Line buffer 2 i.e. Pool buff signals ---------
logic [NUM_FILTER-1 : 0][LB2_NUM_PORT_OUT-1 :0] [LB2_DATA_WIDTH-1 :0]lb_pool_out_o_sig;

//------- conv1 pool block -------------
logic [NUM_FILTER-1 : 0][POOL_NUM_PIXELS_BUF-1 :0] [POOL_OPERAND_WDTH-1 :0]conv1_pool_a_i_sig;
logic [NUM_FILTER-1 : 0][POOL_NUM_PIXELS_BUF-1 :0] [POOL_OPERAND_WDTH-1 :0]conv1_pool_b_i_sig;

//------- SR FF signals ---------
logic sr_Q;
logic data_valid_buff;


/***************************************
* SRAM writes for weights Instantiation
***************************************/
//as the regs needs to be visible to compute blocks,
//the logic needs to be in top file.
//Do not use sram_to_reg_write instantiation


//up counter for address generation 
upcounter #(
        .CNT_WIDTH  (CNT_WIDTH)
)
add_gen_counter(
    .cnt_clk       (conv1_top_clk),
    .cnt_rst_b     (conv1_top_rst_b),
    .cnt_en        (load_sram_reg_en_ctrl_o_sig),
    .cnt_ld_en     (1'b0),
    .cnt_ld_val    (3'b000),
    .cnt_upto      (3'b101), //till 5
    .cnt_out       (cnt_out_addr_sig),
    .cnt_done      (sram_cnt_done_sig)
);

assign sram_cnt_out_addr_sig = {2'b00,cnt_out_addr_sig};

//6 SRAMs of depth 5 for 6 filter
genvar sram_i;
generate
    for (sram_i=0; sram_i<NUM_FILTER*NUM_STRIDE_LEN; sram_i++) begin : wght_mem_inst
        mem_block #(
                    .RAM_DEPTH  (SRAM_DEPTH),
                    .RAM_ADDRW  (SRAM_ADDRW),
                    .RAM_WIDTH  (SRAM_WIDTH)
        )
        sram_weight_mems(
            .clk_i           (conv1_top_clk),
            .ram_wren_i      (1'b0),
            .ram_wr_addr_i   (5'b00000),
            .ram_wr_data_i   (40'h00_0000_0000),
            .ram_rd_addr_i   (sram_cnt_out_addr_sig),
            .ram_rd_data_o   (sram_data_out_sig[sram_i])
        );
    end
endgenerate

//writing to regs
//genvar sram_j;
//generate
//    for (sram_j=0; sram_j<NUM_FILTER; sram_j++) begin
//        always_latch begin
//            if (load_sram_reg_en_ctrl_o_sig)
//                conv1_wght_reg[sram_j][sram_cnt_out_addr_sig] <= sram_data_out_sig[sram_j];
//        end
//    end
//endgenerate


genvar sram_j;
generate
    for (sram_j=0; sram_j<NUM_FILTER*NUM_STRIDE_LEN; sram_j++) begin
        always_ff @( posedge(conv1_top_clk) or negedge(conv1_top_rst_b) ) begin
            if (~conv1_top_rst_b)
                conv1_wght_reg[sram_j][sram_cnt_out_addr_sig] <= {(SRAM_WIDTH){1'b0}};

            else if (load_sram_reg_en_ctrl_o_sig)
                conv1_wght_reg[sram_j][sram_cnt_out_addr_sig] <= sram_data_out_sig[sram_j];
        end
    end
endgenerate

/**************************************
* SRAM writes for weight regs Ends
***************************************/



/**************************************
* Line Buffer 4x8 counter Instantiation
**************************************/

//-------- Delayed enable ---------------
dff_en #(
        .DATA_WIDTH (1'b1)
)
lb_pxl_delay_inst(
    .dff_clk     (conv1_top_clk),
    .dff_rst_b   (conv1_top_rst_b),
    .dff_en      (conv1_top_data_valid),
    .dff_in_i    (lb_pxl_cnt_en_ctrl_o_sig),
    .dff_out_o   (lb_pxl_cnt_dlyd_en_ctrl_o_sig)
);



lb1_pxl_cnt #(
            .CNT_ROW_WIDTH       (LB1_CNT_ROW_WIDTH),
            .CNT_COLUMN_WIDTH    (LB1_CNT_COLUMN_WIDTH)
)
linebuff_pxl_counter_inst(
    .cnt_clk     (conv1_top_clk),
    .cnt_rst_b   (conv1_top_rst_b),
    .cnt_en      (lb_pxl_cnt_dlyd_en_ctrl_o_sig),
    .cnt_done_o  (lb_pxl_cnt_done_i_sig)
);
/**************************************
* Line Buffer 4x8 counter Ends
**************************************/



/********************************
* Line Buffer 4x8 Instantiation
********************************/
linebuff_1F_rowxcol #(
                    .DATA_WIDTH      (LB1_DATA_WIDTH),
                    .NUM_SHIFTS      (LB1_NUM_SHIFTS),
                    .NUM_TAPS        (LB1_NUM_TAPS),
                    .TAP_START       (LB1_TAP_START),
                    .TAPS_STRIDE     (LB1_TAPS_STRIDE)
)
linebuff_1F_4x32_inst(
    .lb_clk      (conv1_top_clk),
    .lb_rst_b    (conv1_top_rst_b),
    .lb_en       (conv1_top_data_valid),
    .lb_in_i     (conv1_lb_in_i),
    .lb_out_o    (lb_pxl_out_o_sig)
);
/********************************
* Line Buffer 4x8 Ends
********************************/

//---- Reversing logic ----
genvar rvrs_i;
generate
    for (rvrs_i=0; rvrs_i<LB1_NUM_PORT_OUT; rvrs_i++) begin
        assign lb_pxl_out_o_rvrs_sig[rvrs_i] = lb_pxl_out_o_sig[LB1_NUM_PORT_OUT-1-rvrs_i];
    end
endgenerate



/********************************
* Interim Flop Instantiation
********************************/
conv1_intrm_flop #(
                .NUM_INPUTS  (INTRM_F_NUM_INPUTS),
                .INPUT_WIDTH (INTRM_F_INPUT_WIDTH)
)
conv1_intrm_flop_inst(
    .intrm_flop_clk      (conv1_top_clk),
    .intrm_flop_rst_b    (conv1_top_rst_b),
    .intrm_flop_en_i     (conv1_top_data_valid),
    .intrm_flop_in_i     (lb_pxl_out_o_rvrs_sig),
    .intrm_flop_out_o    (intrm_flop_out_o_sig)
);
/********************************
* Interim Flop Ends
********************************/



/*****************************************
* Conv1 pxl & weight routing Instantiation
*****************************************/

//-------- converting unpacked array conv1_wght_reg to packed filt_wght_matx_i_sig-----------
genvar wght_i, depth_j;
generate
    for (wght_i=0; wght_i<ROUTE_NUM_FILT*NUM_STRIDE_LEN; wght_i++) begin
        for (depth_j=0; depth_j<ROUTE_NUM_FILT_ROWS; depth_j++) begin
            assign filt_wght_matx_i_sig[wght_i][depth_j] = conv1_wght_reg[wght_i][depth_j];
        end
    end
endgenerate
//-------------------------------------------------------------------------------------------


conv1_wght_pxl_routing #(
                    .NUM_FILT_ROWS           (ROUTE_NUM_FILT_ROWS),         
                    .DATA_WIDTH              (ROUTE_DATA_WIDTH),          
                    .PXL_WIDTH               (ROUTE_PXL_WIDTH),       
                    .WEIGHT_WIDTH            (ROUTE_WEIGHT_WIDTH),
                    .NUM_PXL                 (ROUTE_NUM_PXL),
                    .NUM_WGHT_PER_FILT_ROW   (ROUTE_NUM_WGHT_PER_FILT_ROW),
                    .FILT_INST               (ROUTE_FILT_INST),           
                    .NUM_FILT                (ROUTE_NUM_FILT),   
                    .NUM_PXL_PER_FILT        (ROUTE_NUM_PXL_PER_FILT),
                    .PXL_DATA_PER_FILT_STRD  (ROUTE_PXL_DATA_PER_FILT_STRD),
                    .WEIGHT_WIDTH_BYTE       (ROUTE_WEIGHT_WIDTH_BYTE)
)
conv1_wght_pxl_routing_inst(
    .intm_row_data_i     (intrm_flop_out_o_sig),
    .filt_wght_matx_i    (filt_wght_matx_i_sig),
    .pxl_data_out_o      (pxl_data_out_o_sig), 
    .filt_wght_matx_o    (filt_wght_matx_o_sig)
);
/*****************************************
* Conv1 pxl & weight routing Ends
*****************************************/



/********************************
* Conv1 Compute top Instantiation
********************************/
conv1_compute_top #(
                .STRIDE_LENGTH           (COMPUTE_STRIDE_LENGTH),       
                .NUM_FILT                (COMPUTE_NUM_FILT),      
                .NUM_PIXELS              (COMPUTE_NUM_PIXELS),      
                .PIXEL_WIDTH             (COMPUTE_PIXEL_WIDTH),    
                .NUM_FILT_ROWS           (COMPUTE_NUM_FILT_ROWS),     
                .WEIGHT_WIDTH            (COMPUTE_WEIGHT_WIDTH),      
                .NUM_WEIGHTS             (COMPUTE_NUM_WEIGHTS),    
                .OPERAND_WIDTH           (COMPUTE_OPERAND_WIDTH),
                .NUM_PXL_OUT_PER_FILT    (COMPUTE_NUM_PXL_OUT_PER_FILT),
                .STRD_OUTPUT_WIDTH       (COMPUTE_STRD_OUTPUT_WIDTH),   
                .INPUT_WIDTH             (COMPUTE_INPUT_WIDTH),       
                .NUM_INPUTS              (COMPUTE_NUM_INPUTS), 
                .ACTV_OUTPUT_WIDTH       (COMPUTE_ACTV_OUTPUT_WIDTH) 
)
conv1_compute_top_inst(
    .conv1_top_clk   (conv1_top_clk),
    .conv1_top_rst_b (conv1_top_rst_b),
    .conv1_pxls_i    (pxl_data_out_o_sig),
    .conv1_wghts_i   (filt_wght_matx_o_sig),
    .conv1_out_o     (conv1_out_o_sig)
);
/********************************
* Conv1 compute top Ends
********************************/



/**************************************
* LineBuffer 1x7 counter Instantiation
**************************************/
//cnt_down #(
//        .CNT_WIDTH (LB2_CNT_WIDTH)
//)
//linebuff2_pool_count_inst (
//    .cnt_clk     (conv1_top_clk),
//    .cnt_rstn    (conv1_top_rst_b),
//    .cnt_en      (lb_pool_cnt_en_ctrl_o_sig),
//    .cnt_ld      (),
//    .cnt_ld_val  (),
//    .cnt         (),
//    .cnt_done    ()
//);
/**************************************
* LineBuffer 1x7 counter Ends
**************************************/



/********************************
* LineBuffer 1x7 Instantiation
********************************/
linebuff_pool #(
                    .NUM_FILT        (NUM_FILTER),
                    .DATA_WIDTH      (LB2_DATA_WIDTH),
                    .NUM_SHIFTS      (LB2_NUM_SHIFTS),
                    .NUM_TAPS        (LB2_NUM_TAPS),
                    .TAP_START       (LB2_TAP_START),
                    .TAPS_STRIDE     (LB2_TAPS_STRIDE)
)
linebuff_1F_1x7_inst(
    .lb_pool_clk      (conv1_top_clk),
    .lb_pool_rst_b    (conv1_top_rst_b),
    .lb_pool_en       (conv1_compute_out_valid_i_sig),
    .lb_pool_in_i     (conv1_out_o_sig),
    .lb_pool_out_o    (lb_pool_out_o_sig)
);
/********************************
* LineBuffer 1x7 ends Ends
********************************/



/********************************
* Conv1 max pool Instantiation
********************************/

//--- refactoring lb_pool_out_o_sig from 2x88 to 4x22 for pooling
genvar pool_i, pool_k;
generate
    for (pool_k=0; pool_k<NUM_FILTER; pool_k++) begin
        for (pool_i=0; pool_i<POOL_NUM_PIXELS_BUF; pool_i++) begin
            assign conv1_pool_a_i_sig[pool_k][pool_i][POOL_OPERAND_WDTH-1 :0] = lb_pool_out_o_sig[pool_k][0][(POOL_OPERAND_WDTH * pool_i) + POOL_OPERAND_WDTH -1 : (POOL_OPERAND_WDTH * pool_i)];
        end
    end
endgenerate

genvar pool_j,pool_l;
generate
    for (pool_l=0; pool_l<NUM_FILTER; pool_l++) begin
        for (pool_j=0; pool_j<POOL_NUM_PIXELS_BUF; pool_j++) begin
            assign conv1_pool_b_i_sig[pool_l][pool_j][POOL_OPERAND_WDTH-1 :0] = lb_pool_out_o_sig[pool_l][1][(POOL_OPERAND_WDTH * pool_j) + POOL_OPERAND_WDTH -1 : (POOL_OPERAND_WDTH * pool_j)];
        end
    end
endgenerate

conv1_max_pool_top #(
                .NUM_FILT        (NUM_FILTER),
                .OPERAND_WDTH    (POOL_OPERAND_WDTH),
                .NUM_PIXELS_BUF  (POOL_NUM_PIXELS_BUF),
                .NUM_PIXELS_POOL (POOL_NUM_PIXELS_POOL)
)
conv1_max_pool_inst(
    .conv1_pool_clk      (conv1_top_clk),
    .conv1_pool_rst_b    (conv1_top_rst_b),
    .conv1_pool_a_i      (conv1_pool_a_i_sig),
    .conv1_pool_b_i      (conv1_pool_b_i_sig),
    .conv1_max_pool_o    (pool_out_o)
);
/********************************
* Conv1 max pool Ends
********************************/



/********************************
* FSM Instantiation
********************************/
fsm_layer1 fsm_layer1_inst(
    .fsm_clk                         (conv1_top_clk),
    .fsm_rst_b                       (conv1_top_rst_b),
    .sof_i                           (sof),
    .data_valid_i                    (conv1_top_data_valid),
    .sram_cnt_done_i                 (sram_cnt_done_sig),
    //.lb_pxl_cnt_done_i               (lb_pxl_cnt_done_i_sig), //TODO: not required
    //.lb_pool_cnt_done_i              (lb_pool_cnt_done_i_sig), //TODO: not required
    .conv1_compute_out_valid_i       (conv1_compute_out_valid_i_sig),
    .load_counters_ctrl_o            (),
    .load_sram_reg_en_ctrl_o         (load_sram_reg_en_ctrl_o_sig),
    .lb_pxl_cnt_en_ctrl_o            (lb_pxl_cnt_en_ctrl_o_sig),
    //.data_valid_buff_ctrl_o          (), //TODO: not required
    .lb_pool_cnt_en_ctrl_o           (lb_pool_cnt_en_ctrl_o_sig)
    //.conv1_pool_compute_valid_ctrl_o (), //TODO: not required
);
/********************************
* FSM Ends
********************************/



/********************************
* SR for Compute Instantiation
********************************/
srff_en srff_compute(
    .srff_clk    (conv1_top_clk),
    .srff_rst_b  (conv1_top_rst_b),
    .srff_en_i   (1'b1),
    .srff_S_i    (lb_pxl_cnt_done_i_sig),
    .srff_R_i    (eof),
    .srff_Q_o    (sr_Q), 
    .srff_Qb_o   ()
);

//---- Anding with data_valid
assign data_valid_buff = sr_Q & conv1_top_data_valid;

/********************************
* SR for Compute Ends
********************************/



/********************************
* Delay for compute Instantiation
********************************/
shift_regn #(
            .DATA_WIDTH  (DCOMPUTE_DATA_WIDTH),
            .NUM_SHIFTS  (DCOMPUTE_NUM_SHIFTS),
            .NUM_TAPS    (DCOMPUTE_NUM_TAPS),
            .TAP_START   (DCOMPUTE_TAP_START),
            .TAPS_STRIDE (DCOMPUTE_TAPS_STRIDE)
)
conv1_compute_delay_inst(
    .sr_clk      (conv1_top_clk),
    .sr_rst_b    (conv1_top_rst_b),
    .sr_en       (1'b1),
    .sr_data_i   (data_valid_buff),
    .sr_data_o   (conv1_compute_out_valid_i_sig)
);
/********************************
* Delay for compute Ends
********************************/


/********************************
* Delay for Pool Instantiation
********************************/
shift_regn #(
            .DATA_WIDTH  (DPOOL_DATA_WIDTH),
            .NUM_SHIFTS  (DPOOL_NUM_SHIFTS),
            .NUM_TAPS    (DPOOL_NUM_TAPS),
            .TAP_START   (DPOOL_TAP_START),
            .TAPS_STRIDE (DPOOL_TAPS_STRIDE)
)
conv1_pool_delay_inst(
    .sr_clk      (conv1_top_clk),
    .sr_rst_b    (conv1_top_rst_b),
    .sr_en       (1'b1),
    .sr_data_i   (conv1_compute_out_valid_i_sig),
    .sr_data_o   (pool_valid_out_o)
);
/********************************
* Delay for Pool Ends
********************************/


endmodule
