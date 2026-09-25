; Definiciones comunes
TRUE  EQU 1
FALSE EQU 0

; Identificador del jugador rojo
JUGADOR_ROJO EQU 1
; Identificador del jugador azul
JUGADOR_AZUL EQU 2

; Ancho y alto del tablero de juego
tablero.ANCHO EQU 10
tablero.ALTO  EQU 5

; Marca un OFFSET o SIZE como no completado
; Esto no lo chequea el ABI enforcer, sirve para saber a simple vista qué cosas
; quedaron sin completar :)
NO_COMPLETADO EQU -1

extern strcmp

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
carta.en_juego EQU 0
carta.nombre   EQU 1
carta.vida     EQU 14
carta.jugador  EQU 16
carta.SIZE     EQU 18

;typedef struct carta {
;	bool en_juego; 1 byte
;	char nombre[12]; 12 byte
;	uint16_t vida; 2 byte
;	uint8_t jugador; 1 byte
;} carta_t;


tablero.mano_jugador_rojo EQU 0
tablero.mano_jugador_azul EQU 8
tablero.campo             EQU 16
tablero.SIZE              EQU 24

accion.invocar   EQU 0
accion.destino   EQU 8
accion.siguiente EQU 16
accion.SIZE      EQU 24

; Variables globales de sólo lectura
section .rodata

; Marca el ejercicio 1 como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - hay_accion_que_toque
global EJERCICIO_1_HECHO
EJERCICIO_1_HECHO: db TRUE

; Marca el ejercicio 2 como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - invocar_acciones
global EJERCICIO_2_HECHO
EJERCICIO_2_HECHO: db FALSE

; Marca el ejercicio 3 como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - contar_cartas
global EJERCICIO_3_HECHO
EJERCICIO_3_HECHO: db TRUE

section .text

; Dada una secuencia de acciones determinar si hay alguna cuya carta tenga un
; nombre idéntico (mismos contenidos, no mismo puntero) al pasado por
; parámetro.
;
; El resultado es un valor booleano, la representación de los booleanos de C es
; la siguiente:
;   - El valor `0` es `false`
;   - Cualquier otro valor es `true`
;
; ```c
; bool hay_accion_que_toque(accion_t* accion, char* nombre);
; ```
global hay_accion_que_toque
hay_accion_que_toque:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; r/m64 = accion_t*  accion ->RDI
	; r/m64 = char*      nombre -> RSI
	push rbp
	mov rbp,rsp
	push r12 ; iterador
	push r13 ; carta

	mov r12,rdi
	.ciclo:
		cmp r12,0
		je .finmalo

		mov r13,  [r12+accion.destino] ; en r13 tengo la carta destino
		
		push rdi
		push rsi

		lea rdi, [r13+carta.nombre]
		call strcmp
		pop rsi
		pop rdi
		cmp rax,0
		je .finbueno

		mov r12,[r12+accion.siguiente ]
		jmp .ciclo

		.finbueno:
			mov rax,1
			jmp .fin
	.finmalo:
	xor eax,eax
	.fin:

	pop r13
	pop r12
	pop rbp
	ret

; Invoca las acciones que fueron encoladas en la secuencia proporcionada en el
; primer parámetro.
;
; A la hora de procesar una acción esta sólo se invoca si la carta destino
; sigue en juego.
;
; Luego de invocar una acción, si la carta destino tiene cero puntos de vida,
; se debe marcar ésta como fuera de juego.
;
; Las funciones que implementan acciones de juego tienen la siguiente firma:
; ```c
; void mi_accion(tablero_t* tablero, carta_t* carta);
; ```
; - El tablero a utilizar es el pasado como parámetro
; - La carta a utilizar es la carta destino de la acción (`accion->destino`)
;
; Las acciones se deben invocar en el orden natural de la secuencia (primero la
; primera acción, segundo la segunda acción, etc). Las acciones asumen este
; orden de ejecución.
;
; ```c
; void invocar_acciones(accion_t* accion, tablero_t* tablero);
; ```
global invocar_acciones
invocar_acciones:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; r/m64 = accion_t*  accion
	; r/m64 = tablero_t* tablero
	ret

; Cuenta la cantidad de cartas rojas y azules en el tablero.
;
; Dado un tablero revisa el campo de juego y cuenta la cantidad de cartas
; correspondientes al jugador rojo y al jugador azul. Este conteo incluye tanto
; a las cartas en juego cómo a las fuera de juego (siempre que estén visibles
; en el campo).
;
; Se debe considerar el caso de que el campo contenga cartas que no pertenecen
; a ninguno de los dos jugadores.
;
; Las posiciones libres del campo tienen punteros nulos en lugar de apuntar a
; una carta.
;
; El resultado debe ser escrito en las posiciones de memoria proporcionadas
; como parámetro.
;
; ```c
; void contar_cartas(tablero_t* tablero, uint32_t* cant_rojas, uint32_t* cant_azules);
; ```
global contar_cartas
contar_cartas:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; r/m64 = tablero_t* tablero - > RDI
	; r/m64 = uint32_t*  cant_rojas -> RSI
	; r/m64 = uint32_t*  cant_azules -RDX
	push rbp
	mov rbp,rsp
	push r12 ; i
	push r13 ; j
	push r14 ; carta
	push r15 ;
	push rbx
	mov dword [rsi], 0
	mov dword [rdx], 0
	xor r12,r12

	.cicloi:
		;for (size_t i = 0; i < 10; i++)
		cmp r12,tablero.ANCHO
		je .fin
		xor r13,r13
		.cicloj:
			;for (size_t j = 0; j < 5; j++)
			cmp r13,tablero.ALTO
			je .fin2
			mov r15,r12
			imul rbx,r13,tablero.ANCHO
			add r15,rbx

			mov r14,[RDI+ tablero.campo +r15*8]
			cmp r14,0
			;carta_t* carta = tablero->campo[j][i];
			je .siguiente
			;if (carta != NULL) {
			
	
			;Caso cuando es jugador 1
			cmp byte [r14+carta.jugador],1
			je .rojas
			

			;Caso cuando es jugador 2
			cmp byte [r14+carta.jugador],2
			je .azul

			jmp .siguiente

				.rojas:
					inc dword [rsi]
					jmp .siguiente
				.azul:
					inc dword [rdx]
					jmp .siguiente

			.siguiente:
				inc r13
				jmp .cicloj
		.fin2:
		inc r12
		jmp .cicloi
	.fin:

	pop rbx
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
	ret
