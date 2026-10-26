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
Limit:Especifica el tamaño del segmento, si la granularidad es 0 el segmento puede ir de 1 byte a 1 MByte si granularidad es 1 el tamaño puede ir de 4KB a 4GB.
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

```
print_text_rm  start_rm_msg,start_rm_len,0x0A,0,0
```


10. Busquen qué hace la instrucción LGDT en el Volumen 2 del manual de Intel. Expliquen con sus palabras para qué sirve esta instrucción. En el código, ¿qué estructura indica donde está almacenada la dirección desde la cual se carga la GDT y su tamaño? ¿dónde se inicializa en el código?
La estructura es la que hicimos en gdt.c si no tengo mal entendido, en la misma voy a tener los 4 descriptores de segmento, se iniciliza en GDT.C y lo traigo a kernel.asm


11. Completen el archivo `kernel.asm` en la sección de cargar la GDT usando lo averiguado en el punto 8 para cargar la GDT.


12. Lean la guía de Qemu+gdb. Inserten un breakpoint luego de cargar la GDT. Podemos ahora comprobar el arranque de la máquina hasta ese punto. Para compilar y correr el kernel, pueden usar el target de make `qemu`. Para debuguear con GDB, pueden usar el target `gdb`.

### Segunda parte: Pasaje a modo protegido

Para pasar a modo protegido tenemos que completar los siguientes pasos:

- Deshabilitar interrupciones || HECHO

- Completar la GDT en memoria || HECHO

- Cargar la dirección de la GDT en el registro del procesador GDTR || HECHO

- Habilitar el modo protegido en el procesador

- Hacer un jmp far al segmento de código de nivel 0

- Cargar los selectores de segmento restantes

Recomendamos que también miren como referencia, el manual *volumen 3, sección 9.9.1 "Switching to Protected Mode"*. Tengan en cuenta, que algunos de los pasos que están ahí descritos, corresponden a paginación, que no estaremos activando aún. Los pasos que nos interesan ahora son: 1,2,3,4,5 y 9

Ya hemos hecho los primeros, deshabilitar interrupciones y completar la GDT. También ya cargamos el registro GDTR correctamente. Ahora deberíamos, habilitar el modo protegido, hacer el *jmp far* y cargar los registros selectores de segmento.

13. Investiguen en el manual de Intel *sección 2.5 Control Registers*, el registro CR0. ¿Deberíamos modificarlo para pasar a modo protegido? Si queremos modificar CR0, no podemos hacerlo directamente. Sólo mediante un MOV desde/hacia los registros de control (pueden leerlo en el manual en la sección citada).
Si tenemos que modificarlo pero no se puede directamente, usamos un registro y le ponemos un or 1 y recien ahi clavamos el 1 en el cr0


14. A continuación, completen la sección del `kernel.asm` escribiendo un código que modifique CR0 para pasar a modo protegido. Tengan en cuenta las averiguaciones y comentarios del punto 13.
```
mov eax, cr0
or eax, 1        ; Activa el bit PE
mov cr0, eax
```

15. Notemos que a continuación debe hacerse un jump far para posicionarse en el código de modo protegido. Miren el volumen 2 de Intel para ver los distintos tipos de JMPs disponibles y piensen cuál sería el formato adecuado. ¿Qué usarían como selector de segmento?
```
jmp CS_RING_0_SEL:modo_protegido
```

16. Dentro del modo protegido, vamos a cargar los registros selectores de segmento (`DS`, `ES`, `GS`, `FS` y `SS`). Todos se van a iniciar en el segmento de datos de nivel 0. Para esto, completar el archivo `kernel.asm` dentro del código que se ejecuta ya en modo protegido (etiqueta `modo_protegido`)

```
mov ax, DS_RING_0_SEL
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
```


17. Setear la pila del kernel en la dirección `0x25000`. Configuren los registros que indican dónde está la base y el tope de la pila.

18. Impriman el mensaje de bienvenida a modo protegido e inserten breakpoint en la instrucción siguiente

## VAMOS A INICIAR EL KERNEL

Ya estamos listos para probar el arranque de la máquina. Para eso hay que compilar con `make` e iniciar `qemu`. Pueden hacer:

```
make gdb
```

para iniciar la sesión de qemu con el kernel y con gdb ya *attacheado.*

Otros targets del Makefile:

 - `make qemu`: se genera la imagen del kernel y se ejecuta qemu.

 - `make attach`: attachea gdb a una sesión de qemu existente.

 - `make gdb` hace estos dos últimos targets en secuencia

Ya dentro de gdb, no es necesario salir y volver a entrar, sino que podemos hacer (dentro de la terminal de gdb):

`kernel reload` 

Esto hará un rebuild del kernel y reiniciará la sesión de gdb (pero quedarán seteados todos los breakpoints que hayamos puesto en esta sesión).

19. Verifiquemos que la configuración haya quedado como esperamos:

- Con el comando `info registers` en `qemu` pueden:

- Ver `GDT= <BASE> <LIMITE>`. Verifiquen con `gdb` los valores de las entradas que cargaron.

- Ver los registros de control como el `CR0`

- Ver los registros de propósito general, `EFLAGS`, `EBP`, `ESP`, `RIP`, que también pueden ver con `gdb`.

- Ver los registros selectores de segmento.

20. Pueden ejecutar además `info gdt` dentro de gdb para verificar que la gdt se encuentra bien cargada.

## Tercera parte: Configurando la pantalla

Se va a acceder a la pantalla por un mapeo a memoria. La dirección física donde va a comenzar el buffer de la pantalla es `0x000B8000.`

La pantalla va a ser un arreglo de 50 filas x 80 columnas. En cada posición del arreglo va a haber 2 bytes que representan a una celda de la pantalla. Los colores y atributos se configuran acorde a una convención: [http://wiki.osdev.org/Text_UI](http://wiki.osdev.org/Text_UI)

21. Declaren un segmento adicional que describa el área de la pantalla en memoria que pueda ser utilizado sólo por el kernel. ¿Qué tamaño deberá tener considerando lo descrito en el párrafo anterior? Si el buffer de la pantalla comienza en `0x000B8000`[^3], piensen cuál debería ser la base y el límite. El tipo de este segmento debe ser de datos de lectura/escritura. Finalmente, definan el segmento en el archivo `gdt.c`.

22. Observen el método `screen_draw_box` en `screen.c` y la estructura `ca` en `screen.h` . ¿Qué creen que hace el método **screen_draw_box**? ¿Cómo hace para acceder a la pantalla? ¿Qué estructura usa para representar cada carácter de la pantalla y cuanto ocupa en memoria?

23. Escriban una rutina `screen_draw_layout` que se encargue de limpiar la pantalla y escribir el nombre de los integrantes del grupo (o lo que deseen) en la misma en el archivo `screen.c` y llamen a dicho método desde `kernel.asm`. Pueden usar diferentes fondos, colores e incorporar dibujos si así lo quisieran.

24. Resumen final, discutan con compañeros qué pasos tuvieron que hacer para activar el procesador en modo protegido. Repasen todo el código que estuvieron completando y traten de comprenderlo en detalle ¿Qué cosas les parecieron más interesantes? Seguro encontrarán partes que no comprenden del todo, no duden en consultar a los docentes.
