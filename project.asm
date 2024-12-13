INCLUDE Irvine32.inc
include macros.inc
includelib Winmm.lib
.data

    NUM_PLAYERS equ 10               ; Define the number of players (adjust as needed)
    max_file_size  equ  1000
     buffer BYTE max_file_size DUP(?)
     space1 BYTE "  ", 0;

     ; Arrays to store the player information
playerNames  byte 10*15 dup(?)   ; 10 players, 15 chars max for each name
playerScores dword 10 dup(0)     ; 10 scores (32-bit integers)
playerLevels dword 10 dup(?)    ; 10 levels (32-bit integers)

      
names db "Alice                         ", 0  ; "Alice" + 27 spaces = 32 bytes (null-terminated)
      db "Bob                           ", 0  ; "Bob" + 29 spaces = 32 bytes (null-terminated)
      db "Charlie                       ", 0  ; "Charlie" + 25 spaces = 32 bytes (null-terminated)
      db "Dave                       ", 0  ; "Dave" + 28 spaces = 32 bytes (null-terminated)

    ; Array of scores (corresponding to the names above)
scores dd 100, 95, 88, 77   ; Scores for Alice, Bob, Charlie, Dave

    ; Temporary buffer for swapping names (32 bytes buffer)
temp_name db 32 dup(0)

    ; Temporary variable for swapping scores (32-bit variable)
temp_score dd 0
    error_msg db "Error opening file", 0
    one_string db max_file_size dup(?)
     filename       byte      "data.txt", 0
     filename1      byte      "scores.txt", 0
     filename2      byte      "level.txt", 0
     file_handle    dword     0
     new_data       byte      15 DUP (?)
     new_line       byte      0ah,0dh, 0  ; Carriage return and line feed
     bytes_read     dword     0
     
     message BYTE "Enter data"
             BYTE "[Enter]: ",0ah,0

     Outputflag byte 1
     ScoreString byte 11 DUP (0) ; Enough space for the converted score1and null terminator
     LevelString byte 11 DUP (0) ; Enough space for the converted level and null terminator


    OFFSET1 BYTE 20              ; Offset to move the board to the right
    xPos BYTE 25                 ; Starting position for the snake head (5 + OFFSET1)
    yPos BYTE 0                 ; Starting position for the snake head (near bottom)

    ballX BYTE 35                ; Ball X position
    ballY BYTE 19                ; Ball Y position
    ballDX BYTE 1                ; Ball horizontal direction
    ballDY BYTE -1               ; Ball vertical direction
    lives BYTE 3         ; Lives remaining

    level byte 1
    levelSet byte 0
    levelSet1 byte 0
    endFlag byte 0

    inputChar BYTE ?             ; User input for movement
    score DWORD 0                ; Player score
 
    points1 DWORD 15              ; score added on breaking a brick
    points2 DWORD 10              ; score added on breaking a brick
    points3 DWORD 5              ; score added on breaking a brick


    ballChar byte '0',0
    star BYTE "==========", 0           ; Player string (paddle)
    star2 byte "=======",0
    paddleLen byte 10 
    msgScore BYTE "Score: ", 0

    len BYTE 20                  ; Game boundary length (horizontal, including offset)
    wid BYTE 10                  ; Game boundary height (vertical)

    msgGameOver byte "Game Over!",0
    msgLives byte "lives : ",0

 
    col12 DWORD lightRed + (lightRed * 16) 
 
    col22 DWORD lightGreen + (lightGreen * 16)

    col32 DWORD lightBlue + (lightBlue * 16)

    colC1 DWORD red + (red * 16)
    colC2 DWORD red + (red * 16)
    colC3 DWORD red + (red * 16)
    colC4 DWORD green + (green * 16)
    colC5 DWORD green + (green * 16)
    colC6 DWORD green + (green * 16)
    colC7 DWORD blue + (blue * 16)
    colC8 DWORD blue + (blue * 16) 
    colC9 DWORD blue + (blue * 16)  

    ; Brick health variables
    brick1Health BYTE 1
    brick2Health BYTE 1
    brick3Health BYTE 1
    brick4Health BYTE 1
    brick5Health BYTE 1
    brick6Health BYTE 1
    brick7Health BYTE 1
    brick8Health BYTE 1
    brick9Health BYTE 1
asciiArtInside  byte "               ___                 _                           _     _                        ", 0ah 
asciiArtInside1 byte "              |_ _|  _ __    ___  | |_   _ __   _   _    ___  | |_  (_)   ___    _ __    ___  ", 0ah
asciiArtInside2 byte "               | |  | '_ \  / __| | __| | '__| | | | |  / __| | __| | |  / _ \  | '_ \  / __| ", 0ah
asciiArtInside3 byte "               | |  | | | | \__ \ | |_  | |    | |_| | | (__  | |_  | | | (_) | | | | | \__ \ ", 0ah
asciiArtInside4 byte "              |___| |_| |_| |___/  \__| |_|     \__,_|  \___|  \__| |_|  \___/  |_| |_| |___/ ", 0ah,0ah,0ah
asciiArtInside5 byte "                          Use A/D keys to move the paddle.", 0ah
asciiArtInside6 byte "                          The goal is to break all the bricks by bouncing the ball off the paddle.",0ah
asciiArtInside7 byte "                          You have 3 lives. Lose a life if the ball falls off the screen.",0ah
asciiArtInside8 byte "                          Each brick has a score. Breaking bricks will increase your score.",0ah
asciiArtInside9 byte "                          Each level gets harder with faster balls and shorter paddles.",0ah
asciiArtInside10 byte "                                                                                       ",0ah
asciiArtInside11 byte "             Press b key to go back to menu page                                         ", 0    

tabSpace1 db "      ",0 


   ;MAKE SURE THAT AFTER WELCOME MENU SHOULD BE SET TOGETHER                                                                                                                                                                                                                           
  welcome1 byte "                  _     _ _______ ___     _______ _______ __   __ _______          _______ _______                 ", 0ah
  welcome2 byte "                 | | _ | |       |   |   |       |       |  |_|  |       |        |       |       |                ", 0ah
  welcome3 byte "                 | || || |    ___|   |   |       |   _   |       |    ___|        |_     _|   _   |                ", 0ah
  welcome4 byte "                 |       |   |___|   |   |       |  | |  |       |   |___           |   | |  | |  |                ", 0ah
  welcome5 byte "                 |       |    ___|   |___|      _|  |_|  |       |    ___|          |   | |  |_|  |                ", 0ah
  welcome6 byte "                 |   _   |   |___|       |     |_|       | ||_|| |   |___           |   | |       |                ", 0ah
  welcome7 byte "                 |__| |__|_______|_______|_______|_______|_|   |_|_______|          |___| |_______|                ", 0ah
  welcome8 byte "               _______ ______   ___ _______ ___   _      _______ ______   _______ _______ ___   _ _______ ______   ", 0ah
  welcome9 byte "              |  _    |    _ | |   |       |   | | |    |  _    |    _ | |       |   _   |   | | |       |    _ |  ", 0ah
 welcome10 byte "              | |_|   |   | || |   |       |   |_| |    | |_|   |   | || |    ___|  |_|  |   |_| |    ___|   | ||  ", 0ah
 welcome11 byte "              |       |   |_||_|   |       |      _|    |       |   |_||_|   |___|       |      _|   |___|   |_||_ ", 0ah
 welcome12 byte "              |  _   ||    __  |   |      _|     |_     |  _   ||    __  |    ___|       |     |_|    ___|    __  |", 0ah
 welcome13 byte "              | |_|   |   |  | |   |     |_|    _  |    | |_|   |   |  | |   |___|   _   |    _  |   |___|   |  | |", 0ah
 welcome14 byte "              |_______|___|  |_|___|_______|___| |_|    |_______|___|  |_|_______|__| |__|___| |_|_______|___|  |_|", 0ah
 welcome15 byte "                                                                                                   ", 0ah
 welcome16 byte "                                                                                                   ", 0ah
 welcome17 byte "                                                                                                   ", 0ah
 welcome18 byte "                                                                                                   ", 0ah

 enterPrompt1 byte "  _____       _                                                                      ",0ah
 enterPrompt2 byte " | ____|_ __ | |_ ___ _ __   _   _  ___  _   _ _ __   _ __   __ _ _ __ ___   ___   _ ",0ah
 enterPrompt3 byte " |  _| | '_ \| __/ _ \ '__| | | | |/ _ \| | | | '__| | '_ \ / _` | '_ ` _ \ / _ \ (_)",0ah
 enterPrompt4 byte " | |___| | | | ||  __/ |    | |_| | (_) | |_| | |    | | | | (_| | | | | | |  __/  _ ",0ah
 enterPrompt5 byte " |_____|_| |_|\__\___|_|     \__, |\___/ \__,_|_|    |_| |_|\__,_|_| |_| |_|\___| (_)",0ah
 enterPrompt6 byte "                             |___/                                                   ",0
   
   
   ;Menu ART
welcomePlayer1 byte"                                        __      __        _                          ",0ah
welcomePlayer2 byte"                                        \ \    / /  ___  | |  __   ___   _ __    ___ ",0ah
welcomePlayer3 byte"                                         \ \/\/ /  / -_) | | / _| / _ \ | '  \  / -_)",0ah
welcomePlayer4 byte"                                          \_/\_/   \___| |_| \__| \___/ |_|_|_| \___|",0ah,0ah
tabSpace byte "                                                            ";
playerName byte 15 dup(0)   ; Reserves 15 bytes, all initialized to zero

