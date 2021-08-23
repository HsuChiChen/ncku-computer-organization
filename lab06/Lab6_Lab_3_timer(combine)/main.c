#include "embARC.h"
#include "embARC_debug.h"

#define GPIO4B2_0_OFFSET	0
#define GPIO4B2_1_OFFSET	1
#define GPIO4B2_2_OFFSET	2
#define GPIO4B2_3_OFFSET	3

/* 
    Record working(need to blink) LED
    light[0] : blue
    light[1] : green
    light[2] : red
*/
int light[3] = {0, 0, 0};

/*
    on_off = 1 => the working LEDs are light
    on_off = 0 => the working LEDs are dark
    To avoid compiler optimizing => so we use volatile
*/
volatile int on_off = 0;

void t1_isr(void *ptr)
{
    timer_int_clear(TIMER_1);

    uint32_t read_value;

    /* Prepare a write mask : which is working LEDs now */
    uint32_t write_mask = light[2] << GPIO4B2_3_OFFSET|light[1] << GPIO4B2_2_OFFSET|light[0] << GPIO4B2_1_OFFSET;

    DEV_GPIO_PTR gpio_4b2 = gpio_get_dev(DFSS_GPIO_4B2_ID);

    /* Get the current LEDs status */
    gpio_4b2->gpio_read(&read_value, 1<<GPIO4B2_3_OFFSET|1<<GPIO4B2_2_OFFSET|1<<GPIO4B2_1_OFFSET);

    /* Only opposite the working LEDs according the write mask */
    gpio_4b2->gpio_write(~read_value, write_mask);

    /* Opposite on_off */
    on_off ^= 1;
}

/*
    this function is to do switch mode
    And, if we switch mode, we need to let :
    1. "not working LEDs" become dark immediately
    2. "working LEDs" need to become on or off immediately according "on_off"
*/
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
            (All LEDs) become dark immediatly
            working LEDs : None
        */
        case 0 :
            gpio_4b2->gpio_write(0, 1<<GPIO4B2_3_OFFSET|1<<GPIO4B2_2_OFFSET|1<<GPIO4B2_1_OFFSET);
            light[2] = 0; light[1] = 0; light[0] = 0;
            EMBARC_PRINTF("mode 0 : R(0), G(0), B(0)\n");
            break;
        /*
            R : 0 => R : 1
            G : 0 => G : 0
            B : 0 => B : 0
            (Red) becomes light immediatly or not according "on_off"
            working LEDs : RED 
        */
        case 1 :
            if(on_off)
                gpio_4b2->gpio_write(~0, 1<<GPIO4B2_3_OFFSET);
            light[2] = 1;
            EMBARC_PRINTF("mode 1 : R(1), G(0), B(0)\n");
            break;
        /*
            R : 1 => R : 0
            G : 0 => G : 1
            B : 0 => B : 0
            (Red) becomes dark immediatly
            (Green) becomes light immediatly or not according "on_off"
            working LEDs : GREEN
        */
        case 2 :
            gpio_4b2->gpio_write(0, 1<<GPIO4B2_3_OFFSET);
            if(on_off)
                gpio_4b2->gpio_write(~0, 1<<GPIO4B2_2_OFFSET);
            light[2] = 0; light[1] = 1;
            EMBARC_PRINTF("mode 2 : R(0), G(1), B(0)\n");
            break;
        /*
            R : 0 => R : 0
            G : 1 => G : 0
            B : 0 => B : 1
            (Green) becomes dark immediatly
            (Blue) becomes light immediatly or not according "on_off"
            working LEDs : Blue
        */
        case 3 :
            gpio_4b2->gpio_write(0, 1<<GPIO4B2_2_OFFSET);
            if(on_off)
                gpio_4b2->gpio_write(~0, 1<<GPIO4B2_1_OFFSET);
            light[1] = 0; light[0] = 1;
            EMBARC_PRINTF("mode 3 : R(0), G(0), B(1)\n");
            break;
        /*
            R : 0 => R : 1
            G : 0 => G : 1
            B : 1 => B : 0
            (Blue) becomes dark immediatly
            (Red & Green) become light immediatly or not according "on_off"
            working LEDs : RED, GREEN
        */
        case 4 :
            gpio_4b2->gpio_write(0, 1<<GPIO4B2_1_OFFSET);
            if(on_off)
                gpio_4b2->gpio_write(~0, 1<<GPIO4B2_3_OFFSET|1<<GPIO4B2_2_OFFSET);
            light[2] = 1; light[1] = 1; light[0] = 0;
            EMBARC_PRINTF("mode 4 : R(1), G(1), B(0)\n");
            break;
        /*
            R : 1 => R : 0
            G : 1 => G : 1
            B : 0 => B : 1
            (Red) becomes dark immediatly
            (Blue) become light immediatly or not according "on_off"
            working LEDs : GREEN, BLUE
        */
        case 5 :
            gpio_4b2->gpio_write(0, 1<<GPIO4B2_3_OFFSET);
            if(on_off)
                gpio_4b2->gpio_write(~0, 1<<GPIO4B2_1_OFFSET);
            light[2] = 0; light[0] = 1;
            EMBARC_PRINTF("mode 5 : R(0), G(1), B(1)\n");
            break;
        /*
            R : 0 => R : 1
            G : 1 => G : 0
            B : 1 => B : 1
            (Green) becomes dark immediatly
            (Red) become light immediatly or not according "on_off"
            working LEDs : RED, BLUE
        */
        case 6 :
            gpio_4b2->gpio_write(0, 1<<GPIO4B2_2_OFFSET);
            if(on_off)
                gpio_4b2->gpio_write(~0, 1<<GPIO4B2_3_OFFSET);
            light[2] = 1; light[1] = 0;
            EMBARC_PRINTF("mode 6 : R(1), G(0), B(1)\n");
            break;
        /*
            R : 1 => R : 1
            G : 0 => G : 1
            B : 1 => B : 1
            (Green) become light immediatly or not according "on_off"
            working LEDs : RED, GREEN, BLUE
        */
        case 7 :
            if(on_off)
                gpio_4b2->gpio_write(~0, 1<<GPIO4B2_2_OFFSET);
            light[1] = 1;
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

    /*
        Reset TIMER_1
        every 0.5s throw a interrupt to do blink
    */
    if(timer_present(TIMER_1))
    {
        timer_stop(TIMER_1);
        int_disable(INTNO_TIMER1);
        int_handler_install(INTNO_TIMER1, t1_isr);
        int_enable(INTNO_TIMER1);
        timer_start(TIMER_1, TIMER_CTRL_IE, 0.5*BOARD_CPU_CLOCK);
    }

    
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