# This program is a naive version of memset that writes one byte at a time and loops with a counter.
# The loop takes 4 instructions and writes 1 byte. So it writes 0.25 bytes per cycle.

.globl _start
_start:
	la a0, arr
	li a1, 65
	li a2, 8192
	call memset

	li a0, 1
	la a1, arr
	li a2, 1
	li a7, 64
	ecall

	li a7, 93
	ecall

memset:
	li t0, 0
	blez a2, end
loop:
	add t1, a0, t0
	sb a1, 0(t1)
	addi t0, t0, 1
	blt t0, a2, loop
end:
	ret
	
.data	
arr:
.space 65536
