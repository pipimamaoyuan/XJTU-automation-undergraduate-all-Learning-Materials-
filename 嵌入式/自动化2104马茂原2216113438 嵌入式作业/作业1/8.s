HexOut	STMED r13!,{r0-r2}
		MOV r2,#8
Loop	MOV r0,r1,LSR #28
		CMP r0,#9
		ADDLE r0,r0,#"0"
		ADDGT r0,r0,#"A"-10
		SWI SWI_WriteC
		MOV r1,r1,LSL#4
		SUBS r2,r2,#1
		BNE Loop
		LDMED r13!,{r0-r2}
		MOV pc,r14
		END