#include "embARC.h"
#include "embARC_debug.h"

/* ↓宣告控制器與暫存器位址 */
/* LCD Address */
#define LCD_ADDRESS (0x3E)
#define RGB_ADDRESS (0x62)
/* End LCD Address */

/* LED Driver Register Definition */
#define REG_RED 0x04   // pwm2
#define REG_GREEN 0x03 // pwm1
#define REG_BLUE 0x02  // pwm0

#define REG_MODE1 0x00
#define REG_MODE2 0x01
#define REG_OUTPUT 0x08
/* End RGB Backlight */

/* LCD Command Mask */
#define LCD_CLEARDISPLAY 0x01
#define LCD_RETURNHOME 0x02
#define LCD_ENTRYMODESET 0x04
#define LCD_DISPLAYCONTROL 0x08
#define LCD_CURSORSHIFT 0x10
#define LCD_FUNCTIONSET 0x20
#define LCD_SETCGRAMADDR 0x40
#define LCD_SETDDRAMADDR 0x80
/* End LCD Command Mask */

/* LCD Entry Mode Flag */
#define LCD_ENTRYLEFT 0x02
#define LCD_ENTRYRIGHT_ 0xFD
#define LCD_ENTRYINCREMENT 0x01
#define LCD_ENTRYDECREMENT_ 0xFE
/* End LCD Entry Mode Flag */

/* LCD Display Control Flag */
#define LCD_DISPLAYON 0x04
#define LCD_DISPLAYOFF_ 0xFB
#define LCD_CURSORON 0x02
#define LCD_CURSOROFF_ 0xFD
#define LCD_BLINKON 0x01
#define LCD_BLINKOFF_ 0xFE
/* End LCD Display Control Flag */

/* LCD Cursor Shift Flag */
#define LCD_DISPLAYMOVE 0x08
#define LCD_CURSORMOVE_ 0xF7
#define LCD_MOVERIGHT 0x04
#define LCD_MOVELEFT_ 0xFB
/* End LCD Cursor Shift Flag */

/* LCD Function Set Flag */
#define LCD_8BITMODE 0x10
#define LCD_4BITMODE_ 0xEF
#define LCD_2LINE 0x08
#define LCD_1LINE_ 0xF7
#define LCD_5x10DOTS 0x04
#define LCD_5x8DOTS_ 0xFB
/* End LCD Function Set Flag */
/* ↑宣告控制器與暫存器位址 */

/* 宣告功能性涵式以供初始化以及送出資料使用 */
void Lcd_Init_with_I2C_Dev(DEV_IIC_PTR iic);

/* 宣告一個 DEV_IIC_PTR 的變數來存放 I2C 物件的指標 */
DEV_IIC_PTR iic;

/* Forward Declare 等等要更改的 Lcd_Write 涵式 */
void Lcd_Write(const char Chr);

int main(void) {
  /**
   * 透過 iic_get_dev(uint32_t id) 傳入DFSS_IIC_x_ID 得到 DEV_IIC_PTR 的物件指標
   * 並且將他 assign 給 上面的 iic 變數
   * {
   */
  iic = iic_get_dev(DFSS_IIC_0_ID);
  /**
   * }
   */

  /**
   * 透過 DEV_IIC 裡面的 iic_open 將 iic 開啟成 DEV_MASTER_MODE
   * 同時給予 IIC_SPEED_STANDARD 的傳輸速度即可
   * {
   */
  iic->iic_open(DEV_MASTER_MODE, IIC_SPEED_STANDARD);
  /**
   * }
   */

  /* 為了讓同學能比較清楚看見出現的字，所以我利用 Lcd_Init_with_I2C_Dev 去初始化背光等等參數 */
  Lcd_Init_with_I2C_Dev(iic);

  Lcd_Write('H');
  Lcd_Write('e');
  Lcd_Write('l');
  Lcd_Write('l');
  Lcd_Write('o');
  Lcd_Write(',');
  Lcd_Write('W');
  Lcd_Write('o');
  Lcd_Write('r');
  Lcd_Write('l');
  Lcd_Write('d');
  Lcd_Write('!');

  while (1);

  return E_SYS;
}

void Lcd_Write(const char Chr) {
  /**
   * 先利用iic_control設定 IIC_CMD_MST_SET_TAR_ADDR
   * 將Master的目標位址設定成LCD的地址 - 0x3E
   * {
   */
  iic->iic_control(IIC_CMD_MST_SET_TAR_ADDR, 0x3E);
  /**
   * }
   */

  /**
   * 將0x40與傳進來的Chr變數準備好，變成一個array
   * 注意因為每次傳送都是一個byte，所以型別寫uint8_t/char都可以
   * {
   */
  char addr[2] = {0x40, Chr};
  /**
   * }
   */

  /**
   * 透過iic_write寫出去
   * {
   */
  iic->iic_write(addr, 2);
  /**
   * }
   */
}

void Lcd_Init_with_I2C_Dev(DEV_IIC_PTR iic)
{
  arc_delay_us(50000);

  uint8_t displayFunction_ = 0;
  displayFunction_ |= LCD_2LINE;

  displayFunction_ |= LCD_FUNCTIONSET;
  uint8_t data[2] = {LCD_SETDDRAMADDR, displayFunction_};
  iic->iic_control(IIC_CMD_MST_SET_TAR_ADDR, LCD_ADDRESS);
  iic->iic_write(data, 2);

  arc_delay_us(4500);
  uint8_t displayControl_ = LCD_DISPLAYON & LCD_CURSOROFF_ & LCD_BLINKOFF_;
  displayControl_ |= LCD_DISPLAYON | LCD_DISPLAYCONTROL;
  data[1] = displayControl_;
  iic->iic_write(data, 2);

  data[1] = LCD_CLEARDISPLAY;
  iic->iic_write(data, 2);
  arc_delay_us(2000);

  uint8_t displayMode_ = LCD_ENTRYLEFT | LCD_ENTRYMODESET & LCD_ENTRYDECREMENT_;
  data[1] = displayMode_;
  iic->iic_write(data, 2);

  uint8_t regData[2] = {0, 0};
  iic->iic_control(IIC_CMD_MST_SET_TAR_ADDR, RGB_ADDRESS);
  iic->iic_write(regData, 2);

  regData[0] = 0x08;
  regData[1] = 0xFF;
  iic->iic_write(regData, 2);

  regData[0] = 0x01;
  regData[1] = 0x20;
  iic->iic_write(regData, 2);

  regData[0] = 0x07;
  regData[1] = 0x00;
  iic->iic_write(regData, 2);

  regData[0] = 0x06;
  regData[1] = 0xff;
  iic->iic_write(regData, 2);

  regData[0] = 0x04;
  regData[1] = 0xff;
  iic->iic_write(regData, 2);

  regData[0] = 0x03;
  regData[1] = 0xff;
  iic->iic_write(regData, 2);

  regData[0] = 0x02;
  regData[1] = 0xff;
  iic->iic_write(regData, 2);
}