#include "embARC.h"
#include "embARC_debug.h"

#define GPIO4B2_0_OFFSET	0
#define GPIO4B2_1_OFFSET	1
#define GPIO4B2_2_OFFSET	2
#define GPIO4B2_3_OFFSET	3

void t1_isr(void *ptr)
{
    // Clear IP first
    timer_int_clear(TIMER_1);

    uint32_t read_value;
    DEV_GPIO_PTR gpio_4b2 = gpio_get_dev(DFSS_GPIO_4B2_ID);

    gpio_4b2->gpio_read(&read_value, 1<<GPIO4B2_3_OFFSET);

    gpio_4b2->gpio_write(~read_value, 1<<GPIO4B2_3_OFFSET);

}

int main(void)
{
    DEV_GPIO_PTR gpio_4b2 = gpio_get_dev(DFSS_GPIO_4B2_ID);

    gpio_4b2->gpio_open(1<<GPIO4B2_3_OFFSET);

    // Reset TIMER1
    // Check whether TIMER1 is available before use it
    if(timer_present(TIMER_1))
    {
        // Stop TIMER1 & Disable its interrupt first
        timer_stop(TIMER_1);
        int_disable(INTNO_TIMER1);

        // Connect a ISR to TIMER1's interrupt
        int_handler_install(INTNO_TIMER1, t1_isr);

        // Enable TIMER1's interrupt
        int_enable(INTNO_TIMER1);

        // Start counting, 1 second request an interrupt
        timer_start(TIMER_1, TIMER_CTRL_IE, BOARD_CPU_CLOCK);
    }

    while(1);

    return E_SYS;
}