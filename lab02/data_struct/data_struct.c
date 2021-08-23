#include <stdio.h>

struct student{
    int mathGrade;
    int csGrade;
    int englishGrade;
};

int main()
{
	volatile struct student* A =(struct student*) 0x00000800;
	volatile struct student* B =(struct student*) 0x00000820;
	struct student s1 = {60,70,70};  
	struct student s2 = {70,50,80};  

	*A = s1;
	*B = s2;  
	return 0;
}