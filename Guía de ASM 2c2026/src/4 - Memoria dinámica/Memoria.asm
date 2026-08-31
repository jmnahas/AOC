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
	mov 
	pop rsi
	pop rdi
	; aca cmabio los paramteros
	.ciclo:
		
	; tengo a y b
	; max(a,b)
	; while a[i] != 0 :
	; if a[i]!=b[i]
	;	return -1
	; 
	add rsp,8
	pop r12
	pop rbp
	ret

; char* strClone(char* a)
strClone:
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


