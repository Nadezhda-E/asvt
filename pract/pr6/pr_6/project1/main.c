#include <8051.h>

void tput(unsigned char p) 
{ 
	
	SBUF = p;
    while(!TI);
        
    TI = 0;  
	 
	         
           
} 

unsigned char rget(void) 
{ 
	
    while(!RI);
        
    RI = 0;  
	return SBUF; 
	         
           
} 

void main(void) 
{ 
    unsigned char i;
    unsigned char *ptr;
    unsigned char cur;
    
    PCON = 0x80;
    
    SCON = 0x88;
    
    
   
    ptr = (unsigned char *)0x40;
    
   
    for(i = 0; i < 15; i++) 
    { 	
		SCON = 0x90;
      	cur = rget();
		*ptr=cur;
		SCON = 0x88;
		tput(cur); 
		ptr++;          
    } 
    
    while(1) {}        
}