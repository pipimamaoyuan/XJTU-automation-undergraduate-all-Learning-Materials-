; loop initiation code
MOV r0,#0 ; use r0 for I
MOV r8, #0 ; use separate index for arrays
ADR r2, N ; get address for N
LDR r1,[r2] ; get value of N
MOV r2,#0 ; use r2 for f
ADR r3, c ; load r3 with base of c 
ADR r5, x ; load r5 with base of x
; loop body
loop LDR r4, [r3,r8]; get c[l]
LDR r6,[r5,r8]; get x[i]
MUL r4, r4,r6 ; compute c[i]*¡Á[i]
ADD r2, r2, r4 ; add into running sum 
ADD r8, r8, #4 ; add one word offset 
ADD r0, r0, #1; add 1 to i
CMP r0, r1 ¡¤ÂÞexit?
BLT loop ;if i<N,continue