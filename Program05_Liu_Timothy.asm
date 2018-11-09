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

MIN	= 2			; Lowest valid value for user request
MAX = 200			; Highest valid value for user request; size of array
LO = 100			; Lowest possible random integer
HI = 999			; Highest possible random integer
MAX_PER_LINE = 10	; Max number of values allowed per display line
TAB = 9				; ASCII code for horizontal tab

.data
intro_1			BYTE	"Sorting Random Integers", TAB, TAB, TAB
				BYTE	"Programmed by Timothy Liu", 0dh, 0ah, 0dh, 0ah, 0	; Program and programmer intro
intro_2			BYTE	"This program generates random numbers in the "
				BYTE	"range [100 .. 999], displays the original list, "
				BYTE	"sorts the list, ", 0dh, 0ah, "and calculates the "
				BYTE	"median. Finally, it displays the list sorted in "
				BYTE	"descending order.", 0dh, 0ah, 0dh, 0ah, 0			; Program description
promptText		BYTE	"How many numbers should be generated? "
				BYTE	"[10 .. 200]: ", 0									; Prompt to user to input value
request			DWORD	?													; Number of integers to generate, inputted by user
invalidText		BYTE	"Invalid input", 0dh, 0ah, 0						; Text for invalid user input
array			DWORD	MAX DUP(?)											; Uninitialized array of 32-bit ints to hold random ints		
unsortedText	BYTE	"The unsorted random numbers:", 0dh, 0ah, 0			; Text preceding unsorted list
medianText		BYTE	0dh, 0ah, "The median: ", 0							; Text preceding median of list
sortedText		BYTE	"The sorted list:", 0dh, 0ah, 0						; Text preceding sorted list

.code
main PROC
	;call	Randomize			; Set seed for generating random numbers
; Introduce the program and programmer
	push	OFFSET intro_1		; Pass intro_1 by reference to introduction
	push	OFFSET intro_2		; Pass intro_2 by reference to introduction
	call	introduction

; Get user data
	push	OFFSET promptText	; Pass promptText by reference to getData
	push	OFFSET invalidText	; Pass invalidText by reference to getData
	push	OFFSET request		; Pass request variable by reference to getData
	call	getData

; Fill an array with 'request' number of values
	push	request				; Pass request variable by value to fillArray
	push	OFFSET array		; Pass array by reference to fillArray
	call	fillArray

; Display unsorted list
	push	request				; Pass request variable by value to displayList
	push	OFFSET array		; Pass array by reference to displayList
	push	OFFSET unsortedText	; Pass title of unsorted list to displayList
	call	displayList			

; Sort the array in descending order
	push	OFFSET array				; Pass address of array to sortList
	push	request						; Pass value of request to sortList
	call	sortList

; Calculate and display the median
	push	OFFSET array			; Pass address of array to displayMedian
	push	OFFSET medianText		; Pass address of medianText to displayMedian
	push	request					; Pass value of request to displayMedian
	call	displayMedian

; Display sorted list
	push	request				; Pass request variable by value to displayList
	push	OFFSET array		; Pass array by reference to displayList
	push	OFFSET sortedText	; Pass title of sorted list to displayList
	call	displayList				

	exit						; Exit to operating system
main ENDP

; Description: Procedure to introduce the program and programmer
; Receives: addresses of intro_1 and intro_2 passed by reference
; Returns: none
; Preconditions: none
; Registers changed: edx

introduction	PROC
; Set up access to stack frame
	push	ebp
	mov		ebp, esp

; Display the program title and programmer name
	mov		edx, [ebp+12]
	call	WriteString

; Display program introduction
	mov		edx, [ebp+8]
	call	WriteString

; Reset stack frame
	pop		ebp
	ret		8
introduction	ENDP

; Description: Procedure to get user input for number of integers to generate
; Receives: request variable, promptText, and invalidText passed by reference
; Returns: request variable with valid user input
; Preconditions: none
; Registers changed: eax, ebx, edx

