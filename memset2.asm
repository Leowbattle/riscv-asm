# This is a smarter version of memset that writes 4 bytes at a time.
# If num does not divide by 4, the remainder is written separately.
# The main loop takes 4 instructions and writes 4 bytes. So 1 byte per cycle on average
# (not accounting for remainder and function setup)

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
	mv t5, a1
	add t1, x0, a1
	slli a1, a1, 8
	add t1, t1, a1
	slli a1, a1, 8
	add t1, t1, a1
	slli a1, a1, 8
	add t1, t1, a1
	
	# Split num into whole words and remaining bytes.
	# e.g. If num = 9, t2 = 8, t3 = 1
	#srli t2, a2, 2
	andi t2, a2, 0xfffffffc
	andi t6, a2, 0x00000003
	li t3, 3
	sub t3, t3, t6
	slli t3, t3, 2
	
	li t0, 0
	blez t2, prep
copy_word:
	add t4, a0, t0
	sw t1, 0(t4)
	addi t0, t0, 4
	blt t0, t2, copy_word
	
prep:
	add t4, a0, t0
	la t6, copy_bytes
	add t6, t6, t3
	jr t6
copy_bytes:
	sb t5, 2(t4)
	sb t5, 1(t4)
	sb t5, 0(t4)
	
end:
	ret
	
.data	
arr:
.space 65536
