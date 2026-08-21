#include <stdio.h>
#include <stdint.h>
int main() {
    int8_t c = 100;
    int16_t s = -8712;
    int32_t i = 123456;
    int64_t l = 1234567890;

    printf("int8_t(%lu): %d \n", sizeof(c),c);
    printf("int16_t(%lu): %d \n", sizeof(s),s);
    printf("int32_t(%lu): %d \n", sizeof(i),i);
    printf("int64_t(%lu): %ld \n", sizeof(l),l);


    uint8_t uc = 252;
    uint16_t us = 65531;
    uint32_t ui = 429496721;
    uint64_t ul = 123456789000;

    printf("uint8_t(%lu): %d \n", sizeof(uc),uc);
    printf("uint16_t(%lu): %d \n", sizeof(us),us);
    printf("uint32_t(%lu): %d \n", sizeof(ui),ui);
    printf("uint64_t(%lu): %ld \n", sizeof(ul),ul);

    return 0;
}