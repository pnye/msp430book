#include <msp430.h> 


// Pins for LEDs
#define red_LED     BIT0
#define green_LED   BIT6

/*
 * main.c
 */
void main(void) {
    WDTCTL = WDTPW | WDTHOLD;	// Stop watchdog timer

    // set up red and green LEDs
    P1OUT = red_LED;            // Preload red LED on, green off
    P1DIR = red_LED|green_LED;  // Set pins with LEDs to output


    TACCR0 = 49999;             // Upper limit of count for TAR
    TACCTL0 = CCIE;             // Enable interrupts on Compare 0
    TACTL = TASSEL_2|MC_1|ID_3;
    // SMCLK, Up mode: the timer counts up to TACCR0, divide input by 8

    __enable_interrupt();       // Enable interrupts (intrinsic)
    for (;;){                   // Loop forever
    }
}

#pragma vector = TIMER0_A0_VECTOR
__interrupt void TA0_ISR (void)
{
    P1OUT ^= red_LED|green_LED; // Toggle LEDs
}
