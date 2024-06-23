ADR r4, a ;get address for a
LDR r0, [r4] ; get value of a
MOV r0, r0 LSL 2 ; perform shift
ADR r4, b ;get address for b
LDR r1, [r4] ; get value of b
AND r1, r1£¬#15 ; perform AND
ORR r1, r0, r1 ; perform OR
ADR r4, Z ; get address for z
STR r1,[r4] ;store value for z