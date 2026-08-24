#include <stdio.h>
#include <stdint.h>

char cambio(char str[]){
    int i=0;
    while (str[i]!= '\0')
    {
        if (str[i]<90)
        {
            str[i]=str[i];
        } else{
            str[i]=str[i]+'A'-'a';
        }
        i++;
    }
    
}


int main(){
    char str[] = "Hola";
    cambio(str);
    printf("%s\n", str);
    return 0;
}

//PRIME saber que los str son punteros entonces no existe la duracion de scope con estos bichos, puedo modificarlo extrernamente como hice aca y sirve igual.