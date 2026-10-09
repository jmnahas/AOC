; Hace que los accesos a memoria por defecto se compilen como [rip + offset]
; en lugar de [offset_desde_el_0x0].
;
; Ver https://www.nasm.us/doc/nasmdoc7.html#section-7.2.1 para más información
DEFAULT REL

TRUE  EQU 1
FALSE EQU 0

SINCOS_SIN_OFF EQU 0
SINCOS_COS_OFF EQU 4
SINCOS_SZ      EQU 8

section .rodata

global ej_1_hecho
global ej_2_hecho
global ej_3_hecho
global ej_4_hecho
ej_1_hecho: db TRUE
ej_2_hecho: db FALSE
ej_3_hecho: db FALSE
ej_4_hecho: db TRUE

ALIGN 16
espacios:
	times 10 db ' ' - '0'
	times 6  db 0x0
ceros:
	times 10 db '0'
	times 6  db 0x0
; ... y otra data que les resulte útil para resolver los ejercicios

section .text

global ej1_sample
; void ej1_sample(size_t buf_len, int16_t buf[buf_len],
;                 size_t freq_a_len, int16_t freq_a[freq_a_len], size_t a_start,
;                 size_t freq_b_len, int16_t freq_b[freq_b_len], size_t b_start);
;
; buf_len:    Está en ??
; buf:        Está en ??
; freq_a_len: Está en ??
; freq_a:     Está en ??
; a_start:    Está en ??
; freq_b_len: Está en ??
; freq_b:     Está en ??
; b_start:    Está en ??
;
; Tener en mente que:
; - buf_len, freq_a_len, freq_b_len, a_start y b_start son siempre múltiplos de 16
; - a_start < freq_a_len y b_start < freq_b_len
; - freq_a y freq_b están dados tal que sumarlos entre sí no causa overflow
ej1_sample:
    ;prologo
    push rbp                    
    mov rbp, rsp                

    mov r11, [rbp + 24]         
    mov rax, 0                ; contador

    .ciclo:
        cmp rax, rdi ;si llego al final finalizo
        jge .epilogo

        mov r10, [rbp + 16];r10 tiene a freqb

        movdqu xmm0, [rcx + r8 * 2];xmm0 tiene 8 frequencias
        movdqu xmm1, [r10 + r11 * 2];xmm1 tiene otrs 8

        paddw xmm0, xmm1;sumo
        psraw xmm0, 1;shifteo 1 que es lo mismoq ue dividir por 2

        movdqu [rsi + rax * 2], xmm0;guardo en el destino

        ;avanzo en las 3 cosas, las fecuencias la posicion y mi contador
        add rax, 4
        add r8,  4                  
        add r11, 4

        mov r10, r8
        sub r10, rdx
        cmp r8, rdx
        cmovge r8, r10;se fija si se tiene que seguir moviendo en freqa 

        mov r10, r11
        sub r10, r9                 
        cmp r11, r9
        cmovge r11, r10;se fija si se tiene que seguir moviendo en freqb             

        jmp .ciclo                  

    .epilogo:
        pop rbp                     
        ret
global ej2_detect
; float ej2_detect(size_t size, int16_t signal[size], sincos_t freq[size]);
;
; size:   Está en ??
; signal: Está en ??
; freq:   Está en ??
ej2_detect:
	xorps xmm0, xmm0
	ret

global ej3_remove_duplicates
; void ej3_remove_duplicates(size_t size, char detected[size], char output[]);
;
; size:   Está en ??
; signal: Está en ??
; output: Está en ??
ej3_remove_duplicates:
	ret

global ej4_get_numbers
; void ej4_get_numbers(size_t size, char numbers[10 * (size - 1) + 16], size_t output[size]);
;
; size:   Está en ??
; signal: Está en ??
; output: Está en ??
ej4_get_numbers:
	;prologo
    push rbp
    mov rbp, rsp
    mov r8,0

    .loop_numeros:
        cmp r8, rdi
        jge .epilogo

        xor rcx, rcx                ; rcx = acumulador del valor numérico (size_t)
        xor r9, r9                  ; r9 = offset dentro del número de 10 bytes (0, 4, 8)

    .loop_chunk:
        ; Cargar 4 bytes (4 caracteres ASCII) desde 'numbers' a EAX
        mov eax, [rsi + r9]

        ; --- Procesar Byte 0 (AL) ---
        movzx r10, al
        sub r10, '0'
        mov r11, rcx
        imul r11, r11, 10
        add r11, r10
        cmp r10, 9
        cmovbe rcx, r11

        ; --- Procesar Byte 1 (Mover Byte 1 a AL mediante shift) ---
        shr eax, 8
        movzx r10, al
        sub r10, '0'
        mov r11, rcx
        imul r11, r11, 10
        add r11, r10
        cmp r10, 9
        cmovbe rcx, r11

        ; --- Procesar Byte 2 (Mover Byte 2 a AL mediante shift) ---
        shr eax, 8
        movzx r10, al
        sub r10, '0'
        mov r11, rcx
        imul r11, r11, 10
        add r11, r10
        cmp r10, 9
        cmovbe rcx, r11

        ; JUMP 2: Si r9 es 8, procesamos solo los primeros 2 bytes del chunk (posiciones 8 y 9)
        cmp r9, 8
        jge .fin_numero

        ; --- Procesar Byte 3 (Mover Byte 3 a AL mediante shift) ---
        shr eax, 8
        movzx r10, al
        sub r10, '0'
        mov r11, rcx
        imul r11, r11, 10
        add r11, r10
        cmp r10, 9
        cmovbe rcx, r11

        ; Avanzar offset r9 en 4 bytes (0 -> 4 -> 8)
        add r9, 4
        cmp r9, 10
        ; JUMP 3: Repetir sub-bucle si restan bytes por procesar
        jl .loop_chunk

    .fin_numero:
        ; Almacenar el número procesado de 64 bits en output[i]
        mov [rdx + r8 * 8], rcx

        ; Avanzar al siguiente bloque de 10 bytes en 'numbers'
        add rsi, 10
        inc r8                      ; i++

        ; JUMP 4: Salto al bucle de números
        jmp .loop_numeros

    .epilogo:
        add rsp, 16                 ; Deshacer espacio local
        pop rbp                     ; Restaurar RBP[cite: 1]
        ret