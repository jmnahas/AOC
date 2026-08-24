extern sumar_c
extern restar_c
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS

global alternate_sum_4
global alternate_sum_4_using_c
global alternate_sum_4_using_c_alternative
global alternate_sum_8
global product_2_f
global product_9_f

;########### DEFINICION DE FUNCIONES
; uint32_t alternate_sum_4(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; parametros: 
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
alternate_sum_4:
  sub EDI, ESI
  add EDI, EDX
  sub EDI, ECX

  mov EAX, EDI
  ret

; uint32_t alternate_sum_4_using_c(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; parametros: 
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
alternate_sum_4_using_c:
  ;prologo
  push RBP ;pila alineada
  mov RBP, RSP ;strack frame armado
  push R12
  push R13	; preservo no volatiles, al ser 2 la pila queda alineada

  mov R12D, EDX ; guardo los parámetros x3 y x4 ya que están en registros volátiles
  mov R13D, ECX ; y tienen que sobrevivir al llamado a función

  call restar_c 
  ;recibe los parámetros por EDI y ESI, de acuerdo a la convención, y resulta que ya tenemos los valores en esos registros
  
  mov EDI, EAX ;tomamos el resultado del llamado anterior y lo pasamos como primer parámetro
  mov ESI, R12D
  call sumar_c

  mov EDI, EAX
  mov ESI, R13D
  call restar_c

  ;el resultado final ya está en EAX, así que no hay que hacer más nada

  ;epilogo
  pop R13 ;restauramos los registros no volátiles
  pop R12
  pop RBP ;pila desalineada, RBP restaurado, RSP apuntando a la dirección de retorno
  ret


alternate_sum_4_using_c_alternative:
  ;prologo
  push RBP ;pila alineada
  mov RBP, RSP ;strack frame armado
  sub RSP, 16 ; muevo el tope de la pila 8 bytes para guardar x4, y 8 bytes para que quede alineada

  mov [RBP-8], RCX ; guardo x4 en la pila

  push RDX  ;preservo x3 en la pila, desalineandola
  sub RSP, 8 ;alineo
  call restar_c 
  add RSP, 8 ;restauro tope
  pop RDX ;recupero x3
  
  mov EDI, EAX
  mov ESI, EDX
  call sumar_c

  mov EDI, EAX
  mov ESI, [RBP - 8] ;leo x4 de la pila
  call restar_c

  ;el resultado final ya está en EAX, así que no hay que hacer más nada

  ;epilogo
  add RSP, 16 ;restauro tope de pila
  pop RBP ;pila desalineada, RBP restaurado, RSP apuntando a la dirección de retorno
  ret


; uint32_t alternate_sum_8(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4, uint32_t x5, uint32_t x6, uint32_t x7, uint32_t x8);
; registros y pila:
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
; x5 --> E8
; x6 --> E9
; x7 --> [RBP+4]
; x8 --> [RBP+8]
alternate_sum_8:
  
  push rbp
  mov rbp, rsp
  ;prologo
  sub EDI, ESI
  add EDI,EDX
  sub EDI, ECX
  add EDI, r8d
  sub EDI,r9d
  add EDI,[RBP+16]
  sub EDI,[RBP+24]
  
  mov EAX, EDI

	;epilogo
  pop rbp
  ret 


;QUE APRENDI ACA: BAsicamente hay que acomodar la pila para poder hacer las cosas, despues el offset estaba mal calculado, pense que era +4 y +8 pero era mas.
;Por que? Prque en si pinto esa

; SUGERENCIA: investigar uso de instrucciones para convertir enteros a floats y viceversa
;void product_2_f(uint32_t * destination, uint32_t x1, float f1);
;registros: destination[?], x1[?], f1[?]
; destination --> RDI
; x1 --> ESI
; f1 --> XMM0
product_2_f:
  push rbp
  mov rbp, rsp
  ;prologo
  mov eax,esi

  cvtsi2ss xmm1, rax   ; Convierte el entero de 32 bits de ESI a float y lo guarda en XMM1
  mulss xmm0,xmm1
  cvttss2si eax,xmm0
  mov [rdi],eax  
  ;epilogo
  pop rbp
	ret


;extern void product_9_f(double * destination
;, uint32_t x1, float f1, uint32_t x2, float f2, uint32_t x3, float f3, uint32_t x4, float f4
;, uint32_t x5, float f5, uint32_t x6, float f6, uint32_t x7, float f7, uint32_t x8, float f8
;, uint32_t x9, float f9);
;registros y pila: destination[rdi], x1[?], f1[?], x2[?], f2[?], x3[?], f3[?], x4[?], f4[?]
;	, x5[?], f5[?], x6[?], f6[?], x7[?], f7[?], x8[?], f8[?],
;	, x9[?], f9[?]
;destination -->RDI
;x1 -->ESI
;x2 -->EDX
;x3 -->ECX
;x4 -->R8
;x5 -->R9
;x6 -->[RBP+16]
;x7 -->[RBP+24]
;x8 -->[RBP+32]
;x9 -->[RBP+40]
;f1 -->XMM0
;f2 -->XMM1
;f3 -->XMM2
;f4 -->XMM3
;f5 -->XMM4
;f6 -->XMM5
;f7 -->XMM6
;f8 -->XMM7
;f9 -->[RBP+48]

product_9_f:
	;prologo
	push rbp
	mov rbp, rsp

	;convertimos los flotantes de cada registro xmm en doubles
	; COMPLETAR
  CVTSS2SD xmm0,XMM0
  CVTSS2SD xmm1,xmm1
  CVTSS2SD xmm2,XMM2
  CVTSS2SD xmm3,XMM3
  CVTSS2SD XMM4,XMM4
  CVTSS2SD XMM5,XMM5
  CVTSS2SD XMM6,XMM6
  CVTSS2SD XMM7,XMM7
  movSS xmm8,[RBP+48]
  CVTSS2SD XMM8,xmm8
  
	;multiplicamos los doubles en xmm0 <- xmm0 * xmm1, xmmo * xmm2 , ...
	MULSD XMM0,xmm1
  MULSD xmm0,xmm2
  MULSD XMM0,xmm3
  MULSD XMM0,xmm4
  MULSD XMM0,xmm5
  MULSD XMM0,xmm6
  MULSD XMM0,xmm7
  MULSD XMM0,XMM8
  
  ; COMPLETAR

	; convertimos los enteros en doubles y los multiplicamos por xmm0.
  CVTSI2SD XMM2,ESI
  MULSD xmm1,xmm2
  CVTSI2SD XMM2,EDX
  MULSD xmm1,xmm2
  CVTSI2SD XMM2,ECX
  MULSD xmm1,xmm2
  CVTSI2SD XMM2,R8D
  MULSD xmm1,xmm2
  CVTSI2SD XMM2,R9D
  MULSD xmm1,xmm2
  CVTSI2SD XMM2,[RBP+16]
  MULSD xmm1,xmm2
  CVTSI2SD XMM2,[RBP+24]
  MULSD xmm1,xmm2
  CVTSI2SD XMM2,[RBP+32]
  MULSD xmm1,xmm2
  CVTSI2SD XMM2,[RBP+40]
  MULSD xmm1,xmm2
	; COMPLETAR
  
  movSD qword [rdi],xmm1
	; epilogo
	pop rbp
	ret

