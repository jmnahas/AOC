#include <stdio.h>
int main() {
    char c = 100;
    short s = -8712;
    int i = 123456;
    long l = 1234567890;

    printf("char(%lu): %d \n", sizeof(c),c);
    printf("short(%lu): %d \n", sizeof(s),s);
    printf("int(%lu): %d \n", sizeof(i),i);
    printf("long(%lu): %ld \n", sizeof(l),l);

    unsigned char uc = 252;
    unsigned short us = 65531;
    unsigned int ui = 429496721;
    unsigned long ul = 123456789000;

    printf("uchar(%lu): %d \n", sizeof(uc),uc);
    printf("ushort(%lu): %d \n", sizeof(us),us);
    printf("uint(%lu): %d \n", sizeof(ui),ui);
    printf("ulong(%lu): %ld \n", sizeof(ul),ul);

    return 0;
}

//Basicamente los unsigned son sin negativos, osea por ejemplo en un char puedo de -128 a 127 y en el unsigned char tengo hasta 255
//Asi con todos los unsigned