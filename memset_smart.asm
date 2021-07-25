# This version executes the main loop by computing the end address and using pointer arithmetic
# rather than a counter.
# The main loop takes 3 instructions, and writes 4 bytes. So it writes 1.3333... bytes per cycle on average.

la a0, arr
li a1, 0x00000023
li a2, 8192
call memset
li a7, 10
ecall

# void memset(void* ptr, int value, size_t num);
# a0: ptr
# a1: value
# a2: num
memset:
	# Copy the first byte of a1 into the 4 bytes of t1
	# e.g. If a1 = 0x00000056, t1 = 0x56565656
	andi a1, a1, 0xff # Discard 3 most significant bytes of value
	add t0, x0, a1
	slli a1, a1, 8
	add t0, t0, a1
	slli a1, t0, 16
	add t0, t0, a1
	
	andi t1, a2, 0xfffffffc
	beqz t1, prep
	add t1, t1, a0

copy_word:
	sw t0, (a0)
	addi a0, a0, 4
	blt a0, t1, copy_word
	
prep:
	andi a2, a2, 0x00000003
	beqz a2, end
	andi a1, t0, 0xff
	li t0, 0
	li t1, 1
	beq a2, t1, rem_1
	li t1, 2
	beq a2, t1, rem_2
	li t1, 3
	beq a2, t1, rem_3

rem_3:
	add t0, t0, a1
	slli a1, a1, 8
rem_2:
	add t0, t0, a1
	slli a1, a1, 8
rem_1:
	add t0, t0, a1
	
	sw t0, (a0)

end:
	ret

.data
arr:
.space 65536
