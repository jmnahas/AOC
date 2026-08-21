#include <stdio.h>
int main() {
    int mensaje_secreto[] = {116, 104, 101, 32, 103, 105, 102, 116, 32, 111,
    102, 32, 119, 111, 114, 100, 115, 32, 105, 115, 32, 116, 104, 101, 32,
    103, 105, 102, 116, 32, 111, 102, 32, 100, 101, 99, 101, 112, 116, 105,
    111, 110, 32, 97, 110, 100, 32, 105, 108, 108, 117, 115, 105, 111, 110};

    size_t length = sizeof(mensaje_secreto) / sizeof(int);

    char decoded[length];

    for (int i = 0; i < length; i++) {

        decoded[i] = (char) (mensaje_secreto[i]); // casting de int a char
    }
    for (int i = 0; i < length; i++) {

        printf("%c", decoded[i]);
    }
}

//¿Que mensaje se imprime? 
//the gift of words is the gift of deception and illusion
//¿Porque les parece que length se calcula de esa manera? 
//Se hace asi porque divide el tamaño del vector completo en cuantos ints hay en total, entonces de ahi sabe cuanta cantidad de enteros exsisten en mi mensaje secreto.
//¿Que pasarıa si el mensaje secretotuviera un tamaño distinto?
//Probablemente no compilaria ya que el for o nunca terminaria porque hay un index fuera de largo.
//¿Por que se usa size t para calcular el tamaño del mensaje secreto?
//Porque es mas practico que crear una funcion completa en donde se haga exactamente esto que pide, aparte de que C debe controlar muy bien la memoria entonces crear algo como un vector no ocupa espacio de memoria de mas como si otros lenguajes.
