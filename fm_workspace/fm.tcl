source /home/tools/synopsys/fm/fm/O-2018.06-SP5/admin/setup/.synopsys_fm.setup
set cdf_gen_file 12601.fm.cdf;
source /home/tools/synopsys/fm/fm/O-2018.06-SP5/auxx/gui/fm/.convertFmCmd2Tcl.tcl
set_mismatch_message_filter -suppress {FMR_ELAB-147 FMR_ELAB-130}

set_svf -append { ../dc_workspace/dc_output/MulAdd_top_pre.svf } 
read_sverilog -container r -libname WORK -12 { ../design/shift_buffer.sv ../design/process_element.sv ../design/pe_top.sv ../design/pa_top.sv ../design/MulAdd_top.sv ../design/fixedpoint_multiplier.sv ../design/fixedpoint_formatter.sv ../design/fixedpoint_adder.sv ../design/counter.sv ../design/clk_syncer.sv ../design/accelerator_FSM.sv } 

read_db { /data/PDK/synopsys/ih55lp_hs_rvt_tt_1p20_25c_basic.db } 

set_top r:/WORK/MulAdd_top 

read_verilog -container i -libname WORK -05 { ../dc_workspace/dc_output/MulAdd_top_pre.v } 
read_db { /data/PDK/synopsys/ih55lp_hs_rvt_tt_1p20_25c_basic.db } 
set_top i:/WORK/MulAdd_top 
match 
verify
