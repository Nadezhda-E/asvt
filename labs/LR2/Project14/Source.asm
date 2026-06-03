

.686                    
.model flat, stdcall    
.stack 4096             

.data
    X dw 6DA9h          ; Исходное X
    Y dw 11FAh          ; Исходное Y
    L dw ?              ; Результат цикла
    M dw ?              
    R dw ?              ; Конечный результат


.code
ExitProcess PROTO STDCALL :DWORD
Start:
   
    mov ax, X           ; AX = X (6DA9)
    mov bx, Y           ; BX = Y (11FA)
    mov ecx, 4
    call cycle             ; Счетчик = 4
    

    
    mov L, ax           ; L = результат 
    
   
    mov ax, L           ; AX = L
    xor ax, Y           ; AX = L xor Y
    mov M, ax           ; M = результат (343B)
    
   
    cmp M, 0            ; Сравниваем M с 0
    jg R1             ; Если M > 0, идем в sub1
    jle R2            ; Если M <= 0, идем в sub2
    

R1:
    call SetR1
    jmp continue
R2:
    call SetR2


continue:
    cmp R, 0
    je A1           ; Если R = 0, идем в addr1
    jne A1           ; Если R ? 0, идем в addr2
    
A1:
    call addr1
    jmp finish
A2:
    call addr2
finish:
    Invoke ExitProcess, 0

 cycle:
    sub ax, bx          ; AX = AX - BX
    loop cycle          ; ECX--, если ECX>0 то cycle   
    ret

                     
SetR1 proc
    mov ax, M
    and ax, 0F0Fh
    mov R, ax  
    ret
SetR1 endp
    
    

SetR2 proc
    mov ax, M
    neg ax
    mov R, ax
    ret
SetR2 endp
   
    
    

    
addr1 proc
    
    mov ax, 27E1h
    xor ax, L
    mov R, ax
    ret
addr1 endp
    
addr2 proc
    mov ax, R          
    add ax, 67A1h      
    sub ax, L          
    mov R, ax   
    ret
addr2 endp
    

    
End Start