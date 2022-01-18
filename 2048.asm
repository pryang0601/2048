Title Final Project            
INCLUDE Irvine32.inc
main EQU start@0

keyboardInput PROTO ;keyboard w,s,a,d
generateRanNum PROTO    ;generate 2 in random position
moveUp PROTO
moveDown PROTO
moveRight PROTO
moveLeft PROTO
transpose PROTO
reverse PROTO
merge PROTO
compress PROTO
exitGame PROTO  ;check the game can continue or not
printBox PROTO
print2darray PROTO
Lobby PROTO
InstructionF PROTO
setColor PROTO
setScoreColor PROTO
printWin PROTO
printOver PROTO
printBye PROTO
printscore PROTO
BoxWidth=12
BoxHeight=6

.data
    gameoverStr1 BYTE "   _____          __  __ ______    ___ __      __ _____ _____  ",0
 	gameoverStr2 BYTE "  / ____|   /\   |  \/  |  ____|  / __ \ \    / /  ____|  __ \ ",0
 	gameoverStr3 BYTE " | |  __   /  \  | \  / | |__    | |  | \ \  / /| |__  | |__) |",0
 	gameoverStr4 BYTE " | | |_ | / /\ \ | |\/| |  __|   | |  | |\ \/ / |  __| |  _  / ",0
	gameoverStr5 BYTE " | |__| |/ ____ \| |  | | |____  | |__| | \  /  | |____| | \ \ ",0
	gameoverStr6 BYTE "  \_____/_/    \_\_|  |_|______|  \____/   \/   |______|_|  \_\",0
    gameWin1 BYTE "__     __ __   _    _     _      _ _____ _   _ ",0
    gameWin2 BYTE "\ \   / / __ \| |  | |   | |    | |_   _| \ | |",0
    gameWin3 BYTE " \ \_/ / |  | | |  | |   | |    | | | | |  \| |",0
    gameWin4 BYTE "  \   /| |  | | |  | |   | | /\ | | | | | . ` |",0
    gameWin5 BYTE "   | | | |__| | |__| |   | |/  \| |_| |_| |\  |",0
    gameWin6 BYTE "   |_|  \____/ \____/     \__/\__/|_____|_| \_|",0
    twoStr1 BYTE " ___   ___  _  _   ___  ",0
    twoStr2 BYTE "|__ \ / _ \| || | / _ \ ",0
    twoStr3 BYTE "   ) | | | | || || (_) |",0
    twoStr4 BYTE "  / /| | | |__   _> _ < ",0
    twoStr5 BYTE " / /_| |_| |  | || (_) |",0
    twoStr6 BYTE "|____|\___/   |_| \___/ ",0
    instructStr1 BYTE " _____ _   _  _____ _______ _____  _    _  _____ _______ _____ ____  _   _ ",0
    instructStr2 BYTE "|_   _| \ | |/ ____|__   __|  __ \| |  | |/ ____|__   __|_   _/ __ \| \ | |",0
    instructStr3 BYTE "  | | |  \| | (___    | |  | |__) | |  | | |       | |    | || |  | |  \| |",0
    instructStr4 BYTE "  | | | . ` |\___ \   | |  |  _  /| |  | | |       | |    | || |  | | . ` |",0
    instructStr5 BYTE " _| |_| |\  |____) |  | |  | | \ \| |__| | |____   | |   _| || |__| | |\  |",0
    instructStr6 BYTE "|_____|_| \_|_____/   |_|  |_|  \_\\____/ \_____|  |_|  |_____\____/|_| \_|",0
    cellsWritten DWORD ?
    attribute WORD (LENGTHOF twoStr1) DUP(0Ah)	;green
	attribute2 WORD (LENGTHOF instructStr1) DUP(0Eh)	;yellow
    platform  DWORD 0d,0d,0d,0d,0d,0d,0d,0d,0d,0d,0d,0d,0d,0d,2d,0d,0d,0d,0d,0d,0d,0d,0d,0d,0d,0d,0d,2d,0d,0d,0d,0d,0d,0d,0d,0d
    scorecount DWORD 0d

