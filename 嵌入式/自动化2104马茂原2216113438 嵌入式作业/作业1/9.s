ldr r2,[fp,#-24]
ldr r3,[fp,#-28]
add r2,r2,r3
ldr r3,[fp,#-32]
rsb r3,r3,r2
str r3,[fp,#-36]
ldr r2,[fp,#-28]
ldr r3,[fp,#-32]
add r2,r2,r3
ldr r3,[fp,#-24]
mul r3,r2,r3
str r3,[fp,#-40]
ldr r3,[fp,#-24]
mov r2,r3,asl #2
ldr r3,[fp,#-28]
and r3,r3,#15
orr r3,r2,r3
str r3,[fp,#-44]
