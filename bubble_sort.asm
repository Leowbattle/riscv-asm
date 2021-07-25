la a0, numbers
li a1, 20
call bubble_sort

li a0, 0
li a7, 93
ecall # exit(0)

# void bubble_sort(int* arr, int count);
bubble_sort:
	slli t1, a1, 2
	add t1, a0, t1
	addi t1, t1, -4 # t1 = arr + count - 1
	
outer_loop:
	mv t0, a0
	li t4, 0
loop:
	lw t2, 0(t0)
	lw t3, 4(t0)
	blt t3, t2, swap
	j cont
swap:
	sw t3, 0(t0)
	sw t2, 4(t0)
	li t4, 1
cont:
	addi t0, t0, 4
	blt t0, t1, loop
	
	bnez t4, outer_loop
	
	ret
	
.data

numbers:
.word 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1