menu1   byte "                                            __   __   _______   __    _   __   __       ", 0ah
menu2   byte "                                           |  |_|  | |       | |  |  | | |  | |  |     ", 0ah
menu3   byte "                                           |       | |    ___| |   |_| | |  | |  |     ", 0ah
menu4   byte "                                           |       | |   |___  |       | |  |_|  |     ", 0ah
menu5   byte "                                           |       | |    ___| |  _    | |       |     ", 0ah
menu6   byte "                                           | ||_|| | |   |___  | | |   | |       |     ", 0ah
menu7   byte "                                           |_|   |_| |_______| |_|  |__| |_______|     ", 0ah
menu8   byte "                                                                                                        ", 0ah
menu9   byte "                                                                                             ", 0ah
menu10   byte "                                                                                             ", 0ah
menu11   byte "                                                                                             ", 0ah
menu12   byte "                                          ``````````````````````````````````````             ", 0ah
menu13   byte "                                          `             1. PLAY                `             ", 0ah
menu14   byte "                                          ``````````````````````````````````````             ", 0ah
menu15   byte "                                          `             2. INSTRUCTIONS        `             ", 0ah
menu16   byte "                                          ``````````````````````````````````````             ", 0ah
menu17   byte "                                          `             3. HIGH SCORES         `             ", 0ah
menu18   byte "                                          ``````````````````````````````````````             ", 0ah
menu19   byte "                                          `             4. CREDITS             `             ", 0ah
menu20   byte "                                          ``````````````````````````````````````             ", 0ah
menu22   byte "                                          `             5. EXIT                `             ", 0ah
menu23   byte "                                          ``````````````````````````````````````             ", 0ah,0

    pauseArtLine1 BYTE "__________                                _________                                     ", 0
    pauseArtLine2 BYTE "\______   \_____   __ __  ______ ____    /   _____/ ___________   ____   ____   ____   ", 0
    pauseArtLine3 BYTE " |     ___/\__  \ |  |  \/  ___// __ \   \_____  \_/ ___\_  __ \_/ __ \_/ __ \ /    \  ", 0
    pauseArtLine4 BYTE " |    |     / __ \|  |  /\___ \\  ___/   /        \  \___|  | \/\  ___/\  ___/|   |  \ ", 0
    pauseArtLine5 BYTE " |____|    (____  /____//____  >\___  > /_______  /\___  >__|    \___  >\___  >___|  / ", 0
    resumePrompt  BYTE "Press 'r' to Resume...", 0


        ; Game Over ASCII Art
    gameOverLine1 BYTE " _______  _______  __   __  _______            _______  __   __  _______  ______   ", 0
    gameOverLine2 BYTE "|       ||   _   ||  |_|  ||       |          |       ||  | |  ||       ||    _ |  ", 0
    gameOverLine3 BYTE "|    ___||  |_|  ||       ||    ___|          |   _   ||  |_|  ||    ___||   | ||  ", 0
    gameOverLine4 BYTE "|   | __ |       ||       ||   |___           |  | |  ||       ||   |___ |   |_||_ ", 0
    gameOverLine5 BYTE "|   ||  ||       ||       ||    ___|          |  |_|  ||       ||    ___||    __  |", 0
    gameOverLine6 BYTE "|   |_| ||   _   || ||_|| ||   |___           |       | |     | |   |___ |   |  | |", 0
    gameOverLine7 BYTE "|_______||__| |__||_|   |_||_______|          |_______|  |___|  |_______||___|  |_|", 0

    ; Score message
    
    scoreMessage BYTE "Your Score: ", 0
    creditsArt BYTE "                              ____   ____    _____   ____    ___   _____   ____",0ah
    creditsArt1 BYTE "                             / ___| |  _ \  | ____| |  _ \  |_ _| |_   _| / ___| ",0ah
    creditsArt2 BYTE "                            | |     | |_) | |  _|   | | | |  | |    | |   \___ \ ",0ah
    creditsArt3 BYTE "                            | |___  |  _ <  | |___  | |_| |  | |    | |    ___) |",0ah
    creditsArt4 BYTE "                             \____| |_| \_\ |_____| |____/  |___|   |_|   |____/ ",0ah, 0ah,0
    developer1 BYTE "                               Developer and Designer 1: Muhammad Usman Shaukat 23I-3016", 13, 10, 0 
   developer2 BYTE "                                Developer and Designer 2: Mohammad Shahzaib 23I-3087", 13, 10, 0
    thanksMessage BYTE "                                  Thank you for playing!", 13, 10, 0
    tab1 BYTE      "                            ", 0

    LeaderboardArt BYTE  "               _       _____      _      ____    _____   ____    ____     ___       _      ____    ____  ",0ah
    LeaderboardArt1 BYTE "              | |     | ____|    / \    |  _ \  | ____| |  _ \  | __ )   / _ \     / \    |  _ \  |  _ \ ",0ah
    LeaderboardArt2 BYTE "              | |     |  _|     / _ \   | | | | |  _|   | |_) | |  _ \  | | | |   / _ \   | |_) | | | | |",0ah
    LeaderboardArt3 BYTE "              | |___  | |___   / ___ \  | |_| | | |___  |  _ <  | |_) | | |_| |  / ___ \  |  _ <  | |_| |",0ah
    LeaderboardArt4 BYTE "              |_____| |_____| /_/   \_\ |____/  |_____| |_| \_\ |____/   \___/  /_/   \_\ |_| \_\ |____/ ",0ah, 0ah,0

    ; Exit prompt
    exitPrompt BYTE "Press any key to exit...", 0

    ; Debug strings
    debugXPosLabel BYTE "xPos: ", 0
    debugYPosLabel BYTE "yPos: ", 0
    debugBallXLabel BYTE "ballX: ", 0
    debugBallYLabel BYTE "ballY: ", 0
    debugBrick1Health BYTE "Brick 1 Health: ", 0
    debugBrick2Health BYTE "Brick 2 Health: ", 0
    debugBrick3Health BYTE "Brick 3 Health: ", 0
    debugBrick4Health BYTE "Brick 4 Health: ", 0
    debugBrick5Health BYTE "Brick 5 Health: ", 0
    debugBrick6Health BYTE "Brick 6 Health: ", 0
    debugBrick7Health BYTE "Brick 7 Health: ", 0
    debugBrick8Health BYTE "Brick 8 Health: ", 0
    debugBrick9Health BYTE "Brick 9 Health: ", 0
    debugLevel byte "level: ",0

    heart1 db ",d88b.d88b,", 0
    heart2 db "88888888888", 0
    heart3 db "`Y8888888Y'", 0
    heart4 db "  `Y888Y'  ", 0
    heart5 db "    `Y'    ", 0

    mainSound BYTE "C:\Users\shahz\Downloads\The Legend of Zelda Ocarina of Time_ Title Screen Theme - Extended to 30 Minutes - LinkPlayer64 (youtube).wav", 0
PlaySound PROTO,
	pszSound:PTR BYTE,
	hmod:DWORD,
	fdwSound:DWORD
    SND_ASYNC equ 00000001h



.code

;BubbleSort PROC
;    ; Input parameters:
;    ; ECX = array size (10)
;    ; ESI = base address of scores array
;    ; EBP = base address of corresponding names array
;    mov ecx, 9       ; Number of passes (array size - 1)
;    lea esi, playerScores
;    lea ebp, playerNames
;outer_loop:
;    xor ebx, ebx     ; Reset index (EBX = 0)
;    mov edi, ecx     ; Store remaining passes in EDI (for inner loop control)
;
;inner_loop:
;    ; Load playerScores[ebx] and playerScores[ebx+4] into EAX and EDX
;    mov eax, [esi + ebx*4]  ; Load scores[ebx] into EAX
;    inc ebx
;    mov edx, [esi + (ebx)*4]  ; Load scores[ebx+1] into EDX
;    dec ebx
;    ; Compare if scores[ebx] > scores[ebx + 1]
;    cmp eax, edx
;    jge no_swap      ; If EAX >= EDX, no swap needed
;
;    ; Swap scores
;    mov [esi + ebx*4], edx       ; Store smaller score in scores[ebx]
;    inc ebx
;    mov [esi + (ebx)*4], eax   ; Store larger score in scores[ebx+1]
;    dec ebx
;    ; Also swap corresponding names
;    ; Assuming names are stored as 4-byte (DWORD) pointers or fixed-length strings
;    mov eax, [ebp + ebx*4]
;    inc ebx
;    mov edx, [ebp + (ebx)*4]
;    dec ebx
;    mov [ebp + ebx*4], edx
;    inc ebx
;    mov [ebp + (ebx)*4], eax
;    dec ebx
;
;no_swap:
;    inc ebx          ; Increment the index
;    dec edi          ; Decrease the inner loop counter
;    jnz inner_loop   ; If inner loop counter is not zero, repeat
;
;    dec ecx          ; Decrease outer loop counter (number of passes)
;    jnz outer_loop   ; If outer loop counter is not zero, repeat
;
;    ret
;BubbleSort ENDP


BubbleSort PROC
    ; Input parameters:
    ; ECX = array size (10)
    ; ESI = base address of scores array
    ; EBP = base address of corresponding names array
    mov ecx, 9       ; Number of passes (array size - 1)
    lea esi, playerScores
    lea ebp, playerNames

outer_loop:
    xor ebx, ebx     ; Reset index (EBX = 0)
    mov edi, ecx     ; Store remaining passes in EDI (for inner loop control)

inner_loop:
    ; Load playerScores[ebx] and playerScores[ebx+4] into EAX and EDX
    mov eax, [esi + ebx*4]  ; Load scores[ebx] into EAX
    inc ebx
    mov edx, [esi + (ebx)*4]  ; Load scores[ebx+1] into EDX
    dec ebx
    ; Compare if scores[ebx] > scores[ebx + 1]
    cmp eax, edx
    jge no_swap      ; If EAX >= EDX, no swap needed
    
    ; Swap scores
    mov [esi + ebx*4], edx       ; Store smaller score in scores[ebx]
    inc ebx
    mov [esi + (ebx)*4], eax   ; Store larger score in scores[ebx+1]
    dec ebx
    
    ; Swap names (15 bytes each)
    push ecx
    push esi        ; Save score array base
    push ebx        ; Save current index
    push edi
  
    
    ; Calculate name addresses
    mov esi, ebp    ; Base of names array
    mov eax, 15     ; Name length
    mul ebx         ; Multiply index by name length
    add esi, eax    ; ESI now points to first name to swap
    
    ; Prepare for name swap
    mov edi, esi    ; EDI points to first name
    add edi, 15     ; EDI points to second name
    mov ecx, 15     ; Number of bytes to swap
    
    ; Temporary buffer on stack for name swap
    sub esp, 15     ; Allocate space on stack
    mov ebx, esp    ; EBX as temp buffer
    
    ; Swap names using temp buffer
    cld             ; Clear direction flag (forward)
    
    ; Copy first name to temp buffer
    mov edx, esi    ; Save original ESI
    mov esi, edi    ; ESI points to second name
    sub esi, 15     ; Go back to first name
    mov edi, ebx    ; Temp buffer
    rep movsb       ; Copy first name to temp
    
    ; Copy second name to first name position
    mov esi, edx    ; Restore original first name address
    add esi, 15     ; Point to second name
    mov edi, esi    ; Destination is first name position
    sub edi, 15
    mov ecx, 15     ; Bytes to copy
    rep movsb       ; Copy second name to first name position
    
    ; Copy temp buffer to second name position
    mov esi, ebx    ; Temp buffer
    mov edi, edx    ; Original first name address
    add edi, 15     ; Destination is second name position
    mov ecx, 15     ; Bytes to copy
    rep movsb       ; Copy temp name to second name position
    
    ; Clean up stack
    add esp, 15     ; Restore stack
    
    ; Restore registers
    pop edi
    pop ebx
    pop esi
    pop ecx
   

no_swap:
    inc ebx          ; Increment the index
    cmp ebx, 10
    je reset
    jne normal

reset:
mov ebx, 0

normal:
    dec edi          ; Decrease the inner loop counter
    test edi,edi
    jnz inner_loop   ; If inner loop counter is not zero, repeat
    
    dec ecx          ; Decrease outer loop counter (number of passes)
    test ecx,ecx
    jnz outer_loop   ; If outer loop counter is not zero, repeat
    
    ret
BubbleSort ENDP 

PrintPlayerDetails PROC
    mov ecx, 10 ; Number of players (10)
    lea esi, playerNames
    lea edi, playerScores
    lea ebp, playerLevels
    mov bl, 1
    mov bh, 8

 
