#include <msp430.h>
//#include <io430x25x3.h>

// Pins for LEDs
#define red_LED     BIT0
#define green_LED   BIT6

/*
 * main.c
 */
int main(void) {
    WDTCTL = WDTPW | WDTHOLD;	 // Stop watchdog timer
	
    P1OUT = red_LED;            // Preload red LED on, green LED off
    P1DIR = red_LED|green_LED;
    TACTL = MC_2|ID_3|TASSEL_2|TACLR;   // Set up and start timer A

// Continous up mode, divide closk by 8, closk from SMCLK, clear timer
    for (;;){                   // Loop forever
        while ((TACTL & TAIFG) == 0){   // Wait for overflow
            }                           // doing nothing
        TACTL &= ~TAIFG;                // Clear overflow flag
        P1OUT ^= red_LED|green_LED;     // Toggle LEDs
    }                                   // Back around infinite loop
}
