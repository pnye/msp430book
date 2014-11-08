/* pushy_G2211: a simple demo of configuring push-buttons on
 * input pins.
 */

#include <msp430g2553.h>

#define red_LED   BIT0
#define grn_LED   BIT6
#define BTN       BIT3

void delay(void);

void main(void) {
    unsigned int flash;
    WDTCTL = WDTPW + WDTHOLD;


    P1REN |= BIT3;               // Enables a pullup/pulldown resitor on pin 3
    P1OUT |= BIT3;               // Pin 3 resistor is set as a pullup resistor
    P1DIR |= red_LED + grn_LED;  // LED pins to outputs, BTN is
                                 // still an input by default.

    for (;;) {

        for (flash=0; flash<7; flash++) {
            P1OUT |= red_LED;    // red LED on
            delay();             // call delay function
            P1OUT &= ~red_LED;   // red LED off
            delay();             // delay again
        }

        while ((P1IN & BTN) == BTN);  // wait for button press

        for (flash=0; flash<7; flash++) {
            P1OUT |= grn_LED;    // green LED on
            delay();
            P1OUT &= ~grn_LED;   // green LED off
            delay();
        }

        while ((P1IN & BTN) == BTN);  // wait for button press

    }
} // main

void delay(void) {
    volatile unsigned int count;
    for (count=0; count<60000; count++);
} // delay
