#include <8051.h>  
void msec (int x)  
{ 
while(x-->0)
{ 
TH0 = (-10000)>>8;

TL0=-10000; 

TR0=1;  
do; 
while(TF0==0);  
TF0=0;  
TR0=0;  
} 
} 
void main()  
{ 
int i; 
unsigned char array[5]; 
TMOD=0x1; 
array[0]=0x0;
array[1] = 0x18; 

array[2]=0x24; 
array[3] = 0x42; 
array[4]=0x81; 

P1=array[0]; 
msec(2); 
P1 = array[1];
msec(100);

P1 = array[2];
msec(200);

P1 = array[3];
msec(300);

P1 = array[4];
msec(800);
P1=array[0];
while(1); 
} 