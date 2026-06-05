#include <8051.h> 
void main() 
{ 
unsigned char i,j;  

unsigned char massiv [11]= 
{ 
0xC0, 
0xF9, 
0xA4, 
0xB0, 
0x99, 
0x92, 
0x82, 
0xF8, 
0x80, 
0x90, 
0xFF 
}; 

unsigned char out [8] = {5, 4, 6, 3, 7, 2, 8, 1};

P2=massiv [10];  

while(1)
{
if((P3 & 0x01)==0)
{
for(i=0;i<8;i++) 
{ 
P2=massiv[out[i]];
for(j=0;j<100;j++);

}


P2=massiv[10];
}
}
}