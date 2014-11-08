;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
; ledson_assm.asm - simple program to light LEDs
; Sets pins to output, lights pattern of LEDs, then loops forever
; MSP430G2553 board with LEDs active high on P1.0 and P1.6;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory
            .global RESET                   ; define entry point
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section
            .retainrefs                     ; Additionally retain any sections
                                            ; that have references to current
                                            ; section
;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------------------------------------------------------
                                            ; Main loop here
;-------------------------------------------------------------------------------
SetupP1
; Here we set the output value first to prevent a random value in the register
; when the pin is set to be an output.
			mov.b	#BIT0,&P1OUT			; Turn on LED1
			bis.b	#BIT0|BIT6,&P1DIR		; Set P1.0 and P1.6 as outputs
											; These are the red and green LEDs

InfLoop:
			jmp		InfLoop					; Nothing is being done here

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
