onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {ARM CPU}
add wave -noupdate -radix hexadecimal /TBTic/uEASY/uTube/HCLK
add wave -noupdate -radix hexadecimal /TBTic/uEASY/uRISC32/HADDRM
add wave -noupdate -radix hexadecimal /TBTic/uEASY/uRISC32/HRDATAM
add wave -noupdate -radix hexadecimal /TBTic/uEASY/uRISC32/ID
add wave -noupdate -radix hexadecimal /TBTic/uEASY/uRISC32/HWDATAM
add wave -noupdate -radix hexadecimal /TBTic/uEASY/uRISC32/HWRITEM
add wave -noupdate -divider Decoder
add wave -noupdate -radix hexadecimal /TBTic/uEASY/uDecoder/HRESETn
add wave -noupdate -radix hexadecimal /TBTic/uEASY/uDecoder/HADDR
add wave -noupdate -radix hexadecimal /TBTic/uEASY/uDecoder/HSELDefault
add wave -noupdate -radix hexadecimal /TBTic/uEASY/uDecoder/HSEL_Slave1
add wave -noupdate -radix hexadecimal /TBTic/uEASY/uDecoder/HSEL_Slave2
add wave -noupdate -divider Tube
add wave -noupdate -radix hexadecimal /TBTic/uEASY/uTube/HCLK
add wave -noupdate -radix hexadecimal /TBTic/uEASY/uTube/HADDR
add wave -noupdate -radix hexadecimal /TBTic/uEASY/uTube/HSEL
add wave -noupdate -radix hexadecimal /TBTic/uEASY/uTube/HWRITE
add wave -noupdate -radix hexadecimal /TBTic/uEASY/uTube/HREADYin
add wave -noupdate -radix hexadecimal /TBTic/uEASY/uTube/HRESETn
add wave -noupdate -radix hexadecimal /TBTic/uEASY/uTube/HSIZE
add wave -noupdate -radix hexadecimal /TBTic/uEASY/uTube/HTRANS
add wave -noupdate -radix hexadecimal /TBTic/uEASY/uTube/HWDATA
add wave -noupdate -radix hexadecimal /TBTic/uEASY/uTube/HRDATA
add wave -noupdate -radix hexadecimal /TBTic/uEASY/uTube/HREADYout
add wave -noupdate -radix hexadecimal /TBTic/uEASY/uTube/HRESP
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {896989 ps} 0}
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
WaveRestoreZoom {770989 ps} {1022989 ps}
