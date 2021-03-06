#include <msp430.h>
#include <stdint.h>

/*
 * main.c
 */

#define DELAYLOOPS  50000

void main(void) {
    WDTCTL = WDTPW | WDTHOLD;	// Stop watchdog timer
	
    //volatile unsigned int LoopCtr;      // Loop counter: volatile!
    volatile uint16_t LoopCtr;

    P1OUT = ~BIT0|BIT6;
    P1DIR = BIT0|BIT6;

    for(;;){
        for (LoopCtr = DELAYLOOPS - 1; LoopCtr > 0; -- LoopCtr){
        }

        P1OUT ^= BIT0|BIT6;
    }
}
