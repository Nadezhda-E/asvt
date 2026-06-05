#include <8051.h>

void main()
{
    unsigned int i, shift, idx;
    //unsigned char *str1 = "Hello World!"; , 0xA4, 0xA0
	unsigned char str1[]={0xA6, 0xAD, 0xB7, 0xAF, 0xA2, 0xA0};
    unsigned char *str2 = "LCD20x2";       

   
    P0 = 0x38;
    P2 = 0x1;
    P2 = 0x0;

    P0 = 0x80;
    P2 = 0x1;
    P2 = 0x0;

    while(1)
    {
        
	/*	for(i=0xA6; i<0x192; i++)
{
			P0 = 0x80;
            P2 = 0x1;
            P2 = 0x0;

			P0 = i;
            P2 = 0x3;
            P2 = 0x2;
}
*/





       for(shift = 0; shift <= 20; shift++)
        {
            P0 = 0x80;
            P2 = 0x1;
            P2 = 0x0;

            for(i = 0; i < 20; i++)
            {
                
                idx = (i + shift) % 20;

                if(idx < 6)
                {
                    
                    P0 = str1[idx];
                }
                else
                {
                    
                    P0 = ' ';
                }
                P2 = 0x3;
                P2 = 0x2;
            }
        }

       
        P0 = 0xC0;
        P2 = 0x1;
        P2 = 0x0;

        for(i = 0; i < 7; i++)
        {
            P0 = str2[i];
            P2 = 0x3;
            P2 = 0x2;

            P0 = ' ';
            P2 = 0x3;
            P2 = 0x2;
        }

        for(i = 0; i < 6; i++)
        {
            P0 = ' ';
            P2 = 0x3;
            P2 = 0x2;
        }   

    } 
}

