#include <stdio.h>
#include <stdint.h>

int main() {
    uint8_t a= 165;
    uint8_t b = 5;

    if ((a >> 5) == ((b<<5)>>5) )
    {
         printf("Si se pudo burro \n");
    }

    return 0;
}

//Gran ejercicio, siento que puedo wacho atr. Aprendi que hay que shiftear para comparar por ejemplo, asi borro mierda de atras y de adelante.