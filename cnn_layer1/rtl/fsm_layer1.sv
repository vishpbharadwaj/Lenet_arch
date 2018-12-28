//


module fsm_layer1 #(

)(
    input logic     fsm_clk,
    input logic     fsm_rst_b,
    input logic     sof_i,                          //Start of Frame
    input logic     data_valid_i,                   //data valid i.e. correct data is filling buffer
    input logic     sram_cnt_done_i,                //write from sram to regs done
    //input logic     lb_pxl_cnt_done_i,              //pxl buffer load done
    //input logic     lb_pool_cnt_done_i,             //pool buffer load done
    input logic     conv1_compute_out_valid_i,      //correct data at compute, start pool buff counter
    output logic    load_counters_ctrl_o,           //load the values of counters
    output logic    load_sram_reg_en_ctrl_o,        //to start writes to reg from sram
    output logic    lb_pxl_cnt_en_ctrl_o,           //to start pxl buffer load
    //output logic    data_valid_buff_ctrl_o,         //to delay flops of compute
    output logic    lb_pool_cnt_en_ctrl_o          //to start pool buffer load
    //output logic    conv1_pool_compute_valid_ctrl_o,//pool out data valid
    //output logic    reset_b_ctrl_o                  //reset to all modules
);

enum logic[2:0] {
            RESET       = 3'b001,
            START       = 3'b010,
            CONV1_POOL  = 3'b100
} cstate, nstate;

always_ff @( posedge(fsm_clk) or negedge(fsm_rst_b) ) begin
    if (~fsm_rst_b)
        cstate <= RESET;
    else
        cstate <= nstate;
end


/***** setting next state ****/
always_comb begin : set_nexstate
    case (cstate)
        RESET : begin
                    if (sof_i)
                        nstate = START;
                    else if (~fsm_rst_b)
                        nstate = RESET;
                    else
                        nstate = RESET;
                end

        START : begin
                    if (conv1_compute_out_valid_i)
                        nstate = CONV1_POOL;
                    else if (~fsm_rst_b)
                        nstate = RESET;
                    else
                        nstate = START;
                end

        CONV1_POOL :    begin
                            if (~fsm_rst_b)
                                nstate = RESET;
                            else
                                nstate = CONV1_POOL;
                        end

        default :   begin
                        nstate = RESET;
                    end

    endcase
end


/***** setting outputs ****/
always_comb begin : set_outputs
    load_counters_ctrl_o    = 0;
    load_sram_reg_en_ctrl_o = 0;
    lb_pxl_cnt_en_ctrl_o    = 0;
    lb_pool_cnt_en_ctrl_o   = 0;

    case (nstate)
        RESET : begin
                    load_counters_ctrl_o            = 1;
                end

        START : begin
                    lb_pxl_cnt_en_ctrl_o    = 1;
                    load_sram_reg_en_ctrl_o = 1;
                end

        CONV1_POOL :    begin
                            lb_pool_cnt_en_ctrl_o   = 1;
                        end
    endcase
end


endmodule
