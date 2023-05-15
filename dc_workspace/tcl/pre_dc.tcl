set DESIGN_NAME        "MulAdd_top"
set RTL_SOURCE_FILES  "-f ./design.f"
set CONSTRAIN_FILE     "./tcl/DefaultConstrain.tcl"
set DES_LIB  "./WORK/"


if {![file exists ${DES_LIB}]} {
    echo "Generate dir design lib"
    sh mkdir WORK
}
define_design_lib MY_LIB -path $DES_LIB


saif_map -start
# analyze -format verilog ${RTL_SOURCE_FILES} -library MY_LIB
analyze -format sverilog -vcs $RTL_SOURCE_FILES -library MY_LIB
elaborate ${DESIGN_NAME} -library MY_LIB

current_design $DESIGN_NAME

link
uniquify

set_svf ./dc_output/${DESIGN_NAME}_pre.svf
source -echo -verbose ${CONSTRAIN_FILE}

compile
set_svf -off
report_timing

write -hierarchy -format ddc -output ./dc_output/${DESIGN_NAME}_pre.ddc
write -hierarchy -format verilog -output ./dc_output/${DESIGN_NAME}_pre.v
write_sdf ./dc_output/${DESIGN_NAME}.sdf
write_sdc ./dc_output/${DESIGN_NAME}.sdc

rt > ./dc_output/report_timing.rpt
ra > ./dc_output/report_area.rpt
