//


module fsm_layer1 #(

)(
    input   logic   fsm_clk,
    input   logic   fsm_rst_b,
    input   logic   fcl1_wake_i,                     //indicates fcl1 fsm comes out of reset state
    //input logic     data_valid_i,                   //data valid i.e. correct data is filling buffer
    output  logic   fcl_cnt_en_ctrl_o, 
    input   logic   fcl_done_i,                     //indicates 120 filter read write completion
    input   logic   mem_inc_done_i,                 // indicates 5 frames written or read
    input   logic   restart_i,
    output  logic   sram_wr_en_ctrl_o,                   //control to write to sram
    output  logic   sram_rd_en_ctrl_o,                    //control to read from sram,& to start writes to reg from sram  
   // output logic    sram_cnt_en_ctrl_o,           //to start address incrementing
    //output logic    data_valid_buff_ctrl_o,         //to delay flops of compute
    //output logic    conv1_pool_compute_valid_ctrl_o,//pool out data valid
    //output logic    reset_b_ctrl_o                  //reset to all modules
    output logic    fcl_snt_ld_ctrl_o
);


enum logic[3:0] {
            RESET               = 4'b0001, 
            SRAM_MEM_WRITE      = 4'b0010,
            SRAM_MEM_READ       = 4'b0100,
            FCL1_FNL_RD_DONE    = 4'b1000
} cstate, nstate;

//arcs

logic swch_wr_fcl_dn; //decides to switch to sram_write or fcl_rd_done
logic swch_fcl_dn;   //control indicating switch to fcl_rd_done

assign swch_wr_fcl_dn = sram_rd_en_ctrl_o & mem_inc_done_i & ~(fcl_done_i);
//assign swch_fcl_dn    = sram_rd_en_ctrl_o & mem_inc_done_i & (fcl_done_i);
assign swch_fcl_dn    =  fcl_done_i;

always_ff @( posedge(fsm_clk) or negedge(fsm_rst_b) ) begin
    if (~fsm_rst_b)
        cstate <= RESET;
    else
        cstate <= nstate;
end



///***** setting next state ****/
//always_comb begin : set_nexstate
//    case (cstate)
//        RESET          : begin
//                            if (fcl1_wake_i)
//                                nstate = SRAM_MEM_WRITE;
//                            else
//                                nstate = RESET;
//                         end
//
//        SRAM_MEM_WRITE : begin
//                            if (mem_inc_done_i)
//                                nstate = SRAM_MEM_READ;
//                            else
//                                nstate = SRAM_MEM_WRITE;
//                         end
//
//        SRAM_MEM_READ  : begin
//                            if (swch_wr_fcl_dn)
//                                nstate = SRAM_MEM_WRITE;
//                            else if (swch_fcl_dn)
//                                nstate = FCL1_FNL_RD_DONE;
//                            else
//                                nstate = SRAM_MEM_READ;
//                            end
//        FCL1_FNL_RD_DONE      : begin
//                            if(restart_i)
//                                nstate = RESET;
//                            else
//                                nstate = FCL1_FNL_RD_DONE;
//                         end
//
//        default        : begin
//                            nstate = RESET;
//                         end
//
//    endcase
//end

/// checked with Abhi ,need to discuss with Vishnu to change conv1 fsm and test 

/***** setting next state ****/
always_comb begin : set_nexstate
    case (cstate)
        RESET          : begin
                            if (fcl1_wake_i)
                                nstate = SRAM_MEM_WRITE;
                            else
                                nstate = RESET;
                         end

        SRAM_MEM_WRITE : begin
                            if (mem_inc_done_i)
                                nstate = SRAM_MEM_READ;
                            else
                                nstate = SRAM_MEM_WRITE;
                         end

        SRAM_MEM_READ  : begin
                            if (mem_inc_done_i && (!swch_fcl_dn))
                                nstate = SRAM_MEM_WRITE;
                            else if (swch_fcl_dn)
                                nstate = FCL1_FNL_RD_DONE;
                            else
                                nstate = SRAM_MEM_READ;
                            end
        FCL1_FNL_RD_DONE      : begin
                            if(restart_i)
                                nstate = RESET;
                            else
                                nstate = FCL1_FNL_RD_DONE;
                         end

        default        : begin
                            nstate = RESET;
                         end

    endcase
end

/***** setting outputs ****/
always_comb begin : set_outputs
    //initial values
    sram_wr_en_ctrl_o = 1'b0; 
    sram_rd_en_ctrl_o = 1'b0;
    fcl_cnt_en_ctrl_o = 1'b0;
    fcl_snt_ld_ctrl_o = 1'b0;
    case (cstate)
        RESET :             begin
                                fcl_snt_ld_ctrl_o =1'b1;
                            end

        SRAM_MEM_WRITE :    begin
                                sram_wr_en_ctrl_o            = 1'b1;
                                //fcl_cnt_en_ctrl_o      = 1'b0;
                            end

        SRAM_MEM_READ :     begin
                                sram_rd_en_ctrl_o      = 1'b1; 
                            if(mem_inc_done_i) begin
                                fcl_cnt_en_ctrl_o      = 1'b1; end    
                            end


         FCL1_FNL_RD_DONE :  begin 
                            end
        default :            begin
                                sram_wr_en_ctrl_o           = 1'b0;
                                sram_rd_en_ctrl_o           = 1'b0;
                                fcl_cnt_en_ctrl_o           = 1'b0;
                                fcl_snt_ld_ctrl_o           = 1'b1;
                        //data_valid_buff_ctrl_o          = 0;
                        //conv1_pool_compute_valid_ctrl_o = 1;
                             end

    endcase
end







///***** setting outputs ****/
//always_comb begin : set_outputs
//    //initial values
//    sram_wr_en_ctrl_o = 1'b0; 
//    //sram_rd_en_ctrl_o = 1'b0;
//    fcl_cnt_en_ctrl_o = 1'b0;
//    fcl_snt_ld_ctrl_o = 1'b0;
//    case (nstate)
//        RESET :             begin
//                                fcl_snt_ld_ctrl_o =1'b1;
//                            end
//
//        SRAM_MEM_WRITE :    begin
//                                sram_wr_en_ctrl_o            = 1'b1;
//                            end
//
//        SRAM_MEM_READ :     begin
//                                sram_rd_en_ctrl_o      = 1'b1; 
//                            if(swch_wr_fcl_dn) begin
//                                fcl_cnt_en_ctrl_o      = 1'b1; end    
//                            end
//        FCL1_FNL_RD_DONE :  begin 
//                            end
//        default :            begin
//                                sram_wr_en_ctrl_o           = 1'b0;
//                                sram_rd_en_ctrl_o           = 1'b0;
//                                fcl_cnt_en_ctrl_o           = 1'b0;
//                                fcl_snt_ld_ctrl_o           = 1'b1;
//                        //data_valid_buff_ctrl_o          = 0;
//                        //conv1_pool_compute_valid_ctrl_o = 1;
//                             end
//
//    endcase
//end


endmodule
