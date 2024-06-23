.LBB2:		
		mov r3,#0
		str r3,[fp,#-24]
		mov r3,#0
		str r3,[fp,#-28]
.L2:
		ldr r3,[fp,#-24]
		cmp r3,#7
		ble .L5
		b .L3
.L5:	ldr r3,[fp,#-24]
		mvn r2,#47
		mov r3,r3,asl #2
		sub r0,fp,#12
		add r3,r3,r0
		add r1,r3,r2
		ldr r3,[fp,#-24]
		mvn r2,#79
		mov r3,r3,asl #2
		sub r0,fp,#12
		add r3,r3,r0
		add r3,r3,r2
		ldr r2,[r1,#0]
		ldr r3,[r3,#0]
		mul r2,r3,r2
		ldr r3,[fp,#-28]
		add r3,r3,r2
		str r3,[fp,#-28]
		ldr r3,[fp,#-24]
		add r3,r3,r1
		str r3,[fp,#-24]
		b .L2
.L3:
		
		
			