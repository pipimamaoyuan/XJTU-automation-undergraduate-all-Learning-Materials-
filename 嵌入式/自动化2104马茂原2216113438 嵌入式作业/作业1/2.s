		AREA BlkCpy,CODE,READONLY
SWI_WriteC	EQU	&0
SWI_Exit	EQU &11
		ENTRY
START	ADR r1,TABLE1
		ADR r2,TABLE2
		ADR r3,T1END
LOOP1	LDR r0,[r1],#4
		STR r0,[r2],#4
		CMP r1,r3
		BLT LOOP1
		ADR r1,TABLE2
LOOP2 	LDRB r0,[r1],#1
		CMP r0,#0
		SWINE SWI_WriteC
		BNE LOOP2
		SWI SWI_Exit
TABLE1	=	"This is the right string!",&0a,&0d,0
T1END
		ALIGN
TABLE2	=	"This is the wrong string!",0
		END
