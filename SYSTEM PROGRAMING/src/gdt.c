/* ** por compatibilidad se omiten tildes **
==============================================================================
TALLER System Programming - Arquitectura y Organizacion de Computadoras - FCEN
==============================================================================

  Definicion de la tabla de descriptores globales
*/

#include "gdt.h"

/* Aca se inicializa un arreglo de forma estatica
GDT_COUNT es la cantidad de líneas de la GDT y esta definido en defines.h */

gdt_entry_t gdt[GDT_COUNT] = {
    /* Descriptor nulo*/
    /* Offset = 0x00 */
    [GDT_IDX_NULL_DESC] =
        {
            // El descriptor nulo es el primero que debemos definir siempre
            // Cada campo del struct se matchea con el formato que figura en el manual de intel
            // Es una entrada en la GDT.
            .limit_15_0 = 0x0000,
            .base_15_0 = 0x0000,
            .base_23_16 = 0x00,
            .type = 0x0,
            .s = 0x00,
            .dpl = 0x00,
            .p = 0x00,
            .limit_19_16 = 0x00,
            .avl = 0x0,
            .l = 0x0,
            .db = 0x0,
            .g = 0x00,
            .base_31_24 = 0x00,
        },
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

    /* Completar la GDT: 
      Es conveniente completar antes las constantes definidas en defines.h y valerse
      de las mismas para definir los descriptores acá. Traten en lo posible de usar las 
      macros allí definidas.
      Tomen el descriptor nulo como ejemplo y definan el resto.
     */
    
};

// Aca hay una inicializacion estatica de una structura que tiene su primer componente el tamano 
// y en la segunda, la direccion de memoria de la GDT. Observen la notacion que usa. 
gdt_descriptor_t GDT_DESC = {sizeof(gdt) - 1, (uint32_t)&gdt};
