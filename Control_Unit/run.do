quit -sim
vlib work
vlog ctrl_unit.sv
vlog ssd.sv
vlog ctrl_unit_tb.sv
vsim -voptargs=+acc work.ctrl_unit_tb
do wave.do
run -all

