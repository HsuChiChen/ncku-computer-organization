#include "embARC.h"
#include "embARC_debug.h"

#define GPIO4B2_0_OFFSET	0
#define GPIO4B2_1_OFFSET	1
#define GPIO4B2_2_OFFSET	2
#define GPIO4B2_3_OFFSET	3

int main(void)
{
    /* get 4b2 gpio object */
    DEV_GPIO_PTR gpio_4b2 = gpio_get_dev(DFSS_GPIO_4B2_ID);

    /* 
        Open GPIO
        input   : 0, 1, 2
        output  : 3
    */
    gpio_4b2->gpio_open(1<<GPIO4B2_3_OFFSET);

    while(1)
    {
        gpio_4b2->gpio_write(1<<GPIO4B2_3_OFFSET, 1<<GPIO4B2_3_OFFSET);

        /* delay 1 second */
        board_delay_ms(1000, 0);

        gpio_4b2->gpio_write(0<<GPIO4B2_3_OFFSET, 1<<GPIO4B2_3_OFFSET);
        // gpio_4b2->gpio_write(0, 1<<GPIO4B2_0_OFFSET);

        /* delay 1 second */
        board_delay_ms(1000, 0);
    }

    gpio_4b2->gpio_close();

    return E_SYS;
}