#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
int main() {
    uint32_t vector[6];

    for (uint32_t i = 0; i < 60000000; i++) {
        vector[(rand() % 6)] +=1;
       
    }
    for (int j = 0; j < 6; j++) {
        printf("%u \n", vector[j]);
       
    }
}
//Aca esta bueno como funciona el rand, no mucho mas