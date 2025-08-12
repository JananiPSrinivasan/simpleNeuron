# Clock Constraint

create_clock -name clk -period 10.0 [get_ports clk]
set_input_delay -clock clk 2.5 [get_ports rst_n]

# Set switching activity (toggle rate) per port
set_switching_activity -static_probability 0.1 -toggle_rate 10 [get_ports x]
set_switching_activity -static_probability 0.1 -toggle_rate 10 [get_ports w]
set_switching_activity -static_probability 0.1 -toggle_rate 10 [get_ports bias]
set_switching_activity -static_probability 0.1 -toggle_rate 10 [get_ports y]

# Set load capacitance per I/O pin to realistic value
set_load 5 [get_ports y]         ;# In pF