exitOrNot DWORD 0   ;game exit at the middle, initial:false
winner DWORD 0      ;test if any square added up to 2048, initial:false
outputHandle DWORD 0
count DWORD 0
xyStrPosition COORD <10,5>
xyBoxPosition COORD <7,3>
xyNumPosition COORD <9,5>
xyScorePosition COORD <55,4>
boxTop    BYTE 0DAh, (BoxWidth-2) DUP(0C4h),0BFh
boxBody   BYTE 0B3h, (BoxWidth-2) DUP(' '),0B3h
boxBottom BYTE 0C0h, (BoxWidth-2) DUP(0C4h),0D9h
pressStart BYTE "Press Space to start",0    ;interface
pressInstruct BYTE "Press I to see the instruction",0   ;interface
welcome BYTE "Welcome to" ;interface
blank BYTE (BoxWidth-5) DUP(' '),0      ;clear the number
pressw BYTE "-Press w or ^ to move up",0     ;instruction interface
pressa BYTE "-Press a or < to move left",0     ;instruction interface
presss BYTE "-Press s or v to move down",0     ;instruction interface
pressd BYTE "-Press d or > to move right",0     ;instruction interface
winInstruction BYTE "-Once one of the square add up to 2048, then you win the game",0
loseInstruction BYTE "-Once there is no empty square or no two square can be added together, then you lose the game",0
backtolobby BYTE "Press L back to the lobby",0
disscore BYTE "Your score is: ",0
disscoree BYTE "0",0
xyins COORD <20,5>      ;instruction interface start position
xylobby COORD <40,5>    ;lobby interface start position

.code

main PROC
	INVOKE GetStdHandle,STD_OUTPUT_HANDLE
    mov outputHandle,eax
    call Lobby      ;go to lobby first
    call Clrscr     ;clear screen
    call printBox   
    call print2darray
    call printscore
    gameloop:       ;start game
        call keyboardInput      ;move up/down/left/right
        call generateRanNum     ;generate new number in random empty square
	    call printBox
        call print2darray
        call printscore
        call exitGame           ;check whether it still can play the game or not 
        cmp exitOrNot,1         ;if exitOrNot equal to 0, end the game, jump to lose
        jz lose
        cmp winner,1    ;not in lose condition, if winner equal to 1, jump to win
        jz win      
        jmp gameloop      ;keep playing the game
    lose:       ;print game over
        call printOver
        jmp ENDGAME
    win:    ;print you win
        call printWin
    ENDGAME:
        call WaitMsg
main ENDP

keyboardInput PROC ;Read keyboard input
    call ReadKey
    call ReadChar
    .IF al==57h || al==77h || ax==4800h
        call moveUp
    .ELSEIF al==53h || al==73h || ax==5000h
        call moveDown
    .ELSEIF al==41h || al==61h || ax==4B00h
        call moveLeft
    .ELSEIF al==44h || al==64h || ax==4D00h
        call moveRight
    .ELSEIF ax==011Bh
        exit
    .ENDIF
        ret
keyboardInput ENDP

generateRanNum PROC USES eax ecx edi ;Generate random numbers
    mov esi,OFFSET platform
    mov ebx,0       ;first set ebx to 0 as a constant
    mov edi,28      ;the first valid element is the 7 element(start from 0)
    findempty:
	find2:
        mov eax,22  ;the range
        call RandomRange    ;generate the random number eax from 0-21
	    .IF eax==4 || eax==5 || eax==10 || eax==11 || eax==16 || eax==17    ;if eax=4,5,10,11,16,17 ,means the generate number in invalid place
		    jmp find2   ;find another place again
	    .ENDIF
	    add eax,7   ;because the valid element start at the 7 position
        shl eax,2   ;multiply eax with 4
        cmp [esi+eax],ebx ;whether the random position is 0 or not
        je newNum   ;equal to 0,put 2 inside
        jmp findempty   ;not equal to 0, find another position
    newNum:
	    mov ebx,2   ;change ebx to 2
        mov [esi+eax],ebx   ;put 2 in empty and valid position
    ret
generateRanNum ENDP

reverse PROC USES eax ebx esi edi ecx ebp 
    mov ecx,8 ;4 rows, each row reverse 2 time
    mov esi,OFFSET platform
    mov edi,28 ;the first row start valid position
    mov ebp,40 ;the first row end valid position
    rever:
        mov eax,[esi+edi] ;first element
	    mov ebx,[esi+ebp] ;second element
        mov [esi+edi],ebx ;change the position
        mov [esi+ebp],eax 
        add edi,4 ;the first element add 4 to next position
        sub ebp,4 ;the second element sub 4 to next position
        cmp edi,ebp 
        jc repeatLOOP  ;edi<ebp, repeat the loop
    next:  ;edi>ebp, the row already reverse it 2 time     
        add ebp,32 ;change to next row
        add edi,16
    repeatLOOP:
        LOOP rever
    ret    
