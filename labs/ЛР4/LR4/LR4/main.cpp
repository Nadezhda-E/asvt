#include <iostream>
#include <windows.h> 

using namespace std;

extern "C" float SumR(int steps);

int main(int argc, char** argv)
{
    SetConsoleOutputCP(65001);
    SetConsoleCP(65001);
    int n;
    float result;

    cout << "Вычисление интеграла функции f(x) = cbrt(tan(x)) на отрезке [0, 1]" << endl;
    cout << "Введите количество разбиений n (1..1000000): " << endl;
    cin >> n;

    if (n <= 0) {
        cout << "Ошибка: количество разбиений должно быть положительным числом." << endl;
        return 1;
    }

    // Вызов ассемблерной подпрограммы
    result = SumR(n);

    cout << "Значение интеграла: " << result << endl;

    return 0;
}
