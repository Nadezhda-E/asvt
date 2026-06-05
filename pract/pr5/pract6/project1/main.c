#include <8051.h>

void delay(int x) {
	
	unsigned int j;
	for (j=0; j< x; j++);
   
{
	TH0 = 0xD8;
	TL0 = 0xF0;
	TR0=1;
	
	while(TF0==0);
	TF0=0;
	TR0=0;
}

}

void main(void) {
	
    unsigned char row, col, key;
	unsigned char count;
    unsigned char keys[4][4] = {
        {'/','=','0','C'},
        {'*','3','2','1'},
        {'-','6','5','4'},
        {'+','9','8','7'}
    };

    
    P0 = 0x38;          
    P2 = 0x01; 
    P2 = 0x00;
    
    P0 = 0x80;
    P2 = 0x01; 
    P2 = 0x00;

    while(1) {
		TMOD=0x1;

		
        key = 0xFF; 
        row = 0xFF;
        col = 0xFF;
		P1 = 0x0F;

        
       
            if((P1 & 0x0F) != 0x0F) { 
				count = 0;
				while(count < 5) {
        			P1 = 0x0F;
					
        			if((P1 & 0x0F) != 0x0F) {
						count++;
						delay(1);        
        			} else {
            			count = 0;      
        			}
    			}
                	if((P1 & 0x01) == 0) col = 0;
                	if((P1 & 0x02) == 0) col = 1;
                	if((P1 & 0x04) == 0) col = 2;
                	if((P1 & 0x08) == 0) col = 3;
                	P1 = 0xF0;
	
					if((P1 & 0x10) == 0) row = 0;
            		if((P1 & 0x20) == 0) row = 1;
            		if((P1 & 0x40) == 0) row = 2;
            		if((P1 & 0x80) == 0) row = 3;
	
	
                	if(row != 0xFF && col != 0xFF) {
	
                	key = keys[row][col];
	
                	P0 = key;
                	P2 = 0x03;
                	P2 = 0x02;
					
					delay(5);
            
}
                

                
            }    
    }
}