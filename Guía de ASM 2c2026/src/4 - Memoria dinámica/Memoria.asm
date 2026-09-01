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
	mov rbp,rsp
	push R12
	sub rsp,8

	mov rax,0
	push rdi
	push rsi
	call strLen
	;rax tiene el strlen de a
	mov r12,rax
	pop rsi
	pop rdi
	; tengo a y b
	; si hay uno que tenga longitud mas grande quiere decir que no son iguales las cadenas
	mov rax,rsi
	mov rdi,rsi
	mov rsi,rax

	push rdi
	push rsi
	call strLen
	;rax tiene strlen de b
	pop rsi
	pop rdi
	;En RAX tengo strlen de b y en r12 tengo el strlen de a
	;si no son iguales ya se que se devuelve 0
	cmp r12,rax
	jne .fin
	;si llego hasta aca es porque tienen misma longitud
	.ciclo:
		; while a[i] != 0 :
		cmp byte [rdi],0
		je .finbueno
		; 	if a[i]!=b[i]
		cmp byte [rdi],byte [rsi]
		;	return -1
		jne .fin
		; si llega afuera del while devuelvo 1
		mov rax,1

		inc rdi
		inc rsi
		jmp .ciclo
	.fin:
		mov rax,0 
	.finbueno:
	
	add rsp,8
	pop r12
	pop rbp
	ret

; char* strClone(char* a)
strClone:
	push rbp
	mov rbp,rsp
	mov rax,rdi
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


