

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
NODO_OFFSET_NEXT EQU 0
NODO_OFFSET_CATEGORIA EQU 8
NODO_OFFSET_ARREGLO EQU 16
NODO_OFFSET_LONGITUD EQU 24
NODO_SIZE EQU 32
PACKED_NODO_OFFSET_NEXT EQU 0
PACKED_NODO_OFFSET_CATEGORIA EQU 8
PACKED_NODO_OFFSET_ARREGLO EQU 9
PACKED_NODO_OFFSET_LONGITUD EQU 17
PACKED_NODO_SIZE EQU 21

LISTA_OFFSET_HEAD EQU 0
LISTA_SIZE EQU 8
PACKED_LISTA_OFFSET_HEAD EQU 0
PACKED_LISTA_SIZE EQU 8

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS
global cantidad_total_de_elementos
global cantidad_total_de_elementos_packed

;########### DEFINICION DE FUNCIONES
;extern uint32_t cantidad_total_de_elementos(lista_t* lista);
;registros: lista[?]

;Para la lista voy a tener 4 elementos
;puntero a struct que ocupa 8
;	 struct nodo_s* next;   //8 bytes
;    uint8_t categoria;     //1 byte
;    uint32_t* arreglo;     //8 bytes
;    uint32_t longitud;		//4 bytes
cantidad_total_de_elementos:
	; rdi lista_t*

	push RBP ;pila alineada
    mov RBP, RSP ;strack frame armado
	xor R8,R8
	mov rdi,[rdi+LISTA_OFFSET_HEAD]
	.ciclo:
		add R8, [rdi + NODO_OFFSET_LONGITUD]
		mov RDX, [RDI]
		CMP RDX,0
		JE .chau
		
		mov rdi,rdx
		jmp .ciclo
	.chau:

	mov rax,r8
	pop RBP
	ret

;extern uint32_t cantidad_total_de_elementos_packed(packed_lista_t* lista);
;registros: lista[?]
cantidad_total_de_elementos_packed:
	push RBP ;pila alineada
    mov RBP, RSP ;strack frame armado
	xor R8,R8
	mov rdi,[rdi+PACKED_LISTA_OFFSET_HEAD]
	.ciclo:
		add R8, [rdi + PACKED_NODO_OFFSET_LONGITUD]
		mov RDX, [RDI]
		CMP RDX,0
		JE .chau
		
		mov rdi,rdx
		jmp .ciclo
	.chau:

	mov rax,r8
	pop RBP
	ret

	ret