print_loop:
    
   mov edx, OFFSET tabSpace1
   call WriteString
   call WriteString
   call WriteString
   call WriteString
   call WriteString
   call WriteString
 
 
    ; Print player name
    movzx eax, bl
    call WriteInt

   
    mov dh, bh   ; Start row
    mov dl, 43     ; Start column
    call Gotoxy
    
    mov edx, esi
    call WriteString
    ; Print a space between name and score

    mov dh, bh   ; Start row
    mov dl, 67     ; Start column
    call Gotoxy

    ; Print player score
    mov eax, [edi]
    call WriteInt
    ; Print a space
   
      mov dh, bh   ; Start row
    mov dl, 84    ; Start column
    call Gotoxy

 
    ; Print player level
    mov eax, [ebp]
    call WriteInt
    ; Print a newline after each player
    call Crlf
    ; Move to next player
    add esi, 15
    add edi, 4
    add ebp, 4
    inc bl
    inc bh
    loop print_loop

    ret
PrintPlayerDetails ENDP



BubbleSort1 PROC
    ; Variables
    ; ECX = array size (10)
    ; ESI = base address of array
    ; EAX = current score
    ; EBX = current index
    ; EDX = temporary register for swapping
    mov ecx, 9                      ; Number of passes (array size - 1)
    lea esi, playerLevels           ; Load the address of playerScores array into ESI

outer_loop:
    xor ebx, ebx                    ; Reset index (EBX = 0)
    mov edi, ecx                    ; Store remaining passes in EDI (for inner loop control)

inner_loop:
    ; Load playerLevels[ebx] and playerLevels[ebx+4] into EAX and EDX
    mov eax, [esi + ebx*4]          ; Load playerLevels[ebx] into EAX
    inc ebx
    mov edx, [esi + (ebx)*4]    ; Load playerLevels[ebx+1] into EDX
    dec ebx
    ; Compare if playerLevels[ebx] > playerLevels[ebx + 1]
    cmp eax, edx
    jge no_swap                     ; If EAX >= EDX, no swap needed

    ; Swap playerScores[ebx] and playerLevels[ebx + 1]
    mov [esi + ebx*4], edx          ; Store EDX (larger value) in playerLevels[ebx]

    inc ebx
    mov [esi + (ebx)*4], eax    ; Store EAX (smaller value) in playerLevels[ebx + 1]
    dec ebx

no_swap:
    inc ebx                          ; Increment the index
    dec edi                          ; Decrease the inner loop counter
    jnz inner_loop                   ; If inner loop counter is not zero, repeat

    dec ecx                          ; Decrease outer loop counter (number of passes)
    jnz outer_loop                   ; If outer loop counter is not zero, repeat

    ret
BubbleSort1 ENDP


DispScore PROC
xor esi, esi
 mov ecx, 10                    ; Number of elements (10 scores)
    lea esi, playerScores          ; Load address of playerScores into ESI

print_loop:
    mov eax, [esi]                 ; Load the current score into EAX
    call WriteInt                  ; Print the score
    call Crlf
    add esi, 4                     ; Move to the next integer in the array
    loop print_loop

DispScore ENDP

ReadPlayerData PROC
    ; Open the file for reading
    lea edx, filename
    call OpenInputFile
    mov file_handle, eax
    
    cmp eax, INVALID_HANDLE_VALUE
    je file_error
    
    ; Read entire file contents
    mov eax, file_handle
    lea edx, one_string
    mov ecx, max_file_size
    call ReadFromFile
    mov bytes_read, eax
    
    ; Prepare for parsing
    mov esi, OFFSET one_string
    xor edi, edi  ; Player index

parse_next_player:
    ; Find start of name
    call find_name_start

    ; Calculate name offset
    mov eax, edi
    mov ebx, 15
    mul ebx
    lea ebx, playerNames[eax]
    
    ; Copy name
    call copy_name1

    ; Find and parse score
    call find_number_start
  call convert_multi_digit
     
        mov [playerScores[edi*4]], eax
  


    ; Find and parse level
    call find_number_start
    call convert_ascii_to_integer
    mov playerLevels[edi*4], eax

    ; Increment player count
    inc edi
    
    ; Check if we've reached max players
    cmp edi, 10
    jl parse_next_player

    ; Close the file
    mov eax, file_handle
    call CloseFile
    jmp last

file_error:
    mov edx, OFFSET error_msg
    call WriteString

last:
    ret


    convert_multi_digit PROC
    xor eax, eax    ; Clear final result
    xor ebx, ebx
    mov ecx, 3      ; Number of digits to process

convert_loop:
    ; Get current character
    mov bl, [esi]
   
    ; Check if digit
    cmp bl, '0'
    jl next_digit
    cmp bl, '9'
    jg next_digit
    
    ; Convert ASCII to numeric
    sub bl, '0'
    
    ; Accumulate into final number
    imul eax, 10    ; Shift existing digits left
    add eax, ebx    ; Add new digit
    
    ; Move to next character
    inc esi

next_digit:
    loop convert_loop

     sub eax, '0'
     add eax, 48

    ret
convert_multi_digit ENDP


convert_ascii_to_integer PROC
    xor eax, eax    ; Clear accumulator
    xor ebx, ebx    ; Clear temporary register

convert_loop:
    mov bl, [esi]   ; Get current character
    
    ; Check if character is a digit
    cmp bl, '0'
    jl convert_done ; Less than '0', exit
    cmp bl, '9'
    jg convert_done ; Greater than '9', exit
    
    ; Multiply current result by 10
    imul eax, 10    
    
    ; Convert ASCII digit to numeric value
    sub bl, '0'     ; Convert ASCII to actual digit value
    add eax, ebx    ; Add digit to running total
    
    ; Move to next character
    inc esi
    jmp convert_loop

convert_done:
    ret
convert_ascii_to_integer ENDP

convert_ascii_to_integerDigits PROC
    xor eax, eax    ; Clear accumulator
    xor ebx, ebx    ; Clear temporary register
    mov ecx, 0      ; Flag to track if any digits processed

convert_loop:
    mov bl, [esi]   ; Get current character
    
    ; Check if character is a digit
    cmp bl, '0'
    jl convert_done ; Less than '0', exit
    cmp bl, '9'
    jg convert_done ; Greater than '9', exit
    
    ; Multiply current result by 10
    imul eax, 10    
    
    ; Convert ASCII digit to numeric value
    sub bl, '0'     ; Convert ASCII to actual digit value
    add eax, ebx    ; Add digit to running total
    
    ; Set processed flag
    mov ecx, 1
    
    ; Move to next character
    inc esi
    jmp convert_loop

convert_done:
    ; Check if any digits were processed
    cmp ecx, 0
    je no_number    ; No valid digits found
    ret

no_number:
    ; Handle case where no valid number found
    xor eax, eax   ; Return 0
    ret
convert_ascii_to_integerDigits ENDP

; Helper procedures (find_name_start, copy_name, find_number_start)
find_name_start PROC
find_name_start_loop:
    mov al, [esi]
    cmp al, 0Dh  ; Carriage return
    je skip_char
    cmp al, 0Ah  ; Newline
    je skip_char
    cmp al, 0    ; Null terminator
    ret
skip_char:
    inc esi
    jmp find_name_start_loop
find_name_start ENDP

copy_name1 PROC
    mov ecx, 15   ; Max name length
copy_name_loop:
    mov al, [esi]
    cmp al, 0Dh   ; Stop at carriage return
    je name_done
    cmp al, 0Ah   ; Stop at newline
    je name_done
    
    mov [ebx], al
    inc esi
    inc ebx
    loop copy_name_loop
name_done:
    ; Null terminate the name
    mov byte ptr [ebx], 0
    ret
copy_name1 ENDP

find_number_start PROC
find_number_start_loop:
    mov al, [esi]
    cmp al, '0'
    jl skip_char
    cmp al, '9'
    jg skip_char
    ret
skip_char:
    inc esi
    jmp find_number_start_loop
find_number_start ENDP

ReadPlayerData ENDP
store_scores PROC
mov eax, score
call WriteIntToString

   lea edx, filename1
    call OpenInputFile
    mov file_handle, eax
    mov eax, file_handle 
    lea edx, one_string
    mov ecx, max_file_size
    call ReadFromFile
    mov bytes_read, eax
    mov eax, file_handle
    call CloseFile

    mov esi, bytes_read
    xor edi, edi
   ; Append the newline first
    .while edi < lengthof new_line - 1 ; excluding the null terminator
         mov al, new_line[edi]
         mov one_string[esi], al

         inc edi
         inc esi
    .endw
    mov edx, OFFSET ScoreString
    call WriteString

    ; Append ScoreString to one_string
    mov edi, 0
    .while ScoreString[edi] != 0
         mov al, ScoreString[edi]
         mov one_string[esi], al
         inc edi
         inc esi
    .endw

    mov bytes_read, esi
    xor edi, edi

    ; Append final newline
    .while edi < lengthof new_line - 1 
         mov al, new_line[edi]
         mov one_string[esi], al
         inc edi
         inc esi
    .endw

      lea edx, filename1
    call CreateOutputFile
    mov file_handle, eax 
    lea edx, one_string
    mov ecx, bytes_read
    mov eax, file_handle
    call WriteToFile 
    mov eax, file_handle
    call CloseFile
store_scores ENDP

store_level PROC
mov eax,OFFSET level
call WriteIntToString

   lea edx, filename1
    call OpenInputFile
    mov file_handle, eax
    mov eax, file_handle 
    lea edx, one_string
    mov ecx, max_file_size
    call ReadFromFile
    mov bytes_read, eax
    mov eax, file_handle
    call CloseFile

    mov esi, bytes_read
    xor edi, edi
   ; Append the newline first
    .while edi < lengthof new_line - 1 ; excluding the null terminator
         mov al, new_line[edi]
         mov one_string[esi], al

         inc edi
         inc esi
    .endw
    mov edx, OFFSET ScoreString
    call WriteString

    ; Append ScoreString to one_string
    mov edi, 0
    .while ScoreString[edi] != 0
         mov al, ScoreString[edi]
         mov one_string[esi], al
         inc edi
         inc esi
    .endw

    mov bytes_read, esi
    xor edi, edi

    ; Append final newline
    .while edi < lengthof new_line - 1 
         mov al, new_line[edi]
         mov one_string[esi], al
         inc edi
         inc esi
    .endw

      lea edx, filename1
    call CreateOutputFile
    mov file_handle, eax 
    lea edx, one_string
    mov ecx, bytes_read
    mov eax, file_handle
    call WriteToFile 
    mov eax, file_handle
    call CloseFile
store_level ENDP


store_name PROC
    mov eax, score       
    call WriteIntToString 



    lea edx, filename
    call OpenInputFile
    mov file_handle, eax

    mov eax, file_handle 
    lea edx, one_string
    mov ecx, max_file_size  

    call ReadFromFile

    mov bytes_read, eax
    mov eax, file_handle
    call CloseFile

    mov esi, bytes_read
    xor edi, edi
   
   ;STORE 0DH FOR identifying in reading
    ; Append the newline first
    .while edi < lengthof new_line - 1 ; excluding the null terminator
         mov al, new_line[edi]
         mov one_string[esi], al

         inc edi
         inc esi
    .endw

    ;  mov edx, OFFSET playerName
    ;  mov ecx, LENGTHOF playerName
    ;  call ReadString
    
    ; Copy playerName to new_data
    xor edi, edi  ; Reset index
