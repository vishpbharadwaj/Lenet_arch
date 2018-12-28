//


module fcl1_cntrl_top #(
                    //.SRAM_CNT_WIDTH (SRAM_CNT_WIDTH),
                    parameter SRAM_CNT_WIDTH = 3


)(
    input logic                             fcl_ctrl_clk,
    input logic                             fcl_ctrl_rst_b,
   //input logic     sof_i,                          //Start of Frame
    input logic                             fcl1_wake_i, 
    //indicates fcl1 fsm comes out of reset state
    //input logic     data_valid_i,                   //data valid i.e. correct data is filling buffer
    //input logic     lb_pxl_cnt_done_i,              //pxl buffer load done
    //input logic     lb_pool_cnt_done_i,             //pool buffer load done
    //input logic     conv1_compute_out_valid_i,      //correct data at compute, start pool buff counter
    input logic                             fcl1_restart_i,
    // output logic    load_sram_reg_en_ctrl_o,        //to start writes to reg from sram
    output logic                            fcl_cntrl_top_sram_wr_en_o,                   //control to write to sram
    output logic                            fcl_cntrl_top_sram_rd_en_o,                    //control to read from sram,& to start writes to reg from sram
    output logic    [SRAM_CNT_WIDTH-1 :0]   fcl_cntrl_top_sram_addr_o
   // output logic    sram_cnt_en_ctrl_o,           //to start address incrementing
    //output logic    data_valid_buff_ctrl_o,         //to delay flops of compute
    //output logic    lb_pool_cnt_en_ctrl_o          //to start pool buffer load
    //output logic    conv1_pool_compute_valid_ctrl_o,//pool out data valid
    //output logic    reset_b_ctrl_o                  //reset to all modules
);

logic   sram_wr_en_o_sig; // en for add_gen_counter
logic   sram_rd_en_o_sig; //en for add_gen_counter
logic   fcl_cnt_en_ctrl_o_sig;
logic   fcl_done_i_sig; //indicates 120 filter read write completion
logic   mem_inc_done_i_sig; //indicates sram read/write done
logic   fcl_snt_ld_ctrl_o_sig;
//logic   load_counters_ctrl_o,           //load the values of counters

//up counter for address generation 
upcounter #(
        .CNT_WIDTH  (SRAM_CNT_WIDTH)
)
add_gen_counter(
    .cnt_clk       (fcl_ctrl_clk),
    .cnt_rst_b     (fcl_ctrl_rst_b),
    .cnt_en        ((sram_wr_en_o_sig | sram_rd_en_o_sig)),
    .cnt_ld_en     (1'b0),
    .cnt_ld_val    (3'b000),
    .cnt_upto      (3'b100), //till 4
    .cnt_out       (fcl_cntrl_top_sram_addr_o),
    .cnt_done      (mem_inc_done_i_sig)
);

cnt_down #(
        .CNT_WIDTH  (7)
)
sram_write_counter(
    .cnt_clk     (fcl_ctrl_clk),
    .cnt_rstn    (fcl_ctrl_rst_b),
    .cnt_en      (fcl_cnt_en_ctrl_o_sig),
    .cnt_ld      (fcl_snt_ld_ctrl_o_sig),
    .cnt_ld_val  (7'd120),
    .cnt         (),
    .cnt_done    (fcl_done_i_sig)
);



fsm_layer1  #(
)
i_fsm_layr1(
     .fsm_clk                       (fcl_ctrl_clk),
     .fsm_rst_b                     (fcl_ctrl_rst_b),
     .fcl1_wake_i                   (fcl1_wake_i),
     //.data_valid_i               (),
     .fcl_cnt_en_ctrl_o             (fcl_cnt_en_ctrl_o_sig),
     //.conv1_compute_out_valid_i   (),
     .fcl_done_i                    (fcl_done_i_sig),
     .mem_inc_done_i                (mem_inc_done_i_sig),
     .restart_i                     (fcl1_restart_i),
     .sram_wr_en_ctrl_o             (sram_wr_en_o_sig),
     .sram_rd_en_ctrl_o             (sram_rd_en_o_sig),
     .fcl_snt_ld_ctrl_o             (fcl_snt_ld_ctrl_o_sig)
     //.sram_cnt_en_ctrl_o            (fcl_cnt_en_ctrl_o_sig),
     //data_valid_buff_ctrl_o       ()
);

assign fcl_cntrl_top_sram_wr_en_o = sram_wr_en_o_sig ;
assign fcl_cntrl_top_sram_rd_en_o = sram_rd_en_o_sig ;

endmodule
