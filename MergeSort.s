		.text
		.extern	comparelist		@so that it can be called by main program(stage3main)
		.global comparesortlist		@comparesortlist will merged any two sorted list in sorted manner without removing duplicates
comparesortlist:	ldr	r1,=link	@saving the lr register in memory
		str	lr,[r1]			
		ldr	r2,=pointstar		@pointstar tells the point from where the new sorted string list willl be saved
		ldr	r3,=final		@initially final will be the storing address for start
		str	r3,[r2]
putstart:	ldr	r2,=size		@Retreiving the total number of strings from size memory
		ldr	r2,[r2]
		ldr	r3,=storestarts		@storestarts store the number of strings foloowed by address of the list containing starting sddress of unsorted list
		ldr	r4,=firststringadd	@storing individual strings with their number of strings as "1", account for the fact that dividing of the strings in halves
loop1:		mov	r6,#1			@number of strings=1
		str	r6,[r3]
		add	r3,r3,#4
		str	r4,[r3]
		add	r3,r3,#4
		add	r4,r4,#4
		sub	r2,r2,#1
		cmp	r2,#0
		bne	loop1			@will go back unless all the strings are not saved that is marked by decrementing r2 having initially value of total number of strings
		ldr	r4,=savehere		@savehere is the pointer describing where to put the new sorted list's number of strings and its pointer
		str	r3,[r4]			@here it is where the saving of individual strings ended
		
		ldr	r1,=storestarts		@start comparing the strings by sending the address of the list containing the starting address of sorted strings, individual strings are sorted
		ldr	r2,=placenew		@placenew is the pointer to the point where it needs to start reading the storestars
		str	r1,[r2]
loop2:		ldr	r1,=placenew
		ldr	r2,[r1]
		ldr	r9,[r2]
		str	r9,[sp,#-4]!		@push the number of strings in the first sorted list this time
		add	r2,r2,#4
		ldr	r9,[r2]
		str	r9,[sp,#-4]!		@push the address of the first list containing the addresses of the strings in sorted order this time
		add	r2,r2,#4
		ldr	r9,[r2]
		str	r9,[sp,#-4]!		@push the number of strings in the second sorted list this time
		add	r2,r2,#4
		ldr	r9,[r2]
		str	r9,[sp,#-4]!		@push the address of the first list containing the addresses of the strings in sorted order this time
		add	r2,r2,#4
		str	r2,[r1]
		bl	comparelist		@compare these two list and save the address of new sorted list containing the starting address of strings sorted got by merging the above two
		ldr	r3,=savehere		@new place in sortedstarts where the thenumber of strings in merged sorted list followed by the address of this list is saved
		ldr	r6,[r3]
		str	r8,[r6]
		str	r4,[r6,#4]!
		add	r6,r6,#4
		str	r6,[r3]
		ldr	r7,=size		@if the number of strings in this merged list equal to total number of strings in out imput unsorted list, then all strings are processed and sorted hence break the loop
		ldr	r7,[r7]
		cmp	r8,r7			@r4= number of strings in fukly merged sorted list = size memory, r8 = address of the list containing the starting adddress of the strings which are sorted
		bne	loop2			@break loop if all strings are processed
		
dupli:		ldr	r0,=duplicon		@check duplicon memory
		ldrb	r0,[r0]			@r0 = "0"(non duplicacy) or "1"(duplicacy)
		cmp	r0,#'0
		bne	backtomain		@if duplicated then go to "backtomain" label and print the list conataining duplicated and sorted lists
		
		str	r8,[sp,#-4]!		@push total number of strings into stack ie value at size memory
		ldr	r12,=finalnon		@final list output based on duplicacy or not finalnon will contain non duplicated lists
		ldr	r2,[r4]
		str	r2,[r12]
loopfinal:	ldr	r2,[r4],#4		@else remove duplicates by comparing two adjacent lists in our final list
		ldr	r3,[r12]
		mov	r0,r2			@r0=list now in consideration
		mov	r1,r3			@r1=next list compared with r0 
		bl	compare
		ldreq	r8,[sp]			@due to lack of registers r8 captures the points that it is popped decremented and pushed back everytime the string is equal to adjacent one
		subeq	r8,r8,#1
		streq	r8,[sp]
		cmp	r6,#0
		strne	r0,[r12,#4]!		@if they are not equal then store else skip 
		subeq	r11,r11,#1
		sub	r7,r7,#1		@r7=numbersof strings processed while checking for equality, initially having value at size
		cmp 	r7,#0			
		bne	loopfinal		@if all strings are not processed then loop
		ldr	r4,=finalnon		@finalnon has no duplicate strings
		ldr	r8,[sp]			@pushes final number of strings in stack
		add	r8,r8,#1
		str	r8,[sp]


backtomain:	ldr	r1,=link		@load the link value that branching link from where we called this merge sort and load into pc
		ldr	pc,[r1]			@back to main program for printing the sorted list


		.data
storestarts:	.space	900
savehere:	.word	0
link:		.word	0
placenew:	.word	0