copy_name:
    mov al, playerName[edi]
    mov new_data[edi], al
    inc edi
    cmp edi, 15
    jl copy_name

    ; Reset edi and append new_data to one_string
    xor edi, edi
    .while edi < lengthof new_data
         mov al, new_data[edi]
         mov one_string[esi], al
         inc edi
         inc esi
    .endw

    ;FOR storing score 
    mov edx, OFFSET ScoreString
    call WriteString

    mov bytes_read, esi
    xor edi, edi

    ; Append final newline
    .while edi < lengthof new_line - 1 
         mov al, new_line[edi]
         mov one_string[esi], al
         inc edi
         inc esi
    .endw

    ; Append ScoreString to one_string
    mov edi, 0
    .while ScoreString[edi] != 0
         mov al, ScoreString[edi]
         mov one_string[esi], al
         inc edi
         inc esi
    .endw
    mov edx, esi
  
;clear the string so that level can be stored
    lea     esi, Scorestring          ; Load the address of the string into ESI
    mov     ecx, 13                ; Set ECX to the length of the string (13 characters in this case)

clear_string:
    mov     byte ptr [esi], 0       ; Set the current byte (character) to zero
    inc     esi                    ; Move to the next character
    loop    clear_string           ; Decrement ECX and loop until ECX is zero

    mov esi, edx

    movzx eax, level
    call WriteIntToString 
   
   mov esi, edx
    mov edx, OFFSET ScoreString
    call WriteString
   
    mov bytes_read, esi
    xor edi, edi
   
    ; Append final newline
    .while edi < lengthof new_line - 1 
         mov al, new_line[edi]
         mov one_string[esi], al
         inc edi
         inc esi
    .endw
   
    ; Append ScoreString to one_string
    mov edi, 0
    .while ScoreString[edi] != 0
         mov al, ScoreString[edi]
         mov one_string[esi], al
         inc edi
         inc esi
    .endw
    
    mov bytes_read, esi
    xor edi, edi

    ;store 0dh for identifying in reading
    ; Append final newline
    .while edi < lengthof new_line - 1 
         mov al, new_line[edi]
         mov one_string[esi], al
         inc edi
         inc esi
    .endw

    lea edx, filename
    call CreateOutputFile
    mov file_handle, eax 
    lea edx, one_string
    mov ecx, bytes_read
    mov eax, file_handle
    call WriteToFile 
    mov eax, file_handle
    call CloseFile
    ret
store_name ENDP














PrintHearts PROC
    ; Set text color for red
    mov eax, red + [black*16]
    call SetTextColor
    
    ; Clear the screen
    call Clrscr
    
    ; Load the number of lives into eax
    mov ebx, 0
    movzx ebx, byte ptr [lives]   
    ; Clear ecx (it will count the hearts printed)
    xor ecx, ecx
    
    ; Initial position
    mov dh, 6   ; Start row
    mov dl, 80     ; Start column
    
PrintLoop:
    cmp ecx, ebx     
    jge DonePrinting 
    
    mov al, dh
    ; Save the current column in ah
    mov ah, dl
    
    ; Print first line of heart
    call Gotoxy
    lea edx, heart1  
    call WriteString
    
    ; Move to next line, increment row
    mov dh, al
    inc dh
    mov dl, ah
    call Gotoxy
    lea edx, heart2  
    call WriteString
    
    ; Move to next line, increment row
    mov dh, al
    inc dh
    inc dh
    mov dl, ah
    call Gotoxy
    lea edx, heart3  
    call WriteString
    
    ; Move to next line, increment row
    mov dh, al
    inc dh
    inc dh
    inc dh
    mov dl, ah
    call Gotoxy
    lea edx, heart4  
    call WriteString
    
    ; Move to next line, increment row
    mov dh, al
    inc dh
    inc dh
    inc dh
    inc dh
    mov dl, ah
    call Gotoxy
    lea edx, heart5  
    call WriteString
    
    mov dh, al
    mov dl, ah
    ; Increment counter and adjust column
    inc ecx
    mov dl, 80     ; Reset to original start row
    add dh, 7
    ; If column exceeds screen width, reset column and move down
    cmp dh, 25    
    jl NoMoveDown 
    mov dh, 80  
    add dl, 6     ; Move down more rows to separate hearts vertically
    
NoMoveDown:
    jmp PrintLoop 
DonePrinting:
    ; Set text color back to white
    mov eax, white + [black*16]
    call SetTextColor

    ret
PrintHearts ENDP

WriteIntToString PROC
    ; EAX contains the integer to convert
    ; Resulting string will be stored in ScoreString
    mov ebx, OFFSET ScoreString + 10 ; Point EBX to the end of the ScoreString
    mov byte ptr [ebx], 0       ; Null terminator for the string
    dec ebx                     ; Move to the previous position in the ScoreString

convertLoop:
    mov edx, 0
    mov ecx,10
    div ecx        
    add dl, '0'    
    mov [ebx], dl  
    dec ebx        
    test eax, eax  
    jnz convertLoop

    inc ebx    
    mov edx, esi
    mov esi, ebx   
    mov edi, OFFSET ScoreString

copyString:
    mov al, [esi]       
    mov [edi], al       
    inc esi             
    inc edi             
    cmp al, 0           
    jne copyString      

    ret
WriteIntToString ENDP

outputscore PROC
    ; Open the file for input

    mov edx, OFFSET filename
    call OpenInputFile
    mov file_handle, eax
    
    ; Check for errors in opening the file
    cmp eax, INVALID_HANDLE_VALUE
    jne file_ok
    mWrite <"Cannot open file", 0dh, 0ah>
    jmp quit
file_ok:
    ; Read the file into a buffer
    mov edx, OFFSET buffer
    mov ecx, max_file_size
    call ReadFromFile
    
    jnc check_max_file_size
    
    ; Error reading the file
    mWrite "Error reading file. ", 0dh, 0ah
    call WriteWindowsMsg
    jmp close_file
check_max_file_size:
    cmp eax, max_file_size
    jb buf_size_ok
    mWrite <"Error: Buffer too small for the file", 0dh, 0ah>
    jmp quit
buf_size_ok:
    ; Null terminate the buffer
    mov byte ptr [buffer + eax], 0
    mov ebx, eax  ; Store total file size
    
    ; Display file contents line by line
    mov esi, OFFSET buffer
    mov ecx, 0  ; Flag to track name/score
print_line:
    ; Check if we've reached the end of the buffer
    mov eax, esi
    sub eax, OFFSET buffer
    cmp eax, ebx
    jae close_file
    
    ; Skip leading whitespace
    mov al, [esi]
    cmp al, ' '
    je skip_space
    cmp al, 0Dh
    je next_line
    cmp al, 0Ah
    je next_line
    
    ; Determine if line is name or score
    push esi  ; Save current position
    mov edx, esi  ; Prepare for WriteString
    
    ; Check if line contains any digits (score) or letters (name)
    mov al, [esi]
    
    ; Check for digit (score)
    cmp al, '0'
    jb is_name
    cmp al, '9'
    jbe is_score
    
    ; Check for letter (name)
    cmp al, 'A'
    jb find_next_line
    cmp al, 'z'
    jle is_name
    jmp find_next_line

is_score:
    pop esi  ; Restore position
    mWrite " Score: "
    call WriteString
    call Crlf
    jmp find_next_line

is_name:
    pop esi  ; Restore position
    call WriteString
    call Crlf

find_next_line:
    ; Move to next line
    mov eax, esi
    sub eax, OFFSET buffer
    cmp eax, ebx
    jae close_file
    
    cmp byte ptr [esi], 0Dh  ; Carriage return
    je found_line_end
    inc esi
    jmp find_next_line
    
found_line_end:
    inc esi  ; Skip carriage return
    cmp byte ptr [esi], 0Ah  ; Line feed
    cmp byte ptr [esi], 0Ah  ; Line feed
    je skip_linefeed
    dec esi
    
skip_linefeed:
    inc esi  ; Skip line feed
    jmp print_line
skip_space:
    inc esi
    jmp print_line
next_line:
    inc esi
    jmp print_line
close_file:
    ; Close the file
    mov eax, file_handle
    call CloseFile
    
quit:
    ret
outputscore ENDP


titlePage PROC
    INVOKE PlaySound, OFFSET mainSound, NULL, SND_ASYNC
    mov eax, black + (green*16)  ; black text on green background
    call SetTextColor
    call Clrscr
    mov edx, OFFSET welcome1
    call WriteString
    call Crlf
    
    mov dh,21
    mov dl,87
    call Gotoxy
    mov edx, OFFSET playerName
    mov ecx, LENGTHOF playerName  ; Use actual length of buffer
    
    call ReadString
    call Clrscr
    call menuDisplay
titlePage ENDP

instructionsPage PROC
    mov eax, 0
    mov ebx, 0
    mov ecx, 0
    mov edx, 0
    call ClearScreen

     mov eax, black + (green*16)  ; black text on green background
    
    call SetTextColor
    call Clrscr
    
    ; Print the inside of the ASCII art
    mov edx, OFFSET asciiArtInside
    call WriteString
    call Crlf
read_again:  
  CALL ReadChar
  
     CMP al, 'b'
    je  menuD
      jmp  read_again

menuD:
    call Clrscr
    call menuDisplay
    jmp last

last:

instructionsPage ENDP

Credits PROC
  
    call ClearScreen
       mov eax, black + (green*16)  ; black text on green background
    
    call SetTextColor
    call Clrscr
    MOV edx, OFFSET creditsArt
    CALL WriteString
    CALL Crlf

    ; Display developer 1
    MOV edx, OFFSET developer1
    CALL WriteString
    CALL Crlf

    ; Display developer 2
    MOV edx, OFFSET developer2
    CALL WriteString
    CALL Crlf

    ; Display thanks message
    MOV edx, OFFSET thanksMessage
    CALL WriteString
    CALL Crlf
    
    MOV edx, OFFSET tab1
    CALL WriteString
    

    MOV edx, OFFSET asciiArtInside11
    CALL WriteString
    CALL Crlf


read_again:
    call ReadChar
    CMP al, 'b'
   je  menuD
    jmp  read_again


menuD:
    call Clrscr
    call menuDisplay
    jmp last

last:

Credits ENDP




Leaderboard PROC
    call ClearScreen
    mov eax, black + (green * 16)  ; Set color for leaderboard

    call SetTextColor
    call Clrscr

    mov edx, OFFSET LeaderboardArt
    call WriteString
    call Crlf
    
    mWrite <"                                    Rank   Name                    Score           Level", 0dh, 0ah>
    
    call ReadPlayerData
    call BubbleSort
    call BubbleSort1
    call PrintPlayerDetails


    call Crlf
    call Crlf
    call Crlf
    call Crlf
    call Crlf

    ; Display leaderboard header
    MOV edx, OFFSET tab1
    CALL WriteString
    MOV edx, OFFSET asciiArtInside11
    CALL WriteString
    CALL Crlf
    
    call ReadChar
    CMP al, 'b'
    je menuD

