#include <msp430.h> 

/*
 * main.c - simple program to light LEDs
 * Sets pins to output, lights pattern of LEDs, then loops forever
 * MSP430G2553 board with LEDs active high on P1.0 and P1.6
 */
void main(void) {
    WDTCTL = WDTPW | WDTHOLD;	            // Stop watchdog timer

    P1DIR = 0x41;                           // P1.0 & 6 output (red/green LEDs)
    P1OUT = 0x40;                           // LEDs off

    while(1)
    {
    }
}
