	.global main
	.arch armv8-a+fp+simd
	.type main, %function
	.type insert, %function
	.type delete, %function
	.type traverse, %function
// NODE FORMAT
	.struct 0
	// NODE STRUCT
ListNode:
	value: .hword 0 // 2 bytes
	link: .quad 0 // 8 bytes
	.equ NodeSize, .-ListNode
.data
// THE LIST
Head: .quad 0
// NODE MEMORY
Nodes: .skip 100 * NodeSize
FreePtr: .quad Nodes
.equ OutputSize, 100
Output: .skip OutputSize * 2
.text
main:
	// NODE:
	// 0x 0000 0000 0000 0000 0000
	//    valu ...............link
	//    2    8
	//    80 bits
	//    10 bytes
	//
	// x9-x15 saved by caller
	// x19-x29 restored by function
	adr x2, Head // x2 = address of Head
	adr x3, FreePtr // x3 = address of FreePtr
	adr x1, Nodes // x1 = address of Nodes buffer

	// bl allocate

	mov x0, 0x1111
	bl insert
	mov x0, 0x2222
	bl insert
	mov x0, 0x3333
	bl insert
	mov x0, 0x4444
	bl insert
	mov x0, 0x2222
	bl delete
	bl traverse
end:
	b end
insert: // input 2 byte value, return 8 byte head address
	// mov x19, x0
	ldr x19, [x2] // x9 = head
	cmp x19, #0 // if x19 == 0
	b.eq insert_first
	ldr x20, [x19] // x20 = head
	mov x29, x20 // x29 = x20
	loop:
		ldr x21, [x20, value] // x21 = x20.value
		ldr x22, [x20, link] // x22 = x20.link
		cmp x22, #0 // if x22 == 0
		b.eq insert_end
		b loop
	insert_first:
		mov x19, x0 // x19 = value
		mov x20, 0x0000000000000000 // x20 = null link
		ldr x21, [x3] // x21 = FreePtr
		str x19, [x21, value] // x21.value = x19
		str x20, [x21, link] // x21.link = x20
		str x21, [x2] // Head = FreePtr
		add x22, x21, #10 // x22 = FreePtr + 10
		str x22, [x3] // FreePtr = x22
		ret // return
	insert_end:
		mov x19, x0 // x19 = value
		mov x20, 0x0000000000000000 // x20 = null link
		ldr x21, [x3] // x21 = FreePtr
		str x19, [x21, value]
		str x19, [x21, link]
		// PrevNode.link = FreePtr
		add x22, x21, #10 // FreePtr + 10
		str x22, [x3] // Store FreePtr
		ret // return
	// str x7, [x6] // FreePtr = next available node address
	// loop_1:
	// cmp x19, x20
	// b.lt insert_body
	// ldr x21, [x20, #2]
	// ldr x20, [x21]
	// b loop_1
	// insert_body:

delete: // input 2 byte value to delete, return 1 if found 0 if not
	mov x0, #0
traverse: // store in output buffer, end with 0000
	// adr x3, Head
	// ldur x3, [] // x3 = head of list
	mov x19, x3
	b while
while:
	mov x19, #0
	// ldur x10, [] // get next node
	// if null, endwhile
	// move next to current
endwhile:
	mov x19, x3 // return value in x0
	// br x30 // return

allocate: // opt
	ldr x19, [x3] // x19 = address of FreePtr
	mov x0, x19 // x0 = FreePtr
	add x20, x19, NodeSize // FreePtr += 10
	str x20, [x3] // FreePtr = x19
	ret
isempty: // opt
	ldr x19, [x2]
	cmp x19, #0
	b.eq true
	mov x0, x19
	ret
	true:
		mov x0, 0x0000000000000000
		ret
findnode: // opt
