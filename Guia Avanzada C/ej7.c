#include <stdio.h>
#include <stdint.h>

void swap(int *a, int *b) {
    int tmp = *a;
    *a = *b;
    *b = tmp;
}
int main() {
    int x = 10, y = 20;
    swap(&x, &y);
    printf("x: %d, y: %d\n", x, y);
}

//Explicar que sucederıa si la firma de la funcion swap fuera void swap(int a, int b).
//En ese caso, ¿podrıamos intercambiar los valores de x e y?
//No podriamos cambiarlos porque lo que se devuielve es solo una cosa, entonces como la duracion de las variables es automatica, cuandoo salgas d ela funcion van a seguir valiendo lo mismo que valian antes de entrar.