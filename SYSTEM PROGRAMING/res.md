# System Programming: Pasaje a Modo Protegido
### Primera parte: Definiendo la GDT

Las preguntas que encuentren a lo largo de este trabajo son para guiarlos en el estudio y la resolución, alentamos a que se tomen en serio la tarea de responderlas ya que contienen conceptos clave necesarios para la comprensión del sistema en su conjunto. Tengan en cuenta que cualquiera de estas preguntas, y otras, pueden formar parte del quiz de entrega del TP.

1. Explorando el manual Intel *Volumen 3: System Programming. Sección 2.2 Modes of Operation*. ¿A qué nos referimos con modo real y con modo protegido en un procesador Intel? ¿Qué particularidades tiene cada modo?
Modo real labura por defecto en 16 bits, Podemos direccionar 1 MB de memoria, aunque los modos de direccionamiento son mas limitados que en modo protegido y no hay proteccion de memoria o niveles de privilegio.
Modo real tiene una forma en la que usamos 2 componentes distintas para llegar a un punto, osea direcciona la memoria con 2 componentes usa un selector de segmento y despues un offset.
El calculo es= Direccion Fisica = segmento * 16 + Offset
Ademas tiene interrupciones y todos los sets de instrucciones.


Modo protegido
En modo protegido hay 4 niveles distintos de proteccion y 4gb de memoria disponible. Ademas hay rutinas de atencion con privilegios y el set de instrucciones depende de el nivel de privilegio.

2. Comenten en su equipo, ¿Por qué debemos hacer el pasaje de modo real a modo protegido? ¿No podríamos simplemente tener un sistema operativo en modo real? ¿Qué desventajas tendría?
El modo real da muchas libertades al usuario, ademas de que por ejemplo podriamos direccionar y utilizar menor cantidad de memoria, el pasaje a modo protegido es importante para ademas poder configurar ciertas cosas del SO.

Anteriormente, detallamos que la memoria es un arreglo continuo de bytes y que podemos segmentarla de acuerdo a tamaño, nivel de protección y uso. Debemos indicar al procesador la descripción de los segmentos, es decir, cómo están conformados los segmentos. Los ejercicios a continuación tienen que ver con el armado de la tabla de segmentos.

3. Busquen el manual *volumen 3 de Intel en la sección 3.4.5 Segment Descriptors*. ¿Qué es la GDT? ¿Cómo es el formato de un descriptor de segmento, bit a bit? Expliquen brevemente para qué sirven los campos *Limit*, *Base*, *G*, *P*, *DPL*, *S*. También pueden referirse a los slides de la clase teórica, aunque recomendamos que se acostumbren a consultar el manual.
La GDT es la G
The global descriptor table o GDT, es un lugar de donde se selecciona la memoria, principalmente un selector de segmento que nos dice ciertas caracteristicas del cacho de memoria que estoy yendo a buscar,El mismo tiene un apartado de base,otro de segmento y luego distintos flags que nos dicen a que estoy apuntando.
Limit:Especifica el tamaño del segmento, si la granularidad es 0 el segmento puede ir de 1 byte a 1 MByte si granularidad es 0 el tamaño puede ir de 4KB a 4GB.
Base:Esto nos da la direccion lineal del segmento, nos dice donde esta ubicado, esta dividido en 3 partes distintas.
G:Esto es la granularidad, nos dice como esta segmentado el segmento valga la redundancia, si de a 1 byte o de a 4KB
P:Esto quiere decir si el segmento esta en memoria o no
DPL:Es el nivel de privilegio que tiene va de 0 a 3, osea tiene 4 niveles.
S:Esto especifica si es un segmento de sistema(0) o de codigo o datos(1)
    
4. La tabla de la sección 3.4.5.1 *Code- and Data-Segment Descriptor Types* del volumen 3 del manual del Intel nos permite completar el *Type*, los bits 11, 10, 9, 8. ¿Qué combinación de bits tendríamos que usar si queremos especificar un segmento para ejecución y lectura de código?
1010

![](img/resolucion-dir-logica.png)

Hay dos tipos de tablas que describen segmentos a nivel global y local (GDT y LDT). La tabla LDT no se utiliza en el modelo de segmentación *flat* que estaremos aplicando. Para este taller sólo vamos a usar la Tabla de Descriptores Global (GDT). En esta tabla se definen los descriptores de segmento que le dan estructura a la memoria en el nivel de segmentación.

