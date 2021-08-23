#include "embARC.h"
#include "embARC_debug.h"

#define GPIO4B2_0_OFFSET	0
#define GPIO4B2_1_OFFSET	1
#define GPIO4B2_2_OFFSET	2
#define GPIO4B2_3_OFFSET	3

#define MODE_RED    0
#define MODE_GREEN  1
#define MODE_BLUE   2

int main(void)
{
    /*
        R : 2 times
        G : 3 times
        B : 1 time
    */
    int R_max = 2, G_max = 3, B_max = 1;

    /* count => to count how many times */
    int count = 0;

    /*
        cs : current state
        ns : next state
        This is a concept of finite-state machine
    */
    int cs = MODE_RED;
    int ns;

    DEV_GPIO_PTR gpio_4b2 = gpio_get_dev(DFSS_GPIO_4B2_ID);

    gpio_4b2->gpio_open(1<<GPIO4B2_3_OFFSET|1<<GPIO4B2_2_OFFSET|1<<GPIO4B2_1_OFFSET);

    /*
        In order to avoid the last time stopping in a mode which LEDs aren't all zero
        So, I clear all LEDs first
    */
    gpio_4b2->gpio_write(0, 1<<GPIO4B2_3_OFFSET|1<<GPIO4B2_2_OFFSET|1<<GPIO4B2_1_OFFSET);


    /* finite-state machine */
    while(1)
    {
        switch(cs)
        {
            case MODE_RED :
                count++;
                if(count == R_max)  {ns = MODE_GREEN; count = 0;}  
                else                {ns = MODE_RED;}
                gpio_4b2->gpio_write(1<<GPIO4B2_3_OFFSET, 1<<GPIO4B2_3_OFFSET);
                board_delay_ms(500, 0);
                gpio_4b2->gpio_write(0<<GPIO4B2_3_OFFSET, 1<<GPIO4B2_3_OFFSET);
                board_delay_ms(500, 0);
                break;
            case MODE_GREEN :
                count++;
                if(count == G_max)  {ns = MODE_BLUE; count = 0;}  
                else                {ns = MODE_GREEN;}
                gpio_4b2->gpio_write(1<<GPIO4B2_2_OFFSET, 1<<GPIO4B2_2_OFFSET);
                board_delay_ms(500, 0);
                gpio_4b2->gpio_write(0<<GPIO4B2_2_OFFSET, 1<<GPIO4B2_2_OFFSET);
                board_delay_ms(500, 0);
                break;
            case MODE_BLUE :
                count++;
                if(count == B_max)  {ns = MODE_RED; count = 0;}  
                else                {ns = MODE_BLUE;}
                gpio_4b2->gpio_write(1<<GPIO4B2_1_OFFSET, 1<<GPIO4B2_1_OFFSET);
                board_delay_ms(500, 0);
                gpio_4b2->gpio_write(0<<GPIO4B2_1_OFFSET, 1<<GPIO4B2_1_OFFSET);
                board_delay_ms(500, 0);
                break;
        }
        cs = ns;
    }

    gpio_4b2->gpio_close();

    return E_SYS;
}