.MODEL SMALL          
.STACK 100H            ; Define stack size (256 bytes)

.DATA                  
    MSG1 DB 'ENTER SIGNED NUMBER: $'  ; Message prompting the user to enter a signed number
    SIGN DB ?            ; Variable to store the sign (either '+' or '-')
    SIGNEDNUM DB ?       ; Variable to store the numeric value entered by the user
    ABSNUM DB ?          ; Variable to store the absolute value of SIGNEDNUM
    MSG2 DB 'ABSOLUTE VALUE IS: $'  ; Message to display before showing the absolute value
    DIGIT DB ?           ; Temporary variable to store single digit for display

.CODE                 

MAIN PROC            
    MOV AX, @DATA        ; Load the address of the data segment into AX register
    MOV DS, AX           ; Initialize the DS (Data Segment) register to point to the data segment

    ; Prompt for SIGNED NUMBER
    LEA DX, MSG1         ; Load the address of MSG1 into DX (used for displaying the message)
    MOV AH, 9            ; Set DOS function 9h (Display string function)
    INT 21H              ; Call DOS interrupt to display the message (MSG1)

    ; Read first character (sign or digit)
    MOV AH, 1            ; Set DOS function 1h (Read character from keyboard)
    INT 21H              ; Call DOS interrupt to get the character from the user input into AL register
    MOV SIGN, AL         ; Store the character (sign or digit) in the SIGN variable

    ; Check if the entered character is '-' (negative sign)
    CMP AL, '-'          ; Compare the character in AL register with '-'
    JE READ_NUMBER_NEGATIVE  ; Jump to READ_NUMBER_NEGATIVE if character is '-'
    
    ; If the sign is positive or no sign, handle the number as positive
    ; For simplicity, assume you enter a single digit, you can expand this to handle multi-digit numbers
    MOV SIGNEDNUM, AL     ; Store the numeric value in SIGNEDNUM (assuming it's a digit)
    JMP DISPLAY_RESULT

READ_NUMBER_NEGATIVE:   
    ; Read the next character for the number
    MOV AH, 1            ; Set DOS function 1h (Read character from keyboard)
    INT 21H              ; Call DOS interrupt to get the character from the user input into AL register
    MOV SIGNEDNUM, AL    ; Store the numeric value in SIGNEDNUM

    ; Convert the negative number to its absolute value
    NEG SIGNEDNUM        ; Negate the number to get the absolute value
    
DISPLAY_RESULT:         
    ; Display the ABSOLUTE VALUE message
    LEA DX, MSG2         ; Load the address of MSG2 ("ABSOLUTE VALUE IS:") into DX
    MOV AH, 9            ; Set DOS function 9h (Display string function)
    INT 21H              ; Call DOS interrupt to display the message (MSG2)
    
    ; Display the absolute value of the number
    MOV AL, SIGNEDNUM    ; Load the absolute value of the number into AL
    ADD AL, 30H          ; Convert the number to its ASCII representation
    MOV DL, AL           ; Store the ASCII value in DL
    MOV AH, 2            ; Set DOS function 2h (Display character)
    INT 21H              ; Call DOS interrupt to display the character

EXIT_PROGRAM:
    MOV AH, 4CH          ; DOS function 4Ch (Terminate program)
    INT 21H              ; Call DOS interrupt to return control to DOS

MAIN ENDP              
END MAIN               ; Mark MAIN as the entry point of the program
