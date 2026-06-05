#include <8051.h> 

void main() 
{
	
	int i;
	char xdata *ptr;
	char test, nabor;
	
	nabor = 0x33; 
	
	ptr = (char xdata *) 0x0C00; 
	for(i=0; i<1024;i++) 
	{
		*ptr=nabor; 
		test=*ptr;
		if(ptr == (char xdata *) 0x0C02) 
		{
			test=*((char xdata *) 0xC02) = 0x22; 
		}
		if(test!=nabor)
		{
			P1=0x00;
			while(1); 
		}
	ptr++;
}
P1=0x01;
while(1);
}