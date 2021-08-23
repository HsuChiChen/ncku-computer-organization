	.file	"fib.c"
	.option nopic
	.option checkconstraints
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-48
	sw		s0,44(sp)
	addi	s0,sp,48
	li	a2,0 
	li	a3,1 
	li	a4,0 
	li	a5,9
	li	a7,2048	
	loop:
	beq 	a4,a5,end
	add 	a6,a2,a3
	add	a2,x0,a3
	add	a3,x0,a6
	addi	a4,a4,1
	jal	x0,loop
	
	end:
	sw	a6,0(a7)







	li	a5,0
	mv	a0,a5
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 9.2.0"