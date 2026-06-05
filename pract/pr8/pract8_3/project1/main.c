#include <8051.h>

unsigned char mode = 0;

void interrupt int0_isr(void)
{
    mode = !mode;
}

void main(void)
{
    unsigned char adc_value;
    
    IT0 = 1;   
    EX0 = 1;   
    EA  = 1;
    
    while(1)
    {
        
        while(P37 == 1);
        
        
        P36 = 1;
        P36 = 0;
        
       
        while(P37 == 1);
        
      
        adc_value = P1;
        
       
        P2 = adc_value;
        
       
        if(mode == 0)
        {
            P0 = 127;
        }
        else
        {
            P0 = 18;
        }
    }
}