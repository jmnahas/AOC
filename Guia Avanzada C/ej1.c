#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

typedef struct {
        char* nombre;
        int vida;
        double ataque;
        double defensa;
    } monstruo_t;

monstruo_t evolution(monstruo_t mostro){
    mostro.ataque += 10;
    mostro.defensa += 10;
    return mostro;
} ;



int main(){
    

    monstruo_t mostros[3] = {
        [0] = {"Pikachu", 55,100,300},
        [1] = {"Charmander", 70,120,100},
        [2].nombre = "Squirtle", [2].vida = 60,[2].ataque = 100,[2].defensa = 200,
    };

    for (size_t i = 0; i < 3; i++)
    {
        printf("Nombre: %s\n", mostros[i].nombre);
        printf("Vida: %u\n", mostros[i].vida);
        printf("Ataque: %f\n", mostros[i].ataque);
        printf("Defensa: %f\n", mostros[i].defensa);
        
        printf("Ataque Evolucionada: %f\n", evolution(mostros[i]).ataque);
        printf("Defensa Evolucionada: %f\n", evolution(mostros[i]).defensa);
    }

    
}

//Ejercicio 1 y 2, me sirvieron para comprender como funcionan los structs y distintas maneras de llamarlos.