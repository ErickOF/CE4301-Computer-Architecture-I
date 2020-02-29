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
		B		NEXTR

RANDOM							; RANDOM()
		B		LFSR				; LFSR(num)

NEXTR							; Next random number
		ADD		R1, R1, #0x004		; address_rn += 4
		MOV		R4, R7			; num = copy
		SUBS		R8, R8, #0x001		; num_counter--;
		BNE		RANDOM			; while (num_counter > 0)

		; Here when finish LFSR
		MOV		R5, #0x0F0		; Resquest value
		STR		R5, [R2]			; Store request value
		ADD		R2, R2, #0x004		; Next memory address, 0x304
		MOV		R5, #0x0FF		; Response value
		STR		R5, [R2]			; Store response value

		MOV		R1, #0x200		; Restart base address for random number
		MOV		R6, #0x014		; num_counter = 20

; R4 -> number
; R5 -> divider
; R8 -> division module
ISPRIME							; is_prime(random_numbers)
		CMP		R6, #0x000		; while (num_counter > 0)
		BEQ		FINISH			; Last step
		SUBS		R6, R6, #0x001		; num_counter -= 1
		LDR		R4, [R1]			; random_number = random_numbers.data()
		ADD		R1, R1, #0x004		; random_numbers = random_numbers.next()
		CMP		R4, #0x001		; Comparing with 1
 		BEQ		NOPRIME			; If equal, it's not a prime number
		MOV		R5, #0x001		; divider = 1

NEXTD							; Next divider
		ADD		R5, R5, #0x001		; divider += 1
		CMP		R4, R5			; if (num == divider)
		BEQ		PRIME			; prime number
		B		DIVIDE			; Continue dividing

CHECKD							; Check if it was divided
		CMP		R8, #0x000		; if (number % divider ==  0)
		BEQ		NOPRIME			; If equal then it's not a prime number
		B		NEXTD			; Repeats until end

DIVIDE							; divide(random_number, divider)
		MOV		R8, R4			; Copy of data
		MOV		R9, R5			; Copy of divider
		MOV		R10, #0x000		; result = 0

DIVISION							; Successive subtraction for division
		SUB 		R8, R8, R9		; number -= divider
		ADD		R10, R10, #0x001	; result += 1
		CMP		R8, R9			; Compares for non-zero result
		BPL		DIVISION			; Repeats the loop if subtraction is needed
		B		CHECKD			; Check division module

PRIME
		MOV		R7, #0x001		; prime = True
		B		SAVE				; Save value in memory

NOPRIME
		MOV		R7, #0x000		; prime = False
		B		SAVE				; Save value in memory

SAVE
		STR		R7, [R3]			; Save in memory
		ADD		R3, R3, #0x004		; Next memory address
		B 		ISPRIME			; Next random number

FINISH
		END
