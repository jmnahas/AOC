/* ** por compatibilidad se omiten tildes **
================================================================================
 TALLER System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================

  Rutinas del controlador de interrupciones.
*/
#include "pic.h"

#define PIC1_PORT 0x20
#define PIC2_PORT 0xA0

static __inline __attribute__((always_inline)) void outb(uint32_t port,
                                                         uint8_t data) {
  __asm __volatile("outb %0,%w1" : : "a"(data), "d"(port));
}
void pic_finish1(void) { outb(PIC1_PORT, 0x20); }
void pic_finish2(void) {
  outb(PIC1_PORT, 0x20);
  outb(PIC2_PORT, 0x20);
}

// COMPLETAR: implementar pic_reset()
void pic_reset() {
  outb(0x20, 0x11);
  // ICW2: Vector base para PIC1 (32 = 0x20)
  outb(0x21, 0x20);
  // ICW3: PIC1 Master tiene un esclavo conectado en IRQ2 (bit 2 = 0x04)
  outb(0x21, 0x04);
  // ICW4: Modo x86 (0x01)
  outb(0x21, 0x01);
  // OCW1: Enmascarar todas las interrupciones inicialmente
  outb(0x21, 0xFF);

  // === Inicialización PIC2 (Slave) ===
  // ICW1: Inicialización, modo cascada, espera ICW4
  outb(0xA0, 0x11);
  // ICW2: Vector base para PIC2 (40 = 0x28)
  outb(0xA1, 0x28);
  // ICW3: PIC2 Slave conectado a IRQ2 del Master (ID = 0x02)
  outb(0xA1, 0x02);
  // ICW4: Modo x86 (0x01)
  outb(0xA1, 0x01);
  // OCW1: Enmascarar todas las interrupciones inicialmente
  outb(0xA1, 0xFF);

}

void pic_enable() {
  outb(PIC1_PORT + 1, 0x00);
  outb(PIC2_PORT + 1, 0x00);
}

void pic_disable() {
  outb(PIC1_PORT + 1, 0xFF);
  outb(PIC2_PORT + 1, 0xFF);
}
