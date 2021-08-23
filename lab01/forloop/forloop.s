nop
addi x12,x0,0
addi x13,x0,0
addi x14,x0,10

loop:
addi x12, x12, 1
beq x12, x14, end
add x13, x13, x12
jal x0, loop

end:

ret