reverse ENDP

transpose PROC USES eax ecx ebx esi edi 
    mov esi,OFFSET platform
    mov edi,28	;tempi(row)
    mov ecx,28	;tempj(column)
    tran:   ;change row element to column element
        mov eax,[esi+edi]
        mov ebx,[esi+ecx]
        mov [esi+edi],ebx
        mov [esi+ecx],eax
	.IF ecx==108 ;end of transpose
	    jmp tran2
	.ENDIF

    .IF ecx==100    ;if ecx goes to the end of first column
        add edi,16  ;edi goes to the second row,second column
        mov ecx,edi
	.ELSEIF ecx==104 ;if ecx goes to the end of second column
        add edi,20   ;edi goes to the thrid row,third column
	    mov ecx,edi
	.ELSE
	    add edi,4  ;edi goes to the next element in the same row
        add ecx,24 ;ecx goes to the next element in the next column
    .ENDIF
	jmp tran ;keep transpose
    tran2:
        ret
transpose ENDP

merge PROC USES ecx eax ebx esi edi ebp 
    mov ecx,12  ;4 rows, each row left merge 3 time
    mov esi,OFFSET platform
    mov edi,28  ;[i][j]
    mov ebp,32	;[i][j+1]
    mov ebx,0
    mer:
	    mov eax,[esi+edi]
        cmp eax,0
        jz mer4     ;if eax=0, no need to merge
    mer2:       ;if eax not equal to 0
        mov ebx,[esi+ebp]   ;ebx is the right element
        cmp eax,ebx     ;compare these two elements
        jz mer3         ;if equal the jump to mer3, merge it
        jmp mer4        ;if not equal then jump to mer4
    mer3:
        mov ebx,0       ;the right element clear to 0
        shl eax,1       ;the right add to the left one, eax*2
        mov [esi+edi],eax   ;refresh the left element
        mov [esi+ebp],ebx   ;refresh the right element
        add scorecount,eax   ;add the score
        call printscore
    mer4:
        .IF ebp==40 || ebp==64 || ebp==88 || ebp==112   ;go to the next row
            add edi,16  
            add ebp,16
        .ELSE       ;go to the next element
            add edi,4   
            add ebp,4
        .ENDIF
    LOOP mer
    ret
merge ENDP

compress PROC USES ecx eax ebx esi edi ebp edx 
    mov ecx,16      ;4 rows 4 columns
    mov eax,0       ;eax is the constant 0
    mov esi,OFFSET platform
    mov edi,28
    mov ebp,28
    mov edx,0	;test if changed
    com:
	    cmp [esi+edi],eax   ;if the element equal to 0
	    jz com4     
    com2:	;element not equal to 0, put the element in the left most valid position
        mov ebx,[esi+edi]
        mov [esi+ebp],ebx   ;esi+ebp is the left most position
        mov edx,1           ;edx change to 1
        cmp edi,ebp         ;if edi=ebp, no need to clear the position to 0
        je com4
    com3:
        mov [esi+edi],eax   ;clear the original element to 0 (already move to the left)
    com4:
        cmp edx,1
        jnz com5    ;no change, go to the next element
        add ebp,4   ;if changed, ebx+4
    com5:
        .IF edi==40 || edi==64 || edi==88 
            add edi,12
            mov ebp,edi
        .ELSE
            add edi,4
        .ENDIF
    mov edx,0   ;reset edx to initial 0
    LOOP com
    ret
compress ENDP

moveLeft PROC
    call printscore
    call compress 
    call merge 
    call compress 
    call printscore
    ret
moveLeft ENDP

moveRight PROC
    call reverse 
    call moveLeft
    call reverse 
    ret
moveRight ENDP

moveUp PROC
    call transpose 
    call moveLeft
    call transpose 
    ret
moveUp ENDP

moveDown PROC
    call transpose 
    call moveRight
    call transpose 
    ret
moveDown ENDP

