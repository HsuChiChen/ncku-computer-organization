#include <stdio.h>
int call_add(int a, int b){
	return a + b;
}
int main(){
	int a = 1;
	int b = 2;
	int a_plus_b = call_add(a, b);
	return 0;
}