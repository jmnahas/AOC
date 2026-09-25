#include "../ejs.h"

// Función auxiliar para contar casos por nivel
int contar_casos_por_nivel(caso_t* arreglo_casos, int largo, int nivel) {
        int contador = 0;
        for (size_t i = 0; i < largo; i++)
        {
            
            usuario_t* usuario1 = arreglo_casos[i]->usuario;

            if (usuario1->nivel == nivel)
            {
                contador=contador +1;
            }
            
            
        }
        return contador;

}


segmentacion_t* segmentar_casos(caso_t* arreglo_casos, int largo) {
    int contador1=0;
    int contador2=0;
    int contador3=0;

    contador0=contar_casos_por_nivel(arreglo_casos,largo,0);
    contador1=contar_casos_por_nivel(arreglo_casos,largo,1);
    contador2=contar_casos_por_nivel(arreglo_casos,largo,2);
    segmentacion_t segmentacion = malloc()
}



