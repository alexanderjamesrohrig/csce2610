	.data // DATA
	.text // PROGRAM
	.global main
	.arch armv8-a+fp+simd
	.type main, %function
	.type ackermann, %function

// PROGRAM 3
main:
	mov x0, #2 // m
	mov x1, #2 // n
	mov x2, #0 // return
	bl ackermann
	bl exit

ackermann:
	cmp x0, #0 // if m == 0
	b.gt c2
	add x2, x1, #1 // return n + 1
	br x30
c2:
	sub sp, sp, #16
	stur x0, [sp, #8]
	stur x30, [sp, #0]
	cmp x1, #0 // if n == 0
	b.gt c3
	sub x0, x0, #1 // m = m - 1
	mov x1, #1 // n = 1
	bl ackermann
	ldur x0, [sp, #8]
	ldur x30, [sp, #0]
	add sp, sp, #16
	br x30
c3:
	sub x1, x1, #1
	bl ackermann
	ldur x0, [sp, #8]
	sub x0, x0, #1
	mov x1, x2
	bl ackermann
	ldur x0, [sp, #8]
	ldur x30, [sp, #0]
	add sp, sp, #16
	br x30
exit:
