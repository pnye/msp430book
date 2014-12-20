#include <msp430.h> 
/*
 * main.c
 */

void ConfigPins(void)
{
     P1DIR = ~BIT3; // P1.3 input, others output
     P1OUT = 0; // clear output pins
     P2SEL = ~(BIT6 + BIT7); // P2.6 and 7 GPIO
     P2DIR |= BIT6 + BIT7; // P2.6 and 7 outputs
     P2OUT = 0; // clear output pins
}

int main(void) {
    WDTCTL = WDTPW | WDTHOLD;   // Stop watchdog timer

    ConfigPins();

// Set P1.4 as out put driven low initially
//    P1SEL &= (~BIT4);           // Set P1.4 SEL for GPIO
//    P1DIR |= BIT4;              // Set P1.4 as Output
//    P1OUT &= (BIT4);           // P1.4 is driven low (0) by default

// Set pin P1.2 as input CCI1A to Timer_A
//    P1DIR |= BIT2;
//    P1SEL &= BIT2;

//    P1OUT &= ~(BIT1);
	return 0;
}
