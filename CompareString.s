	.global compare
	.text

compare:	ldrb r8,[r2]
		ldrb r9,[r3]	@loading the ascii values of characters in r8 and r9
		cmp r5,#0	@checking for non case sensitive or case sensitive
		beq nonconse	@branch if non case sensitive that is if it is 0
		cmp r8,r9	@setting vales accordingly
		movgt r6,#1
		movlt r6,#-1
		movne pc,lr	@if not equal then return back to main
		add r2,r2,#1
		add r3,r3,#1
		cmp r8,#0x00	@check for null as at this point if anyone of them is null then both will be null as pc here only when both are equal
		moveq r6,#0
		bne compare	@recursive branch
		mov pc,lr	@go back to main end of function

nonconse:	ldrb r8,[r2]
		ldrb r9,[r3]	@loading the ascii values of characters in r8 and r9
		cmp r8,#0x00	@checking null value
		cmpne r8,#91
		addlt r8,r8,#32
		cmpeq r9,#0x00	@checking null value
		cmpne r9,#91
		addlt r9,r9,#32
		cmp r8,r9	@compare the lowercases only
		movgt r6,#1	@set apropriate value of result register r6
		movlt r6,#-1
		movne pc,lr	@go back to main if done adjusting r6 less or greater
		add r2,r2,#1	@if equal then setting to higher letters
		add r3,r3,#1
		cmp r8,#0x00	@check for null character and if there then both are vanished and return to main by setting equal
		moveq r6,#0
		bne nonconse	@recursive branch
		mov pc,lr	@go back to main end of function
		

	.end