#include <stdio.h>
#define FELIZ 0
#define TRISTE 1

void ser_feliz(int estado);
void print_estado(int estado);

int main(){
    int estado = TRISTE; // automatic duration. Block scope
    ser_feliz(estado);
    print_estado(estado); // que imprime?
}

void ser_feliz(int estado){
    estado = FELIZ;
}

void print_estado(int estado){
    printf("Estoy %s\n", estado == FELIZ ? "feliz" : "triste");
}

//¿Que imprime el programa anterior?
// Previo a verlo digo triste

//Efectivamente era triste, como estado no es variable global o como ser_feliz no tiene un return concreto y se hace algo con eso.
//Estado termina teniendo una duracion fija.