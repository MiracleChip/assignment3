quit -sim
vlib work
vlog reqres.sv
vlog elevator_ctrl.sv
vlog elevator_ctrl_tb.sv
vlog ctrl_unit.sv
vlog ssd.sv
vsim -voptargs=+acc work.elevator_ctrl_tb
run -all

