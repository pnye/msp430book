;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

DestStr		.usect ".bss",16,2				; Allocate 16 bytes (8 words) in RAM
                                            ; for destination string
fillDestination	.equ	R4					; Pointer to start of RAM
fillPattern		.equ	R5					; Pattern for fill

;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory
            .global RESET                   ; Define entry point

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

			mov.w   #0x0200,fillDestination ; Pointer to start of RAM
			mov.w	#0xa5a5,fillPattern		; Set the fill pattern

FillRAM:
 			mov.w   fillPattern ,0(fillDestination)	; Write to RAM
            incd.w  fillDestination         ; Step pointer to next word
            cmp.w   #0x0400,fillDestination ; Set flags for (R4 - end of RAM)
            jlo     FillRAM                 ; Repeat loop while
            								; fillDestination < end of RAM

			mov.w   #BeginSource,R14        ; Load address of source
            call    #MyStrCpy               ; Copy string (don't forget #!)
            jmp     $                       ; Infinite , empty loop

;-----------------------------------------------------------------------
; Copy source string starting in R14 to destination starting in R12
; Both registers overwritten; no local registers used
; No checks for overlap , space in destination , unterminated source ...
MyStrCpy:
            jmp     CopyTest
CopyLoop:
; This ought to be sufficient but the assembler complains...
			;mov.b   BeginSource,R6
			;sub.b	DestStr,R6
			;mov.b	@R14+,R6	; -1 allows for @R1+
; ...so I had to handle the wrapping around myself
			;mov.b	@R14+,R6
									; 0xFFFF allows for increment in @R1+
CopyTest:
            cmp.w	#EndSource+14,R14	; Set flags for (R14 - end of source)
            jlo		CopyLoop
            ret                     ; Yes: return to caller
;-----------------------------------------------------------------------

; Segment for constant data in ROM
BeginSource:                                ; String constant, stored
											; between 0xC000 and 0xFFFF
            .string "hello, world\n"        ; "" causes a '\0' to be appended
EndSource:
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