5. Inicialmente, vamos a definir los siguientes segmentos en la GDT:

    a.  Un segmento para código de nivel 0 ejecución/lectura

    b.  Un segmento para código de nivel 3 ejecución/lectura

    c.  Un segmento para datos de nivel 0 lectura/escritura

    d.  Un segmento para datos de nivel 3 lectura/escritura

    ![alt text](image.png)
    Los 4 segmentos


Cada uno de estos segmentos deben direccionar los primeros 817 MiB[^1] de memoria y por estar usando segmentación *flat*, van a estar solapados. Escriban cómo quedarían los campos de cada descriptor de cada uno de los segmentos solicitados. Especifiquen el G, límite, la base, el tipo, P, DPL, S, P, AVL, L, D/B. Pueden completar con valores hexadecimales en la siguiente planilla: [*GDT Entradas*](https://docs.google.com/spreadsheets/d/1GczRjxYYt4jLSlZ5vJ7clHDZutnW1JJfl9pdL1wZI6w/edit?usp=sharing) (hacer una copia local para que no sea solo lectura).

Recuerden que el límite es el último valor accesible dentro del segmento (es inclusivo) y que el límite está relacionado con el nivel de granularidad **G** que hayan seleccionado.

> Noten que si bien definimos distintos niveles de privilegio, todos usan la misma región de memoria física, por lo cual, no hay una división real de permisos de accesos propuesto a nivel segmentación. Vamos a resolverlo en las próximas clases, cuando agreguemos paginación al kernel.
  
Ahora, trabajemos con el código provisto por la cátedra. Vamos a completar la tabla de segmentos y cargar los descriptores de segmento. Hemos provisto estructuras en C que permiten simplificar la especificación de los campos de cada descriptor.

6. En el archivo `gdt.h` observen las estructuras: `struct gdt_descriptor_t` y el `struct gdt_entry_t`. ¿Qué creen que contiene la variable `extern gdt_entry_t gdt;` y `extern gdt_descriptor_t GDT_DESC;`?
En el mismo archivo lo dice son Declaracion variables de la Tabla GDT, en el caso de gdt, son los descriptores de segmento, y el GDT_DESC es a donde se tiene que apuntar para que vay a la primer entrada




7. Buscar en el Volumen 3 del manual de Intel, sección 3.4.2 *Segment Selectors* el formato de los selectores de segmento. Observar en el archivo `defines.h` las constantes con los valores de distintos selectores de segmento posibles. Completen los defines faltantes en `defines.h` y entiendan la utilidad de las macros allí definidas. 
   **USAR LAS MACROS** para definir los campos de los entries de la gdt. En lo posible, no hardcodeen los números directamente en los campos.

```
#define GDT_CODE_0_SEL  ((GDT_IDX_CODE_0 << 3) | 0)  
#define GDT_DATA_0_SEL  ((GDT_IDX_DATA_0 << 3) | 0)  
#define GDT_CODE_3_SEL  ((GDT_IDX_CODE_3 << 3) | 0)  
#define GDT_DATA_3_SEL  ((GDT_IDX_DATA_3 << 3) | 0)  

#define DESC_CODE_DATA 1
#define DESC_SYSTEM    0
#define DESC_TYPE_EXECUTE_READ (((DESC_CODE_DATA<<2)|1)<<1)
#define DESC_TYPE_READ_WRITE   ((DESC_CODE_DATA<<2)>>1)


#define FLAT_SEGM_SIZE   (817 * 1024 * 1024)
```

8. En el archivo `gdt.c`, completen en el código la Tabla de Descriptores Globales (GDT) con los 4 segmentos definidos en el punto 5. (**usen los defines del punto anterior siempre que sea posible**)

```
    [GDT_IDX_CODE_0] =
        {
            .limit_15_0  = 0b0011000011111111, // 16 bits: 0x30FF
            .base_15_0   = 0b0000000000000000, // 16 bits: 0x0000
            .base_23_16  = 0b00000000,         //  8 bits: 0x00
            .type        = 0b1010,             //  4 bits: Código Execute/Read
            .s           = 0b1,                //  1 bit : Descriptor de código/datos
            .dpl         = 0b00,               //  2 bits: Nivel de privilegio 0
            .p           = 0b1,                //  1 bit : Presente en RAM
            .limit_19_16 = 0b0011,             //  4 bits: 0x3
            .avl         = 0b0,                //  1 bit : Disponible (no usado)
            .l           = 0b0,                //  1 bit : Modo 32 bits (no 64)
            .db          = 0b1,                //  1 bit : Tamaño por defecto de 32 bits
            .g           = 0b1,                //  1 bit : Granularidad de 4 KiB
            .base_31_24  = 0b00000000,
        },
    [GDT_IDX_CODE_3] =
        {
            .limit_15_0  = 0b0011000011111111, // 16 bits: 0x30FF
            .base_15_0   = 0b0000000000000000, // 16 bits: 0x0000
            .base_23_16  = 0b00000000,         //  8 bits: 0x00
            .type        = 0b1010,             //  4 bits: Código Execute/Read
            .s           = 0b1,                //  1 bit : Descriptor de código/datos
            .dpl         = 0b11,               //  2 bits: Nivel de privilegio 3
            .p           = 0b1,                //  1 bit : Presente en RAM
            .limit_19_16 = 0b0011,             //  4 bits: 0x3
            .avl         = 0b0,                //  1 bit : Disponible (no usado)
            .l           = 0b0,                //  1 bit : Modo 32 bits (no 64)
            .db          = 0b1,                //  1 bit : Tamaño por defecto de 32 bits
            .g           = 0b1,                //  1 bit : Granularidad de 4 KiB
            .base_31_24  = 0b00000000,
        },
    [GDT_IDX_DATA_0] =
        {
            .limit_15_0  = 0b0011000011111111, // 16 bits: 0x30FF
            .base_15_0   = 0b0000000000000000, // 16 bits: 0x0000
            .base_23_16  = 0b00000000,         //  8 bits: 0x00
            .type        = 0b0010,             //  4 bits: Código read/write
            .s           = 0b1,                //  1 bit : Descriptor de código/datos
            .dpl         = 0b00,               //  2 bits: Nivel de privilegio 0
            .p           = 0b1,                //  1 bit : Presente en RAM
            .limit_19_16 = 0b0011,             //  4 bits: 0x3
            .avl         = 0b0,                //  1 bit : Disponible (no usado)
            .l           = 0b0,                //  1 bit : Modo 32 bits (no 64)
            .db          = 0b1,                //  1 bit : Tamaño por defecto de 32 bits
            .g           = 0b1,                //  1 bit : Granularidad de 4 KiB
            .base_31_24  = 0b00000000,
        },
    [GDT_IDX_DATA_3] =
        {
            .limit_15_0  = 0b0011000011111111, // 16 bits: 0x30FF
            .base_15_0   = 0b0000000000000000, // 16 bits: 0x0000
            .base_23_16  = 0b00000000,         //  8 bits: 0x00
            .type        = 0b0010,             //  4 bits: CCódigo read/write
            .s           = 0b1,                //  1 bit : Descriptor de código/datos
            .dpl         = 0b11,               //  2 bits: Nivel de privilegio 3
            .p           = 0b1,                //  1 bit : Presente en RAM
            .limit_19_16 = 0b0011,             //  4 bits: 0x3
            .avl         = 0b0,                //  1 bit : Disponible (no usado)
            .l           = 0b0,                //  1 bit : Modo 32 bits (no 64)
            .db          = 0b1,                //  1 bit : Tamaño por defecto de 32 bits
            .g           = 0b1,                //  1 bit : Granularidad de 4 KiB
            .base_31_24  = 0b00000000,
        },
```

9. Ya está todo listo para cargar la GDT. Antes de eso, completen todo lo necesario en `kernel.asm` hasta "Habilitar A20" inclusive[^2]. Tengan en cuenta que las macros de impresión se encuentran definidas en `print.mac` y que para los colores hay constantes definidas en `colors.h`. Las macros reciben sus argumentos separados por comas, sin paréntesis ni nada. Por ejemplo:

    ```print_text_rm arg1, arg2, arg3, arg4, arg5.```

    *Hint*: investiguen para qué puede servir la instrucción **cli** en el manual 2.

10. Busquen qué hace la instrucción LGDT en el Volumen 2 del manual de Intel. Expliquen con sus palabras para qué sirve esta instrucción. En el código, ¿qué estructura indica donde está almacenada la dirección desde la cual se carga la GDT y su tamaño? ¿dónde se inicializa en el código?

11. Completen el archivo `kernel.asm` en la sección de cargar la GDT usando lo averiguado en el punto 8 para cargar la GDT.

12. Lean la guía de Qemu+gdb. Inserten un breakpoint luego de cargar la GDT. Podemos ahora comprobar el arranque de la máquina hasta ese punto. Para compilar y correr el kernel, pueden usar el target de make `qemu`. Para debuguear con GDB, pueden usar el target `gdb`.