exitGame PROC USES eax ebx ecx esi ;Determine whether to leave the game
    mov esi,OFFSET platform
    mov ebx,28
    checkHavenum:   ;whether there still have space for random number
	    mov eax,0   ;eax is the constant 0
        cmp [esi+ebx],eax   ;whether the element is 0
        je Exitfalse        ;still can play
	    mov eax,2048       
        cmp [esi+ebx],eax   ;whether the element is 2048
        je Exitwin          ;is the winner already
        add ebx,4       ;go to the next element
        .IF ebx==116        ;already check all valid element
            jmp checkAddnumSet  ;go to check whether there are 2 elements can be added together
	    .ELSEIF ebx==44 || ebx==68 ||ebx==92
		    add ebx,8       ;go to the next row
		    jmp checkHavenum
        .ELSE
            jmp checkHavenum
        .ENDIF
    checkAddnumSet:         ;reset esi and ebx
        mov esi,OFFSET platform     
        mov ebx,28
    checkAddnum:    ;whether numbers can be added to generate a new space ;platform is full
	    mov eax,[esi+ebx]
        mov edx,[esi+ebx-24]    ;up number
        cmp edx,eax 	;check up number
        jz Exitfalse    ;jump out the loop
	    mov eax,[esi+ebx]
        mov edx,[esi+ebx+24]    ;down number
        cmp edx,eax     ;check down number
        jz Exitfalse
	    mov eax,[esi+ebx]
        mov edx,[esi+ebx-4]
        cmp edx,eax     ;check left number
        jz Exitfalse
	    mov eax,[esi+ebx]
        mov edx,[esi+ebx+4]
        cmp edx,eax     ;check right number
        jz Exitfalse
        .IF ebx==112    ;if check to the end then exit the game
            jmp ExitTrue
        .ELSEIF ebx==40 || ebx==64 || ebx==88
	        add ebx,12      ;go to the next row
	        jmp checkAddnum
	    .ELSE
	        add ebx,4       ;go to the next element
            jmp checkAddnum ;check again
        .ENDIF
    Exitfalse:
        mov exitOrNot,0     ;no need to exit the game
        jmp exitg           ;return
    ExitTrue:
        mov exitOrNot,1     ;need to end the game, game over
        jmp exitg           ;return
    Exitwin:
        mov winner,1        ;win the game
    exitg:
        ret
exitGame ENDP

printBox PROC USES eax ecx ebx edx      ;print the square
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle,eax
    mov bx,7	;x start position
    mov xyBoxPosition.x,bx
    mov bx,3   ;y start position
    mov xyBoxPosition.y,bx
    mov edx,0       ;calculate the present square number
    mov eax,0       ;calculate the present square number in a row
    printB:
        push edx
        INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR boxTop,BoxWidth,xyBoxPosition,ADDR count
        inc xyBoxPosition.y
        mov ecx,BoxHeight-2
        L1: 
            push ecx  
            INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR boxBody,BoxWidth,xyBoxPosition,ADDR count
            inc xyBoxPosition.y   ; next line
            pop ecx         ; restore counter
            loop L1
        INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR boxBottom,BoxWidth,xyBoxPosition,ADDR count
        mov xyBoxPosition.y,bx
        add xyBoxPosition.x,10
        inc eax     ;print 1 square
        pop edx
        inc edx
        .IF edx==4 || edx==8 || edx==12     ;already print 4 square in a row
            mov eax,0
            add bx,5
            mov xyBoxPosition.y,bx  ;move y to next row
            mov xyBoxPosition.x,7   ;x start point
        .ENDIF
        .IF edx==16     ;print 16 squares, return
            jmp printB2
        .ELSE           ;print less than 16 squares, keep printing
            jmp printB
        .ENDIF
    printB2:
        ret
printBox ENDP

print2darray PROC USES ecx eax esi ebx
    mov ecx,16      ;4 rows 4 columns
    mov esi,OFFSET platform	;row index
    mov ebx,28
    mov dl,9   ;x
    mov dh,5    ;y
    call Gotoxy
    printarr:
        mov eax,[esi+ebx]
        call setColor
        call Gotoxy
        call WriteDec
        .IF ebx==40 || ebx==64 || ebx==88
            call Crlf       ;go to the next line
            mov dl,9        ;set the number in the first column
            jmp printarr3
        .ENDIF
        printarr2:
            add ebx,4
            add dl,10   ;print in the right position
            call Gotoxy
            push edx
            mov edx,OFFSET blank    ;clear the last array number
            call WriteString
            pop edx
            jmp printarr4
        printarr3:
            add ebx,12  ;the next row element
            add dh,5    ;the next row
	        mov dl,9
        printarr4:
            LOOP printarr
    call Crlf
    ret
print2darray ENDP

