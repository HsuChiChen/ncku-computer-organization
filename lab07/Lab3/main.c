#include "embARC.h"
#include "embARC_debug.h"
#include "iic1602lcd.h"

/* Define Max Number for 32-bit Integer */
#define MAX_COUNT 0xffffffff
#define GPIO8B2_0_OFFSET 0

/**
 * 宣告或定義你喜歡的埠(port)與腳位(pin)供超音波測距模組使用
 * e.g.:
 * #define UltraSonicPort DFSS_GPIO_8B2_ID
 * {
 */
#define UltraSonicPort DFSS_GPIO_8B2_ID

/**
 * }
 */

/**
 * 宣告 GPIO 物件
 * {
 */
DEV_GPIO_PTR gpio_8b2;
/**
 * }
 */

/**
 * 宣告用來判斷是否有被中斷的變數
 * {
 */
volatile bool ifit;
/**
 * }
 */

/* 宣告Timer0_ISR的原型 */
void Timer0_ISR();

/* Declare LCD Object to control LCD */
pLCD_t lcd_obj;

int main(void)
{
  /**
   * 初始化lcd_obj物件
   * {
   */
  lcd_obj = LCD_Init(DFSS_IIC_0_ID);
  /**
   * }
   */

  /**
	 * 獲得signal腳位的GPIO物件
	 * 將signal腳位設為輸出腳位
	 * {
   */
  gpio_8b2 = gpio_get_dev(UltraSonicPort);
  gpio_8b2->gpio_open(1<<GPIO8B2_0_OFFSET);
  /**
	 * }
	 */

    uint32_t signal_pin = 0;
	float temp;
	uint32_t T0_count = 0;

  while (1)
  {
    /**
		 * 將超音波signal腳位設為輸出
		 * {
		 */
    	gpio_8b2->gpio_control(GPIO_CMD_SET_BIT_DIR_OUTPUT, (void*)(1<<GPIO8B2_0_OFFSET));
    /**
		 * }
		 */

    /**
		 * 將TIMER_0停止
		 * 裝載(install) Timer0_ISR為TIMER0中斷的處理程序(handler)
		 * 開啟TIMER_0的interrupt
		 * 啟動TIMER_0，設定為啟動中斷(Interrupt Enabled)模式，並且在5us(5*10^-6s)時中斷
		 * {
		 */
		timer_stop(TIMER_0);
		int_handler_install(INTNO_TIMER0, Timer0_ISR);
		int_enable(INTNO_TIMER0);
		timer_start(TIMER_0, TIMER_CTRL_IE, 720);
    
    
    
    /**
		 * }
		 */

    /**
		 * 將超音波signal腳位設為高電位
		 * {
		 */
	gpio_8b2->gpio_write(1<<GPIO8B2_0_OFFSET, 1<<GPIO8B2_0_OFFSET);
    /**
		 * }
		 */

    /**
		 * 設定用來判斷是否有中斷的變數
		 * 等待該變數在中斷改變
		 * 將signal pin腳設定為低電位
		 * {
		*/
    	ifit = false;
		while(!ifit){
			//EMBARC_PRINTF("1");
		}
		gpio_8b2->gpio_write(0<<GPIO8B2_0_OFFSET, 1<<GPIO8B2_0_OFFSET);
    
    
    /**
		 * }
		 */

    /**
		 * 停止TIMER_0
		 * 將signal腳位設定為輸入腳位
		 * 宣告一個變數來儲存signal腳位的電位值
		 * 等待signal腳位變為高電位
		 * {
		 */
		timer_stop(TIMER_0);
		gpio_8b2->gpio_control(GPIO_CMD_SET_BIT_DIR_INPUT, (void*)(1<<GPIO8B2_0_OFFSET));
		gpio_8b2->gpio_read(&signal_pin, 1<<GPIO8B2_0_OFFSET);
		while(signal_pin == 0){
			gpio_8b2->gpio_read(&signal_pin, 1<<GPIO8B2_0_OFFSET);
			//EMBARC_PRINTF("%d", signal_pin);
		}

    /**
		 * }
		 */

    /**
		 * 利用timer_start開始計數，因為不需要interrupt所以可以將mode設為0或是TIMER_CTRL_NH，並且設定val為最大值
		 * 待signal腳位變為低電位
		 * {
		 */
		timer_start(TIMER_0, 0, MAX_COUNT);
		while(signal_pin == 1){
			gpio_8b2->gpio_read(&signal_pin, 1<<GPIO8B2_0_OFFSET);
			//EMBARC_PRINTF("3");
		}
    
    /**
		 * }
		 */

    /**
		 * 利用一個變數紀錄TIMER_0目前的計數，作為開始到結束經過的CPU cycle數
		 * 透過開始到結束經過的CPU Cycle數量除以CPU Cycle(CLK_CPU)得到秒數
		 * 再乘以 340(m/s)*100(cm/m)/2(來回) 得到公分數
		 * {
		 */
		timer_current(TIMER_0, &T0_count);
		temp = (float)T0_count / 144000000;
		temp = temp * 340 * 100 / 2;
		//EMBARC_PRINTF("%d.%d\n", (int)temp,(int)(temp * 100) % 100);
    
    
    /**
		 * }
		 */

    /**
		 * 判斷距離是否大於15公分
     * 如果大於15公分就將LCD背景設為綠色，反之LCD背景設為紅色
     * 清除上個迴圈LCD所顯示的距離
     * 將LCD游標設為0, 0
     * 將距離透過LCD印出，因為無法使用%f格式，所以要用%d.%d印出末兩位
		 * {
		 */
    if(temp > 15){
		lcd_obj->set_Color(GREEN);
	}
	else{
		lcd_obj->set_Color(RED);
	}
	lcd_obj->clear();
	lcd_obj->home();
    lcd_obj->printf("%d.%d", (int)temp,(int)(temp * 100) % 100);
    
    
    
    /**
		 * }
		 */

    /* 等待200毫秒，讓LCD能夠有時間顯示上一段距離 */
    board_delay_ms(200, 0);
  }

  return E_SYS;
}

void Timer0_ISR()
{
  /**
	 * 先將TIMER_0的 interrupt 清除
	 * 設定該設定的變數
	 * {
	 */
	timer_int_clear(TIMER_0);	
	ifit = true;
  /**
	 * }
	 */
}
