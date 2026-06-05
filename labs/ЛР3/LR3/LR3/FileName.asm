.686
.model flat, stdcall
.stack 100h

ExitProcess PROTO STDCALL :DWORD

.data
A       DD   -1.0    ;левая граница интервала
B       DD   10.0    ;правая граница интервала
N       DD   100.0  ;количество точек

step    DD  ?       ;шаг
x       DD  ?       ;текущее значение
result  DD  100 DUP(?)  ;массив

zero    DD  0.0     ;константы
minus1  DD -1.0
six     DD  6.0
two     DD  2.0

.code
Start:

    ; step = (B - A) / N
    fld dword ptr B         ;загрузить В в стек
    fsub dword ptr A        ;ST(0) = B - A
    fdiv dword ptr N        ;делим на N
    fstp dword ptr step     ;сохранить результат и удалить из стека

    ; x = A
    fld dword ptr A
    fstp dword ptr x

    mov ecx, 100        ;счетчик цикла
    lea edi, result     ;указатель на массив

calc_loop:

    ; --- если x > 0 ---
    fld dword ptr zero
    fld dword ptr x
    
    fcomip st(0), st(1)
    fstp st(0)

    ja case_x_pos

    ; --- если x >= -1 ---
    fld dword ptr minus1
    fld dword ptr x
    
    fcomip st(0), st(1)
    fstp st(0)

    jae case_x_mid

    jmp case_x_neg

; x > 0 ? x^2
case_x_pos:
    fld dword ptr x
    fmul st(0), st(0)
    jmp save_result

; -1 ? x ? 0 ? x
case_x_mid:
    fld dword ptr x
    jmp save_result

; x < -1 ? 2 * sqrt(|x - 6|)
case_x_neg:
    fld dword ptr x
    fsub dword ptr six   ; x - 6

    ; модуль
    fabs                 ; |x - 6|

    fsqrt                ; sqrt(|x - 6|)
    fmul dword ptr two   ; *2
    jmp save_result

save_result:
    fstp dword ptr [edi]

    ; x = x + step
    fld dword ptr x
    fadd dword ptr step
    fstp dword ptr x

    add edi, 4
    loop calc_loop

exit:
    Invoke ExitProcess, 0

End Start
