ldr r2,[fp,#-24]
ldr r3,[fp,#-28]
cmp r2,r3
ble .L2
.L2	mov r3,#5
	str r3,[fp,#-40]
	ldr r2,[fp,#-32]
	ldr r3,[fp,#-36]
	add r3,r2,r3
	str r3,[fp,#-44]
	b .L3
	ldr r3,[fp,#-32]
	ldr r2,[fp,#-36]
	rsb r3,r2,r3
	str r3,[fp,#-40]
.L3