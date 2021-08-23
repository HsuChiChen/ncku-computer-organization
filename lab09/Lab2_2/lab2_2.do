onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Arbiter
add wave -noupdate -format Logic -radix unsigned /TBTic/uEASY/uArbiter/HBUSREQ1
add wave -noupdate -format Logic -radix unsigned /TBTic/uEASY/uArbiter/HBUSREQ2
add wave -noupdate -format Logic -radix unsigned /TBTic/uEASY/uArbiter/HBUSREQ3
add wave -noupdate -format Logic -radix unsigned /TBTic/uEASY/uArbiter/HBUSREQ4
add wave -noupdate -format Logic -radix unsigned /TBTic/uEASY/uArbiter/HGRANT1
add wave -noupdate -format Logic -radix unsigned /TBTic/uEASY/uArbiter/HGRANT2
add wave -noupdate -format Logic -radix unsigned /TBTic/uEASY/uArbiter/HGRANT3
add wave -noupdate -format Logic -radix unsigned /TBTic/uEASY/uArbiter/HGRANT4
add wave -noupdate -format Literal -radix unsigned /TBTic/uEASY/uArbiter/HMASTER
add wave -noupdate -divider M2S
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/uMuxM2S/HADDR_M1
add wave -noupdate -format Literal -radix unsigned /TBTic/uEASY/uMuxM2S/HWDATA_M1
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/uMuxM2S/HADDR_M2
add wave -noupdate -format Literal -radix ascii /TBTic/uEASY/uMuxM2S/HWDATA_M2
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/uMuxM2S/HADDR_M3
add wave -noupdate -format Literal -radix ascii /TBTic/uEASY/uMuxM2S/HWDATA_M3
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/uMuxM2S/HADDR_M4
add wave -noupdate -format Literal -radix ascii /TBTic/uEASY/uMuxM2S/HWDATA_M4
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/uMuxM2S/HADDR
add wave -noupdate -format Literal -radix ascii /TBTic/uEASY/uMuxM2S/HWDATA
add wave -noupdate -divider Decoder
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/uDecoder/HADDR
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/uDecoder/HSEL_Slave1
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/uDecoder/HSEL_Slave2
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/uDecoder/HSEL_Slave3
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/uDecoder/HSEL_Slave4
add wave -noupdate -format Logic /TBTic/uEASY/uDecoder/HSEL_Slave5
add wave -noupdate -divider Timer1
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/Timer1/HSELS
add wave -noupdate -format Literal -radix unsigned /TBTic/uEASY/Timer1/HWDATAS
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/Timer1/HREADYS
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/Timer1/HRDATAS
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/Timer1/IRQ
add wave -noupdate -format Literal -radix unsigned /TBTic/uEASY/Timer1/uTimers/ENABLE
add wave -noupdate -format Literal -radix unsigned /TBTic/uEASY/Timer1/uTimers/VALUE
add wave -noupdate -format Literal -radix unsigned /TBTic/uEASY/Timer1/uTimers/number_currnt
add wave -noupdate -format Logic -radix unsigned /TBTic/uEASY/Timer1/uTimers/interrupt
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/Timer1/uTimers/timer_itr
add wave -noupdate -divider M1
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/testMaster01/wake
add wave -noupdate -format Literal -radix ascii /TBTic/uEASY/testMaster01/HWDATAM
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/testMaster01/HBUSREQM
add wave -noupdate -divider M2
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/testMaster02/wake
add wave -noupdate -format Literal -radix ascii /TBTic/uEASY/testMaster02/HWDATAM
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/testMaster02/HBUSREQM
add wave -noupdate -divider M3
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/testMaster03/wake
add wave -noupdate -format Literal -radix ascii /TBTic/uEASY/testMaster03/HWDATAM
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/testMaster03/HBUSREQM
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {520000 ps} 0}
configure wave -namecolwidth 127
configure wave -valuecolwidth 77
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
WaveRestoreZoom {0 ps} {8400 ns}
