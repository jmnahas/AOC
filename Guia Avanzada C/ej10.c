#include <stdio.h>
#include <stdint.h>
#include <string.h>


int main(){
    char str1[9] = "Hola";
    char str2[] = "Hola";
    char str3[9];
    if (strcmp(strcpy(str3,strcat(str1,str2)),"HolaHola")==0)
    {
        printf("%s\n", str3);
        printf("%u\n", strlen(str3));
    }

    return 0;
}

//Ahora si termine esto, aprendi que si tengo str cat y str len y str cpy y str cmp no hago nada, joda, quizas esta bueno el strcmp y el strcpy.
