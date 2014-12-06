// timrintC2.c - toggles LEDs with period of about 1.0s
// Processor enters low power mode 0 between ISRs (need SMCLK for timer)
// Toggle LEDs in ISR using interrupts from timer A CCR0
//   in Up mode with period of about 0.5s
// Timer clock is SMCLK divided by 8, up mode, period 50000
// Olimex 1121STK, red_LED,2 active low on P2.3,4
// J H Davies, 2006-10-11; IAR Kickstart version 3.41A
//----------------------------------------------------------------------
#include <msp430.h>                     // Specific device
#include <intrinsics.h>                 // Intrinsic functions
//----------------------------------------------------------------------
// Pins for LEDs
#define red_LED     BIT0
#define green_LED   BIT6
//----------------------------------------------------------------------
void main (void)
{
    WDTCTL = WDTPW|WDTHOLD;             // Stop watchdog timer
    P1OUT = ~red_LED;                   // Preload red_LED on, green_LED off
    P1DIR = red_LED|green_LED;          // Set pins with red_LED,2 to output
    TACCR0 = 49999;                     // Upper limit of count for TAR
    TACCTL0 = CCIE;                     // Enable interrupts on Compare 0
    TACTL = MC_1|ID_3|TASSEL_2|TACLR;   // Set up and start Timer A
// "Up to CCR0" mode, divide clock by 8, clock from SMCLK, clear timer
    __enable_interrupt();               // Enable interrupts (intrinsic)
    for (;;) {                          // Loop forever doing nothing
        __low_power_mode_0();           // Enter low power mode LPM0
    }                                   // Interrupts do the work!
}
//----------------------------------------------------------------------
// Interrupt service routine for Timer A channel 0
// Processor returns to LPM0 automatically after ISR
//----------------------------------------------------------------------
#pragma vector = TIMER0_A0_VECTOR
__interrupt void TA0_ISR (void)
{
        P1OUT ^= red_LED|green_LED;             // Toggle LEDs
}
