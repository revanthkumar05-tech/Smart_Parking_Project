# Smart Parking Occupancy Controller

## Overview
A Verilog-based ASIC project for monitoring parking occupancy, configured for a default capacity of 100 vehicles.

## Features
- Parameterized parking capacity
- Vehicle entry and exit counting
- Full and space-available indicators
- Invalid-event detection
- Asynchronous active-high reset

## Repository Contents
- `01_RTL_Design/` — RTL source and OpenLane configuration
- `02_Functional_Verification/` — testbench and simulation results
- `03_Synthesis/` — synthesis report and gate-level netlist
- `04_Physical_Design/` — floorplan, placement, CTS, routing, DEF and GDS
- `05_Physical_Verification/` — DRC, LVS and manufacturability reports
- `06_PostRoute_STA/` — post-route timing and corner analysis
- `07_Reports_and_Presentation/` — report and presentation materials
- `08_Project_History/` — baseline and comparison files
- `09_Waveforms/` — simulation waveform
- `10_Yosys_Visualization/` — logic graph
- `11_OpenLane_Stage_Outputs/` — selected flow-stage reports

## Functional Verification
The recorded simulation reports 206 checks and 0 errors.

Run the testbench using Icarus Verilog:

    iverilog -g2012 -o /tmp/parking_sim rtl/parking_controller.v simulation/tb_parking_controller.v
    vvp /tmp/parking_sim

## Physical Design
The repository includes physical-design outputs and a GDS file, together with DRC, LVS, manufacturability and timing reports. Consult the reports for detailed results.

## Timing Limitations
The nominal post-route report shows approximately +5.93 ns setup worst slack and +0.33 ns hold worst slack. Some slow-corner STA runs report setup violations; therefore, this project must not be described as passing timing at every corner.

## Reproducibility
Reproducing the physical flow may require the original OpenLane version, PDK, configuration and run environment.

## Author
Revanth Kumar
