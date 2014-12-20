#include <msp430.h>

/* USER CODE START (section: InterruptVectors_init_c_prologue) */
/* User defined includes, defines, global variables and functions */
/* USER CODE END (section: InterruptVectors_init_c_prologue) */

/*
 *  ======== InterruptVectors_graceInit ========
 */
void InterruptVectors_graceInit(void)
{
}


/* Interrupt Function Prototypes */


/*
 *  ======== PORT1 Interrupt Service Routine ========
 *
 * Here are several important notes on using PORTx interrupt Handler:
 *
 * 1. User must explicitly clear the port interrupt flag before exiting
 *
 *    PxIFG &= ~(BITy);
 *
 * 2. User could also exit from low power mode and continue with main
 *    program execution by using the following instruction before exiting
 *    this interrupt handler.
 *
 *    __bic_SR_register_on_exit(LPMx_bits);
 *
 */
#pragma vector=PORT1_VECTOR
__interrupt void PORT1_ISR_HOOK(void)
{
    /* USER CODE START (section: PORT1_ISR_HOOK) */
    /* replace this comment with your code */
    /* USER CODE END (section: PORT1_ISR_HOOK) */
}
