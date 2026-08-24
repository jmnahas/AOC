#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#define NAME_LEN 43

typedef struct{
    int edad;
    char nombre[NAME_LEN + 1];
} persona_t;

persona_t *crearPersona(int edad, char nombre[]){
    persona_t *people = malloc(sizeof(persona_t));
    if (people == NULL) {
        return NULL;
    }
    people->edad = edad;
    strcpy(people->nombre, nombre);
    return people;
}

void eliminarPersona(persona_t *persona){
    free(persona);
}
int main(){
    char nombre[NAME_LEN + 1];
    printf("Ingrese un nombre: ");
    scanf("%s", &nombre); 
    int n;
    printf("Ingrese una edad: ");
    scanf("%d", &n); 
    persona_t *persona=crearPersona(n,nombre);
    printf("%d\n", persona->edad);
    printf("%s\n", persona->nombre);
    eliminarPersona(persona);
    return 0;
}