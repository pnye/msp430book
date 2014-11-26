;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

red_LED		.equ	BIT0

DelaySize	.equ	R12

;Iterations of delay loop for about 0.1s (3 cycles/iteration)
BIGLOOPS	.equ	130
LITTLELOOPS	.equ	100
;-------------------------------------------------------------------------------
			.title "substk1"
			.text                           ; Assemble into program memory
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section
            .retainrefs                     ; Additionally retain any sections
                                            ; that have references to current
                                            ; section

;-------------------------------------------------------------------------------
RESET:      mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT:    mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

			bis.b	#red_LED,&P1OUT			; Preload red LED off
			bis.b	#red_LED,&P1DIR			; Set pin with LED to output

InfLoop:
			push.w	#5						; Push delay parameter onto stack
			call	#DelayTenths			; Call the sub routine
			incd.w  SP						; Release space used for parameter
			xor.b	#red_LED,P1OUT			; Toggle LED
			jmp		InfLoop
;-------------------------------------------------------------------------------
; Subroutine to give delay of DelaySize*0.1s
; Parameter is passed in DelaySize and destroyed
; LoopCounter is used for loop counter but is not saved and restored
; Works correcly if DelaySize = 0: the test is executed first as in while(){}
;-------------------------------------------------------------------------------
DelayTenths:
			sub.w	#4,SP		 			; Allocate two words (4 bytes ) on stack
			jmp		LoopTest				; Start with test in case DelaySize
											; equals 0
OuterLoop:
			mov.w	#BIGLOOPS,2(SP)			; Initialize big loop counter
BigLoop:
			mov.w	#LITTLELOOPS,0(SP)		; Initialize little loop counter
LittleLoop:									; [Clock cycles in brackets]
			dec.w	0(SP)					; Decrement little loop counter [4]
			jnz		LittleLoop				; Repeat loop if not zero 		[2]
			dec.w	2(SP)					; Decrement big loop counter	[4]
			jnz		BigLoop					; Repeat loop if not zero		[2]
			dec.w	6(SP)					; Decrement number of 0.1s delays
LoopTest:
			cmp.w	#0,6(SP)				; Finished number of 0.1s delays
			jnz		OuterLoop				; No: go around delay loop again
			add.w	#4, SP					; Yes: finished, release space on
											; stack
			ret

;-------------------------------------------------------------------------------
                                            ; Main loop here
;-------------------------------------------------------------------------------


;-------------------------------------------------------------------------------
;           Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END, RESET
            .sect 	.stack

;-------------------------------------------------------------------------------
;           Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
