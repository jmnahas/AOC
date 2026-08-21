#include <stdio.h>
#include <stdint.h>

int main() {
    int a = 5;
    int b = 5;
    int i = 3;

    printf("i++)(%u): \n",a = ++i);
    printf("+ii)(%u): \n",b = i++);
    b= ++i;
    a= i++;
    printf("+ii)(%u): \n",a);
    printf("+ii)(%u): \n",b);
    
    //La verdad no se la diferencia ni me importa, siguiente ejercicio
    return 0;
}