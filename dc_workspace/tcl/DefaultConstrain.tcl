#=====================================
#   
#	Clean-up
#
#=====================================
reset_design
#=====================================
# 
#	CLOCK
#
#=====================================
# ----------------clock data----------------------
set CLK_DATA_PERIOD 		2.0
set CLK_DATA_MAX_LATENCY_SOURCE 	[expr {0.15  * $CLK_DATA_PERIOD}]
set CLK_DATA_MAX_LATENCY 		[expr {0.1   * $CLK_DATA_PERIOD}]
set CLK_DATA_TRANSITION  		[expr {0.025 * $CLK_DATA_PERIOD}]
set CLK_DATA_UNCERTAINTY 		[expr {0.15  * $CLK_DATA_PERIOD}]

# ----------------Internel clock----------------------
create_clock -period $CLK_DATA_PERIOD -name clk_data [get_ports clk_data]
set_clock_uncertainty -setup $CLK_DATA_UNCERTAINTY [get_clocks clk_data]
set_clock_latency -source -max $CLK_DATA_MAX_LATENCY_SOURCE [get_clocks clk_data]
set_clock_latency -max $CLK_DATA_MAX_LATENCY [get_clocks clk_data]
set_clock_transition $CLK_DATA_TRANSITION [get_clocks clk_data]

# ----------------clock data----------------------
set CLK_PE_PERIOD 		16.0
set CLK_PE_MAX_LATENCY_SOURCE 	[expr {0.15  * $CLK_PE_PERIOD}]
set CLK_PE_MAX_LATENCY 		[expr {0.1   * $CLK_PE_PERIOD}]
set CLK_PE_TRANSITION  		[expr {0.025 * $CLK_PE_PERIOD}]
set CLK_PE_UNCERTAINTY 		[expr {0.15  * $CLK_PE_PERIOD}]

# ----------------Internel clock----------------------
create_clock -period $CLK_PE_PERIOD -name clk_pe [get_ports clk_pe]
set_clock_uncertainty -setup $CLK_PE_UNCERTAINTY [get_clocks clk_pe]
set_clock_latency -source -max $CLK_PE_MAX_LATENCY_SOURCE [get_clocks clk_pe]
set_clock_latency -max $CLK_PE_MAX_LATENCY [get_clocks clk_pe]
set_clock_transition $CLK_PE_TRANSITION [get_clocks clk_pe]

# --------------Set dont touch-------------------------
set_dont_touch_network [get_ports clk_pe]

set_dont_touch [get_ports clk_data]
set_dont_touch [get_ports rst_n]

#======================================
#
#	Input path
#   
#======================================
set All_input [remove_from_collection [all_inputs] [get_ports {clk_data clk_pe rst_n}]]

# input from internal cntl
set_input_delay -max [expr {0.3 * $CLK_DATA_PERIOD}] -clock clk_data $All_input
set_input_delay -min [expr {0.06 * $CLK_DATA_PERIOD}] -clock clk_data $All_input

#======================================
#
#	Output path
#
#======================================
set_output_delay -max [expr {0.7 * $CLK_DATA_PERIOD}] -clock clk_pe [all_outputs]

#======================================
#
#	AREA
#
#======================================
set_max_area 0

#======================================
#
#   Environment attributes
#
#======================================
set_load 0.03 [all_outputs]

#======================================
#
#   Fanout
#
#======================================
set_max_fanout 32 [current_design]

#======================================
#
#   Ignore
#
#======================================
set_false_path -from [get_clocks clk_data] -to [get_clocks clk_pe]
set_false_path -from [get_clocks clk_pe] -to [get_clocks clk_data]

