	.file	"load_store.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sw		s0,28(sp)
	addi	s0,sp,32
	nop
	li		a2,2048
	li		a3,2056
	li      a4,1
	li      a5,2
    sw      a4,0(a2)
	sw		a5,4(a2)
	lw      a4,0(a2)
	lw		a5,4(a2)
	add 	a6,a4,a5
	sw      a6,0(a3)


	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 9.2.0"
