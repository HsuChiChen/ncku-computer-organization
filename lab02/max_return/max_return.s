main:

	#### 剛進入main function ####
	addi	sp,sp,-32 	#進入main function, 空出一個stack的空間(sp作為main stack的底部)
	sw		ra,28(sp) 	#將ra存起來(owner:caller -> 之後return 0要用)
	sw		s0,24(sp)	#將s0存起來(owner:callee -> callee要負責維持save register的值)
	addi	s0,sp,32	#拿s0作為frame pointer(s0作為main stack的頂部)

	#### 宣告 int a ####
	addi	t1,zero,44	# 
	sw	t1,-20(s0)	# int a 被我放到(s0-20)這個記憶體位址

	#### 宣告 int b,c ####
	addi	t2,zero,87
	sw	t2,-24(s0)

	addi	t3,zero,2
	sw	t3,-28(s0)

	#### 宣告 int *n ####
	li	s11,2048

	#### 準備function arguments ####
	add	a1,t1,x0
	add	a2,t2,x0
	add	a3,t3,x0

	#### 進入sum function (使用跳轉指令) ####
	jal	ra,sum

	#### 將拿到的回傳值(放在a0)放進*n ####
	sw	a0,0(s11)

	#### 結束main function ####
	lw		ra,28(sp)	# 拿回ra(owner:caller -> 拿回自己保存的值)
	lw		s0,24(sp)	# 拿回s0(owner:callee -> callee要負責維持save register的值)
	addi	sp,sp,32	# 釋出main的stack
	jalr	zero,0(ra)	# 跳出main(使用跳轉指令)

sum:
    	#### 剛進入sum function ####
	addi	sp,sp,-32 	#進入main function, 空出一個stack的空間(sp作為main stack的底部)
	sw	ra,28(sp) 	#將ra存起來(owner:caller -> 之後return 0要用)
	sw	s0,24(sp)	#將s0存起來(owner:callee -> callee要負責維持save register的值)
	addi	s0,sp,32	#拿s0作為frame pointer(s0作為main stack的頂部)

	#### 儲存function arguments ####
	add	s1,a1,x0
	add	s2,a2,x0
	add	s3,a3,x0

	#### 跑 sum function (n = a+b+c), 並將回傳值n放到a0 ####
	add	s4,s1,s2
	add	a0,s3,s4

	#### 結束sum function ####
	jalr	x0,0(ra)

