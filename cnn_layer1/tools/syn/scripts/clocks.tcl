# Clocks
# #100MHz
set clk_freq    100


set clock_uncertainty           [expr (10000/$clk_freq)]
#set clock_uncertainty           450
set clk_period_gb               [expr 1.0/1.46]
#set clock_period                [expr ((1000000/$clk_freq)*$clk_period_gb) - $clock_uncertainty]

#10,000ps= 100MHz
set clock_period            2500 

# Create Clocks
create_clock [get_ports conv1_top_clk] -name conv1_top_clk -period $clock_period

group_path -name reg2reg -from [all_registers -clock_pins] -to [all_registers -data_pins]
group_path -name feedthrough -from [all_inputs] -to [all_outputs] 
group_path -name in2flop -from [all_inputs] -to [all_registers -data_pins] 
group_path -name flop2out -from [all_registers -clock_pins] -to [all_outputs]
