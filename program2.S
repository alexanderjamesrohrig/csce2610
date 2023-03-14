	.data
	.type v, %object
	.size v, 3
v:
	.xword 1, 4, 6, 7, 0
	.text
	.global main
	.arch armv8-a+fp+simd
	.type main, %function

main:
	MOV X2, #0 // X2 = 0 EVEN COUNT
	ADR X10, v // X10 = V
	MOV X11, #0 // V INDEX
loop:
	LDR X12, [X10, X11] // X12 = V[X11]
	CBZ X12, exit // IF X12 == 0 EXIT
	TST X12, #1 // IF X12 IS ODD
	BNE odd // GO TO ODD
	ADD X2, X2, X12 // X2 += X12
odd:
	ADD X11, X11, #8 // V INDEX + 1
	B loop // GO TO LOOP
exit:
