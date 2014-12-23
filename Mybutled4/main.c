// Mybutled4.c - press button B1 to light LED1
// Responds to interrupts on input pin, LPM4 between interrupts
// Uses breadboard for leds and switch
// Olimex 1121STK board, LED1 active low on P2.3,
//   button B1 active low on P2.1
// J H Davies, 2006-11-18; IAR Kickstart version 3.41A
//----------------------------------------------------------------------
#include <msp430.h>                 // Specific device
#include <intrinsics.h>             // Intrinsic functions
//----------------------------------------------------------------------
// Pins for LEDs
#define red_LED     BIT3
#define B1          BIT1
//----------------------------------------------------------------------

void main (void)
{
    WDTCTL = WDTPW | WDTHOLD;   // Stop watchdog timer

    // Terminate unused ports
    P1DIR = 0xFF;               // Set all pins as inputs
    P1OUT = 0x00;               // Set output low
    P3DIR = 0xFF;
    P3OUT = 0x00;

    // Set up pins
    P2OUT &= ~red_LED;          // Preload red_LED off (active high!)
    P2DIR |= red_LED;           // Set pin with red_LED to output
    P2REN |= B1;                // Enable pull up/down resistor for B1 (P2.1)
    P2OUT |= B1;                // set as pull up resistor for B1 (P2.1)
    P2IES |= B1;                // Sensitive to negative edge (H->L)
    P2IFG &= ~B1;               // To prevent an immediate interrupt,
                                // clear the flag for P2.1 before enabling
                                // the interrupt.

    P2IE |= B1;                 // Enable interrupts for P2.1

    do {
        P2IFG = 0;                  // Clear any pending interrupts...
    } while (P2IFG != 0);           // ...until none remain

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
#pragma vector = PORT2_VECTOR
__interrupt void PORT2_ISR (void)
{
    P2OUT ^= red_LED;               // Toggle red_LED off
    P2IES ^= B1;                    // Toggle edge sensitivity

    do {
        P2IFG = 0;                  // Clear any pending interrupts...
    } while (P2IFG != 0);           // ...until none remain
}

