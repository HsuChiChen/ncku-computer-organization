#include "embARC.h"
#include "embARC_debug.h"

#define GPIO4B2_0_OFFSET	0
#define GPIO4B2_1_OFFSET	1
#define GPIO4B2_2_OFFSET	2
#define GPIO4B2_3_OFFSET	3

/* change mode function */
int next_mode(DEV_GPIO_PTR gpio_4b2, int mode)
{
    mode++;
    if(mode == 8) {mode = 0;}

    switch(mode)
    {
        /*
            R : X => R : 0
            G : X => G : 0
            B : X => B : 0
        */
        case 0 : 
            gpio_4b2->gpio_write(0, 1<<GPIO4B2_3_OFFSET|1<<GPIO4B2_2_OFFSET|1<<GPIO4B2_1_OFFSET);
            EMBARC_PRINTF("mode 0 : R(0), G(0), B(0)\n");
            break;
        /*
            R : 0 => R : 1
            G : 0 => G : 0
            B : 0 => B : 0
        */
        case 1 :
            gpio_4b2->gpio_write(1<<GPIO4B2_3_OFFSET, 1<<GPIO4B2_3_OFFSET);
            EMBARC_PRINTF("mode 1 : R(1), G(0), B(0)\n");
            break;
        /*
            R : 1 => R : 0
            G : 0 => G : 1
            B : 0 => B : 0
        */
        case 2 :
            gpio_4b2->gpio_write(1<<GPIO4B2_2_OFFSET, 1<<GPIO4B2_3_OFFSET|1<<GPIO4B2_2_OFFSET);
            EMBARC_PRINTF("mode 2 : R(0), G(1), B(0)\n");
            break;
        /*
            R : 0 => R : 0
            G : 1 => G : 0
            B : 0 => B : 1
        */
        case 3 :
            gpio_4b2->gpio_write(1<<GPIO4B2_1_OFFSET, 1<<GPIO4B2_2_OFFSET|1<<GPIO4B2_1_OFFSET);
            EMBARC_PRINTF("mode 3 : R(0), G(0), B(1)\n");
            break;
        /*
            R : 0 => R : 1
            G : 0 => G : 1
            B : 1 => B : 0
        */
        case 4 :
            gpio_4b2->gpio_write(1<<GPIO4B2_3_OFFSET|1<<GPIO4B2_2_OFFSET, 1<<GPIO4B2_3_OFFSET|1<<GPIO4B2_2_OFFSET|1<<GPIO4B2_1_OFFSET);
            EMBARC_PRINTF("mode 4 : R(1), G(1), B(0)\n");
            break;
        /*
            R : 1 => R : 0
            G : 1 => G : 1
            B : 0 => B : 1
        */
        case 5 :
            gpio_4b2->gpio_write(1<<GPIO4B2_1_OFFSET, 1<<GPIO4B2_3_OFFSET|1<<GPIO4B2_1_OFFSET);
            EMBARC_PRINTF("mode 5 : R(0), G(1), B(1)\n");
            break;
        /*
            R : 0 => R : 1
            G : 1 => G : 0
            B : 1 => B : 1
        */
        case 6 :
            gpio_4b2->gpio_write(1<<GPIO4B2_3_OFFSET, 1<<GPIO4B2_3_OFFSET|1<<GPIO4B2_2_OFFSET);
            EMBARC_PRINTF("mode 6 : R(1), G(0), B(1)\n");
            break;
        /*
            R : 1 => R : 1
            G : 0 => G : 1
            B : 1 => B : 1
        */
        case 7 :
            gpio_4b2->gpio_write(1<<GPIO4B2_2_OFFSET, 1<<GPIO4B2_2_OFFSET);
            EMBARC_PRINTF("mode 7 : R(1), G(1), B(1)\n");
            break;
    }

    return mode;

}

int main(void)
{
    uint32_t read_value = 0;

    /* Record which mode is now : 0~7 */
    int mode = 0;

    DEV_GPIO_PTR gpio_4b2 = gpio_get_dev(DFSS_GPIO_4B2_ID);

    gpio_4b2->gpio_open(1<<GPIO4B2_3_OFFSET|1<<GPIO4B2_2_OFFSET|1<<GPIO4B2_1_OFFSET);

    /*
        In order to avoid the last time stopping in a mode which LEDs aren't all zero
        So, I clear all LEDs first
    */
    gpio_4b2->gpio_write(0, 1<<GPIO4B2_3_OFFSET|1<<GPIO4B2_2_OFFSET|1<<GPIO4B2_1_OFFSET);


    while(1)
    {
        gpio_4b2->gpio_read(&read_value, 1<<GPIO4B2_0_OFFSET);

        if(read_value == 1)
        {
            /* filter noise */
            board_delay_ms(30, 0);
            gpio_4b2->gpio_read(&read_value, 1<<GPIO4B2_0_OFFSET);
            if(read_value == 1)
            {
                EMBARC_PRINTF("next\n");
                /* change mode & update mode */
                mode = next_mode(gpio_4b2, mode);
                while(read_value == 1)
                {
                    gpio_4b2->gpio_read(&read_value, 1<<GPIO4B2_0_OFFSET);
                }
            }
        }
        /* Add a little delay avoid clicking button immediately */
        board_delay_ms(50, 0);
    }

    gpio_4b2->gpio_close();

    return E_SYS;
}