#include <htc.h>

unsigned int reload;


unsigned char key0_flag = 0;
unsigned char key1_flag = 0;



void interrupt int0_isr(void)
{
  
        key0_flag = 1;
      
}



void interrupt int1_isr(void)
{
    
        key1_flag = 1;
    
}


void main()
{
    reload = 51786;

    P1 = 0xFE;
    P3 = 0xFF;
    
    RCAP2H = 0x29;
    RCAP2L = 0x28;
    T2CON = 0x04;
    TMOD = 0x01;
    
    IT0 = 1;   
    IT1 = 1;   
    EX0 = 1;   
    EX1 = 1;  
    EA  = 1;  
    
    while(1)
    {
       
       
        if(key0_flag == 1)
        {
            if(P32 == 0)  
            {
                if(reload > 35286)
                    reload -= 2750;
            }
            key0_flag = 0;
        }

       
        if(key1_flag == 1)
        {
            if(P33 == 0)
            {
                if(reload < 51786)
                    reload += 2750;
            }
            key1_flag = 0;
        }

      
        while(TF2 == 0);
        TF2 = 0;
        
        P10 = 1;

        TH0 = reload >> 8;
        TL0 = reload & 0xFF;

        TR0 = 1;
        TF0 = 0;

        while(TF0 == 0);

        TR0 = 0;
        TF0 = 0;

        P10 = 0;
    }
}