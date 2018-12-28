#!/bin/tcsh -f
##############################################################################################

rm -rf DVEfiles csrc inter.vpd simv simv.daidir ucli.key

set nogui_mode = "nogui"

if ($nogui_mode == $1) then
    echo "----------------------- running in No GUI mode -------------------------"
    vcs -sverilog -debug_all +lint=PCWM -f compile_list.f
else
    echo "----------------------- running in GUI mode -------------------------"
    vcs -sverilog -debug_all +lint=PCWM -f compile_list.f -R -gui -override_timescale=1ps/1ps
end
