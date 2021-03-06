;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

red_LED		.equ	BIT0

;Iterations of delay loop for about 0.1s (3 cycles/iteration)
DELAYLOOPS	.equ	27000

DelaySize	.equ	R12
LoopCounter	.equ	R4
;-------------------------------------------------------------------------------
			.title "MyTest1"
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
			mov.w	#5,DelaySize			; Delay size units of 0.1s
			call	#DelayTenths			; Call the sub routine
			xor.b	#red_LED,P1OUT			; Toggle LED
			jmp		InfLoop
;-------------------------------------------------------------------------------
; Subroutine to give delay of DelaySize*0.1s
; Parameter is passed in DelaySize and destroyed
; LoopCounter is used for loop counter but is not saved and restored
; Works correcly if DelaySize = 0: the test is executed first as in while(){}
;-------------------------------------------------------------------------------
DelayTenths:
			push.w	LoopCounter				; Stack R4: will be overwritten
			jmp		LoopTest				; Start with test in case DelaySize
											; equals 0
OuterLoop:
			mov.w	#DELAYLOOPS,LoopCounter	; Initialize loop counter
DelayLoop:									; [Clock cycles in brackets]
			dec.w	LoopCounter				; Decrement loop counter  [1]
			jnz		DelayLoop				; Repeat loop if not zero [2]
			dec.w	DelaySize				; Decrement number of 0.1 delays
LoopTest:
			cmp.w	#0,DelaySize			; Finished number of 0.1s delays
			jnz		OuterLoop				; No: go around delay loop again
			pop.w	LoopCounter				; Yes: restore R4 before returning
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
