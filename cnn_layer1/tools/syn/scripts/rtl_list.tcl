
lappend search_path $variable/rtl/


########################################################
#
#
# add the RTL source files as given in the below example
# ex:   lappend VERILOG_SOURCE_FILES CORTEXM7.v           
#
#
########################################################
lappend VERILOG_SOURCE_FILES conv1_top.sv
lappend VERILOG_SOURCE_FILES dff_en.sv
lappend VERILOG_SOURCE_FILES srff_en.sv
lappend VERILOG_SOURCE_FILES shift_regn.sv
lappend VERILOG_SOURCE_FILES linebuff_1F_rowxcol.sv
lappend VERILOG_SOURCE_FILES cnt_down.sv
lappend VERILOG_SOURCE_FILES upcounter.sv
lappend VERILOG_SOURCE_FILES mem_block.sv
lappend VERILOG_SOURCE_FILES lb1_pxl_cnt.sv
lappend VERILOG_SOURCE_FILES intrm_flop.sv
lappend VERILOG_SOURCE_FILES conv1_intrm_flop.sv
lappend VERILOG_SOURCE_FILES parl_add_2.sv
lappend VERILOG_SOURCE_FILES parl_add_5.sv
lappend VERILOG_SOURCE_FILES mult2.sv
lappend VERILOG_SOURCE_FILES mult_add_2pairs.sv
lappend VERILOG_SOURCE_FILES mult_add_5pairs.sv
lappend VERILOG_SOURCE_FILES conv1_wght_pxl_routing.sv
lappend VERILOG_SOURCE_FILES conv1_compute_filter.sv
lappend VERILOG_SOURCE_FILES conv1_compute_stride.sv
lappend VERILOG_SOURCE_FILES conv1_compute_actv.sv
lappend VERILOG_SOURCE_FILES conv1_compute_top.sv
lappend VERILOG_SOURCE_FILES actv_relu.sv
lappend VERILOG_SOURCE_FILES linebuff_pool.sv
lappend VERILOG_SOURCE_FILES max_pool.sv
lappend VERILOG_SOURCE_FILES conv1_max_pool.sv
lappend VERILOG_SOURCE_FILES conv1_max_pool_top.sv
lappend VERILOG_SOURCE_FILES fsm_layer1.sv
