;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

; red LED
red_LED		.equ	BIT0

;Iterations of delay loop for about 0.1s (3 cycles/iteration)
DELAYLOOPS	.equ	27000

DelaySize	.equ	R12
CurrentSym	.equ	R5
LoopCounter	.equ	R4
myCounter	.equ	R14

; Durations of symbols for morse code in units of 0.1s
; LETTER gives gap between letters; ENDTX terminates Message
DOT			.equ	2
DASH		.equ	6
SPACE		.equ	2
LETTER 		.equ	0
ENDTX		.equ	0xFF



;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section
            .retainrefs                     ; Additionally retain any sections
                                            ; that have references to current
                                            ; section
;-------------------------------------------------------------------------------
RESET	mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

		bic.b	#red_LED,&P1OUT	; Preload LED off
		bis.b	#red_LED,&P1DIR	; Set red LED pin P1 to output
		clr.w	CurrentSym		; Initialize counter to step through msgs
		jmp		MessageTest		; Jump to test so it is evaluated first
MessageLoop
		bis.b	#red_LED,&P1OUT					; red LED is on
		mov.b	msgs(CurrentSym),DelaySize		; Load duration of delay as
												; parameter
		call	#DelayTenths					; Call subroutine
		bic.b	#red_LED,&P1OUT	; red LED off
		mov.w	#SPACE,DelaySize; Load duration of delay (space)
		call	#DelayTenths	; Call subroutine
		inc.w	CurrentSym		; Next symbol to send
MessageTest
		cmp.b	#ENDTX,msgs(CurrentSym)			; Reached end of Message?
		jne		MessageLoop						; No: go around loop
InfLoop
		jmp		InfLoop
DelayTenths
		jmp		LoopTest		; Start with test in case DelaySize = 0
OuterLoop
		mov.w	#DELAYLOOPS,LoopCounter	; Initialize loop counter
DelayLoop
		dec.w	LoopCounter
		jnz		DelayLoop
		dec.w	DelaySize
LoopTest
		cmp.w	#0,DelaySize
		jnz		OuterLoop
		ret

;-------------------------------------------------------------------------------
			.data
msgs		.word	DOT,DOT,DOT,LETTER
			.word	DASH,DASH,DASH,LETTER
			.word	DOT,DOT,DOT,ENDTX


;-------------------------------------------------------------------------------
                                            ; Main loop here
;-------------------------------------------------------------------------------


;-------------------------------------------------------------------------------
;           Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect 	.stack

;-------------------------------------------------------------------------------
;           Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
