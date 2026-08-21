#include <stdio.h>
#define FELIZ 0
#define TRISTE 1
int estado = TRISTE; // static duration. File scope
void alcoholizar();
void print_estado();
int main(){
    print_estado();
    alcoholizar();
    print_estado();
    alcoholizar();alcoholizar();alcoholizar();
    print_estado(); // que imprime?
}
void alcoholizar(){
    static int cantidad = 0; // static duration. block scope
    cantidad++;
    if(cantidad < 3){
        estado = FELIZ;
    }else{
        estado = TRISTE;
    }
}
void print_estado(){
    printf("Estoy %s\n", estado == FELIZ ? "feliz" : "triste");
}

//Static lo que hace es que la variable no muera en la ejecuccion de la funcion, que siga viva incluso despues y qeu se libere igual que una variable global.
//Por eso este programa, imprime Triste, Feliz, Triste, porque lo alcoholizo 4 veces y la cantidad se sumo en todo.as