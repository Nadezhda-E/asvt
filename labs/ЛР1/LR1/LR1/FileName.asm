.686
.model flat,stdcall
.stack 100h
.data
X dw 58
Y dw 23
Z dw 11
Y_r dw ?
M dw ?
.code
ExitProcess PROTO STDCALL :DWORD

Start:
; Вычисление Y_r
mov dx, Y        ; копирование Y в регистр dx
mov ax, dx       ; копирование dx в ax
and dx, 0F0h     ; выделение старших битов (маска 11110000)
and ax, 0Fh      ; выделение младших битов (маска 00001111)
shr dx, 4        ; сдвиг старших битов вправо на 4 разряда
shl ax, 4        ; сдвиг младших битов влево на 4 разряда
or dx, ax        ; объединение - получение Y'
mov Y_r, dx      ; сохранение Y' в переменную


; Вычисление X+Y+Z
mov ax, X        ; копирование X в регистр ax
add ax, Y        ; сложение X и Y
add ax, Z        ; сложение с Z - в ax сумма X+Y+Z
mov bx, ax       ; сохранение суммы в bx

; Вычисление (X+Y+Z) & X
mov ax, bx       ; восстановление суммы в ax
mov dx, X        ; копирование X в регистр dx
and ax, dx       ; логическое И суммы и X
mov cx, ax       ; сохранение результата в cx

; Вычисление (X+Y+Z) & Y'
mov ax, bx       ; восстановление суммы в ax
mov dx, Y_r  ; копирование Y' в регистр dx
and ax, dx       ; логическое И суммы и Y'

; Вычисление M
sub cx, ax       ; вычитание - результат в cx
mov M, cx        ; сохранение результата в M


exit:
Invoke ExitProcess,1
End Start