getData	PROC
; Set up access to stack frame
	push	ebp	
	mov		ebp, esp

prompt:
; Prompt user for number of values to generate
	mov		edx, [ebp+16]
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
	mov		edx, [ebp+12]
	call	WriteString
	jmp		prompt

validInput:
; Store user input
	mov		ebx, [ebp+8]		; Get address of request variable
	mov		[ebx], eax			; Store valid user input

; Reset stack frame
	pop		ebp
	ret		12	
getData	ENDP

; Description: Procedure fills an array with random integers
; Receives: request variable by value and @ array
; Returns: array filled with 'request' many random integers
; Preconditions: request contains valid number
; Registers changed: 

fillArray	PROC
; Set up access to stack frame
	push	ebp
	mov		ebp, esp

; Save parameters
	mov		ecx, [ebp+12]		; Save value of request variable
	mov		esi, [ebp+8]		; Save address of array

	mov		eax, 0
fill:
	mov		[esi], eax
	inc		eax
	add		esi, 4
	loop	fill

; Reset stack frame
	pop		ebp
	ret		8
fillArray	ENDP

; Description: Procedure to display the list of integers in an array
; Receives: value of request variable, address of array passed by reference, title of list passed by reference
; Returns: none
; Preconditions: request variable contains valid number, and array contains 'request' number of values
; Registers changed: eax, ebx, ecx, edx, esi

displayList	PROC
; Set up access to stack frame
	push	ebp
	mov		ebp, esp

; Set up access to array via register indirect addressing
	mov		esi, [ebp+12]									; Save array address
	mov		ecx, [ebp+16]									; Save value of request variable

; Display title of array
	call	Crlf
	mov		edx, [ebp+8]
	call	WriteString

; Track number of values currently on line
	mov		ebx, 0

; Loop through array and print each value
arrayLoop:
	mov		eax, [esi]
	call	WriteDec			; Print array element
	mov		al, TAB				
	call	WriteChar			; Print horizontal tab
	inc		ebx					; Update number of values on current line
	cmp		ebx, MAX_PER_LINE	; Check if need to go to next line
	je		newline
	jmp		noNewline
newline:
	call	Crlf				; Go to next line
	mov		ebx, 0				; Reset counter
noNewline:
	add		esi, 4				; Go to next array element
	loop	arrayLoop
	call	Crlf

; Reset stack frame
	pop		ebp
	ret		12
displayList	ENDP

; Description: Procedure to sort an array of integers in descending order
; Receives: address of array passed by reference and value of request passed by value
; Returns: array of integers sorted in descending order
; Preconditions: array is initialized with 'request' number of values
; Registers changed: eax, ebx, ecx, edx, edi, esi

sortList	PROC
; Set up access to stack frame
	push	ebp
	mov		ebp, esp

; Save parameters
	mov		esi, [ebp+12]		; Save @ array
	mov		edi, [ebp+8]		; Save value of request

; Set up selection sort
	mov		ecx, edi			; Set up outer loop counter
	sub		ecx, 1				; Process array up to second-to-last element
	mov		edx, 0				; Start with first element
outerLoop:			 
	mov		eax, edx
	mov		ebx, edx			; Set up starting point for inner loop
	inc		ebx					; Start at one element after outer loop's element
innerLoop:
; Save index values in registers
	push	edi
	push	eax
	push	ebx
; Convert indices to bytes
	push	eax
	push	ebx
	call	makeBytes
; Compare elements in array
	add		esi, eax			; Go to first index in array
	mov		edi, [esi]			; Get element at first index
	sub		esi, eax			; Reset array pointer
	add		esi, ebx			; Go to second index in array
	cmp		[esi], edi			; Perform comparison
	jle		notGreater
