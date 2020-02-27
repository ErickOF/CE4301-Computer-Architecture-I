; Fibonacci Linear Feedback Shift Register
; author:	Erick Andres Obregon Fonseca
; course:	Computer Architecture I
; year:	Semestre I, 2020

; Needed values
MOV		R0, #0x072				; seed = 0x072
MOV		R1, #0x200				; Base address for random number, address_rn = 0x200
MOV		R2, #0x300				; Base address for commands
MOV		R3, #0x400				; Base address for prime numbers
MOV		R4, R0	 				; num = seed
MOV		R8, #0x014				; num_counter = 20
B 		RANDOM					; RANDOM()		

LFSR								; LFSR(num=R4)
		MOV		R7, R4 			; copy = num
		AND		R5, R4, #0x001		; Save Bit8
		LSR		R4, R4, #0x002		; Bit6
		AND		R6, R4, #0x001		; Save Bit6
		EOR		R5, R5, R6		; result = Bit8 ^ Bit6
		LSR		R4, R4, #0x001		; Bit5
		AND		R6, R4, #0x001		; Save Bit5
		EOR		R5, R5, R6		; result = (Bit8 ^ Bit6) ^ Bit5
		LSR		R4, R4, #0x001		; Bit4
		AND		R6, R4, #0x001		; Save Bit4
		EOR		R5, R5, R6		; result = (Bit8 ^ Bit6 ^ Bit5) ^ Bit4
		LSR		R4, R4, #0x003		; Bit1
		AND		R6, R4, #0x001		; Save Bit1
		EOR		R5, R5, R6		; result = (Bit8 ^ Bit6 ^ Bit5 ^ Bit4) ^ Bit1
		LSL		R5, R5, #0x007		; result = result << 8
		LSR		R7, R7, #0x001		; copy = copy >> 1
		ADD		R7, R5, R7		; copy = result + copy
		STR		R7, [R1]			; Save in memory
		B		NEXT

RANDOM							; RANDOM()
		B		LFSR				; LFSR(num)
NEXT
		ADD		R1, R1, #0x004		; address_rn += 4
		MOV		R4, R7			; num = copy
		SUBS		R8, R8, #0x001		; num_counter--;
		BNE		RANDOM			; while (num_counter > 0))


