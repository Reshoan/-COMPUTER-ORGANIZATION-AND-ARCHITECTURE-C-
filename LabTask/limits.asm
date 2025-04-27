.MODEL SMALL          ; Use SMALL memory model (1 code, 1 data segment)
.STACK 100H           ; Define stack size (256 bytes)

.DATA                 ; Start of data segment
    MSG1 DB 'ENTER LOWER LIMIT: $'     ; Message to ask for lower limit
    MSG2 DB 'ENTER UPPER LIMIT: $'     ; Message to ask for upper limit
    MSG3 DB 'ENTER NUMBER: $'          ; Message to ask for the number to check
    LOWER DB ?                         ; Variable to store LOWER limit
    UPPER DB ?                         ; Variable to store UPPER limit
    NUM DB ?                           ; Variable to store entered number
    MSG4 DB 'INSIDE$'                  ; Message for number inside the range
    MSG5 DB 'OUTSIDE$'                 ; Message for number outside the range

.CODE                ; Start of code segment

MAIN PROC            ; Define main procedure
    MOV AX, @DATA    ; Load the address of data segment into AX
    MOV DS, AX       ; Initialize DS register (needed to access data variables)

    ; Prompt for LOWER LIMIT
    LEA DX, MSG1     ; Load address of MSG1 ("ENTER LOWER LIMIT:") into DX
    MOV AH, 9        ; Set DOS function 9h (Display String)
    INT 21H          ; Call DOS interrupt to display the message

    MOV AH, 1        ; Set DOS function 1h (Read character from keyboard)
    INT 21H          ; Call DOS interrupt to get input character (ASCII) into AL
    SUB AL, 30H      ; Convert ASCII digit to numeric value (e.g., '5' -> 5)
    MOV LOWER, AL    ; Store the value into LOWER

    ; New Line (formatting)
    MOV AH, 2        ; Set DOS function 2h (Display single character)
    MOV DL, 10       ; Line Feed (LF)
    INT 21H          ; Print LF
    MOV DL, 13       ; Carriage Return (CR)
    INT 21H          ; Print CR (creates a new line)

    ; Prompt for UPPER LIMIT
    LEA DX, MSG2     ; Load address of MSG2 ("ENTER UPPER LIMIT:") into DX
    MOV AH, 9        ; Set DOS function 9h
    INT 21H          ; Display message

    MOV AH, 1        ; Set DOS function 1h
    INT 21H          ; Read character into AL
    SUB AL, 30H      ; Convert ASCII to numeric
    MOV UPPER, AL    ; Store it into UPPER

    ; New Line
    MOV AH, 2        ; DOS function 2h
    MOV DL, 10       ; Line Feed
    INT 21H          ; Print LF
    MOV DL, 13       ; Carriage Return
    INT 21H          ; Print CR

    ; Prompt for NUM
    LEA DX, MSG3     ; Load address of MSG3 ("ENTER NUMBER:") into DX
    MOV AH, 9        ; Set DOS function 9h
    INT 21H          ; Display message

    MOV AH, 1        ; Set DOS function 1h
    INT 21H          ; Read character into AL
    SUB AL, 30H      ; Convert ASCII to numeric
    MOV NUM, AL      ; Store it into NUM

; Now Compare NUM with LOWER and UPPER (Exclusive Comparison)

DISPLAY:             
    MOV AL, NUM      ; Move NUM into AL for comparison
    MOV BL, LOWER    ; Move LOWER limit into BL
    CMP AL, BL       ; Compare AL (NUM) with BL (LOWER)

    JBE PRINT_OUTSIDE ; Jump if AL <= BL (NUM <= LOWER), meaning outside the range

    MOV BL, UPPER    ; Move UPPER limit into BL
    CMP AL, BL       ; Compare AL (NUM) with BL (UPPER)

    JAE PRINT_OUTSIDE ; Jump if AL >= BL (NUM >= UPPER), meaning outside the range    
    
    
    ; New Line
    MOV AH, 2        ; DOS function 2h
    MOV DL, 10       ; Line Feed
    INT 21H          ; Print LF
    MOV DL, 13       ; Carriage Return
    INT 21H          ; Print CR

    ; If control reaches here, NUM is between LOWER and UPPER exclusively
    LEA DX, MSG4     ; Load address of "INSIDE" message into DX
    MOV AH, 9        ; Set DOS function 9h
    INT 21H          ; Display "INSIDE"
    JMP EXIT_PROGRAM ; Jump to exit program

PRINT_OUTSIDE: 

    ; New Line
    MOV AH, 2        ; DOS function 2h
    MOV DL, 10       ; Line Feed
    INT 21H          ; Print LF
    MOV DL, 13       ; Carriage Return
    INT 21H          ; Print CR
    
    ;Print outside
    LEA DX, MSG5     ; Load address of "OUTSIDE" message into DX
    MOV AH, 9        ; Set DOS function 9h
    INT 21H          ; Display "OUTSIDE"

EXIT_PROGRAM:
    MOV AH, 4CH      ; DOS function 4Ch (Terminate program)
    INT 21H          ; Call DOS interrupt to return to DOS

MAIN ENDP            ; End of main procedure
END MAIN             ; End of program and mark MAIN as entry point
