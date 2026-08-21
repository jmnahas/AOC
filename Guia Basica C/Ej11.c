#include <stdio.h>
int main() {
    int vector[] = {116, 104, 101, 32,45,3534,234};

    size_t length = sizeof(vector) / sizeof(int);

    int vector2[length];

    for (int i = 0; i < length; i++) {
        if ((i+1)==length)
        {
            vector2[i] = vector[0];
        }else{
            vector2[i] = vector[i+1];
        }
    }
    for (int i = 0; i < length; i++) {
        printf("%u \n", vector2[i]);
    }
}