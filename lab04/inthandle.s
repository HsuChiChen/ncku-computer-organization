addi  sp, sp, -4
sw    ra, 0(sp)
addi  sp, sp, -12
csrr  x31, 833        # mepc=833(0x341)
sw    x31, 0(sp)
csrr  x31, 768        # mstatus=768
sw    x31, 4(sp)
csrr  x31, 834        # mcause=834
sw    x31, 8(sp)




andi  x31, x31, 3
addi  x31, x31, 1197
jalr  x31

lw    x31, 8(sp)
csrw  834, x31
lw    x31, 4(sp)
ori   x31, x31, 8
csrw  768, x31
lw    x31, 0(sp)
csrw  833, x31




addi  sp, sp, 12
lw    ra, 0(sp)
addi  sp, sp, 4
jr    x31
