.MODEL SMALL             ; Use the SMALL memory model: 1 code segment and 1 data segment
.STACK 100H              ; Reserve 256 bytes (100h) for the stack

.DATA                    ; Start of data segment
    MSG1 DB 'ENTER A NUMBER: $'             ; Message prompting user for first number
    MSG2 DB 'ENTER ANOTHER NUMBER: $'       ; Message prompting user for second number
    MSG3 DB 'ASCENDING ORDER: $'            ; Message shown before displaying numbers in ascending order
    NUM1 DB ?                               ; Variable to store first number (input by user)
    NUM2 DB ?                               ; Variable to store second number (input by user)

.CODE                    ; Start of code segment

MAIN PROC                ; Define the main procedure (program starts here)
    MOV AX, @DATA        ; Load address of data segment into AX
    MOV DS, AX           ; Move AX to DS to initialize data segment register

    LEA DX, MSG1         ; Load effective address of MSG1 into DX
    MOV AH, 9            ; Set AH=9 to use DOS interrupt function to display a string
    INT 21H              ; Call DOS interrupt to display 'ENTER A NUMBER:'

    MOV AH, 1            ; Set AH=1 to read a single character input from the user
    INT 21H              ; Call DOS interrupt to get a character from keyboard into AL
    SUB AL, 30H          ; Convert ASCII character in AL to its decimal equivalent (0-9)
    MOV NUM1, AL         ; Store the numeric value in NUM1

    MOV AH, 2            ; Set AH=2 to display a character (used for formatting)
    MOV DL, 10           ; Load Line Feed character (LF) into DL
    INT 21H              ; Call DOS interrupt to print LF
    MOV DL, 13           ; Load Carriage Return character (CR) into DL
    INT 21H              ; Call DOS interrupt to print CR (newline effect)

    LEA DX, MSG2         ; Load effective address of MSG2 into DX
    MOV AH, 9            ; Set AH=9 to display a string
    INT 21H              ; Call DOS interrupt to display 'ENTER ANOTHER NUMBER:'

    MOV AH, 1            ; Set AH=1 to read a single character input
    INT 21H              ; Call DOS interrupt to get a character from user
    SUB AL, 30H          ; Convert ASCII character to decimal
    MOV NUM2, AL         ; Store second number into NUM2

    MOV AL, NUM1         ; Load NUM1 into AL for comparison
    MOV BL, NUM2         ; Load NUM2 into BL for comparison
    CMP AL, BL           ; Compare NUM1 (AL) with NUM2 (BL)
    JG SWAP_NUMS         ; Jump to SWAP_NUMS if NUM1 > NUM2 to swap them
    
    JMP DISPLAY          ; Otherwise, proceed to display the numbers

SWAP_NUMS:               ; Procedure to swap NUM1 and NUM2
    MOV AL, NUM1         ; Load NUM1 into AL
    MOV BL, NUM2         ; Load NUM2 into BL
    MOV NUM1, BL         ; Store BL (original NUM2) into NUM1
    MOV NUM2, AL         ; Store AL (original NUM1) into NUM2
    JMP DISPLAY          ; After swapping, proceed to display

DISPLAY:                 ; Procedure to display numbers in ascending order

    MOV AH, 2            ; Set AH=2 to print a character (formatting)
    MOV DL, 10           ; Load Line Feed (LF) into DL
    INT 21H              ; Call interrupt to print LF
    MOV DL, 13           ; Load Carriage Return (CR) into DL
    INT 21H              ; Call interrupt to print CR (newline effect)

    LEA DX, MSG3         ; Load effective address of MSG3 into DX
    MOV AH, 9            ; Set AH=9 to display a string
    INT 21H              ; Call DOS interrupt to display 'ASCENDING ORDER:'

    MOV DL, NUM1         ; Load the first number from memory into DL
    ADD DL, 30H          ; Convert decimal value to ASCII by adding 30h
    MOV AH, 2            ; Set AH=2 to print a character
    INT 21H              ; Call DOS interrupt to print the ASCII digit

    MOV DL, ' '          ; Load a space character into DL for separation
    MOV AH, 2            ; Set AH=2 to print a character
    INT 21H              ; Call DOS interrupt to print the space

    MOV DL, NUM2         ; Load the second number from memory into DL
    ADD DL, 30H          ; Convert decimal value to ASCII by adding 30h
    MOV AH, 2            ; Set AH=2 to print a character
    INT 21H              ; Call DOS interrupt to print the ASCII digit

    MOV AH, 4CH          ; Set AH=4Ch to terminate the program
    INT 21H              ; Call DOS interrupt to return control to DOS

MAIN ENDP                ; End of MAIN procedure
END MAIN                 ; Mark MAIN as the program entry point
