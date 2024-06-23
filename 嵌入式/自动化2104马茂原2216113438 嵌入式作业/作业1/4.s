ADR r4, b ; get address for b
LDR r0, [r4] ; get value of b
ADR r4, c ;get address for c
LDR r1,[r4] ;get value of c
ADD r2, r0, r1 ; compute partial result
ADR r4, a ; get address for a
LDR r0, [r4] ;get value of a
MUL r2, r2, ro ; compute final value for y
ADR r4, y ;get address for y
STR r2, [r4] ;store y
