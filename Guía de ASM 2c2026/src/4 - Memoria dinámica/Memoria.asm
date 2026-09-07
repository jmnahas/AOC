extern malloc
extern free
extern fprintf

section .data

section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen

; ** String **

; int32_t strCmp(char* a, char* b)
; a -> [RDI]
; b -> [RSI]
strCmp:
    push rbp
    mov rbp, rsp

	.loop:
	    mov al, byte [rdi]        ; AL = a[i]
	    mov dl, byte [rsi]        ; DL = b[i]
	
	    cmp al, dl
	    jne .diferentes           ; Si no son iguales, determinamos quién es mayor
	
	    ; Si son iguales, chequeamos si llegamos al final ('\0')
	    cmp al, 0
	    je .son_iguales
	
	    ; Avanzamos al siguiente byte
	    inc rdi
	    inc rsi
	    jmp .loop
	
	.diferentes:
	    ; Usamos jl / jg sin signo (ja / jb) porque los chars en strcmp son unsigned
	    ja .a_es_mayor            ; Si a[i] > b[i]
	    mov rax, 1               ; Si a[i] < b[i] -> devuelve -1
	    jmp .fin
	
	.a_es_mayor:
	    mov rax, -1                ; Devuelve 1
	    jmp .fin
	
	.son_iguales:
	    mov rax, 0                ; Devuelve 0
	
	.fin:
    	pop rbp
    	ret

; char* strClone(char* a)
strClone:
	push rbp
	mov rbp,rsp
	push r12
	push r13
	
	mov r12,rdi

	push rdi
	call strLen;en rax tengo la longitud de rdi
	pop rdi

	push rdi
	lea rdi, [rax + 1]
	call malloc ; aca tengo el puntero a donde tengo guardado la direcciond ememoria al lugar nuevo
	pop rdi

	mov r13,rax

	.ciclo:
		mov dl, byte [r12]    ; Usamos DL (no AL) para no tocar RAX
    	mov byte [r13], dl    ; Escribimos en el clon
    	cmp dl, 0                   ; ¿Copiamos el '\0'?
    	je .salgo

		inc r12
		inc r13
		jmp .ciclo
	.salgo:


	pop r13 
	pop r12
	pop rbp
	ret

; void strDelete(char* a)
strDelete:
	push rbp
	mov rbp,rsp
	call free
	pop rbp
	ret

; void strPrint(char* a, FILE* pFile)
strPrint:
	ret

; uint32_t strLen(char* a)
strLen:
	push rbp
	mov rbp,rsp
	;*a-> rdi
	;len -> rax
	mov rax,0
	.loop:
		cmp byte [rdi],0
		je .salgo

		inc rax
		inc rdi
		jmp .loop
	.salgo:
	pop rbp
	ret


;Que aprendi aca?
;MUCHAS cosas, la primera no complicarme de mas en algunas cosas como por ejemplo apra hacer el strcmp que pense en hacer 2 ciclos o cosas asi, 
;averiguar mas sobre la funcion que tengo que hacer
;depsues no puedo hacer un [] a [] y cuando uso un [] tengo que poner la cantidad de memoria que voy a usar(casi siempre)
;si lo uso tipo [rax] esto es completo completo
;En el clone por ejemplo esta bueno eso qeu hago de tener la direccion de memoria y esas cosas fidjarme donde la guardo, fijarme donde comparo tal cosa con tal otra y asi
