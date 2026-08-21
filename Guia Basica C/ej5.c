#include <stdio.h>
#include <stdint.h>

int main() {
    float c = 0.1;
    double c2 = 0.1;
    printf("float(%e): \n",c);
    printf("double(%f): \n",c2);

    int i1;
    int i2;

    i1 = (int) c;
    i2 = (int) c2;
    
    printf("Convertido 1:(%i) \n",i1);
    printf("Convertido 2:(%i) \n",i2);
    
    return 0;
}

//En este ej pude convertir float y doubles en Enteros, para eso hice un casteo, lo que sucdeio cuando converti es que se truncaron los enteros.
