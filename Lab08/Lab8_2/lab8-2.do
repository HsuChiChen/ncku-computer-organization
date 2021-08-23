onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {ARM CPU}
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/uTube/HCLK
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/uRISC32/HADDRM
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/uRISC32/HRDATAM
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/uRISC32/ID
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/uRISC32/HWDATAM
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/uRISC32/HWRITEM
add wave -noupdate -divider Decoder
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/uDecoder/HRESETn
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/uDecoder/HADDR
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/uDecoder/HSELDefault
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/uDecoder/HSEL_Slave1
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/uDecoder/HSEL_Slave2
add wave -noupdate -format Logic /TBTic/uEASY/uDecoder/HSEL_Slave3
add wave -noupdate -format Logic /TBTic/uEASY/uDecoder/HSEL_Slave4
add wave -noupdate -divider Tube
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/uTube/HCLK
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/uTube/HADDR
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/uTube/HSEL
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/uTube/HWRITE
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/uTube/HREADYin
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/uTube/HRESETn
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/uTube/HSIZE
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/uTube/HTRANS
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/uTube/HWDATA
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/uTube/HRDATA
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/uTube/HREADYout
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/uTube/HRESP
add wave -noupdate -divider ExtMem
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/uExtMem/HCLK
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/uExtMem/HSEL
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/uExtMem/HWRITE
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/uExtMem/HWDATA
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/uExtMem/HADDR
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {670000 ps} 0}
configure wave -namecolwidth 146
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
WaveRestoreZoom {543306 ps} {1281138 ps}
