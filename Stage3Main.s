	.text
	.extern	comparesortlist				@to call the comaparesortlist label
	.global	fs,size,firststringadd,duplicon		@all declared public so as they can be used by the other modules
main:	mov 	r0,#0x05		@input the mode ie case insensitive or case sensitive
	ldr	r1,=mode
	swi	0x123456
	mov 	r0,#0x06
	ldr	r1,=modin
	swi	0x123456
	ldr	r5,=m 			@dummychar having that value of mode
	ldrb	r5,[r5]
	cmp	r5,#'0
	moveq	r5,#0
	movne	r5,#1			@assigning the value in int on comparison
	str	r5,[sp,#-4]!		@push value  in stack

	mov 	r0,#0x05		@ask if required a list having duplicates or no duplicates
	ldr	r1,=dupliask
	swi	0x123456
	mov 	r0,#0x06
	ldr	r1,=modin
	swi	0x123456
	ldr	r9,=m			@dummychar has the duplicacy condition
	ldrb	r9,[r9]
	cmp	r9,#'0
	ldr	r0,=duplicon		@saving this value in memory
	strb	r9,[r0]
	

	mov 	r0,#0x05		@input the first string list
	ldr	r1,=firststringin
	swi	0x123456
	ldr 	r2,=fs
	ldr	r6,=firststringadd	@string that will contain thestarting addresses
	str	r2,[r6],#4
	mov	r7,#1
loop1:	ldr	r1,=dummy		@loop taking character by character and thus forming a large string in which seperate strings are sepersted by null charcter
	mov 	r0,#0x06
	swi	0x123456
	ldr	r0,=dummychar
	ldrb	r3,[r0]
	cmp	r3,#32
	moveq	r3,#0x00
	addeq	r7,r7,#1
	strb	r3,[r2],#1
	streq	r2,[r6],#4
	cmp	r3,#0x0d
	bne	loop1	
	mov	r3,#0x00
	strb 	r3,[r2,#-1]!
	ldr	r9,=size		@saving total number of strings in size memory
	str	r7,[r9]
	str	r7,[sp,#-4]!		@puttingnumber of strings in stack	
	ldr	r2,=firststringadd
	str	r2,[sp,#-4]!		@putting the address into stack

	cmp	r7,#1			@base case if only 1 element than direclty output that by brancing to print function
	mov	r4,r2
	mov	r8,r7
	blne	comparesortlist		@compares the lists and create a merged list and the list is stored in r4

	mov 	r0,#0x05		@output the sorted merged list
	ldr	r1,=outputfinal
	swi	0x123456
	mov	r9,r8			@r9=total strings returned poped from stack
test:	ldr	r2,[r4]			@takes a string address at a time 
prt:					@prints all characters till null character in the string whose address is in consideration right now
	ldrb	r3,[r2]
	cmp	r3,#0x00
	moveq	r3,#0x20
	ldr	r6,=dummychar	
	strb	r3,[r6]
	mov	r0,#0x05
	ldr	r1,=dummy
	swi	0x123456
	moveq	r3,#0x00
	add	r2,r2,#1
	cmp	r3,#0x00
	bne	prt
	add	r4,r4,#4
	sub	r9,r9,#1
	cmp	r9,#0x00	
	bne 	test			@loop test if r9 is not zero or all lists in sorted merged list are not printed 
	mov	r0,#0x18		@end program
	swi	0x123456




	.data
dummy:		.word	0
		.word	dummychar
		.word	1
modin:		.word 	0
		.word	m
		.word	1
mode: 		.word	0
		.word	out1
		.word	65
dupliask: 	.word	0
		.word	out2
		.word	61
firststringin:	.word	0
		.word	out3
		.word	109
outputfinal:	.word	0
		.word	out5 
		.word	40
fs:	.skip	900
firststringadd:	.skip	200
size:	.skip	4
m:	.skip	1
dummychar:	.skip	1
duplicon:	.skip	1
out5:	.ascii	"\nThe final merged sorted string list is\n" 
out1: 	.ascii "Enter the mode 0 for non case sensitive and 1 for case sensitive\n"
out2: 	.ascii "\nEnter the mode 0 for non case duplicacy and 1 for duplicacy\n"
out3:	.ascii	"\nEnter the string list seperated by whitespace in between each string and press enter when finished entering\n"
