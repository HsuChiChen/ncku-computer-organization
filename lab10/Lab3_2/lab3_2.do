onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/IRCntl/uIRCntl/pending
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/IRCntl/uIRCntl/HIRQSourcesel
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/IRCntl/uIRCntl/HRDATA
add wave -noupdate -format Literal -radix binary /TBTic/uEASY/IRCntl/uIRCntl/HIRQSource
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/IRCntl/uIRCntl/HCLK
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/IRCntl/uIRCntl/HRESETn
add wave -noupdate -divider Timer1
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/Timer1/uTimers/HSELT
add wave -noupdate -format Literal -radix unsigned /TBTic/uEASY/Timer1/uTimers/ENABLE
add wave -noupdate -format Literal -radix unsigned /TBTic/uEASY/Timer1/uTimers/VALUE
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/Timer1/uTimers/HADDR
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/Timer1/uTimers/ACK
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/Timer1/uTimers/timer_itr
add wave -noupdate -format Literal -radix unsigned /TBTic/uEASY/Timer1/uTimers/number_currnt
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/Timer1/uTimers/ENABLE
add wave -noupdate -format Literal -radix unsigned /TBTic/uEASY/Timer1/uTimers/VALUE
add wave -noupdate -divider Timer2
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/Timer2/uTimers/HSELT
add wave -noupdate -format Literal -radix unsigned /TBTic/uEASY/Timer2/uTimers/ENABLE
add wave -noupdate -format Literal -radix unsigned /TBTic/uEASY/Timer2/uTimers/VALUE
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/Timer2/uTimers/HADDR
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/Timer2/uTimers/ACK
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/Timer2/uTimers/timer_itr
add wave -noupdate -format Literal -radix unsigned /TBTic/uEASY/Timer2/uTimers/number_currnt
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/Timer2/uTimers/ENABLE
add wave -noupdate -format Literal -radix unsigned /TBTic/uEASY/Timer2/uTimers/VALUE
add wave -noupdate -divider IRCntl
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/IRCntl/uIRCntl/HSELT
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/IRCntl/uIRCntl/HWRITE
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/IRCntl/uIRCntl/HADDR
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/IRCntl/uIRCntl/HWDATA
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/IRCntl/uIRCntl/HIRQAck
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/IRCntl/uIRCntl/clean
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/IRCntl/uIRCntl/nIRQ
add wave -noupdate -divider Tube
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/uTube/HSEL
add wave -noupdate -format Literal -radix ascii /TBTic/uEASY/uTube/HWDATA
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/uTube/HWRITE
add wave -noupdate -divider EASY
add wave -noupdate -format Logic /TBTic/uEASY/SW1_IRQ
add wave -noupdate -format Logic /TBTic/uEASY/LED1_ACK
add wave -noupdate -divider TBTic
add wave -noupdate -format Logic -radix hexadecimal /TBTic/SW1
add wave -noupdate -format Logic -radix hexadecimal /TBTic/LED1
add wave -noupdate -divider CPu
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/uRISC32/uIntegerCore/umodel05/GENERAL_REG/regpc15
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/uRISC32/uIntegerCore/umodel05/ID
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/uRISC32/uIntegerCore/umodel05/IABORT
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/uRISC32/uIntegerCore/umodel05/IA
add wave -noupdate -format Logic -radix hexadecimal /TBTic/uEASY/uRISC32/uIntegerCore/umodel05/DABORT
add wave -noupdate -format Literal -radix hexadecimal /TBTic/uEASY/uRISC32/IA
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {63945000 ps} 0}
configure wave -namecolwidth 181
configure wave -valuecolwidth 130
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
WaveRestoreZoom {0 ps} {291375 ns}
