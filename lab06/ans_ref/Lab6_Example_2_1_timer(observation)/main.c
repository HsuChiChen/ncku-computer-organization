#include "embARC.h"
#include "embARC_debug.h"

void t1_isr(void *ptr)
{
    uint32_t cur_time;
    uint32_t CTRL;

    EMBARC_PRINTF("----- Enter TIMER1 ISR -----\n");

    /* Check out AUX_TIMER1_CTRL before clear IP */
    CTRL = _arc_aux_read(AUX_TIMER1_CTRL);
    EMBARC_PRINTF("Check AUX_TIMER1_CTR (before clear) : %d\n", CTRL);

    /* Check TIMER1 is continuing update after interrupt before clear IP */
    timer_current(TIMER_1, &cur_time);
    EMBARC_PRINTF("Check TIMER1 (after interrupt before clear IP) : %d\n", cur_time);

    /* Clear IP */
    EMBARC_PRINTF("$ TIMER1 clear IP\n");
    timer_int_clear(TIMER_1);

    /* Check out AUX_TIMER1_CTRL after clear IP */
    CTRL = _arc_aux_read(AUX_TIMER1_CTRL);
    EMBARC_PRINTF("Check AUX_TIMER1_CTR (after clear IP) : %d\n", CTRL);

    /* Check TIMER1 is continuing update after clear IP */
    timer_current(TIMER_1, &cur_time);
    EMBARC_PRINTF("Check TIMER1 (after clear IP) : %d\n", cur_time);

    /* Check us time before delay */
    cur_time = board_get_cur_us();
    EMBARC_PRINTF("Check current us time (before delay) : %d\n", cur_time);

    /*
        Try if we delay > 5*BOARD_CPU_CLOCK in ISR, what will happen
        Delay 6 seconds
    */
    EMBARC_PRINTF("$ Delay 6 seconds\n");
    board_delay_ms(6000, 0); // 6000 ms = 6 secs

    /* Check us time after delay */
    cur_time = board_get_cur_us();
    EMBARC_PRINTF("Check current us time (after delay) : %d\n", cur_time);

    /* Check out AUX_TIMER1_CTRL after delay */
    CTRL = _arc_aux_read(AUX_TIMER1_CTRL);
    EMBARC_PRINTF("Check AUX_TIMER1_CTR (after delay) : %d\n\n\n", CTRL);
}


int main(void)
{
    uint32_t cur_time;
    uint32_t CTRL;
    int pri;

    EMBARC_PRINTF("\n----- Start -----\n");

    /* Check t0 & t1 pri initial */
    pri = int_pri_get(INTNO_TIMER0);
	EMBARC_PRINTF("Check t0 pri (initial) : %d\n", pri);
    pri = int_pri_get(INTNO_TIMER1);
	EMBARC_PRINTF("Check t1 pri (initial) : %d\n", pri);

    /*
        Set t0 pri from -1 to -4
        3. Try comment #70 & #71, then run & check out
    */
    EMBARC_PRINTF("$ Set t0 pri -1 -> INT_PRI_MIN(-4)\n");
    int_pri_set(INTNO_TIMER0, INT_PRI_MIN);

    /* Check t0 pri after set */
    pri = int_pri_get(INTNO_TIMER0);
	EMBARC_PRINTF("Check t0 pri (after set) : %d\n", pri);


    if(timer_present(TIMER_0))
    {
        /* Check TIMER0 after start */
        timer_current(TIMER_0, &cur_time);
        EMBARC_PRINTF("Check TIMER0 (after start) : %d\n", cur_time);
    }

    if(timer_present(TIMER_1))
    {
        /* Check TIMER1 after start */
        timer_current(TIMER_1, &cur_time);
        EMBARC_PRINTF("Check TIMER1 (after start) : %d\n", cur_time);

        /* Reset TIMER1 */
        EMBARC_PRINTF("$ Reset TIMER1\n");
        EMBARC_PRINTF("$ Start TIMER1, Mode : TIMER_CTRL_IE, Limit : 5*BOARD_CPU_CLOCK\n");
        timer_stop(TIMER_1);
        int_disable(INTNO_TIMER1);
        int_handler_install(INTNO_TIMER1, t1_isr);
        int_enable(INTNO_TIMER1);
        timer_start(TIMER_1, TIMER_CTRL_IE, 5*BOARD_CPU_CLOCK);
        //timer_start(TIMER_1, TIMER_CTRL_IE|TIMER_CTRL_IP, 5*BOARD_CPU_CLOCK);
    }

    while(1)
    {
        /*
            1. Check how many times this line executes
            2. Turn on TIMER_CTRL_IP when TIMER1 start, Check whether this line is executable
        */
        EMBARC_PRINTF("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n");
        board_delay_ms(1000,0);
    }

    return E_SYS;
}