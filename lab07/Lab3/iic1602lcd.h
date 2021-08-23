#ifndef IIC1602LCD_H
#define IIC1602LCD_H

#include <stdint.h>

/* LCD Address */
#define LCD_ADDRESS (0x3E)
#define RGB_ADDRESS (0x62)
/* End LCD Address */

/* On/Off and Direction */
typedef enum
{
    OFF = 0,
    ON = 1,
} ON_OFF_t;

typedef enum
{
    LEFT = 0,
    RIGHT = 1,
} LEFT_RIGHT_t;
/* End On/Off and Direction */

/* RGB Backlight */
/* Color Definition */
typedef enum
{
    WHITE = 0,
    RED = 1,
    GREEN = 2,
    BLUE = 3,
} COLOR_t;

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

// void set_CursorPos(DEV_IIC_PTR iic_ptr, );/

typedef struct iic1602lcd_obj_s
{
    /* Setup Function */
    void (*set_CursorPos)(uint8_t col, uint8_t row);
    void (*print)(const char *str, uint8_t len);
    void (*printf)(const char *format, ...);
    void (*clear)(void);
    void (*home)(void);
    /* End Setup Function */

    /* Toggle Function */
    void (*set_Display)(ON_OFF_t Value);
    void (*set_Blink)(ON_OFF_t Value);
    void (*set_Cursor)(ON_OFF_t Value);
    void (*set_ScrollDir)(LEFT_RIGHT_t Value);
    void (*set_CharStarting)(LEFT_RIGHT_t Value);
    void (*set_AutoScroll)(ON_OFF_t Value);
    /* End Setup Function */

    /* RGB Function */
    void (*blink_LED)(ON_OFF_t Value);
    void (*set_Color)(COLOR_t Color);
    void (*set_RGBs)(uint8_t R, uint8_t G, uint8_t B);
    void (*set_RGB)(COLOR_t Color, uint8_t Value);
    /* End RGB Function */

    /* Utility Function */
    void (*write)(const char Chr);
    /* End Utility Function */
} LCD_t, *pLCD_t;

pLCD_t LCD_Init(int32_t iic_id);

#endif