extern strcpy
extern malloc
extern free

section .rodata
; Acá se pueden poner todas las máscaras y datos que necesiten para el ejercicio

section .text
; Marca un ejercicio como aún no completado (esto hace que no corran sus tests)
FALSE EQU 0
; Marca un ejercicio como hecho
TRUE  EQU 1

ITEM_OFFSET_NOMBRE EQU 0
ITEM_OFFSET_ID EQU 12
ITEM_OFFSET_CANTIDAD EQU 16

POINTER_SIZE EQU 8
UINT32_SIZE EQU 4

; Marcar el ejercicio como hecho (`true`) o pendiente (`false`).

global EJERCICIO_1_HECHO
EJERCICIO_1_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

global EJERCICIO_2_HECHO
EJERCICIO_2_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

global EJERCICIO_3_HECHO
EJERCICIO_3_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

global EJERCICIO_4_HECHO
EJERCICIO_4_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

;SUM1 -> Rdi
;SUM2 -> RSI
;SUM3 -> RDX
;SUM4 -> RCX
;SUM5 -> R8	
global ejercicio1
ejercicio1:
	push RBP ;pila alineada
    mov RBP, RSP ;strack frame armado
	
	add Rdi, RSI
	add Rdi, Rdx
    add Rdi, RCX
    add Rdi, r8
	mov Rax, Rdi
	
	POP RBP
	ret

global ejercicio2

;void ejercicio2(item_t* un_item, uint32_t id, uint32_t cantidad, char nombre[]);
;item_t* un_item -> RDI
;uint32_t id -> RSI
;uint32_t cantidad -> RDX
;char nombre[] -> RCX
ejercicio2:
	push RBP
	mov rbp,rsp
	sub rsp, 8                  

    mov [rdi + ITEM_OFFSET_ID], esi
    mov [rdi + ITEM_OFFSET_CANTIDAD], edx


    mov rsi, rcx
    call strcpy

    add rsp, 8
    pop rbp
	ret


global ejercicio3
; uint32_t ejercicio3(uint32_t* array, uint32_t size, uint32_t (*fun_ej_3)(uint32_t a, uint32_t b));
; tengo qeu devolver un entero, entonces en rax voy a tener que tener un entero
; uint32_t* array -> rdi
; uint32_t size -> rsi
; uint32_t (*fun_ej_3)(uint32_t a, uint32_t b)) -> rdx
ejercicio3:
	push rbp
	mov rbp,rsp
	push r12
	
	cmp rsi, 0 ;Esto esta bien se fija si rsi(size) es 0 si lo es hay que dar 64
	je .vacio
	
	mov r12,rsi
	mov rcx, rdi ; array
	mov r8, 0 ; sumatoria
	mov r9, 0 ; i

	.loop:
		mov rdi, r8 
		mov rsi, [rcx + r9*4]

		call rdx

		add r8, rax
		mov rax, r8

		inc r9
		cmp r9, r12
		je .end

		jmp .loop

	.vacio:
		mov rax, 64

	.end:
		pop r12
		pop rbp
		ret

;ACA LO HICE BIEN Y SOLO SIN IA NI MIERDAS, pisaba el registro rsi antes de cargarse a la funcion fun
;entonces perdia el size y nunca sabia cuando paraba.

global ejercicio4
; uint32_t* ejercicio4(uint32_t** array, uint32_t size, uint32_t constante);
; Tengo qeu devolver en rax un puntero a un array que sea el primer array multiplicado por la cosntante
; uint32_t** array -> rdi
; uint32_t size -> rsi
; uint32_t constante ->rdx
ejercicio4:
	push rbp
	mov rbp,rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	sub rsp,8
	

	mov r12, rdi ; guardo las cosas por las dudas
	mov r13, rsi
	mov r14, rdx

	xor rdi, rdi
	mov eax, UINT32_SIZE ; en rax guardo el valor de un entero
	mul esi ; lo multiplico por el tamaño del array
	mov edi, eax 

	call malloc ;llamo malloc porlas
	mov r15, rax ; guardo la direccion de memoria en la que tengo mi nuevo array
	
	xor rcx, rcx
	.loop:
	
	cmp rcx, r13
	je .end

	mov rbx, POINTER_SIZE
	imul rbx,rcx
	mov r8, [r12+rbx]
	mov qword [r12+rbx],0 
	mov r9d, [r8]
	mov rax, r14
	imul eax,r9d
	mov rbx, UINT32_SIZE
	imul rbx,rcx
	mov [r15+rbx], eax
	mov rdi, r8 

	sub rsp,8
	push rcx
	call free
	pop rcx
	add rsp,8

	inc rcx
	jmp .loop

	.end:

	mov rax, r15
	
	add rsp,8
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret
