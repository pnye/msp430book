;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

red_LED		.equ	BIT0
green_LED	.equ	BIT6

UpModePeriod	.equ	4999				; Period for up mode
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section
            .retainrefs                     ; Additionally retain any sections
                                            ; that have references to current
                                            ; section
;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

			mov.b	#red_LED,&P1OUT			; Preload red_led on, green_led off
			bis.b	#red_LED|green_LED,&P1DIR	; Set red and green led to output
			mov.w	#49999,&TACCR0	; Period for up mode
			mov.w	#CCIE,&TACCTL0			; Enable interrupts on compare 0
			mov.w	#MC_1|ID_3|TASSEL_2|TACLR,&TACTL	; Set up Timer A
;	UP mode, divide clock by 8, clock from SMCLK, clear TAR
			bis.w	#GIE,SR					; Enable interrupts (just TACCR0)
			jmp		$						; Loop forever; interrupts do all
;-------------------------------------------------------------------------------
; Interrupt service routine for TACCR0, called when TAR = TACCR0
; No need to acknowledge interrupt explicitly - done automatically
TA0_ISR:									; ISR for TACCR0 CCIFG
			xor.b	#red_LED|green_LED,&P1OUT	; Toggle LEDs
			reti							; That's all: return from interrupt

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
           	.sect ".int09" 					; Timer_A0 Vector
			.short TA0_ISR 					;

            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET


