###############################################################################
# Created by write_sdc
# Mon Oct 26 10:52:31 2026
###############################################################################
current_design parking_controller
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 10.0000 [get_ports {clk}]
set_clock_transition 0.1500 [get_clocks {clk}]
set_clock_uncertainty 0.2500 clk
set_propagated_clock [get_clocks {clk}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {entry_event}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {exit_event}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {invalid_event}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {occupied_count[0]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {occupied_count[1]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {occupied_count[2]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {occupied_count[3]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {occupied_count[4]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {occupied_count[5]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {occupied_count[6]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {parking_full}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {space_available}]
###############################################################################
# Environment
###############################################################################
set_load -pin_load 0.0334 [get_ports {invalid_event}]
set_load -pin_load 0.0334 [get_ports {parking_full}]
set_load -pin_load 0.0334 [get_ports {space_available}]
set_load -pin_load 0.0334 [get_ports {occupied_count[6]}]
set_load -pin_load 0.0334 [get_ports {occupied_count[5]}]
set_load -pin_load 0.0334 [get_ports {occupied_count[4]}]
set_load -pin_load 0.0334 [get_ports {occupied_count[3]}]
set_load -pin_load 0.0334 [get_ports {occupied_count[2]}]
set_load -pin_load 0.0334 [get_ports {occupied_count[1]}]
set_load -pin_load 0.0334 [get_ports {occupied_count[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {clk}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {entry_event}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {exit_event}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset}]
set_timing_derate -early 0.9500
set_timing_derate -late 1.0500
###############################################################################
# Design Rules
###############################################################################
set_max_transition 0.7500 [current_design]
set_max_fanout 10.0000 [current_design]
