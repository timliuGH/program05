TITLE Sorting Random Integers     (Program05_Liu_Timothy.asm)

; Author: Timothy Liu
; Last Modified: November 5, 2018
; OSU email address: liutim@oregonstate.edu
; Course number/section: CS_271_400_F2018
; Project Number: 05              Due Date: November 18, 2018
; Description: This program will introduce the program, ask the user for a
;	value from [10, 200], generate that many random integers in the range
;	[100, 999], store the integers in an array, display the integers unsorted, 
;   sort the integers, calculate and display the median value, and display the
;	sorted list.

INCLUDE Irvine32.inc

MIN	= 10	; Lowest valid value for user request
MAX = 200	; Highest valid value for user request
LO = 100	; Lowest possible random integer
HI = 999	; Highest possible random integer

.data
intro_1			BYTE	"Sorting Random Integers", 09h, 09h, 09h
				BYTE	"Programmed by Timothy Liu", 0dh, 0ah, 0dh, 0ah, 0	; Program and programmer intro
intro_2			BYTE	"This program generates random numbers in the "
				BYTE	"range [100 .. 999], displays the original list, "
				BYTE	"sorts the list, ", 0dh, 0ah, "and calculates the "
				BYTE	"median. Finally, it displays the list sorted in "
				BYTE	"descending order.", 0dh, 0ah, 0dh, 0ah, 0			; Program description
promptText		BYTE	"How many numbers should be generated? "
				BYTE	"[10 .. 200]: ", 0									; Prompt to user to input value
request			DWORD	?													; Number of integers to generate, inputted by user
invalidInput	BYTE	"Invalid input", 0									; Text for invalid user input
unsortedText	BYTE	"The unsorted random numbers:", 0dh, 0ah, 0			; Text preceding unsorted list
medianText		BYTE	"The median is: ", 0								; Text preceding median of list
sortedText		BYTE	"The sorted list:", 0dh, 0ah, 0						; Text preceding sorted list

.code
main PROC
	call	introduction
	call	getData
	call	fillArray
	call	displayList		; Display unsorted list
	call	sortList
	call	displayMedian
	call	displayList		; Display sorted list

	exit					; Exit to operating system
main ENDP

; Description: Procedure to introduce the program and programmer
; Receives: none
; Returns: none
; Preconditions: none
; Registers changed: edx

introduction	PROC
; Display the program title and programmer name
	mov		edx, OFFSET intro_1
	call	WriteString
; Display program introduction
	mov		edx, OFFSET intro_2
	call	WriteString
	ret
introduction	ENDP

; Description: Procedure to get user input for number of integers to generate
; Receives: request variable passed as reference
; Returns: 
; Preconditions: 
; Registers changed: 

getData	PROC
prompt:
; Prompt user for number of values to generate
	mov		edx, OFFSET promptText
	call	WriteString
; Get user input
	call	ReadDec
; Check input is at least allowed MIN
	cmp		eax, MIN
	jl		retry
; Check input is at most allowed MAX
	cmp		eax, MAX
	jg		retry
	jmp		validInput
retry:
; Tell user input was invalid
	mov		edx, OFFSET invalidInput
	jmp		prompt
validInput:
; Store user input
	mov		request, eax
	ret
getData	ENDP

; Description: 
; Receives: 
; Returns: 
; Preconditions: 
; Registers changed: 

fillArray	PROC

	ret
fillArray	ENDP

; Description: 
; Receives: 
; Returns: 
; Preconditions: 
; Registers changed: 

displayList	PROC

	ret
displayList	ENDP

; Description: 
; Receives: 
; Returns: 
; Preconditions: 
; Registers changed: 

sortList	PROC

	ret
sortList	ENDP

; Description: 
; Receives: 
; Returns: 
; Preconditions: 
; Registers changed: 

displayMedian	PROC

	ret
displayMedian	ENDP

END main
