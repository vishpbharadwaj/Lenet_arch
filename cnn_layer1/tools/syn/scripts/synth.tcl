# MW reference
source -e -v ./setup.tcl
sh date
source -e -v ./rtl_list.tcl


analyze -define $RTL_DEFINES -format sverilog $VERILOG_SOURCE_FILES

elaborate $design_name
sh date

current_design $design_name

link
sh date

check_design > ./reports/${design_name}.check_design.rpt

write -f ddc -hier -o ./outputs/${design_name}.elab.ddc

#source -e -v ./scripts/constraints.tcl
#source -e -v ./scripts/io_constraints.tcl
source -e -v ../scripts/clocks.tcl

#group_path -name TO_SRAM_PATHS -to [get_pins -h * -filter "full_name =~ *ip222srspmbshclo8192x39m8k2a\/*"] -weight 2.0
#group_path -name FROM_SRAM_PATHS -from [get_pins -h * -filter "full_name =~ *ip222srspmbshclo8192x39m8k2a\/*"] -weight 2.0

update_timing

check_timing > ./reports/${design_name}.check_timing.rpt

# Clock Gating
##set_clock_gating_style -positive_edge_logic integrated:d04cgc01wd0i0\
##           -minimum_bitwidth 3 \
##           -control_point before \
##           -control_signal test_mode \
##           -num_stages 2 
##
##insert_clock_gating 
##propagate_constraints -gate_clock
##
##if {$multi_vt == 1} {
##    set_multi_vth_constraint -lvth_groups {lvt nom} -lvth_percentage 25 -type soft
##}

sh date
compile_ultra -scan -no_seq_output_inversion -no_autoungroup -no_boundary_optimization -timing_high_effort_script
sh date

write -f ddc -hier -o ./outputs/${design_name}.compile1.ddc

compile_ultra -scan -no_seq_output_inversion -no_autoungroup -no_boundary_optimization -incremental
sh date

# Reports
report_constraint -all_violators -nosplit -verbose > ./reports/$design_name.all_violators
report_timing -max_paths 25  -nosplit > ./reports/$design_name.report_timing
echo "" > ./reports/$design_name.report_io_timing
foreach_in_collection io_port [get_ports *] {
    set io_port_name [get_attribute $io_port full_name]
    if {[get_attribute $io_port pin_direction] == "in"} {
        report_timing -from $io_port_name -nosplit -max_paths 10 >> ./reports/$design_name.report_io_timing
    } else {
        report_timing -to $io_port_name -nosplit -max_paths 10 >> ./reports/$design_name.report_io_timing
    }
}
report_area -hierarchy -nosplit > ./reports/$design_name.report_area
report_qor -nosplit > ./reports/$design_name.report_qor
report_threshold_voltage_group -verbose -nosplit > ./reports/$design_name.report_vt
report_power -verbose -nosplit > ./reports/$design_name.report_power

write -f ddc -hier -o ./outputs/${design_name}.syn_final.ddc
write -f verilog -hier -o ./outputs/${design_name}.gate.v
write_sdc -nosplit ./outputs/${design_name}.sdc
write_parasitics -output ./outputs/${design_name}.spef
exit
