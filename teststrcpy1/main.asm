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

			mov.w   #SourceStr,R14          ; Load address of source
            mov.w   #DestStr ,R12           ; Load address of destination
            call    #MyStrCpy               ; Copy string (don't forget #!)
            jmp     $                       ; Infinite , empty loop

;-----------------------------------------------------------------------
; Copy source string starting in R14 to destination starting in R12
; Both registers overwritten; no local registers used
; No checks for overlap , space in destination , unterminated source ...
MyStrCpy:
            jmp     CopyTest
CopyLoop:
            inc.w   R12               ; [1 word , 1 cycle] inc dst address
CopyTest:
            tst.b   0(R14)            ; [2 words , 4 cycles] test source
            mov.b   @R14+,0(R12)      ; [2 words , 5 cycles] copy src -> dst
            jnz     CopyLoop          ; [1 word , 2 cycles] continue if not \0
            ret                       ; Yes: return to caller
;-----------------------------------------------------------------------

; Segment for constant data in ROM
SourceStr:                                  ; String constant, stored
											; between 0xC000 and 0xFFFF
            .string "Hello World"        	; "" causes a '\0' to be appended

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
