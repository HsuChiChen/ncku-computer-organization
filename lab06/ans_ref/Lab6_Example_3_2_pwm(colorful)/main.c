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

    // PWM_TIMER0 : RED
    // PWM_TIMER1 : GREEN
    // PWM_TIMER2 : BLUE

    while(1)
    {
        // #e7b07e
        pwm_timer_0->pwm_timer_write(PWM_TIMER0, DEV_PWM_TIMER_MODE_PWM, 100000, 91);
        pwm_timer_0->pwm_timer_write(PWM_TIMER1, DEV_PWM_TIMER_MODE_PWM, 100000, 69);
        pwm_timer_0->pwm_timer_write(PWM_TIMER2, DEV_PWM_TIMER_MODE_PWM, 100000, 49);
        board_delay_ms(2000, 0);

        // #71baef
        pwm_timer_0->pwm_timer_write(PWM_TIMER0, DEV_PWM_TIMER_MODE_PWM, 100000, 44);
        pwm_timer_0->pwm_timer_write(PWM_TIMER1, DEV_PWM_TIMER_MODE_PWM, 100000, 73);
        pwm_timer_0->pwm_timer_write(PWM_TIMER2, DEV_PWM_TIMER_MODE_PWM, 100000, 94);
        board_delay_ms(2000, 0);

        // #605de5
        pwm_timer_0->pwm_timer_write(PWM_TIMER0, DEV_PWM_TIMER_MODE_PWM, 100000, 38);
        pwm_timer_0->pwm_timer_write(PWM_TIMER1, DEV_PWM_TIMER_MODE_PWM, 100000, 36);
        pwm_timer_0->pwm_timer_write(PWM_TIMER2, DEV_PWM_TIMER_MODE_PWM, 100000, 90);
        board_delay_ms(2000, 0);

        // #ee20df
        pwm_timer_0->pwm_timer_write(PWM_TIMER0, DEV_PWM_TIMER_MODE_PWM, 100000, 93);
        pwm_timer_0->pwm_timer_write(PWM_TIMER1, DEV_PWM_TIMER_MODE_PWM, 100000, 13);
        pwm_timer_0->pwm_timer_write(PWM_TIMER2, DEV_PWM_TIMER_MODE_PWM, 100000, 87);
        board_delay_ms(2000, 0);
    }

    return E_SYS;
}