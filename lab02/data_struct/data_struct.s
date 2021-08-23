main:
	#### 剛進入main function(注意stack的大小)####
	addi	sp,sp,-40 	#進入main function, 空出一個stack的空間(sp作為main stack的底部)
	sw	ra,16(sp) 	#將ra存起來(owner:caller -> 之後return 0要用)
	addi	s0,sp,40	#拿s0作為frame pointer(s0作為main stack的頂部)

	#### 宣告stuct student* A ####
	addi	a5,zero,1024
	addi	a5,a5,1024
	sw	a5,-20(s0)

	#### 宣告stuct student* B ####
	addi	a6,zero,1040
	addi	a6,a6,1040
	sw	a6,-4(s0)

	#### 宣告stuct student s1 ####
	addi	a5,zero,60
	sw	a5,-36(s0)
	addi	a5,zero,70
	sw	a5,-32(s0)
	addi	a5,zero,70
	sw	a5,-28(s0)

	#### 宣告stuct student s2 ####

	addi	a6,zero,70
	sw	a6,-16(s0)
	addi	a6,zero,50
	sw	a6,-12(s0)
	addi	a6,zero,80
	sw	a6,-8(s0)

	#### *A = s1 ####
	lw	a5,-20(s0) 	#拿到*A
	lw	a4,-36(s0)	#將s1的值一個一個丟進去
	sw	a4,0(a5)
	lw	a4,-32(s0)
	sw	a4,4(a5)
	lw	a4,-28(s0)
	sw	a4,8(a5)

	#### *B = s2 ####
	lw	a6,-4(s0) 	#拿到*A
	lw	a4,-16(s0)	#將s1的值一個一個丟進去
	sw	a4,0(a6)
	lw	a4,-12(s0)
	sw	a4,4(a6)
	lw	a4,-8(s0)
	sw	a4,8(a6)

	#### 結束 main function ####
	lw		ra,16(sp)	# 拿回ra(owner:caller -> 拿回自己保存的值)
	addi		sp,sp,40	# 釋出main的stack
	jalr		zero,0(ra)	# 跳出main(使用跳轉指令)


