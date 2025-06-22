## Generated SDC file "riscv.out.sdc"

## Copyright (C) 2025  Altera Corporation. All rights reserved.
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and any partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, the Altera Quartus Prime License Agreement,
## the Altera IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Altera and sold by Altera or its authorized distributors.  Please
## refer to the Altera Software License Subscription Agreements 
## on the Quartus Prime software download page.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 24.1std.0 Build 1077 03/04/2025 SC Lite Edition"

## DATE    "Sun Jun  8 18:55:13 2025"

##
## DEVICE  "EP4CE6F17C6"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {ClockDIV_internal} -period 1.000 -waveform { 0.000 0.500 } [get_registers {ClockDIV_internal}]
create_clock -name {CLOCK} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {CLOCK}] -rise_to [get_clocks {CLOCK}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {CLOCK}] -fall_to [get_clocks {CLOCK}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {CLOCK}] -rise_to [get_clocks {ClockDIV_internal}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {CLOCK}] -fall_to [get_clocks {ClockDIV_internal}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {CLOCK}] -rise_to [get_clocks {CLOCK}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {CLOCK}] -fall_to [get_clocks {CLOCK}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {CLOCK}] -rise_to [get_clocks {ClockDIV_internal}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {CLOCK}] -fall_to [get_clocks {ClockDIV_internal}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {ClockDIV_internal}] -rise_to [get_clocks {CLOCK}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {ClockDIV_internal}] -fall_to [get_clocks {CLOCK}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {ClockDIV_internal}] -rise_to [get_clocks {ClockDIV_internal}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {ClockDIV_internal}] -fall_to [get_clocks {ClockDIV_internal}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {ClockDIV_internal}] -rise_to [get_clocks {CLOCK}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {ClockDIV_internal}] -fall_to [get_clocks {CLOCK}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {ClockDIV_internal}] -rise_to [get_clocks {ClockDIV_internal}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {ClockDIV_internal}] -fall_to [get_clocks {ClockDIV_internal}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