menuD:
    call Clrscr
    call menuDisplay
    jmp last

last:
Leaderboard ENDP


menuDisplay PROC
  mov eax, 0
    mov ebx, 0
    mov ecx, 0
    mov edx, 0
   
      call ClearScreen
      mov eax,  brown + (green * 16)  ; green background with brown text
    call SetTextColor
    ; Clear screen with current background color
    call Clrscr
    mov dl, 0
    mov dh, 0
    call Gotoxy
 mov edx, OFFSET welcomePlayer1
    call WriteString
    call Crlf
    call Crlf
        mov eax, black + (green * 16)  ; green background with black text
    call SetTextColor
   
    mov edx, OFFSET menu1
    call WriteString
takeInput:
 CALL ReadChar
    CMP al, '1'                ; Start Game
    je showGame
    CMP al, '2'                ; Instructions
    je showInstructions
    CMP al, '3'                ; Leaderboard
    je showLeaderboard
    CMP al, '4'                ; Credits Page
    JE showCredits
    CMP al, '5'                ; Exit
    JE exitProgram
    jmp takeInput
showGame:
 mov eax, white+(black*16)
    call SetTextColor
    call Clrscr
    call Task5
    jmp last

showInstructions:
call instructionsPage
jmp last

showLeaderboard:
call Leaderboard
jmp last


showCredits:
call Credits
jmp last

exitProgram:
CALL Clrscr
exit


last:
    exit
    ret
menuDisplay ENDP

Task5 PROC

    ; Initialize game
    call InitializeGame

gameLoop:
    

    mov bh, endFlag
    cmp bh,1
    je exitGame

    mov eax, score
    cmp eax,90
    je gogo
    cmp eax,180
    je gogo2
    jne gogo1

    gogo:
    call Initializelevel2
    jmp gogo1
    gogo2:
    call Initializelevel3

    gogo1:
    call drawBlocks
    call DrawBoundaries           ; Redraw game boundaries
    call MoveBall
    call DrawPlayer
    call DisplayScore
    call DisplayLives
    
  
  
    ;call DisplayDebugInfo
    call DisplayLevel
    ;call PrintHearts; shahzaib changes

    call ReadKey
    jz gameLoop
  
    mov inputChar, al

    ; Exit game if user types 'x'
    cmp inputChar, 'x'
    je exitGame

    ; Handle movement
    cmp inputChar, 'a'
    je moveLeft
    cmp inputChar, 'd'
    je moveRight
    cmp inputChar, 'p'
    je PauseState

    jmp gameLoop

moveLeft:
    ; Check left boundary
    mov al, xPos
    sub al, 3                    ; Check one step left
    cmp al, OFFSET1              ; Avoid crossing the left boundary
    jl noMove                    ; Stay at the boundary if attempting to cross
    call UpdatePlayer
    dec xPos                     ; Move left
    dec xPos 
    call DrawPlayer
    jmp gameLoop

moveRight:
    ; Check right boundary
    mov al, xPos
    add al, paddleLen                    ; Include the length of the paddle/snake head
    mov ah, OFFSET1              ; Load OFFSET1
    add ah, 19
    mov bl, len                  ; Load len
    add ah, bl                   ; Compute OFFSET1 + len
    cmp al, ah                   ; Avoid crossing the right boundary
    jge noMove                   ; Stay at the boundary if attempting to cross
    call UpdatePlayer 
    inc xPos                     ; Move right
    inc xPos                     ; Move right
    call DrawPlayer
    jmp gameLoop

noMove:
    jmp gameLoop
    
    PauseState:

      call PauseScreen
    jmp gameLoop

exitGame:

    mov dh,0
    mov dl,0
    call Gotoxy
    call clearscreen
    call gameOver
    ret

Task5 endp

PauseScreen PROC
    ; Step 1: Clear the screen
    
    mov dh,0
    mov dl,10
    call Gotoxy
    call ClearScreen
    
   
    mov dh,1
    mov dl,10
    call Gotoxy
    ; Step 2: Print ASCII art for the pause screen
    mov edx, OFFSET pauseArtLine1
    call WriteString
    call Crlf
    mov dh,2
    mov dl,10
    call Gotoxy
    mov edx, OFFSET pauseArtLine2
    call WriteString
    call Crlf
    mov dh,3
    mov dl,10
    call Gotoxy
    mov edx, OFFSET pauseArtLine3
    call WriteString
    call Crlf
    mov dh,4
    mov dl,10
    call Gotoxy
    mov edx, OFFSET pauseArtLine4
    call WriteString
    call Crlf
    mov dh,5
    mov dl,10
    call Gotoxy
    mov edx, OFFSET pauseArtLine5
    call WriteString
    call Crlf

    mov dh,10
    mov dl,40
    call Gotoxy
    ; Step 3: Display the "Press R to Resume" prompt
    mov edx, OFFSET resumePrompt
    call WriteString

    ; Step 4: Wait for user input and check for 'R'
waitForResume:
    call ReadChar                 ; Wait for key press
    cmp al, 'r'                  ; Check if 'R' is pressed
    jne waitForResume            ; If not, wait again
    call ClearScreen
    call PrintHearts ;made in initialise game and lose lise so they need to be called again
    ret
PauseScreen ENDP

InitializeGame PROC
    ; Calculate OFFSET1 + 5 for xPos
    movzx eax, OFFSET1           ; Load OFFSET1 into eax (zero-extend to DWORD)
    add eax, 15                   ; Add 5 to OFFSET1
    mov xPos, al                 ; Store the lower BYTE result in xPos

    ; Set initial yPos
    movzx eax, wid               ; Load wid into eax (zero-extend to DWORD)
    imul eax,2
    add eax, 1
    sub eax, 2                   ; Subtract 2 from wid
    mov yPos, al                 ; Store the lower BYTE result in yPos

    mov ballDX, 1
    mov ballDY, -1

    mov score, 0
    mov lives, 3
    call PrintHearts; shahzaib changes


    ret
InitializeGame ENDP

Initializelevel2 PROC
   
   cmp levelSet,0
   jne broski

   call ClearScreen
   ; Clear previous position of the player
    call UpdatePlayer


    ; Calculate OFFSET1 + 5 for xPos
    movzx eax, OFFSET1           ; Load OFFSET1 into eax (zero-extend to DWORD)
    add eax, 15                   ; Add 5 to OFFSET1
    mov xPos, al                 ; Store the lower BYTE result in xPos

    ; Set initial yPos
    movzx eax, wid               ; Load wid into eax (zero-extend to DWORD)
    imul eax,2
    add eax, 1
    sub eax, 2                   ; Subtract 2 from wid
    mov yPos, al                 ; Store the lower BYTE result in yPos

    mov ballX,35
    mov ballY,19
    mov ballDX, 1
    mov ballDY, -1

    ;set bricks health 2
    mov brick1Health, 2
    mov brick2Health, 2
    mov brick3Health, 2
    mov brick4Health, 2
    mov brick5Health, 2
    mov brick6Health, 2
    mov brick7Health, 2
    mov brick8Health, 2
    mov brick9Health, 2

    ;set level to 2
    mov level ,2
    inc levelSet
    
    ;reset paddle length
    mov paddleLen, 7
    call PrintHearts
    call DrawPlayer
    call DisplayLives
    call DisplayScore
  
    


    broski:

    ret
Initializelevel2 ENDP

Initializelevel3 PROC
   
   cmp levelSet1,0
   jne broski1

   call ClearScreen
   
    ; Clear previous position of the player
    call UpdatePlayer

    ; Calculate OFFSET1 + 5 for xPos
    movzx eax, OFFSET1           ; Load OFFSET1 into eax (zero-extend to DWORD)
    add eax, 15                   ; Add 5 to OFFSET1
    mov xPos, al                 ; Store the lower BYTE result in xPos

    ; Set initial yPos
    movzx eax, wid               ; Load wid into eax (zero-extend to DWORD)
    imul eax,2
    add eax, 1
    sub eax, 2                   ; Subtract 2 from wid
    mov yPos, al                 ; Store the lower BYTE result in yPos

    mov ballX,35
    mov ballY,19
    mov ballDX, -1
    mov ballDY, -1

    ;set bricks health 3
    mov brick1Health, -1
    mov brick2Health, -1
    mov brick3Health, 3
    mov brick4Health, 3
    mov brick5Health, 3
    mov brick6Health, 3
    mov brick7Health, -1
    mov brick8Health, 3
    mov brick9Health, 3

    ;colour change for fixed bricks
    mov eax, cyan + (cyan * 16)

    mov colC1,eax
    mov colC2,eax
    mov colC7 ,eax

    ;colour change for special bricks
    mov eax, lightGray + (lightGray * 16)
    mov colC5,eax

    ;set level to 2
    mov level ,3
    inc levelSet1
    

    call DrawPlayer
    call PrintHearts
    call DisplayLives
    call DisplayScore
 
    broski1:

    ret
Initializelevel3 ENDP

DrawPlayer PROC
    ; Draw player at (xPos, yPos)
    mov eax, green
    call SetTextColor
    mov dl, xPos
    mov dh, yPos
    call Gotoxy
    mov al, level
    cmp al,1
    jne next1

    mov edx, OFFSET star
    call WriteString
    ret

    next1:
    mov edx, OFFSET star2
    call WriteString
    ret
DrawPlayer ENDP

UpdatePlayer PROC
    ; Clear previous position of the player
    mov dl, xPos
    mov dh, yPos
    call Gotoxy

    ; Clear the entire length of the "===" string
    movzx ecx, paddleLen                   ; Length of the string
ClearLoop:
    mov al, ' '                  ; Replace with spaces
    call WriteChar
    inc dl                       ; Move to the next character
    loop ClearLoop

donedone:
    ret
UpdatePlayer ENDP

DisplayScore PROC

    mov eax, 7  ; 7 = White text, black background
    call SetTextColor
    ; Clear previous score area to update new score
    mov dl, 5                    ; Set X position for the score display (5 columns in from the left)
    mov dh, 1                    ; Set Y position for the score display (1 row from the top)
    call Gotoxy                  ; Move cursor to the score position
    mov edx, OFFSET msgScore     ; Load the score message string
    call WriteString             ; Display the score message
    mov eax, score               ; Load the current score
    call WriteDec                ; Display the updated score

    ret
DisplayScore ENDP

DrawBoundaries PROC
    mov eax, white               ; Set boundary color
    call SetTextColor

    ; Draw top boundary
    mov dl, OFFSET1              ; Starting x-position (adjusted for offset)
    mov dh, 0                    ; Y position for top boundary
    movzx ecx, len               ; Length of the boundary
    add ecx, 20
topBoundaryLoop:
    call Gotoxy
    mov al, '_'                 ; Boundary character
    call WriteChar
    inc dl                       ; Move to the next column
    loop topBoundaryLoop

    ; Draw bottom boundary
    mov dl, OFFSET1              ; Starting x-position (adjusted for offset)
    mov dh, wid                  ; Y position for bottom boundary
    add dh, wid
    movzx ecx, len               ; Length of the boundary
    add ecx, 20
