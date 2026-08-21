#include <stdio.h>
#include <stdint.h>

int main() {
    int a = 5;
    int b = 3;
    int c = 2;
    int d = 1;

    // a en binario = 101
    // b en binario = 011
    printf("1)(%u): \n",a + b * c / d);
    printf("2)(%u): \n",a % b);
    printf("3)(%x): \n",a == b);
    printf("4)(%x): \n",a != b);
    printf("5)(%x): \n",a & b); // Quedaria el 001 = 1
    printf("6)(%x): \n",a | b); // Quedaria el 111 = 7
    printf("7)(%x): \n",~a);
    printf("8)(%x): \n",a && b);
    printf("9)(%x): \n",a || b);
    printf("10)(%x): \n",a << 1); // Quedaria el 1011 (El 11 pero en hexa se representa como a)
    printf("11)(%x): \n",a >> 1); // Quedaria el 010
    printf("12)(%u): \n",a += b);
    printf("13)(%u): \n",a -= b);
    printf("14)(%u): \n",a *= b);
    printf("15)(%u): \n",a /= b);
    printf("16)(%u): \n",a %= b);
    

    //Aca aprendi principalmente lo del shifteo, correr 1 a un numero entero y trasnformarlo a otro
    //Tambien esta bueno lo de las mascaras de lo & o |
    return 0;
}