Lobby PROC 
	call Clrscr     ;clear sreen
	INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR welcome,LENGTHOF welcome,xylobby,ADDR count
	add xylobby.y,1
	sub xylobby.x,5
	INVOKE WriteConsoleOutputAttribute,outputHandle,ADDR attribute,LENGTHOF twoStr1,xylobby,ADDR cellswritten
	INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR twoStr1,LENGTHOF twoStr1,xylobby,ADDR count     ;print welcome
	add xylobby.y,1
	INVOKE WriteConsoleOutputAttribute,outputHandle,ADDR attribute,LENGTHOF twoStr1,xylobby,ADDR cellswritten
	INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR twoStr2,LENGTHOF twoStr2,xylobby,ADDR count 
	add xylobby.y,1	
	INVOKE WriteConsoleOutputAttribute,outputHandle,ADDR attribute,LENGTHOF twoStr1,xylobby,ADDR cellswritten
	INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR twoStr3,LENGTHOF twoStr3,xylobby,ADDR count 
	add xylobby.y,1
	INVOKE WriteConsoleOutputAttribute,outputHandle,ADDR attribute,LENGTHOF twoStr1,xylobby,ADDR cellswritten
	INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR twoStr4,LENGTHOF twoStr4,xylobby,ADDR count 
	add xylobby.y,1
	INVOKE WriteConsoleOutputAttribute,outputHandle,ADDR attribute,LENGTHOF twoStr1,xylobby,ADDR cellswritten
	INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR twoStr5,LENGTHOF twoStr5,xylobby,ADDR count 
	add xylobby.y,1
	INVOKE WriteConsoleOutputAttribute,outputHandle,ADDR attribute,LENGTHOF twoStr1,xylobby,ADDR cellswritten
	INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR twoStr6,LENGTHOF twoStr6,xylobby,ADDR count 
	add xylobby.y,3
	sub xylobby.x,20
    ;print instruction
	INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR pressInstruct,LENGTHOF pressInstruct,xylobby,ADDR count
	add xylobby.x,40
    ;print start
	INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR pressStart,LENGTHOF pressStart,xylobby,ADDR count
	call ReadChar
    ;if press F, go to the instruction interface
	.IF al==49h || al==69h
		sub xylobby.x,15    ;reset the xylobby coordinate
		sub xylobby.y,9
		call InstructionF
	.ELSEIF al==20h
		ret
	.ENDIF
	ret
Lobby ENDP

InstructionF PROC
	call Clrscr ;clear sreen
	INVOKE WriteConsoleOutputAttribute,outputHandle,ADDR attribute2,LENGTHOF instructStr1,xyins,ADDR cellswritten
	INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR instructStr1,LENGTHOF instructStr1,xyins,ADDR count 
	add xyins.y,1
	INVOKE WriteConsoleOutputAttribute,outputHandle,ADDR attribute2,LENGTHOF instructStr1,xyins,ADDR cellswritten
	INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR instructStr2,LENGTHOF instructStr2,xyins,ADDR count 
	add xyins.y,1
	INVOKE WriteConsoleOutputAttribute,outputHandle,ADDR attribute2,LENGTHOF instructStr1,xyins,ADDR cellswritten
	INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR instructStr3,LENGTHOF instructStr3,xyins,ADDR count 
	add xyins.y,1
	INVOKE WriteConsoleOutputAttribute,outputHandle,ADDR attribute2,LENGTHOF instructStr1,xyins,ADDR cellswritten
	INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR instructStr4,LENGTHOF instructStr4,xyins,ADDR count 
	add xyins.y,1
	INVOKE WriteConsoleOutputAttribute,outputHandle,ADDR attribute2,LENGTHOF instructStr1,xyins,ADDR cellswritten
	INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR instructStr5,LENGTHOF instructStr5,xyins,ADDR count 
	add xyins.y,1
	INVOKE WriteConsoleOutputAttribute,outputHandle,ADDR attribute2,LENGTHOF instructStr1,xyins,ADDR cellswritten
	INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR instructStr6,LENGTHOF instructStr6,xyins,ADDR count 
	sub xyins.x,10
	add xyins.y,3
	INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR pressw,LENGTHOF pressw,xyins,ADDR count    ;print up instruction
	add xyins.y,2
	INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR pressa,LENGTHOF pressa,xyins,ADDR count    ;print left instruction
	add xyins.y,2
	INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR presss,LENGTHOF presss,xyins,ADDR count    ;print down instruction
	add xyins.y,2
	INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR pressd,LENGTHOF pressd,xyins,ADDR count    ;print right instruction
	add xyins.y,2
	INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR winInstruction,LENGTHOF winInstruction,xyins,ADDR count    ;print the win rule
	add xyins.y,2
	INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR loseInstruction,LENGTHOF loseInstruction,xyins,ADDR count  ;print the lose rule
	add xyins.y,3   
	add xyins.x,3
	INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR pressStart,LENGTHOF pressStart,xyins,ADDR count    ;print start
	add xyins.x,30
	INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR backtolobby,LENGTHOF backtolobby,xyins,ADDR count  ;print lobby
	call ReadChar       ;if press b, then back to the lobby interface
	.IF al==4Ch || al==6Ch
	    sub xyins.x,21  ;reset the xyinstruction coordinate
	    sub xyins.y,21
	    call Lobby
	.ENDIF
	ret