bottomBoundaryLoop:
    call Gotoxy
    mov al, '_'                  ; Boundary character
    call WriteChar
    inc dl                       ; Move to the next column
    loop bottomBoundaryLoop

    ; Draw left boundary
    mov dl, OFFSET1              ; X position for left boundary
    mov dh, 1                    ; Starting y-position
    movzx ecx, wid - 1           ; Height of the boundary (excluding corners)
leftBoundaryLoop:
    call Gotoxy
    mov al, '|'                  ; Boundary character
    call WriteChar
    inc dh                       ; Move to the next row
    loop leftBoundaryLoop

    ; Draw right boundary
    mov al, OFFSET1            ; Load OFFSET1 into al
    mov bl, len                ; Load len into bl
    sub bl, 1                    ; Compute len - 1
    add al, bl                   ; Add OFFSET1 + (len - 1)
    mov dl, al                   ; Store the result in dl for the X position
    add dl,20

    mov dh, 1                    ; Starting y-position
    movzx ecx, wid - 1           ; Height of the boundary (excluding corners)
rightBoundaryLoop:
    call Gotoxy
    mov al, '|'                  ; Boundary character
    call WriteChar
    inc dh                       ; Move to the next row
    loop rightBoundaryLoop
 
    ret
DrawBoundaries ENDP

writingCharacter PROC USES eax
	call SetTextColor
	call Gotoxy
	mov eax, '*'
L1:
	call WriteChar
	loop L1

	ret
writingCharacter ENDP

drawBlocks PROC USES eax ecx edx
    ; Call individual procedures for each block
    call DrawBrick1
    call DrawBrick2
    call DrawBrick3
    call DrawBrick4
    call DrawBrick5
    call DrawBrick6
    call DrawBrick7
    call DrawBrick8
    call DrawBrick9
    ret
drawBlocks ENDP

DrawBrick1 PROC
    mov al, brick1Health
    cmp al, 0
    je ClearBrick1
    ; Draw Block 1 (Red)
    mov dl, OFFSET1
    add dl, 1                    ; X position for Block 1
    mov dh, 2                    ; Y position for Block 1
    mov eax, colC1   ; Set Red color
    mov ecx, 12                  ; Block width
    call writingCharacter        ; Draw Block 1
    ret

ClearBrick1:
    ; Clear Block 1
    mov dl, OFFSET1
    add dl, 1                    ; X position for Block 1
    mov dh, 2                    ; Y position for Block 1
    mov eax, black + (black * 16) ; Set Black color
    mov ecx, 12                  ; Block width
    call writingCharacter        ; Clear Block 1
    ret
DrawBrick1 ENDP

DrawBrick2 PROC
    mov al, brick2Health
    cmp al, 0
    je ClearBrick2
    ; Draw Block 2 (Red)
    mov dl, OFFSET1
    add dl, 14                   ; X position for Block 2
    mov dh, 2                    ; Y position for Block 2
    mov eax, colC2    ; Set Red color
    mov ecx, 12                  ; Block width
    call writingCharacter        ; Draw Block 2
    ret

ClearBrick2:
    ; Clear Block 2
    mov dl, OFFSET1
    add dl, 14                   ; X position for Block 2
    mov dh, 2                    ; Y position for Block 2
    mov eax, black + (black * 16) ; Set Black color
    mov ecx, 12                  ; Block width
    call writingCharacter        ; Clear Block 2
    ret
DrawBrick2 ENDP

DrawBrick3 PROC
    mov al, brick3Health
    cmp al, 0
    je ClearBrick3
    ; Draw Block 3 (Red)
    mov dl, OFFSET1
    add dl, 27                   ; X position for Block 3
    mov dh, 2                    ; Y position for Block 3
    mov eax, colC3    ; Set Red color
    mov ecx, 12                  ; Block width
    call writingCharacter        ; Draw Block 3
    ret

ClearBrick3:
    ; Clear Block 3
    mov dl, OFFSET1
    add dl, 27                   ; X position for Block 3
    mov dh, 2                    ; Y position for Block 3
    mov eax, black + (black * 16) ; Set Black color
    mov ecx, 12                  ; Block width
    call writingCharacter        ; Clear Block 3
    ret
DrawBrick3 ENDP

DrawBrick4 PROC
    mov al, brick4Health
    cmp al, 0
    je ClearBrick4
    ; Draw Block 4 (Green)
    mov dl, OFFSET1
    add dl, 1                    ; X position for Block 4
    mov dh, 4                    ; Y position for Block 4
    mov eax, colC4                ; Set Green color
    mov ecx, 12                  ; Block width
    call writingCharacter        ; Draw Block 4
    ret

ClearBrick4:
    ; Clear Block 4
    mov dl, OFFSET1
    add dl, 1                    ; X position for Block 4
    mov dh, 4                    ; Y position for Block 4
    mov eax, black + (black * 16) ; Set Black color
    mov ecx, 12                  ; Block width
    call writingCharacter        ; Clear Block 4
    ret
DrawBrick4 ENDP

DrawBrick5 PROC
    mov al, brick5Health
    cmp al, 0
    je ClearBrick5
    ; Draw Block 5 (Green)
    mov dl, OFFSET1
    add dl, 14                   ; X position for Block 5
    mov dh, 4                    ; Y position for Block 5
    mov eax, colC5                ; Set Green color
    mov ecx, 12                  ; Block width
    call writingCharacter        ; Draw Block 5
    ret

ClearBrick5:
    ; Clear Block 5
    mov dl, OFFSET1
    add dl, 14                   ; X position for Block 5
    mov dh, 4                    ; Y position for Block 5
    mov eax, black + (black * 16) ; Set Black color
    mov ecx, 12                  ; Block width
    call writingCharacter        ; Clear Block 5
    ret
DrawBrick5 ENDP

DrawBrick6 PROC
    mov al, brick6Health
    cmp al, 0
    je ClearBrick6
    ; Draw Block 6 (Green)
    mov dl, OFFSET1
    add dl, 27                   ; X position for Block 6
    mov dh, 4                    ; Y position for Block 6
    mov eax, colC6                ; Set Green color
    mov ecx, 12                  ; Block width
    call writingCharacter        ; Draw Block 6
    ret

ClearBrick6:
    ; Clear Block 6
    mov dl, OFFSET1
    add dl, 27                   ; X position for Block 6
    mov dh, 4                    ; Y position for Block 6
    mov eax, black + (black * 16) ; Set Black color
    mov ecx, 12                  ; Block width
    call writingCharacter        ; Clear Block 6
    ret
DrawBrick6 ENDP

DrawBrick7 PROC
    mov al, brick7Health
    cmp al, 0
    je ClearBrick7
    ; Draw Block 7 (Blue)
    mov dl, OFFSET1
    add dl, 1                    ; X position for Block 7
    mov dh, 6                    ; Y position for Block 7
    mov eax, colC7                ; Set Blue color
    mov ecx, 12                  ; Block width
    call writingCharacter        ; Draw Block 7
    ret

ClearBrick7:
    ; Clear Block 7
    mov dl, OFFSET1
    add dl, 1                    ; X position for Block 7
    mov dh, 6                    ; Y position for Block 7
    mov eax, black + (black * 16) ; Set Black color
    mov ecx, 12                  ; Block width
    call writingCharacter        ; Clear Block 7
    ret
DrawBrick7 ENDP

DrawBrick8 PROC
    mov al, brick8Health
    cmp al, 0
    je ClearBrick8
    ; Draw Block 8 (Blue)
    mov dl, OFFSET1
    add dl, 14                   ; X position for Block 8
    mov dh, 6                    ; Y position for Block 8
    mov eax, colC8                ; Set Blue color
    mov ecx, 12                  ; Block width
    call writingCharacter        ; Draw Block 8
    ret

ClearBrick8:
    ; Clear Block 8
    mov dl, OFFSET1
    add dl, 14                   ; X position for Block 8
    mov dh, 6                    ; Y position for Block 8
    mov eax, black + (black * 16) ; Set Black color
    mov ecx, 12                  ; Block width
    call writingCharacter        ; Clear Block 8
    ret
DrawBrick8 ENDP

DrawBrick9 PROC
    mov al, brick9Health
    cmp al, 0
    je ClearBrick9
    ; Draw Block 9 (Blue)
    mov dl, OFFSET1
    add dl, 27                   ; X position for Block 9
    mov dh, 6                    ; Y position for Block 9
    mov eax, colC9                ; Set Blue color
    mov ecx, 12                  ; Block width
    call writingCharacter        ; Draw Block 9
    ret

ClearBrick9:
    ; Clear Block 9
    mov dl, OFFSET1
    add dl, 27                   ; X position for Block 9
    mov dh, 6                    ; Y position for Block 9
    mov eax, black + (black * 16) ; Set Black color
    mov ecx, 12                  ; Block width
    call writingCharacter        ; Clear Block 9
    ret
DrawBrick9 ENDP

CheckBrickCollision PROC
    xor ecx, ecx                 ; Reset ECX to 0 (no brick hit)

    ; Check for collisions with all bricks
    call CheckBrick1
    test ecx, ecx                ; Check if ECX is set to 1
    jnz EndBrickCollision        ; If a brick was hit, exit

    call CheckBrick3
    test ecx, ecx
    jnz EndBrickCollision
    
    call CheckBrick2
    test ecx, ecx
    jnz EndBrickCollision

    

    call CheckBrick4
    test ecx, ecx
    jnz EndBrickCollision

    call CheckBrick6
    test ecx, ecx
    jnz EndBrickCollision

    call CheckBrick5
    test ecx, ecx
    jnz EndBrickCollision

   

    call CheckBrick7
    test ecx, ecx
    jnz EndBrickCollision

    call CheckBrick9
    test ecx, ecx
    jnz EndBrickCollision

    call CheckBrick8
    test ecx, ecx
    jnz EndBrickCollision

    

EndBrickCollision:
    ret
CheckBrickCollision ENDP

CheckBrick1 PROC
    xor eax, eax
    mov al, brick1Health
    cmp al, 0
    je SkipBrick1Check

    
    
    ; Check ball collision with Brick 1
    mov al, ballX
    cmp al, 21          ; Left bound of Brick 1
    jl SkipBrick1Check
   

    mov ah, ballX
    cmp ah, 33         ; Right bound of Brick 1
    jg SkipBrick1Check
    mov al, ballY
    dec al
    cmp al, 2                    ; Y position of Brick 1
    jne SkipBrick1Check

    ; Brick 1 hit
    dec brick1Health
    neg ballDY                   ; Reverse vertical direction

    mov al, brick1Health
    cmp al,1
    jne sahiHai
    mov eax , col12
    mov colC1, eax

    sahiHai:

    mov al, brick1Health
    cmp al, 0
    jne ok
    ;increase score
    mov eax , points1
    mov ebx , score
    add eax, ebx
    mov score, eax

    ok:
    call DisplayScore            ; Update score display
    mov ecx, 1                   ; Indicate that a brick was hit
