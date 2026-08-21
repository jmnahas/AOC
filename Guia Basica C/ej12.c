#include <stdio.h>
int main() {
    int vector[] = {116, 104, 101, 32,45,3534,234};

    size_t length = sizeof(vector) / sizeof(int);

    int vector2[length];
    int indice = 4;
    for (int i = 0; i < length; i++) {
        vector2[i] = vector[(i + indice) % length];
    }
    for (int i = 0; i < length; i++) {
        printf("%u \n", vector2[i]);
    }
}
// Gran diea la del % nunca se me hubiera ocurrido gracias IA, soy un burro por no saberlo pero estructuralmente estaba perfecto, lloralo.