InstructionF ENDP

setColor PROC USES eax
        .IF eax==2
            mov eax,13   ;lightMagenta
        .ELSEIF eax==4
            mov eax,2   ;green
        .ELSEIF eax==8
            mov eax,3   ;cyan
        .ELSEIF eax==16
            mov eax,15   ;white
        .ELSEIF eax==32
            mov eax,5   ;magenta
        .ELSEIF eax==64
            mov eax,9   ;light blue
        .ELSEIF eax==128
            mov eax,10   ;light green
        .ELSEIF eax==256
            mov eax,11   ;light cyan
        .ELSEIF eax==512
            mov eax,12   ;light red
        .ELSEIF eax==1024
            mov eax,14   ;yellow
        .ELSEIF eax==2048
            mov eax,4   ;red
        .ELSE
            mov eax,15
	.ENDIF
        call SetTextColor
	ret
setColor ENDP

setScoreColor PROC USES eax
    mov eax,15        
    call SetTextColor
	ret
setScoreColor ENDP

printOver PROC USES eax
	call Clrscr
	INVOKE GetStdHandle,STD_OUTPUT_HANDLE
    mov outputHandle,eax
    INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR gameoverStr1,LENGTHOF gameoverStr1,xyStrPosition,ADDR count
    INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR gameoverStr1,LENGTHOF gameoverStr1,xyStrPosition,ADDR count
    inc xyStrPosition.y
    INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR gameoverStr2,LENGTHOF gameoverStr2,xyStrPosition,ADDR count
    inc xyStrPosition.y
    INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR gameoverStr3,LENGTHOF gameoverStr3,xyStrPosition,ADDR count
    inc xyStrPosition.y
    INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR gameoverStr4,LENGTHOF gameoverStr4,xyStrPosition,ADDR count
	inc xyStrPosition.y
    INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR gameoverStr5,LENGTHOF gameoverStr5,xyStrPosition,ADDR count
	inc xyStrPosition.y
    INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR gameoverStr6,LENGTHOF gameoverStr6,xyStrPosition,ADDR count
	ret
printOver ENDP

printWin PROC USES eax
	call Clrscr
	INVOKE GetStdHandle,STD_OUTPUT_HANDLE
    mov outputHandle,eax
    INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR gameWin1,LENGTHOF gameWin1,xyStrPosition,ADDR count
    inc xyStrPosition.y
    INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR gameWin2,LENGTHOF gameWin2,xyStrPosition,ADDR count
    inc xyStrPosition.y
    INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR gameWin3,LENGTHOF gameWin3,xyStrPosition,ADDR count
    inc xyStrPosition.y
    INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR gameWin4,LENGTHOF gameWin4,xyStrPosition,ADDR count
	inc xyStrPosition.y
    INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR gameWin5,LENGTHOF gameWin5,xyStrPosition,ADDR count
	inc xyStrPosition.y
    INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR gameWin6,LENGTHOF gameWin6,xyStrPosition,ADDR count
	ret
printWin ENDP

printscore PROC USES eax ebx ;Enter in grades
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle,eax
    mov bx,55	;x start position
    mov xyScorePosition.x,bx
    INVOKE WriteConsoleOutputCharacter,outputHandle,ADDR disscore,LENGTHOF disscore,xyScorePosition,ADDR count
    mov eax,scorecount
    mov dl,72   ;x
    mov dh,4    ;y
    call Gotoxy
    call setScoreColor
    call WriteDec 
    ret
printscore ENDP

END main