SkipBrick1Check:
    ret
CheckBrick1 ENDP

CheckBrick2 PROC
    xor eax, eax
    mov al, brick2Health
    cmp al, 0
    je SkipBrick2Check

    ; Check ball collision with Brick 2
    mov al, ballX
    cmp al, 34         ; Left bound of Brick 2
    jl SkipBrick2Check
    mov ah, ballX
    cmp ah, 46         ; Right bound of Brick 2
    jg SkipBrick2Check
    mov al, ballY
    dec al
    cmp al, 2                    ; Y position of Brick 2
    jne SkipBrick2Check

    ; Brick 2 hit
    dec brick2Health
    neg ballDY

    mov al, brick2Health
    cmp al,1
    jne sahiHai
    mov eax , col12
    mov colC2, eax

    sahiHai:
    
    mov al, brick2Health
    cmp al, 0
    jne ok

    ;increase score
    mov eax , points1
    mov ebx , score
    add eax, ebx
    mov score, eax
    
    ok:
    call DisplayScore
    mov ecx, 1
SkipBrick2Check:
    ret
CheckBrick2 ENDP

CheckBrick3 PROC
    
    xor eax, eax
    mov al, brick3Health
    cmp al, 0
    je SkipBrick3Check

    ; Check ball collision with Brick 3
    mov al, ballX
    cmp al, 47         ; Left bound of Brick 3
    jl SkipBrick3Check
    mov ah, ballX
    cmp ah, 59         ; Right bound of Brick 3
    jg SkipBrick3Check
    mov al, ballY
    dec al
    cmp al, 2                    ; Y position of Brick 3
    jne SkipBrick3Check

    ; Brick 3 hit
    dec brick3Health
    neg ballDY
    
    mov al, brick3Health
    cmp al,1
    jne sahiHai
    mov eax , col12
    mov colC3, eax

    sahiHai:
    mov al, brick3Health
    cmp al, 0
    jne ok

    ;increase score
    mov eax , points1
    mov ebx , score
    add eax, ebx
    mov score, eax

    ok:
    call DisplayScore
    mov ecx, 1
SkipBrick3Check:
    ret
CheckBrick3 ENDP

CheckBrick4 PROC
    xor eax, eax
    mov al, brick4Health
    cmp al, 0
    je SkipBrick4Check

    ; Check ball collision with Brick 4
    mov al, ballX
    cmp al, 21          ; Left bound of Brick 4
    jl SkipBrick4Check
    mov ah, ballX
    cmp ah, 33         ; Right bound of Brick 4
    jg SkipBrick4Check
    mov al, ballY
    dec al
    cmp al, 4                    ; Y position of Brick 4
    jne SkipBrick4Check

    ; Brick 4 hit
    dec brick4Health
    neg ballDY

    mov al, brick4Health
    cmp al,1
    jne sahiHai
    mov eax , col22
    mov colC4, eax

    sahiHai:
    
    mov al, brick4Health
    cmp al, 0
    jne ok

    ;increase score
    mov eax , points2
    mov ebx , score
    add eax, ebx
    mov score, eax

    ok:
    call DisplayScore
    mov ecx, 1
SkipBrick4Check:
    ret
CheckBrick4 ENDP

CheckBrick5 PROC
    
    xor eax, eax
    mov al, brick5Health
    cmp al, 0
    je SkipBrick5Check

    ; Check ball collision with Brick 5
    mov al, ballX
    cmp al, 34         ; Left bound of Brick 5
    jl SkipBrick5Check
    mov ah, ballX
    cmp ah, 46         ; Right bound of Brick 5
    jg SkipBrick5Check
    mov al, ballY
    dec al
    cmp al, 4                    ; Y position of Brick 5
    jne SkipBrick5Check

    ; Brick 5 hit
    dec brick5Health
    neg ballDY

    mov al, brick5Health
    cmp al,0
    jne wow11

    mov al, level
    cmp al,3
    jne wow11

    call specialBrick

    wow11:

    mov al, brick5Health
    cmp al,1
    jne sahiHai
    mov eax , col22
    mov colC5, eax

    sahiHai:
    
    mov al, brick5Health
    cmp al, 0
    jne ok

    ;increase score
    mov eax , points2
    mov ebx , score
    add eax, ebx
    mov score, eax

    ok:
    call DisplayScore
    mov ecx, 1
SkipBrick5Check:
    ret
CheckBrick5 ENDP

CheckBrick6 PROC
    xor eax, eax
    mov al, brick6Health
    cmp al, 0
    je SkipBrick6Check

    ; Check ball collision with Brick 6
    mov al, ballX
    cmp al, 47         ; Left bound of Brick 6
    jl SkipBrick6Check
    mov ah, ballX
    cmp ah, 59         ; Right bound of Brick 6
    jg SkipBrick6Check
    mov al, ballY
    dec al
    cmp al, 4                    ; Y position of Brick 6
    jne SkipBrick6Check

    ; Brick 6 hit
    dec brick6Health
    neg ballDY

    mov al, brick6Health
    cmp al,1
    jne sahiHai
    mov eax , col22
    mov colC6, eax

    sahiHai:
    
    mov al, brick6Health
    cmp al, 0
    jne ok

    ;increase score
    mov eax , points2
    mov ebx , score
    add eax, ebx
    mov score, eax


ok:
    call DisplayScore
    mov ecx, 1
SkipBrick6Check:
    ret
CheckBrick6 ENDP

CheckBrick7 PROC
    xor eax, eax
    mov al, brick7Health
    cmp al, 0
    je SkipBrick7Check

    ; Check ball collision with Brick 7
    mov al, ballX
    cmp al, 20          ; Left bound of Brick 7
    jl SkipBrick7Check
    mov ah, ballX
    cmp ah, 33         ; Right bound of Brick 7
    jg SkipBrick7Check
    mov al, ballY
    dec al
    cmp al, 6                    ; Y position of Brick 7
    jne SkipBrick7Check

    ; Brick 7 hit
    dec brick7Health
    neg ballDY

    mov al, brick7Health
    cmp al,1
    jne sahiHai
    mov eax , col32
    mov colC7, eax

    sahiHai:
    
    mov al, brick7Health
    cmp al, 0
    jne ok

    ;increase score
    mov eax , points3
    mov ebx , score
    add eax, ebx
    mov score, eax

ok:
    call DisplayScore
    mov ecx, 1
SkipBrick7Check:
    ret
CheckBrick7 ENDP

CheckBrick8 PROC
    xor eax, eax
    mov al, brick8Health
    cmp al, 0
    je SkipBrick8Check

    ; Check ball collision with Brick 8
    mov al, ballX
    cmp al, 34         ; Left bound of Brick 8
    jl SkipBrick8Check


    mov ah, ballX
    cmp ah, 46         ; Right bound of Brick 8
    jg SkipBrick8Check
    mov al, ballY

    dec al
    cmp al, 6                    ; Y position of Brick 8
    jne SkipBrick8Check

    ; Brick 8 hit
    dec brick8Health
    neg ballDY

    mov al, brick8Health
    cmp al,1
    jne sahiHai
    mov eax , col32
    mov colC8, eax

    sahiHai:
    
    mov al, brick8Health
    cmp al, 0
    jne ok

    ;increase score
    mov eax , points3
    mov ebx , score
    add eax, ebx
    mov score, eax

ok:
    call DisplayScore
    mov ecx, 1
SkipBrick8Check:
    ret
CheckBrick8 ENDP

CheckBrick9 PROC
    xor eax, eax
    mov al, brick9Health
    cmp al, 0
    je SkipBrick9Check

    ; Check ball collision with Brick 9
    mov al, ballX
    cmp al, 47         ; Left bound of Brick 9
    jl SkipBrick9Check


    mov ah, ballX
    cmp ah, 59         ; Right bound of Brick 9
    jg SkipBrick9Check
    mov al, ballY
    dec al
    cmp al, 6                    ; Y position of Brick 9
    jne SkipBrick9Check

    ; Brick 9 hit
    dec brick9Health
    neg ballDY

    mov al, brick9Health
    cmp al,1
    jne sahiHai
    mov eax , col32
    mov colC9, eax

    sahiHai:
    
    mov al, brick9Health
    cmp al, 0
    jne ok

    ;increase score
    mov eax , points3
    mov ebx , score
    add eax, ebx
    mov score, eax

ok:
    call DisplayScore
    mov ecx, 1
SkipBrick9Check:
    ret
CheckBrick9 ENDP

specialBrick PROC

  mov bh,0

  mov al, brick3Health
  cmp al, 0
  je skip11
  mov brick3Health , 0
  ;increase score
    mov eax , points1
    mov ebx , score
    add eax, ebx
    mov score, eax

  mov al, brick6Health
  cmp al, 0
  je skip11
  mov brick6Health ,0
  ;increase score
    mov eax , points2
    mov ebx , score
    add eax, ebx
    mov score, eax

  mov al, brick4Health
  cmp al, 0
  je skip11
  mov brick4Health ,0
  ;increase score
    mov eax , points2
    mov ebx , score
    add eax, ebx
    mov score, eax

  mov al, brick8Health
  cmp al, 0
  je skip11
  mov brick8Health ,0
  ;increase score
    mov eax , points3
    mov ebx , score
    add eax, ebx
    mov score, eax

  mov al, brick9Health
  cmp al, 0
  je skip11
  mov brick9Health,0
  ;increase score
    mov eax , points3
    mov ebx , score
    add eax, ebx
    mov score, eax

  skip11:

  call checkEND

  ret
specialBrick ENDP

checkEND PROC

  mov al, brick1Health
  cmp al, 0
  jg gyattt

  mov al, brick2Health
  cmp al, 0
  jg gyattt

  mov al, brick3Health
  cmp al, 0
  jg gyattt

  mov al, brick4Health
  cmp al, 0
  jg gyattt

  mov al, brick5Health
  cmp al, 0
  jg gyattt

  mov al, brick6Health
  cmp al, 0
  jg gyattt

  mov al, brick7Health
  cmp al, 0
  jg gyattt

  mov al, brick8Health
  cmp al, 0
  jg gyattt

  mov al, brick9Health
  cmp al, 0
  jg gyattt

  inc endFlag

  gyattt:
  ret

checkEND ENDP

DisplayLives PROC
    mov eax, 7
    call SetTextColor
    mov dl, 5
    mov dh, 2
    call Gotoxy
    mov edx, OFFSET msgLives
    call WriteString
    movzx eax, lives
    call WriteDec
    ret
DisplayLives ENDP

ClearScreen PROC
    ; Function to clear the entire screen manually

    mov eax, white             ; Set text color (white background, black text)
    call SetTextColor          ; Apply text color

    mov dl, 0                  ; Start at the top-left corner
    mov dh, 0                  ; (0,0) position on screen

    mov cx, 3000               ; 80 columns x 25 rows = 2000 characters
