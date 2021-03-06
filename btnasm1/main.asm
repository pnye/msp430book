;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory;
red_LED		.equ	BIT0
BTN			.equ	BIT3

			.global	RESET					; define entry point
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section
            .retainrefs                     ; Additionally retain any sections
                                            ; that have references to current
                                            ; section
;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

SetupP1:
			mov.b	#(red_LED|BTN),&P1OUT	; Preload red LED to off.
											; Pin 3 resistor is set as a
											; pullup resistor
			bis.b	#red_LED ,&P1DIR		; Set red LED pin to output
			bis.b	#BTN ,&P1REN			; Enables a pullup resistor for BTN

;-------------------------------------------------------------------------------
                                            ; Main loop here
;-------------------------------------------------------------------------------
InfLoop:									; Loop forever
			bit.b	#BTN ,&P1IN				; Test bit BTN of P1IN
			jnz		ButtonUp
ButtonDown:									; Button is down
			bic.b	#red_LED ,&P1OUT		; Turn on red LED (active low!)
			jmp		InfLoop
ButtonUp:
			bis.b	#red_LED ,&P1OUT 		; Turn red LED off
			jmp		InfLoop
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
