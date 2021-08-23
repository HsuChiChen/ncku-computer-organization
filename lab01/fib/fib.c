#include<stdio.h>

int main(){

  int a = 0;
  int b = 1;
  int c = 0;
  volatile int* base = (int*) 0x20000000;

  for(int i = 2; i < 10; i++){
    c = a + b;
    base[0] = c;
    a = b;
    b = c;
  }
  return 0;
}
