quit -sim
vlib work
vlog reqres.sv
vlog tb_reqres.sv
vsim -voptargs=+acc work.tb_reqres
do wave.do
run -all

