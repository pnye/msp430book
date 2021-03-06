#include <msp430.h> 
#include <stdint.h>

// Pins for LEDs
#define red_LED     BIT0
#define green_LED   BIT6
// Parameters for shift register; length <= 15 (4 is good for testing)
#define REGLENGTH   4
#define LASTMASK    ((uint16_t) (BIT0  << REGLENGTH))
#define NEXTMASK    ((uint16_t) (BIT0  << REGLENGTH - 1))
/*
 * main.c
 */
void main(void) {

    uint16_t pattern;           // Next pattern to be displayed
    WDTCTL = WDTPW | WDTHOLD;	// Stop watchdog timer

    P1OUT = red_LED|green_LED;  // Preload LEDs off
    P1DIR = red_LED|green_LED;  // Set pins with LEDs to output
    TACCR0 = 49999;             // Upper limit of count for TAR
    TACTL = MC_1|ID_3|TASSEL_2|TACLR; // Set up and start Timer A
// "Up to CCR0" mode, divide clock by 8, clock from SMCLK, clear timer
    pattern = 1;

    for (;;){                           // Loop forever
        while (TAIFG == 0){             // Wait for timer to overflow
        }
        //TAIFG << 0;                   // Clear overflow flag
        TACTL &= BIT0;                  // CLEARING TAIFG
        P1OUT = pattern;                // Update pattern (lower byte)
        pattern <<= 1;                  // Shift for next pattern
// Mask two most significant bits, simulate XOR using switch, feed back
        switch (pattern & (LASTMASK|NEXTMASK)){
        case LASTMASK:
        case NEXTMASK:
            pattern |= BIT0;            // XOR gives 1
            break;
        default:
            pattern &= ~BIT0;           // XOR gies 0
            break;
        }
    }
}