ClearLoop:
    call Gotoxy                ; Set cursor position
    mov al, ' '                ; Space character to clear
    call WriteChar             ; Write space to the screen
    inc dl                     ; Move to the next column
    cmp dl, 120                 ; If end of the row, reset
    jne Continue
    mov dl, 0                  ; Reset to the first column
    inc dh                     ; Move to the next row
Continue:
    loop ClearLoop             ; Repeat until the entire screen is cleared

    mov dl, 0                  ; Reset cursor position to (0,0)
    mov dh, 0
    call Gotoxy

    ret
ClearScreen ENDP

LoseLife PROC
    dec lives
   call PrintHearts
    call DisplayLives
   
    mov al, lives
    cmp al, 0
    jne ResetBall

    call ClearScreen

    ; Display game over

    mov edx, OFFSET msgGameOver
    call GameOver
    exit

ResetBall:

    call UpdatePlayer
    call DrawPlayer
    ; Reset ball and paddle
    movzx eax, OFFSET1
    add al, len
    mov bl , xPos
    mov ballX, bl
    movzx eax, wid
    shr eax, 1
    mov bl,yPos
    mov ballY, bl

    mov ballDX, 1
    mov ballDY, -1

    ret
LoseLife ENDP

GameOver PROC
call store_Name

 mov eax, black + (green*16)  ; black text on green background
    
    call SetTextColor
    call Clrscr
    mov dh,1
    mov dl,10
    call Gotoxy
    ; Step 2: Print ASCII art for the "Game Over" screen
    mov edx, OFFSET gameOverLine1
    call WriteString
    call Crlf
    mov dh,2
    mov dl,10
    call Gotoxy
    mov edx, OFFSET gameOverLine2
    call WriteString
    call Crlf
    mov dh,3
    mov dl,10
    call Gotoxy
    mov edx, OFFSET gameOverLine3
    call WriteString
    call Crlf
    mov dh,4
    mov dl,10
    call Gotoxy
    mov edx, OFFSET gameOverLine4
    call WriteString
    call Crlf
    mov dh,5
    mov dl,10
    call Gotoxy
    mov edx, OFFSET gameOverLine5
    call WriteString
    call Crlf
    mov dh,6
    mov dl,10
    call Gotoxy
    mov edx, OFFSET gameOverLine6
    call WriteString
    call Crlf
    mov dh,7
    mov dl,10
    call Gotoxy
    mov edx, OFFSET gameOverLine7
    call WriteString
    call Crlf

    mov dh,12
    mov dl,40
    call Gotoxy
    ; Step 3: Display the player's score
    mov edx, OFFSET scoreMessage
    call WriteString             ; Print "Your Score: "
    mov eax, score         ; Load player's score
    call WriteDec                ; Print the score
    call Crlf

    mov dh,15
    mov dl,40
    call Gotoxy
    ; Step 4: Prompt player to press any key to exit
    mov edx, OFFSET exitPrompt
    call WriteString
    call Crlf
    call Crlf
    call Crlf
    call Crlf
    call ReadKey                 ; Wait for the player to press a key

    ret
GameOver ENDP

CheckBallCollision PROC
    
    ; Check for collisions with all bricks
    call CheckBrickCollision

    ; Paddle collision (check this first)
    mov al, ballY
    cmp al, yPos
    jne CheckBottomCollision      ; If ball's Y is not at paddle level, check bottom collision
    mov al, ballX
    cmp al, xPos
    jl CheckBottomCollision       ; If ball's X is less than paddle's left edge, check bottom collision
    mov ah, ballX
    mov al, xPos
    add al, paddleLen             ; Adjust for ball width
    cmp ah, al
    jle ReverseVertical           ; If ball overlaps paddle, reverse vertical direction
    jmp CheckBottomCollision

ReverseVertical:
    neg ballDY                    ; Reverse the ball's vertical direction
    ret

CheckBottomCollision:
    ; Bottom boundary collision
    mov al, ballY
    cmp al, 20
    jne CheckTopCollision          ; If not at the bottom, check top collision

    mov ah, ballX                 ; Check if hitting bottom-left or bottom-right corner
    cmp ah, OFFSET1
    je BottomLeftCorner
    mov bl, OFFSET1
    add bl, len                   ; Compute right boundary
    cmp ah, bl
    je BottomRightCorner

    call LoseLife                 ; Lose life when hitting bottom
    ret

BottomLeftCorner:
    neg ballDY                    ; Reverse vertical direction
    neg ballDX                    ; Reverse horizontal direction
    ret

BottomRightCorner:
    neg ballDY                    ; Reverse vertical direction
    neg ballDX                    ; Reverse horizontal direction
    ret

CheckTopCollision:
    ; Top boundary collision
    mov al, ballY
    cmp al, 1
    jg CheckLeftRightCollision    ; If above top boundary, check left/right collision

    mov ah, ballX                 ; Check if hitting top-left or top-right corner
    cmp ah, OFFSET1
    je TopLeftCorner
    mov bl, OFFSET1
    add bl, len                   ; Compute right boundary
    cmp ah, bl
    je TopRightCorner

    neg ballDY                    ; Reverse vertical direction
    ret

TopLeftCorner:
    neg ballDY                    ; Reverse vertical direction
    neg ballDX                    ; Reverse horizontal direction
    ret

TopRightCorner:
    neg ballDY                    ; Reverse vertical direction
    neg ballDX                    ; Reverse horizontal direction
    ret

CheckLeftRightCollision:
    ; Left boundary collision
    mov al, ballX
    sub al, 2                     ; Adjust for ball width
    cmp al, OFFSET1
    jl HandleLeftCollision        ; If ball hits left boundary, handle it

    ; Right boundary collision
    mov al, ballX
    add al, 2                     ; Adjust for ball width
    mov bl, OFFSET1
    add bl, len                   ; Compute right boundary
    add bl, len
    cmp al, bl
    jge HandleRightCollision      ; If ball hits right boundary, handle it
    ret

HandleLeftCollision:
    neg ballDX                    ; Reverse horizontal direction
    ret

HandleRightCollision:
    neg ballDX                    ; Reverse horizontal direction
    ret

CheckBallCollision ENDP

MoveBall PROC
    ; Clear the current ball position
    mov dl, ballX
    mov dh, ballY
    call Gotoxy
    mov al, ' '
    call WriteChar

    ; Update ball position
    mov al, ballX
    add al, ballDX
    mov ballX, al
    mov al, ballY
    add al, ballDY
    mov ballY, al

    ; Check collisions
    call CheckBallCollision

    call DrawBall

    cmp Level, 1 
	je firstLevelSpeed
	cmp Level, 2
	je secondLevelSpeed 
    cmp Level, 3
	je thirdLevelSpeed 
	
    firstLevelSpeed: 
        mov eax,180
        call Delay
	jmp wahShera
	
    secondLevelSpeed:
	    mov eax,130
        call Delay
    jmp wahShera
    thirdLevelSpeed:
	    mov eax,70
        call Delay

    wahShera:

    ret
MoveBall ENDP

DrawBall PROC
    mov dl, ballX
    mov dh, ballY
    call Gotoxy
    mov edx, OFFSET ballChar
    call WriteString
    ret
DrawBall ENDP

DisplayDebugInfo PROC
    mov eax, 7                   ; Set text color to white
    call SetTextColor

    ; Display xPos
    mov dl, 5                    ; X position for debug info
    mov dh, 4                    ; Y position (below lives display)
    call Gotoxy
    mov edx, OFFSET debugXPosLabel
    call WriteString
    movzx eax, xPos
    call WriteDec

    ; Display yPos
    mov dl, 5                    ; X position
    mov dh, 5                    ; Next line (below xPos)
    call Gotoxy
    mov edx, OFFSET debugYPosLabel
    call WriteString
    movzx eax, yPos
    call WriteDec

    ; Display ballX
    mov dl, 5                    ; X position
    mov dh, 6                    ; Next line (below yPos)
    call Gotoxy
    mov edx, OFFSET debugBallXLabel
    call WriteString
    movzx eax, ballX
    call WriteDec

    ; Display ballY
    mov dl, 5                    ; X position
    mov dh, 7                    ; Next line (below ballX)
    call Gotoxy
    mov edx, OFFSET debugBallYLabel
    call WriteString
    movzx eax, ballY
    call WriteDec

    ; Display Brick 1 Health
    mov dl, 3                    ; X position
    mov dh, 8                    ; Next line (below ballY)
    call Gotoxy
    mov edx, OFFSET debugBrick1Health
    call WriteString
    movzx eax, brick1Health
    call WriteDec

    ; Display Brick 2 Health
    mov dl, 3                    ; X position
    mov dh, 9                    ; Next line
    call Gotoxy
    mov edx, OFFSET debugBrick2Health
    call WriteString
    movzx eax, brick2Health
    call WriteDec

    ; Display Brick 3 Health
    mov dl, 3                    ; X position
    mov dh, 10                   ; Next line
    call Gotoxy
    mov edx, OFFSET debugBrick3Health
    call WriteString
    movzx eax, brick3Health
    call WriteDec

    ; Display Brick 4 Health
    mov dl, 3                    ; X position
    mov dh, 11                   ; Next line
    call Gotoxy
    mov edx, OFFSET debugBrick4Health
    call WriteString
    movzx eax, brick4Health
    call WriteDec

    ; Display Brick 5 Health
    mov dl, 3                    ; X position
    mov dh, 12                   ; Next line
    call Gotoxy
    mov edx, OFFSET debugBrick5Health
    call WriteString
    movzx eax, brick5Health
    call WriteDec

    ; Display Brick 6 Health
    mov dl, 3                    ; X position
    mov dh, 13                   ; Next line
    call Gotoxy
    mov edx, OFFSET debugBrick6Health
    call WriteString
    movzx eax, brick6Health
    call WriteDec

    ; Display Brick 7 Health
    mov dl, 3                    ; X position
    mov dh, 14                   ; Next line
    call Gotoxy
    mov edx, OFFSET debugBrick7Health
    call WriteString
    movzx eax, brick7Health
    call WriteDec

    ; Display Brick 8 Health
    mov dl, 3                    ; X position
    mov dh, 15                   ; Next line
    call Gotoxy

    mov edx, OFFSET debugBrick8Health
    call WriteString
    movzx eax, brick8Health
    call WriteDec

    ; Display Brick 9 Health
    mov dl, 3                    ; X position
    mov dh, 16                   ; Next line
    call Gotoxy
    mov edx, OFFSET debugBrick9Health
    call WriteString
    movzx eax, brick9Health
    call WriteDec

    ; Display xPos
    mov dl, 5                    ; X position for debug info
    mov dh, 17                    ; Y position (below lives display)
    call Gotoxy
    mov edx, OFFSET debugLevel
    call WriteString
    movzx eax, level
    call WriteDec

    ret
DisplayDebugInfo ENDP

DisplayLevel PROC
  
  ; Display current level
    mov dl, 5                    ; X position for debug info
    mov dh, 3                    ; Y position (below lives display)
    call Gotoxy
    mov edx, OFFSET debugLevel
    call WriteString
    movzx eax, level
    call WriteDec
    ret
    
DisplayLevel ENDP


main PROC
call titlePage
     exit
main ENDP

END main