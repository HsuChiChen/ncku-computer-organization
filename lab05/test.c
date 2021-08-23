// test.c

#include "stdlib.h"

void inline_asm();

int main(){

    inline_asm();
    return 0;
}


void inline_asm(){
    __asm__ __volatile__("li a0, 2048");
    __asm__ __volatile__("li t1, 6;");
    __asm__ __volatile__("sw t1, 0(a0);");
    __asm__ __volatile__("li t1, 6;");
    __asm__ __volatile__("sw t1, 4(a0);");
    __asm__ __volatile__("li t1, 7;");
    __asm__ __volatile__("sw t1, 8(a0);");
    __asm__ __volatile__("li t1, 8;");
    __asm__ __volatile__("sw t1, 12(a0);");
    __asm__ __volatile__("li t1, 9;");
    __asm__ __volatile__("sw t1, 16(a0);");
    __asm__ __volatile__("li t1, 10;");
    __asm__ __volatile__("sw t1, 20(a0);");
    __asm__ __volatile__("li t1, 11;");
    __asm__ __volatile__("sw t1, 24(a0);");
    __asm__ __volatile__("li t1, 12;");
    __asm__ __volatile__("sw t1, 28(a0);");
    __asm__ __volatile__("li t1, 15;");
    __asm__ __volatile__("sw t1, 32(a0);");
    __asm__ __volatile__("custom1 a0;");

    __asm__ __volatile__("li t2, 1;");
    __asm__ __volatile__("li t2, 2;");
    __asm__ __volatile__("li t2, 3;");
    __asm__ __volatile__("li t2, 4;");
    __asm__ __volatile__("li t2, 5;");
    __asm__ __volatile__("li t2, 6;");
    __asm__ __volatile__("li t2, 7;");
    __asm__ __volatile__("li t2, 8;");
    __asm__ __volatile__("li t2, 9;");
    __asm__ __volatile__("li t2, 10;");
    __asm__ __volatile__("custom2 a0;");

}
