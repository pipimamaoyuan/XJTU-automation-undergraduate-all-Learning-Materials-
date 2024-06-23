ADR r4, a ; get address for a
LDR r0, [r4] ; get value of a
ADR r4, b ; get address for b
LDR r1,[r4] ; get value for b
CMP r0,r1 ; compare a < b
BGE fblock ; if a >= b, branch to false block; true block
MOV r0, #5 ; generate value for x
ADR r4£¬x ; get address for x
STR r0, [r4] ;store x
ADR r4£¬ C ; get address for c
LDR r0£¬ [r4] ;get value of c
ADR r4,d;get address for d
LDR r1,[r4]; get value of d
ADD r0, r0, r1 ; compute y
ADR r4, y ;get address for y
STR r0, [r4] ; store y
B after ;branch around false block; false block
fblock ADR r4, c ; get address for c 
LDR r0, [r4] ; get value of c
ADR r4, d ; get address for d 
LDR r1, [r4] ; get value for d
SUB r0, r0, r1 ; compute a-b
ADR r4, x ;get address for x
STR  r0, [r4] ;store value of X
after
; true block
MOVLT r0, #5 ; generate value for x
ADRLT r4, X ; get address for x
STRLT r0, [r4] ; store X
ADRLT r4, C ; get address for c
LDRLT r0, [r4] ; get value of c
ADRLT r4, d ; get address for d
LDRLT r1£¬ [r4] ; get value of d
ADDLT r0, r0,r1 ; compute y
ADRLT r4, y ; get address for y
STRLT r0, [r4] ; store y