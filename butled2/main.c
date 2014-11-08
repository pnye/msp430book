/*  butled2 project
 *  main.c -        press button to light LED
 *  Two loops, one for each state of the button
 */
#include <msp430.h>

#define red_LED     BIT0
#define BTN         BIT3

/*
 * main.c
 */
void main(void) {
    WDTCTL = WDTPW | WDTHOLD;	// Stop watchdog timer
	P1OUT = (red_LED|BTN);
	P1DIR = red_LED;
	P1REN = BTN;
	
	for(;;) {
	    while ((P1IN & BTN) != 0){
	        }
	    // Action taken when button is pressed
	    P1OUT &= ~red_LED;

	    while ((P1IN & BTN) == 0){
	        }

	    // Actions taken when button is released
	    P1OUT |= red_LED;
	}

}
