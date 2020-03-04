; Encryption Algorithm
; author: Erick Andres Obregon Fonseca
; course: Computer Architecture I
; year: Semestre I, 2020


; Needed values
MOV     R0, #0x072                  ; seed = 0x072
MOV     R1, #0x200                  ; Base address for random number, address_rn = 0x200
MOV     R2, #0x250                  ; Base address for characters
MOV     R4, R0                      ; num = seed
MOV     R8, #0x014                  ; num_counter = 20
B       RANDOM                      ; RANDOM()		

; LFSR Algorithm
LFSR                                ; LFSR(num=R4)
        MOV     R7, R4              ; copy = num
        AND     R5, R4, #0x001      ; Save Bit8
        LSR     R4, R4, #0x002      ; Bit6
        AND     R6, R4, #0x001      ; Save Bit6
        EOR     R5, R5, R6          ; result = Bit8 ^ Bit6
        LSR     R4, R4, #0x001      ; Bit5
        AND     R6, R4, #0x001      ; Save Bit5
        EOR     R5, R5, R6          ; result = (Bit8 ^ Bit6) ^ Bit5
        LSR     R4, R4, #0x001      ; Bit4
        AND     R6, R4, #0x001      ; Save Bit4
        EOR     R5, R5, R6          ; result = (Bit8 ^ Bit6 ^ Bit5) ^ Bit4
        LSL     R5, R5, #0x007      ; result = result << 8
        LSR     R7, R7, #0x001      ; copy = copy >> 1
        ADD     R7, R5, R7          ; copy = result + copy
        STR     R7, [R1]            ; Save in memory
        B       NEXTR

RANDOM                              ; RANDOM()
        B       LFSR                ; LFSR(num)

NEXTR                               ; Next random number
        ADD     R1, R1, #0x004      ; address_rn += 4
        MOV     R4, R7              ; num = copy
        SUBS    R8, R8, #0x001      ; num_counter--;
        BNE     RANDOM              ; while (num_counter > 0)

        MOV     R1, #0x200          ; Restart memory address

        ; Write Claude Shannon in memory
        MOV     R4, #0x320          ; String length memory address
        MOV     R5, #0x00E          ; String length
        STR     R5, [R4]            ; Save in memory

        MOV     R3, #0x0E3          ; C
        STR     R3, [R2]
        ADD     R2, R2, #0x004
        MOV     R3, #0x05F          ; l
        STR     R3, [R2]
        ADD     R2, R2, #0x004
        MOV     R3, #0x096          ; a
        STR     R3, [R2]
        ADD     R2, R2, #0x004
        MOV     R3, #0x0FB          ; u
        STR     R3, [R2]
        ADD     R2, R2, #0x004
        MOV     R3, #0x0C0          ; d
        STR     R3, [R2]
        ADD     R2, R2, #0x004
        MOV     R3, #0x0A1          ; e
        STR     R3, [R2]
        ADD     R2, R2, #0x004
        MOV     R3, #0x059          ; space
        STR     R3, [R2]
        ADD     R2, R2, #0x004
        MOV     R3, #0x05D          ; S
        STR     R3, [R2]
        ADD     R2, R2, #0x004
        MOV     R3, #0x0E4          ; h
        STR     R3, [R2]
        ADD     R2, R2, #0x004
        MOV     R3, #0x0B5          ; a
        STR     R3, [R2]
        ADD     R2, R2, #0x004
        MOV     R3, #0x063          ; n
        STR     R3, [R2]
        ADD     R2, R2, #0x004
        MOV     R3, #0x076          ; n
        STR     R3, [R2]
        ADD     R2, R2, #0x004
        MOV     R3, #0x0FF          ; o
        STR     R3, [R2]
        ADD     R2, R2, #0x004
        MOV     R3, #0x039          ; n
        STR     R3, [R2]
        MOV     R2, #0x0250         ; Restart memory address

        LDR     R3, [R4]            ; length = len(string)
        MOV     R4, #0x017          ; key = 23
        MOV     R8, #0x400          ; Memory address to write decoded name

; Decryption Algorithm
DECRYPT                             ; decrypt(string, key)
        LDR     R5, [R2]            ; char = string[i]
        LDR     R6, [R1]            ; num = random_numbers[i]
        EOR     R5, R5, R6          ; char = char XOR num
        SUBS    R5, R5, R4          ; char = char - key
        STR     R5, [R8]            ; Save in memory
        ADD     R1, R1, #0x004      ; Next random number
        ADD     R2, R2, #0x004      ; Next char
        ADD     R8, R8, #0x004      ; Next memory address to write
        SUBS    R3, R3, #0x001      ; length--
        CMP     R3, #0x000          ; while (length != 0)
        BNE     DECRYPT
