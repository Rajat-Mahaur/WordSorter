		.text
		.extern	compare		@to call sorting program for two programs
		.global	comparelist,final,pointstar,finalnon		@did comparelist label global to called by mergesort
comparelist:	ldr	r11,[sp],#4		@extracting parameters from stack	r11= string of address of second string list
		ldr 	r7,[sp],#4		@r7= number of string in second string list
		ldr	r10,[sp],#4		@r10= string of address of first string list
		ldr 	r4,[sp],#4		@r4= number of string in first string list
		ldr	r12,=pointstar		@pointstar assign the position in final where this list merged list from these two sorted list will store
		ldr	r12,[r12]
		sub	sp,sp,#16
		str	lr,[sp,#-4]!		@pushing lr into stack
loop:		ldr	r2,[r10]		@This works for creating duplicated sorted list... loading addresses of strings to be compared at a time
		ldr	r3,[r11]
		bl 	compare
		ldr	r2,[r10]
		ldr	r3,[r11]
		cmp 	r6,#0
		strlt	r2,[r12],#4		@if first string is lesser than then doing appropriate increments in memory 
		addlt	r10,r10,#4
		sublt	r4,r4,#1
		cmp 	r6,#0
		addge	r11,r11,#4		@if first string is greater than or equal to then doing appropriate increments in memory, this point creates a duplicated list
		strge	r3,[r12],#4
		subge	r7,r7,#1
		cmp	r7,#0			@if one of the list ie second list finishes it branches to position to check other list is finished traversing
		beq	m
		cmp	r4,#0			@if one of the list ie first list finishes it branches to position to check other list is finished traversing
		beq	n
		b	loop
m:		cmp	r4,#0
		beq	end			@in case both finishes at the same time then branch to end and checks for duplicacy condition
loopnew1:	ldr	r0,[r10],#4		@push all other leftover strings in first string list into our final merged list
		str	r0,[r12],#4
		sub	r4,r4,#1
		cmp	r4,#0
		bne	loopnew1
		beq	end
n:		cmp	r7,#0
		beq	end
loopnew2:	ldr	r0,[r11],#4		@push all other leftover strings in second string list into our final merged list
		str	r0,[r12],#4
		sub	r7,r7,#1
		cmp	r7,#0
		bne	loopnew2
		
end:		ldr	r8,=pointstar		@assigning the pointstar the value where the we finished storing the merged list in final
		ldr	r4,[r8]
		str	r12,[r8]
		ldr	r0,[sp,#8]!		@load seperate list length
		ldr	r8,[sp,#8]!
		sub	sp,sp,#16
		add	r8,r0,r8		@r7=total strings in both first and second string list
		str	r8,[sp,#-4]!		@stack top has final number of strings in sorted merged list returned as output

		ldr	lr,[sp,#4]		@move back to main program
		mov	pc,lr

		.data
pointstar:	.word	0
final:		.space	900
finalnon:	.space	900

