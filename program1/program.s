	.data
	.type	v, %object
	.type 	n, %object
	.size	v, 7
	.size 	n, 1
v:	.xword 79, 55, 94, 48, 19, 13, 45, 2, 3, 99
n:	.xword 10
	.text
	.global main
	.global swap
	.global findLargest
	.global findSmallest
	.arch armv8-a+fp+simd
	.type	main, %function
	.type	swap, %function
	.type	findLargest, %function
	.type	findSmallest, %function

//
// x0 i
// x1
// x2 v
// x3 n
// x4 largest value
// x5 largest index
//

main:
	MOV X0, #0 // i x0 = 0
	ADR X2, v // v
	ADR X3, n // n
	LDUR X3, [X3, #0] // x3 = n
//	LDUR x4, [x2, #0] // x4 = v[0]

mainLoop: CMP X0, X3 // compare x0 x3
	B.GE exit
	BL findSmallest
	//mov x1, x0
	BL swap
	BL findLargest
	//mov x1, x3
	bl swap

//	LSL x4, x0, #3
//	ADD x4, x4, x2
//	LDUR x5, [x4, #0]

	SUB x3, x3, #1 // n--
	ADD x0, x0, #1 // i++
	B mainLoop
exit:
//	LDUR X4, [X2, #0] // x4 = v[0]
//
//	CMP X1, X4 // compare x1 x4
//	B.LE else1
//	else1: LDUR x11, [X4, #0] // x11 = x4
//
//	CMP X1, X4 // compare x1 x4
//	B.GE else2
//	else2: LDUR x12, [x4, #0] // x12 = x4

findSmallest:
	mov x1, x0
	sub sp, sp, #16
	stur x0, [sp, #0]
	stur x3, [sp, #8]
	lsl x10, x0, #3
	add x10, x10, x2
	ldur x4, [x10, #0]
	mov x5, x0
loopSmall:
	ldur x9, [x10, #0]
	cmp x9, x4
	b.ge sks
	mov x4, x9
	mov x5, x0
sks:
	add x0, x0, #1
	add x10, x10, #8
	cmp x0, x3
	b.lt loopSmall
	ldur x0, [sp, #0]
	ldur x3, [sp, #8]
	br x30

findLargest:
	mov x1, x3
	SUB SP, SP, #16 // reset stack
	STUR x0, [SP, #0] // stack[0] = i
	STUR x3, [SP, #8] // stack[1] = n
	LSL x10, x0, #3 // i * 8
	add x10, x10, x2 // v[i]
	ldur x4, [x10, #0] // largest value = v[i]
	mov x5, x0 // largest index = i
loopLarge:
	ldur x9, [x10, #0] // x9 = v[+1]
	cmp x9, x4 // v[+1] le largest value
	b.le skl
	mov x4, x9 // largest val = x9
	mov x5, x0 // largest ind = i
skl:
	add x0, x0, #1 // i++
	add x10, x10, #8
	cmp x0, x3 // i lt n
	b.lt loopLarge
	ldur x0, [SP, #0] // i = stack[0]
	ldur x3, [SP, #8] // n = stack[1]
	br x30 // return

swap:
	lsl x13, x1, #3
	add x13, x13, x2 // address of v[i]
	ldur x11, [x13, #0] // x11 = v[i]

	lsl x10, x5, #3
	add x10, x10, x2 // address of v[swapIndex]
	ldur x12, [x10, #0] // x12 = v[swapIndex]

	stur x12, [x13, #0]
	stur x11, [x10, #0]

	br x30
error:
	// error
