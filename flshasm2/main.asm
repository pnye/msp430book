;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory
red_LED		.equ	BIT0
green_LED	.equ	BIT6

DELAYLOOPS	.equ	50000

LoopCounter	.equ	R4

			.global	RESET					; Entry point
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section
            .retainrefs                     ; Additionally retain any sections
                                            ; that have references to current
                                            ; section
;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

			bic.b	#red_LED,&P1OUT			; Turn on the red LED
			bis.b	#green_LED,&P1OUT		; Turn off the green LED
			bis.b	#red_LED|green_LED,&P1DIR

InfLoop		mov.w	#DELAYLOOPS,LoopCounter	; Initialize loop counter

DelayLoop	dec.w  	LoopCounter				; Decrement loop counter
			jnz		DelayLoop				; Repeat loop if not zero
			xor.b	#red_LED|green_LED,&P1OUT
			jmp		InfLoop

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
