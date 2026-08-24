#include <stdio.h>
int main(){
    int x = 42;
    int *p = &x;
    printf("Direccion de x: %p Valor: %d\n", (void*) &x, x);
    printf("Direccion de p: %p Valor: %p\n", (void*) &p, (void*) p);
    printf("Valor de lo que apunta p: %d\n", *p);
}

//¿Cual es la diferencia entre x y p? 
// x tiene una variable guardada, y p tambien nada mas que lo que tiene p es la direccion de memoria de x
//¿Y entre x y &x? 
// x tiene una variable y &x es la direccion de memoria de x
//¿Y entre p y *p?
//  p va a guardar la direccion de memoria mientras que *p va a mostrar a lo que apunta, osea el valor de x