#include "embARC.h"
#include "embARC_debug.h"

//ADC_DEFINE(adc_test, ADC_INT_NUM, ADC_CRTL_BASE, NULL);

void arduino_pin_init(void)
{
	io_arduino_config(ARDUINO_PIN_3, ARDUINO_PWM, IO_PINMUX_ENABLE);//pwm timer ch0
	io_arduino_config(ARDUINO_PIN_5, ARDUINO_PWM, IO_PINMUX_ENABLE);//pwm timer ch1
	io_arduino_config(ARDUINO_PIN_6, ARDUINO_PWM, IO_PINMUX_ENABLE);//pwm timer ch2
	io_arduino_config(ARDUINO_PIN_9, ARDUINO_PWM, IO_PINMUX_ENABLE);//pwm timer ch3
	io_arduino_config(ARDUINO_PIN_10, ARDUINO_PWM, IO_PINMUX_ENABLE);//pwm timer ch4
	io_arduino_config(ARDUINO_PIN_11, ARDUINO_PWM, IO_PINMUX_ENABLE);//pwm timer ch5
}

int main(void)
{
    /* change GPIO => PWM */
    arduino_pin_init();

    DEV_PWM_TIMER_PTR pwm_timer_0 = pwm_timer_get_dev(DW_PWM_TIMER_0_ID);
    pwm_timer_0->pwm_timer_open();

    /*
        dc[0] : red's dc
        dc[1] : green's dc
        dc[2] : blue's dc
    */
    uint32_t dc[3] = {0, 0, 0};

    /*
        offset[0] : red's offset
        offset[1] : green's offset
        offset[2] : blue's offset
    */
    uint32_t offset[3] = {5, 0 ,0};

    /* count => Already dc plus offset how many times */
    int count = 0;

    /* 1 time = (dc) 0->100 or 100->0 */
    int times = 0;

    /*
        color :
        0 => R =   0, G =   0, B =   0
        1 => R = 100, G =   0, B =   0
        2 => R = 100, G =  40, B =   0
        3 => R = 100, G = 100, B =   0
        4 => R =   0, G = 100, B =   0
        5 => R =   0, G =   0, B = 100
        6 => R = 100, G =   0, B = 100
        7 => R = 100, G = 100, B = 100
    */
    int color = 0;

    /*
        dir :
        0 => lighten, 0->100
        1 => darken,  100->0
    */
    bool dir = true;
    while(1)
    {
        /* According dir to do lighten or darken */
        if(dir)
        {
            dc[0] += offset[0];
            dc[1] += offset[1];
            dc[2] += offset[2];
        }
        else
        {
            dc[0] -= offset[0];
            dc[1] -= offset[1];
            dc[2] -= offset[2];
        }

        pwm_timer_0->pwm_timer_write(PWM_TIMER0, DEV_PWM_TIMER_MODE_PWM, 100000, dc[0]);
        pwm_timer_0->pwm_timer_write(PWM_TIMER1, DEV_PWM_TIMER_MODE_PWM, 100000, dc[1]);
        pwm_timer_0->pwm_timer_write(PWM_TIMER2, DEV_PWM_TIMER_MODE_PWM, 100000, dc[2]);
        //EMBARC_PRINTF("%d\n", dc);
        board_delay_ms(35, 0);
        count++;

        /*
            if count == 20 means :
                1. dc reachs max or
                2. dc reachs 0
            So, we need to change dir & times plus 1
        */
        if(count == 20)
        {
            count = 0;
            dir = !dir;
            times++;
            /*
                if timers == 4 means :
                    blinky 2 times
                    ( 0->100, 100->0, 0->100, 100->0 )
                So, we need to change color & return times to 0
            */
            if(times == 4)
            {
                times = 0;
                color++;
                if(color == 7)
                    color = 0;
                switch(color)
                {
                    case 0: // red
                        offset[0] = 5;
                        offset[1] = 0;
                        offset[2] = 0;
                        break;
                    case 1 : // orange
                        offset[0] = 5;
                        offset[1] = 2;
                        offset[2] = 0;
                        break;
                    case 2 : // yellow
                        offset[0] = 5;
                        offset[1] = 5;
                        offset[2] = 0;
                        break;
                    case 3 : // green
                        offset[0] = 0;
                        offset[1] = 5;
                        offset[2] = 0;
                        break;
                    case 4 : // blue
                        offset[0] = 0;
                        offset[1] = 0;
                        offset[2] = 5;
                        break;
                    case 5 : // purple
                        offset[0] = 5;
                        offset[1] = 0;
                        offset[2] = 5;
                        break;
                    case 6 : // white
                        offset[0] = 5;
                        offset[1] = 5;
                        offset[2] = 5;
                        break;
                }
            }
        }
    }

    return E_SYS;
}