# Clock constraint for 100 MHz (10 ns period)
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} [get_ports clk]

# Input delay constraint for reset
set_input_delay -clock sys_clk_pin 2.000 [get_ports reset]