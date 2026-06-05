.586                ; Разрешаем инструкции для Pentium и выше (включая FPU)
.model flat, C      ; Плоская модель памяти, стиль именования C

; Сегмент данных
.data
    ; Локальные статические переменные, как в методичке
    sum     DD 0.0        ; Текущая сумма в двойном слове (float)
    h       DD 0.0        ; Шаг интегрирования h = 1/N
    x       DD 0.0        ; Текущее значение x
    two     DD 2.0        ; Константа 2.0

; Сегмент кода
.code
    ; Директива EXTERN для функции из модуля C.
    ; near - тип для 32-битных приложений.
    ; Имя fun_el, с учетом соглашения C (добавляется _)
    EXTERN fun_el:near

    ; Директива PUBLIC для нашей функции SumR
    PUBLIC SumR

; Процедура SumR
; Параметры (передаются через стек в cdecl):
; [EBP+8]  -> int N (количество разбиений)
; Возврат: float в ST(0) (регистр сопроцессора)
SumR PROC C
    ; Пролог
    push ebp
    mov  ebp, esp

    ; Инициализация
    mov ecx, [EBP+8]      ; ecx = N (количество разбиений)

    ; Проверка на N <= 0
    cmp  ecx, 0
    jle  end_func         ; Если N <= 0, выходим

    ; Вычисление шага h = 1.0 / N
    fld1                  ; ST(0) = 1.0
    mov  dword ptr [h], ecx ; Временное целое
    fild dword ptr [h]    ; ST(0) = N, ST(1) = 1.0
    fdivp ST(1), ST(0)    ; ST(0) = 1.0 / N = h
    fstp [h]              ; Сохраняем h, ST(0) очищен

    ; Инициализация суммы (sum = 0.5 * h * (f(0) + f(1))
    ; Но сначала посчитаем отдельно f(0) и f(1), чтобы добавить их к сумме,
    ; а значения f(x_i) для внутренних точек будем умножать на 2.

    ; Сумма = 0
    mov dword ptr [sum], 0
    ; x = 0
    mov dword ptr [x], 0

; ========== Вычисляем f(0) ==========
    push ecx              ; Сохраняем ecx (счетчик) перед вызовом Си-функции
    fld [x]               ; ST(0) = x = 0
    sub esp, 4            ; Резервируем место в стеке под параметр float
    fstp dword ptr [esp]  ; Передача x через стек
    call fun_el           ; Вызов f(x)
    add esp, 4            ; Очистка стека от параметра (cdecl)
    fadd [sum]            ; sum += f(0)
    fstp [sum]
    pop ecx               ; Восстанавливаем ecx

; ========== Вычисляем f(1.0) ==========
    push ecx
    fld1                  ; ST(0) = 1.0
    fstp [x]              ; x = 1.0
    fld [x]
    sub esp, 4
    fstp dword ptr [esp]
    call fun_el
    add esp, 4
    fadd [sum]            ; sum += f(1.0)
    fstp [sum]
    pop ecx

; ========== Цикл для суммы f(x_i) при i от 1 до N-1 ==========
    dec ecx               ; ecx = N-1 (количество внутренних итераций)
    cmp ecx, 0
    jle skip_loop         ; Если N-1 <= 0, пропускаем цикл (N=1)

    mov dword ptr [x], 0  ; Начинаем с x=0, первая внутренняя точка x+h

@@for_i:
    push ecx              ; Сохраняем счетчик цикла

    ; x = x + h
    fld [x]
    fadd [h]
    fstp [x]

    ; Получаем f(x)
    fld [x]
    sub esp, 4
    fstp dword ptr [esp]  ; Передаем x как аргумент
    call fun_el           ; f(x)
    add esp, 4

    ; Умножаем результат на 2 (кроме крайних точек по формуле трапеций)
    fmul [two]

    ; sum += 2 * f(x)
    fadd [sum]
    fstp [sum]

    pop ecx               ; Восстанавливаем счетчик цикла
    dec ecx               ; ecx--
    jnz @@for_i           ; Если ecx не ноль, продолжаем

skip_loop:
; ========== Завершаем вычисление ==========
; Теперь в sum у нас (f(0) + 2*f(h) + ... + 2*f(1-h) + f(1))
; Нужно умножить всю сумму на h / 2.0

    fld [sum]             ; ST(0) = sum
    fmul [h]              ; ST(0) = sum * h
    fdiv [two]            ; ST(0) = (sum * h) / 2.0

    jmp return_here

end_func:
    ; Если N <= 0, возвращаем 0.0
    fldz

return_here:
    ; Эпилог
    mov esp, ebp
    pop ebp
    ret
SumR ENDP

END
