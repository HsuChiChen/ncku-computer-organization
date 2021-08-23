#include "embARC.h"
#include "embARC_debug.h"

#define GPIO4B2_0_OFFSET	0 //signal
#define GPIO4B2_1_OFFSET	1 //R
#define GPIO4B2_2_OFFSET	2 //G
#define GPIO4B2_3_OFFSET	3 //B

int main(void)
{
    /* get 4b2 gpio object */
    DEV_GPIO_PTR gpio_4b2 = gpio_get_dev(DFSS_GPIO_4B2_ID);

    /* 
        Open GPIO
        input   : 0
        output  : 1, 2, 3
    */
    gpio_4b2->gpio_open(1<<GPIO4B2_1_OFFSET | 1<<GPIO4B2_2_OFFSET | 1<<GPIO4B2_3_OFFSET);

    uint32_t read_value = 0;
    uint32_t state = 0;

    while(1)
    {
        /*
            if on  => read_value = 0b1110
            if off => read_value = 0b0000
        */

        //gpio_4b2->gpio_read(&read_value, 1<<GPIO4B2_0_OFFSET);

        gpio_4b2->gpio_read(&read_value, 1<<GPIO4B2_0_OFFSET);
        if(read_value == 1)
        {
            if(state == 7)
            {
                state = 0;
                gpio_4b2->gpio_read(&read_value, 1<<GPIO4B2_0_OFFSET);
                while(read_value == 1)
                {
                    gpio_4b2->gpio_read(&read_value, 1<<GPIO4B2_0_OFFSET);
                    switch(state)
                    {
                        case 0:
                        {
                            gpio_4b2->gpio_write(0<<GPIO4B2_1_OFFSET | 0<<GPIO4B2_2_OFFSET | 0<<GPIO4B2_3_OFFSET, 1<<GPIO4B2_3_OFFSET | 1<<GPIO4B2_2_OFFSET | 1<<GPIO4B2_1_OFFSET);
                            EMBARC_PRINTF("0\n");
							break;    
						}
						case 1:
						{
							gpio_4b2->gpio_write(1<<GPIO4B2_1_OFFSET | 0<<GPIO4B2_2_OFFSET | 0<<GPIO4B2_3_OFFSET, 1<<GPIO4B2_3_OFFSET | 1<<GPIO4B2_2_OFFSET | 1<<GPIO4B2_1_OFFSET);
							EMBARC_PRINTF("1\n");
							break; 
						}
						case 2:
						{
							gpio_4b2->gpio_write(0<<GPIO4B2_1_OFFSET | 1<<GPIO4B2_2_OFFSET | 0<<GPIO4B2_3_OFFSET, 1<<GPIO4B2_3_OFFSET | 1<<GPIO4B2_2_OFFSET | 1<<GPIO4B2_1_OFFSET);
							EMBARC_PRINTF("2\n");
							break; 
						}
						case 3:
						{
							gpio_4b2->gpio_write(0<<GPIO4B2_1_OFFSET | 0<<GPIO4B2_2_OFFSET | 1<<GPIO4B2_3_OFFSET, 1<<GPIO4B2_3_OFFSET | 1<<GPIO4B2_2_OFFSET | 1<<GPIO4B2_1_OFFSET);
							EMBARC_PRINTF("3\n");
							break;
						}
						case 4:
						{
							gpio_4b2->gpio_write(1<<GPIO4B2_1_OFFSET | 1<<GPIO4B2_2_OFFSET | 0<<GPIO4B2_3_OFFSET, 1<<GPIO4B2_3_OFFSET | 1<<GPIO4B2_2_OFFSET | 1<<GPIO4B2_1_OFFSET);
							EMBARC_PRINTF("4\n");
							break; 
						}
						case 5:
						{
							gpio_4b2->gpio_write(0<<GPIO4B2_1_OFFSET | 1<<GPIO4B2_2_OFFSET | 1<<GPIO4B2_3_OFFSET, 1<<GPIO4B2_3_OFFSET | 1<<GPIO4B2_2_OFFSET | 1<<GPIO4B2_1_OFFSET);
							EMBARC_PRINTF("5\n");
							break; 
						}
						case 6:
						{
							gpio_4b2->gpio_write(1<<GPIO4B2_1_OFFSET | 0<<GPIO4B2_2_OFFSET | 1<<GPIO4B2_3_OFFSET, 1<<GPIO4B2_3_OFFSET | 1<<GPIO4B2_2_OFFSET | 1<<GPIO4B2_1_OFFSET);
							EMBARC_PRINTF("6\n");
							break; 
						}
						case 7:
						{
							gpio_4b2->gpio_write(1<<GPIO4B2_1_OFFSET | 1<<GPIO4B2_2_OFFSET | 1<<GPIO4B2_3_OFFSET, 1<<GPIO4B2_3_OFFSET | 1<<GPIO4B2_2_OFFSET | 1<<GPIO4B2_1_OFFSET);
							EMBARC_PRINTF("7\n");
							break; 
						}
						default:
						{
							gpio_4b2->gpio_write(0<<GPIO4B2_1_OFFSET | 0<<GPIO4B2_2_OFFSET | 0<<GPIO4B2_3_OFFSET, 1<<GPIO4B2_3_OFFSET | 1<<GPIO4B2_2_OFFSET | 1<<GPIO4B2_1_OFFSET);
							EMBARC_PRINTF("%d\n", state);
							EMBARC_PRINTF("d\n");
							break; 
						}
					}
                }
                //board_delay_ms(1000, 0);
            }
            else
            {
                state++;
                //board_delay_ms(1000, 0);
                gpio_4b2->gpio_read(&read_value, 1<<GPIO4B2_0_OFFSET);
                while(read_value == 1)
                {
                    gpio_4b2->gpio_read(&read_value, 1<<GPIO4B2_0_OFFSET);
                    switch(state)
					{
						case 0:
						{
							gpio_4b2->gpio_write(0<<GPIO4B2_1_OFFSET | 0<<GPIO4B2_2_OFFSET | 0<<GPIO4B2_3_OFFSET, 1<<GPIO4B2_3_OFFSET | 1<<GPIO4B2_2_OFFSET | 1<<GPIO4B2_1_OFFSET);
							EMBARC_PRINTF("0\n");
							break;    
						}
						case 1:
						{
							gpio_4b2->gpio_write(1<<GPIO4B2_1_OFFSET | 0<<GPIO4B2_2_OFFSET | 0<<GPIO4B2_3_OFFSET, 1<<GPIO4B2_3_OFFSET | 1<<GPIO4B2_2_OFFSET | 1<<GPIO4B2_1_OFFSET);
							EMBARC_PRINTF("1\n");
							break; 
						}
						case 2:
						{
							gpio_4b2->gpio_write(0<<GPIO4B2_1_OFFSET | 1<<GPIO4B2_2_OFFSET | 0<<GPIO4B2_3_OFFSET, 1<<GPIO4B2_3_OFFSET | 1<<GPIO4B2_2_OFFSET | 1<<GPIO4B2_1_OFFSET);
							EMBARC_PRINTF("2\n");
							break; 
						}
						case 3:
						{
							gpio_4b2->gpio_write(0<<GPIO4B2_1_OFFSET | 0<<GPIO4B2_2_OFFSET | 1<<GPIO4B2_3_OFFSET, 1<<GPIO4B2_3_OFFSET | 1<<GPIO4B2_2_OFFSET | 1<<GPIO4B2_1_OFFSET);
							EMBARC_PRINTF("3\n");
							break;
						}
						case 4:
						{
							gpio_4b2->gpio_write(1<<GPIO4B2_1_OFFSET | 1<<GPIO4B2_2_OFFSET | 0<<GPIO4B2_3_OFFSET, 1<<GPIO4B2_3_OFFSET | 1<<GPIO4B2_2_OFFSET | 1<<GPIO4B2_1_OFFSET);
							EMBARC_PRINTF("4\n");
							break; 
						}
						case 5:
						{
							gpio_4b2->gpio_write(0<<GPIO4B2_1_OFFSET | 1<<GPIO4B2_2_OFFSET | 1<<GPIO4B2_3_OFFSET, 1<<GPIO4B2_3_OFFSET | 1<<GPIO4B2_2_OFFSET | 1<<GPIO4B2_1_OFFSET);
							EMBARC_PRINTF("5\n");
							break; 
						}
						case 6:
						{
							gpio_4b2->gpio_write(1<<GPIO4B2_1_OFFSET | 0<<GPIO4B2_2_OFFSET | 1<<GPIO4B2_3_OFFSET, 1<<GPIO4B2_3_OFFSET | 1<<GPIO4B2_2_OFFSET | 1<<GPIO4B2_1_OFFSET);
							EMBARC_PRINTF("6\n");
							break; 
						}
						case 7:
						{
							gpio_4b2->gpio_write(1<<GPIO4B2_1_OFFSET | 1<<GPIO4B2_2_OFFSET | 1<<GPIO4B2_3_OFFSET, 1<<GPIO4B2_3_OFFSET | 1<<GPIO4B2_2_OFFSET | 1<<GPIO4B2_1_OFFSET);
							EMBARC_PRINTF("7\n");
							break; 
						}
						default:
						{
							gpio_4b2->gpio_write(0<<GPIO4B2_1_OFFSET | 0<<GPIO4B2_2_OFFSET | 0<<GPIO4B2_3_OFFSET, 1<<GPIO4B2_3_OFFSET | 1<<GPIO4B2_2_OFFSET | 1<<GPIO4B2_1_OFFSET);
							EMBARC_PRINTF("%d\n", state);
							EMBARC_PRINTF("d\n");
							break; 
						}
					}
                }
            }
            //EMBARC_PRINTF("00\n");
        }

        
        /* Need to right shift 1 bit to let 0 or 1 in the rightest bit
        if(read_value>>1 == 1)
        {
            gpio_4b2->gpio_write(1<<GPIO4B2_3_OFFSET, 1<<GPIO4B2_3_OFFSET);
            EMBARC_PRINTF("ON\n");
        }
        else
        {
            gpio_4b2->gpio_write(0<<GPIO4B2_3_OFFSET, 1<<GPIO4B2_3_OFFSET);
            // gpio4b_2->gpio_write(0, 1<<GPIO4B2_3_OFFSET);
            EMBARC_PRINTF("OFF\n");
        }*/
    }

    gpio_4b2->gpio_close();

    return E_SYS;
}