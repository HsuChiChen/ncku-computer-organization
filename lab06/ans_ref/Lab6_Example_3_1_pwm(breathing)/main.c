#include "embARC.h"
#include "embARC_debug.h"

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
    /* change pins settings from gpio to pwm */
    arduino_pin_init();

    DEV_PWM_TIMER_PTR pwm_timer_0 = pwm_timer_get_dev(DW_PWM_TIMER_0_ID);
    pwm_timer_0->pwm_timer_open();

    ////////////////////////////////////////////////////////////////////////////////////////////////
    /** First way **/

    /* varaibles */
    uint32_t dc = 0;        // duty cycle
    uint32_t offset = 1;    // offset
    bool dir = true;        // +offset(brightening) or -offset(darkening)


    while(1)
    {
        if(dir)
            dc += offset;
        else
            dc -= offset;
         
        pwm_timer_0->pwm_timer_write(PWM_TIMER0, DEV_PWM_TIMER_MODE_PWM, 100000, dc);
        
        board_delay_ms(7, 0);

        if(dc == 100 || dc == 0)
            dir = !dir;
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////////////////////////////////////

    /** second way **/

    /*
    uint32_t dc;
    while(1)
    {
        for(dc=0;dc<100;dc++)
        {
            pwm_timer_0->pwm_timer_write(PWM_TIMER0, DEV_PWM_TIMER_MODE_PWM, 100000, dc);
            board_delay_ms(7, 0);
        }
        for(dc=100;dc>0;dc--)
        {
            pwm_timer_0->pwm_timer_write(PWM_TIMER0, DEV_PWM_TIMER_MODE_PWM, 100000, dc);
            board_delay_ms(7, 0);
        }
    }
    */

   ////////////////////////////////////////////////////////////////////////////////////////////////

    return E_SYS;
}