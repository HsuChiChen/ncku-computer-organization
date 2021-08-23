
int sum(int,int,int);
int main()
{   
    int a=44,b=87,c=2; 
    volatile int* n = (int*) 0x00000800;   
    //int *n;      
    *n=sum(a,b,c);
    //printf("%d",*n);
    return 0;
}    
    
int sum(int a,int b,int c)
{
    int n;
    n=a+b+c;
    return n;  
}