; Retrieve stored index values
	sub		esi, ebx			; Reset array pointer
	pop		ebx
	pop		eax
	pop		edi
	mov		eax, ebx			; Update with index of larger element
	jmp		tryNext
notGreater:
	sub		esi, ebx			; Reset array pointer
	pop		ebx
	pop		eax
	pop		edi
tryNext:
	inc		ebx
	cmp		ebx, edi
	jl		innerLoop
; Convert indices to bytes
	push	eax
	push	edx
	call	makeBytes
; Exchange elements in array
	push	eax
	push	ebx
	push	esi
	call	exchange
	inc		edx
	loop	outerLoop

; Reset stack frame
	pop		ebp
	ret		8
sortList	ENDP

; Description: Sub-procedure to exchange the contents of two array elements with each other
; Receives: indices of the two elements to be exchanged, and @ array
; Returns: array with the two elements exchanged
; Preconditions: none
; Registers changed: none

exchange	PROC
; Set up access to stack frame
	pushad
	mov		ebp, esp

; Save parameters
	mov		esi, [ebp+36]	; Save @ array
	mov		eax, [ebp+44]	; Save byte index of one element
	mov		ebx, [ebp+40]	; Save byte index of other element

; Set up exchange
	add		esi, ebx		; Go to first element
	mov		edi, esi		; Save location of first element
	mov		edx, [esi]		; Save value of first element
	sub		esi, ebx		; Reset array pointer
	add		esi, eax		; Go to second element
	xchg	edx, [esi]		; Store first element at location of second element
	mov		[edi], edx		; Store second element at location of first element

; Restore stack frame
	popad
	ret		12
exchange	ENDP

; Description: Procedure to calculate and display the median
; Receives: address of array and medianText passed by reference and request variable passed by value
; Returns: none
; Preconditions: array is sorted
; Registers changed: eax, ebx, ecx, edx, esi

displayMedian	PROC
; Set up access to stack frame
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp+16]					; Save address of array
	mov		eax, [ebp+8]					; Save value of request

; Display median text
	mov		edx, [ebp+12]
	call	WriteString

; Check if array has even number of values
	mov		ecx, 2							; Set up divisor
	mov		edx, 0							; Clear remainder
	div		ecx
	cmp		edx, 0
	je		isEven

; Handle odd number of array elements
	mov		ebx, [esi+eax*4]				; Get element in middle of array
	mov		eax, ebx
	call	WriteDec						; Print out median
	call	Crlf
	jmp		resetStack

; Handle even number of array elements
isEven:
	mov		ebx, eax						; Save array index
	mov		eax, [esi+ebx*4]				; Get one of two elements in middle of array
	dec		ebx
	add		eax, [esi+ebx*4]				; Add the other element in middle of array
	mov		ecx, 2							; Set up divisor
	mov		edx, 0							; Clear remainder
	div		ecx
	cmp		edx, 0							; Check for remainder
	je		noRounding
	inc		eax								; Round up if remainder exists since remainder is either 0.0 or 0.5 because division by 2
noRounding:
	call	WriteDec						; Print out median	
	call	Crlf

resetStack:
; Reset stack frame
	pop		ebp
	ret		12
displayMedian	ENDP

; Description: Sub-procedure to convert array index to bytes
; Receives: values of two indices
; Returns: eax and ebx with indices converted to bytes
; Preconditions: none
; Registers changed: eax, ebx

makeBytes PROC
; Set up access to stack frame
	push	ebp
	push	edi
	push	edx
	mov		ebp, esp

; Get first index
	mov		eax, [ebp+16]

; Set up conversion (need to clear edx?)
	mov		edi, 4							; Set up multiplier
	mul		edi
	mov		ebx, eax						; Save result

; Get second index
	mov		eax, [ebp+20]

; Set up conversion (need to clear edx?)
	mul		edi

; Reset stack frame
	pop		edx
	pop		edi
	pop		ebp
	ret		8
makeBytes ENDP

END main
