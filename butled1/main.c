/*
 * ======== Standard MSP430 includes ========
 */
#include <msp430.h>

/*
 * ======== Grace related includes ========
 */
#include <ti/mcu/msp430/Grace.h>

/*
 *  ======== main ========
 */

#define BTN     BIT3
#define red_LED BIT0
#define grn_LED BIT6

void main(void)
{
    Grace_init();                   // Activate Grace-generated configuration
    
    // >>>>> Fill-in user code here <<<<<
    P1OUT |= grn_LED;                       // P1.6 on (green LED)
    _delay_cycles(30000);
    P1OUT &= ~grn_LED;                      // green LED off

    for (;;){

        while ((P1IN & BTN) == BTN);        // Wait for button to be pushed

        P1OUT ^= red_LED;                   // Toggle the red LED
     }
}

