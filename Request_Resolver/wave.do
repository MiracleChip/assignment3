onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /tb_reqres/clk
add wave -noupdate -radix binary /tb_reqres/rst
add wave -noupdate -radix binary /tb_reqres/upreq
add wave -noupdate -radix binary /tb_reqres/downreq
add wave -noupdate -radix binary /tb_reqres/up
add wave -noupdate -radix binary /tb_reqres/down
add wave -noupdate -radix binary /tb_reqres/open
add wave -noupdate -radix binary /tb_reqres/req
add wave -noupdate -divider design
add wave -noupdate -radix binary /tb_reqres/uut/clk
add wave -noupdate -radix binary /tb_reqres/uut/rst
add wave -noupdate -radix binary /tb_reqres/uut/upreq
add wave -noupdate -radix binary /tb_reqres/uut/downreq
add wave -noupdate -radix binary /tb_reqres/uut/up
add wave -noupdate -radix binary /tb_reqres/uut/down
add wave -noupdate -radix binary /tb_reqres/uut/open
add wave -noupdate -radix binary /tb_reqres/uut/req
add wave -noupdate -radix binary /tb_reqres/uut/curr
add wave -noupdate -radix binary /tb_reqres/uut/uptarget
add wave -noupdate -radix binary /tb_reqres/uut/downtarget
add wave -noupdate -radix binary /tb_reqres/uut/timer
add wave -noupdate -radix binary /tb_reqres/uut/i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7609909 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {7609830 ps} {7610222 ps}
