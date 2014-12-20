// butled4.c - press button B1 to light LED1
// Responds to interrupts on input pin, LPM4 between interrupts
// Olimex 1121STK board, LED1 active low on P2.3,
//   button B1 active low on P2.1
// J H Davies, 2006-11-18; IAR Kickstart version 3.41A
//----------------------------------------------------------------------
#include <msp430.h>                 // Specific device
#include <intrinsics.h>             // Intrinsic functions
//----------------------------------------------------------------------
// Pins for LEDs
#define red_LED     BIT0
#define B1          BIT3
//----------------------------------------------------------------------

void main (void)
{
    WDTCTL = WDTPW | WDTHOLD;   // Stop watchdog timer

    // Terminate unused ports
    P2DIR = 0xFF;
    P2OUT = 0x00;
    P3DIR = 0xFF;
    P3OUT = 0x00;

    P1OUT &= ~red_LED;          // Preload red_LED off (active high!)
    P1DIR |= red_LED;           // Set pin with LED1 to output
    P1REN |= B1;                // Enable pull up/down resistor for B1 (P1.3)
    P1OUT |= B1;                // set as pull up resistor for B1 (P1.3)
    P1IES |= B1;                // Sensitive to negative edge (H->L)
    P1IFG &= ~BIT3;  // To prevent an immediate interrupt, clear the flag for
                     // P1.3 before enabling the interrupt.
    P1IE |= BIT3;    // Enable interrupts for P1.3

    do {
        P1IFG = 0;                  // Clear any pending interrupts...
    } while (P1IFG != 0);           // ...until none remain

    for (;;) {                      // Loop forever (should not need)
        __low_power_mode_4();       // LPM4 with int'pts, all clocks off
    }                               //   (RAM retention mode)
}
//----------------------------------------------------------------------
// Interrupt service routine for port 2 inputs
// Only one bit is active so no need to check which
// Toggle LED, toggle edge sensitivity, clear any pending interrupts
// Device returns to low power mode automatically after ISR
//----------------------------------------------------------------------
#pragma vector = PORT1_VECTOR
__interrupt void PORT1_ISR (void)
{
    P1OUT ^= red_LED;               // Toggle red_LED off
    P1IES ^= B1;                    // Toggle edge sensitivity

    do {
        P1IFG = 0;                  // Clear any pending interrupts...
    } while (P1IFG != 0);           // ...until none remain
}

