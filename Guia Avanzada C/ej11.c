#include <stdio.h>
int main(){
    uint16_t *arr = secuencia(10);
    printf("%d\n", arr[0]);
    return 0;
}

// Osea esto no va a correr, porque no existe secuencia(10) en ningun lado, ni tampoco esta vinculado a mi stdio.h